<%@page import="affichage.PageRecherche"%>
<%@ page import="maintenance.ressources.IngredientMaintenance" %>
<%@ page import="maintenance.ressources.InfosAuto" %>

<% try{
    InfosAuto t = new InfosAuto();
    String listeCrt[] = {"id","description","immatriculation","numero","marque","modele"};
    String listeInt[] = {};
    String libEntete[] = {"id","description","immatriculation","numero","marque","modele"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des autos");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("maintenance/ressources/auto/auto-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("description").setLibelle("Description");
    pr.getFormu().getChamp("numero").setLibelle("Num&eacute;ro");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=maintenance/ressources/auto/auto-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID", "Description", "Immatriculation","Num&eacute;ro","Marques","Mod&egrave;le"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=maintenance/ressources/auto/auto-saisie.jsp&currentMenu=MENDYNA1764608667292943\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir un automatisme" +
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




