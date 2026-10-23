
<%@page import="facture.ReferenceFacture"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");
%>
<%
    ReferenceFacture  rf = new ReferenceFacture();
    rf.setNomTable("REFERENCEFACTURE");
    String idFacture = null;

    PageConsulte pc = new PageConsulte(rf, request, u);
    pc.setTitre("Fiche de r&eacute;f&eacute;rence de facture");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idfacture").setLibelle("Facture");
    String type = request.getParameter("type");
    String href = "";
    if(type != null && !type.isEmpty()) {
        if(type.compareToIgnoreCase("facture") == 0){
            href = lien + "?but=facturefournisseur/facturefournisseur-fiche.jsp";
        }
        if(type.compareToIgnoreCase("vente") == 0){
            href = lien + "?but=vente/vente-fiche.jsp";
        }
        pc.getChampByName("idfacture").setLien(href, "id=");
    }
    
    //pc.getChampByName("idfacture").setLien(lien+"?but=vente/vente-fiche.jsp", "id=");
    pc.getChampByName("reference").setLibelle("R&eacute;f&eacute;rence");
    String pageModif = "facture/reference-facture-modif.jsp";
    String classe = "facture.ReferenceFacture";
%>

<div class="content-wrapper">
    <h1 class="box-title">
        <!--<a href=<%= lien + "?but=vente/vente-fiche.jsp?id="+pc.getChampByName("idfacture").getValeur()%>> <i class="fa fa-angle-left"></i></a>-----><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">

                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
<%--                        <div class="box-footer">--%>
<%--                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>--%>
<%--                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=facture/reference-facture-liste.jsp&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>--%>
<%--                        </div>--%>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

