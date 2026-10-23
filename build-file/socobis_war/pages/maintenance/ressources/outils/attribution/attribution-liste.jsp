<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="maintenance.configuration.AttributionElementLib" %>
<%@ page import="personnel.Personnel" %>

<% try{
    AttributionElementLib t = new AttributionElementLib();
    String[] listeCrt = {"id", "daty","idPersonnel","idIngredientMaintenanceLib","typeAttribution"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id", "idIngredientMaintenanceLib","idPersonnelLib","typeAttributionLib","daty","qte","qualiteObjetMaintenanceLib","etatLib"};
    String[] libEnteteAffiche = {"ID", "&Eacute;l&eacute;ment", "Attribu&eacute; &agrave","&Eacute;tat de l'attribution","date du mouvement","Quantit&eacute;","Qualit&eacute; de l'&eacute;l&eacute;ment","&Eacute;tat"};

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des attributions d'&eacute;l&eacute;ment");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("maintenance/ressources/outils/attribution/attribution-liste.jsp");

    Liste[] liste = new Liste[2];

    Personnel personnel = new Personnel();
    liste[0] = new Liste("idPersonnel", personnel, "nom", "id");

    String [] val = new String[]{"0","1"};
    String [] aff = new String[]{"Sortie","Retour"};
    liste[1] = new Liste("typeAttribution",aff,val);

    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idPersonnel").setLibelle("Personnel attribu&eacute;");
    pr.getFormu().getChamp("idIngredientMaintenanceLib").setLibelle("&Eacute;l&eacute;ment");
    pr.getFormu().getChamp("typeAttribution").setLibelle("&Eacute;tat de l'attribution");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    //Definition des lienTableau et des colonnes de lien
    String[] lienTableau = {pr.getLien() + "?but=maintenance/ressources/outils/attribution/attribution-fiche.jsp"};
    String[] colonneLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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



