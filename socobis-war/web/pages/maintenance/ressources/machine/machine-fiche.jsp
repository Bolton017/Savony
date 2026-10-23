<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%--
  Created by IntelliJ IDEA.
  User: nomenjanhary ramarokoto
  Date: 01/12/2025
  Time: 23:28
  To change this template use File | Settings | File Templates.
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="maintenance.ressources.IngredientMaintenanceLib" %>

<%
    UserEJB u = (user.UserEJB) session.getValue("u");

%>
<%
    try {
        IngredientMaintenanceLib d = new IngredientMaintenanceLib();
        String dossier = "op";
        String pageActuel = "maintenance/ressources/machine/machine-fiche.jsp";

        PageConsulte pc = new PageConsulte(d, request, u);
        String pageModif = "maintenance/ressources/machine/machine-saisie.jsp";
        String pageTravaux = "maintenance/demandetravaux/demandetravaux-saisie.jsp";
        pc.setTitre("Fiche d'une machine");
        String id = pc.getBase().getTuppleID();
        pc.getChampByName("id").setLibelle("R&eacute;f&eacute;rence");
        pc.getChampByName("libelle").setLibelle("Libell&eacute;");
        pc.getChampByName("idEntiteLib").setLibelle("Entit&eacute;");
        pc.getChampByName("referenceObjet").setLibelle("R&eacute;f&eacute;rence");
        pc.getChampByName("marqueObjet").setLibelle("Marque");
        pc.getChampByName("modeleObjet").setLibelle("Mod&egrave;le");
        pc.getChampByName("numeroSerieObjet").setLibelle("Num&eacute;ro de s&eacute;rie");
        pc.getChampByName("descriptionObjet").setLibelle("Description");
        pc.getChampByName("qualiteObjetLib").setLibelle("Qualit&eacute;");
        pc.getChampByName("etatObjetLib").setLibelle("&Eacute;tat de la machine");
        pc.getChampByName("observationObjet").setLibelle("Caract&eacute;ristique");
        pc.getChampByName("puissanceObjet").setLibelle("Puissance");
        pc.getChampByName("dateAquisition").setLibelle("Date d'acquisition");
        pc.getChampByName("localisationObjetLib").setLibelle("Locaux");
//    pc.getChampByName("pu").setLibelle("Prix Unitaire");
        pc.getChampByName("idLigneLib").setLibelle("Ligne");
        pc.getChampByName("puissanceObjet").setVisible(false);
        pc.getChampByName("idIngredient").setVisible(false);
        pc.getChampByName("qualiteObjet").setVisible(false);
        pc.getChampByName("etatObjet").setVisible(false);
        pc.getChampByName("estEngin").setVisible(false);
        pc.getChampByName("typeRattachement").setVisible(false);
        pc.getChampByName("idEntite").setVisible(false);
        pc.getChampByName("idEntiteLib").setVisible(false);
        pc.getChampByName("estEnginLib").setVisible(false);
        pc.getChampByName("referenceObjet").setVisible(false);
        pc.getChampByName("localisationObjet").setVisible(false);
        pc.getChampByName("idLigne").setVisible(false);
        pc.getChampByName("numeroSerieObjet").setVisible(false);
        pc.getChampByName("modeleObjet").setVisible(false);
        pc.getChampByName("pu").setVisible(false);
        String lien = (String) session.getValue("lien");
        d = (IngredientMaintenanceLib) pc.getBase();
        pc.getChampByName("idLigneLib").setLien(lien + "?but=ligne/ligne-fiche.jsp&id=" + d.getIdLigne(), "page=");

        String[] ordre = {"id", "dateAquisition", "libelle", "idLigneLib", "descriptionObjet", "numeroSerieObjet",
                "marqueObjet", "qualiteObjetLib", "etatObjetLib", "localisationObjetLib", "observationObjet"};
        pc.setOrdre(ordre);

        Map<String, String> map = new HashMap<>();
        map.put("inc/travaux-details", "");
        map.put("inc/achat-details", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/travaux-details";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=maintenance/ressources/machine/machine-liste.jsp"%>> <i
            class="fa fa-angle-left"></i></a><%=pc.getTitre()%>
    </h1>
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
                            <a class="btn btn-secondary pull-right"
                               href="<%= lien + "?but="+ pageModif +"&id=" + id +"&acte=update"%>"
                               style="margin-right:10px;">Modifier</a>
                            <a class="btn btn-secondary pull-right"
                               href="<%= lien + "?but=" + pageTravaux + "&idMachine=" + id+"&entite="+d.getIdEntite() %>"
                               style="margin-right:10px;">Demande de travaux</a>

                            <a class="btn btn-tertiary pull-right"
                               href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + id + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + id %>"
                               style="margin-right:10px;">Attacher Fichier</a>
                            <a class="btn btn-secondary pull-right"
                               href="<%= lien + "?but=maintenance/ressources/machine/composition-machine-saisie.jsp&idMachine=" + id+"&idproduit="+d.getIdIngredient()%>"
                               style="margin-right:10px;">Ajout composant </a>

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
                    <li class="<%=map.get("inc/travaux-details")%>"><a
                            href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/travaux-details">Travaux</a>
                    </li>
                    <li class="<%=map.get("inc/achat-details")%>"><a
                            href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/achat-details">Depenses</a>
                    </li>
                    <li class="<%=map.get("inc/composant-machine")%>"><a
                            href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&idproduit=<%= d.getIdIngredient() %>&tab=inc/composant-machine">Composant
                        machine</a></li>

                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>">
                        <jsp:param name="id" value="<%= id %>"/>
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
    <% out.println(pc.getHtmlAttacherFichier());%>
</div>
<%
    } catch (Exception e) {

        e.printStackTrace();
    }
%>
