<%-- 
    Document   : page-fiche-simple
    Created on : 9 mars 2023, 10:08:42
    Author     : BICI
--%>

<%@page import="mg.cnaps.compta.*"%>
<%@ page import="rapprochement.ReleverDetail" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="constante.ConstanteEtat" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
    try{
    ReleverDetail compta = new ReleverDetail();
    compta.setNomTable("ReleverDetailOrder");
    PageConsulte pc = new PageConsulte(compta, request, (user.UserEJB) session.getValue("u"));
    String id=pc.getBase().getTuppleID();
    ReleverDetail rep=(ReleverDetail)pc.getBase();
    pc.setTitre("Fiche Relever detail");
    String lien = (String) session.getValue("lien");
    pc.getChampByName("idMere").setLien(lien+"?but=rapprochement/fiche-relever.jsp", "id=");
    pc.getChampByName("idMere").setLibelle("Relev&eacute;");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("datyvaleur").setVisible(false);
    pc.getChampByName("debit").setLibelle("D&eacute;bit");
    pc.getChampByName("credit").setLibelle("Cr&eacute;dit");
    pc.getChampByName("designation").setLibelle("D&eacute;signation");


%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%= pc.getHtml() %>
                        <br/>
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


