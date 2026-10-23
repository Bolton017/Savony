
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@ page import="maintenance.configuration.Entite" %>
<%@ page import="maintenance.configuration.SousCategorieEntite" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    SousCategorieEntite categorie = new SousCategorieEntite();
    categorie.setNomTable("souscategorieentite_cpl");
    PageConsulte pc = new PageConsulte(categorie, request, u);
    pc.setTitre("Fiche d'une cat&eacute;gorie de maintenance");
    categorie = (SousCategorieEntite) pc.getBase();
    String lien = (String) session.getValue("lien");
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("Libell&eacute;");
    pc.getChampByName("desce").setVisible(false);
    pc.getChampByName("idEntite").setLibelle("Id Entit&eacute;");
    if (categorie.getIdEntite()!=null){
        pc.getChampByName("idEntite").setLien(lien+"maintenance/configuration/entite/entite-fiche.jsp","id=");
    }
    pc.getChampByName("idEntiteLib").setLibelle("Entit&eacute;");
    String pageModif = "maintenance/configuration/souscategorieentite/sous-categorie-entite-saisie.jsp";
    String classe = "maintenance.configuration.SousCategorieEntite";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=maintenance/configuration/souscategorieentite/sous-categorie-entite-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=maintenance/configuration/souscategorieentite/sous-categorie-entite-liste.jsp&classe="+classe %>">Supprimer</a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

