<%--
    Document   : vente-saisie
    Created on : 22 mars 2024, 14:37:44
    Author     : Angela
--%>

<%@page import="user.*"%>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@page import="faturefournisseur.*"%>
<%@ page import="magasin.Magasin" %>
<%@ page import="mg.cnaps.compta.ConstanteCompta" %>
<%@ page import="faturefournisseur.proforma.ProformaFournisseur" %>
<%@ page import="faturefournisseur.proforma.ProformaFournisseurDetails" %>
<%@ page import="faturefournisseur.proforma.ProformaFournisseurDetailsCpl" %>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        ProformaFournisseur mere = new ProformaFournisseur();
        if (request.getParameter("acte") != null && !request.getParameter("acte").isEmpty()) {
            mere.setNomTable("proformafournisseurlibfrns");
        }
        ProformaFournisseurDetailsCpl fille = new ProformaFournisseurDetailsCpl();
        fille.setNomTable("PROFORMAFRNSDETAILSCPL_2");
        int nombreLigne = 10;

        String iddmdachat = request.getParameter("iddmdachat");
        DmdAchat dmdAchat = null;
        if (iddmdachat!=null && !iddmdachat.isEmpty()) {
            dmdAchat = (DmdAchat) new DmdAchat().getById(iddmdachat,"DMDACHAT",null);
            if (dmdAchat!=null){
                ProformaFournisseurDetails[] bcFille = dmdAchat.getProformaFournisseurDetails(null);
                nombreLigne = bcFille.length;
            }
        }

        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));
        Liste[] liste = new Liste[3];
        caisse.Devise dev = new caisse.Devise();
        //dev.setId("AR");
        liste[0] = new Liste("idDevise",dev,"val","id");
        liste[0].setDefaut("AR");
        ModePaiement mp = new ModePaiement();
        liste[1] = new Liste("modepaiement",mp,"val","id");
        Magasin magasin = new Magasin();
        magasin.setNomTable("MAGASIN2");
        liste[2] = new Liste("idMagasin",magasin,"val","id");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
        pi.getFormu().getChamp("echeance").setLibelle("&Eacute;ch&eacute;ance");
        pi.getFormu().getChamp("echeance").setDefaut("0");
        pi.getFormu().getChamp("dateEcheance").setLibelle("Date d'&eacute;ch&eacute;ance de paiement");
         pi.getFormu().getChamp("dateEcheance").setAutre("onChange='changerEcheance()'");
        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormu().getChamp("reference").setVisible(false);
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("idOrigine").setLibelle("Origine");
        pi.getFormu().getChamp("remise").setLibelle("Remise (en %)");
        pi.getFormu().getChamp("remise").setVisible(false);
        pi.getFormu().getChamp("remisemontant").setLibelle("Remise (en Montant)");
        pi.getFormu().getChamp("remisemontant").setVisible(false);
//        pi.getFormu().getChamp("dateLimite").setLibelle("Date limite de livraison");
        pi.getFormu().getChamp("fournisseur").setLibelle("Fournisseur");
        pi.getFormu().getChamp("fournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","Fournisseur","taxe","taxe");
        pi.getFormu().getChamp("fournisseur").setPageAppelInsert("fournisseur/fournisseur-saisie.jsp","fournisseur;fournisseurlibelle","id;nom");
        pi.getFormu().getChamp("idDevise").setLibelle("Devise");
        pi.getFormu().getChamp("idDevise").setAutre("onChange='deviseModification()'");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("produit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTOACHAT_CPL","pu;unite;taux;compte_achat;compte_achat;libelle","pu;unitelib;tauxDeChange;compte;comptelibelle;produitLib");
        affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampFille("produit"),"produits/as-ingredients-saisie.jsp","id;libelle");

        pi.getFormufle().getChamp("produit_0").setLibelle("Produit");
//        pi.getFormufle().getChamp("produitLib_0").setLibelle("Libell&eacute;");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA (%)");
        pi.getFormufle().getChamp("remise_0").setLibelle("Remise (en %)");
        pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix Unitaire HT");
        pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
        pi.getFormufle().getChamp("unitelib_0").setLibelle("Unit&eacute;");
        pi.getFormufle().getChampMulitple("id").setVisible(false);
//        pi.getFormufle().getChampMulitple("idbc").setVisible(false);
        pi.getFormufle().getChampMulitple("montant").setVisible(false);
        pi.getFormufle().getChampMulitple("unite").setVisible(false);
        pi.getFormufle().getChamp("remiseMontant_0").setLibelle("Remise (en Montant)");

        pi.getFormufle().getChamp("tauxdechange_0").setLibelle("Taux de change");
