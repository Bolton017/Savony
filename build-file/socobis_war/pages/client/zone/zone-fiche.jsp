<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="client.ZoneClient" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    ZoneClient o = new ZoneClient();
    o.setNomTable("ZONECLIENT");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche de la zone de livraison");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("Libell&eacute;");
    pc.getChampByName("desce").setLibelle("Description");
    pc.getChampByName("forfait").setLibelle("Frais de livraison");
    pc.getChampByName("prixcarton").setLibelle("Prix par carton");
    pc.getChampByName("mincarton").setLibelle("Carton minimal");

    String[] ordre = {"id","val","desce","forfait","prixcarton","mincarton"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "client/zone/zone-saisie.jsp&acte=update";
    String pageApresDelete = "client/zone/zone-liste.jsp";
    String classe = "client.ZoneClient";

%>

<div class="content-wrapper">

<h1 class="box-title"><a href=<%= lien + "?but=" + pageRetour%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

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
                        <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
<%--                        <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>--%>
                    </div>
                    <br/>
                </div>
            </div>
        </div>
    </div>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

