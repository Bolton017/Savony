<%--
    Document   : vente-saisie
    Created on : 22 mars 2024, 14:37:44
    Author     : Angela
--%>
<%@ page import="client.Client" %>
<%@ page import="vente.Vente" %>
<%@ page import="vente.InsertionVente" %>
<%@ page import="user.UserEJB" %>
<%@ page import="vente.VenteDetails" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="affichage.Liste" %>
<%@ page import="personnel.Personnel" %>
<%@ page import="utils.ConstanteSavonnerie" %>
<%@ page import="personnel.PersonnelIdUser" %>

<script>
    (function() {

        // ================================================================
        // CONFIG
        // ================================================================
        const MODES = {
            'especes': 'valeurEspece',
            'mvola':   'montantMvola',
            'orange':  'montantOrange',
            'airtel':  'montantAirtel',
            'cheque':  'montantCheque',
            'visa':    'montantVisa'
        };

        // ================================================================
        // HELPERS
        // ================================================================

        function getTotal() {
            const el = document.getElementById('totalGeneral');
            return el ? parseAmount(el.textContent) : 0;
        }

        function isMultiple() {
            const cb = document.getElementById('multiple-payment');
            return !!(cb && cb.checked);
        }

        function getModesActifs() {
            return Array.from(
                document.querySelectorAll('.toggle-container .toggle-button.active input[name="payment-method"]')
            ).map(i => i.value);
        }

        function getRawMontant(inputId) {
            const el = document.getElementById(inputId);
            if (!el || !el.value) return 0;
            const raw = el.value.replace(/\D/g, '');
            return raw ? parseInt(raw, 10) : 0;
        }

        function setMontant(inputId, valeur) {
            const el = document.getElementById(inputId);
            if (!el) return;
            el.value = valeur > 0 ? valeur.toLocaleString('fr-FR') + ' Ar' : '';
        }

        function getSomme(excludeId) {
            let somme = 0;
            getModesActifs().forEach(mode => {
                const id = MODES[mode];
                if (id && id !== excludeId) {
                    somme += getRawMontant(id);
                }
            });
            return somme;
        }

        // ================================================================
        // ERREURS UI
        // ================================================================

        function showError(inputId, msg) {
            const eid = 'mpay-err-' + inputId;
            let el = document.getElementById(eid);
            if (!el) {
                el = document.createElement('div');
                el.id = eid;
                el.style.cssText = 'color:#c00;font-size:12px;font-weight:600;margin-top:4px;' +
                    'background:#fff0f0;border:1px solid #f99;border-radius:4px;padding:4px 8px;';
                const input = document.getElementById(inputId);
                if (input) {
                    const parent = input.closest('.form-input') || input.parentNode;
                    parent.appendChild(el);
                }
            }
            el.textContent = msg;
            el.style.display = 'block';
        }

        function hideError(inputId) {
            const el = document.getElementById('mpay-err-' + inputId);
            if (el) el.style.display = 'none';
        }

        function hideAllErrors() {
            Object.values(MODES).forEach(hideError);
        }

        // ================================================================
        // MISE A JOUR MONTANT PAYE AFFICHÉ
        // ================================================================

        function updateMontantPayeAffiche() {
            let somme = 0;
            const modes = isMultiple() ? getModesActifs() : (() => {
                const r = document.querySelector('input[name="payment-method"]:checked');
                return r ? [r.value] : [];
            })();
            modes.forEach(mode => {
                const id = MODES[mode];
                if (id) somme += getRawMontant(id);
            });
            const el = document.getElementById('montantPayerTexte');
            if (el) el.textContent = formatAmount(somme, true);
        }

        // ================================================================
        // CONTROLE PRINCIPAL
        // ================================================================

        function controler(inputId) {
            if (!isMultiple()) {
                hideError(inputId);
                return true;
            }

            const total       = getTotal();
            const sommeAutres = getSomme(inputId);
            const valeur      = getRawMontant(inputId);
            const restant     = total - sommeAutres;

            // Cas 1 : les autres modes couvrent déjà tout
            if (restant <= 0 && valeur > 0) {
                showError(inputId,
                    'Les autres modes couvrent déjà le total (' +
                    formatAmount(total, true) + '). Remettez ce champ à 0.'
                );
                setMontant(inputId, 0);
                return false;
            }

            // Cas 2 : valeur saisie dépasse le restant
            if (valeur > restant) {
                showError(inputId,
                    'Maximum autorisé : ' + formatAmount(restant, true) +
                    ' (Total : ' + formatAmount(total, true) + ')'
                );
                setMontant(inputId, restant);
                return false;
            }

            // Cas OK
            hideError(inputId);
            return true;
        }

        // ================================================================
        // LISTENER SUR UN INPUT MONTANT
        // ================================================================

        function onMontantInput(e, inputId) {
            if (!isMultiple()) return;

            const input = e.target;

            // 1. Formater la valeur
            const raw = input.value.replace(/\D/g, '');
            if (!raw) {
                input.value = '';
                hideError(inputId);
                updateMontantPayeAffiche();
                if (typeof checkPaymentValidation === 'function') checkPaymentValidation();
                return;
            }
            const num = parseInt(raw, 10);
            input.value = num.toLocaleString('fr-FR') + ' Ar';

            // 2. Repositionner curseur avant " Ar"
            try {
                const pos = input.value.length - 3;
                input.setSelectionRange(pos, pos);
            } catch(err) {}

            // 3. Contrôler le dépassement (corrige si besoin)
            controler(inputId);

            // 4. Mettre à jour l'affichage
            updateMontantPayeAffiche();

            // 5. Réactiver/désactiver le bouton Payer
            if (typeof checkPaymentValidation === 'function') checkPaymentValidation();
        }

        // ================================================================
        // ATTACHER LES LISTENERS (sans écraser les existants)
        // ================================================================

        function attachListeners() {
            Object.entries(MODES).forEach(([mode, inputId]) => {
                const input = document.getElementById(inputId);
                if (!input || input.dataset.mpayCtrl) return;
                input.dataset.mpayCtrl = '1';

                input.addEventListener('input', function(e) {
                    onMontantInput(e, inputId);
                });

                // Sécurité : contrôle aussi au blur
                input.addEventListener('blur', function() {
                    if (!isMultiple()) return;
                    controler(inputId);
                    updateMontantPayeAffiche();
                    if (typeof checkPaymentValidation === 'function') checkPaymentValidation();
                });
            });
        }

        // ================================================================
        // BLOQUER LA SOUMISSION SI DÉPASSEMENT
        // ================================================================

        function attachSubmitGuard() {
            const form = document.getElementById('venteForm');
            if (!form || form.dataset.mpaySubmit) return;
            form.dataset.mpaySubmit = '1';

            // On utilise capture:true pour passer en premier
            form.addEventListener('submit', function(e) {
                if (!isMultiple()) return;

                const total = getTotal();
                let somme = 0;
                getModesActifs().forEach(mode => {
                    const id = MODES[mode];
                    if (id) somme += getRawMontant(id);
                });

                if (somme > total) {
                    e.preventDefault();
                    e.stopImmediatePropagation();

                    const loader = document.getElementById('globalLoader');
                    if (loader) loader.style.display = 'none';

                    // Réactiver le bouton Payer
                    const btn = document.querySelector('.btn-primary.btn-large');
                    if (btn) {
                        btn.disabled = false;
                        btn.style.opacity = '1';
                        btn.style.cursor = 'pointer';
                        btn.innerHTML = 'Payer';
                        btn.style.pointerEvents = 'auto';
                        btn.style.backgroundColor = '';
                    }

                    alert(
                        'La somme des paiements (' + formatAmount(somme, true) + ') ' +
                        'dépasse le total à payer (' + formatAmount(total, true) + ').\n\n' +
                        'Veuillez corriger les montants.'
                    );
                    return false;
                }

                // Vérifier aussi que la somme couvre bien le total
                if (somme < total) {
                    e.preventDefault();
                    e.stopImmediatePropagation();

                    const loader = document.getElementById('globalLoader');
                    if (loader) loader.style.display = 'none';

                    const btn = document.querySelector('.btn-primary.btn-large');
                    if (btn) {
                        btn.disabled = false;
                        btn.style.opacity = '1';
                        btn.style.cursor = 'pointer';
                        btn.innerHTML = 'Payer';
                        btn.style.pointerEvents = 'auto';
                        btn.style.backgroundColor = '';
                    }

                    alert(
                        'Le total des paiements (' + formatAmount(somme, true) + ') ' +
                        'ne couvre pas le total à payer (' + formatAmount(total, true) + ').\n\n' +
                        'Il reste ' + formatAmount(total - somme, true) + ' à régler.'
                    );
                    return false;
                }

            }, true);
        }

        // ================================================================
        // OBSERVER LES CHANGEMENTS DE MODE
        // ================================================================

        function observerModes() {
            // Changement checkbox "Paiement multiple"
            const cb = document.getElementById('multiple-payment');
            if (cb) {
                cb.addEventListener('change', function() {
                    hideAllErrors();
                    updateMontantPayeAffiche();
                    if (typeof checkPaymentValidation === 'function') checkPaymentValidation();
                });
            }

            // Changement de mode de paiement actif
            document.querySelectorAll('.toggle-container .toggle-button').forEach(btn => {
                btn.addEventListener('click', function() {
                    // Léger délai pour laisser le DOM se mettre à jour
                    setTimeout(() => {
                        hideAllErrors();
                        // Re-contrôler tous les champs actifs
                        if (isMultiple()) {
                            getModesActifs().forEach(mode => {
                                const id = MODES[mode];
                                if (id && getRawMontant(id) > 0) {
                                    controler(id);
                                }
                            });
                        }
                        updateMontantPayeAffiche();
                        if (typeof checkPaymentValidation === 'function') checkPaymentValidation();
                    }, 60);
                });
            });
        }

        // ================================================================
        // INIT
        // ================================================================

        function init() {
            attachListeners();
            attachSubmitGuard();
            observerModes();
            console.log('[MultiPaiement] ✅ Contrôle montant actif');
        }

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', init);
        } else {
            init();
        }

    })();
</script>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%
    try {
        String classeMere = "vente.Vente";
        String classeFille = "vente.VenteDetails";
        String butApresPost = "vente/vente-saisie-directe-apj.jsp";
        String colonneMere = "idVente";
        String nombreLigne = "1";
        int nbl = 1;
        String lien =(String) session.getValue("lien");

        String idPoint = "POINT001";
        Client client = new Client();
        //client.setIdPoint(idPoint);
        //client.clientPoint();

        String idClient = ConstanteSavonnerie.CLIENT_DIVERS;
        String nomClient = "Client Divers";

        if(client.getId()!=null){
            idClient = client.getId();
            nomClient = client.getNom();
        }

        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        Vente mere = new InsertionVente();
        mere.setNomTable("INSERTION_VENTE_PERSONNEL_VIDE");
        VenteDetails fille = new VenteDetails();
        fille.setNomTable("vente_details_saisie");
        Vente res = new Vente();
        VenteDetails[] vente_details = null;
        String titre = "Enregistrement d'une vente compl&egrave;te";

        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nbl, u);
        pi.setLien((String) session.getValue("lien"));
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTOVENTE_MGA","pv;compte_vente;libelleComposant;codebarre;taux;photo;reference;unite","pu;compte;designation;codebarre;tauxDeChange;photo;reference;unite");
        Liste[] listes = new Liste[1];
        Personnel personnel = new Personnel();
        personnel.setNomTable("LOG_PERSONNEL_VEN");
//        TypeObjet tp = new TypeObjet();
//        tp.setNomTable("AS_UNITE");
        listes[0] = new Liste("idResponsable", personnel,"nom","id");
        PersonnelIdUser temp =  new PersonnelIdUser();
        PersonnelIdUser user = temp.getByIdUser(u.getUser().getRefuser()+"", null);
        if (user != null && user.getId() != null) {
            listes[0].setDefaut(user.getId());
        }

        pi.getFormu().changerEnChamp(listes);

        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("designation").setVisible(false);
        pi.getFormu().getChamp("idMagasin").setVisible(false);
        pi.getFormu().getChamp("daty").setVisible(false);
        // ID CLIENT
        pi.getFormu().getChamp("idClient").setLibelle("Client");
        pi.getFormu().getChamp("idResponsable").setLibelle("Responsable");
//        pi.getFormu().getChamp("idResponsable").setAutocompleteDynamique("personnel.Personnel","nom","id","Personnel");
        pi.getFormu().getChamp("idClient").setAutocompleteDynamique("client.Client","nom","id","Client");
//        pi.getFormu().getChamp("idClient").setDefaut(idClient);
        // INVISIBLE: Remarque , Etat, Origine, IdDevise
        pi.getFormu().getChamp("remarque").setVisible(false);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idOrigine").setVisible(false);
        pi.getFormu().getChamp("idDevise").setVisible(false);
        pi.getFormu().getChamp("estPrevu").setVisible(false);
        pi.getFormu().getChamp("datyPrevu").setVisible(false);
        pi.getFormu().getChamp("idCommercial").setVisible(false);
        pi.getFormu().getChamp("idmodepaiement").setVisible(false);
        pi.getFormu().getChamp("remise").setVisible(false);
        pi.getFormu().getChamp("remiseMontant").setVisible(false);
        pi.getFormu().getChamp("heureSaisie").setVisible(false);

        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
//        pi.getFormufle().getChamp("montant_0").setLibelle("Montant");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        pi.getFormufle().getChamp("designation_0").setLibelle("Article");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        pi.getFormufle().getChamp("remise_0").setLibelle("Remise en %");
        //pi.getFormufle().getChamp("ristourne_0").setLibelle("Ristourne en %");
        //pi.getFormufle().getChamp("remiseMontant_0").setLibelle("Remise en Montant");
        pi.getFormufle().getChamp("idOrigine_0").setLibelle("Origine");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("photo_0").setLibelle("Photo");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("pu_0").setLibelle("Montant");
        pi.getFormufle().getChamp("reference_0").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormufle().getChamp("unite_0").setLibelle("Unit&eacute;");
        pi.getFormufle().getChamp("tauxDeChange_0").setLibelle("Taux de change");
        pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("pu"),"onChange='updateTotals()' readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("qte"),"onChange='updateTotals()'");
       // affichage.Champ.setAutre(pi.getFormufle().getChampFille("remiseMontant"),"onChange='updateTotals()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("compte"),"readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("tauxDeChange"),"readonly");
//        affichage.Champ.setAutre(pi.getFormufle().getChampFille("montant"),"readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("designation"),"readonly");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("tauxDeChange"),"1");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("idDevise"),"Ar");

        pi.getFormufle().getChampMulitple("compte").setVisible(false);
        pi.getFormufle().getChampMulitple("idDevise").setVisible(false);
        pi.getFormufle().getChampMulitple("tauxDeChange").setVisible(false);
        pi.getFormufle().getChampMulitple("remise").setVisible(false);
        //pi.getFormufle().getChampMulitple("remiseMontant").setVisible(false);
        //pi.getFormufle().getChampMulitple("reference").setVisible(false);
        pi.getFormufle().getChampMulitple("tva").setVisible(false);

        pi.getFormufle().getChampMulitple("idVente").setVisible(false);
        pi.getFormufle().getChampMulitple("montant").setVisible(false);
        pi.getFormufle().getChampMulitple("idProduit").setVisible(false);
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        //pi.getFormufle().getChampMulitple("ristourne").setVisible(false);
        pi.getFormufle().getChampMulitple("IdOrigine").setVisible(false);
        pi.getFormufle().getChampMulitple("puAchat").setVisible(false);
        pi.getFormufle().getChampMulitple("puVente").setVisible(false);
        pi.preparerDataFormu();

        String[] ordreFille = new String[]{"photo", "idProduit", "designation", "qte", "pu", "unite"};
        pi.getFormufle().setColOrdre(ordreFille);
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<style>
    #butfillejsp .table-container {
        float: left;
    }
    .qte-editable-input {
        width: 70px; /* Reduced from 60px */
        text-align: center;
        border: 1px solid #ddd;
        border-radius: 4px;
        padding: 4px 0px; /* Reduced padding */
        font-weight: 600;
        transition: border-color 0.2s ease;
    }

    .col-qte {
        width: 1%; /* Trick to make column shrink to fit content */
        white-space: nowrap;
        padding-left: 5px !important;
        padding-right: 5px !important;
    }

    .qte-editable-input:focus {
        outline: none;
        border-color: var(--VD-main-color);
        box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.1);
    }

    .qte-editable-input:hover {
        border-color: #aaa;
    }
    .ui-autocomplete {
        z-index: 9999 !important;
        position: absolute !important;
        max-height: 200px; /* hauteur max (ajuste selon ton besoin) */
        overflow-y: auto;   /* rend la liste scrollable verticalement */
        overflow-x: hidden; /* évite le défilement horizontal */
        z-index: 9999;
    }
    #globalLoader {
        display: none;
        position: fixed;
        top: 0; left: 0;
        width: 100vw; height: 100vh;
        z-index: 99999;
        background: rgba(255,255,255,0.7);
        justify-content: center;
        align-items: center;
    }
    .wider-icon {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
        border-radius: 4px;
        background-color: var(--VD-main-color);
        margin-left: 8px;
    }
    .wider-icon i {
        color: white !important;
        font-size: 18px;
    }
    .spinner-border {
        display: inline-block;
        width: 4rem;
        height: 4rem;
        vertical-align: text-bottom;
        border: 0.5rem solid var(--VD-main-color);
        border-right-color: transparent;
        border-radius: 50%;
        animation: spinner-border .75s linear infinite;
    }
    #site-logo {
        cursor: pointer;
        transition: transform 0.2s ease;
    }
    #site-logo:hover {
        transform: scale(1.05);
    }
    @keyframes spinner-border {
        to { transform: rotate(360deg); }
    }
    .d-none { display: none !important; }

    .payment-buttons-grid {
        display: grid;
        grid-template-columns: 1fr 1fr 1fr;
        gap: 10px;
        margin-top: 15px;
    }

    .payment-buttons-grid .btn {
        min-width: 100px;
        justify-content: center;
        display: flex;
        align-items: center;
        text-align: center;
    }
    .btn.btn-secondary.btn-large.btn-autre {
        border: 2px solid var(--VD-main-color);
        color: var(--VD-main-color);
    }
    .btn-payment-processing {
        background-color: #6c757d !important;
        cursor: not-allowed !important;
        opacity: 0.7 !important;
        pointer-events: none !important;
    }
    #uploadBox {
        display: none !important;
    }
    .cardradius {
        margin-top: 0px !important;
    }
    .col-md-12.cardradius{
        margin-top: 0px !important;
    }
    .table-container.nopadding.borderless{
        width: 100%;
    }
    .table-container.nopadding.borderless table tbody tr td:nth-child(4) {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
        height: 59px;
    }
    .table-container.nopadding.borderless table tbody tr td .form-control {
        height: 34px !important;
        min-width: inherit !important;
        padding: 0;
    }

    .table-container.nopadding.borderless table tbody tr td select.form-control {
        padding: 8px !important;
    }
    .table-container.nopadding.borderless table tbody tr td input{
        border: none;
        background: transparent;

    }
    .table-container.nopadding.borderless table tbody tr td:nth-child(3) input{
        font-size: 14px;
        font-family: DM Sans, sans-serif;
        font-weight: 600;
        line-height: 21px;
        color: var(--VD-main-color);
        min-width: 150px;

    }
    .table-container.nopadding.borderless table tbody tr td input{
        height: auto;
    }
    .table-container img{
        width: 80%;
    }
    .table-container.nopadding.borderless table tbody tr td .form-control {
        height: 34px !important;
        min-width: 100px !important;
    }
    .table-container.nopadding.borderless table tbody tr td:nth-child(4) input{
        border: 1px solid var(--VD-main-color);
        height: 34px;
        align-self: center;
        padding: 8px 12px !important;
        max-width: 44px !important;
        min-width: 36px !important;
    }
    #idClientsearchBtn {
        height: 50px;
    }
    .col-md-12.cardradius {
        border: none;
        border-top: none !important;
    }
    .form-input {
        width: 100%;
    }
    .table-container.nopadding.borderless table tbody tr td:nth-child(4) .btn {
        height: 30px !important;
        padding: 3px;
    }
    .table-container.nopadding.borderless table tbody tr td:nth-child(5), table-container.nopadding.borderless table tbody tr th:nth-child(5)  {
        max-width: 80px !important;
    }
    .table {
        margin: 0;
        margin-top: 0 !important;
    }
    .table-container.nopadding.borderless table tbody tr td:nth-child(8) {
        display: none;
    }
