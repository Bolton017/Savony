<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="utils.ConstanteProcess" %>
<%@ page import="maintenance.travaux.OrdreTravaux" %>

<%
    try{
        String ismodal = request.getParameter("ismodal");
        OrdreTravaux t = new OrdreTravaux();
        t.setNomTable("OTRAVLIB");
        UserEJB u =(user.UserEJB)session.getValue("u");
        String roleUser = u.getUser().getIdrole();
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (OrdreTravaux) pc.getBase();
        String id=pc.getBase().getTuppleID();
        String lien = (String) session.getValue("lien");
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("lancepar").setLibelle("Entit&eacute;");
        pc.getChampByName("cible").setLibelle("Cible");
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("libelle").setLibelle("D&eacute;signation");
        pc.getChampByName("besoin").setLibelle("Date de besoin");
        pc.getChampByName("daty").setLibelle("Date de la demande");
        pc.getChampByName("etatLib").setVisible(false);
        pc.getChampByName("cible").setVisible(false);
        pc.getChampByName("etat").setLibelle("&Eacute;tat");
        pc.getChampByName("IdBc").setLibelle("Id Demande de travaux");
        if (t.getIdBc()!=null){
            pc.getChampByName("IdBc").setLien(lien+"?but=maintenance/demandetravaux/demandetravaux-fiche.jsp","id=");
        }
        pc.getChampByName("idBc").setLibelle("ID de la demande de travaux");

        pc.setTitre("Fiche de l'ordre de travaux");
        String pageModif = "maintenance/travaux/Otravaux-saisie.jsp";
        String pageActuel = "maintenance/travaux/Otravaux-fiche.jsp";
        String classe = "maintenance.travaux.OrdreTravaux";
        String nomTable = "OFAB";

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/ordre-fabrication-details", "");
        map.put("inc/liste-fabrication-of", "");
        map.put("inc/ordre-fabrication-historique", "");
        map.put("inc/ordre-fabrication-besoins", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/ordre-fabrication-details";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
%>
<div class="content-wrapper">
    <h1 class="box-title"><a href="<%=lien%>?but=maintenance/travaux/Otravaux-liste.jsp"><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute="+pageActuel+"&classe=maintenance.travaux.OrdreTravaux&nomtable=OrdreTravaux"%> " style="margin-right: 10px">Viser</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id + "&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-warning pull-right" href="<%= lien + "?but=maintenance/travaux/resultat-maintenance-saisie.jsp&idOrdreTravaux=" + id%>" style="margin-right: 10px">Resultat du maintenance </a>
                            <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageActuel+"&classe="+classe %>" style="margin-right: 10px">Supprimer</a>
                            <% } %>
                            <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase("11")||pc.getChampByName("etat").getValeur().equalsIgnoreCase(String.valueOf(ConstanteProcess.bloque))) { %>    <%-- VALIDEE --%>
                            <%-- <a href="<%= lien + "?but=process/process-saisie.jsp&id=" + id+"&nomProcess=entamer&objet=fabrication.Of" %>" style="margin-right: 10px"><button class="btn btn-success">(Re)Entamer</button></a> --%>
                            <% } %>
                            <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase(String.valueOf(ConstanteProcess.entame))) { %>    <%-- ENTAMMEE --%>
                            <%-- <a href="<%= lien + "?but=process/process-saisie.jsp&id=" + id+"&nomProcess=bloquer&objet=fabrication.Of" %>" style="margin-right: 10px"><button class="btn btn-warning">Bloquer</button></a> --%>
                            <%-- <a href="<%= lien + "?but=process/process-saisie.jsp&id=" + id+"&nomProcess=terminer&objet=fabrication.Of" %>" style="margin-right: 10px"><button class="btn btn-success">Terminer</button></a> --%>
                            <% } %>
                            <% if(t.getEtat()==11){ %>
<%--                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=demande/demandetransfert-saisie.jsp&idOf="+id%> " style="margin-right: 10px">Demande</a>--%>
                            <% } %>
<%--                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=fabrication/situation-globale.jsp&id="+id%> " style="margin-right: 10px">Situation globale</a>--%>
<%--                            <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=fiche_ordre_fabrication&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer en PDF</a>--%>
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
                    <li class="<%=map.get("inc/ordre-fabrication-details")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/ordre-fabrication-details&ismodal=true','modalContent')">D&eacute;tails</a></li>
<%--                    <li class="<%=map.get("inc/ordre-fabrication-besoins")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/ordre-fabrication-besoins&ismodal=true','modalContent')">Besoins</a></li>--%>
                    <li class="<%=map.get("inc/fabrication-fabrication")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/fabrication-fabrication&ismodal=true','modalContent')">Travaux</a></li>

<%--                    <li class="<%=map.get("inc/ordre-fabrication-dechet")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/ordre-fabrication-dechet&ismodal=true','modalContent')">D&Eacute;chets</a></li>--%>
<%--                    <li class="<%=map.get("inc/of-residu")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/of-residu&ismodal=true','modalContent')">R&eacute;sidu</a></li>--%>
<%--                    <li class="<%=map.get("inc/of-transfertstock")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/of-transfertstock&ismodal=true','modalContent')">Transfert de stock</li>--%>
<%--                    <li class="<%=map.get("inc/of-demande-transfert")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/of-demande-transfert&ismodal=true','modalContent')">Demande de transfert</a></li>--%>
                    <%}else {%>
                    <li class="<%=map.get("inc/ordre-fabrication-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/ordre-fabrication-details">D&eacute;tails</a></li>
<%--                    <li class="<%=map.get("inc/ordre-fabrication-besoins")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/ordre-fabrication-besoins">Besoins</a></li>--%>
                    <li class="<%=map.get("inc/fabrication-fabrication")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-fabrication">Travaux</a></li>
<%--                    <li class="<%=map.get("inc/ordre-fabrication-dechet")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/ordre-fabrication-dechet">D&eacute;chets</a></li>--%>
<%--                    <li class="<%=map.get("inc/of-residu")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/of-residu">R&eacute;sidu</a></li>--%>
                    <%}%>
<%--                    <li class="<%=map.get("inc/of-transfertstock")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/of-transfertstock">Transfert de Stock</a></li>--%>
<%--                    <li class="<%=map.get("inc/of-demande-transfert")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/of-demande-transfert">Demande de transfert</a></li>--%>
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


