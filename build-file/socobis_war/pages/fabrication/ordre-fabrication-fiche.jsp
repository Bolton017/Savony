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

<%
    try{
        String ismodal = request.getParameter("ismodal");
        Of t = new Of();
        t.setNomTable("OFABLIB");
        UserEJB u =(user.UserEJB)session.getValue("u");
        String roleUser = u.getUser().getIdrole();
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (Of) pc.getBase();
        String id=pc.getBase().getTuppleID();
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("lancepar").setLibelle("Atelier");
        pc.getChampByName("cible").setLibelle("Cible");
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("libelle").setLibelle("D&eacute;signation");
        pc.getChampByName("besoin").setLibelle("Date de besoin");
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
        pc.setTitre("Fiche de l'ordre de fabrication");
        String[] ordre = {"id", "daty", "libelle","idBc", "besoin", "lancepar", "cible", "etatLib", "remarque"};
        pc.setOrdre(ordre);
        String lien = (String) session.getValue("lien");
        String pageModif = "fabrication/ordre-fabrication-saisie.jsp";
        String pageActuel = "fabrication/ordre-fabrication-fiche.jsp";
        String classe = "fabrication.Of";
        String nomTable = "OFAB";

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/ordre-fabrication-details", "");
        map.put("inc/disponibilite-matiere", "");
        map.put("inc/liste-fabrication-of", "");
        map.put("inc/ordre-fabrication-historique", "");
        map.put("inc/ordre-fabrication-besoins", "");
        map.put("inc/demande-transfert", "");
        map.put("inc/commentaireOF", "");
        map.put("inc/liste-situation-globale-mere", "");
        map.put("../historique/inc/historique-liste", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/ordre-fabrication-details";
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
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute="+pageActuel+"&classe=fabrication.Of&nomtable=OFAB"%> " style="margin-right: 10px">Viser</a>
                            <% } %>
                            <% if(t.getEtat()!=11) { %>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id + "&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <% } %>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=fabrication/commentaireOF-saisie.jsp&id=" + id %>" style="margin-right: 10px">Commentaire</a>
                            <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageActuel+"&classe="+classe %>" style="margin-right: 10px">Supprimer</a>
                            <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase("11")||pc.getChampByName("etat").getValeur().equalsIgnoreCase(String.valueOf(ConstanteProcess.bloque))) { %>    <%-- VALIDEE --%>
                            <%-- <a href="<%= lien + "?but=process/process-saisie.jsp&id=" + id+"&nomProcess=entamer&objet=fabrication.Of" %>" style="margin-right: 10px"><button class="btn btn-success">(Re)Entamer</button></a> --%>
                            <% } %>
                            <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase(String.valueOf(ConstanteProcess.entame))) { %>    <%-- ENTAMMEE --%>
                            <%-- <a href="<%= lien + "?but=process/process-saisie.jsp&id=" + id+"&nomProcess=bloquer&objet=fabrication.Of" %>" style="margin-right: 10px"><button class="btn btn-warning">Bloquer</button></a> --%>
                            <%-- <a href="<%= lien + "?but=process/process-saisie.jsp&id=" + id+"&nomProcess=terminer&objet=fabrication.Of" %>" style="margin-right: 10px"><button class="btn btn-success">Terminer</button></a> --%>
                            <% } %>
                            <% if(t.getEtat()==11){ %>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=demande/demandetransfert-saisie.jsp&idOf="+id%> " style="margin-right: 10px">Demande</a>
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=cloturer&id=" + id + "&bute="+pageActuel+"&classe=fabrication.Of&nomtable=OFAB"%> " style="margin-right: 10px">Cl&ocirc;turer</a>
                            <% } %>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=fabrication/situation-globale.jsp&id="+id%> " style="margin-right: 10px">Situation globale</a>
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
                    <li class="<%=map.get("inc/ordre-fabrication-details")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&etat=<%= t.getEtat() %>&tab=inc/ordre-fabrication-details&ismodal=true','modalContent')">D&eacute;tails</a></li>
