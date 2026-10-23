
<%@page import="caisse.CaisseCpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="constante.ConstanteEtat" %>
<%
		 try{
    UserEJB u = (user.UserEJB)session.getValue("u");
    
%>
<%
   
    CaisseCpl caisse = new CaisseCpl();
    PageConsulte pc = new PageConsulte(caisse, request, u);
    pc.setTitre("Fiche caisse");
    caisse = (CaisseCpl) pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("D&eacute;signation");
    pc.getChampByName("desce").setLibelle("Description");
    pc.getChampByName("idTypeCaisseLib").setLibelle("Type");
    pc.getChampByName("idPointLib").setLibelle("Point");
    pc.getChampByName("idCategorieCaisseLib").setLibelle("Cat&eacute;gorie");
    pc.getChampByName("idMagasinLib").setLibelle("Magasin"); 
    pc.getChampByName("etat").setLibelle("&Eacute;tat"); 
    pc.getChampByName("IdPoint").setVisible(false);
    pc.getChampByName("IdMagasin").setVisible(false);
    pc.getChampByName("IdTypeCaisse").setVisible(false);
    pc.getChampByName("idCategorieCaisse").setVisible(false);
    pc.getChampByName("etatLib").setVisible(false);

    pc.getChampByName("idDevise").setVisible(false);
    pc.getChampByName("idDeviseLib").setLibelle("Devise");

    String lien = (String) session.getValue("lien");
    String pageModif = "caisse/caisse-saisie.jsp";
    String classe = "caisse.Caisse";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=caisse/caisse-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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

                            <% if(caisse.getEtat() < ConstanteEtat.getEtatValider()) { %>
                              <a  class="btn btn-danger pull-left"  href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annuler&bute=caisse/caisse-fiche.jsp&classe="+classe %>">Annuler</a>
                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=caisse/caisse-fiche.jsp&classe=" + classe %> ">Viser</a>
                                 <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id +"&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <% } %>
                            <% if(caisse.getEtat()== 11) { %>
                                <a class="pull-left btn btn-danger"  href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=annulerVisa&id=" + request.getParameter("id") + "&bute=caisse/caisse-fiche.jsp&classe=" + classe %>">Annuler Visa</a>
                            <% } %>
                        </div>
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
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
		history.back();</script>

<% }%>