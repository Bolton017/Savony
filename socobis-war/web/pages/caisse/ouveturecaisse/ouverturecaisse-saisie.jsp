<%@page import="prevision.Prevision" %>
<%@page import="affichage.*" %>
<%@page import="user.*" %>
<%@page import="utils.*" %>
<%@ page import="annexe.Point" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="caisse.*" %>

<%
    try{
        UserEJB user = (UserEJB) session.getValue("u");
        String lien = (String) session.getValue("lien");

        ReportCaisse mapping = new ReportCaisse();
        ReportCaisse fille = new ReportCaisse();
        fille.setNomTable("REPORTCAISSE_SAISIE");
        Billetage billet = new Billetage();
        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(fille,fille, request, nombreLigne ,user);
        pi.setLien(lien);
//        affichage.Champ[] liste = new affichage.Champ[1];
//        liste[0] = new Liste("idPoint",new Point(),"val","id");

//        pi.getFormu().changerEnChamp(liste);

//        pi.getFormu().getChamp("idPoint").setLibelle("Point");
        pi.getFormu().getChamp("daty").setLibelle("Date");
//        pi.getFormu().getChamp("montantTheorique").setLibelle("Montant th&eacute;orique");
//        pi.getFormu().getChamp("montant").setLibelle("Montant");
        pi.getFormu().getChamp("idCaisse").setLibelle("caisse");
//        pi.getFormu().getChamp("explication").setLibelle("Explication");
        pi.getFormu().getChamp("etat").setVisible(false);
//        pi.getFormu().getChamp("explication").setVisible(false);
        pi.getFormu().getChamp("idUser").setDefaut(user.getUser().getTuppleID());


        String dtJour = Utilitaire.dateDuJour();
        pi.getFormu().getChamp("daty").setDefaut(dtJour);
//        pi.getFormu().getChamp("idPoint").setDefaut(point);
//        pi.getFormu().getChamp("remarque").setDefaut("Cloture de caisse du " + dtJour);


        pi.getFormufle().getChamp("caisseLib_0").setLibelle("Caisse");
        pi.getFormufle().getChamp("montantTheorique_0").setLibelle("Montant Th&eacute;orique");
        pi.getFormufle().getChamp("montant_0").setLibelle("Montant R&eacute;el");
//        pi.getFormufle().getChamp("explication_0").setLibelle("Explication");
        pi.getFormufle().getChampMulitple("id").setVisible(false);
//        pi.getFormufle().getChampMulitple("idCloture").setVisible(false);
        pi.getFormufle().getChampMulitple("idCaisse").setVisible(false);
        pi.getFormufle().getChampMulitple("caisseLib").setAutre("readonly");
//        pi.getFormufle().getChampMulitple("explication").setVisible(false);
        pi.getFormufle().getChampMulitple("montantTheorique").setAutre("readonly");

        pi.getFormufle().getChampMulitple("etat").setVisible(false);

        pi.getFormufle().getChampMulitple("daty").setVisible(false);

        pi.getFormufle().getChampMulitple("heure").setVisible(false);
        pi.getFormufle().getChampMulitple("idUser").setVisible(false);
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("typeReport"), ConstanteAsync.type_report_ouverture);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("typeReport"),false);

        ReportCaisse[] filles = mapping.genererCaisseAOuvrir(user.getListeCaisseReport(),null);
        pi.getFormufle().setNbLigne(filles.length);
//        System.out.println("filles " + filles.length);
        if(filles!=null && filles.length>0) {
            nombreLigne = filles.length;
            pi.setDefautFille(filles);
        }
        String[] order ={"caisseLib", "montantTheorique","montant"};
        pi.getFormufle().setColOrdre(order);

        String classeMere = "caisse.ReportCaisse";
        String nomTableMere = "REPORTCAISSE";
        String butApresPost = "vente/vente-saisie-directe-apj.jsp";
        String classeFille = "caisse.ReportCaisse";
        String colonneMere = "idcloture";


        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<style>
    div#uploadBox {
        display: none;
    }
    .vd-header {
        justify-content: space-between;
    }
    .col-md-12.cardradius {
        margin-top: 0px !important;
    }
    .vente-direct-box{
        z-index: 2000;
        position: relative;
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

    #ajout_multiple_ligne .form-control {
        padding: 0;
        border: 1px solid var(--Border);
        background-color: white;
    }

    #ajout_multiple_ligne a[onclick*="delete_line"],
    #ajout_multiple_ligne a[onclick*="removeLine"],
    #ajout_multiple_ligne a[onclick*="duplicateSingleRow"],
    #ajout_multiple_ligne .glyphicon-remove,
    #ajout_multiple_ligne .glyphicon-duplicate,
    #ajout_multiple_ligne .fa-times,
    #ajout_multiple_ligne .fa-copy {
        display: none !important;
    }

