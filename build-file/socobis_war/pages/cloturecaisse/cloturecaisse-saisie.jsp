<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="prevision.Prevision" %>
<%@page import="affichage.*" %>
<%@page import="user.*" %>
<%@page import="utils.*" %>
<%@ page import="annexe.Point" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="caisse.*" %>
<%@ page import="java.io.IOException" %>
<%@ page import="bean.CGenUtil" %>

<%
    try{
        UserEJB user = (UserEJB) session.getValue("u");
        String lien = (String) session.getValue("lien");

        ReportCaisse mapping = new ReportCaisse();
        ReportCaisse fille = new ReportCaisse();
        fille.setNomTable("REPORTCAISSE_SAISIE");

//        String idCaisse = session.getAttribute("idCaisse").toString();

//        String currentPoint = session.getAttribute("idPoint").toString();
//        System.out.println("POINT ++++++ " + currentPoint);
        CaisseSession sessionCaisse = new CaisseSession();
//        sessionCaisse.setIdPoint(currentPoint);
//        sessionCaisse.setIdCaisse(idCaisse);
//        if(idCaisse != null && idCaisse.compareToIgnoreCase("")!=0) {
//            if (user.getUser().getIdrole().equalsIgnoreCase("caisse")) {
//                sessionCaisse.setIdCaisse(session.getAttribute("idCaisse").toString());
//            }
//            int isExist = sessionCaisse.checkIfSessionOuverteExistePourPoint();
//            if (isExist == 0) {
//                throw new IOException("Vous devez effectuer une ouverture de caisse avant de faire une cloture");
//            }
//        }

        Billet billetCritere = new Billet();
        Billet[] billetsConfigures = (Billet[]) CGenUtil.rechercher(billetCritere, null, null, null, "");
        java.util.List<Billet> coupuresBillet = new java.util.ArrayList<Billet>();
        if (billetsConfigures != null) {
            for (Billet billetConfigure : billetsConfigures) {
                if (billetConfigure == null || billetConfigure.getId() == null || billetConfigure.getVal() == null) continue;
                try {
                    long coupure = Long.parseLong(billetConfigure.getVal().trim());
                    String idBillet = billetConfigure.getId().trim();
                    if (coupure > 0 && idBillet.matches("[A-Za-z0-9_-]+")) coupuresBillet.add(billetConfigure);
                } catch (NumberFormatException ignore) {
                    // Une valeur non monetaire ne doit pas casser la page de cloture.
                }
            }
        }
        java.util.Collections.sort(coupuresBillet, new java.util.Comparator<Billet>() {
            @Override
            public int compare(Billet billetGauche, Billet billetDroite) {
                long valeurGauche = Long.parseLong(billetGauche.getVal().trim());
                long valeurDroite = Long.parseLong(billetDroite.getVal().trim());
                int comparaisonValeur = Long.compare(valeurDroite, valeurGauche);
                if (comparaisonValeur != 0) return comparaisonValeur;
                return billetGauche.getId().compareToIgnoreCase(billetDroite.getId());
            }
        });
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
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("typeReport"), ConstanteAsync.type_report_fermeture);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("typeReport"),false);


        String dtJour = Utilitaire.dateDuJour();
        pi.getFormu().getChamp("daty").setDefaut(dtJour);
//        pi.getFormu().getChamp("idPoint").setDefaut(point);
//        pi.getFormu().getChamp("remarque").setDefaut("Cloture de caisse du " + dtJour);


        pi.getFormufle().getChamp("caisseLib_0").setLibelle("Caisse");
        pi.getFormufle().getChamp("montantTheorique_0").setLibelle("Montant Th&eacute;orique");
        pi.getFormufle().getChamp("montant_0").setLibelle("Montant R&eacute;el");
        pi.getFormufle().getChamp("idCaisse_0").setVisible(false);
//        pi.getFormufle().getChamp("explication_0").setLibelle("Explication");
        pi.getFormufle().getChampMulitple("id").setVisible(false);
