<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="prevision.Prevision" %>
<%@page import="affichage.*" %>
<%@page import="user.*" %>
<%@page import="utils.*" %>
<%@ page import="annexe.Point" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="caisse.*" %>
<%@ page import="java.io.IOException" %>

<%
    try{
        String lien = (String) session.getValue("lien");

        UserEJB user = (UserEJB) session.getValue("u");
        String idCaissier = user.getUser().getTuppleID();
        String point = user.getMagasinEncoursVente().getIdPoint();
        MvtCaisse mouvement = new MvtCaisse();
        PageInsert pageInsert = new PageInsert( mouvement, request, user );
        pageInsert.setLien(lien);

//        String idCaisse = session.getAttribute("idCaisse").toString();
        String currentPoint = user.getMagasinEncoursVente().getIdPoint();
        System.out.println("POINT ++++++ " + currentPoint);
        CaisseSession sessionCaisse = new CaisseSession();
        sessionCaisse.setIdPoint(currentPoint);
//        sessionCaisse.setIdCaisse(idCaisse);
//        if(idCaisse != null && idCaisse.compareToIgnoreCase("")!=0) {
//            int isExist = sessionCaisse.checkIfSessionOuverteExistePourPoint();
//            if (isExist == 0) {
//                throw new IOException("Vous devez effectuer une ouverture de caisse avant de faire une entrée de caisse");
//            }
//        }

        affichage.Champ[] liste = new affichage.Champ[1];
//        liste[0] = new Liste("idDevise",new caisse.Devise(),"val","id");
        Caisse c = new Caisse();
        c.setIdPoint(point);
        liste[0] = new Liste("idCaisse",c,"val","id");

        pageInsert.getFormu().changerEnChamp(liste);
        pageInsert.getFormu().getChamp("designation").setDefaut("Paiement du "+utilitaire.Utilitaire.dateDuJour());
        pageInsert.getFormu().getChamp("idCaisse").setLibelle("Caisse");
        pageInsert.getFormu().getChamp("idCaisse").setDefaut(user.getCaisseEspeceDefaut().getId());
//        pageInsert.getFormu().getChamp("idDevise").setLibelle("Devise");
//        pageInsert.getFormu().getChamp("idDevise").setDefaut("AR");
        pageInsert.getFormu().getChamp("taux").setDefaut("1");
        pageInsert.getFormu().getChamp("taux").setVisible(false);
        pageInsert.getFormu().getChamp("idVirement").setVisible(false);
        pageInsert.getFormu().getChamp("idVenteDetail").setVisible(false);
        pageInsert.getFormu().getChamp("idOp").setVisible(false);
        pageInsert.getFormu().getChamp("etat").setVisible(false);
        pageInsert.getFormu().getChamp("idOrigine").setVisible(false);
        pageInsert.getFormu().getChamp("debit").setVisible(false);
        pageInsert.getFormu().getChamp("daty").setLibelle("Date");
        pageInsert.getFormu().getChamp("idTiers").setPageAppelComplete("client.Client","id","Client");
//        pageInsert.getFormu().getChamp("idTiers").setPageAppelInsert("client/client-saisie.jsp","idTiers;idTierslibelle","id;nom");
        pageInsert.getFormu().getChamp("idTiers").setLibelle("Tiers");
        pageInsert.getFormu().getChamp("idTiers").setDefaut("CLI000576");
        pageInsert.getFormu().getChamp("idPrevision").setLibelle("Prevision");
        pageInsert.getFormu().getChamp("idPrevision").setPageAppelComplete("prevision.Prevision", "id", "PREVISION");
        pageInsert.getFormu().getChamp("idPrevision").setVisible(false);
        pageInsert.getFormu().getChamp("compte").setVisible(false);
        pageInsert.getFormu().getChamp("compte").setDefaut(ConstanteAsync.COMPTE_REGROUPEMENT);
        pageInsert.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pageInsert.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pageInsert.getFormu().getChamp("credit").setLibelle("Cr&eacute;dit");
        pageInsert.getFormu().getChamp("idCaissier").setDefaut(idCaissier);
        pageInsert.getFormu().getChamp("idCaissier").setVisible(false);
        pageInsert.getFormu().getChamp("montantRetourner").setVisible(false);
        pageInsert.getFormu().getChamp("idtraite").setVisible(false);
//        pageInsert.getFormu().getChamp("idbc").setVisible(false);
        pageInsert.getFormu().getChamp("Etatversement").setVisible(false);
        pageInsert.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pageInsert.getFormu().getChamp("idModePaiement").setVisible(false);
        pageInsert.getFormu().getChamp("datycomptabilisation").setVisible(false);
        pageInsert.getFormu().getChamp("idmvtcaissemere").setVisible(false);
        pageInsert.getFormu().getChamp("idDevise").setVisible(false);
        pageInsert.getFormu().getChamp("idDevise").setDefaut("AR");
        pageInsert.getFormu().getChamp("idTiers").setVisible(false);
        pageInsert.getFormu().getChamp("reference").setVisible(false);
        pageInsert.getFormu().getChamp("heure").setVisible(false);
        pageInsert.getFormu().getChamp("idReport").setVisible(false);
        pageInsert.getFormu().getChamp("idPrevision").setVisible(false);

        String[] ordre = {"daty","idCaisse","credit","designation"};
        pageInsert.getFormu().setOrdre(ordre);

        String classe = "caisse.MvtCaisse";
        String nomTable = "MOUVEMENTCAISSE";
//        String butApresPost = "vente/vente-saisie-directe2.jsp";
        String butApresPost = "vente/vente-saisie-directe-apj.jsp";

        pageInsert.preparerDataFormu();
        pageInsert.setTitre("Saisie d'une entrée de caisse");
        pageInsert.getFormu().makeHtmlInsertTabIndex();
%>


<style>
    div#uploadBox {
        display: none;
    }
    .vd-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .transfer-header-nav {
        display:flex;
        align-items:center;
        gap:24px;
        margin-left:auto;
        white-space:nowrap;
    }
    .transfer-header-nav a,
    .transfer-header-user {
        color:#1f2933;
        font-size:13px;
        line-height:1;
        text-decoration:none;
    }
    .transfer-header-nav a.active {
        color:#2f6fdd;
    }
    .transfer-header-nav .caret {
        margin-left:6px;
    }
    .transfer-header-user {
        display:flex;
        align-items:center;
        gap:8px;
    }
    .transfer-header-user i {
        font-size:17px;
    }
    .content-wrapper.transfer-pos-page {
        margin-left:0 !important;
        margin-top:0 !important;
        min-height:100vh !important;
        /*padding:98px 14px 14px !important;*/
        background:#f4f4f4 !important;
        font-family:Arial, Helvetica, sans-serif;
        color:#1f2933;
    }
    .transfer-topbar {
        display:flex;
        align-items:flex-start;
        justify-content:space-between;
        gap:16px;
        margin-bottom:16px;
    }
    .transfer-title {
        margin:0;
        font-size:24px;
        line-height:1.1;
        font-weight:700;
        color:#1f2933;
        font-family: "DM Sans";
    }
    .transfer-subtitle {
        margin:6px 0 0;
        font-size:12px;
        line-height:1.4;
        color:#1f2933;
    }
    .transfer-date {
        flex:0 0 auto;
        font-size:12px;
        color:#1f2933;
        white-space:nowrap;
    }
    #venteForm .transfer-pos-layout {
        display:grid;
        grid-template-columns:minmax(0, 1fr) 304px;
        gap:18px;
        align-items:stretch;
    }
    #venteForm .transfer-form-panel,
    #venteForm .transfer-keypad-panel {
        min-height:456px;
        padding:16px;
        background:#ffffff;
        border:1px solid #eef1f4;
        border-radius:8px;
    }
    #venteForm .transfer-form-panel {
        overflow:hidden;
    }
    #venteForm .transfer-form-panel > .col-md-12,
    #venteForm .transfer-form-panel .col-md-12.cardradius,
    #venteForm .transfer-form-panel .box,
    #venteForm .transfer-form-panel .box.box-primary {
        width:100% !important;
        margin:0 !important;
        padding:0 !important;
        border:0 !important;
        box-shadow:none !important;
        background:transparent !important;
    }
    #venteForm .transfer-form-panel .box-title,
    #venteForm .transfer-form-panel .box-header,
    #venteForm .transfer-form-panel .box-footer {
        display:none !important;
    }
    #venteForm .transfer-keypad-panel {
        display:flex;
        flex-direction:column;
        justify-content:flex-start;
    }
    #venteForm .transfer-keypad-panel .clavier-container {
        display:flex;
        gap:6px;
        width:100%;
        margin:0;
        z-index: 0;
    }
    #venteForm .transfer-keypad-panel .numbers {
        display:flex;
        flex:1 1 auto;
        flex-wrap:wrap;
        gap:6px;
        width:auto !important;
        padding:0 !important;
    }
    #venteForm .transfer-keypad-panel .actions-container {
        display:flex;
        flex:0 0 64px;
        flex-direction:column;
        gap:6px;
        width:64px !important;
        padding:0 !important;
    }
    #venteForm .transfer-keypad-panel .btn-clavier {
        min-width:0 !important;
        width:calc(33.333% - 4px) !important;
        padding:0 !important;
        border:0 !important;
        border-radius:5px;
        background:#e8e8ea;
        color:#20252b;
        font-size:30px;
        font-weight:400;
        box-shadow:none;
    }
    #venteForm .transfer-keypad-panel .btn-clavier:hover,
    #venteForm .transfer-keypad-panel .btn-clavier:focus,
    #venteForm .transfer-keypad-panel .btn-clavier.is-active,
    #venteForm .transfer-keypad-panel .btn-clavier.active {
        background:var(--VD-main-color);
        color:white;
    }
    #venteForm .transfer-keypad-panel .numbers .btn-clavier[data-key="1"] { order:1; }
    #venteForm .transfer-keypad-panel .numbers .btn-clavier[data-key="2"] { order:2; }
    #venteForm .transfer-keypad-panel .numbers .btn-clavier[data-key="3"] { order:3; }
    #venteForm .transfer-keypad-panel .numbers .btn-clavier[data-key="4"] { order:4; }
    #venteForm .transfer-keypad-panel .numbers .btn-clavier[data-key="5"] { order:5; }
    #venteForm .transfer-keypad-panel .numbers .btn-clavier[data-key="6"] { order:6; }
    #venteForm .transfer-keypad-panel .numbers .btn-clavier[data-key="7"] { order:7; }
    #venteForm .transfer-keypad-panel .numbers .btn-clavier[data-key="8"] { order:8; }
    #venteForm .transfer-keypad-panel .numbers .btn-clavier[data-key="9"] { order:9; }
    #venteForm .transfer-keypad-panel .numbers .btn-clavier[data-key="0"] {
        order:10;
        width:calc(66.666% - 2px) !important;
    }
    #venteForm .transfer-keypad-panel .numbers .transfer-decimal-key {
        order:11;
    }
    #venteForm .transfer-keypad-panel .actions-container .btn-clavier {
        width:100% !important;
        height:50% !important;
        font-size:16px;
        font-weight:700;
    }
    #venteForm .transfer-keypad-panel .actions-container .delete {
        font-size:24px;
    }
    #clavier-abc {
        z-index:1050;
    }
    @media (max-width: 900px) {
        #venteForm .transfer-pos-layout {
            grid-template-columns:1fr;
        }
        #venteForm .transfer-form-panel,
        #venteForm .transfer-keypad-panel {
            min-height:auto;
        }
    }
    @media (max-width: 600px) {
        .content-wrapper.transfer-pos-page {
            padding:10px !important;
        }
        .transfer-topbar {
            flex-direction:column;
            margin-bottom:16px;
        }
    }
    .col-md-12.cardradius {
        border: none !important;
        margin-top: 0px !important;
    }
    .vente-direct-box{
        z-index: 2000;
        position: relative;
    }
    .btn.btn-secondary, .btn.btn-danger, .btn.btn-tertiary{
        height: 31px;
    }
    .table > thead > tr > th{
        background-color: var(--VD-content-wrapper-bg);
    }
    .table{
        margin-top: 0px !important;
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
    @keyframes spinner-border {
        to { transform: rotate(360deg); }
    }

    .transfer-pos-layout {
        background: rgba(255, 255, 255, 0.9);
        padding: 14px;
        border-radius: 12px;
    }

    .form-input {
        width: 100%;
    }
    .clavier-container.vente-direct-box {
        padding: 0 !important;
    }
    .btn.btn-primary.transfer-submit-btn {
        margin-top: 12px;
        display: flex;
        justify-content: center;
        font-weight: bold;
    }
    .vd-header{
        z-index: 2001;
    }

</style>
<link href="${pageContext.request.contextPath}/assets/css/vente-directe.css" rel="stylesheet" type="text/css" />
<script>
    window.POSCashPageConfig = {
        formSelector: '#venteForm',
        pageType: 'entry',
        billetage: false,
        posUrl: '${pageContext.request.contextPath}/pages/module.jsp?but=vente/vente-saisie-directe-apj.jsp'
    };
</script>
<script src="${pageContext.request.contextPath}/assets/js/pos/pos-cash-keyboard.js"></script>
<div class="vd-header">
    <img src="${pageContext.request.contextPath}/assets/img/logo_A.png" alt="logo" id="site-logo">
    <div class="form-input w-100">
    </div>
    <div class="d-flex gap-2">
        <a class="btn btn-tertiary" href="${pageContext.request.contextPath}/pages/module.jsp?but=vente/vente-saisie-directe-apj.jsp" >
            <i class="material-symbols-rounded">add</i> POS
        </a>
        <div class="dropdown">
            <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                Mouvement
                <span class="material-symbols-rounded">keyboard_arrow_down</span>
            </button>
            <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                <li><a href="${pageContext.request.contextPath}/pages/module.jsp?but=caisse/mvt/mvtcaisse-entree-pos.jsp">Entrée de caisse</a></li>
                <li><a href="${pageContext.request.contextPath}/pages/module.jsp?but=caisse/mvt/mvtcaisse-sortie-pos.jsp">Sortie de caisse</a></li>
                <li><a href="${pageContext.request.contextPath}/pages/module.jsp?but=caisse/virementIntraCaisse/virementIntraCaisse-saisie-pos.jsp">Transfert de caisse</a></li>
            </ul>
        </div>
        <a class="btn btn-tertiary" href="${pageContext.request.contextPath}/pages/module.jsp?but=cloturecaisse/cloturecaisse-saisie.jsp" >
            Clôture de caisse
        </a>
    </div>
    <div class="btn btn-tertiary">
        <i class="material-symbols-rounded">account_circle</i>
        <%=user.getUser().getNomuser()%>
    </div>
</div>
<div class="content-wrapper transfer-pos-page">
    <div class="transfer-topbar">
        <div>
            <h1 class="transfer-title">Entr&eacute;e de caisse</h1>
            <p class="transfer-subtitle">Veuillez entrer le montant &agrave; encaisser</p>
        </div>
        <div class="transfer-date" id="transferCurrentDate"></div>
    </div>
    <form action="<%=pageInsert.getLien()%>?but=caisse/mvt/apresMvtCaissePos.jsp" method="post" id="venteForm"  data-parsley-validate>
        <div class="transfer-pos-layout">
            <div class="transfer-form-panel">
                <%
                    out.println(pageInsert.getFormu().getHtmlInsert());
                %>
            </div>
            <div class="transfer-keypad-panel">
                <%
                    out.println(pageInsert.getHtmlClavierVisuel());
                %>
                <button type="submit" class="btn btn-primary transfer-submit-btn">Valider l'entr&eacute;e</button>
            </div>
        </div>
        <input name="acte" type="hidden" id="nature" value="insertEtValider">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
</div>

<style>
    #pos-cash-help-modal{
        display: none;
    }
    .custom-modal {
        position: fixed;
        inset: 0;
        display: none;
        justify-content: center;
        z-index: 1999;
        font-family: "Inter", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    }

    .custom-modal.is-open {
        display: flex;
    }

    .custom-modal-overlay {
        position: absolute;
        inset: 0;
        overflow: auto;
        background: rgba(15, 23, 42, 0.48);
        backdrop-filter: blur(2px);
    }

    .custom-modal-dialog {
        position: relative;
        z-index: 1;
        width: min(420px, 92vw);
        background: #ffffff;
        border-radius: 18px;
        box-shadow: 0 28px 60px rgba(15, 23, 42, 0.28);
        padding: 28px 28px 24px;
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    .custom-modal-close {
        position: absolute;
        top: 18px;
        right: 18px;
        border: none;
        background: transparent;
        font-size: 24px;
        line-height: 1;
        color: #64748b;
        cursor: pointer;
        transition: color 0.2s ease;
    }

    .custom-modal-close:hover {
        color: #0f172a;
    }

    .custom-modal-title {
        font-size: 20px;
        font-weight: 600;
        color: #0f172a;
        margin: 0;
    }

    .custom-modal-subtitle {
        font-size: 14px;
        color: #475569;
        margin: 0;
    }

    .custom-modal-body {
        display: flex;
        flex-direction: column;
        gap: 12px;
    }

    .denomination-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 16px;
        padding: 12px;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        background: linear-gradient(135deg, rgba(248, 250, 252, 0.95), rgba(241, 245, 249, 0.9));
    }

    .denomination-label {
        font-size: 15px;
        font-weight: 500;
        color: #0f172a;
    }

    .denomination-input {
        width: 120px;
        padding: 8px 12px;
        border: 1px solid #cbd5f5;
        border-radius: 10px;
        font-size: 15px;
        text-align: right;
        background: #f8fafc;
        color: #0f172a;
        transition: border-color 0.2s ease, box-shadow 0.2s ease;
    }

    .denomination-input:focus {
        outline: none;
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
        background: #ffffff;
    }

    .custom-modal-total {
        font-size: 16px;
        font-weight: 600;
        color: #0f172a;
        text-align: right;
        margin-top: 4px;
    }

    .custom-modal-footer {
        display: flex;
        justify-content: flex-end;
        gap: 12px;
        margin-top: 8px;
    }

    .custom-modal-btn {
        min-width: 110px;
        border-radius: 10px;
        padding: 10px 16px;
        border: none;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: transform 0.15s ease, box-shadow 0.15s ease;
    }

    .custom-modal-btn.primary {
        background: linear-gradient(135deg, #2563eb, #1d4ed8);
        color: #ffffff;
        box-shadow: 0 14px 30px rgba(37, 99, 235, 0.3);
    }

    .custom-modal-btn.primary:hover {
        transform: translateY(-1px);
        box-shadow: 0 18px 34px rgba(37, 99, 235, 0.35);
    }

    .custom-modal-btn.secondary {
        background: #e2e8f0;
        color: #1e293b;
    }

    .custom-modal-btn.secondary:hover {
        background: #cbd5f5;
    }

    @media (max-width: 520px) {
        .denomination-row {
            flex-direction: column;
            align-items: flex-start;
        }

        .denomination-input {
            width: 100%;
        }

        .custom-modal-footer {
            flex-direction: column-reverse;
        }

        .custom-modal-btn {
            width: 100%;
        }
    }
</style>

<div id="globalLoader" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;z-index:99999;background:rgba(255,255,255,0.7);justify-content:center;align-items:center;">
    <div style="text-align:center;">
        <div class="spinner-border"  role="status"></div>
        <div style="margin-top:1rem;font-size:1.2rem;color:(--VD-main-color)">Chargement...</div>
    </div>
</div>


<script>
    let activeInput = null;
    let isShiftActive = false;
    let repeatInterval = null;
    let repeatTimeout = null;

    function setActiveInput(input) {
        document.querySelectorAll(".form-control").forEach(function(el) {
            el.classList.remove("active");
        });

        if (input) {
            input.classList.add("active");
            activeInput = input;
        }
    }

    function initVirtualKeyboard() {
        document.querySelectorAll(".form-control:not(select)").forEach(function(input) {
            input.addEventListener("focus", function() {
                setActiveInput(input);
            });

            input.addEventListener("click", function() {
                setActiveInput(input);
            });
        });
    }

    function getCursorPosition(input) {
        return typeof input.selectionStart === "number"
            ? input.selectionStart
            : input.value.length;
    }

    function addText(char) {
        if (!activeInput) return;

        var cursorPos = getCursorPosition(activeInput);
        var textBefore = activeInput.value.substring(0, cursorPos);
        var textAfter = activeInput.value.substring(cursorPos);
        var value = isShiftActive ? char.toUpperCase() : char.toLowerCase();

        activeInput.value = textBefore + value + textAfter;

        if (isShiftActive) {
            isShiftActive = false;
            document.querySelectorAll(".btn-clavier.maj").forEach(function(btn) {
                btn.classList.remove("active");
            });
        }

        var newPos = cursorPos + value.length;
        if (typeof activeInput.setSelectionRange === "function") {
            activeInput.setSelectionRange(newPos, newPos);
        }
        activeInput.focus();
        activeInput.dispatchEvent(new Event("input", { bubbles: true, cancelable: true }));
    }

    function deleteChar() {
        if (!activeInput) return;

        var cursorPos = getCursorPosition(activeInput);
        if (cursorPos > 0) {
            var textBefore = activeInput.value.substring(0, cursorPos - 1);
            var textAfter = activeInput.value.substring(cursorPos);
            activeInput.value = textBefore + textAfter;

            var newPos = cursorPos - 1;
            if (typeof activeInput.setSelectionRange === "function") {
                activeInput.setSelectionRange(newPos, newPos);
            }
            activeInput.focus();
            activeInput.dispatchEvent(new Event("input", { bubbles: true, cancelable: true }));
        }
    }

    function executeButtonAction(btn) {
        if (btn.classList.contains("maj")) {
            isShiftActive = !isShiftActive;
            btn.classList.toggle("active");
            return false;
        }

        if (btn.classList.contains("delete")) {
            deleteChar();
            return true;
        }

        if (btn.classList.contains("space-touch")) {
            addText(" ");
            return true;
        }

        var key = btn.getAttribute("data-key");
        if (key) {
            addText(key);
            return true;
        }

        var btnText = btn.textContent.trim();
        if (btnText && btnText !== "ABC" && btnText !== "123" && btnText !== "Espace") {
            addText(btnText);
            return true;
        }

        return false;
    }

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

    function buttonUsesKeyboardInput(btn) {
        return btn.classList.contains("maj")
            || btn.classList.contains("delete")
            || btn.classList.contains("space-touch")
            || !!btn.getAttribute("data-key");
    }

    function bindVirtualKeyboardButtons() {
        document.querySelectorAll(".btn-clavier").forEach(function(btn) {
            btn.addEventListener("mousedown", function(e) {
                if (buttonUsesKeyboardInput(btn)) {
                    e.preventDefault();
                }
                var shouldRepeat = executeButtonAction(btn);

                if (shouldRepeat) {
                    repeatTimeout = setTimeout(function() {
                        repeatInterval = setInterval(function() {
                            executeButtonAction(btn);
                        }, 100);
                    }, 500);
                }
            });

            btn.addEventListener("mouseup", stopRepeat);
            btn.addEventListener("mouseleave", stopRepeat);

            btn.addEventListener("touchstart", function(e) {
                if (buttonUsesKeyboardInput(btn)) {
                    e.preventDefault();
                }
                var shouldRepeat = executeButtonAction(btn);

                if (shouldRepeat) {
                    repeatTimeout = setTimeout(function() {
                        repeatInterval = setInterval(function() {
                            executeButtonAction(btn);
                        }, 100);
                    }, 500);
                }
            });

            btn.addEventListener("touchend", stopRepeat);
            btn.addEventListener("touchcancel", stopRepeat);

            btn.addEventListener("mousedown", function() {
                btn.classList.add("is-active");
            });
            btn.addEventListener("mouseup", function() {
                btn.classList.remove("is-active");
            });
            btn.addEventListener("mouseleave", function() {
                btn.classList.remove("is-active");
            });
            btn.addEventListener("touchstart", function() {
                btn.classList.add("is-active");
            });
            btn.addEventListener("touchend", function() {
                btn.classList.remove("is-active");
            });
            btn.addEventListener("touchcancel", function() {
                btn.classList.remove("is-active");
            });
        });
    }

    function decorateTransferForm() {
        var numbers = document.querySelector("#venteForm .transfer-keypad-panel .numbers");
        if (numbers && !numbers.querySelector(".transfer-decimal-key")) {
            var decimalButton = document.createElement("button");
            decimalButton.className = "btn-clavier btn col-md-3 h142pxRegular transfer-decimal-key";
            decimalButton.type = "button";
            decimalButton.setAttribute("data-key", ",");
            decimalButton.textContent = ",";
            numbers.appendChild(decimalButton);
        }
    }

    function displayTransferDate() {
        var dateElement = document.getElementById("transferCurrentDate");
        if (!dateElement) return;

        var now = new Date();
        var dateFormatter = new Intl.DateTimeFormat("fr-FR", {
            day:"2-digit",
            month:"long",
            year:"numeric"
        });
        var timeFormatter = new Intl.DateTimeFormat("fr-FR", {
            hour:"2-digit",
            minute:"2-digit"
        });

        dateElement.textContent = dateFormatter.format(now) + " - " + timeFormatter.format(now);
    }

    var loader = document.getElementById('globalLoader');
    if (loader) {
        loader.style.display = 'flex';
    }

    window.addEventListener('load', function() {
        if (loader) {
            loader.style.display = 'none';
        }
    });

    document.addEventListener('DOMContentLoaded', function() {
        decorateTransferForm();
        displayTransferDate();
        initVirtualKeyboard();
        bindVirtualKeyboardButtons();

        var form = document.getElementById('venteForm');
        if (form && loader) {
            form.addEventListener('submit', function() {
                loader.style.display = 'flex';
            });
        }

        document.addEventListener("mouseup", stopRepeat);
        document.addEventListener("touchend", stopRepeat);
    });

    window.setActiveInput = setActiveInput;
    window.initVirtualKeyboard = initVirtualKeyboard;
</script>

<%
} catch(Exception e) {
    e.printStackTrace();
%>

<div id="errorMessage" class="alert alert-danger"
     style="
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        z-index: 99999;
        min-width: 300px;
        max-width: 500px;
        padding: 20px 30px;
        text-align: center;
        font-size: 18px;
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.3);
     ">
    <%= e.getMessage() %>
</div>

<%--<script>--%>
<%--    setTimeout(function(){--%>
<%--        window.location.href = "${pageContext.request.contextPath}/pages/module.jsp?but=caisse/ouveturecaisse/ouverturecaisse-saisie.jsp";--%>
<%--    }, 900);--%>
<%--</script>--%>

<%
    }
%>
