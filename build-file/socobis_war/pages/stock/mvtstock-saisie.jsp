<%@page import="annexe.Point"%>
<%@page import="magasin.Magasin"%>
<%@page import="stock.TypeMvtStock"%>
<%@page import="stock.MvtStockFille"%>
<%@page import="stock.MvtStock"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@ page import="fabrication.Fabrication" %>
<%@ page import="vente.As_BondeLivraisonClient" %>
<%@page import="faturefournisseur.As_BonDeLivraison"%>
<%@ page import="bean.TypeObjet" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="annexe.Unite" %>
<%@ page import="magasin.DirectionMagasin" %>
<%@ page import="utils.ConstanteSavonnerie" %>
<%@ page import="magasin.DirectionMagasinLib" %>
<%
    try {
        int taille = 10;
        String idBLC = request.getParameter("idBLC");
        String typeMvtStock = request.getParameter("idTypeMvStock");
        String idFab = request.getParameter("idFab");
        String idOf=request.getParameter("idOf");
        String isResidu = request.getParameter("isResidu");
        String idBLF = request.getParameter("idBLF");
        String idTravaux = request.getParameter("idTravaux");
        UserEJB u = (UserEJB) session.getValue("u");
        utilisateursocobis.UtilisateurStation user = new utilisateursocobis.UtilisateurStation();
        user.setTuppleId(u.getUser().getTuppleID());
        user = user.getUtilisateurByrefuser();
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
        fille.setNomTable("MVTSTOCKFILLELIB");
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
        pi.setLien((String) session.getValue("lien"));
        String awhereproduit = "";

        if(user.getService() != null && !user.getService().getDepartement().equals(ConstanteSavonnerie.DEPARTEMENT_DG)) {
            awhereproduit = "and idDirection = '" + user.getService().getDepartement() + "'";
        }

        Liste[] liste = new Liste[3];
        TypeMvtStock typemvt = new TypeMvtStock();
        liste[0] = new Liste("idTypeMvStock",typemvt,"val","id");
        if (typeMvtStock != null && !typeMvtStock.isEmpty()) liste[0].setDefaultSelected(typeMvtStock);
        DirectionMagasinLib cat= new DirectionMagasinLib();
        liste[1] = new Liste("idMagasin", cat, "idMagasinLib", "idmagasin",awhereproduit);
        liste[1].ajouterVide();
        TypeObjet categorie = new TypeObjet();
        categorie.setNomTable("categorieStock");
        liste[2] = new Liste("idCategorieStock",categorie,"val","id");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idPoint").setVisible(false);
        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("idVente").setVisible(false);
        pi.getFormu().getChamp("idTransfert").setVisible(false);
        pi.getFormu().getChamp("idTypeMvStock").setLibelle("Type du mouvement de stock");
        pi.getFormu().getChamp("fabPrecedent").setLibelle("Fabrication pr&eacute;c&eacute;dente");
        pi.getFormu().getChamp("idcategoriestock").setLibelle("Cat&eacute;gorie de stock");
        pi.getFormu().getChamp("idcategoriestock").setDefaut(ConstanteSocobis.ID_CATEGORIESTOCK_NORMAL);
        pi.getFormu().getChamp("heure").setDefaut(Utilitaire.heureCouranteHMS());
        pi.getFormu().getChamp("daty").setEstMoitier(true);
        pi.getFormu().getChamp("heure").setEstMoitier(true);
        pi.getFormu().getChamp("idMagasin").setAutre("onchange=\"updateFille(event, 'formId')\"");


        String apresWh= "";

        if (idTravaux != null) {
            pi.getFormu().getChamp("idobjet").setDefaut(idTravaux);
        }

        if(idBLF!=null && !idBLF.isEmpty()){
            pi.getFormu().getChamp("idTypeMvStock").setAutre("readonly");
            pi.getFormu().getChamp("idPoint").setAutre("readonly");
        }

        if (idOf != null && !idOf.equalsIgnoreCase("")) {
            apresWh = " or IDOFFILLE='"+idOf+"'";
        }

        pi.getFormu().getChamp("fabPrecedent").setPageAppelCompleteAWhere("fabrication.FabricationCpl", "id", "FABRICATIONCPL", "", "",apresWh);
        pi.getFormu().getChamp("daty").setLibelle("Date");

        // endmodif
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idobjet").setVisible(false);
        if (idFab != null && !idFab.isEmpty())
        {
            pi.getFormu().getChamp("idobjet").setDefaut(idFab);
        }

//        Liste[] listefle = new Liste[1];
//        Unite unite =  new Unite();
//        listefle[0] = new Liste("idUniteLib",unite,"val","val");
//        pi.getFormufle().changerEnChamp(listefle);

        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("Entree_0").setLibelle("Entr&eacute;e");
        pi.getFormufle().getChamp("Sortie_0").setLibelle("Sortie");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("IdVenteDetail_0").setLibelle("D&eacute;tails vente");
        pi.getFormufle().getChamp("compteLocalisation_0").setLibelle("Emplacement");
        pi.getFormufle().getChamp("Designation_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("mvtSrc_0").setLibelle("Mouvement source");
        pi.getFormufle().getChamp("idunitelib_0").setLibelle("Unit&eacute;");

        if(idBLC!=null && !idBLC.isEmpty()){
            pi.getFormu().getChamp("idPoint").setAutre("disabled");
            pi.getFormu().getChamp("idPoint").setAutre("disabled");
        }

        Champ.setAutre(pi.getFormufle().getChampFille("idunitelib"),"readonly");
        Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("idunite"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("idMvtStock"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("idTransfertDetail"),false);

        String aprWherelocalisation = "";
        String awheremag = "";
        String idMag = "";
        if(mvtStock!=null){
            idMag = mvtStock.getIdMagasin();
            aprWherelocalisation = " AND classy='"+idMag+"'";
            awheremag = " and idmagasin = '" + idMag + "'";
        }

        if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
             idMag = request.getParameter("idMagasin");
            if(!Utilitaire.champNull(idMag).isEmpty()){
                aprWherelocalisation = " AND classy='"+idMag+"'";
                awheremag = " and idmagasin = '" + idMag + "'";

            }
        }


        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("compteLocalisation"),"mg.cnaps.compta.Localisation","id","localisation","","",aprWherelocalisation);

        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTO","pu;libelle;libelle;unitelib","pu;designation;mvtSrc;idUniteLib","");
        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("mvtsrc"),"stock.MvtStockEntreeAvecReste","id","V_ETATSTOCK_ENTREE","pu;idproduit","pu;idProduit",  awheremag);


