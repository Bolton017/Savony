<%@page import="stock.*"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="affichage.Liste"%>
<%@page import="stock.TypeMvtStock"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@page import="user.UserEJB"%>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="prevision.Service" %>
<%@ page import="utils.ConstanteStation" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="utils.ConstanteSavonnerie" %>
<%@ page import="magasin.DirectionMagasinLib" %>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");

    utilisateursocobis.UtilisateurStation user = new utilisateursocobis.UtilisateurStation();
    user.setTuppleId(u.getUser().getTuppleID());

    user = user.getUtilisateurByrefuser();
    String idDepartement = null;
    if(user.getService() != null) {
        idDepartement = user.getService().getDepartement();
    }

    MvtStockFilleLib stock = new MvtStockFilleLib();
    stock.setNomTable("mvtstockfillelib");

    String [] val = new String[]{"%","1","11", ConstanteStation.TYPEMVTSTOCKINVENTAIRE};
    String [] aff = new String[]{"Tous","Cr&eacute;&eacute;(s)","Vis&eacute;(s)","ecart inventaire"};

    String listeCrt[] = {"id","idMvtStock","dateSql","idProduit","idProduitlib","idDepartement","idMagasin", "mvtsrc"};
    String listeInt[] = {"dateSql"};
    String libEntete[] = {"id","idMvtStock","daty","idProduit","idProduitlib","idMagasinLib","idDepartementLib","entree","sortie","pu","montant","mvtsrc","etatLib"};

    PageRecherche pr = new PageRecherche(stock, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des mouvements du stock fille");

    Liste[] dropDowns = null;

    if (ConstanteSavonnerie.DEPARTEMENT_DG.equalsIgnoreCase(idDepartement) || idDepartement == null)
    {
        dropDowns = new Liste[2];
        dropDowns[0] = new Liste( "idMagasin", new DirectionMagasinLib(), "idMagasinLib" , "idMagasin" );
        dropDowns[0].setApresW(" AND idDirection = '" + idDepartement + "'");
        TypeObjet dep = new TypeObjet("DEPARTEMENT");
        dropDowns[1] = new Liste( "idDepartement", dep, "val", "id");
        dropDowns[1].setDeroulanteDependante(dropDowns[0], "idDirection", "onchange");
        dropDowns[1].setDefaut(idDepartement);

    }
    else if (idDepartement != null && !idDepartement.isEmpty())
    {
        dropDowns = new Liste[1];
        dropDowns[0] = new Liste( "idMagasin",  new DirectionMagasinLib(), "idMagasinLib" , "idMagasin" );
        dropDowns[0].setApresW(" AND idDirection = '" + idDepartement + "'");
        pr.getFormu().getChamp("idDepartement").setAutre("readonly");
        pr.getFormu().getChamp("idDepartement").setDefaut(idDepartement);

    }

//    Liste[] dropDowns = new Liste[2];
//    dropDowns[0] = new Liste( "idMagasin", new Magasin(), "val" , "id" );
//    dropDowns[1] = new Liste( "iddepartement", new Service(), "val" , "id" );

    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/mvtstockfille-liste.jsp");
    pr.getFormu().changerEnChamp(dropDowns);
    pr.getFormu().getChamp("id").setLibelle("Ref");
    pr.getFormu().getChamp("idProduitlib").setLibelle("Produit");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("idProduit").setLibelle("Ref Produit");
    pr.getFormu().getChamp("idMvtStock").setLibelle("Ref Mouvement de Stock");
    pr.getFormu().getChamp("dateSql1").setLibelle("Date min");
    pr.getFormu().getChamp("dateSql1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("dateSql2").setLibelle("Date max");
    pr.getFormu().getChamp("mvtsrc").setLibelle("Mouvement source");
    pr.getFormu().getChamp("dateSql2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement");

//    String awhere ="";
//    if(user.getIddepartement() != null) {
//        awhere += "and iddepartement = '" + user.getIddepartement() + "'";
//        pr.getFormu().getChamp("iddepartement").setDefaut(user.getIddepartement());
//        pr.getFormu().getChamp("iddepartement").setAutre("readonly onclick=\"return false\" style=\"pointer-events:none;\"");
//    }
//    pr.setAWhere(pr.getAWhere()+awhere);

    if(request.getParameter("invdaty") != null&&request.getParameter("invdaty").compareToIgnoreCase("")!=0&&request.getParameter("invdaty").compareToIgnoreCase("null")!=0) {
        if (request.getParameter("invdaty").contains("-")) {
            String formatDate =  Utilitaire.formatterDaty(request.getParameter("invdaty"));
            pr.getFormu().getChamp("dateSql1").setDefaut(formatDate);
        } else {
            pr.getFormu().getChamp("dateSql1").setDefaut(request.getParameter("invdaty"));
        }
    } else if(request.getParameter("clicStock")!=null&&request.getParameter("clicStock").compareToIgnoreCase("")!=0) {
        pr.getFormu().getChamp("dateSql1").setDefaut(Utilitaire.getDebutAnnee(String.valueOf(Utilitaire.stringToInt(Utilitaire.getAnneeEnCours())-1)));
    }
    String clickStockEntree = request.getParameter("clickStockEntree");
    if (!Utilitaire.champNull(clickStockEntree).isEmpty()) {
        pr.setAWhere(" AND etat = 11 AND (id = '"+clickStockEntree+"' or mvtsrc = '"+clickStockEntree+"')");
    }

    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        if (request.getParameter("etat").equalsIgnoreCase("%")){
            pr.setAWhere(pr.getAWhere() + " ");
        }else if(request.getParameter("etat").equalsIgnoreCase(ConstanteStation.TYPEMVTSTOCKINVENTAIRE)){
            pr.setAWhere(pr.getAWhere() + " and IDTYPEMVSTOCK='" + request.getParameter("etat")+" '");
        }
        else {
            pr.setAWhere(pr.getAWhere() + " and etat=" + request.getParameter("etat")+" ");
        }
    }


    String[] colSomme = {"entree","sortie"};
    pr.creerObjetPage(libEntete, colSomme);
    String[] libelleSomme = {"","Nombre","Somme des entr&eacute;es","somme des sorties"};
    pr.getTableauRecap().setLibeEntete(libelleSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=stock/mvtstock-fiche.jsp", pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"idmvtstock","idProduit"};
    String attributLien[] = {"id","id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Ref","Ref Mouvement de Stock","Date","Ref Produit","Produit","Magasin","d&eacute;partement","Entr&eacute;e","Sortie","Prix unitaire","Montant","Mouvement source", "&Eacute;tat"};

    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>
<script>
    function changerDesignation() {
        document.comptelec.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="comptelec">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12">
                <div class="col-md-4">
                    &Eacute;tat :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                        <% for( int i = 0; i < aff.length; i++ ){ %>
                        <% if(request.getParameter("etat") !=null && request.getParameter("etat").compareToIgnoreCase(val[i]) == 0) {%>
                        <option value="<%= val[i] %>" selected> <%= aff[i] %> </option>
                        <% } else { %>
                        <option value="<%= val[i] %>"> <%= aff[i] %> </option>
                        <% } %>
                        <%    }
                        %>
                    </select>
                </div>
                <div class="col-md-4"></div>
            </div>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<script>
    var tousOption = document.querySelector('#idDepartement option[value="%"]');
    if (tousOption) {
        tousOption.remove();
    }
</script>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



