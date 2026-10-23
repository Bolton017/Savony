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
<%@ page import="maintenance.ressources.DepartementMaintenance" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    DepartementMaintenance d = new DepartementMaintenance();

    PageConsulte pc = new PageConsulte(d, request, u);
    pc.setTitre("Fiche D&eacute;partement");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("D&eacute;partement");
    pc.getChampByName("desce").setLibelle("Description");

    String lien = (String) session.getValue("lien");
    String pageModif = "maintenance/ressources/personnel/departement-saisie.jsp";
    String classe = "maintenance.ressources.DepartementMaintenance";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=maintenance/ressources/personnel/departement-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
                            <a  class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=maintenance/ressources/personnel/departement-liste.jsp&classe="+classe %>">Supprimer</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

