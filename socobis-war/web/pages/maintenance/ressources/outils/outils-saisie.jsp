<%--
    Created by IntelliJ IDEA.
  User: nomenjanhary ramarokoto
  Date: 01/12/2025
  Time: 22:28
  To change this template use File | Settings | File Templates.
--%>

<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="maintenance.configuration.Entite" %>
<%@ page import="maintenance.ressources.IngredientMaintenance" %>
<%@ page import="maintenance.utils.ConstanteMaintenance" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>

<%
    try{
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "maintenance.ressources.IngredientMaintenance",
                nomtable = "AS_INGREDIENT_MAINTENANCE",
                apres = "maintenance/ressources/outils/outils-fiche.jsp",
                titre = "Saisie d'un outil";
        if (request.getParameter("acte")!=null && request.getParameter("acte").equals("update")){
            titre = "Modification d'un outil";
        }
        IngredientMaintenance outils = new IngredientMaintenance();
        PageInsert pi = new PageInsert(outils, request, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("libelle").setLibelle("Libell&eacute;");
        pi.getFormu().getChamp("idEntite").setDefaut(ConstanteMaintenance.ENTITE_OUTILS);
        pi.getFormu().getChamp("referenceObjet").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormu().getChamp("idEntite").setVisible(false);
        pi.getFormu().getChamp("referenceObjet").setVisible(false);
        pi.getFormu().getChamp("dateAquisition").setVisible(false);
        pi.getFormu().getChamp("idLigne").setVisible(false);
        pi.getFormu().getChamp("marqueObjet").setLibelle("Marque");
        pi.getFormu().getChamp("modeleObjet").setLibelle("Mod&egrave;le");
        pi.getFormu().getChamp("numeroSerieObjet").setLibelle("Num&eacute;ro de s&eacute;rie");
        pi.getFormu().getChamp("descriptionObjet").setLibelle("Description");
        pi.getFormu().getChamp("pu").setLibelle("Prix unitaire");

        Liste[] liste = new Liste[2];

        TypeObjet qlt = new TypeObjet();
        qlt.setNomTable("QUALITESOBJETMAINTENANCE");
        liste[0] = new Liste("qualiteObjet", qlt, "val", "id");

        TypeObjet etat = new TypeObjet();
        etat.setNomTable("ETATOBJETMAINTENANCE");
        liste[1] = new Liste("etatObjet", etat, "val", "id");

        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("qualiteObjet").setLibelle("Qualit&eacute;");
        pi.getFormu().getChamp("etatObjet").setLibelle("&Eacute;tat de l'outil");
        pi.getFormu().getChamp("localisationObjet").setVisible(false);
        pi.getFormu().getChamp("puissanceObjet").setLibelle("Puissance");
        pi.getFormu().getChamp("observationObjet").setLibelle("Caracteristique");
        pi.getFormu().getChamp("estEngin").setDefaut("0");
        pi.getFormu().getChamp("estEngin").setVisible(false);
        pi.getFormu().getChamp("typeRattachement").setVisible(false);
        pi.getFormu().getChamp("idIngredient").setVisible(false);
        pi.getFormu().getChamp("puissanceObjet").setVisible(false);
        String[] ordre = {"id","referenceObjet", "libelle","marqueObjet","modeleObjet","numeroSerieObjet",
        "descriptionObjet", "qualiteObjet", "etatObjet", "localisationObjet",
        "observationObjet","estEngin"};
        pi.getFormu().setOrdre(ordre);
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