</style>
<link href="${pageContext.request.contextPath}/assets/css/vente-directe.css" rel="stylesheet" type="text/css" />
<style>
    #venteForm .form-control {
        display: flex;
        padding: var(--Bases-4-space-2, 8px) var(--Bases-4-space-3, 12px);
        align-items: center;
        gap: var(--Bases-4-space-3, 12px);
        align-self: stretch;
        height: var(--Size-small, 34px);
        border: 1px solid var(--Border, #C3C5C6);
        border-radius: var(--Bases-4-space-1, 4px);
        min-width: 128px;
    }
    #venteForm #ajout_multiple_ligne .form-control {
        padding: var(--Bases-4-space-2, 8px) var(--Bases-4-space-3, 12px) !important;
    }
    #venteForm .table-container.nopadding.borderless table tbody tr td input {
        border: 1px solid var(--Border);
        background-color: white;
    }
    #venteForm .table-container.nopadding.borderless table tbody tr td input:disabled {
        background-color: var(--Onyx-100) !important;
    }
    #venteForm #ajout_multiple_ligne .form-control {
        padding: 0;
        border: 1px solid var(--Border);
        background-color: white;
    }
    .vd-header.closure-pos-header {
        display: flex !important;
        align-items: center;
        gap: 28px;
        min-height: 84px;
        padding: 18px 28px;
        background: #ffffff;
        border: 0;
        box-shadow: none;
    }
    .closure-header-logo {
        width: 58px;
        height: auto;
        flex: 0 0 auto;
    }
    .closure-header-search {
        display: flex;
        align-items: center;
        flex: 1 1 auto;
        height: 50px;
        padding: 0 20px;
        border: 1px solid #2f6fdd;
        border-radius: 8px;
        color: #20252b;
        font-size: 18px;
        font-weight: 700;
    }
    .closure-header-nav {
        display: flex;
        align-items: center;
        gap: 28px;
        margin-left: auto;
        white-space: nowrap;
    }
    .closure-header-nav a,
    .closure-header-user {
        color: #20252b;
        font-size: 15px;
        line-height: 1;
        text-decoration: none;
    }
    .closure-header-nav a.active {
        color: #2f6fdd;
    }
    .closure-header-user {
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .closure-header-user i {
        font-size: 24px;
    }
    .content-wrapper.closure-pos-page {
        margin-left: 0 !important;
        margin-top: 0 !important;
        min-height: 100vh !important;
        /*padding: 28px !important;*/
        background: #f4f4f4 !important;
        color: #20252b;
        font-family: Arial, Helvetica, sans-serif;
    }
    .closure-topbar {
        display: flex;
        align-items: end;
        justify-content: space-between;
        gap: 18px;
        margin-bottom: 34px;
    }
    .closure-title {
        margin: 0;
        font-size: 30px;
        line-height: 1.15;
        font-weight: 700;
    }
    .closure-subtitle {
        margin: 10px 0 0;
        font-size: 16px;
        line-height: 1.4;
        color: #343a40;
    }
    .closure-date {
        flex: 0 0 auto;
        margin-top: 4px;
        font-size: 15px;
        color: #20252b;
        white-space: nowrap;
    }
    .closure-layout {
        display: grid;
        grid-template-columns: minmax(0, 1fr) 390px;
        gap: 24px;
        padding: 22px;
        background: #ffffff;
        border-radius: 18px;
    }
    .closure-panel {
        min-height: 540px;
        padding: 20px;
        background: #ffffff;
        border: 1px solid #eceff2;
        border-radius: 8px;
    }
    .closure-panel-title {
        margin-bottom: 8px;
        font-size: 21px;
        line-height: 1.1;
        font-weight: 700;
        margin-top: 0;
    }
    .closure-form-panel .col-md-8,
    .closure-form-panel .table-container,
    .closure-form-panel .table-container.nopadding.borderless,
    .closure-form-panel table {
        width: 100% !important;
    }
    .closure-form-panel .table-container,
    .closure-form-panel .table-container.nopadding.borderless {
        padding: 0 !important;
        border: 0 !important;
        overflow: visible !important;
    }
    .closure-form-panel table {
        border-collapse: separate !important;
        border-spacing: 0 8px !important;
        table-layout: auto !important;
    }
    .closure-form-panel table thead th {
        padding: 0 16px 8px !important;
        border: 0 !important;
        color: #2563eb;
        font-size: 14px;
        font-weight: 700;
        vertical-align: middle;
    }
    .closure-form-panel table tbody td {
        padding: 0 16px !important;
        border: 0 !important;
        vertical-align: middle !important;
    }
    .closure-form-panel table tbody tr {
        margin-bottom: 8px;
    }
    .closure-form-panel table tbody td:first-child,
    .closure-form-panel table thead th:first-child {
        width: 40px;
        padding-left: 0 !important;
        padding-right: 10px !important;
        text-align: center;
    }
    .closure-form-panel .box-footer {
        display: none !important;
    }
    .closure-summary-card {
        min-height: 80px;
        padding: 18px 20px 14px;
        border: 1px solid #eceff2;
        border-radius: 8px;
        margin-bottom: 18px;
    }
    .closure-summary-label {
        display: block;
        margin-bottom: 8px;
        font-size: 16px;
        font-weight: 700;
    }
    .closure-summary-total {
        display: block;
        font-size: 34px;
        line-height: 1.1;
        font-weight: 700;
        color: #343a40;
    }
    .closure-summary-lines {
        padding: 14px 16px;
        border: 1px solid #eceff2;
        border-radius: 8px;
        margin-bottom: 18px;
    }
    .closure-summary-line {
        display: flex;
        justify-content: space-between;
        gap: 16px;
        font-size: 15px;
        line-height: 1.8;
    }
    .closure-summary-line.danger {
        color: #ff3030;
    }
    .closure-keypad-title {
        margin: 0 0 14px;
        font-size: 24px;
        line-height: 1;
        font-weight: 700;
    }
    .closure-summary-panel .clavier-container {
        display: flex;
        gap: 8px;
        width: 100%;
        margin: 0;
    }
    .closure-summary-panel .numbers {
        display: flex;
        flex: 1 1 auto;
        flex-wrap: wrap;
        gap: 8px;
        width: auto !important;
        padding: 0 !important;
    }
    .closure-summary-panel .actions-container {
        display: flex;
        flex: 0 0 86px;
        flex-direction: column;
        gap: 8px;
        width: 86px !important;
        padding: 0 !important;
    }
    .closure-summary-panel .btn-clavier {
        min-width: 0 !important;
        width: calc(33.333% - 6px) !important;
        height: 58px !important;
        padding: 0 !important;
        border: 0 !important;
        border-radius: 6px;
        background: #e8e8ea;
        color: #20252b;
        font-size: 36px;
        font-weight: 400;
        box-shadow: none;
    }
    .closure-summary-panel .numbers .btn-clavier[data-key="0"] {
        width: calc(66.666% - 3px) !important;
    }
    .closure-summary-panel .numbers .btn-clavier[data-key="1"] { order: 1; }
    .closure-summary-panel .numbers .btn-clavier[data-key="2"] { order: 2; }
    .closure-summary-panel .numbers .btn-clavier[data-key="3"] { order: 3; }
    .closure-summary-panel .numbers .btn-clavier[data-key="4"] { order: 4; }
    .closure-summary-panel .numbers .btn-clavier[data-key="5"] { order: 5; }
    .closure-summary-panel .numbers .btn-clavier[data-key="6"] { order: 6; }
    .closure-summary-panel .numbers .btn-clavier[data-key="7"] { order: 7; }
    .closure-summary-panel .numbers .btn-clavier[data-key="8"] { order: 8; }
    .closure-summary-panel .numbers .btn-clavier[data-key="9"] { order: 9; }
    .closure-summary-panel .numbers .btn-clavier[data-key="0"] { order: 10; }
    .closure-summary-panel .numbers::after {
        content: ",";
        order: 11;
        display: flex;
        align-items: center;
        justify-content: center;
        width: calc(33.333% - 6px);
        border-radius: 6px;
        background: #e8e8ea;
        color: #20252b;
        font-size: 36px;
        font-weight: 400;
    }
    .closure-summary-panel .actions-container .btn-clavier {
        width: 100% !important;
        height: 50% !important;
        font-size: 20px;
        font-weight: 700;
    }
    .closure-submit-btn {
        width: 100%;
        height: 54px;
        margin-top: 22px;
        border: 0;
        border-radius: 6px;
        background: #336fe1;
        color: #ffffff;
        font-size: 15px;
        font-weight: 700;
    }
    @media (max-width: 1100px) {
        .closure-layout {
            grid-template-columns: 1fr;
        }
    }

</style>
<%--Style custom (Jocelyn)--%>
<style>
    .custom-modal {
        position: fixed;
        inset: 0;
        display: none;
        align-items: center;
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
        background: rgba(0, 0, 0, 0.68);
    }

    .custom-modal-dialog {
        position: relative;
        z-index: 1;
        width: min(884px, 96vw);
        max-height: 92vh;
        background: #ffffff;
        border-radius: 8px;
        box-shadow: none;
        padding: 32px 24px 24px;
        display: flex;
        flex-direction: column;
        gap: 28px;
        overflow: auto;
    }

    .custom-modal-close {
        position: absolute;
        top: 18px;
        right: 18px;
        width: 41px;
        height: 41px;
        border: 1px solid #edf0f2;
        border-radius: 6px;
        background: #ffffff;
        font-size: 24px;
        line-height: 1;
        color: #20252b;
        cursor: pointer;
        transition: background 0.2s ease, border-color 0.2s ease;
    }

    .custom-modal-close:hover {
        background: #f8f9fa;
        border-color: #dfe3e7;
    }

    .custom-modal-title {
        font-size: 17px;
        font-weight: 700;
        color: #20252b;
        margin: 0;
        font-family: "DM Sans";
    }

    .custom-modal-subtitle {
        display: none;
    }

    .custom-modal-content {
        display: grid;
        grid-template-columns: minmax(0, 406px) minmax(0, 406px);
        gap: 24px;
        align-items: start;
    }

    .custom-modal-body {
        display: flex;
        flex-direction: column;
        gap: 8px;
        overflow-y: auto;
        max-height: 520px;
        margin: 0;
    }

    .denomination-row {
        display: grid;
        grid-template-columns: 91px minmax(0, 1fr);
        align-items: center;
        gap: 12px;
        padding: 0;
        border: 0;
        border-radius: 0;
        background: transparent;
    }

    .denomination-label {
        font-size: 14px;
        font-weight: 400;
        color: #374151;
        text-align: right;
        white-space: nowrap;
    }

    .denomination-input {
        width: 100%;
        height: 40px;
        padding: 8px 12px;
        border: 1px solid #c3c5c6;
        border-radius: 4px;
        font-size: 15px;
        text-align: center;
        background: #ffffff;
        color: #343a40;
        transition: border-color 0.2s ease, box-shadow 0.2s ease;
    }

    .denomination-input:focus {
        outline: none;
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
        background: #ffffff;
    }

    .custom-modal-total {
        min-height: 91px;
        padding: 21px 20px 16px;
        border: 1px solid #eef0f2;
        border-radius: 8px;
        color: #343a40;
        text-align: left;
        margin: 0 0 24px;
    }

    .custom-modal-total strong {
        display: block;
        font-size: 14px;
        font-weight: 700;
        line-height: 1;
        margin-bottom: 6px;
        font-font: "DM Sans";
    }

    .custom-modal-total span {
        display: block;
        font-size: 36px;
        font-weight: 700;
        line-height: 1.1;
        letter-spacing: 0;
        font-font: "DM Sans";
    }

    .custom-modal-footer {
        display: flex;
        justify-content: stretch;
        gap: 0;
        margin-top: 24px;
    }

    .custom-modal-btn {
        width: 100%;
        height: 53px;
        border-radius: 6px;
        padding: 0 16px;
        border: none;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: transform 0.15s ease, box-shadow 0.15s ease;
    }

    .custom-modal-btn.primary {
        background: #336fe1;
        color: #ffffff;
        box-shadow: none;
    }

    .custom-modal-btn.primary:hover {
        background: #2f65cc;
        transform: none;
        box-shadow: none;
    }

    .custom-modal-btn.secondary {
        display: none;
    }

    .custom-modal-keypad-title {
        margin: 0 0 12px;
        font-size: 21px;
        line-height: 1;
        font-weight: 700;
        color: #20252b;
    }

    .custom-modal-keypad .clavier-container {
        display: flex;
        gap: 8px;
        width: 100%;
        margin: 0;
    }

    .custom-modal-keypad .numbers {
        display: flex;
        flex: 1 1 auto;
        flex-wrap: wrap;
        gap: 8px;
        width: auto !important;
        padding: 0 !important;
    }

    .custom-modal-keypad .actions-container {
        display: flex;
        flex: 0 0 96px;
        flex-direction: column;
        gap: 8px;
        width: 96px !important;
        padding: 0 !important;
    }

    .custom-modal-keypad .btn-clavier {
        min-width: 0 !important;
        width: calc(33.333% - 6px) !important;
        height: 66px !important;
        padding: 0 !important;
        border: 0 !important;
        border-radius: 6px;
        background: #e8e8ea;
        color: #20252b;
        font-size: 40px;
        font-weight: 400;
        box-shadow: none;
    }

    .custom-modal-keypad .btn-clavier:hover,
    .custom-modal-keypad .btn-clavier:focus,
    .custom-modal-keypad .btn-clavier.active {
        background: #d9dee7;
        color: #20252b;
    }

    .custom-modal-keypad .numbers .btn-clavier[data-key="1"] { order: 1; }
    .custom-modal-keypad .numbers .btn-clavier[data-key="2"] { order: 2; }
    .custom-modal-keypad .numbers .btn-clavier[data-key="3"] { order: 3; }
    .custom-modal-keypad .numbers .btn-clavier[data-key="4"] { order: 4; }
    .custom-modal-keypad .numbers .btn-clavier[data-key="5"] { order: 5; }
    .custom-modal-keypad .numbers .btn-clavier[data-key="6"] { order: 6; }
    .custom-modal-keypad .numbers .btn-clavier[data-key="7"] { order: 7; }
    .custom-modal-keypad .numbers .btn-clavier[data-key="8"] { order: 8; }
    .custom-modal-keypad .numbers .btn-clavier[data-key="9"] { order: 9; }
    .custom-modal-keypad .numbers .btn-clavier[data-key="0"] {
        order: 10;
        width: calc(66.666% - 3px) !important;
    }

    .custom-modal-keypad .numbers .custom-modal-decimal-key {
        order: 11;
    }

    .custom-modal-keypad .actions-container .btn-clavier {
        width: 100% !important;
        height: 50% !important;
        font-size: 21px;
        font-weight: 700;
    }

    .custom-modal-keypad .actions-container .delete {
        font-size: 28px;
    }

    @media (max-width: 780px) {
        .custom-modal-dialog {
            padding: 24px 16px 16px;
        }

        .custom-modal-content {
            grid-template-columns: 1fr;
        }
    }

    @media (max-width: 520px) {
        .denomination-row {
            grid-template-columns: 82px minmax(0, 1fr);
        }

        .denomination-input {
            width: 100%;
        }
    }

    .clavier-container.vente-direct-box {
        height: initial;
        padding: 0;
        z-index: 0 !important;
    }
    .closure-title {
        font-family: "DM Sans";
    }

    .closure-summary-label {
        font-family: "DM Sans";
    }

    .closure-panel-title {
        font-family: "DM Sans";
    }

    .closure-topbar {
        margin-bottom: 12px;
    }
    .back-link {
        display: none;
    }

    .col-md-12.cardradius {
        padding: 0 !important;
    }

    thead tr:first-child th {
        background-color: var(--Onyx-035);
        vertical-align: middle !important;
        padding-bottom: 0 !important;
    }
    .table-container .table tbody tr td {
    
     order-bottom: 1px solid #fff !important;
     padding-bottom: 8px !important;
    }
    .table > thead:nth-child(1) > tr:nth-child(1) > th:nth-child(5) {
        display: none;
    }
    .table-container .table tbody tr td:nth-child(5),
    .table-container .table tbody tr td:nth-child(6) {
        display: none;
    }


</style>
<div class="vd-header">
    <img src="${pageContext.request.contextPath}/assets/img/logo_A.png" alt="logo" id="site-logo">
    <div class="form-input w-100">
        <%--        CHANGE STE--%>
        <input value="" class="form-control ui-autocomplete-input ui-autocomplete-loading" id="idProduit_libelle"  type="text" oninput="autoCompleteVenteDirect('idProduit_libelle','ST_INGREDIENTSVENTEPOS','produits.Ingredients','photo;libelle;reference;quantite=1;pv;codegros;pvgros;remise=0;prix=0;unite;compte_vente','photo;designation;reference;qte;pu;codegros;pu_pvgros;remiseMontant;prix;unite;compte','id')")
        />
        <input value='' class='form-control' id='idProduit' name='idProduit' type='hidden'/>
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
                <li><a href="${pageContext.request.contextPath}/pages/module.jsp?but=caisse/mvt/mvtcaisse-entree-pos.jsp">Entr&eacute;e de caisse</a></li>
                <li><a href="${pageContext.request.contextPath}/pages/module.jsp?but=caisse/mvt/mvtcaisse-sortie-pos.jsp">Sortie de caisse</a></li>
                <li><a href="${pageContext.request.contextPath}/pages/module.jsp?but=caisse/virementIntraCaisse/virementIntraCaisse-saisie-pos.jsp">Transfert de caisse</a></li>
            </ul>
        </div>
        <a class="btn btn-tertiary" href="${pageContext.request.contextPath}/pages/module.jsp?but=cloturecaisse/cloturecaisse-saisie.jsp" >
            Cl&ocirc;ture de caisse
        </a>
    </div>
    <div class="btn btn-tertiary">
        <i class="material-symbols-rounded">account_circle</i>
        <%=user.getCnapsUser().getUsername()%>
    </div>