</style>
<link href="${pageContext.request.contextPath}/assets/css/vente-directe.css" rel="stylesheet" type="text/css" />
<div class="vd-header">
    <img src="${pageContext.request.contextPath}/assets/img/logo-lewis.png" alt="logo" id="site-logo">
    <div class="form-input w-100">
        <input value="" class="form-control ui-autocomplete-input ui-autocomplete-loading" id="idProduit_libelle"  type="text" oninput="autoCompleteVenteDirect('idProduit_libelle','ST_INGREDIENTSVENTEPOS_PRIX','produits.Ingredients','photo;libelle;reference;quantite=1;pv;codegros;pvgros;remise=0;prix=0;unite;compte_vente','photo;designation;reference;qte;pu;codegros;pu_pvgros;remiseMontant;prix;unite;compte','id')"
        />
        <input value='' class='form-control' id='idProduit' name='idProduit' type='hidden'/>
    </div>
    <a class="" href="${pageContext.request.contextPath}/pages/module.jsp?but=cloturecaisse/cloturecaisse-saisie.jsp" >
        <i class="material-symbols-rounded">point_of_sale</i>
    </a>
    <%--    <a class="" href="${pageContext.request.contextPath}/pages/module.jsp?but=vente/vente-saisie-directe2.jsp" target="_blank">--%>
    <a class="" href="${pageContext.request.contextPath}/pages/module.jsp?but=vente/vente-saisie-directe-apj.jsp" target="_blank">
        <i class="material-symbols-rounded">add</i>
    </a>
</div>
<div class="content-wrapper">
    <div class="box-body">
        <form class='container' id="venteForm" action="apresMultiple.jsp" method="post" >
            <div class="row">
                <div class="col-md-3 d-flex vente-directe-left-container ">
                    <div id="selectedProductBox" class="vente-direct-box d-none">
                        <h2 class="h617pxSemibold m-0" >Produit entr&eacute;</h2>
                        <div class="vente-directe__product-image" >
                            <img id="selectedProductImage" src="${pageContext.request.contextPath}/assets/img/products/no_image.png" class="product-img" alt="Produit sélectionné">
                        </div>
                        <h3 id="selectedProductName" class="h520pxSemibold" >Aucun produit</h3>
                        <div class="d-flex"><p>Code produit :</p> <p id="selectedProductCode">--</p> </div>
                        <div class="d-flex"><p>Prix unitaire :</p> <p id="selectedProductPrice">--</p> </div>
                    </div>
                    <div class="clavier-container vente-direct-box" >
                        <div class="numbers col-md-10 nopadding">
                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="7" >7</button>
                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="8" >8</button>
                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="9" >9</button>
                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="4" >4</button>
                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="5" >5</button>
                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="6" >6</button>
                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="1" >1</button>
                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="2" >2</button>
                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="3" >3</button>
                            <button class="btn-clavier btn col-md-12 h142pxRegular" type="button" data-key="0" >0</button>
                        </div>
                        <div class="actions-container col-md-4 nopadding">
                            <button class="btn-clavier btn col-md-12 h142pxRegular delete" type="button" id="deleteBtn2" ><i class="material-symbols-rounded">chevron_left</i></button>
                            <button class="btn-clavier btn col-md-12 h520pxRegular" id="btnClavierABC" data-toggle="modal" data-target="#clavier-abc" type="button" >ABC</button>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 d-flex vente-directe-left-container ">
                    <%

                        out.println(pi.getFormu().getHtmlInsert());
                    %>
                    <div id="butfillejsp">
                        <%
                            out.println(pi.getFormufle().getHtmlTableauInsert());
                        %>
                        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">

                    </div>
                </div>
                <%--                <div class="col-md-5 d-flex vente-directe-left-container ">--%>
                <%--                    <div class="vente-direct-box">--%>
                <%--                        <h2 class="h617pxSemibold m-0" >Client</h2>--%>
                <%--                        <div class="d-flex input-with-addons">--%>
                <%--                            <input class="form-control ui-autocomplete-input ui-autocomplete-loading" id="idClient_libelle" value="<%= nomClient %>" type="text" oninput="autoCompleteDyn('idClient_libelle','Client','client.Client','','id')")/>--%>
                <%--                            <input  class='form-control' id='idClient' value="<%= idClient %>" name='idClient' type='hidden' />--%>
                <%--                            <button class="btn btn-secondary btn-small"  type="button"><i class="material-symbols-rounded">search</i></button>--%>
                <%--                        </div>--%>
                <%--                        <h3 class="h617pxSemibold ">Résumé des commandes</h3>--%>
                <%--                        <div class="table-container nopadding">--%>
                <%--                            <table class="table" >--%>
                <%--                                <thead>--%>
                <%--                                <tr>--%>
                <%--                                    <th class="contenuetable">--%>
                <%--                                        Image--%>
                <%--                                    </th>--%>
                <%--                                    <th class="contenuetable">--%>
                <%--                                        Article--%>
                <%--                                    </th>--%>
                <%--                                    <th class="contenuetable col-qte">--%>
                <%--                                        Quantit&eacute;--%>
                <%--                                    </th>--%>
                <%--                                    <th class="contenuetable">--%>
                <%--                                        Unit&eacute;--%>
                <%--                                    </th>--%>
                <%--                                    <th class="contenuetable">--%>
                <%--                                        Montant--%>
                <%--                                    </th>--%>
                <%--                                    <th class="contenuetable">--%>
                <%--                                        Action--%>
                <%--                                    </th>--%>
                <%--                                </tr>--%>
                <%--                                </thead>--%>
                <%--                                <tbody  id="panierBody">--%>

                <%--                                </tbody>--%>
                <%--                            </table>--%>
                <%--                        </div>--%>
                <%--                    </div>--%>
                <%--                </div>--%>
                <div class="col-md-3">
                    <div class="d-flex vente-directe-right-container">
                        <h2 class="h520pxSemibold m-0" >R&eacute;sum&eacute; des commandes</h2>
                        <div class="box">
                            <div class="box-body recap-achat upside">
                                <div class="d-flex"><p class="Body14pxRegular" >Sous-total</p> <p id="recapSousTotal" class="Body14pxRegular" >0 Ar</p> </div>
                                <div class="d-flex"><p  class="Body14pxRegular" >Remises totales</p> <p id="recapRemises" class="Body14pxRegular">0 Ar</p> </div>
                            </div>
                            <div class="box-footer total-container">
                                <p class="Body12pxBold" >Total à payer</p>
                                <p id="totalGeneral" class="h142pxBold" style="color: var(--VD-main-color);">0 Ar</p>
                                <input type="hidden" name="totalGeneralInput" id="totalGeneralInput">
                            </div>
                            <div class="box-body recap-achat downside" style="border-top: 1px solid #eee; padding-top: 10px;">
                                <div class="d-flex"><p class="h520pxRegular" >Montant payé</p> <p id="montantPayerTexte" class="h235pxBold" style="color: var(--VD-main-color);">0 Ar</p> </div>
                                <div class="d-flex"><p class="h520pxRegular" >&Agrave; retourner</p> <p id="montantRetourner" class="h235pxBold" style="color: var(--VD-main-color);">0 Ar</p> </div>
                                <input type="hidden" name="aretourner" id="aretourner">
                            </div>
                        </div>
                        <div class="box d-none">
                            <button type="submit" style="margin-right: 8px" class="btn btn-small btn-primary pull-right " onclick="setPaymentMode('espece')">Payer en esp&egrave;ce</button>
                            <button style="margin-right: 8px" class="btn btn-small btn-tertiary pull-right nopadding" data-toggle="modal" data-target="#mvola" type="button" ><img src="${pageContext.request.contextPath}/assets/img/mvola.jpeg" alt="mvola" ></button>
                            <button style="margin-right: 8px" class="btn btn-tertiary btn-small pull-right nopadding" data-toggle="modal" data-target="#airtelmoney" type="button"><img src="${pageContext.request.contextPath}/assets/img/airtel.png" alt="airtel" ></button>
                            <button  style="margin-right: 8px" class="btn btn-tertiary btn-small pull-right nopadding" data-toggle="modal" data-target="#orangemoney" type="button"><img src="${pageContext.request.contextPath}/assets/img/orangemoney.png" alt="orangemoney" ></button>
                            <%--                        <button type="button" style="margin-right: 8px" class="btn btn-small btn-primary pull-left " data-toggle="modal" data-target="#paiement-multiple">Modes de paiement multiples</button>--%>
                            <button  style="margin-right: 8px" class="btn btn-secondary btn-small pull-left " data-toggle="modal" data-target="#cheque" type="button">Payer par ch&egrave;que</button>
                            <button  style="margin-right: 8px" class="btn btn-small btn-secondary pull-left " onclick="setPaymentMode('cartebancaire')" data-toggle="modal" data-target="#virement" type="button">Payer par carte bancaire</button>
                        </div>
                        <label class="toggle-button link">
                            <input type="checkbox" id="multiple-payment">
                            <div class="d-flex">
                                <span class="label">Paiement multiple</span>
                            </div>
                            <input type="hidden" name="multiplePayment" id="multiplePaymentInput" value="false" />
                        </label>
                        <div class="paiement-container">
                            <div class="toggle-container">
                                <label class="toggle-button active">
                                    <input type="radio" name="payment-method" value="especes" checked>
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/payments.png">
                                        <span class="label">Espèces</span>
                                    </div>
                                </label>

                                <label class="toggle-button ">
                                    <input type="radio" name="payment-method" value="cheque">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i> </span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/checkbook.png">
                                        <span class="label">Chèque</span>
                                    </div>
                                </label>
                                <label class="toggle-button">
                                    <input type="radio" name="payment-method" value="mvola">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/mvola.png">
                                    </div>
                                </label>
                                <label class="toggle-button">
                                    <input type="radio" name="payment-method" value="airtel">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/airtel.png">
                                    </div>
                                </label>
                                <label class="toggle-button">
                                    <input type="radio" name="payment-method" value="orange">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/orangemoney.png">
                                    </div>
                                </label>
                                <label class="toggle-button">
                                    <input type="radio" name="payment-method" value="visa">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/visa.png">
                                    </div>
                                </label>
                            </div>
                        </div>
                        <div class="input-container">
                            <%--                            espece--%>
                            <div class="form-input w-100 paiement-section" data-mode="especes">
                                <div class="d-flex" style="justify-content: space-between;align-items: baseline">
                                    <label class="input-label" >Montant payé</label>
                                </div>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span>Espèces</span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" name="valeurEspece" id="valeurEspece" value="" autocomplete="off" />
                                </div>
                            </div>
                            <%--                            mvola--%>
                            <div class="form-input paiement-section d-none" data-mode="mvola">
                                <label class="input-label" >Référence</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span><img src="${pageContext.request.contextPath}/assets/img/mvola.png"> </span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refMvola" name="refMvola"/>
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="mvola">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantMvola" name="montantMvola"/>
                            </div>
                            <%--                            orange money--%>
                            <div class="form-input paiement-section d-none" data-mode="orange">
                                <label class="input-label" >Référence</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span><img src="${pageContext.request.contextPath}/assets/img/orangemoney.png"> </span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refOrange" name="refOrange"/>
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="orange">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantOrange" name="montantOrange"/>
                            </div>
                            <%--                            airtel money--%>
                            <div class="form-input paiement-section d-none" data-mode="airtel">
                                <label class="input-label" >Référence</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span><img src="${pageContext.request.contextPath}/assets/img/airtel.png"> </span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refAirtel" name="refAirtel"/>
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="airtel">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantAirtel" name="montantAirtel"/>
                            </div>


                            <%--                            cheque--%>
                            <div class="form-input paiement-section d-none" data-mode="cheque">
                                <label class="input-label" >Numéro chèque</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span>Cheque</span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refCheque" name="refCheque"/>
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="cheque">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantCheque" name="montantCheque"/>
                            </div>

                            <%--                            visa--%>
                            <div class="form-input paiement-section d-none" data-mode="visa">
                                <label class="input-label" >Référence Visa</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span><img src="${pageContext.request.contextPath}/assets/img/visa.png"></span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refVisa" name="refVisa" />
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="visa">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantVisa" name="montantVisa"/>
                            </div>
                        </div>
                        <div class="d-flex gap-2">
                            <div class="d-flex gap-2" style="flex-direction: column" >
                                <a href="${pageContext.request.contextPath}/pages/module.jsp?but=caisse/mvt/mvtcaisse-entree-pos.jsp" class="btn btn-secondary btn-large btn-autre w-100">Entrée de caisse</a>
                                <a href="${pageContext.request.contextPath}/pages/module.jsp?but=caisse/mvt/mvtcaisse-sortie-pos.jsp" class="btn btn-secondary btn-large btn-autre w-100">Sortie de caisse</a>
                            </div>
                            <button type="submit" id="btnPayer" class="btn btn-primary btn-large w-100" style="justify-content: center;align-items: center">Payer</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="modif" tabindex="-1" role="dialog" aria-labelledby="modif" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-body">
                            <div class="search-result-container">
                                <h6 class="h617pxSemibold m-0">Modifier un article</h6>
                                <div class="table-container nopadding">
                                    <table class="table">
                                        <thead>
                                        <tr>
                                            <th>Photo</th>
                                            <th>Article</th>
                                            <th>ID / Code barre</th>
                                            <th>Prix</th>
                                            <th>Remise</th>
                                            <th>Quantit&eacute;</th>
                                            <th></th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr>
                                            <td><img id="modalPhoto" class="logo" src="" alt="photo du produit"></td>
                                            <td id="modalArticle"></td>
                                            <td id="modalCode"></td>
                                            <td id="modalPrix"></td>
                                            <td>
                                                <input type="text" id="modalRemise" class="form-control" value=""/>
                                            </td>
                                            <td>
                                                <div class="d-flex input-with-addons with-btn-left">
                                                    <button id="modalMinus" class="btn btn-secondary btn-small btn-left" type="button"><i class="material-symbols-rounded">remove</i></button>
                                                    <input type="text" id="modalQuantite" class="form-control" value=""/>
                                                    <button id="modalPlus" class="btn btn-secondary btn-small" type="button"><i class="material-symbols-rounded">add</i></button>
                                                </div>
                                            </td>
                                            <td>
                                                <button id="modalSave" class="btn btn-small btn-primary" type="button" data-dismiss="modal">Enregistrer</button>
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="d-flex">
                                <div class="w-100 clavier-abc-container">
                                    <div class="clavier-range">
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="a" >A</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="z" >Z</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="e" >E</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="r" >R</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="t" >T</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="y" >Y</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="u" >U</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="i" >I</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="o" >O</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="p" >P</button>
                                    </div>
                                    <div class="clavier-range">
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="q" >Q</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="s" >S</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="d" >D</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="f" >F</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="g" >G</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="h" >H</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="j" >J</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="k" >K</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="l" >L</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="m" >M</button>
                                    </div>
                                    <div class="clavier-range">
                                        <button class="btn-clavier btn col-md-3 btn-primary h235pxBold maj" type="button" id="shiftBtn" ><i class="material-symbols-rounded">arrow_upward</i> </button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="w" >W</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="x" >X</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="c" >C</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="v" >V</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="b" >B</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="n" >N</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular delete" type="button" id="deleteBtn" ><i class="material-symbols-rounded">chevron_left</i> </button>
                                    </div>
                                    <div class="clavier-range"><button class="btn-clavier btn col-md-3 change-clavier" onclick="swapclavier()" type="button">123</button>

                                        <button class="btn-clavier btn w-100 space-touch" type="button" >Espace</button>
                                    </div>
                                </div>
                                <div class="clavier-container d-none" >
                                    <div class="numbers col-md-10 nopadding">
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="7" >7</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="8" >8</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="9" >9</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="4" >4</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="5" >5</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="6" >6</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="1" >1</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="2" >2</button>
                                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="3" >3</button>
                                        <button class="btn-clavier btn col-md-12 h142pxRegular" type="button" data-key="0" >0</button>
                                    </div>
                                    <div class="actions-container col-md-4 nopadding">
                                        <button class="btn-clavier btn col-md-12 h142pxRegular delete" type="button" id="deleteBtn2" ><i class="material-symbols-rounded">chevron_left</i></button>
                                        <button class="btn-clavier btn col-md-12 h520pxRegular" onclick="swapclavier()" type="button" >ABC</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="mvola" tabindex="-1" role="dialog" aria-labelledby="mvola" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-body">
                            <div class="search-result-container col-md-12">
                                <div class="form-input w-100 mb-5">
                                    <label class="input-label">Entrez la r&eacute;f&eacute;rence :</label>
                                    <input class="form-control" type="text" id="refMvola" name="mvola-ref" >
                                </div>
                                <div class="col-md-12 nopadding">
                                    <button type="submit" style="margin-right: 8px" class="btn btn-primary pull-right " onclick="setPaymentWithRef('mvola','refMvola')" >Valider</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="clavier-abc" tabindex="-1" role="dialog" aria-labelledby="clavier-abc" aria-hidden="true">
                <div class="modal-dialog clavier" role="document">
                    <div class="modal-content">
                        <div class="modal-body">
                            <div class="w-100 clavier-abc-container">
                                <div class="clavier-range">
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="a" >A</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="z" >Z</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="e" >E</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="r" >R</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="t" >T</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="y" >Y</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="u" >U</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="i" >I</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="o" >O</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="p" >P</button>
                                </div>
                                <div class="clavier-range">
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="q" >Q</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="s" >S</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="d" >D</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="f" >F</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="g" >G</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="h" >H</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="j" >J</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="k" >K</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="l" >L</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="m" >M</button>
                                </div>
                                <div class="clavier-range">
                                    <button class="btn-clavier btn col-md-3 btn-primary h235pxBold maj" type="button" id="shiftBtn" ><i class="material-symbols-rounded">arrow_upward</i> </button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="w" >W</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="x" >X</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="c" >C</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="v" >V</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="b" >B</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="n" >N</button>
                                    <button class="btn-clavier btn col-md-3 h142pxRegular delete" type="button" id="deleteBtn" ><i class="material-symbols-rounded">chevron_left</i> </button>
                                </div>
                                <div class="clavier-range">
                                    <button class="btn-clavier btn col-md-3 change-clavier" data-dismiss="modal" type="button">123</button>
                                    <button class="btn-clavier btn w-100 space-touch" type="button" >Espace</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="orangemoney" tabindex="-1" role="dialog" aria-labelledby="orangemoney" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-body">
                            <div class="search-result-container col-md-12">
                                <div class="form-input w-100 mb-5">
                                    <label class="input-label">Entrez la r&eacute;f&eacute;rence :</label>
                                    <input class="form-control" type="text" id="refOrange" name="orangemoney-ref" >
                                </div>
                                <div class="col-md-12 nopadding">
                                    <button type="submit" style="margin-right: 8px" class="btn btn-primary pull-right " onclick="setPaymentWithRef('orange','refOrange')">Valider</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="airtelmoney" tabindex="-1" role="dialog" aria-labelledby="airtelmoney" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-body">
                            <div class="search-result-container col-md-12">
                                <div class="form-input w-100 mb-5">
                                    <label class="input-label">Entrez la r&eacute;f&eacute;rence :</label>
                                    <input class="form-control" type="text" id="refAirtel" name="airtelmoney-ref" >
                                </div>
                                <div class="col-md-12 nopadding">
                                    <button type="submit" style="margin-right: 8px" class="btn btn-primary pull-right " onclick="setPaymentWithRef('airtel','refAirtel')">Valider</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="cheque" tabindex="-1" role="dialog" aria-labelledby="cheque" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-body">
                            <div class="search-result-container col-md-12">
                                <div class="form-input w-100 mb-5">
                                    <label class="input-label">Entrez le num&eacute;ro du ch&egrave;que :</label>
                                    <input class="form-control" id="refCheque" type="text" name="cheque-ref" >
                                </div>
                                <div class="col-md-12 nopadding">
                                    <button type="submit" style="margin-right: 8px" class="btn btn-primary pull-right " onclick="setPaymentWithRef('cheque','refCheque')">Valider</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="virement" tabindex="-1" role="dialog" aria-labelledby="virement" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-body">
                            <div class="search-result-container col-md-12">
                                <div class="form-input w-100 mb-5">
                                    <label class="input-label">Entrez la r&eacute;f&eacute;rence de la transaction :</label>
                                    <input class="form-control" id="refVirement" type="text" name="virement-ref" >
                                </div>
                                <div class="col-md-12 nopadding">
                                    <button type="submit" style="margin-right: 8px" class="btn btn-primary pull-right " onclick="setPaymentWithRef('virement','refVirement')">Valider</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="paiement-multiple" tabindex="-1" role="dialog" aria-labelledby="paiement-multiple" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-body">
                            <div class="search-result-container col-md-12">
                                <h6 class="h520pxSemibold">Remplissez les informations de paiements</h6>
                                <div class="input-container">
                                    <div class="form-input ">
                                        <label class="input-label">Entrez la r&eacute;f&eacute;rence du virement mvola</label>
                                        <input class="form-control" type="text" name="mvola-ref" >
                                    </div>
                                    <div class="form-input ">
                                        <label class="input-label">Entrez le montant du virement mvola</label>
                                        <input class="form-control" type="text" name="mvola-ref" >
                                    </div>

                                    <div class="form-input ">
                                        <label class="input-label">Entrez la r&eacute;f&eacute;rence du virement orange money</label>
                                        <input class="form-control" type="text" name="mvola-ref" >
                                    </div>
                                    <div class="form-input ">
                                        <label class="input-label">Entrez le montant du virement orange money</label>
                                        <input class="form-control" type="text" name="mvola-ref" >
                                    </div>
                                    <div class="form-input ">
                                        <label class="input-label">Entrez la r&eacute;f&eacute;rence du virement airtel money</label>
                                        <input class="form-control" type="text" name="mvola-ref" >
                                    </div>
                                    <div class="form-input ">
                                        <label class="input-label">Entrez le montant du virement airtel money</label>
                                        <input class="form-control" type="text" name="mvola-ref" >
                                    </div>
                                    <div class="form-input ">
                                        <label class="input-label">Entrez la r&eacute;f&eacute;rence du virement via carte bancaire</label>
                                        <input class="form-control" type="text" name="mvola-ref" >
                                    </div>
                                    <div class="form-input ">
                                        <label class="input-label">Entrez le montant du virement via carte bancaire</label>
                                        <input class="form-control" type="text" name="mvola-ref" >
                                    </div>
                                    <div class="form-input ">
                                        <label class="input-label">Entrez la r&eacute;f&eacute;rence du ch&egrave;que</label>
                                        <input class="form-control" type="text" name="mvola-ref" >
                                    </div>
                                    <div class="form-input ">
                                        <label class="input-label">Entrez le montant du ch&egrave;que</label>
                                        <input class="form-control" type="text" name="mvola-ref" >
                                    </div>
                                    <div class="form-input ">
                                        <label class="input-label">Entrez le montant payer en espèce</label>
                                        <input class="form-control" type="text" name="mvola-ref" >
                                    </div>
                                </div>
                                <div class="col-md-12 nopadding">
                                    <button type="submit" style="margin-right: 8px" class="btn btn-primary pull-right ">Valider l'achat</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <input name="acte" type="hidden" id="nature" value="viserLivrerEncaisser">
            <input name="action" type="hidden" id="action" value="viserLivrerEncaisser">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
            <input name="nomtable" type="hidden" id="nomtable" value="Vente_Details">
        </form>
    </div>
