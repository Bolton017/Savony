<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="fabrication.*" %>
<%@ page import="utilitaire.Constante" %>
<%@ page import="utils.ConstanteProcess" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="constante.ConstanteEtat" %>

<%
    try{
        UserEJB u =(user.UserEJB)session.getValue("u");
        String ismodal = request.getParameter("ismodal");
        String lien = (String) session.getValue("lien");
        FabricationCpl t = new FabricationCpl();
        t.setNomTable("FabricationCpl");
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (FabricationCpl) pc.getBase();
        String id=pc.getBase().getTuppleID( );

        HeureSupFabrication[] hfille = null;
        if(id!=null && !id.isEmpty()){
            hfille = t.genererHeureSup(null);
        }

        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("lanceparLib").setLibelle("Lanc&eacute;e par");
        pc.getChampByName("lancepar").setVisible(false);
        pc.getChampByName("cibleLib").setLibelle("Cible");
        pc.getChampByName("cibleLib").setVisible(false);
        pc.getChampByName("cible").setVisible(false);
        pc.getChampByName("remarque").setLibelle("Titre");
        pc.getChampByName("libelle").setLibelle("Description");
        pc.getChampByName("besoin").setLibelle("Date de besoin");
        pc.getChampByName("besoin").setVisible(false);
        pc.getChampByName("FABRICATIONPREC").setLibelle("Fabrication pr&eacute;c&eacute;dente ");
        pc.getChampByName("FABRICATIONPREC").setVisible(false);
        pc.getChampByName("fabricationSuiv").setLibelle("Fabrication Suivant ");
        pc.getChampByName("fabricationSuiv").setVisible(false);
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("idOffille").setLien(lien+"?but=fabrication/ordre-fabrication-details-fiche.jsp", "id=");
        pc.getChampByName("idOffille").setVisible(false);
        pc.getChampByName("idOffille").setLibelle("Ordre de fabrication fille associ&eacute;");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("etatlib").setLibelle("&Eacute;TAT");
        pc.getChampByName("etatlib").setVisible(false);
        pc.getChampByName("idOf").setLibelle("Ordre de fabrication associ&eacute;");
        pc.getChampByName("idOf").setVisible(false);
        pc.getChampByName("idOf").setLien(lien+"?but=fabrication/ordre-fabrication-fiche.jsp", "id=");
        pc.setTitre("Fiche de Fabrication");
        String pageModif = "fabrication/fabrication-saisie.jsp";
        String pageActuel = "fabrication/projet-fiche.jsp";
        String pageActuelListe = "fabrication/fabrication-liste.jsp";
        String classe = "fabrication.Fabrication";

        Map<String, String> map = new HashMap<String, String>();
        map.put("../fabrication/inc/fabrication-details", "");
        map.put("../historique/inc/historique-liste", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "../fabrication/inc/fabrication-details";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
        pc.setModalOnClick(true);
%>
<style>
    .btn-group-container .btn:first-child, .box-footer .btn:first-child {
        margin-right: var(--Bases-4-space-2) !important;
    }
    .btn{
        margin-bottom: var(--Bases-4-space-2) !important;
    }

</style>
<div class="content-wrapper">
    <h1 class="box-title"><a href="<%= lien + "?but=" +pageActuelListe %>"><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
                                <% if (t.getEtat() < ConstanteEtat.getEtatValider()) {%>
                                      <a class="btn btn-danger pull-left" style="margin-right: 10px" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageActuelListe+"&classe="+classe %>&nomtable=fabrication">Supprimer</a>
                                      <a class="btn btn-primary pull-right" style="margin-right: 10px" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute="+pageActuel+"&classe=fabrication.Fabrication&nomtable=fabrication"%>">Valider</a>
                                      <a class="btn btn-secondary pull-right" style="margin-right: 10px" href="<%= lien + "?but="+ pageModif +"&id=" + id + "&acte=update"%>">Modifier</a>
                                <% } %>
                                <% if(t.getEtat()==1){ %>
                                <% } %>


                                <% if(t.getEtat()>=11){ %>
                                        <a class="btn btn-secondary pull-right" style="margin-right: 10px" href="<%= lien + "?but=stock/mvtstock-saisie.jsp&idOf="+t.getIdOffille()+"&idFab=" + id+"&idTypeMvStock="+ConstanteSocobis.TYPE_MVT_ENTREE%>">Mouvement entree</a>
                                        <a class="btn btn-secondary pull-right" style="margin-right: 10px" href="<%= lien + "?but=stock/mvtstock-saisie.jsp&idOf="+t.getIdOffille()+"&idFab=" + id+"&idTypeMvStock="+ConstanteSocobis.TYPE_MVT_SORTIE%>">Mouvement sortie</a>
                                        <a class="btn btn-danger pull-left" style="margin-right: 10px" href="<%= lien + "?but=apresTarif.jsp&acte=annulerVisa&id=" + id + "&bute="+pageActuel+"&classe=fabrication.Fabrication&nomtable=fabrication"%>">Annuler</a>
                                <% } %>

                                <a class="btn btn-secondary pull-right" style="margin-right: 10px" href="<%= lien + "?but=fabrication/charge/charge-saisie.jsp&id=" + id %>">Saisir charge</a>

                                <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase("11")||pc.getChampByName("etat").getValeur().equalsIgnoreCase(String.valueOf(ConstanteProcess.bloque))) { %>
                                <a class="btn btn-primary pull-right" style="margin-right: 10px" href="<%= lien + "?but=process/process-saisie.jsp&id=" + id+"&nomProcess=entamer&objet=fabrication.Fabrication" %>">(Re)Entamer</a>
                                <% } %>

                                <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase(String.valueOf(ConstanteProcess.entame))) { %>
                                <a class="btn btn-danger pull-left"  style="margin-right: 10px" href="<%= lien + "?but=process/process-saisie.jsp&id=" + id+"&nomProcess=bloquer&objet=fabrication.Fabrication" %>">Bloquer</a>
                                <a class="btn btn-primary pull-right" style="margin-right: 10px"  href="<%= lien + "?but=process/process-saisie.jsp&id=" + id+"&nomProcess=terminer&objet=fabrication.Fabrication" %>">Terminer</a>
                                <% } %>

                                <% if (t.getFabricationPrec()!=null) { %>
                                <a class="btn btn-secondary pull-right" style="margin-right: 10px"  href="<%= lien + "?but=fabrication/projet-fiche.jsp&id="+t.getFabricationPrec()+"" %>">Pr&eacute;c&eacute;dent</a>
                                <% } %>

                                <% if (t.getFabricationSuiv()!=null) { %>
                                <a class="btn btn-secondary pull-right" style="margin-right: 10px" href="<%= lien + "?but=fabrication/projet-fiche.jsp&id="+t.getFabricationSuiv()+"" %>">suivant</a>
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
                    <%
                        if (ismodal != null && ismodal.equalsIgnoreCase("true"))
                        {
                    %>
                        <li class="<%=map.get("../fabrication/inc/fabrication-mvtstock")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-mvtstock&ismodal=true','modalContent')" href="#" >Mouvement de stock</a></li>
                        <li class="<%=map.get("../fabrication/inc/fabrication-charge")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-charge&ismodal=true','modalContent')" href="#" >Charges rattach&eacute;es</a></li>
                        <% if(u.getUser().getIdrole().compareTo(ConstanteSocobis.CHEFFABR_RANG)==0){ %>
                        <li class="<%=map.get("../fabrication/inc/fabrication-rapprochement")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-rapprochement&ismodal=true','modalContent')" href="#">Rapprochement</a></li>
                        <% } %>
                        <li class="<%=map.get("../fabrication/inc/fabrication-historique")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-historique&ismodal=true','modalContent')" href="#" >Historique de fabrication</a></li>
                        <% if(u.getUser().getIdrole().compareTo(ConstanteSocobis.CHEFFABR_RANG)==0){ %>
                        <li class="<%=map.get("../fabrication/inc/fabrication-rapprochement-globale")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-rapprochement-globale&ismodal=true','modalContent')" href="#" >Rapprochement Globale</a></li>
                        <% } %>

                    <%}else {%>
                        <li class="<%=map.get("../fabrication/inc/fabrication-mvtstock")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-mvtstock">Mouvement de stock</a></li>
                        <li class="<%=map.get("../fabrication/inc/fabrication-charge")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-charge">Charges rattach&eacute;es</a></li>
                        <% if(u.getUser().getIdrole().compareTo(ConstanteSocobis.CHEFFABR_RANG)==0){ %>
                        <li class="<%=map.get("../fabrication/inc/fabrication-rapprochement")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-rapprochement">Rapprochement</a></li>
                        <% } %>
                        <li class="<%=map.get("../fabrication/inc/fabrication-historique")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-historique">Historique de fabrication</a></li>
                        <% if(u.getUser().getIdrole().compareTo(ConstanteSocobis.CHEFFABR_RANG)==0){ %>
                        <li class="<%=map.get("../fabrication/inc/fabrication-rapprochement-globale")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-rapprochement-globale">Rapprochement Globale</a></li>
                        <% } %>
                        <li class="<%=map.get("../historique/inc/historique-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=../historique/inc/historique-liste">Historique</a></li>
                    <%}%>
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
