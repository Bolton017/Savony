<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@page import="paie.log.LogService"%>


<% try {
    UserEJB u = (user.UserEJB)session.getValue("u");

    String nomtable = "LOG_SERVICE_LIB";
    LogService service = new LogService();
    service.setNomTable(nomtable);

    PageConsulte pc = new PageConsulte(service, request, u);
    pc.setTitre("Fiche de service");
    pc.getBase();
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("libelle").setLibelle("Libell&eacute;");
    pc.getChampByName("code_service").setLibelle("Code Service");
    pc.getChampByName("LIBELLEDIRECTION").setLibelle("Direction Rattach&eacute;e");

    pc.getChampByName("code_dr").setVisible(false);
    pc.getChampByName("dr_rattache").setVisible(false);

    String lien = (String) session.getValue("lien");
    String classe = "paie.log.LogService";
    String pageListe = "paie/service/service-liste.jsp";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but="+pageListe+""%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a  class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+ pageListe + "&classe="+classe+"&nomtable=" + nomtable %>" style="margin-right: 10px">Supprimer</a>
                        </div>
                        <br/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<% } catch (Exception e) {
    e.printStackTrace();
}%>
