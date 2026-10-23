<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 12/03/2026
  Time: 10:00
  Dashboard unifié des analyses médicales
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
<%@ page import="fabrication.Of" %>
<%@ page import="stock.*" %>
<%@ page import="fabrication.OfabLibCount" %>
<%@ page import="fabrication.SituationOfFille" %>

<!-- Inclusion de Chart.js pour les graphiques -->
<script src="${pageContext.request.contextPath}/chartPlugins/Chart.min.js"></script>

<%
    try {
        String lien = (String) session.getAttribute("lien");
        UserEJB u = (user.UserEJB) session.getValue("u");
        String dateDuJour = Utilitaire.dateDuJour();
        String anneeCourante = Utilitaire.getAnnee(dateDuJour);
        String backgroundColor = ConstanteDashboard.DEFAULT_GRAPH_BACKGROUND_COLOR;
        String[] palettes = ConstanteDashboard.DEFAULT_COLORS;
        String[] paramDaty = {"daty"};
        String[] paramVide = {};
        DashboardGraph[] graphs = new DashboardGraph[14];
        DashboardGraph[] graphsNoDaty = new DashboardGraph[14];

        // ==================== Production par produit ===============
        MvtStockFilleEntreeFab mvtFab = new MvtStockFilleEntreeFab();
        String listeCrtProd[] = {"daty"};
        String listeIntProd[] = {"daty"};
        String[] pourcentageProd = {};
        String somDefautProd[] = {"entree"};
        String colGrColProd[] = {"idProduitlib"};
        String[] legendeProd = {"Production"};

        PageRechercheGroupe prProd = new PageRechercheGroupe(mvtFab, request, listeCrtProd, listeIntProd, 3, colGrColProd, somDefautProd, pourcentageProd, 4, 0);
        prProd.setNpp(2000);
        prProd.setAWhere(" AND IDFAB IS NOT NULL  AND IDFAB LIKE 'FAB%' AND CATEGORIEINGREDIENT like '%"+ ConstanteSocobis.CATEGORIE_PRODUIT_FINI+"%'");
        graphs[0] = new DashboardGraph(prProd, legendeProd, DashboardGraphType.BAR);
        graphs[0].setOrientation("horizontal");
        graphs[0].setTitre("Production par produit");
        graphs[0].setIcon("build");
        graphs[0].setColSpan(12);
        graphs[0].setLienPage(lien + "?but=dashboard.jsp");
        graphs[0].setBackgroundColor(backgroundColor);
        graphs[0].setCouleurs(palettes);
        graphs[0].setCanvasId("chartProduction");

        //===================== ORDRE FABRICATION par etat ===============
        OfabLibCount of = new OfabLibCount();
        String listeCrtOf[] = {"daty"};
        String listeIntOf[] = {"daty"};
        String[] pourcentageOf = {};
        String somDefautOf[] = {"nb"};
        String colGrColOf[] = {"etatLib"};

        PageRechercheGroupe prOf = new PageRechercheGroupe(of, request, listeCrtOf, listeIntOf, 3, colGrColOf, somDefautOf, pourcentageOf, 4, 0);
        prOf.setNpp(2000);
        graphs[1] = new DashboardGraph(prOf, new String[]{"OF par état"}, DashboardGraphType.DOUGHNUT);
        graphs[1].setTitre("Ordres de fabrication par état");
        graphs[1].setIcon("build");
        graphs[1].setColSpan(12);
        graphs[1].setPositionLegende("left");
        graphs[1].setLienPage(lien + "?but=dashboard.jsp");
        graphs[1].setBackgroundColor(backgroundColor);
        graphs[1].setCouleurs(palettes);
        graphs[1].setCanvasId("chartOF");

        //======================== Repartition du cout de production  =================
        MvtStockFilleSortieFab mvtFabSortie = new MvtStockFilleSortieFab();
        mvtFabSortie.setNomTable("MVTSTOCKFILLESORTIEFAB");
        String listeCrtCout[] = {"daty"};
        String listeIntCout[] = {"daty"};
        String[] pourcentageCout = {};
        String somDefautCout[] = {"montant"};
        String colGrColCout[] = {"categorieIngredient"};
        String[] legendeCout = {"Coût de production"};

        PageRechercheGroupe prCout = new PageRechercheGroupe(mvtFabSortie, request, listeCrtCout, listeIntCout, 3, colGrColCout, somDefautCout, pourcentageCout, 4, 0);
        prCout.setNpp(2000);
        graphs[2] = new DashboardGraph(prCout, legendeCout, DashboardGraphType.DOUGHNUT);
        graphs[2].setTitre("Répartition du coût de production");
        graphs[2].setIcon("build");
        graphs[2].setPositionLegende("left");
        graphs[2].setColSpan(12);
        graphs[2].setUnite(" Ar");
        graphs[2].setLienPage(lien + "?but=dashboard.jsp");
        graphs[2].setBackgroundColor(backgroundColor);
        graphs[2].setCouleurs(palettes);
        graphs[2].setCanvasId("chartCoutProduction");


        // ==== Consommation matière vs prévue ==============
        MvtStockFilleTheorique t = new MvtStockFilleTheorique();
        t.setNomTable("stockEtDepenseFabThe");
        String listeCrt[] = {};
        String listeInt[] = {};
        String pourcentage[] = {};
        String somDefaut[] = {"sortie","qteth"};
        String colGrCol[] = {"idProduit",};
        String[] legende = {"Consommation réelle","Consommation théorique"};
        PageRechercheGroupe prConsommation = new PageRechercheGroupe(t, request, listeCrt, listeInt, 3, colGrCol, somDefaut, pourcentage, 4, 0);
        prConsommation.setNpp(2000);

//        graphsNoDaty[0] = new DashboardGraph(prConsommation, legende, DashboardGraphType.BAR);
//        graphsNoDaty[0].setOrientation("horizontal");
//        graphsNoDaty[0].setTitre("Consommation matière vs prévue");
//        graphsNoDaty[0].setIcon("build");
////        graphsNoDaty[0].setMultiAxes(true);
//        graphsNoDaty[0].setColSpan(12);
//        graphsNoDaty[0].setLienPage(lien + "?but=dashboard.jsp");
//        graphsNoDaty[0].setBackgroundColor(backgroundColor);
//        graphsNoDaty[0].setCouleurs(palettes);
//        graphsNoDaty[0].setCanvasId("chartConsommation");


        DashboardApj da = new DashboardApj(graphs, u);
        da.setApres("etats/dashboard-locale.jsp");
        da.setLien(lien);
        da.getFormu().getChamp("daty1").setDefaut(Utilitaire.getDebutAnnee(anneeCourante));
        da.getFormu().getChamp("daty2").setDefaut(dateDuJour);
        da.getFormu().getChamp("daty1").setLibelle("Date Min");
        da.getFormu().getChamp("daty2").setLibelle("Date Max");

        da.creerObjetPage(true);

//        DashboardApj daNoDaty = new DashboardApj(graphsNoDaty, u);
//        daNoDaty.setApres("etats/dashboard-locale.jsp");
//        daNoDaty.setLien(lien);
//        daNoDaty.creerObjetPage(true);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Tableau de bord</h1>
    </section>
    <section class="content">
        <!-- Formulaire unique pour tous les filtres -->
        <form action="<%=lien%>?but=dashboard.jsp" method="post" name="formulaire" id="dashboardForm">
            <%=da.getHtmlFormu()%>
        </form>
        <div class="row gap-2">
            <div class="col-12">
                <%=graphs[0].getHtml()%>
            </div>
            <div class="col-12">
                <%=graphs[1].getHtml()%>
            </div>
            <div class="col-12">
                <%=graphs[2].getHtml()%>
            </div>
<%--            <div class="col-12">--%>
<%--&lt;%&ndash;                <%=graphsNoDaty[0].getHtml()%>&ndash;%&gt;--%>
<%--            </div>--%>
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
