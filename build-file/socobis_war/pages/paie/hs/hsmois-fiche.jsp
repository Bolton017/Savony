<%--
    Document   : hsmois-fiche
    Created on : 10-12-2025
    Author     : NH
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="paie.hs.HsMois" %>
<%@ page import="paie.hs.HsMoisCpl" %>

<%
    UserEJB u = (user.UserEJB) session.getValue("u");
%>

<%
    HsMoisCpl hs = new HsMoisCpl();
    hs.setNomTable("HSMOIS_CPL");

    PageConsulte pc = new PageConsulte(hs, request, u);
    pc.setTitre("Fiche du calcul d'heure suppl&eacute;mentaire du mois");

    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("ID");
    pc.getChampByName("moisLib").setLibelle("Mois");
    pc.getChampByName("idDepartementLib").setLibelle("D&eacute;partement");
    pc.getChampByName("idCategorieLib").setLibelle("Cat&eacute;gorie");
    pc.getChampByName("idDepartement").setVisible(false);
    pc.getChampByName("idCategorie").setVisible(false);
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("annee").setLibelle("Ann&eacute;e");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("mois").setVisible(false);
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");

    String lien = (String) session.getValue("lien");

    String pageModif = "paie/hs/hsmois-calcul.jsp";
    String classe = "paie.hs.HsMois";
    String pageActuel = "paie/hs/hsmois-fiche.jsp";

//    onglets :
    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/eltpaiehs-details", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/eltpaiehs-details";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";

    HsMois paie = (HsMois) pc.getBase();
    String butefiche = "paie/hs/hsmois-fiche.jsp";

%>

<div class="content-wrapper">
    <h1 class="box-title">
        <a href="<%= lien + "?but=paie/hs/hsmois-liste.jsp" %>">
            <i class="fa fa-arrow-circle-left"></i>
        </a>
        <%=pc.getTitre()%>
    </h1>

    <div class="row m-0">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <% out.println(pc.getHtml()); %>
                        <br/>
                        <div class="box-footer">
                            <% if(paie.getEtat() == 1) {%>
                                <a class="btn btn-secondary pull-right"
                                   href="<%= lien + "?but=" + pageModif + "&id=" + id + "&acte=update" %>"
                                   style="margin-right: 10px">Modifier</a>
                                <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute="+butefiche+"&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                            <% } %>
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
                    <!-- a modifier -->
                    <li class="<%=map.get("inc/eltpaiehs-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/eltpaiehs-details">D&eacute;tails des heures suppl&eacute;mentaires</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idFactureFournisseur" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>


</div>