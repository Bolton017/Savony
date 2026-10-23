<%--
    Document   : point-fiche
    Created on : 22 mars 2024, 09:26:43
    Author     : Angela
--%>

<%@page import="compteur.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    CompteurLib compteur = new CompteurLib();
    compteur.setNomTable("COMPTEURLIB");
    PageConsulte pc = new PageConsulte(compteur, request, u);
    CompteurLib rep=(CompteurLib)pc.getBase();
    pc.setTitre("Fiche d'un compteur");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("ID");
    pc.getChampByName("nombre").setLibelle("Compteur actuel");
    pc.getChampByName("daty").setLibelle("Date de saisie");
    pc.getChampByName("debut").setLibelle("D&eacute;but");
    pc.getChampByName("idFabrication").setLibelle("Id Fabrication");
    pc.getChampByName("idFabricationLib").setLibelle("Fabrication");
    pc.getChampByName("idMachine").setLibelle("Id Machine");
    pc.getChampByName("idMachineLib").setLibelle("Machine");
    pc.getChampByName("idorigine").setLibelle("ID origine");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("etatlib").setVisible(false);

    String lien = (String) session.getValue("lien");
    String classe = "compteur.CompteurLib";
    String pageActuel = "compteur/compteur-fiche.jsp";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href="#"> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
                            <% if (rep.getEtat() == ConstanteEtat.getEtatCreer()) {%>
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute="+pageActuel+"&classe=compteur.Compteur&nomtable=compteur"%>">Viser</a>
                            <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=compteur/compteur-liste.jsp&classe="+classe %>">
                                Supprimer
                            </a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