</div>
<div id="globalLoader" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;z-index:99999;background:rgba(255,255,255,0.7);justify-content:center;align-items:center;">
    <div style="text-align:center;">
        <div class="spinner-border"  role="status"></div>
        <div style="margin-top:1rem;font-size:1.2rem;color:(--VD-main-color)">Chargement...</div>
    </div>
</div>
<script>
    const multipleInput = document.getElementById('multiple-payment');
    const hiddenInput = document.getElementById('multiplePaymentInput');

    multipleInput.addEventListener('change', function() {
        hiddenInput.value = this.checked ? 'true' : 'false';
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById("idClientlibelle").value = "<%=nomClient%>";
        document.getElementById("idClient").value = "<%=idClient%>";
        const form = document.getElementById('venteForm');

        form.addEventListener('submit', function(e) {
            const monetaryInputs = [
                'valeurEspece',
                'montantMvola',
                'montantOrange',
                'montantAirtel',
                'montantCheque',
                'montantVisa'
            ];

            monetaryInputs.forEach(inputId => {
                const input = document.getElementById(inputId);
                if (input && input.value) {
                    const rawValue = input.value.replace(/[^\d.]/g, '');
                    input.value = rawValue;
                }
            });

            document.querySelectorAll("input[name^='pu_'], input[name^='prix_'], input[name^='qte_'], input[name^='remiseMontant_']").forEach(input => {
                if (input.value) {
                    const rawValue = input.value.replace(/[^\d.]/g, '');
                    input.value = rawValue;
                }
            });

            const formData = new FormData(form)
            console.log("Form Data before submission1 :", formData);
        });
    });
</script>
<%--paiement multiple--%>
<script>
    // Loader
    var loader = document.getElementById('globalLoader');

    function reactiverBoutonPayer() {
        var btnPayer = document.getElementById('btnPayer');
        var loader = document.getElementById('globalLoader');

        if (btnPayer) {
            btnPayer.disabled = false;
            btnPayer.removeAttribute('disabled');
            btnPayer.classList.remove('btn-payment-processing');

            btnPayer.style.backgroundColor = '';
            btnPayer.style.cursor = 'pointer';
            btnPayer.style.opacity = '1';
            btnPayer.style.pointerEvents = 'auto';
            btnPayer.innerHTML = 'Payer';
        }

        if (loader) {
            loader.style.display = 'none';
            loader.classList.add('d-none');
        }
    }

    window.addEventListener('pageshow', function() {
        reactiverBoutonPayer();
    });
    (function() {
        var originalAlert = window.alert;
        window.alert = function(msg) {
            reactiverBoutonPayer();
            originalAlert.call(window, msg);
        };
    })();
    // Affiche le loader dès le début
    loader.style.display = 'flex';

    // Masque le loader quand la page est complètement chargée
    window.addEventListener('load', function() {
        loader.style.display = 'none';
    });

    // Gestionnaire global d'erreur
    window.addEventListener('error', function() {
        reactiverBoutonPayer();
    });
    window.addEventListener('unhandledrejection', function() {
        reactiverBoutonPayer();
    });

    // Affiche le loader lors de la soumission du formulaire
    document.addEventListener('DOMContentLoaded', function() {
        var form = document.getElementById('venteForm');
        if (form && loader) {
            form.addEventListener('submit', function(e) {
                // e.preventDefault()
                // const row1 = document.getElementById('ligne-multiple-0');
                // row1.remove()
                const formData = new FormData(form)
                console.log("Form Data before submission2 :", formData);
                // Save cart state BEFORE submission
                saveCartState();

                const submitBtn = form.querySelector('button[type="submit"].btn-primary.btn-large');
                if (submitBtn) {
                    submitBtn.style.backgroundColor = '#6c757d';
                    submitBtn.style.cursor = 'not-allowed';
                    submitBtn.style.opacity = '0.7';
                    submitBtn.style.pointerEvents = 'none';
                    submitBtn.innerHTML = 'Paiement en cours...';
                    submitBtn.disabled = true;
                }

                const multiplePayment = document.getElementById('multiple-payment');
                const isMultiplePayment = multiplePayment && multiplePayment.checked;

                if (isMultiplePayment) {
                    loader.style.display = 'flex';
                    loader.classList.remove('d-none');
                    return;
                }

                const totalElement = document.getElementById("totalGeneral");
                const total = parseAmount(totalElement.textContent);
                const selectedRadio = document.querySelector('input[name="payment-method"]:checked');

                if (selectedRadio && selectedRadio.value === 'especes') {
                    const rawValue = document.getElementById('valeurEspece').value.replace(/\D/g, '');
                    const numericValue = rawValue ? parseInt(rawValue, 10) : 0;
                    if (numericValue < total) {
                        if (submitBtn) {
                            submitBtn.classList.remove('btn-payment-processing');
                            submitBtn.textContent = 'Payer';
                            submitBtn.disabled = false;
                        }
                        loader.style.display = 'none';
                        loader.classList.add('d-none');
                        return;
                    }
                }


                loader.style.display = 'flex';
                loader.classList.remove('d-none');
            });
        }
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const multipleInput = document.getElementById('multiple-payment'); // checkbox maintenant
        // on ne prend QUE les toggle buttons des moyens (dans .toggle-container) => exclut "Paiement multiple"
        const paymentButtons = Array.from(document.querySelectorAll('.toggle-container .toggle-button'));
        const sections = Array.from(document.querySelectorAll('.paiement-section'));
        let lastClicked = null;

        // Par défaut : activer "especes"
        paymentButtons.forEach(btn => {
            const inp = btn.querySelector('input[name="payment-method"]');
            if (inp && inp.value === 'especes') {
                btn.classList.add('active');
                lastClicked = btn;
            }
        });

        function updateSections() {
            const activeModes = paymentButtons
                .filter(b => b.classList.contains('active'))
                .map(b => b.querySelector('input[name="payment-method"]').value);

            sections.forEach(sec => {
                const show = activeModes.includes(sec.dataset.mode);
                sec.classList.toggle('d-none', !show);
            });
        }

        // Clique sur un moyen de paiement
        paymentButtons.forEach(btn => {
            btn.addEventListener('click', function(e) {
                // si on est en mode multiple : empêcher le comportement radio standard
                if (multipleInput && multipleInput.checked) {
                    e.preventDefault(); // empêche la radio native (qui forcerait une seule sélection)
                    this.classList.toggle('active');
                } else {
                    // mode single : un seul actif
                    paymentButtons.forEach(b => b.classList.remove('active'));
                    this.classList.add('active');
                }
                lastClicked = this;
                updateSections();
                checkPaymentValidation();
            });
        });

        // Quand on active/désactive "paiement multiple"
        if (multipleInput) {
            multipleInput.addEventListener('change', function() {
                if (!this.checked) {
                    // sortie du mode multiple : ne garder que le dernier cliqué (ou 'especes' par défaut)
                    if (lastClicked) {
                        paymentButtons.forEach(b => {
                            if (b !== lastClicked) b.classList.remove('active');
                        });
                    } else {
                        // fallback : activer "especes"
                        paymentButtons.forEach(b => {
                            const inp = b.querySelector('input[name="payment-method"]');
                            if (inp && inp.value === 'especes') b.classList.add('active');
                            else b.classList.remove('active');
                        });
                    }
                }
                updateSections();
                checkPaymentValidation();
            });
        }

        // initial
        updateSections();
    });

    let paymentValidationState = {
        especes: { valid: false, required: false },
        mvola: { valid: false, required: false },
        orange: { valid: false, required: false },
        airtel: { valid: false, required: false },
        cheque: { valid: false, required: false },
        visa: { valid: false, required: false }
    };

    function checkPaymentValidation() {
        const multiplePayment = document.getElementById('multiple-payment');
        const isMultiplePayment = multiplePayment && multiplePayment.checked;
        const validateButton = document.querySelector('.btn-primary.btn-large');

        if (!isMultiplePayment) {
            validateButton.disabled = false;
            validateButton.style.opacity = '1';
            validateButton.style.cursor = 'pointer';
            return;
        }

        // Check which payment methods are active
        const activeButtons = document.querySelectorAll('.toggle-container .toggle-button.active');

        let allValid = true;
        activeButtons.forEach(btn => {
            const paymentType = btn.querySelector('input[name="payment-method"]').value;

            if (paymentType === 'especes') {
                // Especes only needs amount, not reference
                const amountInput = document.getElementById('valeurEspece');
                const rawValue = amountInput?.value.replace(/\D/g, '');
                const numericValue = rawValue ? parseInt(rawValue, 10) : 0;

                if (numericValue <= 0) {
                    allValid = false;
                }
            } else {
                // Other payment methods need both reference and amount
                const refInputId = getRefInputId(paymentType);
                const montantInputId = getMontantInputId(paymentType);

                const refInput = document.getElementById(refInputId);
                const montantInput = document.getElementById(montantInputId);

                const refValue = refInput?.value.trim() || '';
                const montantRaw = montantInput?.value.replace(/\D/g, '') || '';
                const montantValue = montantRaw ? parseInt(montantRaw, 10) : 0;

                if (refValue === '' || montantValue <= 0) {
                    allValid = false;
                }
            }
        });

        validateButton.disabled = !allValid;
        validateButton.style.opacity = allValid ? '1' : '0.6';
        validateButton.style.cursor = allValid ? 'pointer' : 'not-allowed';
    }

    function getRefInputId(paymentType) {
        const mapping = {
            'mvola': 'refMvola',
            'orange': 'refOrange',
            'airtel': 'refAirtel',
            'cheque': 'refCheque',
            'visa': 'refVisa'
        };
        return mapping[paymentType] || '';
    }

    function getMontantInputId(paymentType) {
        const mapping = {
            'mvola': 'montantMvola',
            'orange': 'montantOrange',
            'airtel': 'montantAirtel',
            'cheque': 'montantCheque',
            'visa': 'montantVisa'
        };
        return mapping[paymentType] || '';
    }
