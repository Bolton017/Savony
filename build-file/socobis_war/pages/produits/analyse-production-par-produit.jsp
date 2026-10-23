<%--
  Dashboard unifié - avec Analyse IA intégrée
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@page import="user.UserEJB"%>
<%@page import="affichage.*"%>
<%@ page import="vente.VenteDetailsLib" %>
<%@ page import="vente.VenteLib" %>
<%@ page import="faturefournisseur.FactureFournisseurCpl" %>
<%@ page import="faturefournisseur.FactureFournisseurDetailsCpl" %>
<%@ page import="java.util.Map" %>
<%@ page import="bean.ValeurEtiquette" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="constante.ConstanteDashboard" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="utils.ConstanteAsync" %>   <%-- ← ajout pour l'analyse IA --%>
<%@ page import="fabrication.Of" %>
<%@ page import="stock.*" %>
<%@ page import="fabrication.OfabLibCount" %>
<%@ page import="fabrication.SituationOfFille" %>

<script src="${pageContext.request.contextPath}/chartPlugins/Chart.min.js"></script>

<%
    try {
        String lien = (String) session.getAttribute("lien");
        UserEJB u = (user.UserEJB) session.getValue("u");
        String dateDuJour = Utilitaire.dateDuJour();
        String anneeCourante = Utilitaire.getAnnee(dateDuJour);
        String backgroundColor = ConstanteDashboard.DEFAULT_GRAPH_BACKGROUND_COLOR;
        String[] palettes = ConstanteDashboard.DEFAULT_COLORS;
        DashboardGraph[] graphs = new DashboardGraph[1];

        // ==================== Production par produit ====================
        MvtStockFilleEntreeFab mvtFab = new MvtStockFilleEntreeFab();
        String[] listeCrtProd   = {"daty"};
        String[] listeIntProd   = {"daty"};
        String[] pourcentageProd = {};
        String[] somDefautProd  = {"entree"};
        String[] colGrColProd   = {"idProduitlib"};
        String[] legendeProd    = {"Production"};

        PageRechercheGroupe prProd = new PageRechercheGroupe(
                mvtFab, request, listeCrtProd, listeIntProd,
                3, colGrColProd, somDefautProd, pourcentageProd, 4, 0
        );
        prProd.setNpp(2000);
        prProd.setAWhere(
                " AND IDFAB IS NOT NULL AND IDFAB LIKE 'FAB%'" +
                        " AND CATEGORIEINGREDIENT LIKE '%" + ConstanteSocobis.CATEGORIE_PRODUIT_FINI + "%'"
        );

        graphs[0] = new DashboardGraph(prProd, legendeProd, DashboardGraphType.BAR);
        graphs[0].setOrientation("horizontal");
        graphs[0].setTitre("Production par produit");
        graphs[0].setIcon("build");
        graphs[0].setColSpan(12);
        graphs[0].setLienPage(lien + "?but=produits/analyse-production-par-produit.jsp");
        graphs[0].setBackgroundColor(backgroundColor);
        graphs[0].setCouleurs(palettes);
        graphs[0].setCanvasId("chartProduction");

        // ==================== Titres pour l'analyse IA ====================
        String titreIA = "Analyse de la production par produit";
        String desceIA = "Analyse des quantités produites par produit fini";

        // ==================== Dashboard APJ ====================
        DashboardApj da = new DashboardApj(graphs, u);
        da.setApres("etats/dashboard-locale.jsp");
        da.setLien(lien);
        da.getFormu().getChamp("daty1").setDefaut(Utilitaire.getDebutAnnee(anneeCourante));
        da.getFormu().getChamp("daty2").setDefaut(dateDuJour);
        da.getFormu().getChamp("daty1").setLibelle("Date Min");
        da.getFormu().getChamp("daty2").setLibelle("Date Max");

        da.creerObjetPage(true);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Tableau de bord</h1>
    </section>
    <section class="content">

        <!-- Formulaire de filtre dates -->
        <form action="<%=lien%>?but=produits/analyse-production-par-produit.jsp" method="post" name="formulaire" id="dashboardForm">
            <%=da.getHtmlFormu()%>
        </form>

        <div class="row gap-2">
            <!-- Graphique production -->
            <div class="col-12">
                <%=graphs[0].getHtml()%>
            </div>

            <!-- ===== ANALYSE IA ===== -->
            <div class="col-12">
                <%=prProd.getHtmlWithEvaluation(
                        ConstanteAsync.API_URL,
                        ConstanteAsync.API_KEY,
                        titreIA,
                        desceIA
                )%>
            </div>
            <!-- ===================== -->
        </div>

    </section>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<%
    }
%>