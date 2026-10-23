<%@ page import="user.UserEJB" %>
<%@ page import="affichage.*" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="paie.dashboard.*" %>
<%@ page import="constante.ConstanteDashboard" %>
<%@ page import="annexe.Point" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script src="${pageContext.request.contextPath}/chartPlugins/Chart.min.js"></script>

<%
    try {
        String lien = (String) session.getAttribute("lien");
        UserEJB u = (user.UserEJB) session.getAttribute("u");
        String[] paramVide = {};
        String backgroundColor = ConstanteDashboard.DEFAULT_GRAPH_BACKGROUND_COLOR;
        String[] palettes = {"#4e73df", "#1cc88a", "#36b9cc", "#f6c23e", "#e74a3b"};

        PageRecherche[] pr = new PageRecherche[10];
        pr[0] = new PageRecherche(new ReppartionEffectifContrat(), request, paramVide, paramVide, 4, null, 0);
        pr[1] = new PageRecherche(new ReppartionEffectifContrat(), request, paramVide, paramVide, 4, null, 0);
        pr[2] = new PageRecherche(new EffectifsCDIHFCategorie(), request, paramVide, paramVide, 4, null, 0);
        pr[3] = new PageRecherche(new DashPyramidAgeCDI(), request, paramVide, paramVide, 4, null, 0);
        pr[4] = new PageRecherche(new DashPyramideAgeJRN(), request, paramVide, paramVide, 4, null, 0);
        pr[5] = new PageRecherche(new DashPyramideAnciennetteCDI(), request, paramVide, paramVide, 4, null, 0);
        pr[6] = new PageRecherche(new DashSalaireCategorieCDI(), request, paramVide, paramVide, 4, null, 0);
        pr[7] = new PageRecherche(new DashSalaireAncCDI(), request, paramVide, paramVide, 4, null, 0);
        pr[8] = new PageRecherche(new DashHSUPMoisCDI(), request, paramVide, paramVide, 4, null, 0);
        pr[9] = new PageRecherche(new ReppartionEffectifContrat(), request, paramVide, paramVide, 4, null, 0);

        for(PageRecherche p : pr) { p.setUtilisateur(u); p.setNpp(9999); }
        PageRecherche.creerObjetPage(pr);

        DashboardGraphOpt[] g = new DashboardGraphOpt[10];

        // 0. Effectif Total (CARD)
        g[0] = new DashboardGraphOpt(pr[0].getRs(), null, new String[]{"Collaborateurs"}, DashboardGraphType.CARD);
        g[0].setTitre("Effectif Total");
        g[0].setColValeur(new String[]{"nb_employes"});
        g[0].setColSpan(4);
        g[0].setIcon("groups");
        g[0].setCanvasId("c0");

        // 1. Contrat (DOUGHNUT)
        g[1] = new DashboardGraphOpt(pr[1].getRs(), new String[]{"type_contrat"}, new String[]{"Nombre"}, DashboardGraphType.DOUGHNUT);
        g[1].setTitre("Répartition par Contrat");
        g[1].setColValeur(new String[]{"nb_employes"});
        g[1].setColAffiche(new String[]{"type_contrat"});
        g[1].setColSpan(5);
        g[1].setIcon("assignment");
        g[1].setCanvasId("c1");

        // 2. Catégories par Genre (BAR)
        g[2] = new DashboardGraphOpt(pr[2].getRs(), new String[]{"categorie"}, new String[]{"Hommes", "Femmes"}, DashboardGraphType.BAR);
        g[2].setTitre("CDI : Catégories par Genre");
        g[2].setColValeur(new String[]{"nb_hommes", "nb_femmes"});
        g[2].setColAffiche(new String[]{"categorie"});
        g[2].setColSpan(7);
        g[2].setIcon("business_center");
        g[2].setCanvasId("c2");

        // 3. Âge CDI (BAR)
        g[3] = new DashboardGraphOpt(pr[3].getRs(), new String[]{"tranche_age"}, new String[]{"Hommes", "Femmes"}, DashboardGraphType.BAR);
        g[3].setTitre("Âges (CDI)");
        g[3].setColValeur(new String[]{"nb_hommes", "nb_femmes"});
        g[3].setColAffiche(new String[]{"tranche_age"});
        g[3].setColSpan(4);
        g[3].setIcon("cake");
        g[3].setCanvasId("c3");

        // 4. Âge JRN (BAR)
        g[4] = new DashboardGraphOpt(pr[4].getRs(), new String[]{"tranche_age"}, new String[]{"Hommes", "Femmes"}, DashboardGraphType.BAR);
        g[4].setTitre("Âges (Journaliers)");
        g[4].setColValeur(new String[]{"nb_hommes", "nb_femmes"});
        g[4].setColAffiche(new String[]{"tranche_age"});
        g[4].setColSpan(4);
        g[4].setIcon("event_note");
        g[4].setCanvasId("c4");

        // 5. Ancienneté CDI (BAR)
        g[5] = new DashboardGraphOpt(pr[5].getRs(), new String[]{"tranche_anciennete"}, new String[]{"Hommes", "Femmes"}, DashboardGraphType.BAR);
        g[5].setTitre("Ancienneté (CDI)");
        g[5].setColValeur(new String[]{"nb_hommes", "nb_femmes"});
        g[5].setColAffiche(new String[]{"tranche_anciennete"});
        g[5].setColSpan(4);
        g[5].setIcon("history");
        g[5].setCanvasId("c5");

        // 6. Salaire Categorie (BAR)
        g[6] = new DashboardGraphOpt(pr[6].getRs(), new String[]{"categorie"}, new String[]{"Salaire Moyen Femme","Salaire Moyen Total", "Salaire Moyen Homme"}, DashboardGraphType.BAR);
        g[6].setTitre("Salaire / Catégorie");
        g[6].setColValeur(new String[]{"salaire_moyen_femme","salaire_moyen_total","salaire_moyen_homme"});
        g[6].setColAffiche(new String[]{"categorie"});
        g[6].setUnite(" Ar");
        g[6].setColSpan(6);
        g[6].setIcon("payments");
        g[6].setCanvasId("c6");

        // 7. Salaire Ancienneté (LINE)
        g[7] = new DashboardGraphOpt(pr[7].getRs(), new String[]{"tranche_anciennete"}, new String[]{"Salaire Moyen Femme","Salaire Moyen Total", "Salaire Moyen Homme"}, DashboardGraphType.LINE);
        g[7].setTitre("Évolution Salaire / Ancienneté");
        g[7].setColValeur(new String[]{"salaire_moyen_femme","salaire_moyen_total", "salaire_moyen_homme"});
        g[7].setColAffiche(new String[]{"tranche_anciennete"});
        g[7].setUnite(" Ar");
        g[7].setColSpan(6);
        g[7].setIcon("trending_up");
        g[7].setCanvasId("c7");

        // 8. H.Sup (LINE)
        g[8] = new DashboardGraphOpt(pr[8].getRs(), new String[]{"mois"}, new String[]{"Montant Heure Sup Femme","Montant Heure Sup Total", "Montant Heure Sup Homme"}, DashboardGraphType.LINE);
        g[8].setTitre("Montant Heure Sup par Mois");
        g[8].setColValeur(new String[]{"montant_hsup_femme","montant_hsup_total", "montant_hsup_homme"});
        g[8].setColAffiche(new String[]{"mois"});
        g[8].setColSpan(12);
        g[8].setIcon("more_time");
        g[8].setCanvasId("c8");

        g[9] = new DashboardGraphOpt(pr[9].getRs(), new String[]{"type_contrat"}, new String[]{"Nombre"}, DashboardGraphType.CARD);
        g[9].setTitre("Répartition par Contrat");
        g[9].setColValeur(new String[]{"nb_employes"});
        g[9].setColAffiche(new String[]{"type_contrat"});
        g[9].setColSpan(4);
        g[9].setIcon("assignment");
        g[9].setCanvasId("c9");


        // Finalisation
        for(DashboardGraphOpt graph : g) {
            graph.setBackgroundColor(backgroundColor);
            graph.setCouleurs(palettes);
            graph.creerGraph();
        }
%>
<style>
    .dashboard-card-row.Body14pxSemiBold {
        padding-left: 0;
    }

    .dashboard-card-footer {
        display: none;
    }

</style>
<div class="content-wrapper">
    <section class="content-header"><h1>Dashboard Capital Humain</h1></section>
    <section class="content">
        <form action="<%=lien%>?but=paie/dashboard-rh.jsp" method="post">
           <!-- <%=pr[0].getFormu().getHtmlEnsemble()%> -->
        </form>

        <div class="row" style="margin-top: 20px">
        <%=g[0].getHtml()%>
        <%=g[9].getHtml()%>
        </div>
        <div class="row">
            <h2 class="col-md-12 h520pxSemibold"></h2>
            <%=g[1].getHtml()%>
            <%=g[2].getHtml()%>
        </div>
        <div class="row">
            <h2 class="col-md-12 h520pxSemibold">Démographie</h2>
            <%=g[3].getHtml()%> <%=g[4].getHtml()%> <%=g[5].getHtml()%>
        </div>
        <div class="row">
            <h2 class="col-md-12 h520pxSemibold">Analyses des Rémunérations</h2>
            <%=g[6].getHtml()%> <%=g[7].getHtml()%> <%=g[8].getHtml()%>
        </div>
    </section>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const exportBtn = document.querySelector('[data-target="#exporter"]'); // Cacher le bouton Exporter
        if (exportBtn) {
            const wrapper = exportBtn.closest(".d-flex");
            (wrapper || exportBtn).style.display = "none";
        }
        const motsCles = document.querySelector(".mots-cless"); // Cacher le bloc mots-clés
        if (motsCles) {
            motsCles.style.display = "none";
        }
    });
</script>

<% } catch (Exception e) { e.printStackTrace(); out.println("Erreur : " + e.getMessage()); } %>