<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 3/5/25
  Time: 2:43 PM
  To change this template use File | Settings | File Templates.
--%>
<%--
    Document   : page-fiche-simple
    Created on : 9 mars 2023, 10:08:42
    Author     : BICI
--%>

<%@ page import="personnel.Personnel" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
  try{
    Personnel t = new Personnel();
    t.setNomTable("Personnel");
    PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
    String id=pc.getBase().getTuppleID();
    pc.setTitre("Fiche Personnel");
    pc.getChampByName("telephone").setLibelle("T&eacute;l&eacute;phone");
    String lien = (String) session.getValue("lien");
    String pageModif = "personnel/personnel-modif.jsp";
    String classe = "personnel.Personnel";
%>
<div class="content-wrapper">
  <h1 class="box-title"><a href="#"><i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
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
              <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=#&classe="+classe %>">Supprimer</a>
            </div>
            <br/>

          </div>
        </div>
      </div>
    </div>
  </div>
</div>


<%
  } catch (Exception e) {
    e.printStackTrace();
  } %>