//        Champ.setVisible(pi.getFormufle().getChampFille("reste"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("IdVenteDetail"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idMvtStock"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idTransfertDetail"),false);


        String[] order = {"idProduit", "designation","Entree", "Sortie","idUnitelib", "pu","compteLocalisation","mvtsrc"};
        pi.getFormufle().setColOrdre(order);
        String[] champorder = {"daty","heure","idPoint", "designation","idmagasin", "idTypeMvStock", "fabPrecedent","idVente","idTransfert","idobjet","etat"};
        pi.getFormu().setOrdre(champorder);

        if(isResidu != null && !isResidu.isEmpty()){
            affichage.Champ.setVisible(pi.getFormufle().getChampFille("sortie"),false);
        }
        if (mvtStock != null)
        {
            mvtStock.setIdCategorieStock(ConstanteSocobis.ID_CATEGORIESTOCK_NORMAL);
            mvtStock.setHeure(Utilitaire.heureCouranteHMS());
            pi.getFormu().setDefaut(mvtStock);
            pi.getFormu().getChamp("daty").setDefaut(Utilitaire.formatterDaty(mvtStock.getDaty()));
            pi.setDefautFille(mvtStock.getFille());

        }

        pi.preparerDataFormu();

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
        <div id="butfillejsp">
            <h3 class="h329pxBold">Détails du mouvement de stocks</h3>
            <div>
                <p>Colonnes du Fichier Excel : idProduit,Entree,Sortie,pu,mvtSrc,compteLocalisation</p>
            </div>
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
    function applyTypeMvtStock() {
        const select = document.getElementById("idTypeMvStock");
        if (!select) return;

        changeChampByTypeDeStock(
            select.options[select.selectedIndex].text
        );
    }

    document.addEventListener("DOMContentLoaded", function () {
        const typeSelect = document.getElementById("idTypeMvStock");
        const detailContainer = document.getElementById("butfillejsp");
        applyTypeMvtStock();

        if (typeSelect) {
            typeSelect.addEventListener("change", applyTypeMvtStock);
        }

        if (detailContainer) {
            const observer = new MutationObserver(function () {
                applyTypeMvtStock();
            });

            observer.observe(detailContainer, {
                childList: true,
                subtree: true
            });
        }
    });
    // document.addEventListener('DOMContentLoaded', function() {
    //     const monLabel = document.querySelector('label[for="upload"]');
    //     monLabel.textContent = "Entrez le chemin de votre fichier Excel (colonnes : ID Produit, désignation, Entrée, Sortie, Prix unitaire, mouvement source, Localisation) :";
    //     var selectedValue = document.getElementById("idTypeMvStock").options[document.getElementById("idTypeMvStock").selectedIndex].text;
    //     changeChampByTypeDeStock(selectedValue);
    //
    //     document.getElementById("idTypeMvStock").addEventListener("change", function () {
    //         var selectedValue = this.options[this.selectedIndex].text;
    //         changeChampByTypeDeStock(selectedValue);
    //     });
    // });


    function changeChampByTypeDeStock(typeStock){
        var lineLength = document.querySelectorAll('input[id^="entree_"]').length;

        for (var i = 0; i < lineLength; i++) {
            var entreeInput = document.getElementById("entree_" + i);
            var sortieInput = document.getElementById("sortie_" + i);
            var sourceInput = document.getElementById("mvtSrc_" + i+"libelle");

            if (typeStock === "Entrée") {
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
            else if (typeStock === "Inventaire") {
                if (entreeInput) {
                    entreeInput.readOnly = false;
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