</script>




<script>
    // Variables globales
    let activeInput = null;
    let isShiftActive = false;

    // Fonction pour gérer l'activation des inputs
    function setActiveInput(input) {
        // Retirer la classe active de tous les inputs
        document.querySelectorAll('.form-control').forEach(el => {
            el.classList.remove('active');
        });

        // Ajouter la classe active à l'input cliqué
        if (input) {
            input.classList.add('active');
            activeInput = input;
        }
    }

    // Initialiser les écouteurs sur tous les inputs avec la classe form-control
    function initVirtualKeyboard() {
        document.querySelectorAll('.form-control:not(select)').forEach(input => {
            input.addEventListener('focus', () => {
                setActiveInput(input);
            });

            input.addEventListener('click', () => {
                setActiveInput(input);
            });
        });
    }

    // Fonction pour ajouter du texte à l'input actif
    function addText(char) {
        if (!activeInput) return;

        const cursorPos = activeInput.selectionStart || activeInput.value.length;
        const textBefore = activeInput.value.substring(0, cursorPos);
        const textAfter = activeInput.value.substring(cursorPos);

        if (isShiftActive) {
            activeInput.value = textBefore + char.toUpperCase() + textAfter;
            isShiftActive = false;
            // Désactiver visuellement tous les boutons maj
            document.querySelectorAll('.btn-clavier.maj').forEach(btn => {
                btn.classList.remove('active');
            });
        } else {
            activeInput.value = textBefore + char.toLowerCase() + textAfter;
        }

        // Repositionner le curseur
        const newPos = cursorPos + 1;
        activeInput.setSelectionRange(newPos, newPos);
        activeInput.focus();

        const inputEvent = new Event('input', { bubbles: true, cancelable: true });
        activeInput.dispatchEvent(inputEvent);
    }

    // Fonction pour supprimer un caractère
    function deleteChar() {
        if (!activeInput) return;

        const cursorPos = activeInput.selectionStart || activeInput.value.length;
        if (cursorPos > 0) {
            const textBefore = activeInput.value.substring(0, cursorPos - 1);
            const textAfter = activeInput.value.substring(cursorPos);
            activeInput.value = textBefore + textAfter;

            // Repositionner le curseur
            const newPos = cursorPos - 1;
            activeInput.setSelectionRange(newPos, newPos);
            activeInput.focus();
        }
    }

    // Variables pour la répétition
    let repeatInterval = null;
    let repeatTimeout = null;

    // Fonction pour exécuter l'action d'un bouton
    function executeButtonAction(btn) {
        // 1. Bouton MAJ (Shift) - pas de répétition
        if (btn.classList.contains('maj')) {
            isShiftActive = !isShiftActive;
            btn.classList.toggle('active');
            return false; // Pas de répétition
        }

        // 2. Bouton DELETE (Supprimer)
        if (btn.classList.contains('delete')) {
            deleteChar();
            return true; // Répétition activée
        }

        // 3. Bouton ESPACE
        if (btn.classList.contains('space-touch')) {
            addText(' ');
            return true; // Répétition activée
        }

        // 5. Boutons normaux avec data-key (lettres et chiffres)
        const key = btn.getAttribute('data-key');
        if (key) {
            addText(key);
            return true; // Répétition activée
        }

        // 6. Fallback : utiliser le texte du bouton si pas de data-key
        const btnText = btn.textContent.trim();
        if (btnText && btnText !== 'ABC' && btnText !== '123' && btnText !== 'Espace') {
            addText(btnText);
            return true; // Répétition activée
        }

        return false;
    }

    // Fonction pour arrêter la répétition
    function stopRepeat() {
        if (repeatTimeout) {
            clearTimeout(repeatTimeout);
            repeatTimeout = null;
        }
        if (repeatInterval) {
            clearInterval(repeatInterval);
            repeatInterval = null;
        }
    }

    // Initialisation au chargement du DOM
    document.addEventListener('DOMContentLoaded', function() {
        // Initialiser le clavier virtuel
        initVirtualKeyboard();

        // Gérer TOUS les boutons du clavier de manière généralisée
        document.querySelectorAll('.btn-clavier').forEach(btn => {
            // Gestion du mousedown pour démarrer la répétition
            btn.addEventListener('mousedown', (e) => {
                e.preventDefault();

                // Exécuter l'action immédiatement
                const shouldRepeat = executeButtonAction(btn);

                // Si le bouton doit se répéter
                if (shouldRepeat) {
                    // Attendre 500ms avant de commencer la répétition
                    repeatTimeout = setTimeout(() => {
                        // Répéter toutes les 100ms
                        repeatInterval = setInterval(() => {
                            executeButtonAction(btn);
                        }, 100);
                    }, 500);
                }
            });

            // Arrêter la répétition quand on relâche le bouton
            btn.addEventListener('mouseup', stopRepeat);
            btn.addEventListener('mouseleave', stopRepeat);

            // Support tactile pour mobile
            btn.addEventListener('touchstart', (e) => {
                e.preventDefault();
                const shouldRepeat = executeButtonAction(btn);

                if (shouldRepeat) {
                    repeatTimeout = setTimeout(() => {
                        repeatInterval = setInterval(() => {
                            executeButtonAction(btn);
                        }, 100);
                    }, 500);
                }
            });

            btn.addEventListener('touchend', stopRepeat);
            btn.addEventListener('touchcancel', stopRepeat);

            btn.addEventListener('mousedown', function() {
                btn.classList.add('is-active');
            });
            btn.addEventListener('mouseup', function() {
                btn.classList.remove('is-active');
            });
            btn.addEventListener('mouseleave', function() {
                btn.classList.remove('is-active');
            });
            // For touch devices
            btn.addEventListener('touchstart', function() {
                btn.classList.add('is-active');
            });
            btn.addEventListener('touchend', function() {
                btn.classList.remove('is-active');
            });
            btn.addEventListener('touchcancel', function() {
                btn.classList.remove('is-active');
            });
        });

        // Arrêter la répétition si on relâche en dehors du document
        document.addEventListener('mouseup', stopRepeat);
        document.addEventListener('touchend', stopRepeat);
    });

    // Save cart state before form submission
    function saveCartState() {
        const cartState = {
            products: gatherProductData(),
            client: {
                id: document.getElementById('idClient')?.value || '',
                nom: document.getElementById('idClient_libelle')?.value || ''
            },
            productPreview: {
                photo: document.getElementById('selectedProductImage')?.src || '',
                name: document.getElementById('selectedProductName')?.textContent || '',
                code: document.getElementById('selectedProductCode')?.textContent || '',
                price: document.getElementById('selectedProductPrice')?.textContent || ''
            },
            timestamp: Date.now()
        };

        sessionStorage.setItem('cartStateBeforeSubmit', JSON.stringify(cartState));
        console.log('Cart state saved:', cartState);
    }

    // Restore cart state after page reload
    function restoreCartState() {
        const savedState = sessionStorage.getItem('cartStateBeforeSubmit');

        if (!savedState) {
            console.log('No saved cart state found');
            return;
        }

        try {
            const cartState = JSON.parse(savedState);

            // Check if state is less than 5 minutes old
            if (Date.now() - cartState.timestamp > 300000) {
                sessionStorage.removeItem('cartStateBeforeSubmit');
                return;
            }

            // Restore client
            if (cartState.client.id) {
                const idClientInput = document.getElementById('idClient');
                const idClientLibelleInput = document.getElementById('idClient_libelle');
                if (idClientInput) idClientInput.value = cartState.client.id;
                if (idClientLibelleInput) idClientLibelleInput.value = cartState.client.nom;
            }

            // Restore products
            if (cartState.products && cartState.products.length > 0) {
                const tbody = document.getElementById("panierBody");
                if (!tbody) return;

                // Clear existing rows
                tbody.innerHTML = '';

                cartState.products.forEach((product, index) => {
                    restoreProductRow(product, index);
                });

                updateTotals();
                sync();
            }

            // Restore product preview
            if (cartState.productPreview && cartState.productPreview.name) {
                updateProductPreview(cartState.productPreview);
            }

            console.log('Cart state restored successfully');

            // Clear the saved state after successful restore
            sessionStorage.removeItem('cartStateBeforeSubmit');

        } catch (error) {
            console.error('Error restoring cart state:', error);
            sessionStorage.removeItem('cartStateBeforeSubmit');
        }
    }

    // Helper function to restore a single product row
    function restoreProductRow(product, rowCount) {
        console.log('product => ', product);
        const tbody = document.getElementById("panierBody");
        if (!tbody) return;

        const row = document.createElement("tr");

        // Hidden inputs
        const hiddenID = document.createElement("input");
        hiddenID.type = "hidden";
        hiddenID.value = product.id;
        hiddenID.name = "idProduit_" + rowCount;
        hiddenID.id = "idProduit_" + rowCount;
        row.appendChild(hiddenID);

        const hiddenEstEnGros = document.createElement("input");
        hiddenEstEnGros.type = "hidden";
        hiddenEstEnGros.name = "estEnGros_" + rowCount;
        hiddenEstEnGros.value = "0";
        row.appendChild(hiddenEstEnGros);

        const ids = document.createElement("input");
        ids.type = "hidden";
        ids.value = rowCount;
        ids.name = "ids";
        row.appendChild(ids);

        // Photo hidden input
        const photoInput = document.createElement("input");
        photoInput.type = "hidden";
        photoInput.name = "photo_" + rowCount;
        photoInput.value = product.urlPhoto || '';
        row.appendChild(photoInput);

        // Designation hidden input
        const designationInput = document.createElement("input");
        designationInput.type = "hidden";
        designationInput.name = "designation_" + rowCount;
        designationInput.value = product.designation;
        row.appendChild(designationInput);

        const referenceInput = document.createElement("input");
        referenceInput.type = "hidden";
        referenceInput.name = "reference_" + rowCount;
        referenceInput.value = product.reference || '';
        row.appendChild(referenceInput);

        // Quantity hidden input
        const qteInput = document.createElement("input");
        qteInput.type = "hidden";
        qteInput.name = "qte_" + rowCount;
        qteInput.value = product.quantite;
        row.appendChild(qteInput);

        // Price hidden input
        const puInput = document.createElement("input");
        puInput.type = "hidden";
        puInput.name = "pu_" + rowCount;
        puInput.value = product.prixunitaire;
        row.appendChild(puInput);

        // Remise hidden input
        const remiseInput = document.createElement("input");
        remiseInput.type = "hidden";
        remiseInput.name = "remiseMontant_" + rowCount;
        remiseInput.value = product.remiseMontant || 0;
        row.appendChild(remiseInput);

        // Prix total hidden input
        const prixInput = document.createElement("input");
        prixInput.type = "hidden";
        prixInput.name = "prix_" + rowCount;
        prixInput.value = (product.quantite * product.prixunitaire) - (product.remiseMontant || 0);
        row.appendChild(prixInput);

        // Unit hidden input
        const uniteInput = document.createElement("input");
        uniteInput.type = "hidden";
        uniteInput.name = "unite_" + rowCount;
        uniteInput.value = product.isWeightBased ? "UNT00004" : "UNT00001";
        row.appendChild(uniteInput);

        // Base price hidden input
        const basePriceInput = document.createElement("input");
        basePriceInput.type = "hidden";
        basePriceInput.name = "basePriceKg_" + rowCount;
        basePriceInput.value = product.originalPrice || product.prixunitaire;
        row.appendChild(basePriceInput);

        // Column 1: Image
        const imgCell = document.createElement("td");
        imgCell.className = "contenuetable";
        const img = document.createElement("img");
        img.className = "product-img";
        img.src = resolveProductImage(product.urlPhoto);
        img.onerror = function() { this.src = productImageFallback; };
        imgCell.appendChild(img);
        row.appendChild(imgCell);

        // Column 2: Article name and price
        const articleCell = document.createElement("td");
        articleCell.className = "contenuetable";
        const productDetail = document.createElement("div");
        productDetail.className = "d-flex product-detail";
        const productName = document.createElement("span");
        productName.className = "Body14pxSemiBold";
        productName.textContent = product.designation;
        const productPrice = document.createElement("span");
        productPrice.className = "Body14pxRegular";

        let displayPrice = product.prixunitaire;
        if (product.isWeightBased) {
            displayPrice = roundToNearest100(product.prixunitaire);
        }
        productPrice.textContent = formatAmount(displayPrice, true);

        productDetail.appendChild(productName);
        productDetail.appendChild(productPrice);
        articleCell.appendChild(productDetail);
        row.appendChild(articleCell);

        // Column 3: Quantity
        const qteCell = document.createElement("td");
        qteCell.className = "contenuetable col-qte";
        const qteAction = document.createElement("div");
        qteAction.className = "d-flex gap-1 qte-action";

        const minusBtn = document.createElement("button");
        minusBtn.className = "btn btn-primary btn-small minus-btn-qte";
        minusBtn.type = "button";
        minusBtn.innerHTML = '<i class="material-symbols-rounded">remove</i>';
        minusBtn.onclick = function() {
            const qteVisibleInput = row.querySelector(".qte-editable-input");
            const qteHiddenInput = row.querySelector("input[name^='qte_']");
            const currentQte = parseAmount(qteVisibleInput?.value || 0);
            const newQte = Math.max(currentQte - 1, 0);
            qteHiddenInput.value = newQte;
            qteVisibleInput.value = newQte;
            updateTotals();
            sync();
        };

        const qteVisibleInput = document.createElement("input");
        qteVisibleInput.type = "text";
        qteVisibleInput.className = "qte-editable-input Body14pxSemiBold";
        qteVisibleInput.value = product.quantite;

        qteVisibleInput.addEventListener('focus', function() { setActiveInput(this); });
        qteVisibleInput.addEventListener('click', function() { setActiveInput(this); });

        qteVisibleInput.addEventListener('keydown', function(e) {
            if ([46, 8, 9, 27, 13].includes(e.keyCode) ||
                (e.keyCode === 65 && e.ctrlKey === true) ||
                (e.keyCode >= 35 && e.keyCode <= 39)) {
                return;
            }
            if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) &&
                (e.keyCode < 96 || e.keyCode > 105) &&
                e.keyCode !== 188 && e.keyCode !== 190 && e.keyCode !== 110) {
                e.preventDefault();
            }
        });

        const plusBtn = document.createElement("button");
        plusBtn.className = "btn btn-primary btn-small plus-btn-qte";
        plusBtn.type = "button";
        plusBtn.innerHTML = '<i class="material-symbols-rounded">add</i>';
        plusBtn.onclick = function() {
            const qteVisibleInput = row.querySelector(".qte-editable-input");
            const qteHiddenInput = row.querySelector("input[name^='qte_']");
            const currentQte = parseAmount(qteVisibleInput?.value || 0);
            const newQte = currentQte + 1;
            qteHiddenInput.value = newQte;
            qteVisibleInput.value = newQte;
            updateTotals();
            sync();
        };

        qteAction.appendChild(minusBtn);
        qteAction.appendChild(qteVisibleInput);
        qteAction.appendChild(plusBtn);
        qteCell.appendChild(qteAction);
        row.appendChild(qteCell);

        // Column 4: Unit
        const unitCell = document.createElement("td");
        unitCell.className = "contenuetable";
        const unitSpan = document.createElement("span");
        unitSpan.className = "Body14pxRegular";
        unitSpan.textContent = product.isWeightBased ? "Gramme" : "Unité";
        unitCell.appendChild(unitSpan);
        row.appendChild(unitCell);

        const montantCell = document.createElement("td");
        montantCell.className = "contenuetable montant-row";
        let initialAmount = 0;
        if (product.isWeightBased) {
            // If weight based: (Qty * BasePrice) / 1000
            initialAmount = (product.quantite * (product.originalPrice || product.prixunitaire)) / 1000;
        } else {
            // If unit based: Qty * Price
            initialAmount = product.quantite * product.prixunitaire;
        }
        if(product.remiseMontant) {
            initialAmount -= product.remiseMontant;
        }
        montantCell.textContent = formatAmount(Math.max(initialAmount, 0), true);
        row.appendChild(montantCell);

        // Column 5: Actions
        const actionCell = document.createElement("td");
        actionCell.className = "contenuetable";
        const removeBtn = document.createElement("button");
        removeBtn.className = "btn btn-danger btn-small";
        removeBtn.type = "button";
        removeBtn.innerHTML = '<i class="material-symbols-rounded">delete</i>';
        removeBtn.onclick = function() { removeProductRow(this); };
        actionCell.appendChild(removeBtn);
        row.appendChild(actionCell);

        // Store data in row dataset
        row.dataset.productPhoto = product.urlPhoto || '';
        row.dataset.productName = product.designation;
        row.dataset.productReference = product.reference || '';
        row.dataset.productPrice = product.prixunitaire;
        row.dataset.productOriginalPrice = product.originalPrice || product.prixunitaire;

        tbody.appendChild(row);
    }

    // Rendre les fonctions disponibles globalement
    window.setActiveInput = setActiveInput;
    window.initVirtualKeyboard = initVirtualKeyboard;
