<%--
  Created by IntelliJ IDEA.
  User: tsinjoniaina
  Date: 21/09/2026
  Time: 15:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="bean.TypeObjet"%>
<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="caisse.Devise" %>
<%@ page import="faturefournisseur.*" %>
<%@ page import="mg.cnaps.compta.ConstanteCompta" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="affichage.Champ" %>
<%@ page import="utils.ConstanteAsync" %>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        FactureFournisseur mere = new FactureFournisseur();
        FactureFournisseurDetails fille = new FactureFournisseurDetails();
        fille.setNomTable("FactureFournisseurFille");

        FactureFournisseur fournisseur = new FactureFournisseur();
        FactureFournisseurDetails[] details = null;
        As_BonDeLivraison bonDeLivraison = new As_BonDeLivraison();
        As_BonDeCommande bonDeCommande = new As_BonDeCommande();
        Liste[] liste = new Liste[2];
//        Magasin mag = new Magasin();
//        mag.setNomTable("magasin2");
//        liste[0] = new Liste("idMagasin",mag,"val","id");
        Devise d = new Devise();
        liste[0] = new Liste("idDevise",d,"val","id");

        liste[0].setDefaut("AR");
        if(request.getParameter("id")!=null){
            bonDeLivraison.setId(request.getParameter("id"));
            details = bonDeLivraison.getDetailsFacture(request.getParameter("id"),null);
            bonDeLivraison = (As_BonDeLivraison)bonDeLivraison.getById(request.getParameter("id"),"AS_BONDELIVRAISON",null);
            if(bonDeLivraison!=null){
                fournisseur = bonDeLivraison.genererFacture();
            }
        }else if(request.getParameter("idbc")!=null){
            bonDeCommande.setId(request.getParameter("idbc"));
            details = bonDeCommande.getDetailsFacture(request.getParameter("idbc"),null);
            bonDeCommande = (As_BonDeCommande)bonDeCommande.getById(request.getParameter("idbc"),"AS_BONDECOMMANDE",null);
            fournisseur = bonDeCommande.genererFacture();
            liste[0].setDefaut(fournisseur.getIdDevise());
        }
        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));


        ModePaiement mp = new ModePaiement();
        liste[1] = new Liste("idModePaiement",mp,"val","id");

//        liste[3] = new Liste("estPrevu");
//        liste[3].makeListeOuiNon();

        TypeObjet typefacture = new TypeObjet();
        typefacture.setNomTable("type_facture");
