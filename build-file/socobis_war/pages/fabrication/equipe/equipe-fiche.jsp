<%@page import="annexe.CategorieLib"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="fabrication.equipe.Equipe" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    Equipe categorie = new Equipe();
    categorie.setNomTable("equipe");

    PageConsulte pc = new PageConsulte(categorie, request, u);
    pc.setTitre("Fiche &Eacute;quipe");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("Nom &Eacute;quipe");
    pc.getChampByName("desce").setLibelle("Description");
    String lien = (String) session.getValue("lien");
    String pageModif = "fabrication/equipe/equipe-saisie.jsp&acte=update";
    String pageEquipeEmpSaisie = "fabrication/equipe/compositionEquipe-saisie.jsp&acte=update";

    String classe = "fabrication.equipe.Equipe";
    String pageActuel = "fabrication/equipe/equipe.jsp";

    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/composition-equipe", "");
    map.put("inc/equipe-employe-liste", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/composition-equipe";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=fabrication/equipe/equipe-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-primary pull-right"  href="<%= lien + "?but="+ pageEquipeEmpSaisie +"&id=" + id%>" style="margin-right: 10px">Modifier la composition</a>
                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=fabrication/equipe/equipe-liste.jsp&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
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
                    <li class="<%=map.get("inc/equipe-emp-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/equipe-emp-liste">Personnels</a></li>
                    <li class="<%=map.get("inc/composition-equipe")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/composition-equipe">Composition d'&eacute;quipe</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
</div>

