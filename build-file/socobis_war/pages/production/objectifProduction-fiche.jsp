<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="production.ObjectifProductionLib" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    ObjectifProductionLib o = new ObjectifProductionLib();
    o.setNomTable("objectifproductionlib");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche objectif du production");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idProduitLib").setLibelle("Produit");
    pc.getChampByName("uniteLib").setLibelle("Unit&egrave;");
    pc.getChampByName("qte").setLibelle("Quantit&egrave;");
    pc.getChampByName("idProduit").setVisible(false);
    pc.getChampByName("unite").setVisible(false);

    String[] ordre = {"id","idProduitLib","uniteLib"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "production/objectifProduction-saisie.jsp&acte=update";
    //String pageApresDelete = "production/critereProduit-liste.jsp";
    String classe = "production.ObjectifProduction";

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

