<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 01/09/2025
  Time: 17:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="fabrication.OfEtatGlobal" %>
<%@ page import="fabrication.OfFilleCpl" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.HashMap" %>
<%@page import="java.util.Map"%>
<%@page import="stock.MvtStockFilleTheorique"%>
<%@page import="utilitaire.Utilitaire"%>
<% try{
    String id = request.getParameter("id");
    OfEtatGlobal etatGlobal = new OfEtatGlobal(id);
    MvtStockFilleTheorique[]rapprochementGlobal = etatGlobal.getRapprochementGlobal();
    OfFilleCpl[]details = etatGlobal.getDetails();


%>
<div class="content-wrapper">
  <section class="content-header">
    <h1>Situation globale</h1>
  </section>
  <div class="box-fiche">
    <div class="box">         
      <section class="content">
        <h2>OF : <%=etatGlobal.getOf().getId()%></h2>
        <p>Date : <%= Utilitaire.formatterDaty(etatGlobal.getOf().getDaty())%> </p>
        <%
          HashMap<String, Vector> rapprochement = etatGlobal.getRapprochement();
          for (Map.Entry<String, Vector> liste : rapprochement.entrySet()) {
            String categorie = liste.getKey();
            Vector valeurs = liste.getValue();
        %>
        <table class="table table-bordered table-striped table-hover text-center align-middle">
          <thead class="table-dark">
          <tr>
            <th style="width:40%"><%=categorie%></th>
            <th>Quantité</th>
            <th>P.U</th>
            <th>Quantité théorique</th>
            <th>P.U théorique</th>
            <th>Montant</th>
            <th>Montant théorique</th>
            <th>Écart quantité</th>
            <th>Écart montant</th>
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
    <%--      RECAPITULATIF--%>
        <h2>TABLEAU R&Eacute;CAPITULATIF</h2>
        <table class="table table-bordered table-striped table-hover text-center align-middle">
          <thead class="table-dark">
          <tr>
            <th style="width:40%">INTITUL&Eacute;S</th>
            <th>Quantit&eacute;</th>
            <th>Prix Unitaire</th>
            <th>Montant Th&eacute;orique</th>
            <th>Total</th>
            <th>&Eacute;cart</th>
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
              <td></td>
              <td></td>
              <td><%= Utilitaire.formaterAr(rapprochementGlobal[i].getMontth()) %></td>
              <td><%=  Utilitaire.formaterAr(rapprochementGlobal[i].getMontantsortie()) %></td>
              <td><%=  Utilitaire.formaterAr(rapprochementGlobal[i].getEcart()) %></td>

              <td><%=  rapprochementGlobal[i].getPourcentage() %> %</td>
            </tr>
            <% } %>
          </tbody>
        </table>

    <%--    DETAILS--%>
        <h2>LISTE DES D&Eacute;TAILS</h2>
        <table class="table table-bordered table-striped table-hover text-center align-middle">
          <thead class="table-dark">
          <tr>
            <th style="width:40%">D&eacute;signation</th>
            <th>Prix de revient</th>
            <th>Qt&eacute; fabriqu&eacute;e</th>
            <th>Prix de vente</th>
            <th>D&eacute;penses de fabrication</th>
            <th>Taux de revient</th>
          </tr>
          </thead>
          <tbody>
          <%
    //        MvtStockFilleTheorique.calculerPourcentage(rapprochementGlobal);
            for (int i=0;i<details.length;i++) {
          %>
          <tr>
            <td><%= details[i].getLibelleexacte() %></td>
            <td><%= Utilitaire.formaterAr(details[i].getPurevient()) %></td>
            <td><%= details[i].getQteFabrique()%></td>
            <td><%=  Utilitaire.formaterAr(details[i].getPv()) %></td>
            <td><%=  Utilitaire.formaterAr(details[i].getMontantsortie()) %></td>
            <td><%=  details[i].getTauxRevient() %></td>
          </tr>
          <% } %>
          </tbody>
        </table>

        <a class="btn btn-primary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=situation_globale&id=<%=request.getParameter("id")%>" style="margin-right: -14px;margin-top: 30px">Imprimer en PDF</a>

      </section>
    </div>
  </div>

</div>
<%
  } catch (Exception e) {
    e.printStackTrace();
  } %>
