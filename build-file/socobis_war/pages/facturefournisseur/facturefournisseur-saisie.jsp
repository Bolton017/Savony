<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="caisse.Caisse"%>
<%@page import="vente.InsertionVente"%>
<%@page import="vente.VenteDetails"%>
<%@page import="bean.TypeObjet"%>
<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="caisse.Devise" %>
<%@ page import="annexe.Point" %>
<%@ page import="faturefournisseur.*" %>
<%@ page import="mg.cnaps.compta.ConstanteCompta" %>
<%@ page import="utils.ConstanteAsync" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="prevision.Service" %>
<%@ page import="budget.UtilisateurService" %>
<%@ page import="affichage.Champ" %>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        String nomTableMere = "FACTUREFOURNISSEUR";
        String nomTableFille = "FactureFournisseurFille";

        if(!Utilitaire.champNull(request.getParameter("acte")).isEmpty()){
            nomTableMere = "FACTUREFOURNISSEURAUTOCOMPLETE";
            nomTableFille = "FACTFOURNISSEURFILLEACOMPLETE";
        }

        FactureFournisseur mere = new FactureFournisseur();
        mere.setNomTable(nomTableMere);
        FactureFournisseurDetails fille = new FactureFournisseurDetails();
        fille.setNomTable(nomTableFille);

        FactureFournisseur fournisseur = new FactureFournisseur();
        FactureFournisseurDetails[] details = null;
        As_BonDeLivraison bonDeLivraison = new As_BonDeLivraison();
        As_BonDeCommande bonDeCommande = new As_BonDeCommande();

        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));


        Liste[] liste = new Liste[5];
        Devise d = new Devise();
        liste[0] = new Liste("idDevise",d,"val","id");

        ModePaiement mp = new ModePaiement();
        liste[1] = new Liste("idModePaiement",mp,"val","id");

        liste[2] = new Liste("estPrevu");
        liste[2].makeListeOuiNon();

        liste[0].setDefaut("AR");
        if(request.getParameter("idBL")!=null){
            bonDeLivraison.setId(request.getParameter("idBL"));
            details = bonDeLivraison.getDetailsFacture(request.getParameter("idBL"),null);
            bonDeLivraison = (As_BonDeLivraison)bonDeLivraison.getById(request.getParameter("idBL"),"AS_BONDELIVRAISON_AUTOCOMPLETE",null);
            if(bonDeLivraison!=null){
                fournisseur = bonDeLivraison.genererFacture();
                fournisseur.setTypeFactureFournisseur(ConstanteSocobis.typeFactureFournisseurFAR);
                liste[0].setDefaut(fournisseur.getIdDevise());
                if (bonDeLivraison.getIdbc() != null && !bonDeLivraison.getIdbc().isEmpty()) {
                    faturefournisseur.As_BonDeCommande bc = (As_BonDeCommande)new As_BonDeCommande().getById(bonDeLivraison.getIdbc(),"AS_BONDECOMMANDE",null);
                    liste[1].setDefaut(bc.getModepaiement());
                    fournisseur.setIdModePaiement(bc.getModepaiement());
                }
            }
        }else if(request.getParameter("idbc")!=null){
            bonDeCommande.setId(request.getParameter("idbc"));
            details = bonDeCommande.getDetailsFacture(request.getParameter("idbc"),null);
            bonDeCommande = (As_BonDeCommande)bonDeCommande.getById(request.getParameter("idbc"),"AS_BONDECOMMANDE",null);
            fournisseur = bonDeCommande.genererFacture();
            liste[0].setDefaut(fournisseur.getIdDevise());
            liste[1].setDefaut(bonDeCommande.getModepaiement());
            fournisseur.setIdModePaiement(bonDeCommande.getModepaiement());
        }



        TypeObjet typefacture = new TypeObjet();
        typefacture.setNomTable("type_facture");
        liste[3] = new Liste("idtypefacture",typefacture,"val","id");
        TypeAchat ta = new TypeAchat();
        liste[4] = new Liste("typeachat",ta,"val","desce");

        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idtypefacture").setDefaut(ConstanteSocobis.TYPE_FACTURE);
        pi.getFormu().getChamp("service").setLibelle("D&eacute;partement");
        UtilisateurService us = new UtilisateurService();
        us.setRefuser(u.getUser().getTuppleID());
        us = us.getUserService(null);
        if (us != null) {
            pi.getFormu().getChamp("service").setDefaut(us.getIdService());
        }
        pi.getFormu().getChamp("service").setVisible(false);
        pi.getFormu().getChamp("idfactureprincipale").setVisible(false);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pi.getFormu().getChamp("numero").setLibelle("Num&eacute;ro");
        pi.getFormu().getChamp("numero").setVisible(false);

         pi.getFormu().getChamp("idtypefacture").setLibelle("Type de facture");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("idModePaiement").setLibelle("Mode de paiement");
        pi.getFormu().getChamp("typeachat").setLibelle("Type d'achat");
        pi.getFormu().getChamp("idDmdAchat").setVisible(false);
        pi.getFormu().getChamp("idMagasin").setVisible(false);
        
        pi.getFormu().getChamp("remise").setLibelle("Remise (en %)");
        pi.getFormu().getChamp("remiseMontant").setLibelle("Remise (en Montant)");

        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("idFournisseur").setLibelle("Fournisseur");
        pi.getFormu().getChamp("idFournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","fournisseur","echeance;taxe","echeance;taxe");
        pi.getFormu().getChamp("idFournisseur").setPageAppelInsert("fournisseur/fournisseur-saisie.jsp","idFournisseur;idFournisseurlibelle","id;nom");
        pi.getFormu().getChamp("typeFactureFournisseur").setVisible(false);
        pi.getFormu().getChamp("typeFactureFournisseur").setDefaut(ConstanteSocobis.typeFactureFournisseurFAR);

        String[] ordre={"daty"};
        pi.getFormu().setOrdre(ordre);
        String ac_affiche_val = "null";
        String ac_valeur_val = "id";
        String ac_colFiltre_val = "null";
        String ac_nomTable_val = "ST_INGREDIENTSAUTOVENTE_CPL";
        String ac_classe_val = "produits.IngredientsLib";
        String ac_useMotcle_val = "true";
        String ac_champRetour_val = "pv;compte_achat;compte_achat;libelleComposant";
        String dependentFieldsToMap_str_val = "pu;compte;comptelibelle;designation";

        String onChangeParam = "dynamicAutocompleteDependant(this, " +
                "\"IDFOURNISSEUR\", " +
                "\"LIKE\", " +
                "\"idProduit\", " +
                "\"" + nombreLigne + "\", " +
                "\"" + ac_affiche_val + "\", " +
                "\"" + ac_valeur_val + "\", " +
                "\"" + ac_colFiltre_val + "\", " +
                "\"" + ac_nomTable_val + "\", " +
                "\"" + ac_classe_val + "\", " +
                "\"" + ac_useMotcle_val + "\", " +
                "\"" + ac_champRetour_val + "\", " +
                "\"" + dependentFieldsToMap_str_val + "\"" + // Last parameter
                ")";

        //pi.getFormu().getChamp("idFournisseur").setAutre("onChange='" + onChangeParam + "'");
        //pi.getFormu().getChamp("idFournisseur").setAutre("onchange=\"updateFille(event, 'formId')\"");
        //pi.getFormu().getChamp("idDevise").setAutre("onchange=\"updateFille(event, 'formId')\"");

        pi.getFormu().getChamp("idDevise").setLibelle("Devise");
        pi.getFormu().getChamp("idDevise").setDefaut("AR");
        pi.getFormu().getChamp("datyPrevu").setVisible(false);
        pi.getFormu().getChamp("idDevise").setAutre("onChange='deviseModification()'");
        pi.getFormu().getChamp("idBc").setVisible(false);
        pi.getFormu().getChamp("devise").setVisible(false);
        pi.getFormu().getChamp("taux").setVisible(false);
        pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormu().getChamp("idRef").setVisible(false);
        if(request.getParameter("idTravaux")!=null){
            pi.getFormu().getChamp("idRef").setDefaut(request.getParameter("idTravaux"));
        }
        if(request.getParameter("idElementMaintenance")!=null){
            pi.getFormu().getChamp("idObjet").setDefaut(request.getParameter("idElementMaintenance"));
        }
        if(request.getParameter("idBL")!=null){
            pi.getFormu().getChamp("idObjet").setDefaut(request.getParameter("idBL"));
            pi.getFormu().getChamp("idObjet").setAutre("readonly");
            pi.getFormu().getChamp("idObjet").setLibelle("Source");
        }
        else if (request.getParameter("idbc") != null && !request.getParameter("idbc").isEmpty()) {
            pi.getFormu().getChamp("idObjet").setDefaut(request.getParameter("idbc"));
            pi.getFormu().getChamp("idObjet").setAutre("readonly");
            pi.getFormu().getChamp("idObjet").setLibelle("Source");
        }
        else {
            pi.getFormu().getChamp("idObjet").setVisible(false);
            pi.getFormu().getChamp("idObjet").setLibelle("Consommateur");
            pi.getFormu().getChamp("idObjet").setPageAppelComplete("maintenance.ressources.IngredientMaintenanceLib","id","AS_INGREDIENT_MAINTENANCE_LIB","","");
        }

        pi.getFormu().getChamp("estPrevu").setLibelle("Est pr&eacute;vu");
        pi.getFormu().getChamp("dateEcheancePaiement").setLibelle("Date pr&eacute;visionnelle de paiement");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTOACHAT_CPL","pu;taux;compte_achat;compte_achat;idMagasin","pu;tauxDeChange;compte;comptelibelle;idMagasin");
        affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampFille("idProduit"),"produits/as-ingredients-saisie.jsp","id;libelle");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("compte"),"mg.cnaps.compta.ComptaCompte","compte","compte6","","");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idPrevision"),"prevision.Prevision","id","prevision","","");

        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("idPrevision_0").setLibelle("Pr&eacute;vision");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        
        pi.getFormufle().getChamp("remise_0").setLibelle("Remise (en %)");
        pi.getFormufle().getChamp("remiseMontant_0").setLibelle("Remise (en Montant)");


        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        //pi.getFormufle().getChamp("idDevise_0").setVisible(false);
        pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
        pi.getFormufle().getChamp("tauxDeChange_0").setLibelle("Taux de change");
        Champ.setDefaut(pi.getFormufle().getChampFille("tauxDeChange"),"1");

        pi.getFormufle().getChamp("mois_0").setLibelle("Mois");
        pi.getFormufle().getChamp("annee_0").setLibelle("Ann&eacute;e");

        pi.getFormufle().getChampMulitple("idFactureFournisseur").setVisible(false);

        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("idbcDetail").setVisible(false);
        pi.getFormufle().getChampMulitple("idbcDevise").setVisible(false);
        pi.getFormufle().getChampMulitple("mois").setVisible(false);
        pi.getFormufle().getChampMulitple("annee").setVisible(false);
        pi.getFormufle().getChampMulitple("idMagasin").setVisible(false);

        affichage.Champ.setAutre(pi.getFormufle().getChampFille("pu"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("qte"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("tva"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("remise"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("remiseMontant"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("idProduit"),"onchange='calculerMontantV2()'");


        pi.preparerDataFormu();
        for(int i=0;i<nombreLigne;i++){
            pi.getFormufle().getChamp("qte_"+i).setAutre("onChange='calculerMontantV2("+i+")'");
            pi.getFormufle().getChamp("qte_"+i).setDefaut("0");
            pi.getFormufle().getChamp("tva_"+i).setDefaut("0");
             pi.getFormufle().getChamp("idDevise_"+i).setDefaut("AR");
            //pi.getFormufle().getChamp("tva_"+i).setVisible(false);
            pi.getFormufle().getChamp("idDevise_"+i).setAutre("readonly");
//            pi.getFormufle().getChamp("tauxDeChange_"+i).setAutre("readonly");
            //pi.getFormufle().getChamp("idDevise_"+i).setDefaut("AR");
            pi.getFormufle().getChamp("compte_"+i).setAutre("readonly");
        }

        FactureFournisseur ocr = (FactureFournisseur) session.getAttribute("ocr");
        if(ocr!=null){
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            LocalDate localDate = ocr.getDaty().toLocalDate();
            String formattedDate = localDate.format(formatter);
            pi.getFormu().getChamp("designation").setDefaut(ocr.getDesignation());
            pi.getFormu().getChamp("daty").setDefaut(formattedDate);
            if(ocr.getIdFournisseur()!=null){
                pi.getFormu().getChamp("idFournisseur").setDefaut(ocr.getIdFournisseur());
            }
            
            if(ocr.getIdMagasin()!=null){
                pi.getFormu().getChamp("idMagasin").setDefaut(ocr.getIdMagasin());
            }
            pi.setDefautFille(ocr.getFille());
        }

        if(details!=null && details.length > 0){
            if(request.getParameter("idbc")!=null){
                fournisseur.setDesignation("Facturation de la commande num "+request.getParameter("idbc"));
            }
            fournisseur.setIdtypefacture(ConstanteSocobis.TYPE_FACTURE);
            pi.getFormu().setDefaut(fournisseur);
            //pi.getFormu().getChamp("iddevise").setDefaut("AR");
            pi.setDefautFille(details);
            pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
            //pi.getFormu().getChamp("designation").setDefaut("Facturation de la commande num "+request.getParameter("idbc"));
        }

        session.removeAttribute("ocr");

        String iddmdachat = request.getParameter("iddmdachat");
        if (iddmdachat!=null && !iddmdachat.isEmpty()) {
            DmdAchat dmdAchat = (DmdAchat) new DmdAchat().getById(iddmdachat,"DMDACHAT",null);
        if (dmdAchat!=null){
                pi.getFormu().getChamp("daty").setDefaut(Utilitaire.datetostring(dmdAchat.getDaty()));
                pi.getFormu().getChamp("idFournisseur").setDefaut(dmdAchat.getFournisseur());
                pi.getFormu().getChamp("idbc").setDefaut(iddmdachat);
                pi.getFormu().getChamp("iddmdachat").setDefaut(iddmdachat);
                pi.getFormu().getChamp("designation").setDefaut("Facture de la demande d'achat "+iddmdachat);
                FactureFournisseurDetails[] factureFournisseurDetails = dmdAchat.getFactureFournisseurDetails(null);
                pi.setDefautFille(factureFournisseurDetails);
            }
        }

        //Variables de navigation
        String classeMere = "faturefournisseur.FactureFournisseur";
        String classeFille = "faturefournisseur.FactureFournisseurDetails";
        String butApresPost = "facturefournisseur/facturefournisseur-fiche.jsp";
        String colonneMere = "idFactureFournisseur";
        //Preparer les affichages
        String[] colOrdre = {"idProduit","compte","qte","pu","tva","idDevise","tauxDeChange","mois","annee","idMagasin","remise","remiseMontant","idPrevision"};
        pi.getFormufle().setColOrdre(colOrdre);
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <%if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update")) {%>
    <h1>Modification D&eacute;pense  / Facture Fournisseur</h1>
    <% }else{ %>
    <h1>D&eacute;pense / Facture Fournisseur</h1>
    <% } %>
    <div class="box-body">
        <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
            <%

                out.println(pi.getFormu().getHtmlInsert());
            %>
            <div class="col-md-12 nopadding" >
                <div class="col-md-12 cardradius">
                    <h3 class="fontinter m-0">
                        Total : <span id="montanttotal">0</span> <span id="deviseLibelle">AR</span>
                        <span style="margin-left: 200px;"></span>
                        <!----Reste budget : <span id="budget">0</span><span id="devise"> Ar</span>--->
                    </h3>
                </div>
            </div>
            <div id="butfillejsp">
                <%
                    out.println(pi.getFormufle().getHtmlTableauInsert());
                %>
            </div>

            <input type="hidden" name="taxe" id="taxe" value="">
            <input type="hidden" name="echeance" id="echeance" value="">
            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
        </form>
    </div>
</div>
<script>
    function initExclusionRemiseEnTete() {
        var $remise = $("#remise");
        var $remiseMontant = $("#remiseMontant");

        $remise.on('input change', function() {
            var val = $(this).val().trim();
            if (val !== "" && val !== "0") {
                $remiseMontant.prop('disabled', true).val('0');
                $remiseMontant.trigger('blur');
            } else {
                $remiseMontant.prop('disabled', false);
            }
            calculerMontantV2();
        });

        $remiseMontant.on('input change', function() {
            var val = $(this).val().trim();
            if (val !== "" && val !== "0") {
                $remise.prop('disabled', true).val('0');
                $remise.trigger('blur');
            } else {
                $remise.prop('disabled', false);
            }
            calculerMontantV2();
        });
    }

    $(document).ready(function() {
        
        initExclusionRemiseEnTete()
        calculerMontantV2();
        deviseModification();
        const echeanceInput = document.getElementById('echeance');
        const observer = new MutationObserver(() => {
            changerValeur();
        });

        observer.observe(echeanceInput, {
            attributes: true,
            attributeFilter: ['value']
        });


        const TAXE_VALUE = <%= ConstanteCompta.constante_tva %>;

        const taxeInput = document.getElementById('taxe');
        const tvaInputs = document.querySelectorAll('[id^="tva_"]');

        const observer2 = new MutationObserver(() => {
            const newValue = taxeInput.value;

            if (newValue === '1.0') {
                tvaInputs.forEach(input => {
                    input.value = TAXE_VALUE;
                });
            } else {
                tvaInputs.forEach(input => {
                    input.value = '0';
                });
            }
        });

        observer2.observe(taxeInput, {
            attributes: true,
            attributeFilter: ['value']
        });


        $(document).on('input change', 'input[id^="remise_"]', function() {
            var id = $(this).attr('id'); 
            var idx = id.split('_')[1];
            var target = $("#remiseMontant_" + idx);
            
            if ($(this).val().trim() !== "" && $(this).val().trim() !== "0") {
                target.prop('disabled', true).val('0');
            } else {
                target.prop('disabled', false);
            }
            calculerMontantV2();
        });
    
        $(document).on('input change', 'input[id^="remiseMontant_"]', function() {
            var id = $(this).attr('id'); 
            var idx = id.split('_')[1];
            var target = $("#remise_" + idx);
            
            if ($(this).val().trim() !== "" && $(this).val().trim() !== "0") {
                target.prop('disabled', true).val('0');
            } else {
                target.prop('disabled', false);
            }
            calculerMontantV2();
        });
    
            calculerMontantV2();
    });

</script>
<script>
    function calculerMontant(indice) {
        var val = 0;
        $('input[id^="qte_"]').each(function () {
            var id = $(this).attr('id').replace('qte_', '');
            var qte = cleanNumber($(this).val());
            var pu = cleanNumber($('#pu_' + id).val());
            val += qte * pu;
        });
        $("#montanttotal").html(
            val.toLocaleString('fr-FR', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            })
        );
    }
    function cleanNumber(val) {
            if (!val) return 0;

            return parseFloat(
                val
                    .toString()
                    .replace(/&nbsp;/g, "")   // retire le code HTML
                    .replace(/\u00A0/g, "")   // retire espace insécable réel
                    .replace(/\s/g, "")       // retire tous les autres espaces
                    .replace(",", ".")        // virgule → point
            ) || 0;
    }

    function calculerMontantV2() {
        var puList = document.querySelectorAll('input[id^="pu_"]');
        let montantTtc = 0;

        puList.forEach(input => {
            let id = input.id.split("_")[1];


            let pu = cleanNumber(document.getElementById("pu_" + id)?.value);
            let qte = cleanNumber(document.getElementById("qte_" + id)?.value);
            let tva = cleanNumber(document.getElementById("tva_" + id)?.value);
            

            let remisePct = cleanNumber(document.getElementById("remise_" + id)?.value);
            let remiseMontant = cleanNumber(document.getElementById("remiseMontant_" + id)?.value);


            let montantHt = pu * qte;


            let montantRemise = 0;
            if (remisePct > 0) {
                montantRemise = montantHt * (remisePct / 100);
            } else if (remiseMontant > 0) {
                montantRemise = Math.min(remiseMontant, montantHt);
            }


            let montantApresRemiseLigne = montantHt - montantRemise;


            let montantTva = montantApresRemiseLigne * (tva / 100);


            montantTtc += (montantApresRemiseLigne + montantTva);
        });


        let remiseEnTetePct = cleanNumber($("#remise").val());
        let remiseEnTeteMontant = cleanNumber($("#remiseMontant").val());

        if (remiseEnTetePct > 0) {
            montantTtc = montantTtc * (1 - remiseEnTetePct / 100);
        } else if (remiseEnTeteMontant > 0) {
            montantTtc = Math.max(0, montantTtc - remiseEnTeteMontant);
        }


        document.getElementById("montanttotal").innerHTML =
            montantTtc.toLocaleString('fr-FR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        }

        function cleanNumber(str) {
            if (!str) return 0;
            return parseFloat(str.toString().replace(/\s/g, '').replace(',', '.')) || 0;
        }



    function deviseModification() {

        var nombreLigne = parseInt($("#nombreLigne").val());
        for(let iL=0;iL<nombreLigne;iL++){
            $(function(){
                var mapping = {
                    "AR": {
                        "table": "ST_INGREDIENTSAUTOACHAT_CPL",
                    },
                    "USD": {
                        "table": "ST_INGREDIENTSAUTOACHAT_USD"
                        // "table": "ST_INGREDIENTSAUTOACHAT_CPL"
                    },
                    "EUR": {
                        "table": "ST_INGREDIENTSAUTOACHAT_EUR"
                        // "table": "ST_INGREDIENTSAUTOACHAT_CPL"
                    }
                };
                $("#deviseLibelle").html(" " + $('#idDevise').val());
                var idDevise = $('#idDevise').val();
                $("#idDevise_"+iL).val(idDevise);
                let autocompleteTriggered = false;
                $("#idProduit_"+iL+"libelle").autocomplete('destroy');
                // $("#tauxDeChange_"+iL).val('');
                // $("#pu_"+iL).val('');
                $("#idProduit_"+iL+"libelle").autocomplete({
                    source: function(request, response) {
                        $("#idProduit_"+iL).val('');
                        if (autocompleteTriggered) {
                            fetchAutocomplete(request, response, "null", "id", "null", mapping[idDevise].table, "produits.IngredientsLib", "true","pu;taux;compte_achat;compte_achat");
                        }
                    },
                    select: function(event, ui) {
                        $("#idProduit_"+iL+"libelle").val(ui.item.label);
                        $("#idProduit_"+iL).val(ui.item.value);
                        $("#idProduit_"+iL).trigger('change');
                        $(this).autocomplete('disable');
                        var champsDependant = ['pu_'+iL,'tauxDeChange_'+iL,'compte_'+iL,'compte_'+iL+'libelle'];
                        for(let i=0;i<champsDependant.length;i++){
                            $('#'+champsDependant[i]).val(ui.item.retour.split(';')[i]);
                        }
                        autocompleteTriggered = false;
                        return false;
                    }
                }).autocomplete('disable');
                $("#idProduit_"+iL+"libelle").off('keydown');
                $("#idProduit_"+iL+"libelle").keydown(function(event) {
                    if (event.key === 'Tab') {
                        event.preventDefault();
                        autocompleteTriggered = true;
                        $(this).autocomplete('enable').autocomplete('search', $(this).val());
                    }
                });
                $("#idProduit_"+iL+"libelle").off('input');
                $("#idProduit_"+iL+"libelle").on('input', function() {
                    $("#idProduit_"+iL).val('');
                    autocompleteTriggered = false;
                    $(this).autocomplete('disable');
                });
                $("#idProduit_"+iL+"searchBtn").off('click');
                $("#idProduit_"+iL+"searchBtn").click(function() {
                    autocompleteTriggered = true;
                    $("#idProduit_"+iL+"libelle").autocomplete('enable').autocomplete('search', $("#idProduit_"+iL+"libelle").val());
                });
            });
        }
    }

    function sanitizeNumber(str) {
        return parseFloat(str.replace(/\s/g, '').replace(',', '.')) || 0;
    }

    function changerValeur() {
        var champ = document.getElementById("echeance");
        const champDaty = document.getElementById("dateEcheancePaiement");

        let jour, mois, annee;

        const today = new Date();
        jour = today.getDate();
        mois = today.getMonth() + 1;
        annee = today.getFullYear();
        const date = new Date(annee, mois - 1, jour);

        if (isNaN(date.getTime())) {
            alert("Date invalide !");
            return;
        }

        const nbJours = sanitizeNumber(champ.value);
        date.setDate(date.getDate() + nbJours);

        const formattedDate = [
            String(date.getDate()).padStart(2, '0'),
            String(date.getMonth() + 1).padStart(2, '0'),
            date.getFullYear()
        ].join("/");

        champDaty.value = formattedDate;
        champ.dispatchEvent(new Event("input"));
    }

    var dateEcheanceInitiale = null;
    document.getElementById("idModePaiement").addEventListener("change", function () {
        calculerDateEcheance();
    });
    function calculerDateEcheance() {
        var select = document.getElementById("idModePaiement");
        var inputDate = document.getElementById("dateEcheancePaiement");
        if (dateEcheanceInitiale === null) {
            dateEcheanceInitiale = inputDate.value;
        }
        var texte = select.options[select.selectedIndex].text;
        var match = texte.match(/\b\d+\b(?!\s*%)/);
        if (!match) {
            inputDate.value = dateEcheanceInitiale;
            return;
        }
        var nbJours = parseInt(match[0], 10);
        var parts = dateEcheanceInitiale.split("/");
        if (parts.length !== 3) {
            return;
        }
        var date = new Date(
            parseInt(parts[2], 10),
            parseInt(parts[1], 10) - 1,
            parseInt(parts[0], 10)
        );
        date.setDate(date.getDate() + nbJours);
        var jour = ("0" + date.getDate()).slice(-2);
        var mois = ("0" + (date.getMonth() + 1)).slice(-2);
        var annee = date.getFullYear();
        inputDate.value = jour + "/" + mois + "/" + annee;
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
