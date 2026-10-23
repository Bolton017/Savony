
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@page import="affichage.PageRecherche" %>
<%@ page import="affichage.Graphe" %>
<%@ page import="affichage.*" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="java.util.Map" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="stock.MvtStockFilleTheorique" %>
<%@ page import="utils.ConstanteAsync" %>
<%@ page import="java.util.Calendar" %>

<% try {
    MvtStockFilleTheorique bdc = new MvtStockFilleTheorique();
    bdc.setNomTable("MVTSTOCKFILLESORTIEFAB");
    String listeCrt[] = {"daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"categorieingredient", "montant"};
    String[] colGrp = {"categorieingredient"};
    String[] sommeGrp = {"montant"};
    PageRechercheGroupe pr = new PageRechercheGroupe(bdc, request, listeCrt, listeInt, 3, colGrp, sommeGrp, colGrp.length, sommeGrp.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stat/stat-repartition-cout-production.jsp");
    Calendar calendar = Calendar.getInstance();
    int month = calendar.get(Calendar.MONTH) + 1; // January is 0
    int year = calendar.get(Calendar.YEAR);

    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty1").setDefaut(String.format("01/%02d/%04d", month, year));
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
//    pr.getFormu().getChamp("idObjet").setPageAppelComplete("fabrication.Of","id","Ofab");
    String[] colSomme = null;
    pr.creerObjetPage();
    String lienTableau[] = {};
    String colonneLien[] = {};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Cat&eacute;gorie", "Co&ucirc;t de production"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String titreGraph = "R&eacute;partition du co&ucirc;t de production";
    String description = "Graphe";

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

        Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "categorieingredient", "montant")};
        Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_cout_fab", "");
        g1.setTypeGraphe("pie");
        out.println(g1.getHtml("ctx_cout_fab"));

    } catch (Exception e) {

        e.printStackTrace();
    }
%>