//        pi.getFormufle().getChampMulitple("tauxDeChange").setAutre("readonly");

        affichage.Champ.setAutre(pi.getFormufle().getChampFille("pu"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("quantite"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("tva"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("produit"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("unitelib"),"readonly");

        pi.preparerDataFormu();
        for(int i=0;i<nombreLigne;i++){
            pi.getFormufle().getChamp("idDevise_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("quantite_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("quantite_"+i).setDefaut("0");
            pi.getFormufle().getChamp("tva_"+i).setDefaut("0");
            pi.getFormufle().getChamp("idDevise_"+i).setDefaut("AR");
            pi.getFormufle().getChamp("tauxdechange_"+i).setDefaut("1");
//            pi.getFormufle().getChamp("tva_"+i).setDefaut("20");
        }

//        pi.getFormufle().getChampMulitple("quantite").setVisible(false);
        if (dmdAchat!=null) {
            pi.getFormu().getChamp("echeance").setDefaut(String.valueOf(dmdAchat.getEcheance()));
            pi.getFormu().getChamp("dateEcheance").setDefaut(Utilitaire.datetostring(dmdAchat.getDateEcheance()));
            pi.getFormu().getChamp("idOrigine").setDefaut(dmdAchat.getId());
            pi.getFormu().getChamp("idOrigine").setAutre("readonly");
            pi.getFormu().getChamp("daty").setDefaut(Utilitaire.datetostring(dmdAchat.getDaty()));
            pi.getFormu().getChamp("fournisseur").setDefaut(dmdAchat.getFournisseur());
            pi.getFormu().getChamp("designation").setDefaut("Proforma de la demande d'achat "+iddmdachat);
            pi.getFormu().getChamp("idMagasin").setDefaut(dmdAchat.getIdMagasin());

            ProformaFournisseurDetails[] bcFille = dmdAchat.getProformaFournisseurDetails(null);
            nombreLigne = bcFille.length;
            pi.setDefautFille(bcFille);
        }
        //Variables de navigation
        String classeMere = "faturefournisseur.proforma.ProformaFournisseur";
        String classeFille = "faturefournisseur.proforma.ProformaFournisseurDetails";
        String butApresPost = "facturefournisseur/proforma/proforma-fiche.jsp";
        String colonneMere = "idMere";

        pi.getFormufle().setColOrdre(new String[]{"produit", "quantite", "unitelib","pu","idDevise","tva", "tauxdechange","remise","remiseMontant"});
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <%if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update")) {%>
    <h1>Modification d'un bon de commande fournisseur</h1>
    <% }else{ %>
    <h1>Saisie d'un bon de commande fournisseur</h1>
    <% } %>
    <div class="box-body">
        <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
            <%

                out.println(pi.getFormu().getHtmlInsert());
            %>
            <div class="col-md-12 nopadding" >
                <div class="col-md-12 cardradius">
                    <h3 class="fontinter" style="background: white;padding: 16px;margin-top: 10px;border-radius: 16px;" >Total  : <span id="montanttotal">0</span><span id="deviseLibelle"> Ar</span></h3>
                </div>
            </div>
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>

            <input name="taxe" type="hidden" id="taxe" value="">
            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
            <input name="nomtable" type="hidden" id="nomtable" value="ProformaFournisseurDetails">
        </form>
    </div>
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
            if (typeof calculer === 'function') {
                calculer('remise');
            }
        });
        
        $remiseMontant.on('input change', function() {
            var val = $(this).val().trim();
            if (val !== "" && val !== "0") {
                $remise.prop('disabled', true).val('0');
                $remise.trigger('blur');
            } else {
                $remise.prop('disabled', false);
            }
            if (typeof calculer === 'function') {
                calculer('remiseMontant');
            }
        });
    }

    $(document).ready(function() {
        
        initExclusionRemiseEnTete()

        /*var nombreLigne = <%=nombreLigne%>;
        for(var i=0;i<nombreLigne;i++){
            calculerMontant(i);
        }

        const TAXE_VALUE = <%= ConstanteCompta.constante_tva %>;

        const taxeInput = document.getElementById('taxe');
        const tvaInputs = document.querySelectorAll('[id^="tva_"]');

        const observer = new MutationObserver(() => {
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

        observer.observe(taxeInput, {
            attributes: true,
            attributeFilter: ['value']
        });*/
        $(document).on('input change', 'input[id^="remise_"]', function() {
            var id = $(this).attr('id'); 
            var idx = id.split('_')[1];
            var target = $("#remiseMontant_" + idx);
            
            if ($(this).val().trim() !== "" && $(this).val().trim() !== "0") {
                target.prop('disabled', true).val('0');
            } else {
                target.prop('disabled', false);
            }
            /*calculerMontantV2();*/
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
            /*calculerMontantV2();*/
        });
        
    });
</script>
<script>
    /*function calculerMontant(indice,source) {
        var val = 0;
        $('input[id^="quantite_"]').each(function() {
            var quantite =  parseFloat($("#"+$(this).attr('id').replace("quantite","pu")).val());
            var montant = parseFloat($(this).val());
            if(!isNaN(quantite) && !isNaN(montant)){
                var value =quantite * montant;
                val += value;
            }
        });
        $("#montanttotal").html(val.toFixed(2));
    }

    function calculerMontantV2(){
        var listChamp = document.querySelectorAll('input[id^="pu_"]');
        let montantTtc = 0;
        for (let i = 0; i < listChamp.length; i++) {
            let pu = parseFloat(document.getElementById("pu_"+i)?.value || 0);
            let qte = parseFloat(document.getElementById("quantite_"+i)?.value || 0);
            let tva = parseFloat(document.getElementById("tva_"+i)?.value || 0);
            let remise = parseFloat(document.getElementById("remises_"+i)?.value || 0);
            let montantremise = (pu*qte)*(remise/100);
            montantTtc += ((pu*qte)-montantremise)+(((pu*qte)-montantremise)*(tva/100));
        }
        document.getElementById("montanttotal").innerHTML = montantTtc.toLocaleString('en-US');
    }

    document.addEventListener("DOMContentLoaded", function() {
        calculerMontantV2();
    });
    */

    function deviseModification() {

        var nombreLigne = parseInt($("#nombreLigne").val());
        for(let iL=0;iL<nombreLigne;iL++){
            $(function(){
                var mapping = {
                    "AR": {
                        "table": "ST_INGREDIENTSAUTOACHAT_CPL",
                    },
                    "USD": {
                        "table": "ST_INGREDIENTSAUTOACHAT_CPL"
                    },
                    "EUR": {
                        "table": "ST_INGREDIENTSAUTOACHAT_CPL"
                    }
                };
                $("#deviseLibelle").html($('#idDevise').val());
                var idDevise = $('#idDevise').val();
                $("#idDevise_"+iL).val(idDevise);
                let autocompleteTriggered = false;
                $("#produit_"+iL+"libelle").autocomplete('destroy');
                $("#tauxDeChange_"+iL).val('');
                $("#pu_"+iL).val('');
                $("#produit_"+iL+"libelle").autocomplete({
                    source: function(request, response) {
                        $("#produit_"+iL).val('');
                        if (autocompleteTriggered) {
                            fetchAutocomplete(request, response, "null", "id", "null", mapping[idDevise].table, "produits.IngredientsLib", "true","pu;taux;compte_achat;compte_achat");
                        }
                    },
                    select: function(event, ui) {
                        $("#produit_"+iL+"libelle").val(ui.item.label);
                        $("#produit_"+iL).val(ui.item.value);
                        $("#produit_"+iL).trigger('change');
                        $(this).autocomplete('disable');
                        var champsDependant = ['pu_'+iL,'tauxDeChange_'+iL,'compte_'+iL, 'comptelibelle_'+iL];
                        for(let i=0;i<champsDependant.length;i++){
                            $('#'+champsDependant[i]).val(ui.item.retour.split(';')[i]);
                        }
                        autocompleteTriggered = false;
                        return false;
                    }
                }).autocomplete('disable');
                $("#produit_"+iL+"libelle").off('keydown');
                $("#produit_"+iL+"libelle").keydown(function(event) {
                    if (event.key === 'Tab') {
                        event.preventDefault();
                        autocompleteTriggered = true;
                        $(this).autocomplete('enable').autocomplete('search', $(this).val());
                    }
                });
                $("#produit_"+iL+"libelle").off('input');
                $("#produit_"+iL+"libelle").on('input', function() {
                    $("#produit_"+iL).val('');
                    autocompleteTriggered = false;
                    $(this).autocomplete('disable');
                });
                $("#produit_"+iL+"searchBtn").off('click');
                $("#produit_"+iL+"searchBtn").click(function() {
                    autocompleteTriggered = true;
                    $("#produit_"+iL+"libelle").autocomplete('enable').autocomplete('search', $("#produit_"+iL+"libelle").val());
                });
            });
        }
    }

    function calculerEtAfficherTotal() {
        var nombreLigne = parseInt($("#nombreLigne").val() || 10);
        
        var totalHtDetails = 0;
        var totalTvaDetails = 0;
        var totalTtcDetails = 0;
        
        for (var i = 0; i < nombreLigne; i++) {
            var pu = parseFloat($("#pu_" + i)?.val() || 0);
            var qte = parseFloat($("#quantite_" + i)?.val() || 0);
            var tva = parseFloat($("#tva_" + i)?.val() || 0);
            var remisePct = parseFloat($("#remise_" + i)?.val() || 0);
            var remiseMontant = parseFloat($("#remiseMontant_" + i)?.val() || 0);
            
            var brut = pu * qte;
            
            var remiseDetail = 0;
            if (remisePct > 0) {
                remiseDetail = brut * (remisePct / 100);
            } else if (remiseMontant > 0) {
                remiseDetail = remiseMontant;
            }
            
            var htNet = brut - remiseDetail;
            var tvaMontant = (tva === 0) ? 0 : htNet * (tva / 100);
            var ttcLigne = (tva === 0) ? htNet : htNet + tvaMontant;
            
            totalHtDetails += htNet;
            totalTvaDetails += tvaMontant;
            totalTtcDetails += ttcLigne;
        }
        
        var remiseEnTetePct = parseFloat($("#remise")?.val() || 0);
        var remiseEnTeteMontant = parseFloat($("#remiseMontant")?.val() || 0);
        
        var remiseAppliquee = 0;
        if (remiseEnTetePct > 0) {
            remiseAppliquee = totalTtcDetails * (remiseEnTetePct / 100);
        } else if (remiseEnTeteMontant > 0) {
            remiseAppliquee = remiseEnTeteMontant;
        }
        
        var htFinal = totalHtDetails - (remiseEnTetePct > 0 ? totalHtDetails * (remiseEnTetePct / 100) : remiseEnTeteMontant > 0 ? remiseEnTeteMontant * (totalHtDetails / (totalTtcDetails || 1)) : 0);
        var tvaFinale = totalTvaDetails - (remiseAppliquee * (totalTvaDetails / (totalTtcDetails || 1)));
        
        var ttcFinal = 0;
        if (totalTvaDetails === 0) {
            ttcFinal = htFinal;
        } else {
            ttcFinal = totalTtcDetails - remiseAppliquee;
        }
        
        var devise = $("#idDevise").val() || "AR";
        var symbole = (devise === "AR") ? " Ar" : " " + devise;
        
        $("#montanttotal").html(ttcFinal.toLocaleString('fr-FR', { minimumFractionDigits: 2, maximumFractionDigits: 2 }));
        $("#deviseLibelle").html(symbole);
        
        $("#totalHtHidden").val(htFinal.toFixed(2));
        $("#totalTvaHidden").val(tvaFinale.toFixed(2));
        $("#totalTtcHidden").val(ttcFinal.toFixed(2));
    }

    function initCalculTotal() {

        $(document).on('input change', 'input[id^="pu_"], input[id^="quantite_"], input[id^="tva_"], input[id^="remise_"], input[id^="remiseMontant_"]', function() {
            calculerEtAfficherTotal();
        });
        
        $(document).on('input change', '#remise, #remiseMontant, #idDevise', function() {
            calculerEtAfficherTotal();
        });
        
        setTimeout(calculerEtAfficherTotal, 300);
    }

    $(document).ready(function() {
        initCalculTotal();
    });
</script>
<script>
    function calculerDateEcheance() {
        const champEcheance = document.getElementById("echeance");
        const champDateEcheance = document.getElementById("dateEcheance");

        if (!champEcheance || !champDateEcheance) {
            return;
        }
        let date = new Date();
        const nbJours = parseInt(champEcheance.value) || 0;
        date.setDate(date.getDate() + nbJours);
        const formattedDate =
            String(date.getDate()).padStart(2, '0') + "/" +
            String(date.getMonth() + 1).padStart(2, '0') + "/" +
            date.getFullYear();
        champDateEcheance.value = formattedDate;
    }
     function changerEcheance() {
    const champEcheance = document.getElementById("echeance");
    const champDateEcheance = document.getElementById("dateEcheance");

    if (!champEcheance || !champDateEcheance || !champDateEcheance.value) {
        return;
    }

    const today = new Date();
    today.setHours(0,0,0,0);

    const tab = champDateEcheance.value.split("/");
    if (tab.length !== 3) {
        return;
    }

    const dateFin = new Date(
        parseInt(tab[2]),
        parseInt(tab[1]) - 1,
        parseInt(tab[0])
    );
    dateFin.setHours(0,0,0,0);

    if (isNaN(dateFin.getTime())) {
        return;
    }

    const diff = Math.round(
        (dateFin - today) / (1000 * 60 * 60 * 24)
    );

    champEcheance.value = diff;
}

    document.addEventListener("DOMContentLoaded", function () {

    calculerDateEcheance();

    document.getElementById("echeance")
            .addEventListener("input", calculerDateEcheance);

    document.getElementById("echeance")
            .addEventListener("change", calculerDateEcheance);

    document.getElementById("dateEcheance")
            .addEventListener("input", changerEcheance);

    document.getElementById("dateEcheance")
            .addEventListener("change", changerEcheance);

});
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

