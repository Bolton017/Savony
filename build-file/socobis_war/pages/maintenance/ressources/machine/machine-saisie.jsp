<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="maintenance.configuration.Entite" %>
<%@ page import="maintenance.ressources.IngredientMaintenance" %>
<%@ page import="maintenance.utils.ConstanteMaintenance" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>

<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "maintenance.ressources.IngredientMaintenance",
                nomtable = "AS_INGREDIENT_MAINTENANCE",
                apres = "maintenance/ressources/machine/machine-fiche.jsp",
                titre = "Saisie d'une machine";
        if (request.getParameter("acte")!=null && request.getParameter("acte").equals("update")){
            titre = "Modification d'une machine";
        }
        IngredientMaintenance categorie = new IngredientMaintenance();
        PageInsert pi = new PageInsert(categorie, request, u);
        pi.setLien((String) session.getValue("lien"));

        Liste[] liste = new Liste[4];
        TypeObjet c = new TypeObjet();
        c.setNomTable("QUALITESOBJETMAINTENANCE");
        liste[0] = new Liste("qualiteObjet",c,"val","id");

        TypeObjet c2 = new TypeObjet();
        c2.setNomTable("ETATOBJETMAINTENANCE");
        liste[1] = new Liste("etatObjet",c2,"val","id");

        TypeObjet c3 = new TypeObjet();
        c3.setNomTable("LOG_DEPARTEMENT");
        liste[2] = new Liste("localisationObjet",c3,"val","id");

        TypeObjet c4 = new TypeObjet();
        c4.setNomTable("LIGNE");
        liste[3] = new Liste("idLigne",c4,"val","id");

        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("libelle").setLibelle("Libell&eacute;");
        pi.getFormu().getChamp("idEntite").setDefaut(ConstanteMaintenance.ENTITE_MACHINE);
        pi.getFormu().getChamp("idEntite").setVisible(false);
        pi.getFormu().getChamp("referenceObjet").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormu().getChamp("referenceObjet").setVisible(false);
        pi.getFormu().getChamp("marqueObjet").setLibelle("Marque");
        pi.getFormu().getChamp("modeleObjet").setLibelle("Mod&egrave;le");
        pi.getFormu().getChamp("numeroSerieObjet").setLibelle("Num&eacute;ro de s&eacute;rie");
        pi.getFormu().getChamp("descriptionObjet").setLibelle("Description");
        pi.getFormu().getChamp("pu").setLibelle("Prix unitaire");
        pi.getFormu().getChamp("idLigne").setLibelle("Ligne");

        pi.getFormu().getChamp("qualiteObjet").setLibelle("Qualit&eacute;");
        pi.getFormu().getChamp("etatObjet").setLibelle("&Eacute;tat de la machine");
        pi.getFormu().getChamp("localisationObjet").setLibelle("Locaux"); 
        pi.getFormu().getChamp("puissanceObjet").setLibelle("Puissance");
        pi.getFormu().getChamp("puissanceObjet").setVisible(false); 
        pi.getFormu().getChamp("observationObjet").setLibelle("Caract&eacute;ristique"); 
        pi.getFormu().getChamp("estEngin").setDefaut("0");
        pi.getFormu().getChamp("estEngin").setVisible(false);
        pi.getFormu().getChamp("typeRattachement").setVisible(false);
        pi.getFormu().getChamp("idIngredient").setVisible(false);

        pi.getFormu().getChamp("dateAquisition").setLibelle("Date d'acquisition");

        String[] ordre = {"dateAquisition","referenceObjet", "libelle","marqueObjet","modeleObjet","numeroSerieObjet",
                "descriptionObjet", "qualiteObjet", "etatObjet", "localisationObjet","puissanceObjet",
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