</div>
<div class="content-wrapper closure-pos-page">
    <div class="closure-topbar">
        <div>
            <h1 class="closure-title">Ouverture de caisse</h1>
            <p class="closure-subtitle">Veuillez entrer le montant d'ouverture du fond de caisses.</p>
        </div>
        <div class="closure-date" id="closureCurrentDate"></div>
    </div>
    <form action="<%=pi.getLien()%>?but=caisse/apresMultipleCaisse.jsp" method="post" id="venteForm"  data-parsley-validate>
        <div class="closure-layout">
            <div class="closure-panel closure-form-panel">
                <h2 class="closure-panel-title">D&eacute;claration des fonds</h2>
                <div class="col-md-8 nopadding">
                    <div class="d-none">
                        <%
                            out.println(pi.getFormu().getHtmlInsert());
                        %>
                    </div>
                    <%
                        out.println(pi.getFormufle().getHtmlTableauInsert());
                    %>
                </div>
            </div>
            <div class="closure-panel closure-summary-panel">
                <h2 class="closure-panel-title">Synth&egrave;se des caisses</h2>
                <div class="closure-summary-card">
                    <span class="closure-summary-label">Total compt&eacute;</span>
                    <span class="closure-summary-total"><span id="closureCountedTotal">0</span> Ar</span>
                </div>
                <h3 class="closure-keypad-title"></h3>
                <div class="clavier-container vente-direct-box clr" >
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
                        <button class="btn-clavier btn col-md-12 h520pxRegular" data-toggle="modal" data-target="#clavier-abc" type="button" >ABC</button>
                    </div>
                </div>
                <button type="submit" class="closure-submit-btn">Confirmer</button>
            </div>
        </div>
        <input name="acte" type="hidden" id="nature" value="insertFilleSeulAvecValidation">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
