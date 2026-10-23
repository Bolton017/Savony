
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%@ page import="maintenance.configuration.AttributionElementLib" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    AttributionElementLib client = new AttributionElementLib();

    PageConsulte pc = new PageConsulte(client, request, u);
    pc.setTitre("Fiche d'attribution");
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idIngredientMaintenanceLib").setLibelle("Pi&egrave;ce");
    pc.getChampByName("idPersonnelLib").setLibelle("Personnel");
    pc.getChampByName("qualiteObjetMaintenanceLib").setLibelle("Qualité");
    pc.getChampByName("typeAttributionLib").setLibelle("Type d'attribution");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
    pc.getChampByName("idIngredientMaintenance").setVisible(false);
    pc.getChampByName("etatElement").setVisible(false);
    pc.getChampByName("typeAttribution").setVisible(false);
    pc.getChampByName("idPersonnel").setVisible(false);
    pc.getChampByName("etat").setVisible(false);


    String lien = (String) session.getValue("lien");
    String pageModif = "maintenance/configuration/attribution/attribution-saisie.jsp";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=maintenance/configuration/attribution/attribution-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

