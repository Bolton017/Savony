<%@ page import="affichage.*" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="vente.*" %>
<%@ page import="constante.ConstanteDashboard" %>
<%@ page import="bean.ResultatEtSomme" %>
<%@ page import="faturefournisseur.FactureFournisseurCpl" %>
<%@ page import="user.UserEJB" %>
<%@ page import="faturefournisseur.FournisseurCpl" %>
<%@ page import="faturefournisseur.As_BonDeCommandeCpl" %>
<%@ page import="java.sql.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script src="${pageContext.request.contextPath}/chartPlugins/Chart.min.js"></script>

<% try {
    String lien = (String) session.getAttribute("lien");
    String dateDuJour = Utilitaire.dateDuJour();
    int moisActuel = Utilitaire.getMoisEnCours();
    int annee = Utilitaire.getAneeEnCours();
    Date lastMouth = Utilitaire.getDebutDuMoisByMoisAnnee(moisActuel, annee);
    UserEJB u = (user.UserEJB) session.getAttribute("u");
    String backgroundColor = ConstanteDashboard.DEFAULT_GRAPH_BACKGROUND_COLOR;
    String[] palettes = ConstanteDashboard.DEFAULT_COLORS;
    String[] paramVide = {};

    // ================================================================
    // MAPPING
    FactureFournisseurCpl factures = new FactureFournisseurCpl();
    FournisseurCpl fournisseurs = new FournisseurCpl();
    As_BonDeCommandeCpl commandes = new As_BonDeCommandeCpl();
    String[] critere = {"daty"};
    String[] critereInt = {"daty"};



    // ================================================================
    // INSTANCIATION PAGE RECHERCHE
    PageRecherche[] pr = new PageRecherche[3];
    pr[0] = new PageRecherche(factures, request, critere, critereInt, 4, paramVide, paramVide.length);
    pr[0].setUtilisateur(u);
    pr[0].setNpp(Integer.MAX_VALUE);
    pr[0].getFormu().getChamp("daty1").setDefaut(Utilitaire.datetostring(lastMouth));
    pr[0].getFormu().getChamp("daty2").setDefaut(dateDuJour);
    pr[0].getFormu().getChamp("daty1").setLibelle("Date Min");
    pr[0].getFormu().getChamp("daty2").setLibelle("Date Max");
    pr[0].setAWhere(" AND etat = 11");

    pr[1] = new PageRecherche(fournisseurs, request, paramVide, paramVide, 4, paramVide, paramVide.length);
    pr[1].setUtilisateur(u);
    pr[1].setNpp(Integer.MAX_VALUE);

    pr[2] = new PageRecherche(commandes, request, critere, critereInt, 4, paramVide, paramVide.length);
    pr[2].setUtilisateur(u);
    pr[2].setNpp(Integer.MAX_VALUE);
    pr[2].getFormu().getChamp("daty1").setDefaut(Utilitaire.datetostring(lastMouth));
    pr[2].getFormu().getChamp("daty2").setDefaut(dateDuJour);
    pr[2].getFormu().getChamp("daty1").setLibelle("Date Min");
    pr[2].getFormu().getChamp("daty2").setLibelle("Date Max");
    pr[2].setAWhere(" AND etat = 11");

    // PREPARER DATA
    PageRecherche.creerObjetPage(pr);
    ResultatEtSomme rsAchats = pr[0].getRs();
    ResultatEtSomme rsFournisseurs = pr[1].getRs();
    ResultatEtSomme rsCommandes = pr[2].getRs();
    // ================================================================
    // --------- GRAPHIQUES ---------
    DashboardGraphOpt pgAchatTotal = new DashboardGraphOpt(rsAchats, null, paramVide, DashboardGraphType.KPI);
    pgAchatTotal.setTitre("Montant total des achats");
    pgAchatTotal.setUnite(" Ar");
    pgAchatTotal.setLienPage("facturefournisseur/facturefournisseur-liste.jsp");
    pgAchatTotal.setCanvasId("pgAchatTotal");
    pgAchatTotal.setColValeur(new String[]{"montantttc"});
    pgAchatTotal.creerGraph();

    DashboardGraphOpt pgFournisseur = new DashboardGraphOpt(rsFournisseurs, null, paramVide, DashboardGraphType.KPI);
    pgFournisseur.setTitre("Fournisseur actifs");
    pgFournisseur.setUnite("");
    pgFournisseur.setLienPage("fournisseur/fournisseur-liste.jsp");
    pgFournisseur.setCanvasId("pgFournisseur");
    pgFournisseur.setColValeur(new String[]{"nb"});
    pgFournisseur.creerGraph();

    DashboardGraphOpt pgCommandes = new DashboardGraphOpt(rsCommandes, null, paramVide, DashboardGraphType.KPI);
    pgCommandes.setTitre("Commandes Fournisseurs");
    pgCommandes.setUnite("");
    pgCommandes.setLienPage("bondecommande/bondecommande-liste.jsp");
    pgCommandes.setCanvasId("pgCommandes");
    pgCommandes.setColValeur(new String[]{"nb"});
    pgCommandes.creerGraph();

    String[] colMontantTTC = {"montantttc"};
    String[] legende = {"Total Montant"};
    String[] colDaty = {"daty"};
    DashboardGraphOpt dgAchatDate = new DashboardGraphOpt(rsAchats,colDaty,legende,DashboardGraphType.LINE);
    dgAchatDate.setTitre("Évolution des achats");
    dgAchatDate.setColValeur(colMontantTTC);
    dgAchatDate.setColAffiche(colDaty);
    dgAchatDate.setIcon("trending_up");
    dgAchatDate.setUnite(" Ar");
    dgAchatDate.setColSpan(4);
    dgAchatDate.setLienPage("facturefournisseur/facturefournisseur-liste.jsp");
    dgAchatDate.setBackgroundColor(backgroundColor);
    dgAchatDate.setCouleurs(palettes);
    dgAchatDate.setCanvasId("dgAchatDate");
    dgAchatDate.creerGraph();

    String[] colIdFournisseurLib = {"idFournisseurLib"};
    DashboardGraphOpt dgAchatFournisseur = new DashboardGraphOpt(rsAchats,colIdFournisseurLib,paramVide,DashboardGraphType.DOUGHNUT);
    dgAchatFournisseur.setTitre("Achats par fournisseur");
    dgAchatFournisseur.setColValeur(colMontantTTC);
    dgAchatFournisseur.setColAffiche(colIdFournisseurLib);
    dgAchatFournisseur.setIcon("group");
    dgAchatFournisseur.setUnite(" Ar");
    dgAchatFournisseur.setColSpan(4);
    dgAchatFournisseur.setLienPage("facturefournisseur/facturefournisseur-liste.jsp");
    dgAchatFournisseur.setBackgroundColor(backgroundColor);
    dgAchatFournisseur.setCouleurs(palettes);
    dgAchatFournisseur.setCanvasId("dgAchatFournisseur");
    dgAchatFournisseur.creerGraph();

    String[] legendeTypeAchatLib = {"typeAchatLib"};
    DashboardGraphOpt dgAchatCategorie = new DashboardGraphOpt(rsAchats,legendeTypeAchatLib,paramVide,DashboardGraphType.DOUGHNUT);
    dgAchatCategorie.setTitre("Répartition des achats par catégorie");
    dgAchatCategorie.setColValeur(colMontantTTC);
    dgAchatCategorie.setColAffiche(legendeTypeAchatLib);
    dgAchatCategorie.setIcon("category");
    dgAchatCategorie.setUnite(" Ar");
    dgAchatCategorie.setColSpan(4);
    dgAchatCategorie.setLienPage("facturefournisseur/facturefournisseur-liste.jsp");
    dgAchatCategorie.setBackgroundColor(backgroundColor);
    dgAchatCategorie.setCouleurs(palettes);
    dgAchatCategorie.setCanvasId("dgAchatCategorie");
    dgAchatCategorie.creerGraph();

    String[] legendeFournisseurPerf = {"Nombres de commandes"};
    String[] colFournisseurLib = {"fournisseurlib"};
    DashboardGraphOpt dgFournisseurPerf = new DashboardGraphOpt(rsCommandes,colFournisseurLib,legendeFournisseurPerf,DashboardGraphType.BAR);
    dgFournisseurPerf.setTitre("Top 10 des fournisseurs les plus utilisés");
    dgFournisseurPerf.setColValeur(new String[]{"nb"});
    dgFournisseurPerf.setColAffiche(colFournisseurLib);
    dgFournisseurPerf.setIcon("bar_chart");
    dgFournisseurPerf.setUnite("");
    dgFournisseurPerf.setColSpan(12);
    dgFournisseurPerf.setLimite(10);
    dgFournisseurPerf.setOrdre("desc");
    dgFournisseurPerf.setOrientation("horizontal");
    dgFournisseurPerf.setLienPage("fournisseur/fournisseur-liste.jsp");
    dgFournisseurPerf.setBackgroundColor(backgroundColor);
    dgFournisseurPerf.setCouleurs(palettes);
    dgFournisseurPerf.setCanvasId("dgFournisseurPerf");
    dgFournisseurPerf.creerGraph();
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Tableau de bord par point de vente</h1>
    </section>
    <section class="content">
        <form action="<%=lien%>?but=<%=pr[0].getApres()%>" method="post">
            <%=pr[0].getFormu().getHtmlEnsemble()%>
        </form>
        <div class="row p-3">
            <h2 class="col-md-12 h520pxSemibold">KPIs</h2>
            <div class="col-md-4">
                <%=pgAchatTotal.getHtml()%>
            </div>
            <div class="col-md-4">
                <%=pgCommandes.getHtml()%>
            </div>
            <div class="col-md-4">
                <%=pgFournisseur.getHtml()%>
            </div>
            <div class="col-md-12">
                <h2 class="col-md-12 h520pxSemibold">Achats</h2>
                <%=dgAchatFournisseur.getHtml()%>
                <%=dgAchatDate.getHtml()%>
                <%=dgAchatCategorie.getHtml()%>
            </div>
            <div class="col-md-12">
                <h2 class="col-md-12 h520pxSemibold">Performance</h2>
<%--                <%=dgLivraison.getHtml()%>--%>
                <%=dgFournisseurPerf.getHtml()%>
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
    e.printStackTrace(); %>
    <script language="JavaScript"> alert('<%=e.getMessage()%>');
        history.back();
    </script>
<% }%>