<%--        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">--%>
        <input name="nomtable" type="hidden" id="nomtable" value="REPORTCAISSE">

    </form>
</div>


<div id="montantModal" class="custom-modal" aria-hidden="true">
    <div class="custom-modal-overlay" id="montantModalOverlay"></div>
    <div class="custom-modal-dialog" role="dialog" aria-labelledby="montantModalTitle">
        <button type="button" class="custom-modal-close" id="montantModalClose" aria-label="Fermer">&times;</button>
        <h3 class="custom-modal-title" id="montantModalTitle">D&eacute;claration d&rsquo;esp&egrave;ces</h3>
        <p class="custom-modal-subtitle">Indiquez le nombre de billets pour chaque coupure.</p>
        <div class="custom-modal-content">
            <div class="custom-modal-body">
	                <div class="denomination-row">
	                    <span class="denomination-label">20&nbsp;000 Ar&nbsp;&nbsp;x</span>
	                    <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="20000">
	                </div>
	                <div class="denomination-row">
	                    <span class="denomination-label">10&nbsp;000 Ar&nbsp;&nbsp;x</span>
	                    <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="10000">
	                </div>
	                <div class="denomination-row">
	                    <span class="denomination-label">5&nbsp;000 Ar&nbsp;&nbsp;x</span>
	                    <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="5000">
	                </div>
	                <div class="denomination-row">
	                    <span class="denomination-label">2&nbsp;000 Ar&nbsp;&nbsp;x</span>
	                    <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="2000">
	                </div>
	                <div class="denomination-row">
	                    <span class="denomination-label">1&nbsp;000 Ar&nbsp;&nbsp;x</span>
	                    <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="1000">
	                </div>
	                <div class="denomination-row">
	                    <span class="denomination-label">500 Ar&nbsp;&nbsp;x</span>
	                    <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="500">
	                </div>
	                <div class="denomination-row">
	                    <span class="denomination-label">200 Ar&nbsp;&nbsp;x</span>
	                    <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="200">
	                </div>
	                <div class="denomination-row">
	                    <span class="denomination-label">100 Ar&nbsp;&nbsp;x</span>
	                    <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="100">
	                </div>
	                <div class="denomination-row">
	                    <span class="denomination-label">50 Ar&nbsp;&nbsp;x</span>
	                    <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="50">
	                </div>
	                <div class="denomination-row">
	                    <span class="denomination-label">20 Ar&nbsp;&nbsp;x</span>
	                    <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="20">
	                </div>
	                <div class="denomination-row">
	                    <span class="denomination-label">10 Ar&nbsp;&nbsp;x</span>
	                    <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="10">
	                </div>
	            </div>
	            <div class="custom-modal-side">
	                <div class="custom-modal-total"><strong>Total</strong><span id="montantModalTotal">0 Ar</span></div>
	                <div class="custom-modal-keypad">
	                    <div class="clavier-container vente-direct-box" >
	                        <div class="numbers col-md-10 nopadding">
	                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="1" >1</button>
	                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="2" >2</button>
	                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="3" >3</button>
	                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="4" >4</button>
	                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="5" >5</button>
	                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="6" >6</button>
	                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="7" >7</button>
	                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="8" >8</button>
	                            <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="9" >9</button>
	                            <button class="btn-clavier btn col-md-12 h142pxRegular" type="button" data-key="0" >0</button>
	                            <button class="btn-clavier btn col-md-3 h142pxRegular custom-modal-decimal-key" type="button" data-key="," >,</button>
	                        </div>
	                        <div class="actions-container col-md-4 nopadding">
	                            <button class="btn-clavier btn col-md-12 h142pxRegular delete" type="button" id="deleteBtn2" ><i class="material-symbols-rounded">backspace</i></button>
	                            <button class="btn-clavier btn col-md-12 h520pxRegular" type="button" disabled>ABC</button>
	                        </div>
	                    </div>
	                    <div class="custom-modal-footer">
	                        <button type="button" class="custom-modal-btn secondary" id="montantModalCancel">Annuler</button>
	                        <button type="button" class="custom-modal-btn primary" id="montantModalValidate">Valider</button>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	</div>
