<%@ page import="user.UserEJB" %>
<%@ page import="affichage.*" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="paie.dashboard.*" %>
<%@ page import="constante.ConstanteDashboard" %>
<%@ page import="annexe.Point" %>
<%@ page import="rh.*" %>
<%@ page import="paie.dashboard.MaterniteDepartMensuelDashboard" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<script src="${pageContext.request.contextPath}/chartPlugins/Chart.min.js"></script>

<%
    try {
        String lien = (String) session.getAttribute("lien");
        UserEJB u = (user.UserEJB) session.getAttribute("u");
        String[] paramVide = {};
        String backgroundColor = ConstanteDashboard.DEFAULT_GRAPH_BACKGROUND_COLOR;
        String[] palettes = {"#4e73df", "#1cc88a", "#36b9cc", "#f6c23e", "#e74a3b"};

        // 1. Initialisation des 3 recherches
        PageRecherche[] pr = new PageRecherche[2];
        pr[0] = new PageRecherche(new MaterniteDepartMensuelDashboard(), request, paramVide, paramVide, 4, null, 0);
        pr[1] = new PageRecherche(new MaterniteDureeGlobaleDashboard(), request, paramVide, paramVide, 4, null, 0);
    //    pr[2] = new PageRecherche(new MaterniteDureeMoyenneDashboard(), request, paramVide, paramVide, 4, null, 0);
        String[] listeCrt = {};
        String[] listeInt = {};
        String[] libEntete = {"idPersonnelLib","dateDepartTheorique","dateDepartReel","ecartdepartjours","dateRetourTheorique","dateRetourAjuste", "ecartretourjours"};
        PageRecherche prtab = new PageRecherche(new EcartJourDashboard(), request, listeCrt, listeInt, 4 , libEntete, libEntete.length);
        prtab.setTitre("&Eacute;cart entre th&eacute;orique et r&eacute;el");
        String[] colSomme = null;

        for(PageRecherche p : pr) {
            p.setUtilisateur(u);
            p.setNpp(9999);
        }
        PageRecherche.creerObjetPage(pr);

        prtab.setUtilisateur(u);
        prtab.setLien((String) session.getValue("lien"));
        prtab.creerObjetPage(libEntete, colSomme);
        String[] libEnteteAffiche = {"Personnel","D&eacute;part Th&eacute;orique","D&eacute;part r&eacute;el","&Eacute;cart du d&eacute;part(Jours)","Retour Th&eacute;orique","Retour r&eacute;el","&Eacute;cart du retour(Jours)"};
        prtab.getTableau().setLibelleAffiche(libEnteteAffiche);

        // 2. Configuration des graphiques
        DashboardGraphOpt[] g = new DashboardGraphOpt[2];

        // --- G[1] : KPI Durée Moyenne (CARD) - PLACÉ EN PREMIER ---
        g[1] = new DashboardGraphOpt(pr[1].getRs(), null, new String[]{"Jours de congé"}, DashboardGraphType.CARD);
        g[1].setTitre("Durée Moyenne Globale Th&eacute;orique");
        g[1].setColValeur(new String[]{"dureeMoyenneJours"});
        g[1].setColSpan(4); // Prend un tiers de l'écran en haut
        g[1].setIcon("hourglass_empty");
        g[1].setUnite(" jrs");
        g[1].setCanvasId("c2");

        // --- G[0] : Départs Mensuels (BAR) ---
        g[0] = new DashboardGraphOpt(pr[0].getRs(), new String[]{"mois"}, new String[]{"Nombre de départs"}, DashboardGraphType.BAR);
        g[0].setTitre("Évolution des départs en congé maternité");
        g[0].setColValeur(new String[]{"nombreDepart"});
        g[0].setColAffiche(new String[]{"mois"});
        g[0].setColSpan(12);
        g[0].setIcon("pregnant_woman");
        g[0].setCanvasId("c1");

        // --- G[2] : Évolution Durée Moyenne (LINE) ---
//        g[2] = new DashboardGraphOpt(pr[2].getRs(), new String[]{"mois"}, new String[]{"Durée moyenne"}, DashboardGraphType.LINE);
//        g[2].setTitre("Évolution de la durée moyenne par mois");
//        g[2].setColValeur(new String[]{"dureeMoyenneJours"});
//        g[2].setColAffiche(new String[]{"mois"});
//        g[2].setColSpan(6); // 50% de l'écran
//        g[2].setIcon("timeline");
//        g[2].setUnite(" jrs");
//        g[2].setCanvasId("c3");

        // Finalisation
        for(DashboardGraphOpt graph : g) {
            graph.setBackgroundColor(backgroundColor);
            graph.setCouleurs(palettes);
            graph.creerGraph();
        }
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Dashboard Capital Humain - Maternité</h1>
    </section>

    <section class="content">
        <form action="<%=lien%>?but=dashboard/maternite/maternite-dashboard.jsp" method="post" name="formulaire">
          <!-- <%=pr[0].getFormu().getHtmlEnsemble()%> -->
            <% out.println(prtab.getFormu().getHtmlEnsemble()); %>
        </form>

        <div class="row">
            <h2 class="col-md-12 h520pxSemibold">Vue d'ensemble</h2>
            <%=g[1].getHtml()%>
        </div>

        <div class="row" style="margin-top: 20px;">
            <h2 class="col-md-12 h520pxSemibold">Analyses Évolutives</h2>
            <%=g[0].getHtml()%>
<%--            <%=g[2].getHtml()%>--%>
        </div>
        <div class="row" style="margin-top: 20px;">
            <h2 class="col-md-12 h520pxSemibold">Analyses des Écarts</h2>
            <% out.println(prtab.getTableau().getHtml()); %>
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

        // Auto-submit des filtres
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
        out.println("<div class='alert alert-danger'>Erreur : " + e.getMessage() + "</div>");
    }
%>