//        liste[2] = new Liste("idtypefacture",typefacture,"val","id");
//        liste[4].setDefaut(ConstanteSocobis.TYPE_FRAIS_ACCESSOIRE);
//        TypeAchat ta = new TypeAchat();
//        liste[4] = new Liste("typeachat",ta,"val","desce");

        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idtypefacture").setDefaut(ConstanteAsync.TYPE_FRAIS_ACCESSOIRE);

        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("service").setVisible(false);

        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pi.getFormu().getChamp("idMagasin").setVisible(false);

        pi.getFormu().getChamp("numero").setLibelle("Num&eacute;ro");
        pi.getFormu().getChamp("numero").setVisible(false);
        pi.getFormu().getChamp("typeFactureFournisseur").setVisible(false);
        pi.getFormu().getChamp("typeFactureFournisseur").setDefaut(ConstanteAsync.FAR);

        pi.getFormu().getChamp("idtypefacture").setLibelle("Type de facture");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("idModePaiement").setLibelle("Mode de paiement");

        pi.getFormu().getChamp("typeachat").setLibelle("Type d'achat");
        pi.getFormu().getChamp("typeachat").setVisible(false);
        pi.getFormu().getChamp("remiseMontant").setVisible(false);


        pi.getFormu().getChamp("echeancefacture").setVisible(false);

        pi.getFormu().getChamp("idDmdAchat").setVisible(false);
        pi.getFormu().getChamp("idtypefacture").setVisible(false);
        pi.getFormu().getChamp("reference").setVisible(false);
        pi.getFormu().getChamp("idfactureprincipale").setLibelle("Facture principale");
        if(request.getParameter("idorigine")!=null){
            pi.getFormu().getChamp("idfactureprincipale").setDefaut(request.getParameter("idorigine"));
        }
        pi.getFormu().getChamp("idfactureprincipale").setPageAppel("choix/facture/facturefournisseurPrincipale-choix.jsp");
        pi.getFormu().getChamp("idfactureprincipale").setAutre("readonly");

        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("idFournisseur").setLibelle("Fournisseur");
        pi.getFormu().getChamp("idFournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","fournisseur","echeance;taxe","echeance;taxe");
        pi.getFormu().getChamp("idFournisseur").setPageAppelInsert("fournisseur/fournisseur-saisie.jsp","idFournisseur;idFournisseurlibelle","id;nom");

        String idFactureFournisseur = request.getParameter("idFactureFournisseur");

        if(!Utilitaire.champNull(idFactureFournisseur).isEmpty()) {
            pi.getFormu().getChamp("idfactureprincipale").setDefaut(idFactureFournisseur);

            FactureFournisseur factureFournisseur = new FactureFournisseur().getFactureFournisseurById(idFactureFournisseur, "FACTUREFOURNISSEUR", null);

            if (factureFournisseur != null) {
                pi.getFormu().getChamp("idFournisseur").setDefaut(factureFournisseur.getIdFournisseur());
                pi.getFormu().getChamp("designation").setDefaut("Frais accessoire de la facture " + idFactureFournisseur);
                pi.getFormu().getChamp("idDevise").setDefaut(factureFournisseur.getIdDevise());

                Champ.setDefaut(pi.getFormufle().getChampFille("idDevise"), factureFournisseur.getIdDevise());
            }

        }

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
        pi.getFormu().getChamp("datyPrevu").setVisible(false);
        pi.getFormu().getChamp("idDevise").setAutre("onChange='deviseModification()'");
        pi.getFormu().getChamp("idBc").setVisible(false);
        pi.getFormu().getChamp("devise").setVisible(false);
        pi.getFormu().getChamp("taux").setVisible(false);
        pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormu().getChamp("idRef").setVisible(false);
        pi.getFormu().getChamp("remise").setVisible(false);
        if(request.getParameter("idTravaux")!=null){
            pi.getFormu().getChamp("idRef").setDefaut(request.getParameter("idTravaux"));
        }
        if(request.getParameter("idElementMaintenance")!=null){
            pi.getFormu().getChamp("idObjet").setDefaut(request.getParameter("idElementMaintenance"));
        }
        if(request.getParameter("id")!=null){
            pi.getFormu().getChamp("idObjet").setDefaut(request.getParameter("id"));
            pi.getFormu().getChamp("idObjet").setAutre("readonly");
            pi.getFormu().getChamp("idObjet").setLibelle("Source");
        }
        else {
            pi.getFormu().getChamp("idObjet").setLibelle("Consommateur");
            pi.getFormu().getChamp("idObjet").setVisible(false);
            pi.getFormu().getChamp("idObjet").setPageAppelComplete("maintenance.ressources.IngredientMaintenanceLib","id","AS_INGREDIENT_MAINTENANCE_LIB","idIngredient","idObjet");
        }

        pi.getFormu().getChamp("estPrevu").setLibelle("Est pr&eacute;vu");
        pi.getFormu().getChamp("estPrevu").setVisible(false);

        pi.getFormu().getChamp("dateEcheancePaiement").setLibelle("Date pr&eacute;visionnelle de paiement");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTOACHAT_CPL","pu;taux;compte_achat;compte_achat","pu;tauxDeChange;compte;comptelibelle");
        affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampFille("idProduit"),"produits/as-ingredients-saisie.jsp","id;libelle");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("compte"),"mg.cnaps.compta.ComptaCompte","compte","compte6","","");

        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("idPrevision_0").setLibelle("Pr&eacute;vision");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        pi.getFormufle().getChamp("remises_0").setLibelle("remise");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        //pi.getFormufle().getChamp("idDevise_0").setVisible(false);
        pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
        pi.getFormufle().getChamp("tauxDeChange_0").setLibelle("Taux de change");

        pi.getFormufle().getChamp("mois_0").setLibelle("Mois");
        pi.getFormufle().getChamp("annee_0").setLibelle("Ann&eacute;e");

        pi.getFormufle().getChampMulitple("idFactureFournisseur").setVisible(false);
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("idbcDetail").setVisible(false);
        pi.getFormufle().getChampMulitple("idbcDevise").setVisible(false);
        pi.getFormufle().getChampMulitple("mois").setVisible(false);
        pi.getFormufle().getChampMulitple("annee").setVisible(false);


        affichage.Champ.setAutre(pi.getFormufle().getChampFille("pu"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("qte"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("tva"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("remises"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("idProduit"),"onchange='calculerMontantV2()'");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("tauxDeChange"),"1");


        pi.preparerDataFormu();
        for(int i=0;i<nombreLigne;i++){
            pi.getFormufle().getChamp("qte_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("qte_"+i).setDefaut("0");
            pi.getFormufle().getChamp("tva_"+i).setDefaut("0");
            //pi.getFormufle().getChamp("tva_"+i).setVisible(false);
            pi.getFormufle().getChamp("idDevise_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("idPrevision_"+i).setPageAppelComplete("prevision.Prevision","id","Prevision");
            //pi.getFormufle().getChamp("tauxDeChange_"+i).setVisible(false);
            //pi.getFormufle().getChamp("idDevise_"+i).setDefaut("AR");
            //pi.getFormufle().getChamp("compte_"+i).setAutre("readonly");
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
        String[] colOrdre = {"id","idProduit","idPrevision", "designation","compte","qte","pu","tva","idDevise","tauxDeChange","mois","annee"};
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
                    <h3 class="fontinter m-0" >Total  : <span id="montanttotal">0</span><span id="deviseLibelle"> Ar</span></h3>
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
    // Appel automatique de calculerMontant pour chaque ligne au chargement
    $(document).ready(function () {
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
    });
</script>
<script>
    function calculerMontant(indice,source) {
        var val = 0;
        $('input[id^="qte_"]').each(function() {
            var quantite =  parseFloat($("#"+$(this).attr('id').replace("qte","pu")).val());
            var montant = parseFloat($(this).val());
            if(!isNaN(quantite) && !isNaN(montant)){
                var value =quantite * montant;
                val += value;
            }
        });
        $("#montanttotal").html(Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(val));
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
            let remise = cleanNumber(document.getElementById("remises_" + id)?.value);

            let montantHt = pu * qte;
            let montantRemise = montantHt * (remise / 100);
            let montantTva = (montantHt - montantRemise) * (tva / 100);

            montantTtc += (montantHt - montantRemise + montantTva);
        });

        document.getElementById("montanttotal").innerHTML =
            montantTtc.toLocaleString('fr-FR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
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
                    },
                    "EUR": {
                        "table": "ST_INGREDIENTSAUTOACHAT_EUR"
                    }
                };
                $("#deviseLibelle").html($('#idDevise').val());
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
                            fetchAutocomplete(request, response, "null", "id", "null", mapping[idDevise].table, "produits.IngredientsLib", "true","pu;taux;compte;compte");
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

