<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@ page import="machine.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    Ligne t = new Ligne();
    t.setNomTable("LIGNE");
    String ismodal = request.getParameter("ismodal");
    PageConsulte pc = new PageConsulte(t, request, u);
    pc.setTitre("Fiche d'une Ligne");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("Nom");
    pc.getChampByName("desce").setLibelle("Description");
    String lien = (String) session.getValue("lien");
    String pageModif = "ligne/ligne-saisie.jsp&acte=update";
    String classe = "machine.Ligne";

    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/machine-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/machine-details";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";

    String pageActuel = "ligne/ligne-fiche.jsp";
%>

<div class="content-wrapper">
        <h1 class="box-title">
            <a href="<%= lien + "?but=ligne/ligne-liste.jsp" %>">
                <i class="fa fa-arrow-circle-left"></i>
            </a>
            <%= pc.getTitre() %>
        </h1>
    <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=ligne/ligne-liste.jsp&classe="+classe %>">Supprimer</a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <% if (ismodal != null && ismodal.equalsIgnoreCase("true")) { %>
                        <li class="<%=map.get("inc/machine-details")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=ligne/ligne-fiche.jsp&id=<%= id %>&tab=inc/machine-details&ismodal=true','modalContent')">Machines</a></li>
                    <% } else { %>
                         <li class="<%=map.get("inc/machine-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/machine-details">Machine</a></li>
                    <% } %>
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
