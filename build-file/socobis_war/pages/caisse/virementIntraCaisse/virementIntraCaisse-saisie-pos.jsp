<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="caisse.VirementIntraCaisse"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="caisse.CaisseSession" %>
<%@ page import="java.io.IOException" %>
<%@ page import="caisse.CaisseCpl" %>

<%
    try{

        VirementIntraCaisse a = new VirementIntraCaisse();

        UserEJB user = (UserEJB) session.getValue("u");

        PageInsert pageInsert = new PageInsert(a, request, user);

        String lien = (String) session.getValue("lien");
        pageInsert.setLien(lien);
        pageInsert.setTitre("Saisie de virement intra-caisse");

        String currentPoint = user.getMagasinEncoursVente().getIdPoint();
        CaisseSession sessionCaisse = new CaisseSession();
        sessionCaisse.setIdPoint(currentPoint);
//        int isExist = sessionCaisse.checkIfSessionOuverteExistePourPoint();
//        if(isExist==0) {
//            throw new IOException("Vous devez effectuer une ouverture de caisse avant de faire un transfert de caisse");
//        }


        String[] ordre = {"idCaisseDepart", "idCaisseArrive", "montant", "designation", "daty"};

        Liste[] liste = new Liste[2];
        CaisseCpl caissecpl = new CaisseCpl();
        caissecpl.setNomTable("CAISSECPL");
        liste[0] = new Liste(  "idCaisseDepart",caissecpl, "val","id");

        liste[1] = new Liste("idCaisseArrive",caissecpl,"val","id");


        pageInsert.getFormu().changerEnChamp(liste);


        pageInsert.getFormu().getChamp("idCaisseDepart").setLibelle("Transfert depuis");
        pageInsert.getFormu().getChamp("idCaisseArrive").setLibelle("Vers");

        pageInsert.getFormu().getChamp("Etat").setVisible(false);
        pageInsert.getFormu().getChamp("idOrigine").setVisible(false);

        pageInsert.getFormu().getChamp("montant").setLibelle("Montant");
        pageInsert.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pageInsert.getFormu().getChamp("designation").setType("textarea");
        pageInsert.getFormu().getChamp("daty").setLibelle("Date");
        pageInsert.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pageInsert.getFormu().getChamp("daty").setVisible(false);

        pageInsert.getFormu().setOrdre(ordre);


        String classe = "caisse.VirementIntraCaisse";

        String butApresPost ="vente/vente-saisie-directe-apj.jsp";

        String nomTable = "VirementIntraCaisse";


        pageInsert.preparerDataFormu();

        pageInsert.getFormu().makeHtmlInsertTabIndex();

%>


<style>
    #pos-cash-help-modal{
        display: none;
    }
    .vd-header {
        display:flex;
        justify-content:space-between;
        align-items:center;
    }

    .vd-header.transfer-pos-header {
        display:flex !important;
        position:fixed;
        top:0;
        left:0;
        right:0;
        z-index:1047;
        min-height:84px;
        padding:20px 28px;
        gap:22px;
        background:#ffffff;
        border-top:6px solid #2f3337;
        border-bottom:1px solid #e6e8eb;
        box-shadow:none;
    }

    .vd-header.transfer-pos-header .transfer-header-logo {
        width:52px;
        height:auto;
        flex:0 0 auto;
    }

    .vd-header.transfer-pos-header .transfer-header-search-wrap {
        flex:1 1 auto;
        width:100%;
        margin:0;
    }

    .vd-header.transfer-pos-header .transfer-header-search {
        width:100%;
        height:40px;
        padding:0 18px;
        border:1px solid #e7eaee;
        border-radius:0;
        background:#ffffff;
        color:#1f2933;
        font-size:14px;
        font-weight:700;
        box-shadow:none;
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

    #virementForm .transfer-pos-layout {
        display:grid;
        grid-template-columns:minmax(0, 1fr) 304px;
        gap:18px;
        align-items:stretch;
    }

    #virementForm .transfer-form-panel,
    #virementForm .transfer-keypad-panel {
        min-height:456px;
        padding:16px;
        background:#ffffff;
        border:1px solid #eef1f4;
        border-radius:8px;
    }

    #virementForm .transfer-form-panel {
        overflow:hidden;
    }

    #virementForm .transfer-form-panel > .col-md-12,
    #virementForm .transfer-form-panel .col-md-12.cardradius,
    #virementForm .transfer-form-panel .box,
    #virementForm .transfer-form-panel .box.box-primary {
        width:100% !important;
        margin:0 !important;
        padding:0 !important;
        border:0 !important;
        box-shadow:none !important;
        background:transparent !important;
    }

    #virementForm .transfer-form-panel .box-title,
    #virementForm .transfer-form-panel .box-header,
    #virementForm .transfer-form-panel .box-footer {
        display:none !important;
    }

    #virementForm .transfer-form-panel .box-body,
    #virementForm .transfer-form-panel #pagerecherche,
    #virementForm .transfer-form-panel .row {
        display:flex !important;
        flex-wrap:wrap;
        gap:8px 28px;
        width:100%;
        margin:0 !important;
        padding:0 !important;
    }

    #virementForm .transfer-form-panel .form-group {
        float:none !important;
        margin:0 !important;
        padding:0 !important;
    }

    #virementForm .transfer-caisse-from,
    #virementForm .transfer-caisse-to {
        flex:0 0 calc(50% - 14px) !important;
        position:relative;
    }

    #virementForm .transfer-caisse-from:after {
        content:"<->";
        position:absolute;
        right:-36px;
        bottom:15px;
        font-size:18px;
        line-height:1;
        color:#1f2933;
    }

    #virementForm .transfer-amount-group,
    #virementForm .transfer-designation-group {
        flex:0 0 100% !important;
        width:100% !important;
        max-width:100% !important;
        position:relative;
    }

    #virementForm .transfer-form-panel label {
        display:block;
        margin:0 0 6px;
        font-size:12px;
        font-weight:400;
        color:#1f2933;
    }

    #virementForm .transfer-form-panel .form-control {
        width:100%;
        height:42px;
        min-height:42px;
        padding:9px 12px;
        border:1px solid #cfd5dc;
        border-radius:4px;
        background:#ffffff;
        box-shadow:none;
        color:#343a40;
        font-size:12px;
    }

    #virementForm .transfer-form-panel .form-control:focus,
    #virementForm .transfer-form-panel .form-control.active {
        border-color:#2f6fdd;
        box-shadow:0 0 0 1px rgba(47, 111, 221, 0.12);
        outline:0;
    }

    #virementForm .transfer-form-panel textarea.form-control,
    #virementForm .transfer-designation-group textarea {
        height:82px !important;
        resize:none;
    }

    #virementForm .transfer-amount-group .form-control {
        padding-right:36px;
    }

    #virementForm .transfer-currency {
        position:absolute;
        right:10px;
        bottom:35px;
        font-size:12px;
        color:#a4abb3;
        pointer-events:none;
    }

    #virementForm .transfer-keypad-panel {
        display:flex;
        flex-direction:column;
        justify-content:flex-start;
    }

    #virementForm .transfer-keypad-panel .clavier-container {
        display:flex;
        gap:6px;
        width:100%;
        margin:0;
        z-index: 0;
    }

    #virementForm .transfer-keypad-panel .numbers {
        display:flex;
        flex:1 1 auto;
        flex-wrap:wrap;
        gap:6px;
        width:auto !important;
        padding:0 !important;
    }

    #virementForm .transfer-keypad-panel .actions-container {
        display:flex;
        flex:0 0 64px;
        flex-direction:column;
        gap:6px;
        width:64px !important;
        padding:0 !important;
    }

    #virementForm .transfer-keypad-panel .btn-clavier {
        min-width:0 !important;
        width:calc(33.333% - 4px) !important;
        /*height:67px !important;*/
        padding:0 !important;
        border:0 !important;
        border-radius:5px;
        background:#e8e8ea;
        color:#20252b;
        font-size:30px;
        font-weight:400;
        box-shadow:none;
    }

    #virementForm .transfer-keypad-panel .btn-clavier:hover,
    #virementForm .transfer-keypad-panel .btn-clavier:focus,
    #virementForm .transfer-keypad-panel .btn-clavier.is-active,
    #virementForm .transfer-keypad-panel .btn-clavier.active {
        background:#d9dee7;
        color:#20252b;
    }

    #virementForm .transfer-keypad-panel .numbers .btn-clavier[data-key="1"] { order:1; }
    #virementForm .transfer-keypad-panel .numbers .btn-clavier[data-key="2"] { order:2; }
    #virementForm .transfer-keypad-panel .numbers .btn-clavier[data-key="3"] { order:3; }
    #virementForm .transfer-keypad-panel .numbers .btn-clavier[data-key="4"] { order:4; }
    #virementForm .transfer-keypad-panel .numbers .btn-clavier[data-key="5"] { order:5; }
    #virementForm .transfer-keypad-panel .numbers .btn-clavier[data-key="6"] { order:6; }
    #virementForm .transfer-keypad-panel .numbers .btn-clavier[data-key="7"] { order:7; }
    #virementForm .transfer-keypad-panel .numbers .btn-clavier[data-key="8"] { order:8; }
    #virementForm .transfer-keypad-panel .numbers .btn-clavier[data-key="9"] { order:9; }

    #virementForm .transfer-keypad-panel .numbers .btn-clavier[data-key="0"] {
        order:10;
        width:calc(66.666% - 2px) !important;
    }

    #virementForm .transfer-keypad-panel .numbers .transfer-decimal-key {
        order:11;
    }

    #virementForm .transfer-keypad-panel .actions-container .btn-clavier {
        width:100% !important;
        height:50% !important;
        font-size:16px;
        font-weight:700;
    }

    #virementForm .transfer-keypad-panel .actions-container .delete {
        font-size:24px;
    }

    #virementForm .transfer-submit-btn {
        width:100%;
        height:41px;
        margin-top:12px;
        border:0;
        border-radius:5px;
        background:#2f6fdd;
        color:#ffffff;
        /*font-size:12px;*/
        font-weight:600;
        text-align:center;
        display:flex;
        justify-content:center;
        align-items:center;
    }

    #virementForm .transfer-submit-btn:hover,
    #virementForm .transfer-submit-btn:focus {
        background:#265dc2;
        color:#ffffff;
    }

    #clavier-abc {
        z-index:1050;
    }

    @media (max-width: 900px) {
        #virementForm .transfer-pos-layout {
            grid-template-columns:1fr;
        }

        #virementForm .transfer-form-panel,
        #virementForm .transfer-keypad-panel {
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

        #virementForm .transfer-caisse-from,
        #virementForm .transfer-caisse-to {
            flex-basis:100% !important;
            width:100% !important;
            max-width:100% !important;
        }

        #virementForm .transfer-caisse-from:after {
            display:none;
        }
    }

    .col-md-12.cardradius {
        border:none !important;
        margin-top:0px !important;
    }


    #globalLoader {
        display:none;
        position:fixed;
        top:0;
        left:0;
        width:100vw;
        height:100vh;
        z-index:99999;
        background:rgba(255,255,255,0.7);
        justify-content:center;
        align-items:center;
    }


    .spinner-border {

        width:4rem;
        height:4rem;

        border:0.5rem solid var(--VD-main-color);
        border-right-color:transparent;

        border-radius:50%;

        animation:spinner-border .75s linear infinite;
    }


    @keyframes spinner-border {

        to {
            transform:rotate(360deg);
        }

    }


    .table > thead > tr > th{
        background-color:var(--VD-content-wrapper-bg);
    }

    .form-input:first-child {
        width: calc(50% - 20px);
    }
    .form-input {
        width: 100%;
    }
    .form-input:nth-child(2) {
        width: calc(50% - 20px);
        margin-left: 20px;
    }

    .transfer-pos-layout {
        background: rgba(255, 255, 255, 0.9);
        padding: 14px;
        border-radius: 12px;
    }

    .clavier-container.vente-direct-box {
        padding: 0 !important;
    }



