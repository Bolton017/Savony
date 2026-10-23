<%@ page import="caisse.EcartCloture" %>
<%@ page import="affichage.Graphe" %>
<%@ page import="java.util.Map" %>
<%@ page import="bean.CGenUtil" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String caisseParam = request.getParameter("idCaisse");
    String datyParam = request.getParameter("daty");
    java.sql.Date datyFilter = null;
    if (datyParam != null && !datyParam.isEmpty()) {
        datyFilter = java.sql.Date.valueOf(datyParam);
    }
%>

<div class="content-wrapper" style="padding:20px;">
    <h1 class="card-title text-center">Écart de clôture par caisse et par date</h1>
    <div class="card shadow rounded h-100">
        <div class="card-body">

            <form method="get" action="<%= session.getAttribute("lien") %>">
                <input type="hidden" name="but" value="cloturecaisse/graphe-ecart.jsp">
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label for="idCaisse" class="form-label">Caisse</label>
                        <select id="idCaisse" name="idCaisse" class="form-control">
                            <option value="">Toutes les caisses</option>
                            <%
                                // Charger la liste des caisses
                                caisse.Caisse[] caisses = (caisse.Caisse[]) CGenUtil.rechercher(new caisse.Caisse(), null, null, "");
                                for (caisse.Caisse c : caisses) {
                            %>
                            <option value="<%= c.getId() %>" <%= (caisseParam != null && caisseParam.equals(c.getId())) ? "selected" : "" %>>
                                <%= c.getVal() %>
                            </option>
                            <%
                                }
                            %>
                        </select>

                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="daty" class="form-label">Date</label>
                        <input type="date" id="daty" name="daty" class="form-control"
                               value="<%= datyParam != null ? datyParam : "" %>">
                    </div>
                    <div class="col-md-4 mb-3 d-flex align-items-end">
                        <label  class="form-label"></label>
                        <button type="submit" class="btn btn-primary w-100" style="margin-top: 13px;">Appliquer</button>
                    </div>
                </div>
            </form>

            <canvas id="c_ecart"></canvas>
        </div>
    </div>
</div>

<%
    if (caisseParam != null && !caisseParam.isEmpty()) {
        // --- Une caisse sélectionnée ---
        Map<String, Double> ecartData = EcartCloture.getDataChartByCaisse(caisseParam,datyFilter);

        Graphe g = new Graphe(new Map[]{ecartData}, "ecart",
                new String[]{""}, new String[]{}, "c_ecart", "");
        g.setTypeGraphe("bar");
        g.setCouleurs(utils.ConstanteAsync.couleurs);
        g.setBgCouleurs(utils.ConstanteAsync.couleurs);
        out.println(g.getHtml("ctx_ecart"));

    } else {
        // --- Toutes les caisses = somme par date ---
        Map<String, Double> ecartSomme = EcartCloture.getDataChartSommeParDate(datyFilter);

        Graphe g = new Graphe(new Map[]{ecartSomme}, "ecart",
                new String[]{""}, new String[]{}, "c_ecart", "");
        g.setTypeGraphe("bar");
        g.setCouleurs(utils.ConstanteAsync.couleurs);
        g.setBgCouleurs(utils.ConstanteAsync.couleurs);
        out.println(g.getHtml("ctx_ecart"));
    }
%>


<style>
    .card {
        transition: transform 0.2s ease-in-out;
        padding: 20px;
        border: 1px solid var(--Border);
        border-radius: var(--Bases-4-space-2);
        background-color: var(--Background-primaire);
    }
    canvas {
        max-height: 350px;
    }
</style>
