<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="calculBesoin.CalculBesoinLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    CalculBesoinLib o = new CalculBesoinLib();
    o.setNomTable("CALCULBESOINLIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un calcul de besoin");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("designation").setLibelle("D&eacute;signation");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("idMagasinLib").setLibelle("Magasin");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idMagasin").setVisible(false);

    String[] ordre = {"id","designation","daty","idMagasinLib","etat"};
    pc.setOrdre(ordre);

    String pageActuel = "calculBesoin/calculBesoin-fiche.jsp";
    String pageRetour = ".jsp";
    String pageModif = "calculBesoin/calculBesoin-saisie-multiple.jsp&acte=update";
    String pageApresDelete = "calculBesoin-liste.jsp";
    String classe = "calculBesoin.CalculBesoinLib";

    Map<String, String> map = new HashMap<>();
    map.put("inc/calculBesoin-details-liste", "");
    map.put("inc/calculBesoin-besoins", "");
    map.put("inc/calculBesoin-besoins-qte", "");
    map.put("inc/calculBesoin-besoins-montant", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/calculBesoin-details-liste";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
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
                        <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                    </div>
                    <br/>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="row m-0">
    <div class="col-md-12 nopadding">
        <div class="nav-tabs-custom">
            <ul class="nav nav-tabs">
                <li class="<%=map.get("inc/calculBesoin-details-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/calculBesoin-details-liste">D&eacute;tails</a></li>
                <li class="<%=map.get("inc/calculBesoin-besoins")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/calculBesoin-besoins">Besoins</a></li>
                <li class="<%=map.get("inc/calculBesoin-besoins-qte")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/calculBesoin-besoins-qte">Besoins en quantit&eacute;</a></li>
                <li class="<%=map.get("inc/calculBesoin-besoins-montant")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/calculBesoin-besoins-montant">Besoins en montant</a></li>
            </ul>
            <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
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