</style>


<link href="${pageContext.request.contextPath}/assets/css/vente-directe.css" rel="stylesheet" type="text/css" />
<script>
    window.POSCashPageConfig = {
        formSelector: '#virementForm',
        pageType: 'transfer',
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
            <h1 class="transfer-title">Transfert de caisse</h1>
            <p class="transfer-subtitle">Veuillez entrer le montant &agrave; transf&eacute;rer de la caisse</p>
        </div>
        <div class="transfer-date" id="transferCurrentDate"></div>
    </div>



    <form
            action="<%=pageInsert.getLien()%>?but=caisse/mvt/apresMvtCaissePos.jsp"
            method="post"
            id="virementForm"
            data-parsley-validate>


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
                <button type="submit" class="btn btn-primary transfer-submit-btn">Valider le transfert</button>
            </div>
        </div>



        <input
                name="acte"
                type="hidden"
                value="insertEtValider">



        <input
                name="bute"
                type="hidden"
                value="<%=butApresPost%>">



        <input
                name="classe"
                type="hidden"
                value="<%=classe%>">



        <input
                name="nomtable"
                type="hidden"
                value="<%=nomTable%>">


    </form>


</div>



<div id="globalLoader">


    <div style="text-align:center">

        <div class="spinner-border"></div>

        <div style="margin-top:1rem;font-size:1.2rem;">
            Chargement...
        </div>

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

    function buttonUsesKeyboardInput(btn) {
        return btn.classList.contains("maj")
            || btn.classList.contains("delete")
            || btn.classList.contains("space-touch")
            || !!btn.getAttribute("data-key");
    }

    function markFieldGroup(fieldId, className) {
        var field = document.getElementById(fieldId);
        if (!field) return;

        var group = field.closest(".form-group") || field.parentElement;
        if (group) {
            group.classList.add(className);
        }
    }

    function decorateTransferForm() {
        markFieldGroup("idCaisseDepart", "transfer-caisse-from");
        markFieldGroup("idCaisseArrive", "transfer-caisse-to");
        markFieldGroup("montant", "transfer-amount-group");
        markFieldGroup("designation", "transfer-designation-group");

        var amountGroup = document.querySelector(".transfer-amount-group");
        if (amountGroup && !amountGroup.querySelector(".transfer-currency")) {
            var currency = document.createElement("span");
            currency.className = "transfer-currency";
            currency.textContent = "Ar";
            amountGroup.appendChild(currency);
        }

        var numbers = document.querySelector("#virementForm .transfer-keypad-panel .numbers");
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

    var loader = document.getElementById("globalLoader");

    window.addEventListener("load", function() {
        if (loader) {
            loader.style.display = "none";
        }
    });

    document.addEventListener("DOMContentLoaded", function() {
        decorateTransferForm();
        displayTransferDate();
        initVirtualKeyboard();
        bindVirtualKeyboardButtons();

        var form = document.getElementById("virementForm");
        if (form && loader) {
            form.addEventListener("submit", function() {
                loader.style.display = "flex";
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

<script>
    setTimeout(function(){
        window.location.href = "${pageContext.request.contextPath}/pages/module.jsp?but=caisse/ouveturecaisse/ouverturecaisse-saisie.jsp";
    }, 900);
</script>

<%
    }
%>
