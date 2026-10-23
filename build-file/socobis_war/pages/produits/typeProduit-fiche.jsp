<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.TypeProduit" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    TypeProduit t = new TypeProduit();
    t.setNomTable("TYPEPRODUIT");
    String ismodal = request.getParameter("ismodal");
    PageConsulte pc = new PageConsulte(t, request, u);
    pc.setTitre("Fiche d'un Type de Produit");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("Nom");
    pc.getChampByName("desce").setLibelle("Description");
    String lien = (String) session.getValue("lien");
    String pageModif = "produits/typeProduit-saisie.jsp&acte=update";
    String pageCritereProduit = "production/critereProduit-saisie.jsp";
    String classe = "produits.TypeProduit";


    String pageActuel = "produits/typeProduit-fiche.jsp";
        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/critere", ""); 

        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/critere";
        } 
        map.put(tab, "active");
        tab = tab + ".jsp";
%>

<div class="content-wrapper">
        <h1 class="box-title">
            <a href="<%= lien + "?but=produits/typeProduit-liste.jsp" %>">
                <i class="fa fa-arrow-circle-left"></i>
            </a>
            <%= pc.getTitre() %>
        </h1>
    <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=produits/typeProduit-liste.jsp&classe="+classe %>">Supprimer</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageCritereProduit +"&id=" + id%>" style="margin-right: 10px"> Ajouter crit&egrave;re</a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
        <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("inc/critere")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/critere">Crit&egrave;res</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idpersonnel" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>
        </div>
    </div>
</div>
