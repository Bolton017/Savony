<%--
    Document   : vente-saisie
    Created on : 22 mars 2024, 14:37:44
    Author     : Angela
--%>

<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@page import="faturefournisseur.*"%>
<%@ page import="magasin.Magasin" %>
<%@ page import="mg.cnaps.compta.ConstanteCompta" %>
<%@ page import="prevision.Service" %>
<%@ page import="budget.UtilisateurService" %>
<%@ page import="affichage.Champ" %>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        As_BonDeCommande mere = new As_BonDeCommande();
        As_BonDeCommande_Fille_CPL fille = new As_BonDeCommande_Fille_CPL();
        fille.setNomTable("AS_BONDECOMMANDE_FILLE_CPL_U");
        int nombreLigne = 10;

        String iddmdachat = request.getParameter("iddmdachat");
        DmdAchat dmdAchat = null;
        As_BonDeCommande_Fille[] bcFille = null;
        if(iddmdachat!=null && !iddmdachat.isEmpty()){
            dmdAchat = (DmdAchat) new DmdAchat().getById(iddmdachat,"DMDACHAT",null);
            if(dmdAchat!=null){
                bcFille = dmdAchat.getBonDeCommandeDetails(null);
                nombreLigne = Math.max(nombreLigne, bcFille.length);
            }
        }

        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));


        Liste[] liste = new Liste[4];
        caisse.Devise dev = new caisse.Devise();
        //dev.setId("AR");
