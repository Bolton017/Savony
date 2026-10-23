
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@ page import="maintenance.configuration.Situation" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    Situation categorie = new Situation();
    PageConsulte pc = new PageConsulte(categorie, request, u);
    pc.setTitre("Fiche d'une situation");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("Libell&eacute;");
    pc.getChampByName("desce").setLibelle("Description");
    String lien = (String) session.getValue("lien");
    String pageModif = "maintenance/configuration/situation/situation-saisie.jsp&acte=update";
    String classe = "maintenance.configuration.Situation";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=maintenance/configuration/situation/situation-liste.jsp"%> ><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=maintenance/configuration/situation/situation-liste.jsp&classe="+classe %>">Supprimer</a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