<div id="globalLoader" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;z-index:99999;background:rgba(255,255,255,0.7);justify-content:center;align-items:center;">
    <div style="text-align:center;">
        <div class="spinner-border"  role="status"></div>
        <div style="margin-top:1rem;font-size:1.2rem;color:var(--VD-main-color)">Chargement...</div>
    </div>
</div>
<script>
    // Loader
    var loader = document.getElementById('globalLoader');
    // Affiche le loader dès le début
    loader.style.display = 'flex';

    // Masque le loader quand la page est complètement chargée
    window.addEventListener('load', function() {
        loader.style.display = 'none';
    });

    // Affiche le loader lors de la soumission du formulaire
    document.addEventListener('DOMContentLoaded', function() {
        var form = document.getElementById('venteForm');
        if (form && loader) {
            form.addEventListener('submit', function() {
                loader.style.display = 'flex';
            });
        }
    });
</script>
<script>
    function parseClosureAmount(value) {
        if (value === null || value === undefined) {
            return 0;
        }
        var normalized = String(value).replace(/\s+/g, '').replace(',', '.');
        var parsed = parseFloat(normalized);
        return Number.isFinite(parsed) ? parsed : 0;
    }

    function formatClosureAmount(value) {
        return Math.round(value).toLocaleString('fr-FR');
    }

    function updateClosureHeaderDate() {
        var target = document.getElementById('closureCurrentDate');
        if (!target) {
            return;
        }
        var now = new Date();
        var dateFormatter = new Intl.DateTimeFormat('fr-FR', {
            day: '2-digit',
            month: 'long',
            year: 'numeric'
        });
        var timeFormatter = new Intl.DateTimeFormat('fr-FR', {
            hour: '2-digit',
            minute: '2-digit'
        });
        target.textContent = dateFormatter.format(now) + '   ' + timeFormatter.format(now);
    }

    function updateClosureSummary() {
        var counted = 0;
        var expected = 0;
        document.querySelectorAll('input[id^="montant_"]').forEach(function(input) {
            counted += parseClosureAmount(input.value);
        });
        document.querySelectorAll('input[id^="montantTheorique_"]').forEach(function(input) {
            expected += parseClosureAmount(input.value);
        });

        var countedTarget = document.getElementById('closureCountedTotal');
        var expectedTarget = document.getElementById('closureExpectedTotal');
        var differenceTarget = document.getElementById('closureDifference');
        var totalTarget = document.getElementById('montanttotal');

        if (countedTarget) {
            countedTarget.textContent = formatClosureAmount(counted);
        }
        if (expectedTarget) {
            expectedTarget.textContent = formatClosureAmount(expected) + ' Ar';
        }
        if (differenceTarget) {
            differenceTarget.textContent = formatClosureAmount(counted - expected) + ' Ar';
        }
        if (totalTarget) {
            totalTarget.textContent = formatClosureAmount(counted);
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        updateClosureHeaderDate();
        updateClosureSummary();
        document.querySelectorAll('input[id^="montant_"], input[id^="montantTheorique_"]').forEach(function(input) {
            input.addEventListener('input', updateClosureSummary);
            input.addEventListener('change', updateClosureSummary);
        });
    });
