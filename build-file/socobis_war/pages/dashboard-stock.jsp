<%@ page import="user.UserEJB" %>
<%@ page import="affichage.*" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="stock.*" %>
<%@ page import="inventaire.*" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="bean.ResultatEtSomme" %>
<%@ page import="constante.ConstanteDashboard" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="magasin.MagasinLib" %>
<%@ page import="magasin.MagasinPointCompte" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    try {
        String lien = (String) session.getAttribute("lien");
        String backgroundColor = ConstanteDashboard.DEFAULT_GRAPH_BACKGROUND_COLOR;
        String[] palettes = ConstanteDashboard.DEFAULT_COLORS;

        // 1. DATA STOCK (Valeur, Catégories, Magasins)
        PageRecherche[] pr = new PageRecherche[4];
        StockDashboardCpl stockRef = new StockDashboardCpl();
        pr[0] = new PageRecherche(stockRef, request, new String[]{"idMagasinLib"}, new String[]{}, 4, new String[]{}, 0);
        pr[0].setUtilisateur((user.UserEJB) session.getAttribute("u"));
        pr[0].setNpp(10000);

        // 2. DATA INVENTAIRE (Écarts)
        InventaireEcartDashboard ecartRef = new InventaireEcartDashboard();
        pr[1] = new PageRecherche(ecartRef, request, new String[]{"idMagasinLib"}, new String[]{}, 4, new String[]{}, 0);
        pr[1].setUtilisateur((user.UserEJB) session.getAttribute("u"));
        pr[1].setUtilisateur((user.UserEJB) session.getAttribute("u"));

        // 3. DATA TRANSFERTS
        TransfertDashboardCpl transRef = new TransfertDashboardCpl();
        pr[2] = new PageRecherche(transRef, request, new String[]{"idMagasinDepartLib"}, new String[]{}, 4, new String[]{}, 0);
        pr[2].setUtilisateur((user.UserEJB) session.getAttribute("u"));

        MagasinPointCompte magCount = new MagasinPointCompte();
        pr[3] = new PageRecherche(magCount, request, new String[]{"nbrMagasin"}, new String[]{}, 4, new String[]{}, 0);
        pr[3].setUtilisateur((user.UserEJB) session.getAttribute("u"));

        PageRecherche.creerObjetPage(pr);
        ResultatEtSomme rsStock = pr[0].getRs();
        ResultatEtSomme rsEcart = pr[1].getRs();
        ResultatEtSomme rsTrans = pr[2].getRs();
        ResultatEtSomme rsmagCount = pr[3].getRs();

        // --- GRAPHIQUES ---

        // KPI Valeur Stock
        DashboardGraphOpt kpiValeur = new DashboardGraphOpt(rsStock, null, new String[]{"Valeur totale du stock"}, DashboardGraphType.KPI);
        kpiValeur.setTitre("Valeur en stock");
        kpiValeur.setColValeur(new String[]{"valeurStock"});
        kpiValeur.setUnite(" Ar");
        kpiValeur.setIcon("payments");
        kpiValeur.setCanvasId("kpiValeur");

        // KPI Nb Articles
        DashboardGraphOpt kpiArticles = new DashboardGraphOpt(rsStock, null, new String[]{"Articles en stock"}, DashboardGraphType.KPI);
        kpiArticles.setTitre("Nombre d'article");
        kpiArticles.setColValeur(new String[]{"nbArticles"});
        kpiArticles.setUnite(" Articles");
        kpiArticles.setIcon("inventory_2");
        kpiArticles.setCanvasId("kpiArticles");

        // KPI Nb
        DashboardGraphOpt kpiMagasin = new DashboardGraphOpt(rsmagCount, null, new String[]{"Magasin"}, DashboardGraphType.KPI);
        kpiMagasin.setTitre("Nombre de magasin");
        kpiMagasin.setColValeur(new String[]{"nbrMagasin"});
        kpiMagasin.setUnite(" Magasins");
        kpiMagasin.setIcon("inventory_2");
        kpiMagasin.setCanvasId("kpiMagasin");

        // Graphique Valeur par Magasin (Bar)
        DashboardGraphOpt gValMag = new DashboardGraphOpt(rsStock, new String[]{"idMagasinLib"}, new String[]{"Valeur"}, DashboardGraphType.BAR);
        gValMag.setColValeur(new String[]{"valeurStock"});
        gValMag.setTitre("Valeur du stock par magasin");
        gValMag.setIcon("paid");
        gValMag.setCanvasId("gValMag");
        gValMag.setColAffiche(new String[]{"valeurStock"});
        gValMag.setColSpan(8);

        // Graphique Valeur par Catégorie (Donut)
        DashboardGraphOpt gValCat = new DashboardGraphOpt(rsStock, new String[]{"idtypeproduitlib"}, new String[]{"Valeur"}, DashboardGraphType.DOUGHNUT);
        gValCat.setColValeur(new String[]{"valeurStock"});
        gValCat.setTitre("Valeur par catégorie");
        gValCat.setIcon("filter_8");
        gValCat.setCanvasId("gValCat");
        gValCat.setColSpan(4);

        // Graphique Transferts (Pie)
        DashboardGraphOpt gTrans = new DashboardGraphOpt(rsTrans, new String[]{"statutLib"}, new String[]{"Nombre"}, DashboardGraphType.PIE);
        gTrans.setColValeur(new String[]{"nb"});
        gTrans.setTitre("Répartition des transferts");
        gTrans.setIcon("compare_arrows");
        gTrans.setCanvasId("gTrans");
        gTrans.setColSpan(6);

        // Graphique Écarts par Magasin
        DashboardGraphOpt gEcart = new DashboardGraphOpt(rsEcart, new String[]{"idMagasinLib"}, new String[]{"Valeur Écart"}, DashboardGraphType.BAR);
        gEcart.setColValeur(new String[]{"valeurEcart"});
        gEcart.setTitre("Valeur des écarts d'inventaire");
        gEcart.setCanvasId("gEcart");
        gEcart.setIcon("arrow_range");
        gEcart.setColAffiche(new String[]{"valeurEcart"});
        gEcart.setColSpan(6);

        DashboardGraphOpt kpiEcartNb = new DashboardGraphOpt(rsEcart, null, new String[]{"Nombre d'écarts"}, DashboardGraphType.KPI);
        kpiEcartNb.setTitre("Nombre d'écarts");
        kpiEcartNb.setColValeur(new String[]{"ecart"});
        kpiEcartNb.setIcon("warning");
        kpiEcartNb.setUnite(" d'écarts");
        kpiEcartNb.setColAffiche(new String[]{"ecart"});
        kpiEcartNb.setCanvasId("kpiEcartNb");

        DashboardGraphOpt gQteMag = new DashboardGraphOpt(rsStock, new String[]{"idMagasinLib"}, new String[]{"Quantité"}, DashboardGraphType.BAR);
        gQteMag.setColValeur(new String[]{"reste"});
        gQteMag.setTitre("Quantité stock par magasin");
        gQteMag.setIcon("shopping_basket");
        gQteMag.setCanvasId("gQteMag");
        gQteMag.setColAffiche(new String[]{"reste"});
        gQteMag.setColSpan(6);

        DashboardGraphOpt gTransVal = new DashboardGraphOpt(rsTrans, new String[]{"idMagasinDepartLib"}, new String[]{"Valeur Transférée"}, DashboardGraphType.BAR);
        gTransVal.setColValeur(new String[]{"valeurTransferee"});
        gTransVal.setTitre("Valeur transférée par magasin");
        gTransVal.setIcon("local_shipping");
        gTransVal.setCanvasId("gTransVal");
        gTransVal.setColAffiche(new String[]{"valeurTransferee"});
        gTransVal.setColSpan(6);

        DashboardGraphOpt gEcartMag = new DashboardGraphOpt(rsEcart, new String[]{"idMagasinLib"}, new String[]{"Valeur Écart"}, DashboardGraphType.BAR);
        gEcartMag.setColValeur(new String[]{"valeurEcart"});
        gEcartMag.setTitre("Valeur des écarts par magasin");
        gEcartMag.setIcon("trending_down");
        gEcartMag.setCanvasId("gEcartMag");
        gEcartMag.setColAffiche(new String[]{"valeurEcart"});
        gEcartMag.setColSpan(6);

        gTransVal.creerGraph();
        gQteMag.creerGraph();
        kpiValeur.creerGraph();
        kpiArticles.creerGraph();
        kpiMagasin.creerGraph();
        kpiEcartNb.creerGraph();
        gValCat.creerGraph();
        gValMag.creerGraph();
        gTrans.creerGraph();
        gEcartMag.creerGraph();
        gEcart.creerGraph();
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Dashboard Gestion des Stocks</h1>
    </section>

    <section class="content">
        <!-- Section KPI -->
        <div class="row">
            <div class="col-md-4"><%=kpiValeur.getHtml()%></div>
            <div class="col-md-4"><%=kpiArticles.getHtml()%></div>
            <div class="col-md-4"><%=kpiMagasin.getHtml()%></div>
            <div class="col-md-4"><%=kpiEcartNb.getHtml()%></div>
        </div>

        <!-- Section Valeur -->
        <div class="row">
            <h2 class="col-md-12 h520pxSemibold">Analyse de la Valeur</h2>
            <%=gValMag.getHtml()%>
            <%=gQteMag.getHtml()%>
            <%=gValCat.getHtml()%>
        </div>

        <!-- Section Inventaire & Transferts -->
        <div class="row">
            <h2 class="col-md-12 h520pxSemibold">Risques & Flux</h2>
            <%=gEcart.getHtml()%>
            <%=gTrans.getHtml()%>
            <%=gEcartMag.getHtml()%>
            <%=gTransVal.getHtml()%>
        </div>

    </section>
</div>

<% } catch (Exception e) { e.printStackTrace(); } %>