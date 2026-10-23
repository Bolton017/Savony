<%--
    Document   : client-fiche
    Created on : 22 mars 2024, 14:50:51
    Author     : SAFIDY
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%@ page import="maintenance.ressources.IngredientMaintenance" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    IngredientMaintenance d = new IngredientMaintenance();

    PageConsulte pc = new PageConsulte(d, request, u);
    pc.setTitre("Fiche locaux");
    pc.getBase();

    String id=pc.getBase().getTuppleID();

    pc.getChampByName("libelle").setLibelle("Nom du Local");
    pc.getChampByName("localisationObjet").setLibelle("Adresse");
//    pc.getChampByName("dateAquisition").setLibelle("Date d'acquisition");

    pc.getChampByName("idEntite").setVisible(false);
    pc.getChampByName("referenceObjet").setVisible(false);
    pc.getChampByName("marqueObjet").setVisible(false);
    pc.getChampByName("modeleObjet").setVisible(false);
    pc.getChampByName("descriptionObjet").setVisible(false);
    pc.getChampByName("numeroSerieObjet").setVisible(false);
    pc.getChampByName("descriptionObjet").setVisible(false);
    pc.getChampByName("qualiteObjet").setVisible(false);
    pc.getChampByName("etatObjet").setVisible(false);
    pc.getChampByName("puissanceObjet").setVisible(false);
    pc.getChampByName("observationObjet").setVisible(false);
    pc.getChampByName("typeRattachement").setVisible(false);
    pc.getChampByName("idIngredient").setVisible(false);
    pc.getChampByName("estEngin").setVisible(false);
    pc.getChampByName("id").setVisible(false);
    pc.getChampByName("dateAquisition").setVisible(false);
    pc.getChampByName("pu").setVisible(false);
    pc.getChampByName("idLigne").setVisible(false);

    String lien = (String) session.getValue("lien");
    String pageModif = "maintenance/ressources/locaux/locaux-saisie.jsp";
    String classe = "maintenance.ressources.IngredientMaintenance";
    String pageActuel = "maintenance/ressources/locaux/locaux-fiche.jsp";

    Map<String, String> map = new HashMap<>();
    map.put("inc/travaux-details", "");
    map.put("inc/achat-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/travaux-details";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    d=(IngredientMaintenance) pc.getBase();
    String pageTravaux = "maintenance/demandetravaux/demandetravaux-saisie.jsp";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=maintenance/ressources/locaux/locaux-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id +"&acte=update"%>">Modifier</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=" + pageTravaux + "&idMachine=" + id+"&entite="+d.getIdEntite()%>" style="margin-right:10px;">Demande de travaux</a>

                        <%--                            <a  class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=maintenance/ressources/personnel/departement-liste.jsp&classe="+classe %>">Supprimer</a>--%>
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
                    <li class="<%=map.get("inc/travaux-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/travaux-details">Travaux</a></li>
                    <li class="<%=map.get("inc/achat-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/achat-details">Depenses</a></li>
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