//        pi.getFormufle().getChampMulitple("idCloture").setVisible(false);
        pi.getFormufle().getChampMulitple("idCaisse").setVisible(false);
        pi.getFormufle().getChampMulitple("idCategorieCaisse").setVisible(false);
        pi.getFormufle().getChampMulitple("billetage").setVisible(false);
        pi.getFormufle().getChampMulitple("caisseLib").setAutre("readonly");
//        pi.getFormufle().getChampMulitple("explication").setVisible(false);
        pi.getFormufle().getChampMulitple("montantTheorique").setAutre("readonly");

        pi.getFormufle().getChampMulitple("etat").setVisible(false);

        pi.getFormufle().getChampMulitple("daty").setVisible(false);

        pi.getFormufle().getChampMulitple("heure").setVisible(false);
        pi.getFormufle().getChampMulitple("idUser").setVisible(false);

        ReportCaisse[] filles = mapping.genererCaisseAFermer(user.getListeCaisseReport(),null);
        nombreLigne = filles == null ? 0 : filles.length;
        System.out.println("filles " + nombreLigne);
        if (nombreLigne > 0) {
            pi.setDefautFille(filles);
        }
        // setDefautFille ajoute volontairement des lignes libres. La cloture
        // doit conserver exactement une ligne par caisse.
        pi.setNombreLigne(nombreLigne);
        pi.getFormufle().setNbLigne(nombreLigne);
        String[] order ={"caisseLib", "montantTheorique","montant"};
        pi.getFormufle().setColOrdre(order);

        String classeMere = "caisse.ClotureCaisse";
        String nomTableMere = "REPORTCAISSE";
        String butApresPost = "caisse/mvt/fermeture-session.jsp";
        String classeFille = "caisse.ReportCaisse";
        String colonneMere = "idcloture";


        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<style>
    #venteForm .table-container.nopadding.borderless table tbody tr td input[readonly] {
        background-color: #eee !important ;
    }
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
        width: calc(100% - 3px) !important;
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
<div class="content-wrapper closure-pos-page">
    <div class="closure-topbar">
        <div>
            <h1 class="closure-title">Clôture de caisse</h1>
            <p class="closure-subtitle">V&eacute;rifiez les totaux et d&eacute;clarez les montants r&eacute;els en caisse.</p>
        </div>
        <div class="closure-date" id="closureCurrentDate"></div>
    </div>
    <form action="<%=pi.getLien()%>?but=caisse/apresMultipleCaisse.jsp" method="post" id="venteForm"  data-parsley-validate>
        <div class="col-md-12 nopadding" >
            <h3 class="h520pxSemibold" style="display:none;background: white;padding: 16px;margin-top: 10px;border-radius:8px;border: 1px solid var(--Border);">Total  : <span id="montanttotal">0</span><span id="deviseLibelle">Ar</span></h3>
        </div>
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
                <div class="closure-summary-lines">
                    <div class="closure-summary-line"><span>Montant attendu</span><span id="closureExpectedTotal">0 Ar</span></div>
                    <div class="closure-summary-line danger"><span>&Eacute;cart</span><span id="closureDifference">0 Ar</span></div>
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
                <button type="submit" class="closure-submit-btn">Cl&ocirc;turer</button>
            </div>
        </div>
        <input name="acte" type="hidden" id="nature" value="insertAvecValidation">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
        <input name="nomtable" type="hidden" id="nomtable" value="REPORTCAISSE">

    </form>
</div>

<script>
    (function cleanGeneratedClosureRows() {
        'use strict';

        const form = document.getElementById('venteForm');
        const expectedCountInput = document.getElementById('nombreLigne');
        if (!form || !expectedCountInput) return;

        const expectedCount = Math.max(parseInt(expectedCountInput.value, 10) || 0, 0);
        const childContainer = form.querySelector('#butfillejsp') || form;

        childContainer.querySelectorAll('tr[id^="ligne-multiple-"]').forEach(function(row) {
            const match = row.id.match(/ligne-multiple-(\d+)$/);
            if (match && parseInt(match[1], 10) >= expectedCount) row.remove();
        });

        form.querySelectorAll('[name]').forEach(function(field) {
            const match = field.name.match(/_(\d+)$/);
            if (match && parseInt(match[1], 10) >= expectedCount) field.remove();
        });

        ['nbrLigne', 'indexMultiple'].forEach(function(id) {
            const counter = document.getElementById(id);
            if (counter) counter.value = String(expectedCount);
        });
    })();
