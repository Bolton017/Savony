<%@ page import="user.UserEJB" %>
<%@ page import="affichage.*" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="paie.dashboard.*" %>
<%@ page import="constante.ConstanteDashboard" %>
<%@ page import="paie.accident.StatAccidentType" %>
<%@ page import="paie.accident.StatAccidentBusiness" %>
<%@ page import="paie.accident.RepartitionAccidentGravite" %>
<%@ page import="paie.accident.StatAccidentEvolution" %>
<%@ page import="bean.ResultatEtSomme" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<script src="${pageContext.request.contextPath}/chartPlugins/Chart.min.js"></script>

<%
    try {
        String lien = (String) session.getAttribute("lien");
        UserEJB u = (user.UserEJB) session.getAttribute("u");
        String[] paramVide = {};
        String backgroundColor = ConstanteDashboard.DEFAULT_GRAPH_BACKGROUND_COLOR;

        // --- Palettes de couleurs ---
        String[] palettes = {"#4e73df", "#1cc88a", "#36b9cc", "#f6c23e", "#e74a3b"};
        String[] palettesGravite = {"#28a745", "#8bc34a", "#ffc107", "#fd7e14", "#e74a3b", "#dc3545"};
        String[] palettesType = {"#4e73df", "#6f42c1", "#20c997", "#17a2b8", "#6610f2", "#0d6efd", "#5a4fcf", "#36b9cc", "#4dabf7", "#748ffc", "#9b59b6", "#1abc9c", "#3498db", "#2ecc71", "#34495e"};
        String[] palettesEvolution = {"#e74a3b", "#f6c23e", "#fd7e14", "#dc3545"};
        String[] palettesBusiness = {"#f6c23e", "#fd7e14", "#e74a3b", "#dc3545", "#d63384", "#6f42c1", "#0dcaf0", "#198754", "#0d6efd", "#6610f2", "#ff6f61", "#ffa07a", "#ff8c00", "#cd853f", "#b22222"};

        String[] criterePoint = {};
        String[] critereIntPoint = {};

        // 1. Initialisation de toutes les recherches
        PageRecherche[] pr = new PageRecherche[7];
        pr[0] = new PageRecherche(new AccidentJourArretDashboard(), request, paramVide, paramVide, 4, null, 0);
        pr[0].setAWhere(" order by id asc ");
        pr[1] = new PageRecherche(new AccidentMachineDashboard(), request, paramVide, paramVide, 4, null, 0);
        pr[2] = new PageRecherche(new ActionCorrectiveDashboard(), request, paramVide, paramVide, 4, null, 0);

        pr[3] = new PageRecherche(new RepartitionAccidentGravite(), request, criterePoint, critereIntPoint, 4, paramVide, paramVide.length);
        pr[4] = new PageRecherche(new StatAccidentType(), request, criterePoint, critereIntPoint, 4, paramVide, paramVide.length);
        pr[5] = new PageRecherche(new StatAccidentEvolution(), request, criterePoint, critereIntPoint, 4, paramVide, paramVide.length);
        pr[5].setAWhere(" order by moisInt asc");
        pr[6] = new PageRecherche(new StatAccidentBusiness(), request, criterePoint, critereIntPoint, 4, paramVide, paramVide.length);

        for(PageRecherche p : pr) {
            p.setUtilisateur(u);
            p.setNpp(9999);
        }
        PageRecherche.creerObjetPage(pr);

        // 2. Configuration des graphiques (Tableau étendu à 7)
        DashboardGraphOpt[] g = new DashboardGraphOpt[7];

        // --- G[0] : Cumul Jours d'Arrêt Mensuel (LINE) ---
        g[0] = new DashboardGraphOpt(pr[0].getRs(), new String[]{"moislib"}, new String[]{"Jours d'arrêt"}, DashboardGraphType.LINE);
        g[0].setTitre("Cumul des Jours d'Arrêt par Mois (Année en Cours)");
        g[0].setColAffiche(new String[]{"moislib"});
        g[0].setColValeur(new String[]{"cumuljoursarret"});
        g[0].setColSpan(6);
        g[0].setIcon("date_range");
        g[0].setCouleurs(palettes);
        g[0].setCanvasId("c0");

        // --- G[1] : Accidents par Machine (BAR) ---
        g[1] = new DashboardGraphOpt(pr[1].getRs(), new String[]{"id_machine_lib"}, new String[]{"Nombre d'accidents"}, DashboardGraphType.BAR);
        g[1].setTitre("Machines les plus accidentogènes");
        g[1].setColAffiche(new String[]{"id_machine_lib"});
        g[1].setColValeur(new String[]{"nombreaccidents"});
        g[1].setColSpan(6);
        g[1].setIcon("build");
        g[1].setCouleurs(palettes);
        g[1].setCanvasId("c1");

        // --- G[2] : Actions Correctives (DOUGHNUT) ---
        String[] legende = {"Réalisées", "Non Réalisées"};
        String[] colonnesValeurs = {"actionsrealisees", "actionsnonrealisees"};
        g[2] = new DashboardGraphOpt(pr[2].getRs(), new String[]{"id"}, legende, DashboardGraphType.BAR);
        g[2].setTitre("Avancement des Actions Correctives");
        g[2].setColValeur(colonnesValeurs);
        g[2].setColAffiche(new String[]{"id"});
        g[2].setColSpan(12);
        g[2].setIcon("task_alt");
        g[2].setCouleurs(palettes);
        g[2].setCanvasId("c2");

        // --- G[3] : Répartition par gravité (DOUGHNUT) ---
        g[3] = new DashboardGraphOpt(pr[3].getRs(), new String[]{"id_gravite_lib"}, new String[]{"Nombre des accidents"}, DashboardGraphType.DOUGHNUT);
        g[3].setTitre("Répartition des accidents par gravité");
        g[3].setColValeur(new String[]{"nombreaccidents"});
        g[3].setColSpan(6);
        g[3].setIcon("pie_chart");
        g[3].setLienPage("accident/accident-liste.jsp");
        g[3].setCouleurs(palettesGravite); // Palette spécifique
        g[3].setCanvasId("graphRepartitionAccidentGrvt");

        // --- G[4] : Analyse par type (BAR) ---
        g[4] = new DashboardGraphOpt(pr[4].getRs(), new String[]{"id_type_accident_lib"}, new String[]{"Nombre des accidents"}, DashboardGraphType.BAR);
        g[4].setTitre("Analyse des accidents par type");
        g[4].setColValeur(new String[]{"nombreaccidents"});
        g[4].setColAffiche(new String[]{"id_type_accident_lib"});
        g[4].setColSpan(6);
        g[4].setIcon("bar_chart");
        g[4].setLimite(10);
        g[4].setOrdre("desc");
        g[4].setOrientation("vertical");
        g[4].setCouleurs(palettesType); // Palette spécifique
        g[4].setCanvasId("chartStatAccidentType");

        // --- G[5] : Évolution mensuelle (LINE) ---
        g[5] = new DashboardGraphOpt(pr[5].getRs(), new String[]{"mois"}, new String[]{"Nombre des accidents"}, DashboardGraphType.LINE);
        g[5].setTitre("Évolution mensuelle des accidents");
        g[5].setColValeur(new String[]{"nombreaccidents"});
        g[5].setColAffiche(new String[]{"mois"});
        g[5].setColSpan(6);
        g[5].setIcon("show_chart");
        g[5].setOrdre("moisint asc");
        g[5].setOrientation("vertical");
        g[5].setCouleurs(palettesEvolution); // Palette spécifique
        g[5].setCanvasId("chartStatAccidentEvolution");

        // --- G[6] : Accidents par Business Unit (BAR) ---
        g[6] = new DashboardGraphOpt(pr[6].getRs(), new String[]{"idbulib"}, new String[]{"Nombre des accidents"}, DashboardGraphType.BAR);
        g[6].setTitre("Accidents par Business Unit");
        g[6].setColValeur(new String[]{"nombreaccidents"});
        g[6].setColAffiche(new String[]{"idbulib"});
        g[6].setColSpan(6);
        g[6].setIcon("business");
        g[6].setLimite(10);
        g[6].setOrdre("desc");
        g[6].setOrientation("vertical");
        g[6].setCouleurs(palettesBusiness); // Palette spécifique
        g[6].setCanvasId("chartStatAccidentBusiness");

        // 3. Finalisation (Construction des graphiques)
        for(DashboardGraphOpt graph : g) {
            graph.setBackgroundColor(backgroundColor);
            // La couleur est désormais définie manuellement au dessus pour chaque graphe
            graph.creerGraph();
        }
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Dashboard Sécurité & Accidents</h1>
    </section>

    <section class="content">
        <form action="<%=lien%>?but=paie/dashboard-accident.jsp" method="post" name="formulaire">
           <!--  <%=pr[0].getFormu().getHtmlEnsemble()%>-->
        </form>

        <div class="row" style="margin-top: 20px">
            <%=g[0].getHtml()%>
            <%=g[1].getHtml()%>
        </div>

        <div class="row" style="margin-top: 20px;">
            <%=g[2].getHtml()%>
        </div>

        <div class="row" style="margin-top: 20px;">
            <%=g[3].getHtml()%>
            <%=g[4].getHtml()%>
        </div>

        <div class="row" style="margin-top: 20px;">
            <%=g[5].getHtml()%>
            <%=g[6].getHtml()%>
        </div>
    </section>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const selects = document.querySelectorAll('form[name="formulaire"] select');
        selects.forEach(function(select) {
            select.addEventListener('change', function() {
                document.formulaire.submit();
            });
        });
    });
</script>

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

<%
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<div class='alert alert-danger'>Erreur : " + e.getLocalizedMessage() + "</div>");
    }
%>