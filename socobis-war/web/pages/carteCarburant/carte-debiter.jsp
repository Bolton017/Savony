<%@page import="annexe.Point"%>
<%@page import="magasin.Magasin"%>
<%@page import="stock.TypeMvtStock"%>
<%@page import="stock.MvtStockFille"%>
<%@page import="stock.MvtStock"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@ page import="fabrication.Fabrication" %>
<%@ page import="vente.As_BondeLivraisonClient" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@page import="faturefournisseur.As_BonDeLivraison"%>
<%@ page import="produits.Ingredients" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="produits.IngredientsLibWithStock" %>
<%
  try {
    int taille = 10;
    String idcarte = request.getParameter("idcarte");
    String idBLC = request.getParameter("idBLC");
    String typeMvtStock = request.getParameter("idTypeMvStock");
    String idFab = request.getParameter("idFab");
    String idOf=request.getParameter("idOf");
    String isResidu = request.getParameter("isResidu");
    String idBLF = request.getParameter("idBLF");
    String idTravaux = request.getParameter("idTravaux");

    IngredientsLibWithStock carte = null;
    if(idcarte!=null&&idcarte.compareToIgnoreCase("")!=0){
        Connection c = null;
        carte = (IngredientsLibWithStock) new IngredientsLibWithStock().getById(idcarte,"as_ingredients_lib_with_stock",c);
        taille = 1;
    }

    MvtStock mvtStock = null;
    if(idBLC!=null && !idBLC.isEmpty()){
      As_BondeLivraisonClient bl = new As_BondeLivraisonClient();
      bl.setId(idBLC);
      mvtStock = bl.genererMvtStock(null);
    }

    if(idBLF!=null && !idBLF.isEmpty()){
      As_BonDeLivraison bl = new As_BonDeLivraison();
      bl.setId(idBLF);
      mvtStock = bl.genererMvtStockPersist1(null);
    }

//        A demande
    if (idFab != null && !idFab.isEmpty()) {
      Fabrication fab = new Fabrication();

      fab.setId(idFab);
      if(isResidu != null && !isResidu.isEmpty()){
        mvtStock = fab.genererMvtStock(null);
      }else{
        if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
          String idMagasin = request.getParameter("idMagasin");
          mvtStock = fab.genererMvtStock(idMagasin, typeMvtStock, null);
        }else{
          mvtStock = fab.genererMvtStock(typeMvtStock, null);
        }
      }
      if(mvtStock!=null&&mvtStock.getFille().length>10)taille=mvtStock.getFille().length+3;
    }

    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = u = (UserEJB) session.getValue("u");
    String classeMere = "stock.MvtStock",
            classeFille = "stock.MvtStockFille",
            titre = "Saisie de mouvement de stock",
            redirection = "stock/mvtstock-fiche.jsp";
    String colonneMere = "idMvtStock";

    if(request.getParameter("acte")!=null){
      titre = "Modification de mouvement de stock";
    }

    MvtStock mere = new MvtStock();
    mere.setNomTable("MVTSTOCK");
    MvtStockFille fille = new MvtStockFille();
    fille.setNomTable("MVTSTOCKFILLE");
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));

    Liste[] liste = new Liste[2];
    Point magasinpoint = new Point();
    liste[0] = new Liste("idPoint",magasinpoint,"val","id");
    Magasin cat= new Magasin();
    cat.setNomTable("magasin2");
    liste[1] = new Liste("idMagasin", cat, "val", "id");
    liste[0].setDeroulanteDependante(liste[1],"idPoint","onchange");
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("idPoint").setLibelle("Point");
    pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    if(carte!=null){
      pi.getFormu().getChamp("designation").setDefaut("Debitage carte "+carte.getId());
    }
