<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.Ingredients" %>
<%@ page import="utils.ConstanteSavonnerie" %>
<%
    try{

        Ingredients a = new Ingredients();
        String nomTable = "as_ingredients";
        UserEJB u =(user.UserEJB) session.getValue("u");
        PageInsert pi = new PageInsert(a, request,u );
        String lien = (String) session.getValue("lien");
        pi.setLien(lien);
        String mapping = "produits.Ingredients";

        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("libelle").setLibelle("Immatriculation");
        pi.getFormu().getChamp("unite").setDefaut("UNT00005");
        pi.getFormu().getChamp("unite").setVisible(false);
        pi.getFormu().getChamp("pu").setDefaut("1");
        pi.getFormu().getChamp("compte_ristourne").setLibelle("Compte de ristourne");
        pi.getFormu().getChamp("codebarre").setLibelle("Code-barre");
        pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormu().getChamp("pvgros").setLibelle("Prix de vente gros");
        pi.getFormu().getChamp("categorieIngredient").setDefaut(ConstanteSavonnerie.VEHICULE_ID_CATEGORIEINGREDIENT);
        pi.getFormu().getChamp("compte_vente").setDefaut("72004");
        pi.getFormu().getChamp("compte_vente").setVisible(false);
        pi.getFormu().getChamp("compte_achat").setDefaut("62004");
        pi.getFormu().getChamp("compte_achat").setVisible(false);
        pi.getFormu().getChamp("pu").setVisible(false);
        pi.getFormu().getChamp("categorieIngredient").setVisible(false);
         pi.getFormu().getChamp("seuil").setVisible(false);
        pi.getFormu().getChamp("quantiteParPack").setVisible(false);
        pi.getFormu().getChamp("actif").setVisible(false);
        pi.getFormu().getChamp("photo").setVisible(false);
        pi.getFormu().getChamp("calorie").setVisible(false);
        pi.getFormu().getChamp("compose").setVisible(false);
        pi.getFormu().getChamp("idFournisseur").setVisible(false);
        pi.getFormu().getChamp("qteLimite").setVisible(false);
        pi.getFormu().getChamp("pv").setVisible(false);
        pi.getFormu().getChamp("libelleVente").setVisible(false);
        pi.getFormu().getChamp("puVenteUsd").setVisible(false);
        pi.getFormu().getChamp("puVenteEuro").setVisible(false);
        pi.getFormu().getChamp("tva").setVisible(false);
        pi.getFormu().getChamp("filepath").setVisible(false);
        pi.getFormu().getChamp("refpost").setVisible(false);
        pi.getFormu().getChamp("refqualification").setVisible(false);
        pi.getFormu().getChamp("idmagasin").setVisible(false);
        pi.getFormu().getChamp("idFamille").setVisible(false);
        pi.getFormu().getChamp("parfums").setVisible(false);
        pi.getFormu().getChamp("typeStock").setVisible(false);
        pi.getFormu().getChamp("reste").setVisible(false);

        String[] ordres = {"daty"};
        pi.getFormu().setOrdre(ordres);

        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();


%>

<div class="content-wrapper">
    <h1>Saisie d'un Vehicule</h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="vehicule/vehicule-fiche.jsp">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
    </form>
</div>

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>

