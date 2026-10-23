<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="calculBesoin.CalculBesoin" %>
<%@ page import="calculBesoin.CalculBesoinFille" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "calculBesoin.CalculBesoin";
    String classeFille = "calculBesoin.CalculBesoinFille";
    String nomTableFille = "CALCULBESOINFILLE";
    String colonneMere = "idMere";
    String apres = "calculBesoin/calculBesoin-fiche.jsp";

    CalculBesoin mere = new CalculBesoin();
    mere.setNomTable("CALCULBESOIN");
    CalculBesoinFille fille = new CalculBesoinFille();
    fille.setNomTable("CALCULBESOINFILLE");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie d'un calcul de besoin");

    Liste[] listes = new Liste[1];
    listes[0] = new Liste("idMagasin", new magasin.Magasin(), "val", "id");


    pi.getFormu().changerEnChamp(listes);
    pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
//    pi.getFormu().getChamp("idMagasin").setAutre("onchange=\"updateFille(event, 'formId')\"");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("etat").setVisible(false);

    pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idMere").getListeChamp(),false);
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","PRODUIT_FINI_ACTIF","","");

    String[] colOrdre = {"idProduit","qte"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un calcul de besoin");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomtable" value=<%=nomTableFille%>>
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

