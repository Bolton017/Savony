<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 22/08/2025
  Time: 17:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="affichage.Graphe" %>
<%@ page import="java.util.Map" %>
<%@ page import="utils.ConstanteAsync" %>
<%@ page import="stock.MvtStockFille" %>

<%
    String debut = request.getParameter("dateDebut");
    String fin = request.getParameter("dateFin");
%>

<div class="content-wrapper" style="padding: 20px;">

    <div class="card shadow rounded" style="margin-bottom: 20px">
        <div class="card-body">
            <h5 class="card-title text-center mb-4">Filtrer par période</h5>
            <form method="get" action="<%= session.getAttribute("lien") %>" style="margin-bottom: 20px">
                <input type="hidden" name="but" value="chart/analyse.jsp">
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label for="dateDebut" class="form-label">Date de début</label>
                        <input type="date" id="dateDebut" name="dateDebut" class="form-control" >
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="dateFin" class="form-label">Date de fin</label>
                        <input type="date" id="dateFin" name="dateFin" class="form-control" >
                    </div>
                    <div class="col-md-4 mb-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100" style="position: relative; top: 20px;">Appliquer le filtre</button>
                    </div>
                </div>
            </form>
            <%
                if ((debut != null && !debut.isEmpty()) || (fin != null && !fin.isEmpty())) {
            %>
            <div class="alert alert-secondary mb-4" style="background-color: #c7c8c9;">
                Résultats filtrés
                <%
                    if (debut != null && !debut.isEmpty() && fin != null && !fin.isEmpty()) {
                %>
                entre le <strong><%= debut %></strong> et le <strong><%= fin %></strong>.
                <%
                } else if (debut != null && !debut.isEmpty()) {
                %>
                à partir du <strong><%= debut %></strong>.
                <%
                } else if (fin != null && !fin.isEmpty()) {
                %>
                jusqu au <strong><%= fin %></strong>.
                <%
                    }
                %>
            </div>
            <%
                }
            %>
        </div>
    </div>

    <div class="row mt-4">
        <div class="col-md-6 mb-4">
            <div class="card shadow rounded h-100">
                <div class="card-body">
                    <h5 class="card-title text-center">BAR</h5>
                    <canvas id="graph_bar"></canvas>
                </div>
            </div>
        </div>
    </div>

    <div class="row mt-4" style="margin-top: 20px;">
        <div class="col-md-4 mb-4">
            <div class="card shadow rounded h-100">
                <div class="card-body">
                    <h5 class="card-title text-center">CHEESE</h5>
                    <canvas id="graph_cheese"></canvas>
                </div>
            </div>
        </div>
    </div>

</div>



<%
    String colAbs1 = "nomphase";
    String[] colOrd1 = {""};
    String[] colAff1 = {""};

    String colAbs2 = "nomUtilisateur";
    String[] colOrd2 = {""};
    String[] colAff2 = {""};

    try {
        Map<String, Double>[] data1 = new Map[] {MvtStockFille.getDataChartCheese()};
        Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_cheese", "");
        g1.setTypeGraphe("doughnut");
        out.println(g1.getHtml("ctx1"));


        Map<String, Double>[] data2 = new Map[] {MvtStockFille.getDataChartBar()};
        Graphe g2 = new Graphe(data2, colAbs2, colOrd2, colAff2, "graph_bar", "");
        g2.setTypeGraphe("bar");
        out.println(g2.getHtml("ctx2", true));
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<style>
    .card {
        transition: transform 0.2s ease-in-out;
        padding: 20px;
        background: #fcfcfc;
        border-radius: 20px;
    }

    canvas {
        max-height: 300px;
    }
</style>

