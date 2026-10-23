<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@ page import="rapport.mapping.MailRapport" %>


<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%

    MailRapport objet = new MailRapport();
    PageConsulte pc = new PageConsulte(objet, request, u);
    pc.setTitre("Fiche Destinataire/Cc");
    pc.getChampByName("val").setLibelle("E-Mail");
    pc.getChampByName("desce").setLibelle("Description");

    String id = request.getParameter("id");
    String lien = (String) session.getValue("lien");

    String classe = "rapport.mapping.MailRapport";
    String bute = "rapport/configuration/mailrapport/mailrapport-liste.jsp";


%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but="+bute%> ><i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-warning pull-right"  href="<%=(String) session.getValue("lien") + "?but=rapport/configuration/mailrapport/mailrapport-saisie.jsp&id=" + id+"&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-danger pull-right"  href="<%=(String) session.getValue("lien") + "?but=apresTarif.jsp&id=" + id%>&acte=delete&bute=<%= bute %>&classe=<%= classe %>" style="margin-right: 10px">Supprimer</a>
                        </div>
                        <br/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>