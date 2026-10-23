<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Graphe" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="java.util.Map" %>
<%@ page import="analyse.AnalyseParTypeProduit" %>

<% try{
    AnalyseParTypeProduit bdc = new AnalyseParTypeProduit();
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {};
    PageRecherche pr = new PageRecherche(bdc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("data/analyse-type-produit.jsp");


    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String titreGraph = "Nombre d'analyse par type de produit";

%>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= titreGraph %></h1>
    </section>
    <section class="content">
        <div class="row m-0">
            <div class="cardradius">
                <canvas id="graph_depense_cat"></canvas>
                <h5 class="card-title text-center"><%= titreGraph %></h5>
            </div>
        </div>
    </section>

</div>
<%
        String colAbs1 = "idTypeProduitLib";
        String[] colOrd1 = {""};
        String[] colAff1 = {""};

        Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "idTypeProduitLib", "nombreAnalyses")};
        Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_depense_cat", "");
        g1.setTypeGraphe("bar");
        out.println(g1.getHtml("ctx_depense_cat"));
    }catch(Exception e){

        e.printStackTrace();
    }
%>