</script>
<script>
    function swapclavier(){
        e.preventDefault();
        $('.modal-body .clavier-container').toggleClass('d-none');
        $('.clavier-abc-container').toggleClass('d-none');
    }
</script>
<%--par defaut eo @ produit ny cursor--%>
<script>
    function focusOnProduit() {
        const input = document.getElementById("idProduit_libelle");
        if (input) {
            input.focus();
        }
    }
    //gestion de focus sur recherche produit
    window.onload = function() {
        focusOnProduit();

        // RESTORE CART STATE FIRST
        restoreCartState();

        const observer = new MutationObserver(() => {
            const activeElement = document.activeElement;
            const isUserTyping = activeElement && (
                activeElement.id === 'idClient_libelle' ||
                activeElement.classList.contains('ui-autocomplete-input') ||
                activeElement.tagName === 'INPUT'
            );

            if (!isUserTyping) {
                focusOnProduit();
            }
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true,
            attributes: true
        });

        sendMessage("BIENVENUE !!!");
    };
</script>

<script src="/savonnerie/dist/js/socket.io.min.js"></script>
<script>

    const amountFormatter = new Intl.NumberFormat('fr-FR', {
        minimumFractionDigits: 0,
        maximumFractionDigits: 2
    });
    const productImageFallback = '${pageContext.request.contextPath}/assets/img/products/no_image.png';

    function getIdNumber() {
        const ids = [];
        // Sélectionner tous les inputs dont le name commence par "designation_"
        const designations = document.querySelectorAll("input[name^='designation_']");
        if (!designations || designations.length == 0) {
            ids.push(0);
        }
        else
        {
            designations.forEach(input => {
                const match = input.name.match(/^designation_(\d+)$/);
                if (match) {
                    ids.push(parseInt(match[1], 10));
                }
            });
        }
        return ids;
    }

    function sync() {
        setupListeners();
        // Optionnel : appeler gatherProductData() pour initialiser l'état
        const products = gatherProductData();
        save(products);
        console.log("product sync", products);
    }

    function parseAmount(value) {
        if (value === null || value === undefined) {
            return 0;
        }
        const normalized = value.toString()
            .replace(/Ar/gi, '')
            .replace(/[\s\u00A0]/g, '')
            .replace(/,/g, '.');
        const parsed = Number(normalized);
        return Number.isFinite(parsed) ? parsed : 0;
    }

    function formatAmount(value, withCurrency) {
        const formatted = amountFormatter.format(Number(value) || 0);
        return withCurrency ? formatted + ' Ar' : formatted;
    }

    function setCellDisplay(cell, text) {
        if (!cell) {
            return;
        }
        Array.from(cell.childNodes).forEach(node => {
            if (node.nodeType === 3 && node.textContent.trim() !== '') {
                cell.removeChild(node);
            }
        });
        const hiddenInputs = cell.querySelectorAll("input[type='hidden']");
        let span = cell.querySelector('.cell-value');
        if (!span) {
            span = document.createElement('span');
            span.className = 'cell-value';
            if (hiddenInputs.length > 0) {
                cell.insertBefore(span, hiddenInputs[0]);
            } else {
                cell.appendChild(span);
            }
        }
        // span.textContent = text;
    }

    function getCellDisplay(cell) {
        if (!cell) {
            return '';
        }
        const span = cell.querySelector('.cell-value');
        if (span) {
            return span.textContent.trim();
        }
        return cell.textContent.trim();
    }


    function parseWeightBarcode(barcode) {
        const cleaned = barcode.trim();
        const codeLen = 13;
        console.log("Full barcode scanned:", cleaned);
        console.log("Barcode length:", cleaned.length);

        if (cleaned.length < codeLen) {
            return { isWeightBased: false, productCode: null, weight: null };
        }

        const prefix = cleaned.substring(0, 2);
        const productCode = cleaned.substring(4, 7);
        const weightStr = cleaned.substring(7, 12);
        const weight = parseInt(weightStr, 10);

        return {
            isWeightBased: true,
            productCode: productCode,
            weight: isNaN(weight) ? 0 : weight
        };
    }

    async function getProductByBarcode(barcode) {
        const barcodeInfo = parseWeightBarcode(barcode);

        try {
            const response = await fetch(`${pageContext.request.contextPath}/ApresTarif?acte=pos&reference=${barcodeInfo.productCode}`);
            const data = await response.json();

            if (data.productPos) {
                console.log('Product retrieved from barcode:', data.productPos);
                return {
                    product: data.productPos,
                    barcodeInfo: barcodeInfo,
                    isWeightUnit: data.productPos.unite === "UNT00004"
                };
            } else {
                console.log('No product found for reference:', barcodeInfo.productCode);
                return { product: null, error: "Product not found" };
            }
        } catch (error) {
            console.error('Error fetching product by barcode:', error);
            return { product: null, error: error.message };
        }
    }

    window.parseWeightBarcode = parseWeightBarcode;
    window.formatAmount = formatAmount;
    window.parseAmount = parseAmount;
    window.setCellDisplay = setCellDisplay;
    window.getCellDisplay = getCellDisplay;
    window.refreshProductPreview = refreshProductPreview;
    window.removeProductRow = removeProductRow;

    function resolveProductImage(photo) {
        console.log({photo})
        if (!photo) {
            return `${pageContext.request.contextPath}/assets/img/products/no_image.png`;
        }
        if (/^https?:\/\//i.test(photo)) {
            return photo;
        }
        return `${pageContext.request.contextPath}/assets/img/produit/`+photo;
    }

    // Exemple d'utilisation
    const img = document.createElement("img");
    img.className = "logo";
    img.alt = "photo du produit";

    img.src = resolveProductImage(val);

    // imageFallback
    img.onerror = function() {
        this.onerror = null; // empêche boucle infinie
        this.src = `${pageContext.request.contextPath}/assets/img/products/no_image.png`;
    };

    cell.appendChild(img);


    function updateProductPreview({ photo, name, code, price }) {
        console.log({photo})

        const box = document.getElementById('selectedProductBox');
        if (!box) {
            return;
        }

        box.classList.remove('d-none');

        const imageElement = document.getElementById('selectedProductImage');
        if (imageElement) {
            imageElement.src = resolveProductImage(photo);
            imageElement.onerror = function () {
                this.onerror = null;
                this.src = productImageFallback;
            };
        }

        const nameElement = document.getElementById('selectedProductName');
        if (nameElement) {
            nameElement.textContent = name && name.trim() !== '' ? name : 'Aucun produit';
        }

        const codeElement = document.getElementById('selectedProductCode');
        if (codeElement) {
            // Use reference instead of ID
            codeElement.textContent = code && code.trim() !== '' ? code : '--';
        }

        const priceElement = document.getElementById('selectedProductPrice');
        if (priceElement) {
            const numericPrice = parseAmount(price);
            priceElement.textContent = formatAmount(numericPrice, true);
        }
    }

    function hideProductPreview() {
        const box = document.getElementById('selectedProductBox');
        if (!box) {
            return;
        }
        box.classList.add('d-none');
    }

    function refreshProductPreview(previewData) {
        if (previewData && (previewData.name || previewData.photo || previewData.code)) {
            updateProductPreview(previewData);
            return;
        }

        const rows = document.querySelectorAll('#panierBody tr');
        if (!rows.length) {
            hideProductPreview();
            return;
        }

        const lastRow = rows[rows.length - 1];
        const data = {
            photo: lastRow?.dataset?.productPhoto || '',
            name: lastRow?.dataset?.productName || '',
            code: lastRow?.dataset?.productReference || lastRow?.dataset?.productCode || '',
            price: lastRow?.dataset?.productOriginalPrice || lastRow?.dataset?.productPrice || ''
        };
        updateProductPreview(data);
    }

    function removeProductRow(button) {
        const row = button.closest('tr');
        if (!row) {
            return;
        }
        row.remove();
        updateTotals();
        refreshProductPreview();
        sync();
    }

    function adjustModalQuantity(delta) {
        const modalQuantite = document.getElementById("modalQuantite");
        if (!modalQuantite) {
            return;
        }

        const currentValue = parseAmount(modalQuantite.value || 0);
        const updated = Math.max(currentValue + delta, 0);
        modalQuantite.value = Number.isInteger(updated) ? updated : updated.toFixed(2);
    }

    document.addEventListener("click", function (e) {
        const modifierBtn = e.target.closest(".btn-modifier");
        if (!modifierBtn) {
            return;
        }

        const tr = modifierBtn.closest("tr");
        if (!tr) {
            return;
        }

        const cells = Array.from(tr.querySelectorAll("td"));
        if (cells.length < 7) {
            return;
        }

        const modalPhoto = document.getElementById("modalPhoto");
        const modalArticle = document.getElementById("modalArticle");
        const modalCode = document.getElementById("modalCode");
        const modalPrix = document.getElementById("modalPrix");
        const modalRemise = document.getElementById("modalRemise");
        const modalQuantite = document.getElementById("modalQuantite");

        const articleCell = cells[1];
        const codeCell = cells[2];
        const quantiteCell = cells[3];
        const prixUnitaireCell = cells[4];
        const remiseCell = cells[5];

        if (modalPhoto) {
            const photo = tr.querySelector("img")?.src || "";
            modalPhoto.src = photo;
        }
        if (modalArticle) {
            modalArticle.textContent = getCellDisplay(articleCell);
        }
        if (modalCode) {
            modalCode.textContent = getCellDisplay(codeCell);
        }
        if (modalPrix) {
            modalPrix.textContent = getCellDisplay(prixUnitaireCell);
        }

        const quantiteValue = parseAmount(tr.querySelector("input[name^='qte_']")?.value || getCellDisplay(quantiteCell));
        const remiseValue = parseAmount(tr.querySelector("input[name^='remiseMontant_']")?.value || getCellDisplay(remiseCell));

        if (modalQuantite) {
            modalQuantite.value = Number.isInteger(quantiteValue) ? quantiteValue : quantiteValue.toFixed(2);
        }
        if (modalRemise) {
            modalRemise.value = remiseValue.toString();
        }
    });

    function autoCompleteDyn(inputID, table, classe, champRetour,valeur) {
        let input = document.getElementById(inputID);
        if (!input) {
            return;
        }
        input.addEventListener('keydown', function (event) {
            if (event.key === 'Enter' || event.key === 'Tab') {
                event.preventDefault();
                let prest = input.value;
                if (prest != null && prest.trim() !== "") {
                    let temp = prest.split("::");
                    input.value = temp[0].trim();
                }
            } else {

                $('#' + inputID).autocomplete({
                    source: function (request, response) {
                        let rep =  fetchAutocomplete(request, response, "null", valeur, "null", table, classe, "true",champRetour,"null");
                        console.log("REP", rep)
                    },
                    minLength: 0,
                    select: function (event, ui) {
                        let selectedObj = ui.item;
                        let prest = selectedObj.value;
                        let temp = prest.split("::");
                        let compte = temp[0].trim();

                        let prest2 = selectedObj.label;
                        let temp2 = prest2.split("::");
                        let compte2 = temp2[0].trim();

                        document.getElementById(inputID).value = compte2;
                        let tempinput = inputID.split("_");
                        console.log(selectedObj);
                        console.log(compte2);
                        console.log('#',inputID);
                        console.log('#',tempinput[0])
                        $('#'+tempinput[0]).val(compte)
                        document.getElementById(tempinput[0]).dispatchEvent(new Event("change"));

                        setTimeout(() => {
                            const input = document.getElementById(inputID);
                            input.value = compte2;
                            console.log('Set value:', input.value);

                            // Après sélection du client, refocuser sur le champ produit
                            if (inputID === 'idClient_libelle') {
                                setTimeout(() => {
                                    focusOnProduit();
                                }, 100);
                            }
                        }, 10);

                        return false;
                    }
                });
            }
        });
    }

    // autocomplete efa tonga de miselectionner produit hoazy raha iray ilay resultat hitany
    function autoCompleteVenteDirect(inputID, table, classe, champRetour, inputNom, valeur) {
        const champsBase = champRetour.split(";").filter(c => !c.includes("="));
        const inputNames = inputNom.split(";");

        const defaults = {};
        champRetour.split(";").forEach(c => {
            if (c.includes("=")) {
                const [key, val] = c.split("=");
                defaults[key] = val;
            }
        });

        let input = document.getElementById(inputID);
        if (!input) return;

        $('#' + inputID).autocomplete({
            source: function(request, response) {
                const searchTerm = request.term;
                const barcodeInfo = parseWeightBarcode(searchTerm);
                console.log("BARCODE  INFO",barcodeInfo)

                if (barcodeInfo.isWeightBased) {
                    const productCode = barcodeInfo.productCode;
                    const codegrosSearchRequest = { term: productCode };
                    fetchAutocomplete(codegrosSearchRequest, function(codegrosResults) {
                        console.log("Codegros search results:", codegrosResults);

                        const codegrosMatch = codegrosResults.find(result => {
                            let codegros = '';
                            const values = (result.retour || "").split(";");
                            champsBase.forEach((col, idx) => {
                                if (col === 'codegros' && values[idx]) {
                                    codegros = values[idx].toString();
                                }
                            });

                            if (!codegros) {
                                const valueParts = result.value.split(' - ');
                                console.log('===> valueParts', valueParts);
                                for (let i = 0; i < valueParts.length; i++) {
                                    let valiny = '[' + i + ']' + ' ===> '  + valueParts[i];
                                    console.log('valiny ======> ', valiny);
                                }
                                if (valueParts.length >= 5) {
                                    codegros = valueParts[4]; // codegros is the 5th element (0-indexed: 4)
                                }
                            }
                            return codegros === productCode;
                        });

                        if (codegrosMatch) {
                            const values = (codegrosMatch.retour || "").split(";");
                            let codegros = '', reference = '', pvgros = '', pv = '';
                            champsBase.forEach((col, idx) => {
                                if (col === 'codegros' && values[idx]) codegros = values[idx].toString();
                                if (col === 'reference' && values[idx]) reference = values[idx].toString();
                                if (col === 'pvgros' && values[idx]) pvgros = values[idx].toString();
                                if (col === 'pv' && values[idx]) pv = values[idx].toString();
                            });

                            handleProductSelection(codegrosMatch, inputID, champRetour, inputNom, valeur, defaults, barcodeInfo.weight);
                            $('#' + inputID).autocomplete("close");
                        } else {
                            fetchAutocompletePrecis(codegrosSearchRequest, function(refResults) {
                                if (refResults && refResults.length > 0) {
                                    const single = refResults[0];
                                    handleProductSelection(single, inputID, champRetour, inputNom, valeur, defaults, barcodeInfo.weight);
                                    $('#' + inputID).autocomplete("close");
                                } else {
                                    response(refResults);
                                }
                            }, "null", valeur, "null", table, classe, "true", champsBase.join(";"), "null", "true");
                        }
                    }, "null", valeur, "null", table, classe, "true", champsBase.join(";"), "null");
                } else {
                    console.log("Regular search term, not weight-based");
                    const searchRequest = { term: searchTerm };
                    fetchAutocomplete(searchRequest, function(results) {
                        console.log("Search results for non-weight code:", results);
                        if (searchTerm.length < 3) {
                            response(results);
                            return;
                        }

                        const resultArray = (results && results.valeure) ? results.valeure : (Array.isArray(results) ? results : []);
                        console.log(" result ", resultArray);
                        /* 
                        if (resultArray.length === 1) {
                            handleProductSelection(resultArray[0], inputID, champRetour, inputNom, valeur, defaults);
                            $('#' + inputID).autocomplete("close");
                            return;
                        }
                        */
                        if (results && results.length === 1) {
                            const single = results[0];
                            const term = searchTerm.trim().toLowerCase();
                            const values = (single.retour || "").split(";");
                            let isExactMatch = false;

                            champsBase.forEach((col, idx) => {
                                if (values[idx]) {
                                    const val = values[idx].toString().toLowerCase().trim();
                                    if (val === term) {
                                        isExactMatch = true;
                                    }
                                }
                            });

                            if (!isExactMatch) {
                                if ((single.label && single.label.toLowerCase() === term) ||
                                    (single.value && single.value.toLowerCase() === term)) {
                                    isExactMatch = true;
                                }
                            }

                            if (isExactMatch) {
                                handleProductSelection(single, inputID, champRetour, inputNom, valeur, defaults);
                                $('#' + inputID).autocomplete("close");
                            }
                        }


                        const wholesaleMatch = results.find(result => {
                            let codegros = '';
                            const values = (result.retour || "").split(";");
                            champsBase.forEach((col, idx) => {
                                if (col === 'codegros' && values[idx]) {
                                    codegros = values[idx].toString();
                                }
                            });

                            if (!codegros) {
                                const valueParts = result.value.split(' - ');
                                if (valueParts.length >= 5) {
                                    codegros = valueParts[4]; // codegros is the 5th element (0-indexed: 4)
                                }
                            }

                            return codegros === searchTerm;
                        });

                        if (wholesaleMatch) {
                            const values = (wholesaleMatch.retour || "").split(";");
                            let codegros = '', reference = '', pvgros = '', pv = '';
                            champsBase.forEach((col, idx) => {
                                if (col === 'codegros' && values[idx]) codegros = values[idx].toString();
                                if (col === 'reference' && values[idx]) reference = values[idx].toString();
                                if (col === 'pvgros' && values[idx]) pvgros = values[idx].toString();
                                if (col === 'pv' && values[idx]) pv = values[idx].toString();
                            });

                            handleProductSelection(wholesaleMatch, inputID, champRetour, inputNom, valeur, defaults);
                            $('#' + inputID).autocomplete("close");
                        } else {
                            response(results);
                            if (results && results.length === 1) {
                                const single = results[0];
                                const term = searchTerm.trim().toLowerCase();
                                const values = (single.retour || "").split(";");
                                let isExactMatch = false;

                                champsBase.forEach((col, idx) => {
                                    if (values[idx]) {
                                        const val = values[idx].toString().toLowerCase().trim();
                                        if (val === term) {
                                            isExactMatch = true;
                                        }
                                    }
                                });

                                if (!isExactMatch) {
                                    if ((single.label && single.label.toLowerCase() === term) ||
                                        (single.value && single.value.toLowerCase() === term)) {
                                        isExactMatch = true;
                                    }
                                }

                                if (isExactMatch) {
                                    handleProductSelection(single, inputID, champRetour, inputNom, valeur, defaults);
                                    $('#' + inputID).autocomplete("close");
                                }
                            }
                        }
                    }, "null", valeur, "null", table, classe, "true", champsBase.join(";"), "null");
                }
            },
            minLength: 0,
            select: function(event, ui) {
                const currentInput = $('#' + inputID).val();
                const barcodeInfo = parseWeightBarcode(currentInput);

                if (barcodeInfo.isWeightBased) {
                    let codegros = '';
                    const values = (ui.item.retour || "").split(";");
                    champsBase.forEach((col, idx) => {
                        if (col === 'codegros' && values[idx]) {
                            codegros = values[idx].toString();
                        }
                        if (col === 'unite' && values[idx]) {
                            unite = values[idx].toString();
                        }
                    });

                    ui.item.unite = unite;

                    if (!codegros) {
                        const valueParts = ui.item.value.split(' - ');
                        if (valueParts.length >= 5) {
                            codegros = valueParts[4]; // codegros is the 5th element (0-indexed: 4)
                        }
                    }


                    const isWholesale = codegros === barcodeInfo.productCode;
                    handleProductSelection(ui.item, inputID, champRetour, inputNom, valeur, defaults, barcodeInfo.weight);
                } else {
                    let codegros = '';
                    const values = (ui.item.retour || "").split(";");
                    champsBase.forEach((col, idx) => {
                        if (col === 'codegros' && values[idx]) {
                            codegros = values[idx].toString();
                        }
                    });

                    if (!codegros) {
                        const valueParts = ui.item.value.split(' - ');
                        if (valueParts.length >= 5) {
                            codegros = valueParts[4]; // codegros is the 5th element (0-indexed: 4)
                        }
                    }
                    if (codegros === currentInput) {
                        handleProductSelection(ui.item, inputID, champRetour, inputNom, valeur, defaults);
                    } else {
                        handleProductSelection(ui.item, inputID, champRetour, inputNom, valeur, defaults);
                    }
                }
                return false;
            }
        });
    }

    function handleProductSelection(selectedObj, inputID, champRetour, inputNom, valeur, defaults, overrideQuantity = null) {
        const champsBase = champRetour.split(";").filter(c => !c.includes("="));
        const inputNames = inputNom.split(";");

        let tbody = document.getElementById("ajout_multiple_ligne");
        if (!tbody) return;

        let idsInput = getIdNumber();
        let rowCount = idsInput.length > 0 ? idsInput[idsInput.length - 1] + 1 : 0;
        let addLineButton = document.getElementById("addLines")
        if (addLineButton) {
            addLineButton.dispatchEvent(new Event("click"));
            attachEvents()
            const check = document.getElementById("checkbox"+rowCount);
            check.setAttribute("checked", "checked");
        }
        let row = document.getElementById("ligne-multiple-"+rowCount);
        // id du produit
        let hiddenID = document.getElementById("idProduit_" + rowCount);
        hiddenID.value = selectedObj.value.split("::")[0].trim();
        hiddenID.type = "hidden";
        hiddenID.name = "idProduit_" + rowCount;
        hiddenID.id = "idProduit_" + rowCount;
        row.appendChild(hiddenID);

        let hiddenEstEnGros = document.createElement("input");
        hiddenEstEnGros.type = "hidden";
        hiddenEstEnGros.name = "estEnGros_" + rowCount;
        hiddenEstEnGros.id = "estEnGros_" + rowCount;
        hiddenEstEnGros.value = "0"; // Default value
        row.appendChild(hiddenEstEnGros);

        const valeurs = (selectedObj.retour || "").split(";");
        const finalColumns = champRetour.split(";").map(c => c.split("=")[0]);
        const productId = selectedObj.value.split("::")[0].trim();
        const productPreviewData = { photo: '', name: '', code: productId, price: '' };

        // Store data for later use
        let photoVal = '', designationVal = '', qteVal = '', puVal = '', pvgrosVal = '', remiseVal = '', prixVal = '', compteVenteVal = '';
        let referenceVal = '', codegrosVal = '';

        champsBase.forEach((col, idx) => {
            if (valeurs[idx] !== undefined) {
                if (col === 'reference') referenceVal = valeurs[idx].toString();
                if (col === 'codegros') codegrosVal = valeurs[idx].toString();
                if (col === 'pvgros') pvgrosVal = valeurs[idx].toString();
                if (col === 'compte') compteVenteVal = valeurs[idx].toString();
            }
        });

        const labelParts = selectedObj.label.split(' - ');
        if (labelParts.length >= 4) {
            referenceVal = labelParts[3].trim(); // reference is the 4th element (0-indexed: 3)
        }
        if (labelParts.length >= 5) {
            codegrosVal = labelParts[4].trim(); // codegros is the 5th element (0-indexed: 4)
        }


        const originalInput = document.getElementById(inputID).value;
        const barcodeInfo = parseWeightBarcode(originalInput);

        let isWholesaleCode = false;
        if (barcodeInfo.isWeightBased) {
            isWholesaleCode = codegrosVal && barcodeInfo.productCode.toString() === codegrosVal;
        } else {
            isWholesaleCode = codegrosVal && originalInput.toString() === codegrosVal;
        }

        if (isWholesaleCode) {
            const estEnGrosInput = row.querySelector("input[name='estEnGros_" + rowCount + "']");
            if (estEnGrosInput) {
                estEnGrosInput.value = "1";
            }
        }

        if (!codegrosVal) {
            const valueParts = selectedObj.value.split(' - ');
            if (valueParts.length >= 5) {
                const valueCodegros = valueParts[4];

                if (barcodeInfo.isWeightBased) {
                    isWholesaleCode = valueCodegros && barcodeInfo.productCode.toString() === valueCodegros;
                } else {
                    isWholesaleCode = valueCodegros && originalInput.toString() === valueCodegros;
                }
            }
        }
        finalColumns.forEach((col, idx) => {
            const val = defaults[col] !== undefined ? defaults[col] : (champsBase.indexOf(col) >= 0 ? valeurs[champsBase.indexOf(col)] : "");
            if (inputNames[idx] === 'qte' && overrideQuantity !== null) {
                qteVal = overrideQuantity.toString();
            } else {
                if (inputNames[idx] === 'photo') photoVal = val;
                if (inputNames[idx] === 'designation') designationVal = val;
                if (inputNames[idx] === 'qte') qteVal = val;
                if (inputNames[idx] === 'reference') referenceVal = val;
                if (inputNames[idx] === 'pu') {
                    const priceToUse = isWholesaleCode && pvgrosVal ? pvgrosVal : val;

                    if (overrideQuantity !== null) {
                        const uniteParts = selectedObj.retour ? selectedObj.retour.split(';') : [];
                        // Check if item is weight-based (UNT00004)
                        const uniteCode = uniteParts.length >= 7 ? uniteParts[6] : null;

                        const basePrice = parseAmount(priceToUse);

                        // If Weight-based (UNT00004): Calculate total price for the specific weight (Weight * PricePerKG / 1000)
                        // If Unit-based: Keep the BASE PRICE. The Quantity input handles the multiplication in updateTotals().
                        puVal = uniteCode === "UNT00004"
                            ? ((overrideQuantity * basePrice) / 1000).toString()
                            : basePrice.toString();
                    } else {
                        puVal = priceToUse;
                    }
                }

                if (inputNames[idx] === 'pu_pvgros') {
                    pvgrosVal = val;
                    if (isWholesaleCode && !puVal) {
                        puVal = val;
                    }
                }
                if (inputNames[idx] === 'remiseMontant') remiseVal = val;
                if (inputNames[idx] === 'prix') prixVal = val;
                if (inputNames[idx] === 'compte') compteVenteVal = val;
            }

            // Create hidden inputs
            if (inputNames[idx]) {
                let newInput = false;
                let hiddenInput = document.getElementById(inputNames[idx] + "_" + rowCount);
                if (!hiddenInput){
                    hiddenInput = document.createElement("input");
                    hiddenInput.type = "hidden";
                    hiddenInput.name = inputNames[idx] + "_" + rowCount;
                    hiddenInput.id = inputNames[idx] + "_" + rowCount;
                    newInput = true;
                }

                let inputValue = val;
                console.log('inputNames[idx] === pu:', inputNames[idx]);
                if (inputNames[idx] === 'qte' && overrideQuantity !== null) {
                    inputValue = overrideQuantity.toString();
                } else if (inputNames[idx] === 'pu') {
                    inputValue = puVal;
                } else if (inputNames[idx] === 'pu_pvgros') {
                    inputValue = val;
                } else if (inputNames[idx] === 'reference') {
                    inputValue = referenceVal;
                }else if (inputNames[idx] === 'compte') {
                    inputValue = compteVenteVal;
                }

                hiddenInput.value = inputValue;
                if (newInput) {
                    row.appendChild(hiddenInput);
                }
            }

            // Store base unit price for BOTH weight-based AND unit-based products
            if (inputNames[idx] === 'pu') {
                const priceToUse = isWholesaleCode && pvgrosVal ? pvgrosVal : val;
                const uniteParts = selectedObj.retour ? selectedObj.retour.split(';') : [];
                const uniteCode = uniteParts.length > 0 ? uniteParts[uniteParts.length - 1] : null;

                const hiddenBasePriceKg = document.createElement("input");
                hiddenBasePriceKg.type = "hidden";
                hiddenBasePriceKg.name = "basePriceKg_" + rowCount;
                hiddenBasePriceKg.id = "basePriceKg_" + rowCount;

                if (uniteCode === "UNT00004") {
                    hiddenBasePriceKg.value = parseAmount(priceToUse);
                } else {
                    hiddenBasePriceKg.value = parseAmount(priceToUse);
                }
                console.log("PRICE TO USE 1:", priceToUse)
                console.log("PRICE TO USE 1:", hiddenBasePriceKg)

                row.appendChild(hiddenBasePriceKg);
            }

            // Store the BASE price per KG/unit (before weight calculation) for weight-based products
            if (inputNames[idx] === 'pu' && overrideQuantity !== null) {
                const uniteParts = selectedObj.retour ? selectedObj.retour.split(';') : [];
                const uniteCode = uniteParts.length > 0 ? uniteParts[uniteParts.length - 1] : null;

                if (uniteCode === "UNT00004") {
                    const priceToUse = isWholesaleCode && pvgrosVal ? pvgrosVal : val;
                    const hiddenBasePriceKg = document.createElement("input");
                    hiddenBasePriceKg.type = "hidden";
                    hiddenBasePriceKg.name = "basePriceKg_" + rowCount;
                    hiddenBasePriceKg.id = "basePriceKg_" + rowCount;
                    hiddenBasePriceKg.value = parseAmount(priceToUse); // Original price per KG
                    row.appendChild(hiddenBasePriceKg);
                    console.log("PRICE TO USE 2:", priceToUse)
                    console.log("PRICE TO USE 2:", hiddenBasePriceKg)
                }
            }

            if (inputNames[idx] === 'designation') productPreviewData.name = val;
            if (inputNames[idx] === 'photo') productPreviewData.photo = val;
            if (inputNames[idx] === 'pu') {
                const originalPrice = isWholesaleCode && pvgrosVal ? pvgrosVal : val;
                productPreviewData.price = originalPrice;
            }
            if (inputNames[idx] === 'reference') productPreviewData.code = val;
        });
        // Build the row with proper UI structure matching the static example
        // Column 1: Image
        const imgCell = document.createElement("td");
        imgCell.className = "contenuetable";
        const img = document.createElement("img");
        img.className = "product-img";
        img.alt = "Produit sélectionné";
        img.src = resolveProductImage(photoVal);
        img.onerror = function() { this.src = productImageFallback; };
        imgCell.appendChild(img);
        const photoInput = document.getElementById("photo_"+rowCount);
        photoInput.type = "hidden";
        const tdimg = photoInput.closest('td')
        tdimg.querySelectorAll("img").forEach(img => {
            img.remove();
        })
        tdimg.insertBefore(img,photoInput);


        // // Column 2: Article (designation + price)
        // const articleCell = document.createElement("td");
        // articleCell.className = "contenuetable";
        // const productDetail = document.createElement("div");
        // productDetail.className = "d-flex product-detail";
        // const productName = document.createElement("span");
        // productName.className = "Body14pxSemiBold";
        // productName.textContent = designationVal || "Produit";
        // const productPrice = document.createElement("span");
        // productPrice.className = "Body14pxRegular";
        // productPrice.textContent = formatAmount(parseAmount(puVal), true);
        // productDetail.appendChild(productName);
        // productDetail.appendChild(productPrice);
        // articleCell.appendChild(productDetail);
        // row.appendChild(articleCell);

        //  // Column 3: Quantity with +/- buttons
        // const qteCell = document.createElement("td");
        // qteCell.className = "contenuetable col-qte";
        // const qteAction = document.createElement("div");
        // qteAction.className = "d-flex gap-1 qte-action";
        //
        const minusBtn = document.createElement("button");
        minusBtn.className = "btn btn-primary btn-small minus-btn-qte";
        minusBtn.type = "button";
        minusBtn.innerHTML = '<i class="material-symbols-rounded">remove</i>';
        minusBtn.onclick = function() {
            // const qteVisibleInput = row.querySelector(".qte-editable-input");
            const qteHiddenInput = row.querySelector("input[name^='qte_']");
            const puInput = row.querySelector("input[name^='pu_']");
            const basePriceKgInput = row.querySelector("input[name^='basePriceKg_']");
            const uniteInput = row.querySelector("input[name^='unite_']");
            // const productDetail = row.querySelector('.product-detail .Body14pxRegular');
            const estEnGrosInput = row.querySelector("input[name^='estEnGros_']");
            const puPvgrosInput = row.querySelector("input[name^='pu_pvgros_']");
            // const currentQte = parseAmount(qteVisibleInput?.value || 0);
            const currentQte = parseAmount(qteHiddenInput?.value || 0);
            const uniteCode = uniteInput?.value || '';
            const isWeightBased = uniteCode === "UNT00004";
            const decrement = isWeightBased ? 10 : 1;
            const newQte = Math.max(currentQte - decrement, 0);
            qteHiddenInput.value = newQte;
            // qteVisibleInput.value = Number.isInteger(newQte) ? newQte : newQte.toFixed(0);

            if (isWeightBased && basePriceKgInput) {
                const basePricePerKg = parseAmount(basePriceKgInput.value);
                const newPrice = (newQte * basePricePerKg) / 1000;
                puInput.value = newPrice;
                // if (productDetail) {
                //     productDetail.textContent = formatAmount(roundToNearest100(newPrice), true);
                // }
            }

            // else {
            //     const isWholesale = estEnGrosInput?.value === "1";
            //     let basePrice = 0;
            //     if (isWholesale && puPvgrosInput && puPvgrosInput.value) {
            //         basePrice = parseAmount(puPvgrosInput.value);
            //     } else if (basePriceKgInput) {
            //         basePrice = parseAmount(basePriceKgInput.value);
            //     }
            //
            //     const newPrice = newQte * basePrice;
            //     puInput.value = newPrice;
            //     if (productDetail) {
            //         productDetail.textContent = formatAmount(newPrice, true);
            //     }
            // }
            updateTotals();
            sync();
        };
        const qteVisibleInput = row.querySelector("input[name^='qte_']");
        // const qteVisibleInput = document.createElement("input");
        // qteVisibleInput.type = "text";
        // qteVisibleInput.className = "qte-editable-input Body14pxSemiBold";
        // qteVisibleInput.value = qteVal || "1";
        // qteVisibleInput.style.width = "70px";
        // qteVisibleInput.style.textAlign = "center";
        // qteVisibleInput.style.border = "1px solid #ddd";
        // qteVisibleInput.style.borderRadius = "4px";
        // qteVisibleInput.style.padding = "4px 8px";
        //
        //
        qteVisibleInput.addEventListener('focus', function() { setActiveInput(this); });
        qteVisibleInput.addEventListener('click', function() { setActiveInput(this); });
        qteVisibleInput.addEventListener('keydown', function(e) {
            if ([46, 8, 9, 27, 13].includes(e.keyCode) ||
                (e.keyCode === 65 && e.ctrlKey === true) ||
                (e.keyCode >= 35 && e.keyCode <= 39)) {
                return;
            }
            if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) &&
                (e.keyCode < 96 || e.keyCode > 105) &&
                e.keyCode !== 188 && e.keyCode !== 190 && e.keyCode !== 110) {
                e.preventDefault();
            }
        });

        qteVisibleInput.addEventListener('input', function() {
            const qteHiddenInput = row.querySelector("input[name^='qte_']");
            const puInput = row.querySelector("input[name^='pu_']");
            const basePriceKgInput = row.querySelector("input[name^='basePriceKg_']");
            const uniteInput = row.querySelector("input[name^='unite_']");
            const productDetail = row.querySelector('.product-detail .Body14pxRegular');
            const estEnGrosInput = row.querySelector("input[name^='estEnGros_']");
            const puPvgrosInput = row.querySelector("input[name^='pu_pvgros_']");
            let value = this.value.replace(/[^\d.,]/g, '');
            console.log("BASE PRICE INPUT",basePriceKgInput)
            console.log("PU",puInput)

            if (value === '') {
                value = '0';
            }

            const numericValue = parseAmount(value);
            qteHiddenInput.value = numericValue;
            if (!isNaN(numericValue) && numericValue >= 0) {
                const uniteCode = uniteInput?.value || '';
                const isWeightBased = uniteCode === "UNT00004";
                if (isWeightBased && basePriceKgInput) {
                    const basePricePerKg = parseAmount(row.dataset.productOriginalPrice);
                    const newPrice = (numericValue * basePricePerKg) / 1000;
                    console.log("NEW PRICE : ",newPrice)
                    puInput.value = newPrice;
                    // if (productDetail) {
                    //     productDetail.textContent = formatAmount(roundToNearest100(newPrice), true);
                    // }
                }

                // else {
                //     const isWholesale = estEnGrosInput?.value === "1";
                //     let basePrice = 0;
                //     if (isWholesale && puPvgrosInput && puPvgrosInput.value) {
                //         basePrice = parseAmount(puPvgrosInput.value);
                //     } else if (basePriceKgInput) {
                //         basePrice = parseAmount(basePriceKgInput.value);
                //     } else {
                //         basePrice = 0;
                //     }
                //
                //     const newPrice = numericValue * basePrice;
                //     puInput.value = newPrice;
                //     if (productDetail) {
                //         productDetail.textContent = formatAmount(newPrice, true);
                //     }
                // }
                updateTotals();
                sync();
            }
        });

        qteVisibleInput.addEventListener('keypress', function(e) {
            const char = String.fromCharCode(e.which);
            if (!/[\d.,]/.test(char)) {
                e.preventDefault();
            }
        });

        qteVisibleInput.addEventListener('blur', function() {
            const qteHiddenInput = row.querySelector("input[name^='qte_']");
            const numericValue = parseAmount(this.value);
            if (isNaN(numericValue) || numericValue < 0) {
                this.value = qteHiddenInput.value || "0";
            } else {
                this.value = Number.isInteger(numericValue) ? numericValue : numericValue.toFixed(2);
                qteHiddenInput.value = this.value;
            }
            updateTotals();
            sync();
        });

        const plusBtn = document.createElement("button");
        plusBtn.className = "btn btn-primary btn-small plus-btn-qte";
        plusBtn.type = "button";
        plusBtn.innerHTML = '<i class="material-symbols-rounded">add</i>';
        plusBtn.onclick = function() {
            // const qteVisibleInput = row.querySelector(".qte-editable-input");
            const qteHiddenInput = row.querySelector("input[name^='qte_']");
            const puInput = row.querySelector("input[name^='pu_']");
            const basePriceKgInput = row.querySelector("input[name^='basePriceKg_']");
            const uniteInput = row.querySelector("input[name^='unite_']");
            const productDetail = row.querySelector('.product-detail .Body14pxRegular');
            const estEnGrosInput = row.querySelector("input[name^='estEnGros_']");
            const puPvgrosInput = row.querySelector("input[name^='pu_pvgros_']");
            // const currentQte = parseAmount(qteVisibleInput?.value || 0);
            const currentQte = parseAmount(qteHiddenInput?.value || 0);
            const uniteCode = uniteInput?.value || '';
            const isWeightBased = uniteCode === "UNT00004";
            const increment = isWeightBased ? 10 : 1;
            const newQte = currentQte + increment;
            qteHiddenInput.value = newQte;
            // qteVisibleInput.value = Number.isInteger(newQte) ? newQte : newQte.toFixed(0);
            if (isWeightBased && basePriceKgInput) {
                const basePricePerKg = parseAmount(basePriceKgInput.value);
                const newPrice = (newQte * basePricePerKg) / 1000;
                puInput.value = newPrice;
                // if (productDetail) {
                //     productDetail.textContent = formatAmount(newPrice, true);
                // }
            }

            // else {
            //     const isWholesale = estEnGrosInput?.value === "1";
            //     let basePrice = 0;
            //     if (isWholesale && puPvgrosInput && puPvgrosInput.value) {
            //         basePrice = parseAmount(puPvgrosInput.value);
            //     } else if (basePriceKgInput) {
            //         basePrice = parseAmount(basePriceKgInput.value);
            //     }
            //     const newPrice = newQte * basePrice;
            //     puInput.value = newPrice;
            //     if (productDetail) {
            //         productDetail.textContent = formatAmount(newPrice, true);
            //     }
            // }
            updateTotals();
            sync();
        };
        const tdqte = qteVisibleInput.closest("td")
        tdqte.innerHTML = "";
        tdqte.appendChild(minusBtn);
        tdqte.appendChild(qteVisibleInput);
        tdqte.appendChild(plusBtn);
        // qteAction.appendChild(minusBtn);
        // qteAction.appendChild(qteVisibleInput);
        // qteAction.appendChild(plusBtn);
        // qteCell.appendChild(qteAction);
        // row.appendChild(qteCell);

        // Column 4: Unit display (no dropdown, just text)
        const unitCell = document.createElement("td");
        unitCell.className = "contenuetable";

        let uniteCode = '';
        let uniteLibelle = '';
        const values = (selectedObj.retour || "").split(";");
        champsBase.forEach((col, idx) => {
            if (col === 'unite' && values[idx]) {
                uniteCode = values[idx].toString();
            }
            if (col === 'uniteLibelle' && values[idx]) {
                uniteLibelle = values[idx].toString();
            }
        });

        if (!uniteLibelle && uniteCode === "UNT00004") {
            uniteLibelle = "Gramme";
        } else if (!uniteLibelle) {
            uniteLibelle = "Unité";
        }

        const hiddenUnite = document.getElementById("unite_" + rowCount);
        // const hiddenUnite = document.createElement("input");
        hiddenUnite.type = "hidden";
        // hiddenUnite.name = "unite_" + rowCount;
        // hiddenUnite.id = "unite_" + rowCount;
        // hiddenUnite.value = uniteCode;
        // row.appendChild(hiddenUnite);

        const unitSpan = document.createElement("span");
        unitSpan.className = "Body14pxRegular";
        unitSpan.textContent = uniteLibelle;

        const tdunite = hiddenUnite.closest("td")
        tdunite.innerHTML = "";
        tdunite.append(unitSpan);
        tdunite.append(hiddenUnite);
        // unitCell.appendChild(unitSpan);
        // row.appendChild(unitCell);

        row.dataset.uniteCode = uniteCode;
        row.dataset.uniteLibelle = uniteLibelle;

        // const montantCell = document.createElement("td");
        // montantCell.className = "contenuetable montant-row";
        // montantCell.textContent = "0 Ar";
        // row.appendChild(montantCell);

        // // Column 5: Action buttons (Edit + Remove)
        // const actionCell = document.createElement("td");
        // actionCell.className = "contenuetable";
        // actionCell

        // Edit button
        // const editBtn = document.createElement("button");
        // editBtn.className = "btn-remove btn-primary";
        // editBtn.type = "button";
        // editBtn.setAttribute("data-toggle", "modal");
        // editBtn.setAttribute("data-target", "#modif");
        // editBtn.innerHTML = '<i class="material-symbols-rounded">edit</i>';

        // // Remove button
        // const removeBtn = document.createElement("button");
        // removeBtn.className = "btn btn-danger btn-small";
        // removeBtn.type = "button";
        // removeBtn.innerHTML = '<i class="material-symbols-rounded">delete</i>';
        // removeBtn.onclick = function() { removeProductRow(this); };

        // actionCell.appendChild(editBtn);
        // actionCell.appendChild(removeBtn);
        // row.appendChild(actionCell);

        // Store product data in row dataset
        row.dataset.productPhoto = photoVal;
        row.dataset.productName = designationVal;
        row.dataset.productCode = productId;
        row.dataset.productReference = referenceVal;
        row.dataset.productPrice = puVal;
        row.dataset.productOriginalPrice = isWholesaleCode && pvgrosVal ? pvgrosVal : (champsBase.indexOf('pv') >= 0 ? valeurs[champsBase.indexOf('pv')] : '');
        row.dataset.pvgros = pvgrosVal;
        row.dataset.codegros = codegrosVal;
        row.dataset.isWholesale = isWholesaleCode.toString();

        sync();
        updateTotals();
        refreshProductPreview(productPreviewData);

        // clear input
        const input = document.getElementById(inputID);
        if (input) input.value = "";
    }


