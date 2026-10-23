<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="ristourne.*" %>
<%@ page import="rapprochement.ReleverLib" %>

<%
    try{
        String lien = (String) session.getValue("lien");
        ReleverLib t = new ReleverLib();
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (ReleverLib) pc.getBase();
        String id=pc.getBase().getTuppleID();
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("idcaisselib").setLibelle("Banque");
        pc.getChampByName("daty").setLibelle("Date (import/saisie)");
        pc.getChampByName("etat").setLibelle("&Eacute;tat");
        pc.getChampByName("etatlib").setVisible(false);
        pc.getChampByName("idcaisse").setVisible(false);
        pc.getChampByName("datyDebut").setLibelle("P&eacute;riode d&eacute;but");
        pc.getChampByName("datyFin").setLibelle("P&eacute;riode fin");

        pc.setTitre("Fiche du relev&eacute;");
        String pageActuel = "rapprochement/fiche-relever.jsp";

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/details-relever", "");

        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/details-relever";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
        String classe = "rapprochement.Relever";
        String pageRetour = "rapprochement/liste-relever.jsp";
         String pageModif = "rapprochement/saisie-relever.jsp";
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
                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageRetour %>" style="margin-right: 10px">Retour</a>

                            <% if(t.getEtat() == 1){ %>
                            <a class="btn btn-primary pull-right"
                               href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=rapprochement/fiche-relever.jsp&classe=" + classe%> "
                               style="margin-right: 10px">valider </a>
                            <a class="btn btn-secondary pull-right"
                               href="<%= lien + "?but="+ pageModif +"&id=" + id+"&acte=update"%>"
                               style="margin-right: 10px">Modifier</a>
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
                    <li class="<%=map.get("inc/details-relever")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/details-relever">D&eacute;tails</a></li>
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

<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>
