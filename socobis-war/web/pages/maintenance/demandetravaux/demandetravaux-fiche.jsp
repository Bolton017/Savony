
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="maintenance.planning.DemandeTravauxCpl" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    DemandeTravauxCpl categorie = new DemandeTravauxCpl();
    PageConsulte pc = new PageConsulte(categorie, request, u);
    pc.setTitre("Fiche de demande de travaux");
    categorie = (DemandeTravauxCpl) pc.getBase();
    String id=pc.getBase().getTuppleID();
    categorie = (DemandeTravauxCpl) pc.getBase();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idEntiteLib").setLibelle("Entit&eacute;");
    pc.getChampByName("idMachineLib").setLibelle("&Eacute;l&eacute;ment");
    pc.getChampByName("idSituationLib").setLibelle("Situation");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("dateBesoin").setLibelle("Date de besoin");
    pc.getChampByName("prioriteLib").setLibelle("Priorit&eacute;");
    pc.getChampByName("estExistantLib").setLibelle("Probl&egrave;me d&eacute;j&agrave; rencontr&eacute;");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("idDepartementLib").setLibelle("D&eacute;partement de demande");
    pc.getChampByName("idDepartementMaintenanceLib").setLibelle("D&eacute;partement de maintenance");

    pc.getChampByName("etatLib").setVisible(false);
    pc.getChampByName("idEntite").setVisible(false);
    pc.getChampByName("idMachine").setVisible(false);
    pc.getChampByName("idSituation").setVisible(false);
    pc.getChampByName("estExistant").setVisible(false);
    pc.getChampByName("idDepartement").setVisible(false);
    pc.getChampByName("priorite").setVisible(false);
    pc.getChampByName("idOtFille").setVisible(false);
    pc.getChampByName("IdDepartementMaintenance").setVisible(false);

    String lien = (String) session.getValue("lien");
    String pageModif = "maintenance/demandetravaux/demandetravaux-saisie.jsp&acte=update";
    String classe = "maintenance.planning.DemandeTravaux";
    String pageActuel = "maintenance/demandetravaux/demandetravaux-fiche.jsp";
    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/otravaux-details", "");
    map.put("inc/liste-fabrication-of", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/otravaux-details";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=maintenance/demandetravaux/demandetravaux-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                            <% if (categorie.getEtat()<ConstanteEtat.getEtatValider()){ %>
                                <div class="box-footer">
                                    <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=maintenance/demandetravaux/demandetravaux-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                                    <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 8px">Modifier</a>
                                    <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=maintenance/demandetravaux/demandetravaux-liste.jsp&classe="+classe %>">Supprimer</a>
                                </div>
                            <% } %>
                            <% if (categorie.getEtat()>=ConstanteEtat.getEtatValider()){ %>
                                <a class="btn btn-success pull-right"  href="<%= lien + "?but=maintenance/travaux/Otravaux-saisie.jsp&idDemande=" + id%>" style="margin-right: 10px">Ex&eacute;cuter</a>
<%--                                <a class="btn btn-primary pull-right" href="<%= lien + "?but=maintenance/travaux/Travaux-saisie.jsp&idOffille=" + categorie.getIdOtFille() +"&idDepartement="+categorie.getIdDepartementMaintenance()%>" style="margin-right: 10px">Ex&eacute;cuter</a>--%>

                            <% } %>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>

    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("inc/otravaux-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/otravaux-details">Ordre de travaux</a></li>
<%--                    <li class="<%=map.get("inc/liste-fabrication-of")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-fabrication-of">Travaux</a></li>--%>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= categorie.getId() %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
</div>

