<%-- 
    Document   : client-fiche
    Created on : 22 mars 2024, 14:50:51
    Author     : SAFIDY
--%>

<%@page import="client.Client"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="client.ClientLib" %>
<%@ page import="fichier.AttacherFichier" %>
<%@ page import="uploadbean.UploadService" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
%>
<%
    try{
    String pageActuel = "client/client-fiche.jsp";
    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/client-facture", "");
    map.put("inc/client-bc", "");
    map.put("inc/client-proforma", "");
    map.put("inc/releve-client-opt", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/client-facture";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";


    ClientLib client = new ClientLib();
    client.setNomTable("CLIENTLIB");
    String lien = (String) session.getValue("lien");
    PageConsulte pc = new PageConsulte(client, request, u);
    pc.setTitre("Fiche Client");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("codeclient").setLibelle("Code client");
    pc.getChampByName("nom").setLibelle("Nom");
    pc.getChampByName("telephone").setLibelle("T&eacute;l&eacute;phone");
    pc.getChampByName("mail").setLibelle("Adresse e-mail");
    pc.getChampByName("adresse").setLibelle("Adresse");
    pc.getChampByName("datecarte").setLibelle("Date d ’ &eacute;mission de la carte");
    pc.getChampByName("telfixe").setLibelle("T&eacute;l&eacute;phone personnel");
    pc.getChampByName("echeance").setLibelle("Ech&eacute;ance de paiement");
    pc.getChampByName("IdTarificationLib").setLibelle("Type de client");

    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("compte").setLibelle("Compte G&eacute;n&eacute;ral");
    pc.getChampByName("compteauxiliaire").setLibelle("Compte Auxiliaire");
    pc.getChampByName("compteauxiliaire").setLien(lien + "?but=compta/lien-fiche.jsp&type=compte","compte=");
    pc.getChampByName("idTypeClient").setVisible(false);
    pc.getChampByName("idProvince").setVisible(false);
    pc.getChampByName("idTypeClientLib").setLibelle("Type de tarification");
    pc.getChampByName("provinceLib").setLibelle("Province");
    pc.getChampByName("idModePaiement").setVisible(false);
    pc.getChampByName("CIN").setLibelle("CIN");
    pc.getChampByName("idModePaiementLib").setLibelle("Mode de paiement");
    pc.getChampByName("taxe").setLibelle("Taxe (%)");
    pc.getChampByName("Idzoneclient").setVisible(false);
    pc.getChampByName("IdzoneclientLib").setLibelle("Zone Client");
    pc.getChampByName("delai").setLibelle("D&eacute;lai de validit&eacute; du prix (jours)");

    String pageModif = "client/client-modif.jsp";
    String classe = "client.Client";
    pc.setDossier("CLIENT");
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=client/client-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <!--a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a-->
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=client/client-saisie.jsp&acte=update&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-tertiary pull-right" href="<%= lien + "?but=pageupload.jsp&id=" + request.getParameter("id")
                            + "&dossier=" + pc.getDossier()
                            + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel
                            + "&id=" + request.getParameter("id")
                            + "&classe=" +classe
                            + "&nomprj="+ pc.getChampByName("nom").getValeur() %>"
                            style="margin-right: 10px;">Attacher Fichier</a>
                            <a  class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=client/client-liste.jsp&classe="+classe %>">D&eacute;sactiver</a>
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
                    <!-- a modifier -->
                    <li class="<%=map.get("inc/client-facture")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/client-facture">Liste des Factures</a></li>
                    <li class="<%=map.get("inc/releve-client-opt")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/releve-client-opt">Relev&eacute; client</a></li>
                    <li class="<%=map.get("inc/client-bc")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/client-bc">Liste des Bon de Commandes</a></li>
                    <li class="<%=map.get("inc/client-proforma")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/client-proforma">Liste des Proformas</a></li>
                    <li class="<%=map.get("inc/tarif-ingredients-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/tarif-ingredients-liste">Tarifs</a></li>

                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="numbl" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>

    <%=pc.getHtmlAttacherFichier()%>
</div>
<%}catch (Exception e){
        e.printStackTrace();
}%>
