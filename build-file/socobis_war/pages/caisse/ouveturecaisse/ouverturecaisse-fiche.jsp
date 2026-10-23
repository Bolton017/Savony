
<%@page import="caisse.ReportCaisseCpl"%>
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
    ReportCaisseCpl caisse = new ReportCaisseCpl();
    caisse.setNomTable("ouverturecaisse_cpl");
    PageConsulte pc = new PageConsulte(caisse, request, u);
    pc.setTitre("Fiche report caisse");
    caisse=(ReportCaisseCpl) pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("idCaisseLib").setLibelle("Caisse");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("typeReportLib").setLibelle("Type report");
    pc.getChampByName("IdCaisse").setVisible(false);
    pc.getChampByName("typeReport").setVisible(false);
    pc.getChampByName("EtatLib").setVisible(false);
    pc.getChampByName("MontantTheorique").setLibelle("Montant th&eacute;orique");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    String lien = (String) session.getValue("lien");
    String pageModif = "caisse/report/reportCaisse-saisie.jsp";
    String classe = "caisse.ReportCaisse";
    Map<String, String> map = new HashMap<String, String>();

    String pageActuel ="caisse/report/reportCaisse-fiche.jsp";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=caisse/ouveturecaisse/ouverturecaisse-saisie.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <% if(caisse.getEtat() < ConstanteEtat.getEtatValider()) { %>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=caisse/ouveturecaisse/ouverturecaisse-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                            <% } %>
                             <% if(caisse.getEtat()== 11) { %>
                                <a class="pull-left btn btn-danger"  href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=annulerVisa&id=" + request.getParameter("id") + "&bute=caisse/ouveturecaisse/ouverturecaisse-fiche.jsp&classe=" + classe %>">Annuler Visa</a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

