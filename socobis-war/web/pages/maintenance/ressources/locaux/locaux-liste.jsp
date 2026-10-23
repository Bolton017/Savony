<%--
    Document   : client-liste
    Created on : 22 mars 2024, 14:50:31
    Author     : SAFIDY
--%>

<%@page import="affichage.PageRecherche"%>
<%@ page import="maintenance.ressources.IngredientMaintenance" %>
<%@ page import="maintenance.utils.ConstanteMaintenance" %>

<% try{
    IngredientMaintenance t = new IngredientMaintenance();
    String listeCrt[] = {"id","libelle","localisationObjet"};
    String listeInt[] = {};
    String libEntete[] = {"id","libelle","localisationObjet"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des locaux");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("maintenance/ressources/locaux/locaux-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("libelle").setLibelle("Nom du Local ");
    pr.getFormu().getChamp("localisationObjet").setLibelle("Adresse");
    String apreswhere=" AND IDENTITE='"+ ConstanteMaintenance.ENTITE_LOCAUX +"'";
    pr.setAWhere(apreswhere);
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=maintenance/ressources/locaux/locaux-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID", "Nom du Local", "Adresse"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=maintenance/ressources/locaux/locaux-saisie.jsp&currentMenu=MENDYN1764610006403774\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir un local" +
            "                </a>"
    );

%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
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
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>




