<%--
    Document   : produit-fiche
    Created on : 21 mars 2024, 09:44:57
    Author     : Angela
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="affichage.*" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    TypeObjet categorie = new TypeObjet();
    categorie.setNomTable("poste");

    PageConsulte pc = new PageConsulte(categorie, request, u);
    pc.setTitre("Fiche du Poste");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("D&eacute;signation");
    pc.getChampByName("desce").setLibelle("Description");
    String lien = (String) session.getValue("lien");
    String pageModif = "annexe/poste/poste-saisie.jsp&acte=update";
    String classe = "bean.TypeObjet";
%>

<div class="content-wrapper">
        <h1 class="box-title"><a href=<%= lien + "?but=annexe/poste/poste-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
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
                            <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=annexe/poste/poste-liste.jsp&classe="+classe %>&nomtable=poste">Supprimer</a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

