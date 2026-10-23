<%@page import="stock.*"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="bean.*"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@ page import="fabrication.*" %>
<%@page import="charge.*"%>

<%
    try {
        UserEJB u = u = (UserEJB) session.getValue("u");
        int taille = 10;
        String idFab = request.getParameter("id");
        String classeMere = "fabrication.Fabrication",
                classeFille = "charge.Charge",
                titre = "Saisie des charges multiples",
                redirection = "fabrication/fabrication-fiche.jsp&id="+idFab+"&tab=inc/fabrication-charge";
        String colonneMere = "idfabrication";

        // Mere et fille
        Fabrication mere = new Fabrication();
        mere.setNomTable("FABRICATION");
        mere.setId(idFab);
        Charge fille = new Charge();
        fille.setNomTable("CHARGE");

        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
        pi.setLien((String) session.getValue("lien"));

        if (idFab != null && !idFab.isEmpty()) {
            affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("idFabrication").getListeChamp(),"readonly");
            affichage.Champ.setDefaut(pi.getFormufle().getChampMulitple("idFabrication").getListeChamp(),idFab);
        }

        String[] colOrdre = {"daty","libelle","idIngredients","pu","qte","type","idFabrication"};
        pi.getFormufle().setColOrdre(colOrdre);

        Liste[] liste = new Liste[1];
        TypeObjet typeC = new TypeObjet();
        typeC.setNomTable("typecharge");
        liste[0] = new Liste("type", typeC, "val", "id");
        pi.getFormufle().changerEnChamp(liste);
        affichage.Champ.setDefaut(pi.getFormufle().getChampMulitple("type").getListeChamp(),"1");

        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idIngredients"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTO","pu","pu");
        pi.getFormufle().getChamp("daty_0").setLibelle("Date");
        pi.getFormufle().getChamp("libelle_0").setLibelle("D&eacute;scription");
        pi.getFormufle().getChamp("idFabrication_0").setLibelle("Fabrication");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix Unitaire");
        pi.getFormufle().getChamp("type_0").setLibelle("Type");
        pi.getFormufle().getChamp("idIngredients_0").setLibelle("Ingr&eacute;dients");

        Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("etat"),false);

        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<div class="content-wrapper">
    <h1><%=titre%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <div id="butfillejsp">
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
        </div>
        <input name="acte" type="hidden" id="nature" value="insertfille">
        <input name="bute" type="hidden" id="bute" value="<%=redirection%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomtable" value="charge">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
        <input name="idMere" type="hidden" id="idMere" value="<%= idFab %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= taille %>">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
