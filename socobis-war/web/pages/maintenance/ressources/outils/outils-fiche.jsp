@ -0,0 +1,74 @@
<%--
  Created by IntelliJ IDEA.
  User: nomenjanhary ramarokoto
  Date: 01/12/2025
  Time: 23:28
  To change this template use File | Settings | File Templates.
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="maintenance.ressources.IngredientMaintenanceLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    IngredientMaintenanceLib d = new IngredientMaintenanceLib();
    String pageModif = "maintenance/ressources/outils/outils-saisie.jsp";
    String pageAttribuer = "maintenance/ressources/outils/attribution/attribution-saisie.jsp";
    PageConsulte pc = new PageConsulte(d, request, u);
    String id=pc.getBase().getTuppleID();
    pc.setTitre("Fiche d'un outil");
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("libelle").setLibelle("Libell&eacute;");
    pc.getChampByName("idEntiteLib").setLibelle("Entit&eacute;");
    pc.getChampByName("referenceObjet").setLibelle("R&eacute;f&eacute;rence");
    pc.getChampByName("marqueObjet").setLibelle("Marque");
    pc.getChampByName("modeleObjet").setLibelle("Mod&egrave;le");
    pc.getChampByName("numeroSerieObjet").setLibelle("Num&eacute;ro de serie");
    pc.getChampByName("descriptionObjet").setLibelle("D&eacute;scription");
    pc.getChampByName("qualiteObjetLib").setLibelle("Qualit&eacute;");
    pc.getChampByName("etatObjetLib").setLibelle("&Eacute;tat");
    pc.getChampByName("localisationObjet").setLibelle("Localisation");
    pc.getChampByName("observationObjet").setLibelle("Caracteristique");
    pc.getChampByName("pu").setLibelle("Prix Unitaire");
    pc.getChampByName("puissanceObjet").setVisible(false);
    pc.getChampByName("idIngredient").setVisible(false);
    pc.getChampByName("qualiteObjet").setVisible(false);
    pc.getChampByName("etatObjet").setVisible(false);
    pc.getChampByName("estEngin").setVisible(false);
    pc.getChampByName("typeRattachement").setVisible(false);
    pc.getChampByName("idEntite").setVisible(false);
    pc.getChampByName("idEntiteLib").setVisible(false);
    pc.getChampByName("estEnginLib").setVisible(false);
    pc.getChampByName("LocalisationObjetLib").setVisible(false);
    pc.getChampByName("DateAquisition").setVisible(false);
    pc.getChampByName("referenceObjet").setVisible(false);
    pc.getChampByName("localisationObjet").setVisible(false);
    pc.getChampByName("idLigne").setVisible(false);
    pc.getChampByName("idLigneLib").setVisible(false);
    String[] ordre = {"id","libelle","idEntiteLib","descriptionObjet","numeroSerieObjet",
            "marqueObjet","qualiteObjetLib","etatObjetLib","observationObjet",
            "puissanceObjet"};
    pc.setOrdre(ordre);
    String lien = (String) session.getValue("lien");
    String pageTravaux = "maintenance/demandetravaux/demandetravaux-saisie.jsp";


    String pageActuel = "maintenance/ressources/outils/outils-fiche.jsp";
    Map<String, String> map = new HashMap<>();
    map.put("inc/attribution-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/attribution-details";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    d=(IngredientMaintenanceLib) pc.getBase();
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=maintenance/ressources/outils/outils-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
                           <a class="btn btn-secondary pull-right" style="margin-right: 10px;" href="<%= lien + "?but="+ pageModif +"&id=" + id +"&acte=update"%>">Modifier</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=" + pageTravaux + "&idMachine=" + id+"&entite="+d.getIdEntite() %>" style="margin-right:10px;">Demande de travaux</a>

                        <%--                            <a class="btn btn-secondary pull-right" style="margin-right: 10px;" href="<%= lien + "?but="+ pageAttribuer +"&id=" + id +"&acte=insert"%>">Attribuer</a>--%>
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
<%--                    <li class="<%=map.get("inc/attribution-details.jsp")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/attribution-details.jsp">Historique d'attribution</a></li>--%>
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



