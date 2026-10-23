
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="maintenance.ressources.DepartementMaintenance" %>
<%@ page import="maintenance.ressources.IngredientMaintenance" %>
<%@ page import="maintenance.utils.ConstanteMaintenance" %>

<%
    try{
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "maintenance.ressources.IngredientMaintenance",
                nomtable = "AS_INGREDIENT_MAINTENANCE",
                apres = "maintenance/ressources/locaux/locaux-fiche.jsp",
                titre = "Saisie d'un nouveau Locaux";

        if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update")) {
            titre = "Modification d'un locaux";
        }

        IngredientMaintenance client = new IngredientMaintenance();
        PageInsert pi = new PageInsert(client, request, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("libelle").setLibelle("Nom du Local ");
        pi.getFormu().getChamp("localisationObjet").setLibelle("Adresse");
        pi.getFormu().getChamp("pu").setLibelle("Prix Unitaire");

        pi.getFormu().getChamp("idEntite").setDefaut(ConstanteMaintenance.ENTITE_LOCAUX);
        pi.getFormu().getChamp("idEntite").setVisible(false);
        pi.getFormu().getChamp("referenceObjet").setVisible(false);
        pi.getFormu().getChamp("marqueObjet").setVisible(false);
        pi.getFormu().getChamp("modeleObjet").setVisible(false);
        pi.getFormu().getChamp("descriptionObjet").setVisible(false);
        pi.getFormu().getChamp("numeroSerieObjet").setVisible(false);
        pi.getFormu().getChamp("descriptionObjet").setVisible(false);
        pi.getFormu().getChamp("qualiteObjet").setVisible(false);
        pi.getFormu().getChamp("etatObjet").setVisible(false);
        pi.getFormu().getChamp("puissanceObjet").setVisible(false);
        pi.getFormu().getChamp("observationObjet").setVisible(false);
        pi.getFormu().getChamp("typeRattachement").setVisible(false);
        pi.getFormu().getChamp("idIngredient").setVisible(false);
        pi.getFormu().getChamp("estEngin").setVisible(false);
        pi.getFormu().getChamp("dateAquisition").setVisible(false);
        pi.getFormu().getChamp("idLigne").setVisible(false);


        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>
