
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="charge.*"%>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    
%>
<%
    ChargeLib devise = new ChargeLib();
    PageConsulte pc = new PageConsulte(devise, request, u);
    pc.setTitre("Fiche de charge");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");  
    pc.getChampByName("libelle").setLibelle("Libell&eacute;");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("pu").setLibelle("Prix");
    pc.getChampByName("qte").setLibelle("Quantit&eacute;");
    pc.getChampByName("type").setLibelle("Type de charge");
    pc.getChampByName("idfabrication").setLibelle("Fabrication associ&eacute;");
    pc.getChampByName("idoffille").setLibelle("Ordre de Fabrication fille associ&eacute;");
    pc.getChampByName("idof").setLibelle("Ordre de Fabrication");
    pc.getChampByName("idingredients").setLibelle("ID Ingr&eacute;dient");
    pc.getChampByName("idfabrication").setAutre("readonly");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    String idfabrication=pc.getChampByName("idfabrication").getValeur();
    String lien = (String) session.getValue("lien");
    pc.getChampByName("idfabrication").setLien(lien+"?but=fabrication/fabrication-fiche.jsp", "id=");
    pc.getChampByName("idoffille").setLien(lien+"?but=fabrication/ordre-fabrication-details-fiche.jsp", "id=");
    pc.getChampByName("idof").setLien(lien+"?but=fabrication/ordre-fabrication-fiche.jsp.jsp", "id=");
    pc.getChampByName("idingredients").setLien(lien+"?but=produits/as-ingredients-fiche.jsp", "id=");
    String pageModif = "fabrication/charge/charge-modif.jsp";
    String bute="fabrication/fabrication-fiche.jsp&id="+idfabrication+"&tab=inc/fabrication-charge";
    String classe = "charge.Charge";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=fabrication/charge/charge-fiche.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
               
    <div class="row">
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
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=fabrication/charge/charge-fiche.jsp&classe=charge.Charge"%> " style="margin-right: 10px">Valider</a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div> 