</script>
<%--calcul prix et calcul montant total a payer avec remise --%>
<script>
    function updateTotals() {
        let sousTotal = 0;
        let remiseTotale = 0;
        document.querySelectorAll("#ajout_multiple_ligne tr").forEach(tr => {
            const qteInput = tr.querySelector("input[name^='qte_']");
            const puInput = tr.querySelector("input[name^='pu_']");
            const remiseInput = tr.querySelector("input[name^='remiseMontant_']");
            const prixInput = tr.querySelector("input[name^='montant_']");
            const uniteInput = tr.querySelector("input[name^='unite_']");

            const montantCell = tr.querySelector(".montant-row");

            const qteMinusBtn = tr.querySelector(".minus-btn-qte");
            const qtePlusBtn = tr.querySelector(".plus-btn-qte");

            const quantite = parseAmount(qteInput?.value || 0);
            const prixUnitaire = parseAmount(puInput?.value || 0);
            const remise = parseAmount(remiseInput?.value || 0);
            const uniteCode = uniteInput?.value || '';
            // Check if product is weight-based (UNT00004 = Gramme/KG)
            const isWeightBased = uniteCode === "UNT00004";

            // Disable +/- buttons for weight-based products
            if (isWeightBased) {
                qteMinusBtn?.setAttribute("disabled", true);
                qtePlusBtn?.setAttribute("disabled", true);
            } else {
                qteMinusBtn?.removeAttribute("disabled");
                qtePlusBtn?.removeAttribute("disabled");
            }

            let montantBrut;
            if (isWeightBased) {
                montantBrut = roundToNearest100(prixUnitaire);
            } else {
                montantBrut = quantite * prixUnitaire;
            }
            sousTotal += montantBrut;

            remiseTotale += remise;

            const montantNet = Math.max(montantBrut - remise, 0);

            if (prixInput) {
                prixInput.value = montantNet.toFixed(2);
            }

            if (montantCell) {
                montantCell.textContent = formatAmount(montantNet, true);
            }

            const prixCell = prixInput ? prixInput.closest('td') : tr.querySelector("td:nth-last-child(2)");
            if (prixCell) {
                setCellDisplay(prixCell, formatAmount(montantNet));
            }
        });

        const total = Math.max(sousTotal - remiseTotale, 0);

        const sousTotalElement = document.getElementById("recapSousTotal");
        if (sousTotalElement) {
            sousTotalElement.textContent = formatAmount(sousTotal, true);
        }

        const remiseElement = document.getElementById("recapRemises");
        if (remiseElement) {
            remiseElement.textContent = formatAmount(remiseTotale, true);
        }

        const totalElement = document.getElementById("totalGeneral");
        if (totalElement) {
            const roundedTotal = roundToNearest100(total);
            sendMessage("A PAYER: " + formatNumberWithSpaces(roundedTotal) + " Ar");
            totalElement.textContent = formatAmount(roundedTotal, true);

            const totalElementInput = document.getElementById("totalGeneralInput");
            totalElementInput.value = parseAmount(totalElement.textContent);
        }
    }

    function roundToNearest100(number) {
        return Math.round(number / 100) * 100;
    }

    function formatNumberWithSpaces(number) {
        return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
    }

    function sendMessage(texte) {
        const endpoint = "http://192.168.88.90:3100/lcd";
        const data = {
            message: texte
        };
        fetch(endpoint, {
            method: "POST",
            headers: {
                "content-type": "application/json"
            },
            body: JSON.stringify(data)
        })
            .then(
                (response) => {
                    if (!response.ok) {
                        throw new Error("Erreur réseau lors de l'envoi du message au LCD");
                    }
                    return response.json();
                }
            )
            .then(
                (result) => {
                    console.log("Message envoyé au LCD avec succès :", result);
                }
            ).catch(
            (error) => {
                console.error("Erreur lors de l'envoi du message au LCD :", error);
            }
        );
    }

    function attachEvents() {
        // document.querySelectorAll("input[name^='qte_'], input[name^='pu_'], input[name^='remiseMontant_']").forEach(input => {
        //     input.removeEventListener("input", updateTotals);
        //     input.addEventListener("input", updateTotals);
        //     input.removeEventListener("change", updateTotals);
        //     input.addEventListener("change", updateTotals);
        //     input.removeEventListener("blur", updateTotals);
        //     input.addEventListener("blur", updateTotals);
        // });
        document.querySelectorAll("a[onclick^='delete_line']").forEach(button => {
            button.removeEventListener("click", updateTotals);
            button.addEventListener("click", updateTotals);
        });
    }

    window.updateTotals = updateTotals;

    document.addEventListener("DOMContentLoaded", function() {
        attachEvents();
        checkPaymentValidation();
        updateTotals();
        refreshProductPreview();
        document.getElementById("ligne-multiple-0").classList.add("d-none");
        document.querySelectorAll('.box-footer.borderless.nopadding').forEach(footer => {
            footer.classList.add("d-none");
        })
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

        $('input[id^="remiseMontant_"]').each(function() {
            var remise = parseFloat($(this).val());  // <-- récupérer la valeur
            if (!isNaN(remise) && remise > 0) {
                val = val - remise;  // appliquer la remise en %
            }
        });

        $("#montanttotal").html(Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(val));
    }
    function deviseModification() {
        var nombreLigne = parseInt($("#nombreLigne").val());
        for(let iL=0;iL<nombreLigne;iL++){
            $(function(){
                var mapping = {
                    "AR": {
                        "table": "ST_INGREDIENTSAUTOVENTE_MGA",
                    },
                    "USD": {
                        "table": "ST_INGREDIENTSAUTOVENTE_EURO"
                    },
                    "EUR": {
                        "table": "ST_INGREDIENTSAUTOVENTE_USD"
                    }
                };
                $("#deviseLibelle").html($('#idDevise').val());
                var idDevise = $('#idDevise').val();
                $("#idDevise_"+iL).val(idDevise);
                let autocompleteTriggered = false;
                $("#idProduit_"+iL+"libelle").autocomplete('destroy');
                $("#tauxDeChange_"+iL).val('');
                $("#pu_"+iL).val('');
                $("#idProduit_"+iL+"libelle").autocomplete({
                    source: function(request, response) {
                        $("#idProduit_"+iL).val('');
                        if (autocompleteTriggered) {
                            fetchAutocomplete(request, response, "null", "id", "null", mapping[idDevise].table, "produits.IngredientsLib", "true","pv;libelleComposant;codebarre;taux");
                        }
                    },
                    select: function(event, ui) {
                        $("#idProduit_"+iL+"libelle").val(ui.item.label);
                        $("#idProduit_"+iL).val(ui.item.value);
                        $("#idProduit_"+iL).trigger('change');
                        $(this).autocomplete('disable');
                        var champsDependant = ['pu_'+iL,'compte_'+iL,'designation_'+iL,'codebarre_'+iL,'tauxDeChange_'+iL];
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

    function getIdNumber() {
        const ids = [];
        // Sélectionner tous les inputs dont le name commence par "designation_"
        document.querySelectorAll("input[name^='designation_']").forEach(input => {
            const match = input.name.match(/^designation_(\d+)$/);
            if (match) {
                ids.push(parseInt(match[1], 10));
            }
        });
        return ids;
    }

    function extractProductValue(id) {
        const designationInput = document.querySelector("[name='designation_"+id+"']");
        const idProduitInput = document.querySelector("[name='idProduit_"+id+"']");
        const quantiteInput = document.querySelector("[name='qte_"+id+"']");
        const prixInput = document.querySelector("[name='pu_"+id+"']");
        const remiseMontantInput = document.querySelector("[name='remiseMontant_"+id+"']");
        const photoInput = document.querySelector("[name='photo_"+id+"']");
        const referenceInput = document.querySelector("[name='reference_"+id+"']");
        const basePriceKgInput = document.querySelector("[name='basePriceKg_"+id+"']");
        const compteVenteInput = document.querySelector("[name='compte_"+id+"']");


        // Get the row element
        const row = quantiteInput ? quantiteInput.closest('tr') : null;

        // FIX: Check the hidden unite input instead of a select
        const unitInput = document.querySelector("[name='unite_"+id+"']");

        if (!designationInput || !quantiteInput || !prixInput) {
            return null;
        }

        const designation = designationInput.value.trim();
        if (!designation) {
            return null;
        }

        const quantite = Number(quantiteInput.value);
        const prixunitaire = Number(prixInput.value);
        const remiseMontant = remiseMontantInput ? Number(remiseMontantInput.value) : 0;

        // FIX: Determine if the product is weight-based using the hidden input value (UNT00004)
        const isWeightBased = unitInput && unitInput.value === "UNT00004";

        return {
            id: idProduitInput ? idProduitInput.value : '',
            designation,
            reference: referenceInput?.value || '',
            quantite: isNaN(quantite) ? 0 : quantite,
            prixunitaire: isNaN(prixunitaire) ? 0 : prixunitaire,
            originalPrice: basePriceKgInput?.value || prixunitaire,
            remiseMontant: isNaN(remiseMontant) ? 0 : remiseMontant,
            urlPhoto: photoInput.value,
            isWeightBased: isWeightBased,
            compte: compteVenteInput ? compteVenteInput.value : ''
        };
    }

    function gatherProductData() {
        const ids = getIdNumber();
        const products = [];
        ids.forEach(id => {
            const product = extractProductValue(id);
            if (product) {
                products.push(product);
            }
        });
        return products;
    }
    function checkAndUpdateListener(id) {
        const input = document.getElementById(id);
        if (input) {
            if (!input.dataset.listenerAdded) {
                const update = () => {
                    const products = gatherProductData();
                    save(products);
                    console.log(products);
                };
                input.addEventListener('change', update);
                input.addEventListener('input', update);
                input.dataset.listenerAdded = 'true'; // marque en mémoire
            }
        }
    }

    function setupLinkListeners() {
        document.querySelectorAll("td a").forEach(link => {
            if (!link.dataset.listenerAdded) {
                link.addEventListener("click", () => {
                    sync();
                });
                link.dataset.listenerAdded = "true";
            }
        });
    }


    function setupListeners() {
        const ids = getIdNumber();
        ids.forEach(id => {
            checkAndUpdateListener("idProduit_" + id+"libelle");
            checkAndUpdateListener("designation_" + id);
            checkAndUpdateListener("qte_" + id);
            checkAndUpdateListener("pu_" + id);
            checkAndUpdateListener("remise_" + id);
            checkAndUpdateListener("remiseMontant_" + id);
        });
        setupLinkListeners();
    }

    function save(products) {
        // Exemple de sauvegarde dans localStorage
        localStorage.setItem('products', JSON.stringify(products));
        sendProducts(products);
        console.log('Données sauvegardées:', products);
    }

    function sync() {
        setupListeners();
        // Optionnel : appeler gatherProductData() pour initialiser l'état
        const products = gatherProductData();
        save(products);
        console.log("product sync", products);
    }

    document.addEventListener("DOMContentLoaded", function() {
        sync();
        console.log("Caisse script loaded");
    });

    // now setup socket connection
    const my_ip = window.location.hostname;
    const socket = io(my_ip+":3000"); // ton serveur socket
    socket.on("connect", () => {
        console.log("Connecté au serveur socket avec l'ID:", socket.id);
        // S'identifier en tant que caissier
        socket.emit("register", "caissier");
    });
    socket.on("registered", (data) => {
        console.log("Enregistré en tant que:", data);
    });
    socket.on("disconnect", () => {
        console.log("Déconnecté du serveur socket");
    });
    function sendProducts(produits = null) {
        let products = null;
        if (produits) {
            products = produits;
        } else {
            products = gatherProductData();
        }

        socket.emit("send_products", products);
        //console.log("Produits envoyés au serveur:", products);
    }
    // Envoyer les produits toutes les 30 secondes
    setInterval(sendProducts, 30000);

</script>

<script>
    let currentEditRow = null;

    document.addEventListener("click", function (e) {
        const btn = e.target.closest(".btn-modifier");
        if (!btn) {
            return;
        }

        currentEditRow = btn.closest("tr");
        if (!currentEditRow) {
            return;
        }

        const modalQuantite = document.getElementById("modalQuantite");
        const modalRemise = document.getElementById("modalRemise");
        const modalPrix = document.getElementById("modalPrix");
        const modalPhoto = document.getElementById("modalPhoto");
        const modalArticle = document.getElementById("modalArticle");
        const modalCode = document.getElementById("modalCode");

        //Récupération correcte des données depuis les inputs cachés
        const photoInput = currentEditRow.querySelector("input[name^='photo_']");
        const designationInput = currentEditRow.querySelector("input[name^='designation_']");
        const idProduitInput = currentEditRow.querySelector("input[name^='idProduit_']");
        const qteInput = currentEditRow.querySelector("input[name^='qte_']");
        const remiseInput = currentEditRow.querySelector("input[name^='remiseMontant_']");
        const prixUnitaireInput = currentEditRow.querySelector("input[name^='pu_']");

        //Affichage de l'image
        if (modalPhoto && photoInput) {
            const photoValue = photoInput.value;
            modalPhoto.src = resolveProductImage(photoValue);
            modalPhoto.onerror = function() {
                this.src = `${pageContext.request.contextPath}/assets/img/products/no_image.png`;
            };
        }

        //Affichage du nom de l'article
        if (modalArticle && designationInput) {
            modalArticle.textContent = designationInput.value || "Aucun article";
        }

        //Affichage de l'ID/Code produit
        if (modalCode && idProduitInput) {
            modalCode.textContent = idProduitInput.value || "--";
        }

        //Affichage du prix formaté
        if (modalPrix && prixUnitaireInput) {
            const prixValue = parseAmount(prixUnitaireInput.value || 0);
            modalPrix.textContent = formatAmount(prixValue, true);
        }

        //Valeurs pour les champs modifiables
        const qteValue = parseAmount(qteInput?.value || 0);
        const remiseValue = parseAmount(remiseInput?.value || 0);

        if (modalQuantite) {
            modalQuantite.value = Number.isInteger(qteValue) ? qteValue : qteValue.toFixed(2);
        }
        if (modalRemise) {
            modalRemise.value = remiseValue.toString();
        }
    });

    const modificationModal = document.getElementById("modif");
    if (modificationModal) {
        const minusBtn = document.getElementById("modalMinus");
        if (minusBtn) {
            minusBtn.addEventListener("click", function() {
                adjustModalQuantity(-1);
            });
        }

        const plusBtn = document.getElementById("modalPlus");
        if (plusBtn) {
            plusBtn.addEventListener("click", function() {
                adjustModalQuantity(1);
            });
        }

        modificationModal.addEventListener("click", function(e){
            if (!e.target.matches(".btn.btn-small.btn-primary")) {
                return;
            }
            if (!currentEditRow) {
                return;
            }

            const modalQuantite = document.getElementById("modalQuantite");
            const modalRemise = document.getElementById("modalRemise");

            const newQte = parseAmount(modalQuantite?.value || 0);
            const newRem = parseAmount(modalRemise?.value || 0);

            const qteInput = currentEditRow.querySelector("input[name^='qte_']");
            const remInput = currentEditRow.querySelector("input[name^='remiseMontant_']");

            if (qteInput) {
                qteInput.value = newQte;
            }
            if (remInput) {
                remInput.value = newRem;
            }

            const quantityCell = qteInput ? qteInput.closest('td') : currentEditRow.cells[3];
            if (quantityCell) {
                const qteDisplay = Number.isInteger(newQte) ? newQte : newQte.toFixed(2);
                setCellDisplay(quantityCell, qteDisplay.toString());
            }

            const remiseCell = remInput ? remInput.closest('td') : currentEditRow.cells[5];
            if (remiseCell) {
                setCellDisplay(remiseCell, formatAmount(newRem));
            }

            updateTotals();

            if (modalQuantite) {
                modalQuantite.value = (Number.isInteger(newQte) ? newQte : newQte.toFixed(2)).toString();
            }
            if (modalRemise) {
                modalRemise.value = newRem.toString();
            }

            if (typeof $ !== "undefined" && typeof $('#modif').modal === "function") {
                $('#modif').modal('hide');
            } else if (typeof bootstrap !== "undefined" && bootstrap.Modal) {
                const modalInstance = bootstrap.Modal.getInstance(modificationModal);
                if (modalInstance) {
                    modalInstance.hide();
                }
            }
            sync();
        });
    }

</script>

<%--eto mode de paiement ( set caisse selon mode paiement ) pour tpe et espece seulement --%>
<script>
    function setPaymentMode(mode) {
        let form = document.getElementById("venteForm");

        let old = document.getElementById("paymentModeInput");
        if (old) old.remove();

        let hidden = document.createElement("input");
        hidden.type = "hidden";
        hidden.name = "modePaiement";
        hidden.value = mode;
        hidden.id = "paymentModeInput";
        form.appendChild(hidden);
    }
</script>

<script>
    function setPaymentWithRef(mode, refInputId) {
        let form = document.getElementById("venteForm");
        if (!form) return;

        document.querySelectorAll("#venteForm input#paymentModeInput, #venteForm input#paymentRefInput")
            .forEach(el => el.remove());

        let refValue = document.getElementById(refInputId)?.value || "";

        let hiddenMode = document.createElement("input");
        hiddenMode.type = "hidden";
        hiddenMode.name = "modePaiement";
        hiddenMode.value = mode;
        hiddenMode.id = "paymentModeInput";
        form.appendChild(hiddenMode);

        let hiddenRef = document.createElement("input");
        hiddenRef.type = "hidden";
        hiddenRef.name = "referencePaiement";
        hiddenRef.value = refValue;
        hiddenRef.id = "paymentRefInput";
        form.appendChild(hiddenRef);

        form.submit();
    }
</script>
<%--montant a retourner payement espece--%>
<script>
    const recapRemisesRetourner = document.getElementById('montantRetourner');
    const valeurEspeceInput = document.getElementById('valeurEspece');
    const radios = document.querySelectorAll('input[name="payment-method"]');
    function updateRecap(value) {

        if (value >= 0) {
            recapRemisesRetourner.textContent = formatAmount(value,true);
            document.getElementById("aretourner").value = Number(value);
            // Ensure it uses the amount styling for positive values
            recapRemisesRetourner.className = "h520pxSemibold";
        } else {
            recapRemisesRetourner.textContent = "Montant payé inférieur";
            // Use smaller text for error messages
            recapRemisesRetourner.className = "Body14pxRegular";
        }
    }
    function calculerRetour() {
        const totalElement = document.getElementById("totalGeneral");
        console.log("TOTAL="+parseAmount(totalElement.textContent));
        const selectedRadio = document.querySelector('input[name="payment-method"]:checked');
        let aRetourner = 0;
        if (selectedRadio && selectedRadio.value === 'especes') {
            const total = parseAmount(totalElement.textContent);
            const paiement = parseAmount(valeurEspeceInput.value);
            if (total > 0) {
                aRetourner = paiement - total;
                console.log("A retourner:", aRetourner);
                updateRecap(aRetourner);
            }
        }
        return aRetourner
    }
    function pasteMontantPayer(value){
        const montantPayehtml = document.getElementById("montantPayerTexte");
        montantPayehtml.textContent = formatAmount(value,true);
    }

    function pasteMontantPayerMultiple(){
        let somme = 0;
        ['valeurEspece', 'montantMvola', 'montantOrange', 'montantAirtel', 'montantCheque', 'montantVisa'].forEach(inputId => {
            const input = document.getElementById(inputId);
            console.log(input)
            if (input) {

                const rawValue = input.value.replace(/\D/g, '');
                log("RAW MULTI",rawValue)
                if (!rawValue) {
                    const numericValue = parseInt(rawValue, 10);
                    somme += numericValue;
                }
            }
        });
        pasteMontantPayer(somme);
    }

    // valeurEspeceInput.addEventListener('input', calculerRetour);
    valeurEspeceInput.addEventListener('input', function(e) {
        const multiplePayment = document.getElementById('multiple-payment').checked;
        if (multiplePayment) {
            const errorElement = document.getElementById('espece-error');
            if (errorElement) errorElement.style.display = 'none';

            const selectionStart = this.selectionStart;
            const rawValue = this.value.replace(/\D/g, '');
            if (!rawValue) {
                this.value = '';
                checkPaymentValidation();
                return;
            }
            const numericValue = parseInt(rawValue, 10);
            this.value = numericValue.toLocaleString('fr-FR') + ' Ar';
            this.setSelectionRange(this.value.length - 3, this.value.length - 3);

            pasteMontantPayerMultiple()
            checkPaymentValidation();
            return;
        }

        const selectionStart = this.selectionStart;
        const rawValue = this.value.replace(/\D/g, '');
        if (!rawValue) {
            this.value = '';
            pasteMontantPayer(0);
            updateRecap(0);
            return;
        }
        const numericValue = parseInt(rawValue, 10);
        this.value = numericValue.toLocaleString('fr-FR') + ' Ar';

        const totalElement = document.getElementById("totalGeneral");
        const total = parseAmount(totalElement.textContent);

        if (numericValue < total) {
            let errorElement = document.getElementById('espece-error');
            if (!errorElement) {
                errorElement = document.createElement('div');
                errorElement.id = 'espece-error';
                errorElement.className = 'error-message';
                errorElement.style.color = 'red';
                errorElement.style.marginTop = '5px';
                errorElement.style.fontSize = '14px';
                errorElement.style.fontWeight = 'bold';
                errorElement.style.backgroundColor = '#ffe6e6';
                errorElement.style.padding = '5px';
                errorElement.style.border = '1px solid #ff0000';
                errorElement.style.borderRadius = '4px';
                const parentDiv = this.closest('.form-input');
                parentDiv.appendChild(errorElement);
            }
            errorElement.textContent = 'Le montant saisi est insuffisant. Montant requis: ' + formatAmount(total, true);
            errorElement.style.display = 'block';

            const validateButton = document.querySelector('.btn-primary.btn-large');
            if (validateButton) {
                validateButton.disabled = true;
                validateButton.style.opacity = '0.6';
                validateButton.style.cursor = 'not-allowed';
            }
        } else {
            const errorElement = document.getElementById('espece-error');
            if (errorElement) errorElement.style.display = 'none';

            // const validateButton = document.querySelector('.btn-primary.btn-large');
            // if (validateButton) {
            //     validateButton.disabled = false;
            //     validateButton.style.opacity = '1';
            //     validateButton.style.cursor = 'pointer';
            // }
        }

        const aRetourner = calculerRetour();
        pasteMontantPayer(numericValue);
        sendMessage("PAYE: "+formatNumberWithSpaces(numericValue)+" Ar||"+"MONNAIE: "+formatNumberWithSpaces(aRetourner)+" Ar");
        checkPaymentValidation();
        this.setSelectionRange(this.value.length - 3, this.value.length - 3);
    });

    // Add validation listeners for all payment method inputs
    ['montantMvola', 'montantOrange',
        'montantAirtel', 'montantCheque',
        'montantVisa'].forEach(inputId => {
        const input = document.getElementById(inputId);
        if (input) {
            input.addEventListener('input', function() {
                const multiplePayment = document.getElementById('multiple-payment').checked;
                const rawValue = this.value.replace(/\D/g, '');
                console.log("TT",this)
                console.log("RAW",rawValue)
                if (!rawValue) {
                    this.value = '';
                    pasteMontantPayer(0);
                    return;
                }
                const numericValue = parseInt(rawValue, 10);
                console.log("NumericValue ",numericValue)
                this.value = numericValue.toLocaleString('fr-FR') + ' Ar';
                if (multiplePayment){
                    pasteMontantPayerMultiple();
                }else {
                    pasteMontantPayer(numericValue);
                }
                updateRecap(0);
                checkPaymentValidation();
                this.setSelectionRange(this.value.length - 3, this.value.length - 3);
            });
            input.addEventListener('change', function() {
                checkPaymentValidation();
            });
        }
    });

    // Add validation on form submission
    document.getElementById('venteForm').addEventListener('submit', function(e) {
        const multiplePayment = document.getElementById('multiple-payment');
        const isMultiplePayment = multiplePayment && multiplePayment.checked;

        if (isMultiplePayment) {
            return true;
        }

        const totalElement = document.getElementById("totalGeneral");
        const total = parseAmount(totalElement.textContent);
        const rawValue = valeurEspeceInput.value.replace(/\D/g, '');
        const numericValue = rawValue ? parseInt(rawValue, 10) : 0;

        // Check if 'especes' is selected and amount is insufficient
        const selectedRadio = document.querySelector('input[name="payment-method"]:checked');
        // if (selectedRadio && selectedRadio.value === 'especes') {
        //     if (numericValue < total) {
        //         e.preventDefault(); // Prevent form submission
        //         alert('Le montant saisi en espèces est insuffisant pour effectuer le paiement. Montant requis: ' + formatAmount(total, true));
        //         // Masque le loader
        //         loader.style.display = 'none';
        //         return false;
        //     }
        // }
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        var btn = document.getElementById('btnClavierABC');
        var modal = document.getElementById('clavier-abc');

        if (!btn || !modal) return;

        // Fonction pour ouvrir le modal
        function openModal() {
            // Empêcher d'ouvrir plusieurs fois
            if (modal.classList.contains('in')) return;

            modal.style.display = 'block';
            modal.setAttribute('aria-hidden', 'false');
            document.body.classList.add('modal-open');

            // Légère temporisation pour activer la transition .fade -> .in
            setTimeout(function() {
                modal.classList.add('in');
            }, 10);
        }

        // Fonction pour fermer le modal
        function closeModal() {
            modal.classList.remove('in');
            modal.setAttribute('aria-hidden', 'true');
            document.body.classList.remove('modal-open');

            // Attendre la fin de la transition (300ms environ comme Bootstrap)
            setTimeout(function() {
                modal.style.display = 'none';
            }, 300);
        }

        // Clic sur le bouton (ou tap mobile)
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            openModal();
        });
        btn.addEventListener('touchstart', function(e) {
            e.preventDefault();
            openModal();
        });

        // Clic sur la zone hors de la modale
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                closeModal();
            }
        });

        // Clic sur un bouton de fermeture interne (si présent)
        modal.addEventListener('click', function(e) {
            if (e.target.classList.contains('close')) {
                closeModal();
            }
        });

        // Fermeture avec la touche ESC
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && modal.classList.contains('in')) {
                closeModal();
            }
        });
        function addLinkAccueilLogo() {
            const img = document.getElementById("site-logo");
            const link = document.createElement("a");
            link.href = "<%=lien%>?but=accueil.jsp";

            img.parentNode.insertBefore(link, img);
            link.appendChild(img);
        }
        addLinkAccueilLogo();
    });
</script>


<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    (function() {
        var loaderElem = document.getElementById('globalLoader');
        if (loaderElem) {
            loaderElem.style.display = 'none';
            loaderElem.style.setProperty('display', 'none', 'important');
            if (loaderElem.classList) {
                loaderElem.classList.add('d-none');
            }
        }
    })();
    alert('<%=e.getMessage()%>');
</script>
<% }%>