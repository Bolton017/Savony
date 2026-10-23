<%@page import="user.UserEJB"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    UserEJB u = (UserEJB) session.getAttribute("u");
    if (u == null || u.getUser() == null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }

    @SuppressWarnings("unchecked")
    List<String> importErrors = (List<String>) session.getAttribute("importErrors");
    String importDaty = (String) session.getAttribute("importDaty");
    String importDesce = (String) session.getAttribute("importDesce");
%>

<div class="content-wrapper">
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <h2>Import Tarif Ingrédients</h2>
                        <p>Fichier Excel: colonnes <strong>idIngredient, idTypeClient, date, prixUnitaire</strong></p>

                        <form method="POST" action="<%= request.getContextPath() %>/ImportPrixDetailsServlet" enctype="multipart/form-data">

                            <div class="form-group">
                                <label for="daty">Date de l'import <span style="color: red;">*</span></label>
                                <input type="date" id="daty" name="daty" class="form-control" required value="<%= importDaty != null ? importDaty : "" %>">
                            </div>

                            <div class="form-group">
                                <label for="desce">Description</label>
                                <textarea id="desce" name="desce" class="form-control" rows="3"><%= importDesce != null ? importDesce : "" %></textarea>
                            </div>

                            <div class="form-group">
                                <label for="excelFile">Fichier XLS/XLSX <span style="color: red;">*</span></label>
                                <input type="file" id="excelFile" name="excelFile" class="form-control" accept=".xls,.xlsx,.XLS,.XLSX" required>
                            </div>

                            <div style="margin-top: 20px;">
                                <button type="submit" class="btn btn-primary">Importer</button>
                                <button type="button" class="btn btn-secondary" onclick="history.back();">Annuler</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <% if (importErrors != null && !importErrors.isEmpty()) { %>
    <div class="row m-0" style="margin-top: 20px;">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box box-danger">
                <div class="box-header">
                    <h3 class="box-title">Erreurs d'import</h3>
                </div>
                <div class="box-body">
                    <ul>
                        <% for (String error : importErrors) { %>
                        <li><%= error %></li>
                        <% } %>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <%
        session.removeAttribute("importErrors");
        session.removeAttribute("importDaty");
        session.removeAttribute("importDesce");
    %>
    <% } %>
</div>

