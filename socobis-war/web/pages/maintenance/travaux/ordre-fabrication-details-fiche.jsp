<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="fabrication.OfFilleCpl" %>
<%@ page import="maintenance.travaux.OrdreTravauxFilleCpl" %>
<%
    try{
        UserEJB u =(user.UserEJB)session.getValue("u");
        String roleUser = u.getUser().getIdrole();
        String ismodal = request.getParameter("ismodal");
        String lien = (String) session.getValue("lien");
        OrdreTravauxFilleCpl t = new OrdreTravauxFilleCpl();
        t.setNomTable("OTRAVFILLERESTELIB");
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (OrdreTravauxFilleCpl) pc.getBase();
        String id=pc.getBase().getTuppleID();
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("libelle").setLibelle("Libell&eacute; de l'ordre de travaux");
        pc.getChampByName("libelleexacte").setLibelle("Machine");
        pc.getChampByName("qte").setLibelle("Quantit&eacute;");
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("idingredients").setVisible(false);
        pc.getChampByName("datybesoin").setVisible(false);
        pc.getChampByName("idunite").setVisible(false);
        pc.getChampByName("qtefabrique").setVisible(false);
        pc.getChampByName("qtereste").setVisible(false);
        pc.getChampByName("idmere").setLien(lien+"?but=fabrication/ordre-fabrication-fiche.jsp", "id=");
        pc.setTitre("Fiche d'un d&eacute;tail d'ordre de travaux");

        // String pageModif = "fabrication/ordre-fabrication-details-modif.jsp";
        String pageActuel = "maintenance/travaux/ordre-fabrication-details-fiche.jsp";
        String classe = "fabrication.OfFilleCpl";
        String nomTable = "OFFILLE";
        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/liste-fabrication-of", "");
        map.put("inc/ordre-fabrication-historique", "");
        map.put("inc/ordre-fabrication-besoins", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/liste-fabrication-of";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
        OfFilleCpl base=(OfFilleCpl)pc.getBase();
//        pc.setModalOnClick(true);
    %>
    <div class="content-wrapper">
    <h1 class="box-title"><a href="#"><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6 mb-5 nopadding">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <%-- <a class="btn btn-warning pull-left"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a> --%>
                            <%-- <a href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageActuel+"&classe="+classe %>" style="margin-right: 10px"><button class="btn btn-danger">Supprimer</button></a> --%>

                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=maintenance/travaux/Travaux-saisie.jsp&idOffille=" + id %>&designation=fabrication de <%=base.getLibelleexacte()%> " style="margin-right: 10px">Exevuter</a>
<%--                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=travaux/offille-situation-globale.jsp&id=" + id %>&designation=fabrication de <%=base.getLibelleexacte()%> " style="margin-right: 10px">Situation globale</a>--%>

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
                    <%
                        if (ismodal != null && ismodal.equalsIgnoreCase("true"))
                        {
                    %>
                        <li class="<%=map.get("inc/liste-fabrication-of")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-fabrication-of&ismodal=true', 'modalContent')">D&eacute;tails</a></li>
                    <%}else { %>
                        <li class="<%=map.get("inc/liste-fabrication-of")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-fabrication-of">D&eacute;tails</a></li>

                    <%} %>
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
<%=pc.getModalHtml("modalContent")%>
<%
   } catch (Exception e) {
       e.printStackTrace();
   } %>




