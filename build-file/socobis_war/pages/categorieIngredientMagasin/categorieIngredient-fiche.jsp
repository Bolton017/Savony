<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="magasin.CategorieIngredientMagasinLib" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    CategorieIngredientMagasinLib o = new CategorieIngredientMagasinLib();
    o.setNomTable("V_CATEGORIEINGREDIENTMAGLIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idMagasinLib").setLibelle("Magasin");
    pc.getChampByName("idCategorieIngredientLib").setLibelle("Cat&eacute;gorie d'ingr&eacute;dient");
    pc.getChampByName("idMagasin").setVisible(false);
    pc.getChampByName("idCategorieIngredient").setVisible(false);

    String[] ordre = {"id","idMagasinLib","idCategorieIngredientLib"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "categorieIngredientMagasin/categorieIngredient-saisie.jsp&acte=update";
    String pageApresDelete = "categorieIngredientMagasin/categorieIngredient-liste.jsp";
    String classe = "magasin.CategorieIngredientMagasinLib";

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
                        <a class="btn btn-primary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a  class=" btn btn-secondary pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe + "&nomtable=CATEGORIEINGREDIENTMAGASIN" %>">Supprimer</a>
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

