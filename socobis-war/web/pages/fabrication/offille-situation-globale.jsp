<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 01/09/2025
  Time: 17:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="fabrication.OffilleEtatGlobal" %>
<%@ page import="fabrication.OfFilleCpl" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>
<%@page import="java.util.Map"%>
<%@page import="stock.MvtStockFilleTheorique"%>
<%@page import="utilitaire.Utilitaire"%>
<%@ page import="produits.Ingredients" %>
<% try{
    String id = request.getParameter("id");
    OffilleEtatGlobal etatGlobal = new OffilleEtatGlobal(id);
    MvtStockFilleTheorique[]rapprochementGlobal = etatGlobal.getRapprochementGlobal();
    OfFilleCpl offille = etatGlobal.getOffille();
    String idIngredient = offille.getIdIngredients();
    Ingredients ingredients = (Ingredients) new Ingredients().getById(idIngredient,null,null);

%>
<style>
    .fiche-article {border-collapse: collapse; width: 100%; max-width: 720px;}
    .fiche-article th, .fiche-article td {border: 1px solid #ddd; padding: 8px;}
    .fiche-article th {background: #f4f6f8; text-align: left;}
    .fiche-article td:last-child {text-align: right;}
    .fiche-article caption {text-align: left; font-weight: 600; margin: 0 0 8px;}
</style>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Situation globale</h1>
    </section>
    <section class="content">
        <div class="box">
            <div class="box-body table-responsive no-padding">
                <div id="selectnonee">
                    <table class="table table-bordered table-striped table-hover text-center align-middle" cellpadding="6" cellspacing="0">
                        <tbody>
                        <tr>
                            <td>Article</td>
                            <td><%=  ingredients.getLibelle() %></td>
                        </tr>
                        <tr>
                            <td>Quantit&eacute; ordre</td>
                            <td><%= offille.getQte() %></td>
                        </tr>
                        <tr>
                            <td>Quantit&eacute; fabriqu&eacute;</td>
                            <td><%= offille.getQteFabrique() %></td>
                        </tr>
                        <tr>
                            <td>Reste &agrave; fabriqu&eacute;</td>
                            <td><%= offille.getQteReste() %></td>
                        </tr>
                        <tr>
                            <td>Prix Unitaire de revient</td>
                            <td><%= Utilitaire.formaterAr(offille.getPuRevient()) %></td>
                        </tr>
                        <tr>
                            <td>Prix de vente</td>
                            <td><%= Utilitaire.formaterAr(offille.getPv()) %></td>
                        </tr>
                        <tr>
                            <td>Valeur th&eacute;orique</td>
                            <td><%= Utilitaire.formaterAr(Utilitaire.enleverExponentielleDouble(offille.getMontantRevient())) %></td>
                        </tr>
                        <tr>
                            <td>Valeur fabriqu&eacute;s</td>
                            <td><%= Utilitaire.formaterAr(Utilitaire.enleverExponentielleDouble(offille.getMontantentree())) %></td>
                        </tr>
                        <tr>
                            <td>D&eacute;pense fabrication</td>
                            <td><%= Utilitaire.formaterAr(Utilitaire.enleverExponentielleDouble(offille.getMontantsortie())) %></td>
                        </tr>
                        <tr>
                            <td>Taux de revient</td>
                            <td><%= Utilitaire.formaterAr(Utilitaire.enleverExponentielleDouble(offille.getTauxRevient())) %></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <%
            HashMap<String, Vector> rapprochement = etatGlobal.getRapprochement();
            for (Map.Entry<String, Vector> liste : rapprochement.entrySet()) {
                String categorie = liste.getKey();
                Vector valeurs = liste.getValue();
        %>
        <% if (valeurs!=null && !valeurs.isEmpty()){ %>
        <div class="box">
            <div class="box-body table-responsive no-padding">
                <div id="selectnonee">
                    <table class="table table-bordered table-striped table-hover text-center align-middle">
                        <thead class="table-dark">
                        <tr>
                            <th style="width:40%"><%=categorie%></th>
                            <th>Quantit&eacute;</th>
                            <th>P.U</th>
                            <th>Quantit&eacute; th&eacute;orique</th>
                            <th>P.U th&eacute;orique</th>
                            <th>Montant</th>
                            <th>Montant th&eacute;orique</th>
                            <th>&eacute;cart quantit&eacute;</th>
                            <th>&eacute;cart montant</th>
                            <th></th>
                        </tr>
                        </thead>
                        <tbody>
                            <%
              for (Object obj : valeurs) {
                  if (obj instanceof MvtStockFilleTheorique) {
                      MvtStockFilleTheorique mvt = (MvtStockFilleTheorique) obj;
          %>
                        <tr>
                            <td><%= mvt.getDesignation() %></td>
                            <td><%=mvt.getSortie()%></td>
                            <td><%=  Utilitaire.formaterAr(mvt.getPu()) %></td>
                            <td><%= mvt.getQteth() %></td>
                            <td><%=  Utilitaire.formaterAr(mvt.getPuth()) %></td>
                            <td><%=  Utilitaire.formaterAr(mvt.getMontantsortie()) %></td>
                            <td><%=  Utilitaire.formaterAr(mvt.getMontth()) %></td>
                            <td><%=  Utilitaire.formaterAr(mvt.getEcartqte()) %></td>
                            <td><%=  Utilitaire.formaterAr(mvt.getEcartmontant()) %></td>
                        </tr>
                            <%
                  }
              }%>
                        <tbody>
                            <% } %>
                    </table>
                </div>
            </div>
        </div>
        <% } %>
        <div class="col-md-12 nopadding">
            <div class="box-solid table-container recap-table">
                <div>
                    <h3 class="box-title cardtitle h520pxSemibold" align="left">TABLEAU RECAPITULATIF</h3>
                </div>
                <div class="box-body table-container nopadding">
                    <div id="selectnonee">
                        <table class="table table-bordered table-striped table-hover text-center align-middle">
                            <thead class="table-dark">
                            <tr>
                                <th style="width:40%">INTITULES</th>
<%--                                <th>Quantit&eacute;</th>--%>
<%--                                <th>P.U</th>--%>
                                <th>Montant Th&eacute;orique</th>
                                <th>Total</th>
                                <th>&eacute;cart</th>
                                <th></th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                MvtStockFilleTheorique.calculerPourcentage(rapprochementGlobal);
                                for (int i=0;i<rapprochementGlobal.length;i++) {
                            %>
                            <tr>
                                <td><%= rapprochementGlobal[i].getCategorieingredient() %></td>
<%--                                <td> <%= Utilitaire.formaterAr(rapprochementGlobal[i].getQteth()) %> </td>--%>
<%--                                <td> <%= Utilitaire.formaterAr(rapprochementGlobal[i].getPuth()) %> </td>--%>
                                <td><%= Utilitaire.formaterAr(rapprochementGlobal[i].getMontth()) %></td>
                                <td><%=  Utilitaire.formaterAr(rapprochementGlobal[i].getMontantsortie()) %></td>
                                <td><%=  rapprochementGlobal[i].getEcart() %></td>

                                <td><%=  rapprochementGlobal[i].getPourcentage() %> %</td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>


        <div class="col-md-6">
            <a class="btn btn-primary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=offille_situation_globale&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer en PDF</a>
        </div>
    </section>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>
