<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.*" %>
<%@ page import="bean.ResultatEtSomme" %>
<%@ page import="constante.ConstanteDashboard" %>
<%@ page import="paie.accident.AccidentStats" %>
<script src="${pageContext.request.contextPath}/chartPlugins/Chart.min.js"></script>
<%
    try {
        String lien = (String) session.getAttribute("lien");
        UserEJB u = (user.UserEJB) session.getAttribute("u");
        String backgroundColor = ConstanteDashboard.DEFAULT_GRAPH_BACKGROUND_COLOR;

        String[] palettes = {
            "#4e73df", // bleu  -> Jours sans accident
            "#f6c23e"  // jaune -> Record historique
        };

        String[] paramVide = {};
        String[] criterePoint = {};
        String[] critereIntPoint = {};

        PageRecherche[] pr = new PageRecherche[1];
        pr[0] = new PageRecherche(new AccidentStats(), request, criterePoint, critereIntPoint, 4, paramVide, paramVide.length);
        pr[0].setUtilisateur(u);
        pr[0].setNpp(9999);
        pr[0].setAWhere(" ORDER BY datecomptage ASC ");

        PageRecherche.creerObjetPage(pr);
        ResultatEtSomme statAccidentStats = pr[0].getRs();

        // --- Line Chart : Évolution jours sans accident + record historique ---
        DashboardGraphOpt dgEvolutionJours = new DashboardGraphOpt(
            statAccidentStats,
            new String[]{"datecomptage"},
            new String[]{"Jours sans accident", "Record historique"},
            DashboardGraphType.LINE
        );
        dgEvolutionJours.setTitre("Évolution mensuelle des jours sans accident et record historique");
        dgEvolutionJours.setColValeur(new String[]{"joursansaccident", "recordjoursansaccident"});
        dgEvolutionJours.setColAffiche(new String[]{"datecomptage"});
        dgEvolutionJours.setColSpan(12);
        dgEvolutionJours.setIcon("trending_up");
        dgEvolutionJours.setOrdre("datecomptage asc");
        dgEvolutionJours.setOrientation("vertical");
        dgEvolutionJours.setBackgroundColor(backgroundColor);
        dgEvolutionJours.setCouleurs(palettes);
        dgEvolutionJours.setCanvasId("graphEvolutionJours");
        dgEvolutionJours.creerGraph();
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Suivi des jours sans accident</h1>
    </section>
    <section class="content">
        <form action="<%=lien%>?but=paie/accident/graphe-jour-accident.jsp" method="post" name="formulaire">
            <%=pr[0].getFormu().getHtmlEnsemble()%>
        </form>

        <div class="row" style="margin-top: 20px;">
            <%=dgEvolutionJours.getHtml()%>
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
        const selects = document.querySelectorAll('form[name="formulaire"] select');
        selects.forEach(function(select) {
            select.addEventListener('change', function() {
                document.formulaire.submit();
            });
        });
    });
</script>

<% } catch (Exception e) { e.printStackTrace(); out.println("<div class='alert alert-danger'>Erreur : " + e.getMessage() + "</div>"); } %>