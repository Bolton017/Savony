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
<%@ page import="fabrication.ProcessLib" %>

<% try {
    ProcessLib bdc = new ProcessLib();
    bdc.setNomTable("PROCESS_OF_FAB");
    String listeCrt[] = {"idMere","daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"idMere" ,"designation", "ecartMinutes"};
    String[] colGrp = {"designation"};
    String[] sommeGrp = {"ecartMinutes"};
    PageRechercheGroupe pr = new PageRechercheGroupe(bdc, request, listeCrt, listeInt, 3, colGrp, sommeGrp, colGrp.length, sommeGrp.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stat/comparaison-duree-of.jsp");

    pr.getFormu().getChamp("idMere").setLibelle("R&eacute;f&eacute;rence Ordre de Fabrication");
//    pr.getFormu().getChamp("idObjet").setPageAppelComplete("fabrication.Of","id","Ofab");
    pr.getFormu().getChamp("daty1").setLibelle("Date de d&eacute;but");
    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date de fin");
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());

    String[] colSomme = null;
    pr.creerObjetPage();
    String lienTableau[] = {};
    String colonneLien[] = {};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID","D&eacute;signation", "Dur&eacute;e en minute"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String titreGraph = "Dur&eacute;e de cycle par OF";
    String description = "Analyse Durée de cycle de fabrication : par OF  : ";

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
        String colAbs1 = "designation";
        String[] colOrd1 = {""};
        String[] colAff1 = {""};

        Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "designation", "ecartMinutes")};
        Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_cout_fab", "");
        g1.setTypeGraphe("line");
        out.println(g1.getHtml("ctx_cout_fab"));

    } catch (Exception e) {

        e.printStackTrace();
    }
%>
