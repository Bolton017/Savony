<%@ page import="affichage.Graphe" %>
<%@ page import="paie.employe.SalaireParFonction" %>
<%@ page import="paie.employe.TauxAbsenteisme" %>
<%@ page import="java.util.Map" %>
<%@ page import="utils.ConstanteAsync" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    Map<Integer, String> moisMap = TauxAbsenteisme.getMoisMap();

    // -------- Filtres Salaire --------
    String moisSalaireParam = request.getParameter("moisSalaire");
    String anneeSalaireParam = request.getParameter("anneeSalaire");

    Integer moisSalaire = (moisSalaireParam != null && !moisSalaireParam.isEmpty()) ? Integer.parseInt(moisSalaireParam) : null;
    Integer anneeSalaire = (anneeSalaireParam != null && !anneeSalaireParam.isEmpty()) ? Integer.parseInt(anneeSalaireParam) : null;

    // -------- Filtres Absenteisme --------
    String moisAbsParam = request.getParameter("moisAbs");
    String anneeAbsParam = request.getParameter("anneeAbs");

    Integer moisAbs = (moisAbsParam != null && !moisAbsParam.isEmpty()) ? Integer.parseInt(moisAbsParam) : null;
    Integer anneeAbs = (anneeAbsParam != null && !anneeAbsParam.isEmpty()) ? Integer.parseInt(anneeAbsParam) : null;
%>

<div class="content-wrapper" style="padding: 20px;">
    <h1>Graphe analyse de salaire</h1>
    <form method="get" action="<%= session.getAttribute("lien") %>">
        <div class="col-md-12 cardradius">
            <div class="input-container">
                <h5 class="card-title w-100 m-0">Moyenne salaire par Fonctions</h5>
                <div class="form-input mb-5">
                    <label for="anneeSalaire" class="input-label">Année</label>
                    <input type="number" id="anneeSalaire" name="anneeSalaire" class="form-control"
                           value="<%= anneeSalaire != null ? anneeSalaire : "" %>"
                           placeholder="Toutes les années">
                </div>
                <div class="form-input mb-5">
                    <label for="moisSalaire" class="input-label">Mois</label>
                    <select id="moisSalaire" name="moisSalaire" class="form-control">
                        <option value="">Tous les mois</option>
                        <%
                            for (Map.Entry<Integer, String> entry : moisMap.entrySet()) {
                        %>
                        <option value="<%= entry.getKey() %>"
                                <%= (moisSalaire != null && moisSalaire.equals(entry.getKey())) ? "selected" : "" %>>
                            <%= entry.getValue() %>
                        </option>
                        <%
                            }
                        %>
                    </select>
                </div>

                <h5 class="card-title w-100 m-0">Taux d'absentéisme par période</h5>
                <div class="form-input ">
                    <label for="anneeAbs" class="input-label">Année</label>
                    <input type="number" id="anneeAbs" name="anneeAbs" class="form-control"
                           value="<%= anneeAbs != null ? anneeAbs : "" %>"
                           placeholder="Toutes les années">
                </div>
                <div class="form-input ">
                    <label for="moisAbs" class="input-label">Mois</label>
                    <select id="moisAbs" name="moisAbs" class="form-control">
                        <option value="">Tous les mois</option>
                        <%
                            for (Map.Entry<Integer, String> entry : moisMap.entrySet()) {
                        %>
                        <option value="<%= entry.getKey() %>"
                                <%= (moisAbs != null && moisAbs.equals(entry.getKey())) ? "selected" : "" %>>
                            <%= entry.getValue() %>
                        </option>
                        <%
                            }
                        %>
                    </select>
                </div>

                <input type="hidden" name="but" value="paie/editions/graphe-salaire.jsp">
                <div class="box-footer borderless nopadding w-100" style="margin-top: 1rem;">
                    <button type="submit" name="Submit2" class="btn btn-primary pull-right" style="margin-right: 0;" multi-lang="">Enregistrer</button>
                    <button type="reset" name="Submit2" class="btn btn-secondary pull-right" style="margin-right: 15px;" multi-lang="">Réinitialiser</button>
                </div>
            </div>
        </div>
    </form>
    <div class="row m-0">
        <div class="col-md-12 cardradius">
            <h5 class="card-title w-100 h520pxSemibold" style="margin-top: 0">Moyenne salaire par Fonctions</h5>
            <canvas id="c_salaireparfonction"></canvas>
        </div>
        <div class=" col-md-12 cardradius">
            <h5 class="card-title h520pxSemibold w-100 " style="margin-top: 0">Taux d'absentéisme par période</h5>
            <canvas id="c_tauxabsence"></canvas>
        </div>
    </div>
</div>

<%
    try {
        // --- Graphe Salaire ---
        Map<String, Double> salaireData;
        if (moisSalaire != null && anneeSalaire != null) {
            salaireData = SalaireParFonction.getDataChart(moisSalaire, anneeSalaire);
        } else if (moisSalaire != null) {
            salaireData = SalaireParFonction.getDataChartByMois(moisSalaire);
        } else if (anneeSalaire != null) {
            salaireData = SalaireParFonction.getDataChartByAnnee(anneeSalaire);
        } else {
            salaireData = SalaireParFonction.getDataChart();
        }

        Graphe g1 = new Graphe(new Map[]{salaireData}, "fonctionLib",
                new String[]{"fonctionLib"}, new String[]{""}, "c_salaireparfonction", "");
        g1.setTypeGraphe("bar");
        g1.setCouleurs(ConstanteAsync.couleurs);
        g1.setBgCouleurs(ConstanteAsync.couleurs);
        out.println(g1.getHtml("ctx1"));

        // --- Graphe Absenteisme ---
        Map<String, Double> absenceData;
        if (moisAbs != null && anneeAbs != null) {
            absenceData = TauxAbsenteisme.getDataChart(moisAbs, anneeAbs);
        } else if (moisAbs != null) {
            absenceData = TauxAbsenteisme.getDataChartByMois(moisAbs);
        } else if (anneeAbs != null) {
            absenceData = TauxAbsenteisme.getDataChartByAnnee(anneeAbs);
        } else {
            absenceData = TauxAbsenteisme.getDataChart();
        }

        Graphe g2 = new Graphe(new Map[]{absenceData}, "moisLib",
                new String[]{"moisLib"}, new String[]{""}, "c_tauxabsence", "");
        g2.setTypeGraphe("bar");
        g2.setCouleurs(ConstanteAsync.couleurs);
        g2.setBgCouleurs(ConstanteAsync.couleurs);
        out.println(g2.getHtml("ctx2"));
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
    .input-label {
        font-weight: 600;
        color: #333;
        font-size: 0.9rem;
    }
</style>