//    pi.getFormu().getChamp("designation").setDefaut("Debitage carte "+request.getParameter("idcarte"));
    pi.getFormu().getChamp("idVente").setVisible(false);
    pi.getFormu().getChamp("idTransfert").setVisible(false);
    pi.getFormu().getChamp("idTypeMvStock").setVisible(false);
    pi.getFormu().getChamp("idTypeMvStock").setDefaut(ConstanteSocobis.TYPE_MVT_SORTIE);
    pi.getFormu().getChamp("fabPrecedent").setVisible(false);
    String apresWh= "";

    if (idTravaux != null) {
      pi.getFormu().getChamp("idobjet").setDefaut(idTravaux);
    }

    if(idBLF!=null && !idBLF.isEmpty()){
      pi.getFormu().getChamp("idPoint").setAutre("disabled");
      pi.getFormu().getChamp("idTypeMvStock").setAutre("disabled");
    }

    if (idOf != null && !idOf.equalsIgnoreCase("")) {
      //pi.getFormu().getChamp("fabPrecedent").setDefaut(idOf);
      apresWh = " or IDOFFILLE='"+idOf+"'";
    }
    pi.getFormu().getChamp("fabPrecedent").setPageAppelCompleteAWhere("fabrication.FabricationCpl", "id", "FABRICATIONCPL", "", "",apresWh);
    pi.getFormu().getChamp("daty").setLibelle("Date");
    // modif
    if(!Utilitaire.champNull(idFab).isEmpty()) {
      pi.getFormu().getChamp("idMagasin").setAutre("onchange=\"updateFille(event, 'formId')\"");
    }

    // endmodif
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idobjet").setLibelle("Vehicule");
    pi.getFormu().getChamp("idobjet").setPageAppelCompleteAWhere("produits.IngredientsLib", "id", "ST_INGREDIENTSAUTO", "", ""," AND CATEGORIEINGREDIENT='"+ConstanteSocobis.categorie_vehicule+"'");
    if (idFab != null && !idFab.isEmpty())
    {
      pi.getFormu().getChamp("idobjet").setDefaut(idFab);
    }
    pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
    pi.getFormufle().getChamp("Entree_0").setLibelle("Entr&eacute;e");
    pi.getFormufle().getChamp("Sortie_0").setLibelle("Montant");
    pi.getFormufle().getChamp("mvtSrc_0").setLibelle("Mouvement source");
    pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
    pi.getFormufle().getChamp("IdVenteDetail_0").setLibelle("D&eacute;tails vente");
    pi.getFormufle().getChamp("Designation_0").setLibelle("D&eacute;signation");
    if(carte!=null) {
      affichage.Champ.setDefaut(pi.getFormufle().getChampMulitple("idProduit").getListeChamp(), carte.getId());
      affichage.Champ.setDefaut(pi.getFormufle().getChampMulitple("Designation").getListeChamp(), carte.getLibelle());
      affichage.Champ.setDefaut(pi.getFormufle().getChampMulitple("Sortie").getListeChamp(), carte.getReste()+"");
    }
    affichage.Champ.setDefaut(pi.getFormufle().getChampMulitple("pu").getListeChamp(), "1");
    if(idBLC!=null && !idBLC.isEmpty()){
      pi.getFormu().getChamp("idPoint").setAutre("disabled");
    }
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTO","pu;libelle","pu;designation");
    Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
    Champ.setVisible(pi.getFormufle().getChampFille("idTransfertDetail"),false);
    Champ.setVisible(pi.getFormufle().getChampFille("pu"),false);
    Champ.setVisible(pi.getFormufle().getChampFille("mvtSrc"),false);
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("mvtSrc"),"stock.MvtStockEntreeAvecReste","id","V_ETATSTOCK_ENTREE","pu","pu");
    if (mvtStock != null ) {
      String idDEpart = mvtStock.getIdMagasin();
      String con = "";
      if(!Utilitaire.champNull(idDEpart).isEmpty()){
        con += " and idmagasin = '" + idDEpart + "'";
      }
      affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("mvtSrc"),"stock.MvtStockEntreeAvecReste","id","V_ETATSTOCK_ENTREE","pu","pu",con);
    }
    affichage.Champ.setAutoCompleteDependante(pi.getFormufle().getChampFille("idProduit"), pi.getFormufle().getChampFille("mvtSrc"), "stock.MvtStockEntreeAvecReste", "V_ETATSTOCK_ENTREE", "idProduit", "pu", "pu");
    Champ.setVisible(pi.getFormufle().getChampFille("reste"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("IdVenteDetail"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idMvtStock"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("entree"),false);

    pi.getFormu().getChamp("idMagasin").setAutre("onchange=\"updateFille(event, 'formId')\"");
    if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
      String apr = "";
      String idMag = request.getParameter("idMagasin");
      if(!Utilitaire.champNull(idMag).isEmpty()){
        apr = " AND idmagasin='"+idMag+"'";
      }
      affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("mvtSrc"),"stock.MvtStockEntreeAvecReste","id","V_ETATSTOCK_ENTREE","pu","pu",apr);
    }

    String[] order = {"idProduit", "designation","Sortie"};
    pi.getFormufle().setColOrdre(order);
    String[] champorder = {"daty","idPoint", "designation","idmagasin", "idTypeMvStock", "idVente","idTransfert","idobjet","etat"};
    pi.getFormu().setOrdre(champorder);

    if(isResidu != null && !isResidu.isEmpty()){
      affichage.Champ.setVisible(pi.getFormufle().getChampFille("sortie"),false);
    }
    if (mvtStock != null)
    {
      pi.getFormu().setDefaut(mvtStock);
      pi.getFormu().getChamp("daty").setDefaut(Utilitaire.formatterDaty(mvtStock.getDaty()));
      pi.setDefautFille(mvtStock.getFille());

    }
    pi.preparerDataFormu();

//        pi.getFormufle().setNbLigne(5);

    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<style>
  .h329pxBold {
    margin-top: 300px;
  }

  @media (max-width: 768px) {
    .h329pxBold {
      margin-top: 30px;
    }
  }
</style>
<div class="content-wrapper">
  <h1><%=titre%></h1>
  <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
    <%

      out.println(pi.getFormu().getHtmlInsert());
    %>
    <h3 class="h329pxBold">Détails mouvement de stocks</h3>
    <div id="butfillejsp">
      <%
        out.println(pi.getFormufle().getHtmlTableauInsert());
      %>
      <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
    </div>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="<%=redirection%>">
    <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
    <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
    <input name="nomtable" type="hidden" id="classefille" value="mvtstockfille">
    <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
  </form>
</div>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    var selectedValue = document.getElementById("idTypeMvStock").options[document.getElementById("idTypeMvStock").selectedIndex].text;
    changeChampByTypeDeStock(selectedValue);

    document.getElementById("idTypeMvStock").addEventListener("change", function () {
      var selectedValue = this.options[this.selectedIndex].text;
      changeChampByTypeDeStock(selectedValue);
    });
  });


  function changeChampByTypeDeStock(typeStock){
    var lineLength = document.querySelectorAll('input[id^="entree_"]').length;

    for (var i = 0; i < lineLength; i++) {
      var entreeInput = document.getElementById("entree_" + i);
      var sortieInput = document.getElementById("sortie_" + i);
      var sourceInput = document.getElementById("source_" + i+"libelle");

      if (typeStock === "Entree") {
        if (sourceInput){
          sourceInput.readOnly = true;
        }
        if (sortieInput) {
          sortieInput.readOnly = true;
          sortieInput.value = 0;
        }
        if (entreeInput) {
          entreeInput.readOnly = false;
        }
      } else if (typeStock === "Sortie") {
        if (entreeInput) {
          entreeInput.readOnly = true;
          entreeInput.value = 0;
        }
        if (sortieInput) {
          sortieInput.readOnly = false;
        }
        if (sourceInput){
          sourceInput.readOnly = false;
        }
      }
    }
  }
</script>

<%
} catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript">
  alert('<%=e.getMessage()%>');
  history.back();
</script>
<% }%>