<%--                    <li class="<%=map.get("inc/disponibilite-matiere")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/odisponibilite-matiere&ismodal=true','modalContent')">Disponibilt&eacute; des mati&egrave;res</a></li>--%>
                    <li class="<%=map.get("inc/ordre-fabrication-besoins")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/ordre-fabrication-besoins&ismodal=true','modalContent')">Besoins</a></li>
                    <li class="<%=map.get("inc/fabrication-fabrication")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/fabrication-fabrication&ismodal=true','modalContent')">Fabrications</a></li>
                    <% if(roleUser.compareTo(ConstanteSocobis.CHEFFABR_RANG) == 0 ||roleUser.compareToIgnoreCase("dg")==0) { %>
                        <li class="<%=map.get("inc/ordre-fabrication-rapprochement")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/ordre-fabrication-rapprochement&ismodal=true','modalContent')">Rapprochement</a></li>
                        <li class="<%=map.get("inc/ordre-fabrication-rapprochement-globale")%>" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/ordre-fabrication-rapprochement-globale&ismodal=true','modalContent')"><a href="#">Rapprochement Globale</a></li>
                    <% } %>
<%--                    <li class="<%=map.get("inc/ordre-fabrication-dechet")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/ordre-fabrication-dechet&ismodal=true','modalContent')">D&Eacute;chets</a></li>--%>
<%--                    <li class="<%=map.get("inc/of-residu")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/of-residu&ismodal=true','modalContent')">R&eacute;sidu</a></li>--%>
                    <li class="<%=map.get("inc/of-transfertstock")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/of-transfertstock&ismodal=true','modalContent')">Transfert de stock</li>
                    <li class="<%=map.get("inc/of-demande-transfert")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=fabrication/ordre-fabrication-fiche.jsp&id=<%= id %>&tab=inc/of-demande-transfert&ismodal=true','modalContent')">Demande d'approvisionnement</a></li>
                    <%}else {%>
                    <li class="<%=map.get("inc/ordre-fabrication-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&etat=<%= t.getEtat() %>&tab=inc/ordre-fabrication-details">D&eacute;tails</a></li>
<%--                    <li class="<%=map.get("inc/disponibilite-matiere")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/disponibilite-matiere">Disponibilit&eacute; des mati&egrave;res</a></li>--%>
                    <li class="<%=map.get("inc/ordre-fabrication-besoins")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/ordre-fabrication-besoins">Besoins</a></li>
                    <li class="<%=map.get("inc/fabrication-fabrication")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-fabrication">Fabrications</a></li>
                    <li class="<%=map.get("inc/commentaireOF")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/commentaireOF">Commentaire</a></li>
                    <% if(roleUser.compareTo(ConstanteSocobis.CHEFFABR_RANG) == 0 ||roleUser.compareToIgnoreCase("dg")==0 ) { %>
<%--                        <li class="<%=map.get("inc/ordre-fabrication-rapprochement")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/rentabilite-production">Rentabilit&eacute; Production</a></li>--%>
                        <li class="<%=map.get("inc/ordre-fabrication-rapprochement")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/ordre-fabrication-rapprochement">Rapprochement</a></li>
                        <li class="<%=map.get("inc/ordre-fabrication-rapprochement-globale")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/ordre-fabrication-rapprochement-globale">Rapprochement Globale</a></li>
                    <% } %>
<%--                    <li class="<%=map.get("inc/ordre-fabrication-dechet")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/ordre-fabrication-dechet">D&eacute;chets</a></li>--%>
<%--                    <li class="<%=map.get("inc/of-residu")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/of-residu">R&eacute;sidu</a></li>--%>
                    <%}%>
                    <li class="<%=map.get("inc/of-transfertstock")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/of-transfertstock">Transfert de Stock</a></li>
                    <li class="<%=map.get("inc/disponibilite-stock-of")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&filtreMagasin=<%= t.getLancePar() %>&tab=inc/disponibilite-stock-of">Disponibilit&eacute; stock</a></li>
                    <li class="<%=map.get("inc/of-demande-transfert")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/of-demande-transfert">Demande d'approvisionnement</a></li>
                    <li class="<%=map.get("inc/liste-situation-globale-mere")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-situation-globale-mere">Situation globale</a></li>
                    <li class="<%=map.get("../historique/inc/historique-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=../historique/inc/historique-liste">Historique</a></li>
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


