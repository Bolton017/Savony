<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="rapport.mapping.CRContentLib" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    CRContentLib crContent = new CRContentLib();
    PageConsulte pc = new PageConsulte(crContent, request, u);
    pc.setTitre("Fiche de Contenus");
    String id=pc.getBase().getTuppleID();

    String pageActuel = "rapport/configuration/cr/contenus/config-contenus-fiche.jsp";

    String lien = (String) session.getValue("lien");
    String pageModif = "rapport/configuration/cr/contenus/config-contenus.jsp";
    pc.getChampByName("graphe").setVisible(false);
    pc.getChampByName("grapheLib").setLibelle("Graphique");

    Map<String, String> map = new HashMap<String, String>();
    map.put("config-contenus-fille", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "config-contenus-fille";
    }
    map.put(tab, "active");
    tab = "inc/" + tab + ".jsp";
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but="%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id+"&acte=update"%>" style="margin-right: 10px">Modifier</a>
<%--                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annuler&bute=inventaire/inventaire-liste.jsp&classe="+classe%>"><button class="btn btn-danger">Annuler</button></a>--%>
                        </div>
                        <br/>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="<%=map.get(tab)%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=<%= tab%>">D&eacute;tails</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>
        </div>
    </div>
</div>