<%@page import="paie.frais.FraisMedicauxData"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="paie.frais.RetraitFraisMedicaux"%>
<%@page import="bean.CGenUtil"%>
<%@page import="paie.employe.PersonneGainSortieReste"%>
<%
    try {
        String id = request.getParameter("id");
        FraisMedicauxData fraisMedicaux = new FraisMedicauxData(id);
%>

<div class="row">
    <div class="col-md-12">
        <div class="box box-primary box-fiche">
            <div class="box-header with-border">
                <h1 class="box-title">Solde frais m&eacute;dicaux</h1> 
            </div>
            <div class="box-body">
                <% if (fraisMedicaux.getListePers() != null && fraisMedicaux.getListePers().length > 0) {%>
                <table class="table table-bordered">
                    <tr>				
                        <th>ID</th>
                        <th>Personnel</th>
                        <th>Dotation</th>
                        <th>Remboursement</th>
                        <th>Solde</th>
                    </tr>
                    <% for( PersonneGainSortieReste tmp : fraisMedicaux.getListePers() ){ %>
                    <tr>
                        <td><%= tmp.getId() %></td>
                        <td><%= tmp.getCturgence_nom_prenom() %></td>
                        <td><%= Utilitaire.formaterAr(tmp.getGain()) %></td>
                        <td><%= Utilitaire.formaterAr(tmp.getMontant()) %></td>
                        <td><%= Utilitaire.formaterAr(tmp.getReste()) %></td>
                    </tr>
                    <% } %>
                </table>
                <% } else {%>
                    Aucune solde de frais m�dicaux.
                <% }%>
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
        <div class="box box-primary box-fiche">
            <div class="box-header with-border">
                <h1 class="box-title">Liste des retraits de frais medicaux</h1> 
            </div>
            <div class="box-body">
                				
                <% if (fraisMedicaux.getListeRetrait() != null && fraisMedicaux.getListeRetrait().length > 0) {%>
                <table class="table table-bordered">
                    <tr>
                        <th>Description</th>
                        <th>Date de retrait</th>
                        <th>Montant</th>
                        <th>Etat</th>
                    </tr>
                    <% for( RetraitFraisMedicaux tmp : fraisMedicaux.getListeRetrait() ){ %>
                    <tr>
                        <td><%= tmp.getDescription() %></td>
                        <td><%= Utilitaire.formatterDaty(tmp.getDaty()) %></td>
                        <td><%= Utilitaire.formaterAr(tmp.getMontant()) %></td>
                        <td><%= tmp.getEtatlib()%></td>
                    </tr>
                    <% } %>
                </table>
                <% } else {%>
                    Aucun retrait de frais m&eacute;dicaux.
                <% }%>
            </div>
        </div>
    </div>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>