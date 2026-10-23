<%@page import="stock.MvtStockLib"%>
<%@page import="stock.MvtStock"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="affichage.Liste"%>
<%@page import="stock.TypeMvtStock"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@page import="user.UserEJB"%>
<%@ page import="bean.TypeObjet" %>
<%@ page import="prevision.Service" %>
<%@ page import="utilisateur.Utilisateur" %>
<%@ page import="utils.ConstanteSavonnerie" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="magasin.DirectionMagasinLib" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{

    String[] etatVal = {"","1","11", "0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;(s)", "Valid&eacute;(s)", "Annul&eacute;(s)"};

    UserEJB u = (UserEJB) session.getValue("u");

    utilisateursocobis.UtilisateurStation user = new utilisateursocobis.UtilisateurStation();
    user.setTuppleId(u.getUser().getTuppleID());

    user = user.getUtilisateurByrefuser();
    String idDepartement = null;
    if(user.getService() != null) {
        idDepartement = user.getService().getDepartement();
    }

    MvtStockLib stock = new MvtStockLib();
    stock.setNomTable("mvtstocklib");


    String listeCrt[] = {"id", "daty","designation","idDepartement", "idMagasin", "idCategorieStock", "idTypeMvStock"};
    String listeInt[] = {"daty"};
    String libEntete[] = {
            "id",
            "daty",
            "designation",
            "idMagasinlib",
            "idDepartementLib",
            "idCategorieStockLib",
            "idTypeMvStocklib",
            "idVentelib",
            "idTransfertlib",
            "montantEntree",
            "montantSortie",
            "etatlib"
    };
    PageRecherche pr = new PageRecherche(stock, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des mouvements de stocks");

    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat=" + request.getParameter("etat"));
    }


    Liste[] dropDowns = null;


    if (ConstanteSavonnerie.DEPARTEMENT_DG.equalsIgnoreCase(idDepartement) || idDepartement == null){
        dropDowns = new Liste[4];
        dropDowns[0] = new Liste( "idMagasin", new DirectionMagasinLib(), "idMagasinLib" , "idMagasin" );
        dropDowns[1] = new Liste( "idTypeMvStock", new TypeMvtStock(), "val" , "id" );
        TypeObjet dep = new TypeObjet("DEPARTEMENT");
        dropDowns[2] = new Liste( "idDepartement", dep, "val", "id");
        dropDowns[2].setDefaut(idDepartement);
        dropDowns[0].setApresW(" AND idDirection = '" + idDepartement + "'");
        dropDowns[2].setDeroulanteDependante(dropDowns[0], "idDirection", "onchange");
        TypeObjet categorie = new TypeObjet();
        categorie.setNomTable("categorieStock");
        dropDowns[3] = new Liste("idCategorieStock",categorie,"val","id");

    } else if (idDepartement != null && !idDepartement.isEmpty())
    {
        dropDowns = new Liste[3];
        dropDowns[0] = new Liste( "idMagasin",  new DirectionMagasinLib(), "idMagasinLib" , "idMagasin" );
        dropDowns[1] = new Liste( "idTypeMvStock", new TypeMvtStock(), "val" , "id" );
        dropDowns[0].setApresW(" AND idDirection = '" + idDepartement + "'");
        pr.getFormu().getChamp("idDepartement").setAutre("readonly");
        pr.getFormu().getChamp("idDepartement").setDefaut(idDepartement);
        TypeObjet categorie = new TypeObjet();
        categorie.setNomTable("categorieStock");
        dropDowns[2] = new Liste("idCategorieStock",categorie,"val","id");

    }


    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/mvtstock-liste.jsp");
    pr.getFormu().changerEnChamp(dropDowns);
    pr.getFormu().getChamp("id").setLibelle("Ref");
    pr.getFormu().getChamp("idCategorieStock").setLibelle("Cat&eacute;gorie de Stock");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement");
    pr.getFormu().getChamp("idTypeMvStock").setLibelle("Type de mouvement de stock");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);


    String[] idAttributsLienTab = {"daty1", "idDepartement"};
    String[] valAttributsLienTab = {pr.getFormu().getChamp("daty1").getValeur(), pr.getFormu().getChamp("idDepartement").getValeur()};

    Map<String,String> lienTab=new HashMap();
    lienTab.put("viser", pr.getLien() +"?but=apresTarif.jsp&acte=valider&bute=stock/mvtstock-liste.jsp&classe=stock.MvtStock&rajoutLien="+ Utilitaire.ajouterParam(idAttributsLienTab, valAttributsLienTab));
    lienTab.put("modifier",pr.getLien() + "?but=stock/mvtstock-saisie.jsp&acte=update");
    lienTab.put("dupliquer", pr.getLien() + "?but=stock/mvtstock-saisie.jsp&acte=dupliquer");
    pr.getTableau().setLienClicDroite(lienTab);
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=stock/mvtstock-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {
            "Ref",
            "Date",
            "D&eacute;signation",
            "Magasin",
            "D&eacute;partement",
            "Cat&eacute;gorie de Stock",
            "Type de mouvement de stock",
            "Vente",
            "Transfert",
            "Montant Entr&eacute;e",
            "Montant Sortie",
            "&Eacute;tat"
    };
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("stock/mvtfille-liste.jsp&id=");
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=stock/mvtstock-saisie.jsp&currentMenu=MNDN000000024\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un mouvement de stock</a>");
%>
<script>
    function changerDesignation() {
        document.getElementById("mvtStock").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="mvtStock" id="mvtStock">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row">
                <div class="col-md-12" style="margin-top: 10px;">
                    <div class="col-md-2 nopadding">
                        <label>&Eacute;tat : </label>
                        <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                            <%
                                for( int i = 0; i < etatAff.length; i++ ){ %>
                            <% if(request.getParameter("etat") !=null && request.getParameter("etat").compareToIgnoreCase(etatVal[i]) == 0) {%>
                            <option value="<%= etatVal[i] %>" selected> <%= etatAff[i] %> </option>
                            <% } else { %>
                            <option value="<%= etatVal[i] %>"> <%= etatAff[i] %> </option>
                            <% } %>
                            <%    }
                            %>
                        </select>
                    </div>
                </div>
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



