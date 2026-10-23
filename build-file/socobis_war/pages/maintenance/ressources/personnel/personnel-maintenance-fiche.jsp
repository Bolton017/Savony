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

<%@ page import="maintenance.ressources.PersonnelMaintenanceLib" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    PersonnelMaintenanceLib d = new PersonnelMaintenanceLib();

    PageConsulte pc = new PageConsulte(d, request, u);
    pc.setTitre("Fiche Personnel");
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("nom").setLibelle("Nom et pr&eacute;nom");
    pc.getChampByName("mail").setLibelle("Adresse e-mail");
    pc.getChampByName("idDepartement").setVisible(false);
    pc.getChampByName("idDepartementLib").setLibelle("D&eacute;partement");
    pc.getChampByName("telephone").setLibelle("T&eacute;l&eacute;phone");
    pc.getChampByName("compte").setVisible(false);



    String lien = (String) session.getValue("lien");
    String pageModif = "maintenance/ressources/personnel/personnel-maintenance-saisie.jsp";
    String classe = "maintenance.ressources.PersonnelMaintenance";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=maintenance/ressources/personnel/personnel-maintenance-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
                            <a  class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=maintenance/ressources/personnel/personnel-maintenance-liste.jsp&classe="+classe %>">Supprimer</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