//        liste[0] = new Liste("idDevise",dev,"val","id");
//        liste[0].setDefaut("AR");
        ModePaiement mp = new ModePaiement();
        liste[0] = new Liste("modepaiement",mp,"val","id");
        Magasin magasin = new Magasin();
        magasin.setNomTable("MAGASIN2");
        liste[1] = new Liste("idMagasin",magasin,"val","id");
        TypeObjet devise = new TypeObjet();
        devise.setNomTable("devise");
        liste[2] = new Liste("idDevise",devise,"val","id");
        liste[3] = new Liste("service", new Service(), "libelle", "compte");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("echeance").setLibelle("&Eacute;ch&eacute;ance");
        pi.getFormu().getChamp("echeance").setDefaut("0");
        pi.getFormu().getChamp("dateEcheance").setLibelle("Date d'&eacute;ch&eacute;ance de paiement");
        pi.getFormu().getChamp("dateEcheance").setAutre("onChange='changerEcheance()'");
        pi.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormu().getChamp("idOrigine").setLibelle("Origine");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("remise").setLibelle("Remise (en %)");
        pi.getFormu().getChamp("remiseMontant").setLibelle("Remise (en Montant)");
        pi.getFormu().getChamp("dateLimite").setLibelle("Date limite de livraison");
        pi.getFormu().getChamp("fournisseur").setLibelle("Fournisseur");
        pi.getFormu().getChamp("fournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","Fournisseur","taxe","taxe");
        pi.getFormu().getChamp("fournisseur").setPageAppelInsert("fournisseur/fournisseur-saisie.jsp","fournisseur;fournisseurlibelle","id;nom");
        pi.getFormu().getChamp("idDevise").setLibelle("Devise");
        pi.getFormu().getChamp("service").setLibelle("D&eacute;partement");
        pi.getFormu().getChamp("idDevise").setDefaut("AR");
        pi.getFormu().getChamp("idDevise").setAutre("readonly");
       pi.getFormu().getChamp("idDevise").setAutre("onChange='deviseModification()'");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("produit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTOACHAT_CPL","pu;taux;compte_achat;compte_achat;libelle;unite","pu;tauxDeChange;compte;comptelibelle;designation;unitelib");
        affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampFille("produit"),"produits/as-ingredients-saisie.jsp","id;libelle");

        Champ.setVisible(pi.getFormufle().getChampMulitple("produitLib").getListeChamp(), false);

        pi.getFormufle().getChamp("produit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("produitLib_0").setVisible(false);
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("unitelib_0").setLibelle("Unit&eacute;");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA (%)");
        pi.getFormufle().getChamp("remise_0").setLibelle("Remise (en %)");
        pi.getFormufle().getChamp("remiseMontant_0").setLibelle("Remise (en Montant)");
        pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix Unitaire HT");
        pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("idbc").setVisible(false);
        pi.getFormufle().getChampMulitple("montant").setVisible(false);
        pi.getFormufle().getChampMulitple("unite").setVisible(false);

        pi.getFormufle().getChamp("remarque_0").setLibelle("Description");
        //pi.getFormufle().getChampMulitple("tauxDeChange").setVisible(false);
//        pi.getFormufle().getChampMulitple("idDevise").setVisible(false);

        pi.getFormufle().getChamp("tauxDeChange_0").setLibelle("Taux de change");
//        pi.getFormufle().getChampMulitple("tauxDeChange").setAutre("readonly");

        affichage.Champ.setAutre(pi.getFormufle().getChampFille("pu"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("quantite"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("tva"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("produit"),"onchange='calculerMontantV2()'");

        pi.preparerDataFormu();
        for(int i=0;i<nombreLigne;i++){
            pi.getFormufle().getChamp("tauxDeChange_"+i).setDefaut("1");
//            pi.getFormufle().getChamp("tauxDeChange_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("idDevise_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("quantite_"+i).setAutre("onChange='calculerMontantV2()'");
            pi.getFormufle().getChamp("quantite_"+i).setDefaut("0");
            pi.getFormufle().getChamp("tva_"+i).setDefaut("0");
            pi.getFormufle().getChamp("idDevise_"+i).setDefaut("AR");
            pi.getFormufle().getChamp("tauxDeChange_"+i).setDefaut("1");
//            pi.getFormufle().getChamp("tva_"+i).setDefaut("20");
        }

        Champ.setAutre(pi.getFormufle().getChampMulitple("unitelib").getListeChamp(), "readonly");

        //pi.getFormufle().getChampMulitple("quantite").setVisible(false);


        UtilisateurService us = new UtilisateurService();
        us.setRefuser(u.getUser().getTuppleID());
        us = us.getUserService(null);
        if (us != null) {
            pi.getFormu().getChamp("service").setDefaut(us.getIdService());
        }

        if (iddmdachat!=null && !iddmdachat.isEmpty()) {
            if (dmdAchat!=null){
                pi.getFormu().getChamp("echeance").setDefaut(String.valueOf(dmdAchat.getEcheance()));
                pi.getFormu().getChamp("dateEcheance").setDefaut(Utilitaire.datetostring(dmdAchat.getDateEcheance()));
                pi.getFormu().getChamp("daty").setDefaut(Utilitaire.datetostring(dmdAchat.getDaty()));
                pi.getFormu().getChamp("fournisseur").setDefaut(dmdAchat.getFournisseur());
                pi.getFormu().getChamp("designation").setDefaut("Facture de la demande d'achat "+iddmdachat);
                pi.getFormu().getChamp("idMagasin").setDefaut(dmdAchat.getIdMagasin());
                pi.getFormu().getChamp("idOrigine").setDefaut(iddmdachat);
                pi.getFormu().getChamp("idOrigine").setAutre("readonly");
                pi.getFormu().getChamp("service").setDefaut(dmdAchat.getService());

                if(dmdAchat.getDateLimite()!=null){
                    pi.getFormu().getChamp("dateLimite").setDefaut(Utilitaire.datetostring(dmdAchat.getDateLimite()));
                }
                pi.setDefautFille(bcFille);
            }
        }

        //Variables de navigation
        String classeMere = "faturefournisseur.As_BonDeCommande";
        String classeFille = "faturefournisseur.As_BonDeCommande_Fille";
        String butApresPost = "bondecommande/bondecommande-fiche.jsp";
        String colonneMere = "idbc";

        pi.getFormufle().setColOrdre(new String[]{"produit","designation", "produitLib", "remarque", "quantite", "unitelib","pu","iddevise","tva", "tauxDeChange","remiseMontant","remise"});
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
                    <h3 class="fontinter" style="background: white;padding: 16px;margin-top: 10px;border-radius: 16px;" >Total  : <span id="montanttotal">0</span> <span id="deviseLibelle">AR</span></h3>
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
            <input name="nomtable" type="hidden" id="nomtable" value="AS_BONDECOMMANDE_FILLE">
        </form>
    </div>
</div>
</div>
<script>
    function initialiserDeviseTotal() {
        var devise = $("#idDevise").val();

        if (devise == null || devise === "") {
            devise = "AR";
        }

        $("#deviseLibelle").html(devise);
    }
    function initExclusionRemiseEnTete() {
        var $remise = $("#remise");
        var $remiseMontant = $("#remisemontant");

        $remise.on('input change', function() {
            var val = $(this).val().trim();
            if (val !== "" && val !== "0") {
                $remiseMontant.prop('disabled', true).val('0');
            } else {
                $remiseMontant.prop('disabled', false);
            }
            calculerMontantV2();
        });

        $remiseMontant.on('input change', function() {
            var val = $(this).val().trim();
            if (val !== "" && val !== "0") {
                $remise.prop('disabled', true).val('0');
            } else {
                $remise.prop('disabled', false);
            }
            calculerMontantV2();
        });
    }

    $(document).ready(function() {
        initialiserDeviseTotal();
        initExclusionRemiseEnTete()

        var nombreLigne = <%=nombreLigne%>;
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
    });
</script>
<script>
    function calculerMontant(indice,source) {
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

    function calculerMontantV2() {
        var puList = document.querySelectorAll('input[id^="pu_"]');
        let montantTtc = 0;

        puList.forEach(input => {
            let id = input.id.split("_")[1];


            let pu = cleanNumber(document.getElementById("pu_" + id)?.value);
            let qte = cleanNumber(document.getElementById("quantite_" + id)?.value);
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
        let remiseEnTeteMontant = cleanNumber($("#remisemontant").val());

        if (remiseEnTetePct > 0) {
            montantTtc = montantTtc * (1 - remiseEnTetePct / 100);
        } else if (remiseEnTeteMontant > 0) {
            montantTtc = Math.max(0, montantTtc - remiseEnTeteMontant);
        }


        document.getElementById("montanttotal").innerHTML =
            Number(montantTtc).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, " ");
        }

        function cleanNumber(str) {
            if (!str) return 0;
            return parseFloat(str.toString().replace(/\s/g, '').replace(',', '.')) || 0;
        }

    document.addEventListener("DOMContentLoaded", function() {
        calculerMontantV2();
    });

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
                            fetchAutocomplete(request, response, "null", "id", "null", mapping[idDevise].table, "produits.IngredientsLib", "true","pu;taux;compte_achat;compte_achat;unite");
                        }
                    },
                    select: function(event, ui) {
                        $("#produit_"+iL+"libelle").val(ui.item.label);
                        $("#produit_"+iL).val(ui.item.value);
                        $("#produit_"+iL).trigger('change');
                        $(this).autocomplete('disable');
                        var champsDependant = ['pu_'+iL,'tauxDeChange_'+iL,'compte_'+iL, 'comptelibelle_'+iL, 'unitelib_'+iL];
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

