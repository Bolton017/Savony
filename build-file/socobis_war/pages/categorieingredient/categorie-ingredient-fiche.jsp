<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 03/04/2025
  Time: 15:01
  To change this template use File | Settings | File Templates.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="produits.CategorieIngredient" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    CategorieIngredient client = new CategorieIngredient();

    PageConsulte pc = new PageConsulte(client, request, u);
    pc.setTitre("Fiche Categorie d'ingredient");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("D&eacute;signation");
    pc.getChampByName("desce").setLibelle("Description");
    String lien = (String) session.getValue("lien");
    String pageModif = "categorieingredient/categorie-ingredient-modif.jsp";
    String classe = "produits.CategorieIngredient";
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=categorieingredient/categorie-ingredient-liste.jsp"%>> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=categorieingredient/categorie-ingredient-liste.jsp&classe="+classe+"&nomtable=CATEGORIEINGREDIENT" %>" style="margin-right: 10px"><button class="btn btn-danger">Supprimer</button></a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

