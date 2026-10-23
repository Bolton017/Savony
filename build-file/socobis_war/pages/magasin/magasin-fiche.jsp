<%@page import="magasin.Magasin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    
%>
<%
try{
    Magasin unite = new Magasin();
    unite.setNomTable("magasinlib");
    PageConsulte pc = new PageConsulte(unite, request, u);
    pc.setTitre("Fiche Magasin");
    pc.getBase();
    Magasin magasin = (Magasin)pc.getBase();
    String id = magasin.getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("Libell&eacute;");
    pc.getChampByName("desce").setLibelle("Description");
    pc.getChampByName("idPointlib").setLibelle("Point");
    pc.getChampByName("idTypeMagasinlib").setLibelle("Type magasin");
    pc.getChampByName("idMagasinMereLib").setLibelle("Magasin d'origine");
    pc.getChampByName("idDepartementLib").setLibelle("D&eacute;partement");
    String lienModif = "&acte=update";

    pc.getChampByName("idDepartement").setVisible(false);
    pc.getChampByName("idPoint").setVisible(false);
    pc.getChampByName("idTypeMagasin").setVisible(false);
    String lien = (String) session.getValue("lien");
    String pageModif = "magasin/magasin-saisie.jsp"+lienModif;
    String classe = "magasin.Magasin";
    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/categorieIngredient", "");
    map.put("inc/directionMagasin", "");

    String pageActuel = "magasin/magasin-fiche.jsp";
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/categorieIngredient";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=magasin/magasin-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=categorieIngredientMagasin/categorieIngredient-saisie.jsp&id=" + id%>" style="margin-right: 10px">Ajouter cat&eacute;gorie</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=magasin/directionMagasin-saisie.jsp&id=" + id%>" style="margin-right: 10px">Ajouter direction</a>
                            <a  class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=magasin/magasin-liste.jsp&classe="+classe %>">Supprimer</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row m-0" style="margin-top: 25px">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="<%=map.get("inc/categorieIngredient")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/categorieIngredient">Cat&eacute;gorie d'ingredient</a></li>
                    <li class="<%=map.get("inc/directionMagasin")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/directionMagasin">Directions</a></li>
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

<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>
