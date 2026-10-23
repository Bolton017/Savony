<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="magasin.DirectionMagasinLib" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    DirectionMagasinLib o = new DirectionMagasinLib();
    o.setNomTable("DIRECTIONMAGASINLIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Departement d'une magasin");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idMagasinLib").setLibelle("Magasin");
    pc.getChampByName("idDirectionLib").setLibelle("Direction");
    pc.getChampByName("idMagasin").setVisible(false);
    pc.getChampByName("idDirection").setVisible(false);

    String[] ordre = {"id","idMagasinLib","idDirectionLib"};
    pc.setOrdre(ordre);

    String pageRetour = "magasin/directionMagasin-liste.jsp";
    String pageModif = "magasin/directionMagasin-saisie.jsp&acte=update";
    String pageApresDelete = "magasin/directionMagasin-liste.jsp";
    String classe = "magasin.DirectionMagasinLib";

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
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>
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

