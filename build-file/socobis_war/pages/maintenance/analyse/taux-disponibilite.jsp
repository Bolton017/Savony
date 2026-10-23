<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 18/12/2025
  Time: 15:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="maintenance.etats.CoutMaintenance" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="utils.ConstanteAsync" %>
<%@ page import="java.util.Map" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="affichage.Graphe" %>
<% try {
    CoutMaintenance bdc = new CoutMaintenance();
    String listeCrt[] = {"nomMachine"};
    String listeInt[] = {};
    String libEntete[] = {"idMachine" ,"nomMachine", "idLigneLib", "tauxDisponibilite"};

    PageRecherche pr = new PageRecherche(bdc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("maintenance/analyse/taux-disponibilite.jsp");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {};
    String colonneLien[] = {};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID","Machine", "Ligne", "Taux de disponibilit&eacute;"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String titreGraph = "Taux de Disponibilit&eacute; par Machine";
    String description = "Analyse de Taux de Disponibilit&eacute; par Machine : ";

%>
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
                <canvas id="graph_moyenne_panne"></canvas>
                <h5 class="card-title text-center">
                    <%= titreGraph %>
                </h5>
            </div>
        </div>
    </section>

</div>
<%
        String colAbs1 = "nomMachine";
        String[] colOrd1 = {""};
        String[] colAff1 = {""};

        Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "nomMachine", "tauxDisponibilite")};
        Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_moyenne_panne", "");
        g1.setTypeGraphe("bar");
        out.println(g1.getHtml("ctx_moyenne_panne"));

    } catch (Exception e) {

        e.printStackTrace();
    }
%>
