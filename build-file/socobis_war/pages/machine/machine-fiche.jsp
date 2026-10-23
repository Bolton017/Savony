<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 20/08/2025
  Time: 10:32
  To change this template use File | Settings | File Templates.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="machine.Machine" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    Machine t = new Machine();
    t.setNomTable("MACHINE");

    PageConsulte pc = new PageConsulte(t, request, u);
    pc.setTitre("Fiche Machine");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("Nom");
    pc.getChampByName("desce").setLibelle("Description");
    pc.getChampByName("idLigne").setLibelle("Ligne");
    String lien = (String) session.getValue("lien");
    String pageModif = "machine/machine-saisie.jsp&acte=update";
    String classe = "machine.Machine";
    Map<String, String> map = new HashMap<>();
    map.put("inc/elementInspectionMachine-machine", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/elementInspectionMachine-machine";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    String pageActuel = "machine/machine-fiche.jsp";

%>
%>

<div class="content-wrapper">
        <h1 class="box-title"><a href=<%= lien + "?but=machine/machine-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
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
                            <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=machine/machine-liste.jsp&classe="+classe %>">Supprimer</a>
                            <a class="btn btn-secondary pull-right"
                               href="<%= lien + "?but=machine/elementInspectionMachine-saisie.jsp&idMachine=" + id%>"
                               style="margin-right:10px;">Ajout composant </a>
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
                    <li class="<%=map.get("inc/elementInspectionMachine-machine")%>"><a
                            href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/elementInspectionMachine-machine">&Eacutel&eacutement inspect&eacute;</a>
                    </li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>">
                        <jsp:param name="id" value="<%= id %>"/>
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
</div>
