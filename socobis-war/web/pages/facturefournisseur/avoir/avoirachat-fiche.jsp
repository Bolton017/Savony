<%--
  Created by IntelliJ IDEA.
  User: tsinjoniaina
  Date: 25/09/2026
  Time: 09:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="avoir.AvoirAchatLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="constante.ConstanteEtat" %>

<% try{
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    AvoirAchatLib o = new AvoirAchatLib();
    o.setNomTable("AVOIRACHATCALC_AVEC_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche de l'avoir achat");
    String id = pc.getBase().getTuppleID();
    o = (AvoirAchatLib) pc.getBase();

    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("idFournisseurLib").setLibelle("Fournisseur");
    pc.getChampByName("designation").setLibelle("D&eacute;signation");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("idMagasinLib").setLibelle("Magasin");
    pc.getChampByName("idMagasinLib").setVisible(false);
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("etatLib").setVisible(false);
    pc.getChampByName("idFacture").setLibelle("Ref. Facture");
    pc.getChampByName("idFacture").setLien(lien+"?but=facturefournisseur/facturefournisseur-fiche.jsp", "id=");
    pc.getChampByName("remise").setLibelle("Remise(%)");
    pc.getChampByName("remise").setVisible(false);
    pc.getChampByName("montantRemise").setLibelle("Montant Remise");
    pc.getChampByName("montantNonRemise").setLibelle("Montant Sans Remise");
    pc.getChampByName("montantHt").setLibelle("Montant HT");
    pc.getChampByName("montantTva").setLibelle("Montant TVA");
    pc.getChampByName("montantTtc").setLibelle("Montant TTC");
    pc.getChampByName("montantTtcAr").setVisible(false);
    pc.getChampByName("idMagasin").setVisible(false);
    pc.getChampByName("idFournisseur").setVisible(false);

    String[] ordre = {"daty","idfournisseurLib","designation","remarque","idmagasinLib","id","etat","idFacture"};
    pc.setOrdre(ordre);

    String pageActuel = "facturefournisseur/avoir/avoirachat-fiche.jsp";
    String pageRetour = "facturefournisseur/avoir/avoirachat-liste.jsp";
    String pageModif = "facturefournisseur/avoir/avoirachat-saisie.jsp&acte=update";
    String pageApresDelete = "facturefournisseur/avoir/avoirachat-liste.jsp";
    String classe = "avoir.AvoirAchat";

    Map<String, String> map = new HashMap<>();
    map.put("inc/avoir-detail", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/avoir-detail";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
%>

<div class="content-wrapper">

    <h1 class="box-title"><a href=<%= lien + "?but=" + pageRetour%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <% if (o.getEtat() < ConstanteEtat.getEtatValider()) {%>
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=facturefournisseur/avoir/avoirachat-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=facturefournisseur/facturefournisseur-liste.jsp&classe="+classe %>&nomtable=AvoirAchat">Supprimer</a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- Exemple d'onglet -->
                    <li class="<%=map.get("inc/avoir-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/avoir-detail">D&eacute;tails</a></li>
                    <li class="<%=map.get("../inc/ecriture-detail")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=../inc/ecriture-detail">Écriture</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
</div>

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>