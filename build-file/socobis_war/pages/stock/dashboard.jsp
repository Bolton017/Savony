<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.*" %>
<%@ page import="stock.EtatStockParEntree" %>
<%@ page import="constante.ConstanteDashboard" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="dashboard.*" %>
<%@ page import="bean.ResultatEtSomme" %>
<script src="${pageContext.request.contextPath}/chartPlugins/Chart.min.js"></script>
<% try{
    String lien = (String) session.getAttribute("lien");
    UserEJB u = (user.UserEJB) session.getAttribute("u");

    String anneeCourante = Utilitaire.getAnnee(Utilitaire.dateDuJour());

    String backgroundColor = ConstanteDashboard.DEFAULT_GRAPH_BACKGROUND_COLOR;
    String[] palettes = ConstanteDashboard.DEFAULT_COLORS;

    String[] paramDaty = {"daty"};
    String[] paramVide = {};

    String defautDaty1 = Utilitaire.getDebutAnnee(anneeCourante);
    String defautDaty2 = Utilitaire.dateDuJour();

    String daty1 = request.getParameter("daty1");
    String daty2 = request.getParameter("daty2");
    if (daty1 == null || daty1.trim().isEmpty()) {
        daty1 = defautDaty1;
    }
    if (daty2 == null || daty2.trim().isEmpty()) {
        daty2 = defautDaty2;
    }

    DashboardGraphOpt[] graphs = new DashboardGraphOpt[3];

    PageRecherche[] prStock = new PageRecherche[3];

    EtatStockParEntree vst = new EtatStockParEntree();
    prStock[0] = new PageRecherche(vst,request,paramDaty,paramDaty,4,new String[]{},0);
    prStock[0].setUtilisateur(u);
    prStock[0].getFormu().getChamp("daty1").setDefaut(defautDaty1);
    prStock[0].getFormu().getChamp("daty2").setDefaut(defautDaty2);
    prStock[0].getFormu().getChamp("daty1").setValeur(daty1);
    prStock[0].getFormu().getChamp("daty2").setValeur(daty2);
    prStock[0].setNpp(Integer.MAX_VALUE);
    prStock[0].getFormu().getChamp("daty1").setLibelle("date min");
    prStock[0].getFormu().getChamp("daty2").setLibelle("date max");
    EtatStockParEntree vsmp = new EtatStockParEntree();
    prStock[1] = new PageRecherche(vsmp,request,paramDaty,paramDaty,4,new String[]{},0);
    prStock[1].setUtilisateur(u);
    prStock[1].getFormu().getChamp("daty1").setDefaut(defautDaty1);
    prStock[1].getFormu().getChamp("daty2").setDefaut(defautDaty2);
    prStock[1].getFormu().getChamp("daty1").setValeur(daty1);
    prStock[1].getFormu().getChamp("daty2").setValeur(daty2);
    prStock[1].setAWhere(" AND categorieIngredient='CAT004'");
    prStock[1].setNpp(Integer.MAX_VALUE);
    EtatStockParEntree vspf = new EtatStockParEntree();

    prStock[2] = new PageRecherche(vspf,request,paramDaty,paramDaty,4,new String[]{},0);
    prStock[2].setUtilisateur(u);
    prStock[2].getFormu().getChamp("daty1").setDefaut(defautDaty1);
    prStock[2].getFormu().getChamp("daty2").setDefaut(defautDaty2);
    prStock[2].getFormu().getChamp("daty1").setValeur(daty1);
    prStock[2].getFormu().getChamp("daty2").setValeur(daty2);
    prStock[2].setAWhere(" AND categorieIngredient IN ('CAT008','CAT001')");
    prStock[2].setNpp(Integer.MAX_VALUE);
    PageRecherche.creerObjetPage(prStock);

    ResultatEtSomme rsStockTotal = prStock[0].getRs();
    ResultatEtSomme rsStockMP = prStock[1].getRs();
    ResultatEtSomme rsStockPF = prStock[2].getRs();

    graphs[0] = new DashboardGraphOpt(rsStockTotal,null, new String[]{"Valeur stock totale"},DashboardGraphType.CARD);
    graphs[0].setTitre("Valeur en stock total");
    graphs[0].setColValeur(new String[]{"montantreste"});
    graphs[0].setUnite(" Ar");
    graphs[0].setIcon("shopping_cart");
    graphs[0].setColSpan(4);
    graphs[0].setAvecDate(false);
    graphs[0].setLienPage(lien + "?but=stock/etatstock/etatstock-liste.jsp");
    graphs[0].setBackgroundColor(backgroundColor);
    graphs[0].setCouleurs(palettes);
    graphs[0].setCanvasId("caValeurStockTotal");

    graphs[1] = new DashboardGraphOpt(rsStockMP,null, new String[]{"Valeur stock MP"},DashboardGraphType.CARD);
    graphs[1].setTitre("Valeur en stock MP");
    graphs[1].setColValeur(new String[]{"montantreste"});
    graphs[1].setUnite(" Ar");
    graphs[1].setIcon("inventory");
    graphs[1].setColSpan(4);
    graphs[1].setAvecDate(false);
    graphs[1].setLienPage(lien + "?but=stock/etatstock/etatstock-liste.jsp");
    graphs[1].setBackgroundColor(backgroundColor);
    graphs[1].setCouleurs(palettes);
    graphs[1].setCanvasId("caValeurStockMP");

    graphs[2] = new DashboardGraphOpt( rsStockPF,null,new String[]{"Valeur stock PF/SF"},DashboardGraphType.CARD);
    graphs[2].setTitre("Valeur stock PF + Semi-fini");
    graphs[2].setColValeur(new String[]{"montantreste"});
    graphs[2].setUnite(" Ar");
    graphs[2].setIcon("precision_manufacturing");
    graphs[2].setColSpan(4);
    graphs[2].setAvecDate(false);
    graphs[2].setLienPage(lien + "?but=stock/etatstock/etatstock-liste.jsp");
    graphs[2].setBackgroundColor(backgroundColor);
    graphs[2].setCouleurs(palettes);
    graphs[2].setCanvasId("caValeurStockPF");

    for (DashboardGraphOpt graph : graphs) {
        graph.setBackgroundColor(backgroundColor);
        graph.setCouleurs(palettes);
        graph.setColSpan(4);
        graph.creerGraph();
    }

    String[] critere = {"dateInv"};
    String[] critereInt = {"dateInv"};

    PageRecherche[] pr = new PageRecherche[6];

    for (int i = 0; i < 6; i++) {
        pr[i] = new PageRecherche(new V_InventaireFilleCPL(), request, critere, critereInt, 4, paramVide, 0);
        pr[i].setUtilisateur(u);
        pr[i].setNpp(Integer.MAX_VALUE);
        pr[i].getFormu().getChamp("dateInv1").setDefaut(daty1);
        pr[i].getFormu().getChamp("dateInv2").setDefaut(daty2);
        pr[i].getFormu().getChamp("dateInv1").setValeur(daty1);
        pr[i].getFormu().getChamp("dateInv2").setValeur(daty2);
        pr[i].getFormu().getChamp("dateInv1").setLibelle("Date début");
        pr[i].getFormu().getChamp("dateInv2").setLibelle("Date fin");
    }

    pr[1].setAWhere(" AND categorieIngredient = 'CAT004' ");
    pr[2].setAWhere(" AND categorieIngredient IN ('CAT008','CAT001')");
    pr[4].setAWhere(" AND categorieIngredient = 'CAT004'");
    pr[5].setAWhere(" AND categorieIngredient IN ('CAT008','CAT001')");

    PageRecherche.creerObjetPage(pr);

    DashboardGraphOpt[] g = new DashboardGraphOpt[6];
    String[] colDateAffiche = {"dateInv"};

    g[0] = new DashboardGraphOpt(pr[0].getRs(), colDateAffiche, new String[]{"Valeur Totale"}, DashboardGraphType.LINE);
    g[0].setTitre("Évolution de la valeur de stock (Total)");
    g[0].setColValeur(new String[]{"montantReelle"});
    g[0].setCanvasId("chartStockTotal");
    g[0].setUnite(" Ar");

    g[1] = new DashboardGraphOpt(pr[1].getRs(), colDateAffiche, new String[]{"Valeur MP"}, DashboardGraphType.LINE);
    g[1].setTitre("Évolution de la valeur de stock (Mat. Premières)");
    g[1].setColValeur(new String[]{"montantReelle"});
    g[1].setCanvasId("chartStockMP");
    g[1].setUnite(" Ar");

    g[2] = new DashboardGraphOpt(pr[2].getRs(), colDateAffiche, new String[]{"Valeur PF/SF"}, DashboardGraphType.LINE);
    g[2].setTitre("Évolution de la valeur de stock (PF + Semi-finis)");
    g[2].setColValeur(new String[]{"montantReelle"});
    g[2].setCanvasId("chartStockPF");
    g[2].setUnite(" Ar");

    g[3] = new DashboardGraphOpt(pr[3].getRs(), colDateAffiche, new String[]{"Écart Total"}, DashboardGraphType.LINE);
    g[3].setTitre("Évolution de l'écart sur inventaire (Total)");
    g[3].setColValeur(new String[]{"ecart"});
    g[3].setCanvasId("chartEcartTotal");
    g[3].setUnite("");

    g[4] = new DashboardGraphOpt(pr[4].getRs(), colDateAffiche, new String[]{"Écart MP"}, DashboardGraphType.LINE);
    g[4].setTitre("Évolution de l'écart sur inventaire (Mat. Premières)");
    g[4].setColValeur(new String[]{"ecart"});
    g[4].setCanvasId("chartEcartMP");
    g[4].setUnite("");

    g[5] = new DashboardGraphOpt(pr[5].getRs(), colDateAffiche, new String[]{"Écart PF/SF"}, DashboardGraphType.LINE);
    g[5].setTitre("Évolution de l'écart sur inventaire (PF + Semi-finis)");
    g[5].setColValeur(new String[]{"ecart"});
    g[5].setCanvasId("chartEcartPF");
    g[5].setUnite("");

    for (DashboardGraphOpt graph : g) {
        graph.setColAffiche(colDateAffiche);
        graph.setIcon("trending_up");
        graph.setColSpan(6);
        graph.setBackgroundColor(backgroundColor);
        graph.setCouleurs(palettes);
        graph.creerGraph();
    }
%>

<script src="${pageContext.request.contextPath}/chartPlugins/Chart.min.js"></script>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Dashboard Stock</h1>
    </section>
    <section class="content">
        <form action="<%=lien%>?but=stock/dashboard.jsp" method="post" name="formulaire" id="dashboardForm">
            <%=prStock[0].getFormu().getHtmlEnsemble()%>
        </form>

        <div class="row p-3" style="margin-bottom: 20px;">
            <h2 class="col-md-12 h520pxSemibold" style="margin-bottom: 20px;">Indicateurs Clés (KPI Stock)</h2>
            <%=graphs[0].getHtml()%>
            <%=graphs[1].getHtml()%>
            <%=graphs[2].getHtml()%>
        </div>

        <div class="row p-3" style="margin-top: 30px;">
            <h2 class="col-md-12 h520pxSemibold">Analyse des Valeurs de Stock</h2>
            <div class="row">
                <%=g[0].getHtml()%>
                <%=g[1].getHtml()%>
            </div>
            <div class="row" style="margin-top: 20px;">
                <%=g[2].getHtml()%>
            </div>

            <h2 class="col-md-12 h520pxSemibold" style="margin-top: 40px;">Analyse des Écarts d'Inventaire</h2>
            <div class="row">
                <%=g[3].getHtml()%>
                <%=g[4].getHtml()%>
            </div>
            <div class="row" style="margin-top: 20px;">
                <%=g[5].getHtml()%>
            </div>
        </div>
    </section>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const exportBtn = document.querySelector('[data-target="#exporter"]');
        if (exportBtn) {
            const wrapper = exportBtn.closest(".d-flex");
            (wrapper || exportBtn).style.display = "none";
        }

        const motsCles = document.querySelector(".mots-cless");
        if (motsCles) {
            motsCles.style.display = "none";
        }
    });
</script>

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage().replace("'", "\\'")%>');
history.back();
</script>
<% }%>