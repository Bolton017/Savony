<%--
    Document   : client-liste
    Created on : 22 mars 2024, 14:50:31
    Author     : SAFIDY
--%>

<%@page import="client.Client"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="maintenance.ressources.DepartementMaintenance" %>

<% try{
    DepartementMaintenance t = new DepartementMaintenance();
    String listeCrt[] = {"id","val"};
    String listeInt[] = {};
    String libEntete[] = {"id","val","desce"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des D&eacute;partement");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("maintenance/ressources/personnel/departement-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("val").setLibelle("D&eacute;partement");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=maintenance/ressources/personnel/departement-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID", "D&eacute;partement", "Description"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=maintenance/ressources/personnel/departement-saisie.jsp&currentMenu=MENDYN1764572290177749\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir un d&eacute;partement de maintenance" +
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




