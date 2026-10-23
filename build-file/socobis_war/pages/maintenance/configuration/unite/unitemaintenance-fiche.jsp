<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="maintenance.configuration.UniteMaintenance" %>
<%  try {
    UserEJB u = (user.UserEJB)session.getValue("u");
    UniteMaintenance o = new UniteMaintenance();
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'unit&eacute; de maintenance");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("echelle").setLibelle("&Eacute;chelle");
    pc.getChampByName("val").setLibelle("Libell&eacute;");
    pc.getChampByName("desce").setLibelle("Designation");

    String lien = (String) session.getValue("lien");
    String pageModif = "maintenance/configuration/unite/unitemaintenance-saisie.jsp";
    String classe = "maintenance.configuration.UniteMaintenance";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=pompe/pompe-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id+ "&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <a  class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=maintenance/configuration/unite/unitemaintenance-liste.jsp&classe="+classe %>">Supprimer</a>
                        </div>
                    </div>
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


