<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="ristourne.*" %>

<%
    try{
        String lien = (String) session.getValue("lien");
        RistourneLib t = new RistourneLib();
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (RistourneLib) pc.getBase();
        String id=pc.getBase().getTuppleID();
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("designation").setLibelle("D&eacute;signation");
        pc.getChampByName("idClientLib").setLibelle("Client");
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("datedebutristourne").setLibelle("Date D&eacute;but Ristourne");
        pc.getChampByName("datefinristourne").setLibelle("Date Fin Ristourne");
        pc.getChampByName("idOrigine").setLibelle("Source");
        pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
        pc.getChampByName("idClient").setVisible(false);
        pc.getChampByName("etat").setVisible(false);

        pc.setTitre("Fiche d'un Ristourne");
        String pageActuel = "ristourne/ristourne-fiche.jsp";

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/ristourne-details", "");

        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/ristourne-details";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
        RistourneLib da=(RistourneLib)pc.getBase();
%>
<div class="content-wrapper">
    <h1 class="box-title"><a href="#"><i class="fa fa-angle-left"></i></a><% out.println(pc.getTitre()); %></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <% if(da.getEtat()<11){ %>
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=ristourne/ristourne-fiche.jsp&classe=ristourne.Ristourne&nomtable=RISTOURNE"%> " style="margin-right: 10px">Valider</a>
                            <% } %>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="<%=map.get("inc/ristourne-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/ristourne-details">D&eacute;tails</a></li>
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