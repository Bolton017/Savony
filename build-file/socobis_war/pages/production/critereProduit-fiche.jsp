<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="production.CritereProduitLib" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    CritereProduitLib o = new CritereProduitLib();
    o.setNomTable("CRITEREPRODUITLIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche crit&egrave;re produit");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idcritere").setLibelle("ID Crit&egrave;re");
    pc.getChampByName("idtypeproduit").setLibelle("ID Type produit");
    pc.getChampByName("idcriterelib").setLibelle("Crit&egrave;re");
    pc.getChampByName("idtypeproduitlib").setLibelle("Type produit");
    pc.getChampByName("idcritere").setLien(lien + "?but=critere/critere-fiche.jsp", "id=");
    pc.getChampByName("idTypeProduit").setLien(lien + "?but=produits/typeProduit-fiche.jsp", "id=");

    String[] ordre = {"id","idcriterelib","idtypeproduitlib"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "production/critereProduit-saisie.jsp&acte=update";
    String pageApresDelete = "production/critereProduit-liste.jsp";
    String classe = "production.CritereProduit";

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

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