</script>

<div id="montantModal" class="custom-modal" aria-hidden="true">
    <div class="custom-modal-overlay" id="montantModalOverlay"></div>
    <div class="custom-modal-dialog" role="dialog" aria-labelledby="montantModalTitle">
        <button type="button" class="custom-modal-close" id="montantModalClose" aria-label="Fermer">&times;</button>
        <h3 class="custom-modal-title" id="montantModalTitle">D&eacute;claration d&rsquo;esp&egrave;ces</h3>
        <p class="custom-modal-subtitle">Indiquez le nombre de billets pour chaque coupure.</p>
        <div class="custom-modal-content">
            <div class="custom-modal-body">
                <% if (coupuresBillet.isEmpty()) { %>
                <div class="denomination-empty" role="alert">
                    Aucune coupure n&rsquo;est configur&eacute;e.
                </div>
                <% } else {
                    for (Billet coupureBillet : coupuresBillet) {
                        long valeurCoupure = Long.parseLong(coupureBillet.getVal().trim());
                        String idBillet = coupureBillet.getId().trim();
                        String libelleCoupure = java.text.NumberFormat
                                .getIntegerInstance(java.util.Locale.FRANCE)
                                .format(valeurCoupure);
                %>
                <div class="denomination-row">
                    <span class="denomination-label"><%= libelleCoupure %> Ar&nbsp;&nbsp;x</span>
                    <input type="text"
                           class="form-control denomination-input"
                           inputmode="numeric"
                           pattern="[0-9]*"
                           autocomplete="off"
                           data-billet-id="<%= idBillet %>"
                           data-denomination="<%= valeurCoupure %>"
                           aria-label="Nombre de coupures de <%= libelleCoupure %> Ariary">
                </div>
                <%  }
                } %>
            </div>
            <div class="custom-modal-side">
                <div class="custom-modal-total"><strong>Total</strong><span id="montantModalTotal">0 Ar</span></div>
                <div class="custom-modal-keypad">
                    <h4 class="custom-modal-keypad-title"></h4>
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
                        </div>
                        <div class="actions-container col-md-4 nopadding">
                            <button class="btn-clavier btn col-md-12 h142pxRegular delete" type="button" id="deleteBtn2" ><i class="material-symbols-rounded">backspace</i></button>
                            <button class="btn-clavier btn col-md-12 h520pxRegular" type="button" disabled>ABC</button>
                        </div>
                    </div>
                    <div class="custom-modal-footer">
                        <button type="button" class="custom-modal-btn secondary" id="montantModalCancel">Annuler</button>
                        <button type="button" class="custom-modal-btn primary" id="montantModalValidate"<%= coupuresBillet.isEmpty() ? " disabled" : "" %>>Valider</button>
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
    function getClosureLoader() {
        return document.getElementById('globalLoader');
    }

    function showClosureLoader() {
        var loader = getClosureLoader();
        if (loader) loader.style.display = 'flex';
    }

    function hideClosureLoader() {
        var loader = getClosureLoader();
        if (loader) loader.style.display = 'none';
    }

    hideClosureLoader();

    window.addEventListener('pageshow', hideClosureLoader);
    window.addEventListener('pagehide', hideClosureLoader);
    window.addEventListener('error', function() {
        hideClosureLoader();
    });
    window.addEventListener('unhandledrejection', function() {
        hideClosureLoader();
    });
    document.addEventListener('DOMContentLoaded', function() {
        var form = document.getElementById('venteForm');
        if (!form) return;
        hideClosureLoader();
        form.addEventListener('submit', function(event) {
            window.setTimeout(function() {
                if (event.defaultPrevented) {
                    hideClosureLoader();
                    return;
                }
                showClosureLoader();
            }, 0);
        });
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
        if (input && !input.readOnly && !input.disabled) {
            input.classList.add('active');
            activeInput = input;
        } else {
            activeInput = null;
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
        if (!activeInput || activeInput.readOnly || activeInput.disabled) return;

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
        if (!activeInput || activeInput.readOnly || activeInput.disabled) return;

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
        'use strict';

        const modal = document.getElementById('montantModal');
        if (!modal) return;

        const CASH_CATEGORY = '<%= ConstanteAsync.caisseCategEspeece %>'.trim().toLowerCase();
        const overlay = document.getElementById('montantModalOverlay');
        const closeBtn = document.getElementById('montantModalClose');
        const cancelBtn = document.getElementById('montantModalCancel');
        const validateBtn = document.getElementById('montantModalValidate');
        const totalLabel = document.getElementById('montantModalTotal');
        const qtyInputs = Array.from(modal.querySelectorAll('input[data-billet-id][data-denomination]'));
        const allowedBilletIds = new Set(qtyInputs.map(function(input) {
            return input.dataset.billetId;
        }));

        let currentInput = null;

        function getRowIndex(input) {
            return input && input.id ? input.id.replace('montant_', '') : '';
        }

        function getBilletageInput(index) {
            let input = document.getElementById('billetage_' + index);
            if (input) return input;

            const form = document.getElementById('venteForm');
            if (!form) return null;
            input = document.createElement('input');
            input.type = 'hidden';
            input.id = 'billetage_' + index;
            input.name = 'billetage_' + index;
            form.appendChild(input);
            return input;
        }

        function isCashInput(input) {
            const index = getRowIndex(input);
            if (!index && index !== '0') return false;

            const categoryInput = document.getElementById('idCategorieCaisse_' + index);
            const category = categoryInput && categoryInput.value
                ? categoryInput.value.trim().toLowerCase()
                : '';
            if (category && category === CASH_CATEGORY) return true;

            const labelInput = document.getElementById('caisseLib_' + index);
            return !!(labelInput && labelInput.value && /esp.{1,2}ce/i.test(labelInput.value));
        }

        function normalizeQuantity(value) {
            const raw = String(value == null ? '' : value).trim();
            if (!/^\d+$/.test(raw)) return '';
            const quantity = parseInt(raw, 10);
            return Number.isFinite(quantity) && quantity > 0 ? String(quantity) : '';
        }

        function parseBilletage(serialized) {
            const result = {};
            String(serialized || '').split(';').forEach(function(part) {
                const match = part.match(/^([^:;]+):(\d+)$/);
                if (!match || !allowedBilletIds.has(match[1])) return;
                const quantity = parseInt(match[2], 10);
                if (quantity > 0) result[match[1]] = quantity;
            });
            return result;
        }

        function serializeBilletage() {
            return qtyInputs.reduce(function(parts, input) {
                const quantity = parseInt(normalizeQuantity(input.value), 10);
                if (quantity > 0) {
                    parts.push(input.dataset.billetId + ':' + quantity);
                }
                return parts;
            }, []).join(';');
        }

        function computeTotalFromMap(counts) {
            return qtyInputs.reduce(function(total, input) {
                const denomination = parseInt(input.dataset.denomination, 10);
                const quantity = parseInt(counts[input.dataset.billetId] || 0, 10);
                return total + denomination * quantity;
            }, 0);
        }

        function computeTotal() {
            const counts = {};
            qtyInputs.forEach(function(input) {
                counts[input.dataset.billetId] = parseInt(normalizeQuantity(input.value), 10) || 0;
            });
            return computeTotalFromMap(counts);
        }

        function updateTotal() {
            if (totalLabel) {
                totalLabel.textContent = computeTotal().toLocaleString('fr-FR') + ' Ar';
            }
        }

        function hydrateFromHidden(target) {
            const billetageInput = getBilletageInput(getRowIndex(target));
            const counts = parseBilletage(billetageInput ? billetageInput.value : '');
            qtyInputs.forEach(function(input) {
                const quantity = counts[input.dataset.billetId];
                input.value = quantity > 0 ? String(quantity) : '';
            });
            updateTotal();
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
            if (!target || !isCashInput(target) || modal.classList.contains('is-open')) return;
            currentInput = target;
            hydrateFromHidden(target);
            modal.classList.add('is-open');
            modal.setAttribute('aria-hidden', 'false');
            disableScroll();
            setTimeout(function() {
                if (qtyInputs[0]) {
                    qtyInputs[0].focus();
                    qtyInputs[0].select();
                }
            }, 0);
        }

        function closeModal(applyResult) {
            const target = currentInput;
            if (applyResult && target) {
                const billetageInput = getBilletageInput(getRowIndex(target));
                if (billetageInput) billetageInput.value = serializeBilletage();

                const total = computeTotal();
                target.value = total > 0 ? String(total) : '';
                target.dispatchEvent(new Event('input', { bubbles: true }));
                target.dispatchEvent(new Event('change', { bubbles: true }));
            }

            modal.classList.remove('is-open');
            modal.setAttribute('aria-hidden', 'true');
            enableScroll();
            if (typeof window.setActiveInput === 'function') window.setActiveInput(null);
            currentInput = null;
        }

        function prepareCashInputs() {
            document.querySelectorAll('input[id^="montant_"]').forEach(function(input) {
                if (!isCashInput(input)) return;

                const index = getRowIndex(input);
                const billetageInput = getBilletageInput(index);
                const counts = parseBilletage(billetageInput ? billetageInput.value : '');
                const total = computeTotalFromMap(counts);

                input.readOnly = true;
                input.inputMode = 'none';
                input.dataset.billetageTrigger = 'true';
                input.setAttribute('aria-haspopup', 'dialog');
                input.setAttribute('aria-controls', 'montantModal');
                input.placeholder = 'Appuyez sur Entrer pour compter les billets';
                input.value = total > 0 ? String(total) : '';
            });
        }

        function synchronizeCashAmounts() {
            document.querySelectorAll('input[data-billetage-trigger="true"]').forEach(function(input) {
                const billetageInput = getBilletageInput(getRowIndex(input));
                const counts = parseBilletage(billetageInput ? billetageInput.value : '');
                input.value = computeTotalFromMap(counts) || '';
            });
        }

        qtyInputs.forEach(function(input) {
            input.addEventListener('input', function() {
                input.value = normalizeQuantity(input.value);
                updateTotal();
            });
            input.addEventListener('change', function() {
                input.value = normalizeQuantity(input.value);
                updateTotal();
            });
        });

        if (overlay) overlay.addEventListener('click', function() { closeModal(false); });
        if (closeBtn) closeBtn.addEventListener('click', function() { closeModal(false); });
        if (cancelBtn) cancelBtn.addEventListener('click', function() { closeModal(false); });
        if (validateBtn) validateBtn.addEventListener('click', function() { closeModal(true); });

        document.addEventListener('click', function(event) {
            const target = event.target;
            if (target && target.matches('input[data-billetage-trigger="true"]')) {
                event.preventDefault();
                openModal(target);
            }
        }, true);

        document.addEventListener('focusin', function(event) {
            const target = event.target;
            if (target && target.matches('input[data-billetage-trigger="true"]')) {
                openModal(target);
            }
        });

        document.addEventListener('keydown', function(event) {
            if (modal.classList.contains('is-open')) {
                if (event.key === 'Escape') {
                    event.preventDefault();
                    closeModal(false);
                }
                return;
            }

            const target = event.target;
            if (target && target.matches('input[data-billetage-trigger="true"]')) {
                event.preventDefault();
                if (event.key === 'Enter' || event.key === ' ') openModal(target);
            }
        }, true);

        const form = document.getElementById('venteForm');
        if (form) {
            form.addEventListener('submit', synchronizeCashAmounts, true);
        }

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', prepareCashInputs);
        } else {
            prepareCashInputs();
        }

        window.POSClosureBilletage = {
            open: openModal,
            serialize: serializeBilletage,
            parse: parseBilletage,
            synchronize: synchronizeCashAmounts
        };
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
               Enregistrer et imprimer le rapport Z
            </button>
        `;
        }
    }
</script>
<%
} catch(Exception e) {
    e.printStackTrace();
%>

<script>
    var loader = document.getElementById('globalLoader');

    if (loader) {
        loader.style.display = 'none';
    }
</script>

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

<%
    }
%>
