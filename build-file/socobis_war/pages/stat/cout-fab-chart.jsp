<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Graphe" %>
<%@ page import="affichage.*" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="java.util.Map" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="stat.CoutFabParOf" %>
<%@ page import="utils.ConstanteAsync" %>

<% try{
    CoutFabParOf bdc = new CoutFabParOf();
    bdc.setNomTable("cout_fab_par_of");
    String listeCrt[] = {"ingredients","datybesoin"};
    String listeInt[] = {"datybesoin"};
    String libEntete[] = {"idmere","coutdeproduction"};
    String[] colGrp = {"idmere"};
    String[] sommeGrp = {"coutdeproduction"};
    PageRechercheGroupe pr = new PageRechercheGroupe(bdc, request, listeCrt, listeInt, 3,  colGrp, sommeGrp, colGrp.length, sommeGrp.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stat/cout-fab-chart.jsp");

    pr.getFormu().getChamp("ingredients").setLibelle("Produit");
    pr.getFormu().getChamp("datybesoin1").setLibelle("Date de d&eacute;but");
    pr.getFormu().getChamp("datybesoin1").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("datybesoin2").setLibelle("Date de fin");
    pr.getFormu().getChamp("datybesoin2").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("ingredients").setPageAppelComplete("produits.Ingredients","id","AS_INGREDIENTS_PRODUIT_FINIE");
    String[] colSomme = null;
    pr.creerObjetPage();
    String lienTableau[] = {};
    String colonneLien[] = {};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"R&eacute;f&eacute;rence","Co&ucirc;t de production"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    String titreGraph = "&Eacute;volution du co&ucirc;t de production par Ordre de Fabrication";
    String description = "Statistiques coût : mpe, emballage , mod , par période et par produit (graphe hausse et baisse)";

%>
<script>
    function changerDesignation() {
        document.getElementById("bdc-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= titreGraph %></h1>
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
        <div class="row col-md-12 mb-5 nopadding">
            <%
                out.println(pr.getTableau().getHtml());
                out.println(pr.getBasPage());
            %>
        </div>
        <br>
        <div class="row mt-4" style="margin-top: 20px;">
            <div class="col-md-12 mb-4" style="width: 60%">
                <div class="card h-100" style="
                        border-radius: 10px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                        border: 1px solid #e0e0e0;
                        background-color: white;
                        padding: 1em">
                    <div class="card-body">
                        <h5 class="card-title text-center"><%= titreGraph %></h5>
                        <canvas id="graph_cout_fab"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </section>

</div>
<%
        String colAbs1 = "idmere";
        String[] colOrd1 = {""};
        String[] colAff1 = {""};

        Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "idmere", "coutdeproduction")};
        Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_cout_fab", "");
        g1.setTypeGraphe("line");
        out.println(g1.getHtml("ctx_cout_fab"));
    }catch(Exception e){

        e.printStackTrace();
    }
%>