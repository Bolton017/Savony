<%--
  Created by IntelliJ IDEA.
  User: Maroussia
  Date: 11/12/2025
  Time: 17:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@page import="affichage.PageRecherche" %>
<%@ page import="affichage.Graphe" %>
<%@ page import="affichage.*" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="java.util.Map" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="stat.CoutFabParOf" %>
<%@ page import="stock.MvtStockFilleTheorique" %>
<%@ page import="utils.ConstanteAsync" %>

<% try {
    MvtStockFilleTheorique bdc = new MvtStockFilleTheorique();
    bdc.setNomTable("STOCKETDEPENSEOFFABTHECAT");
    String listeCrt[] = {"idObjet"};
    String listeInt[] = {};
    String libEntete[] = {"idObjet", "categorieingredient", "montantSortie"};
    String[] colGrp = {"idObjet", "categorieingredient"};
    String[] sommeGrp = {"montantSortie"};
    PageRechercheGroupe pr = new PageRechercheGroupe(bdc, request, listeCrt, listeInt, 3, colGrp, sommeGrp, colGrp.length, sommeGrp.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stat/repartition-cout-production.jsp");

    pr.getFormu().getChamp("idObjet").setLibelle("R&eacute;f&eacute;rence Ordre de Fabrication");
//    pr.getFormu().getChamp("idObjet").setPageAppelComplete("fabrication.Of","id","Ofab");
    String[] colSomme = null;
    pr.creerObjetPage();
    String lienTableau[] = {};
    String colonneLien[] = {};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"R&eacute;f&eacute;rence", "Cat&eacute;gorie", "Co&ucirc;t de production"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String titreGraph = "Co&ucirc;t de production d'Ordre de Fabrication par cat&eacute;gorie ";
    String description = "Graphe %: par rapport coût OF: MOD, MPE, emballage,consommable : ";

%>
<script>
    function changerDesignation() {
        document.getElementById("bdc-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= titreGraph %>
        </h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bdc-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <br>
        <%
            out.println(pr.getHtmlWithEvaluation(ConstanteAsync.API_URL, ConstanteAsync.API_KEY, titreGraph, description));%>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
        <br>
        <div class="row m-0">
            <div class="cardradius">
                <canvas id="graph_cout_fab"></canvas>
                <h5 class="card-title text-center">
                    <%= titreGraph %>
                </h5>
            </div>
        </div>
    </section>

</div>
<%
        String colAbs1 = "categorieingredient";
        String[] colOrd1 = {""};
        String[] colAff1 = {""};

        Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "categorieingredient", "montantSortie")};
        Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_cout_fab", "");
        g1.setTypeGraphe("doughnut");
        out.println(g1.getHtml("ctx_cout_fab"));

    } catch (Exception e) {

        e.printStackTrace();
    }
%>
