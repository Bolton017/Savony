<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="analyse.AnalyseCpl" %>
<%@ page import="constante.ConstanteEtat" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    AnalyseCpl o = new AnalyseCpl();
    o.setNomTable("ANALYSECPL");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'une analyse");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("idfabricationlib").setLibelle("Fabrication");
    pc.getChampByName("idcriterelib").setLibelle("Crit&egrave;re");
    pc.getChampByName("idresponsablelib").setLibelle("Responsable");
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("idfabrication").setLibelle("Id Fabrication");
    pc.getChampByName("idcritere").setLibelle("Id Crit&egrave;re");
    pc.getChampByName("valeur").setLibelle("Valeur");
    pc.getChampByName("idresponsable").setLibelle("Id Responsable");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idcritere").setLien(lien + "?but=critere/critere-fiche.jsp", "id=");
    pc.getChampByName("idfabrication").setLien(lien + "?but=fabrication/fabrication-fiche.jsp", "id=");
    String[] ordre = {"idfabricationlib","idresponsablelib","etatlib","id","daty","idfabrication","idcritere","idcriterelib","valeur","idresponsable"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "analyse/analyse-saisie.jsp&acte=update";
    String pageApresDelete = "analyse/analyse-liste.jsp";
    String classe = "analyse.Analyse";
    o = (AnalyseCpl) pc.getBase();

%>

<div class="content-wrapper">

<h1 class="box-title"><a hrefpi.getFormu().getChamp("idTypeProduit").setDefaut(idCritereProduit);=<%= lien + "?but=" + pageRetour%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

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
                       <% if (o.getEtat() < ConstanteEtat.getEtatValider()) {%>
                        <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                        <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=analyse/analyse-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                         <% }%>
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

