<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="besoin.BesoinFabrication" %>
<%@ page import="besoin.BesoinFabricationDetailsCPL" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@page import="utils.ConstanteSocobis"%>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "besoin.BesoinFabrication";
    String classeFille = "besoin.BesoinFabricationDetails";
    String nomTableFille = "BESOINFABRICATIONDETAILS";
    String colonneMere = "idbesoinfabrication";
    String apres = "besoin/besoinFabrication-fiche.jsp";

    BesoinFabrication mere = new BesoinFabrication();
    mere.setNomTable("BESOINFABRICATION");
    BesoinFabricationDetailsCPL fille = new BesoinFabricationDetailsCPL();
    fille.setNomTable("BESOINFABRICATIONDETAILSCPL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie des besoins de fabrication");

    //affichage.Liste[] listes = new affichage.Liste[1];
    //String[] mois = {"Janvier","F&eacute;vrier","Mars","Avril","Mais","Juin","A&ocirc;ut","Septembre","Octobre","Novembre","D&eacute;cembre"};
    //int[] moisVal = {1,2,3,4,5,6,7,8,9,10,11,12};

    //listes[0] = new Liste("mois");
    //listes[0].ajouterValeur(new String[]{(moisVal).toString()},mois);
    //pi.getFormu().changerEnChamp(listes);

    affichage.Champ[] liste = new Champ[1];
    Liste mois = new Liste("mois");
    mois.makeListeMois();
    liste[0] = mois;
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("mois").setLibelle("Mois");
    pi.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
    pi.getFormu().getChamp("annee").setDefaut("2026");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");


    pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
    pi.getFormufle().getChamp("idProduitLib_0").setLibelle("D&eacute;signation");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("unite_0").setLibelle("Unit&eacute;");
    pi.getFormufle().getChamp("uniteLib_0").setLibelle("Unit&eacute;");
    for (int i = 0; i < taille ; i++) {
        pi.getFormufle().getChamp("unite_"+i).setVisible(false);
        pi.getFormufle().getChamp("uniteLib_"+i).setAutre("readonly");
    }
    Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id;unite","AS_INGREDIENTS_LIB","id;unite;libelle;uniteLib","idProduit;unite;idProduitLib;uniteLib"," and idcategorie  ='"+ConstanteSocobis.CATEGORIE_PRODUIT_FINI+"'");

    String[] colOrdre = {"idProduit","idProduitLib","qte","unite","uniteLib"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification des besoins de fabrication");
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

