<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 2025-04-01
  Time: 16:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="fabrication.Of" %>
<%@ page import="utilitaire.Constante" %>
<%@ page import="utils.ConstanteProcess" %>
<%@ page import="oracle.jdbc.driver.Const" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="fabrication.EtudeOf" %>

<%
    try{
        String ismodal = request.getParameter("ismodal");
        EtudeOf t = new EtudeOf();
        t.setNomTable("EtudeOFLIB");
        UserEJB u =(user.UserEJB)session.getValue("u");
        String roleUser = u.getUser().getIdrole();
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (EtudeOf) pc.getBase();
        String id=pc.getBase().getTuppleID();
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("lancepar").setVisible(false);
        pc.getChampByName("cible").setLibelle("Cible");
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("libelle").setLibelle("D&eacute;signation");
        pc.getChampByName("besoin").setLibelle("Date de besoin");
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
        pc.setTitre("Fiche de l'ordre de fabrication");
        String lien = (String) session.getValue("lien");
        String pageModif = "fabrication/EtudeOF-saisie.jsp";
        String pageActuel = "fabrication/EtudeOF-fiche.jsp";
        String classe = "fabrication.EtudeOF";
        String nomTable = "EtudeOF";

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/EtudeOf-details", "");
        map.put("inc/EtudeOf-besoins", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/EtudeOf-details";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
%>
<div class="content-wrapper">
    <h1 class="box-title"><a href="#"><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
                            <% if(t.getEtat()==1){ %>
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute="+pageActuel+"&classe=fabrication.EtudeOf&nomtable=EtudeOF"%> " style="margin-right: 10px">Viser</a>
                            <% } %>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id + "&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageActuel+"&classe="+classe %>" style="margin-right: 10px">Supprimer</a>
                            <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase("11")||pc.getChampByName("etat").getValeur().equalsIgnoreCase(String.valueOf(ConstanteProcess.bloque))) { %>    <%-- VALIDEE --%>
                            <% } %>
                            <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase(String.valueOf(ConstanteProcess.entame))) { %>    <%-- ENTAMMEE --%>
                            <% } %>
                            <% if(t.getEtat()==11){ %>
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=cloturer&id=" + id + "&bute="+pageActuel+"&classe=fabrication.EtudeOf&nomtable=EtudeOf"%> " style="margin-right: 10px">Cl&ocirc;turer</a>
                            <% } %>
                            <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=fiche_ordre_fabrication&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer en PDF</a>
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
                    <!-- a modifier -->
                    <%
                        if (ismodal != null && ismodal.equalsIgnoreCase("true"))
                        {
                    %>
                    <li class="<%=map.get("inc/EtudeOf-besoins")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/ordre-fabrication-besoins&ismodal=true','modalContent')">Besoins</a></li>
                    <%}else {%>
                    <li class="<%=map.get("inc/EtudeOf-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/EtudeOf-details">D&eacute;tails</a></li>
                    <li class="<%=map.get("inc/EtudeOf-besoins")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/EtudeOf-besoins">Besoins</a></li>
                    <% } %>
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


