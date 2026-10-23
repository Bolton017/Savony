

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="maintenance.planning.PlanningCpl" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    PlanningCpl categorie = new PlanningCpl();
    PageConsulte pc = new PageConsulte(categorie, request, u);
    pc.setTitre("Fiche de planning");
    categorie = (PlanningCpl) pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("refObjet").setLibelle("Description");
    pc.getChampByName("idMachineLib").setLibelle("&Eacute;l&eacute;ment");
    pc.getChampByName("idTypeMaintenanceLib").setLibelle("Type de maintenance");
    pc.getChampByName("frequence").setLibelle("Fr&eacute;quence");
    pc.getChampByName("datedebut").setLibelle("Date de d&eacute;but");
    pc.getChampByName("datefin").setVisible(false);
    pc.getChampByName("uniteLib").setLibelle("Unit&eacute;");
    pc.getChampByName("PrioriteLib").setLibelle("Priorit&eacute;");
    pc.getChampByName("estPeriodiqueLib").setLibelle("Est p&eacute;riodique");
    pc.getChampByName("duree").setLibelle("dur&eacute;e");
    pc.getChampByName("EtatDemandeTravauxLib").setLibelle("Situation de la demande de travaux");
    pc.getChampByName("EtatTravauxLib").setLibelle("Situation du travaux");
    pc.getChampByName("IdEntiteLib").setLibelle("Entit&eacute;");
//    pc.getChampByName("EstTerminee").setVisible(false);
    pc.getChampByName("IdTravaux").setVisible(false);
    pc.getChampByName("EtatOrdreTravauxLib").setVisible(false);

    pc.getChampByName("etatLib").setVisible(false);
    pc.getChampByName("unite").setVisible(false);
    pc.getChampByName("Priorite").setVisible(false);
    pc.getChampByName("IdDemandeTravaux").setVisible(false);
    pc.getChampByName("IdOrdreTravaux").setVisible(false);
    pc.getChampByName("IdOrdreTravauxFille").setVisible(false);
    pc.getChampByName("EtatDemandeTravaux").setVisible(false);
    pc.getChampByName("EtatOrdreTravaux").setVisible(false);
    pc.getChampByName("EtatTravaux").setVisible(false);
    pc.getChampByName("idMachine").setVisible(false);
    pc.getChampByName("idTypeMaintenance").setVisible(false);
    pc.getChampByName("estPeriodique").setVisible(false);
    pc.getChampByName("idSource").setVisible(false);
    pc.getChampByName("IdEntite").setVisible(false);
    pc.getChampByName("uniteLib").setVisible(false);
    pc.getChampByName("PrioriteLib").setVisible(false);

    String lien = (String) session.getValue("lien");
    String pageModif = "maintenance/planning/planning-saisie.jsp&acte=update";
    String classe = "maintenance.planning.Planning";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=maintenance/planning/planning-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                            <% if (categorie.getEtat()<ConstanteEtat.getEtatValider()){ %>
                                <div class="box-footer">
                                    <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=maintenance/planning/planning-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                                    <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                                    <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=maintenance/planning/calendrier-maintenance.jsp&classe="+classe %>">Supprimer</a>
                                </div>
                            <% }else{ %>
                                <div class="box-footer">
                                    <% if(categorie.getIdDemandeTravaux()==null){ %>
                                    <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien")%>?but=maintenance/demandetravaux/demandetravaux-saisie.jsp&idplanning=<%=categorie.getId()%>&entite=<%=categorie.getIdEntite()%>&idMachine=<%=categorie.getIdMachine()%>&description=<%=categorie.getRefObjet()%>" style="margin-right: 10px">Demande de travaux</a>
                                    <% }else if(categorie.getIdDemandeTravaux()!=null && categorie.getIdTravaux()==null){ %>
                                    <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien")%>?but=maintenance/travaux/Travaux-saisie.jsp&idOffille=<%=categorie.getIdOrdreTravauxFille()%>" style="margin-right: 10px">Exc&eacute;cuter</a>
                                    <% }else if(categorie.getIdDemandeTravaux()!=null && categorie.getIdTravaux()!=null){ %>
                                    <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien")%>?but=maintenance/travaux/Travaux-fiche.jsp&id=<%=categorie.getIdTravaux()%>" style="margin-right: 10px">Fiche travaux</a>
                                    <% } %>
                            <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

