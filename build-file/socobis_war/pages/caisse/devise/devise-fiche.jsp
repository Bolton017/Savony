
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="caisse.Devise"%>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    
%>
<%
    Devise devise = new Devise();

    PageConsulte pc = new PageConsulte(devise, request, u);
    pc.setTitre("Fiche Devise");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("D&eacute;signation");
    pc.getChampByName("desce").setLibelle("Description");
    String lien = (String) session.getValue("lien");
    String pageModif = "caisse/devise/devise-modif.jsp";
    String classe = "caisse.Devise";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=caisse/devise/gestion-devise.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=caisse/devise/gestion-devise.jsp&classe="+classe %>">Supprimer</a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

