<%@page import="inventaire.InventaireLib"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="affichage.Liste"%>
<%@page import="magasin.Magasin"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@page import="user.UserEJB"%>
<%@ page import="prevision.Service" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="utils.ConstanteSavonnerie" %>
<%@ page import="magasin.DirectionMagasinLib" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{

    String[] etatVal = {"","1","11", "0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;(s)", "Vis&eacute;(s)", "Annul&eacute;(s)"};

    UserEJB u = (UserEJB) session.getValue("u");

    utilisateursocobis.UtilisateurStation user = new utilisateursocobis.UtilisateurStation();
    user.setTuppleId(u.getUser().getTuppleID());
    user = user.getUtilisateurByrefuser();
    String idDepartement = null;
    if(user.getService() != null) {
        idDepartement = user.getService().getDepartement();
    }

    InventaireLib inventaire = new InventaireLib();
    inventaire.setNomTable("INVENTAIRELIB");

    
    String listeCrt[] = {"id","daty", "heure","designation","idDepartement", "idMagasin", "remarque"};
    String listeInt[] = {"daty", "heure"};
    String libEntete[] = {"id","daty","heure","designation", "montantQuantite","idMagasinlib", "idDepartementLib","remarque","etatlib"};

    PageRecherche pr = new PageRecherche(inventaire, request, listeCrt, listeInt, 3, libEntete, libEntete.length);

    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat=" + request.getParameter("etat"));
    }

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

    pr.setTitre("Liste des inventaires");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("inventaire/inventaire-liste.jsp");
    pr.getFormu().changerEnChamp(dropDowns);
    pr.getFormu().getChamp("id").setLibelle("Ref");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("heure1").setLibelle("Heure Min");
    pr.getFormu().getChamp("heure2").setLibelle("Heure Max");
    pr.getFormu().getChamp("heure1").setType("time");
    pr.getFormu().getChamp("heure2").setType("time");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] idAttributsLienTab = {"daty1", "idDepartement"};
    String[] valAttributsLienTab = {pr.getFormu().getChamp("daty1").getValeur(), pr.getFormu().getChamp("idDepartement").getValeur()};

    Map<String,String> lienTab=new HashMap();
    lienTab.put("viser", pr.getLien() +"?but=apresTarif.jsp&acte=valider&bute=inventaire/inventaire-liste.jsp&classe=inventaire.Inventaire&rajoutLien="+ Utilitaire.ajouterParam(idAttributsLienTab, valAttributsLienTab));
    lienTab.put("modifier",pr.getLien() + "?but=inventaire/inventaire-saisie.jsp&acte=update");
    lienTab.put("dupliquer", pr.getLien() + "?but=inventaire/inventaire-saisie.jsp&acte=dupliquer");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=inventaire/inventaire-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Ref","Date","Heure","D&eacute;signation","Valeur Quantit&eacute;", "Magasin", "D&eacute;partement","Remarque","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=inventaire/inventaire-saisie.jsp&currentMenu=MNDN000000026\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un inventaire</a>"
    );
    pr.getTableau().setLienFille("inventaire/inventairefille-liste.jsp&id=");

%>
<script>
  function changerDesignation() {
    document.formetat.submit();
  }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post"  name="formetat" id="formetat">
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



