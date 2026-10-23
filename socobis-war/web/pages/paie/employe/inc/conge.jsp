<%@page import="utilitaire.Utilitaire"%>
<%@page import="paie.conge.CongeDroit"%>
<%@page import="paie.log.LogPersonnel"%>
<%@page import="paie.conge.Conge"%>
<%@ page import="paie.conge.MouvementAbsence" %>
<%
    try {
        MouvementAbsence mvt = new MouvementAbsence();
        mvt.setIdPersonnel(request.getParameter("id"));
        double soldeConge = mvt.getSoldeCongePers();
%>

<div class="row">
    <div class="col-md-6">
        <div>
            <!-- <div class="box-header with-border">
                <h1 class="box-title">Solde cong&eacute;</h1>
            </div> -->
            <div class="box-body">
                <table class="table table-bordered">
                    <tr>
                        <th>Nombre de jours</th>
                    </tr>
                    <tr>
                        <td><%= soldeConge %></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>