</script>
<script>
    function formatWithThousandSeparator(num) {
        if (num === null || num === undefined || num === '') {
            return '';
        }

        let str = num.toString().replace(/[,\s]/g, '');

        let parsed = parseFloat(str);
        if (isNaN(parsed)) {
            return str;
        }

        return parsed.toLocaleString('fr-FR', {
            maximumFractionDigits: 0,
            useGrouping: true
        });
    }

    function addThousandSeparator(input) {
        if (!input) return;

        let start = input.selectionStart;
        let end = input.selectionEnd;

        let originalValue = input.value.replace(/[,\s]/g, '');

        if (originalValue !== '' && !isNaN(originalValue)) {
            let formattedValue = formatWithThousandSeparator(originalValue);

            if (input.value !== formattedValue) {
                input.value = formattedValue;

                let newStart = start;
                let newEnd = end;

                if (start <= originalValue.length) {
                    let originalBeforeCursor = originalValue.substring(0, start);
                    let formattedBeforeCursor = formatWithThousandSeparator(originalBeforeCursor);
                    newStart = formattedBeforeCursor.length;
                    newEnd = newStart + (end - start);
                }

                newStart = Math.min(newStart, input.value.length);
                newStart = Math.max(0, newStart);
                newEnd = Math.min(newEnd, input.value.length);
                newEnd = Math.max(newStart, newEnd);

                input.setSelectionRange(newStart, newEnd);
            }
        }
    }

    function handleNumberInput(event) {
        let input = event.target;
        if (input.name && (input.name.includes('montant') || input.name.includes('Montant'))) {
            let valueWithoutSpaces = input.value.replace(/[,\s]/g, '');
            if (valueWithoutSpaces === '' || !isNaN(valueWithoutSpaces)) {
                setTimeout(() => {
                    let cursorPos = input.selectionStart;

                    let originalValue = input.value.replace(/[,\s]/g, '');

                    if (originalValue !== '' && !isNaN(originalValue)) {
                        let formattedValue = formatWithThousandSeparator(originalValue);

                        if (input.value !== formattedValue) {
                            input.value = formattedValue;

                            if (cursorPos <= originalValue.length) {
                                let formattedBeforeCursor = formatWithThousandSeparator(originalValue.substring(0, cursorPos));
                                cursorPos = formattedBeforeCursor.length;
                            }

                            cursorPos = Math.min(cursorPos, input.value.length);
                            cursorPos = Math.max(0, cursorPos);

                            input.setSelectionRange(cursorPos, cursorPos);
                        }
                    }
                }, 10);
            }
        }
    }

    function applyThousandSeparators() {
        let amountInputs = document.querySelectorAll('input[name*="montant" i]');

        amountInputs.forEach(input => {
            if (input.value && input.value.trim() !== '') {
                let originalValue = input.value.replace(/[,\s]/g, '');
                if (originalValue !== '' && !isNaN(originalValue)) {
                    input.value = formatWithThousandSeparator(originalValue);
                }
            }

            input.addEventListener('input', handleNumberInput);
            input.addEventListener('blur', function(e) {
                let input = e.target;
                if (input.name && (input.name.includes('montant') || input.name.includes('Montant'))) {
                    let valueWithoutSpaces = input.value.replace(/[,\s]/g, '');
                    if (valueWithoutSpaces !== '' && !isNaN(valueWithoutSpaces)) {
                        input.value = formatWithThousandSeparator(valueWithoutSpaces);
                    }
                }
            });

            input.addEventListener('focus', function(e) {
                let input = e.target;
                if (input.name && (input.name.includes('montant') || input.name.includes('Montant'))) {
                    input.value = input.value.replace(/[,\s]/g, '');
                }
            });
        });
    }

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
        document.querySelectorAll('.form-control').forEach(input => {
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

        if (typeof $ !== 'undefined' && $(activeInput).data('ui-autocomplete')) {
            $(activeInput).autocomplete('search', activeInput.value);
        }
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

            const inputEvent = new Event('input', { bubbles: true, cancelable: true });
            activeInput.dispatchEvent(inputEvent);
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

        // Initialiser les séparateurs de millier
        applyThousandSeparators();

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
        });

        // Arrêter la répétition si on relâche en dehors du document
        document.addEventListener('mouseup', stopRepeat);
        document.addEventListener('touchend', stopRepeat);
    });

    // Rendre les fonctions disponibles globalement
    window.setActiveInput = setActiveInput;
    window.initVirtualKeyboard = initVirtualKeyboard;
