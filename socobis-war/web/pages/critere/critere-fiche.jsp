<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.Critere" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    Critere t = new Critere();
    t.setNomTable("CRITERE");
    String ismodal = request.getParameter("ismodal");
    PageConsulte pc = new PageConsulte(t, request, u);
    pc.setTitre("Fiche d'un Critère");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("Nom");
    pc.getChampByName("desce").setLibelle("Description");
    String lien = (String) session.getValue("lien");
    String pageModif = "critere/critere-saisie.jsp&acte=update";
    String classe = "produits.Critere";


    String pageActuel = "critere/critere-fiche.jsp";
%>

<div class="content-wrapper">
        <h1 class="box-title">
            <a href="<%= lien + "?but=critere/critere-liste.jsp" %>">
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
                            <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=critere/critere-liste.jsp&classe="+classe %>">Supprimer</a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