</script>
<script>
    (function() {
        const modal = document.getElementById('montantModal');
        if (!modal) {
            return;
        }

        const overlay = document.getElementById('montantModalOverlay');
        const closeBtn = document.getElementById('montantModalClose');
        const cancelBtn = document.getElementById('montantModalCancel');
        const validateBtn = document.getElementById('montantModalValidate');
        const totalLabel = document.getElementById('montantModalTotal');
        const qtyInputs = Array.from(modal.querySelectorAll('input[data-denomination]'));

        let currentInput = null;

        function toNumber(value) {
            if (typeof value !== 'string') {
                value = String(value ?? '');
            }
            const normalized = value.replace(/\s+/g, '').replace(',', '.');
            const parsed = parseFloat(normalized);
            return Number.isFinite(parsed) && parsed > 0 ? parsed : 0;
        }

        function computeTotal() {
            return qtyInputs.reduce((sum, input) => {
                const qty = toNumber(input.value);
                const denom = Number(input.dataset.denomination || 0);
                if (!Number.isFinite(denom) || denom <= 0) {
                    return sum;
                }
                return sum + qty * denom;
            }, 0);
        }

        function updateTotal() {
            if (!totalLabel) {
                return;
            }
            const total = computeTotal();
            totalLabel.textContent = total.toLocaleString('fr-FR') + ' Ar';
        }

        function hydrateFromDataset(target) {
            qtyInputs.forEach(input => {
                input.value = '';
            });

            if (!target || !target.dataset || !target.dataset.billetage) {
                updateTotal();
                return;
            }

            try {
                const stored = JSON.parse(target.dataset.billetage);
                qtyInputs.forEach(input => {
                    const denom = input.dataset.denomination;
                    if (stored && Object.prototype.hasOwnProperty.call(stored, denom)) {
                        input.value = stored[denom];
                    }
                });
            } catch (err) {
                console.warn('Impossible de charger le billetage enregistré', err);
            }
            updateTotal();
        }

        function storeCountsOnInput(target) {
            if (!target) {
                return;
            }
            const stored = {};
            let hasValue = false;
            qtyInputs.forEach(input => {
                const qty = toNumber(input.value);
                const denom = input.dataset.denomination;
                if (qty > 0) {
                    stored[denom] = qty;
                    hasValue = true;
                }
            });

            if (hasValue) {
                target.dataset.billetage = JSON.stringify(stored);
            } else {
                delete target.dataset.billetage;
            }
        }

        function disableScroll() {
            document.body.dataset.prevOverflow = document.body.style.overflow;
            document.body.style.overflow = 'hidden';
        }

        function enableScroll() {
            const previous = document.body.dataset.prevOverflow;
            document.body.style.overflow = previous || '';
            delete document.body.dataset.prevOverflow;
        }

        function openModal(target) {
            currentInput = target;
            hydrateFromDataset(target);
            modal.classList.add('is-open');
            modal.setAttribute('aria-hidden', 'false');
            disableScroll();
            setTimeout(() => {
                const firstInput = qtyInputs[0];
                if (firstInput) {
                    firstInput.focus();
                    firstInput.select();
                }
            }, 0);
        }

        function closeModal(applyResult) {
            if (applyResult && currentInput) {
                const total = computeTotal();
                currentInput.value = total > 0 ? total.toString() : '';
                storeCountsOnInput(currentInput);
                currentInput.dispatchEvent(new Event('input', { bubbles: true }));
                currentInput.dispatchEvent(new Event('change', { bubbles: true }));
            }

            modal.classList.remove('is-open');
            modal.setAttribute('aria-hidden', 'true');
            enableScroll();
            currentInput = null;
        }

        function handleTriggerClick(event) {
            const target = event.target;
            if (!target || !target.id || !target.id.startsWith('montant_')) {
                return;
            }
            const parts = target.id.split('_');
            if (parts.length < 2) {
                return;
            }
            const index = parts[parts.length - 1];
            const labelInput = document.getElementById('caisseLib_' + index);
            if (labelInput && labelInput.value && /esp.{1,2}ce/i.test(labelInput.value)) {
                event.preventDefault();
                openModal(target);
            }
        }

        qtyInputs.forEach(input => {
            input.addEventListener('input', updateTotal);
            input.addEventListener('change', updateTotal);
        });

        overlay?.addEventListener('click', () => closeModal(false));
        closeBtn?.addEventListener('click', () => closeModal(false));
        cancelBtn?.addEventListener('click', () => closeModal(false));
        validateBtn?.addEventListener('click', () => closeModal(true));

        document.addEventListener('click', handleTriggerClick, true);

        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape' && modal.classList.contains('is-open')) {
                closeModal(false);
            }
        });
    })();

    window.onload = function() {
        const footers = document.querySelectorAll('.box-footer');
        const lastFooter = footers[footers.length - 1];

        if (lastFooter) {
            // Cacher tous les boutons existants
            const allButtons = lastFooter.querySelectorAll('a, button, input[type="button"], input[type="submit"]');
            allButtons.forEach(btn => {
                btn.style.display = 'none';
            });

            // Ajouter ton bouton "Enregistrer et imprimer"
            lastFooter.innerHTML += `
            <button class="btn btn-primary pull-right"
               style="display:block;margin-right:62px;margin-top:20px;">
               Enregistrer
            </button>
        `;
        }
    }
</script>

<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>
