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
        pc.getChampByName("cible").setVisible(false);
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("libelle").setLibelle("D&eacute;signation");
        pc.getChampByName("besoin").setLibelle("Date de besoin");
        pc.getChampByName("FABRICATIONPREC").setLibelle("Fabrication pr&eacute;c&eacute;dente ");
        pc.getChampByName("fabricationSuiv").setLibelle("Fabrication Suivant ");
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("idOffille").setLien(lien+"?but=fabrication/ordre-fabrication-details-fiche.jsp", "id=");
        pc.getChampByName("idOffille").setLibelle("Ordre de fabrication fille associ&eacute;");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("etatlib").setLibelle("&Eacute;TAT");
        pc.getChampByName("idOf").setLibelle("Ordre de fabrication associ&eacute;");
        pc.getChampByName("idOf").setLien(lien+"?but=fabrication/ordre-fabrication-fiche.jsp", "id=");
        pc.setTitre("Fiche de Fabrication");
        String pageModif = "fabrication/fabrication-saisie.jsp";
        String pageActuel = "fabrication/fabrication-fiche.jsp";
        String pageActuelListe = "fabrication/fabrication-liste.jsp";
        String classe = "fabrication.Fabrication";
        String nomTable = "FabricationAB";

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/fabrication-details", "");
        map.put("../historique/inc/historique-liste", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/fabrication-details";
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
                                <a class="btn btn-primary pull-right" style="margin-right: 10px" href="<%= lien + "?but=stock/mvtstock-saisie.jsp&idOf=" + t.getIdOffille() + "&idFab=" + id + "&idTypeMvStock=" + ConstanteSocobis.TYPE_MVT_ENTREE + "&isResidu=residu" %>">R&eacute;sidu</a>
                                <% if(t.getEtat()==1){ %>
                                <% } %>
<%--                                <a class="btn btn-primary pull-right" style="margin-right: 10px" href="<%= lien + "?but=demande/demandetransfert-saisie.jsp&idFab=" + id %>">Demande de transfert</a>--%>
                                <a class="btn btn-primary pull-right" style="margin-right: 10px" href="<%= lien + "?but=analyse/analyse-saisie.jsp&idFab=" + id %>">Enregistrer analyse</a>


<%--                            <% if(t.getEtat() == ConstanteEtat.getEtatValider()){ %>--%>
<%--                                    <a class="btn btn-secondary pull-right" href="<%= lien + "?but=fabrication/attribuerRessource.jsp&idFab="+id+"" %>">Ressource</a>--%>
<%--                                    <a class="btn btn-secondary pull-right" href="<%= lien + "?but=fabrication/heureSup-saisie.jsp&idFab="+id+"" %>">Saisir HS</a>--%>
<%--                                   --%>
<%--                            <% } %>--%>
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
                                <a class="btn btn-secondary pull-right" style="margin-right: 10px"  href="<%= lien + "?but=fabrication/fabrication-fiche.jsp&id="+t.getFabricationPrec()+"" %>">Pr&eacute;c&eacute;dent</a>
                                <% } %>

                                <% if (t.getFabricationSuiv()!=null) { %>
                                <a class="btn btn-secondary pull-right" style="margin-right: 10px" href="<%= lien + "?but=fabrication/fabrication-fiche.jsp&id="+t.getFabricationSuiv()+"" %>">suivant</a>
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
                    <!-- a modifier -->
                    <%
                        if (ismodal != null && ismodal.equalsIgnoreCase("true"))
                        {
                    %>
                        <li class="<%=map.get("inc/fabrication-details")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-details&ismodal=true','modalContent')" href="#">D&eacute;tails</a></li>
                        <li class="<%=map.get("inc/fabrication-mvtstock")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-mvtstock&ismodal=true','modalContent')" href="#" >Mouvement de stock</a></li>
                        <li class="<%=map.get("inc/fabrication-charge")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-charge&ismodal=true','modalContent')" href="#" >Charges rattach&eacute;es</a></li>
                        <% if(u.getUser().getIdrole().compareTo(ConstanteSocobis.CHEFFABR_RANG)==0){ %>
                        <li class="<%=map.get("inc/fabrication-rapprochement")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-rapprochement&ismodal=true','modalContent')" href="#">Rapprochement</a></li>
                        <% } %>
                        <li class="<%=map.get("inc/fabrication-historique")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-historique&ismodal=true','modalContent')" href="#" >Historique de fabrication</a></li>
                        <% if(u.getUser().getIdrole().compareTo(ConstanteSocobis.CHEFFABR_RANG)==0){ %>
                        <li class="<%=map.get("inc/fabrication-rapprochement-globale")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-rapprochement-globale&ismodal=true','modalContent')" href="#" >Rapprochement Globale</a></li>
                        <% } %>
                        <%--                    <li class="<%=map.get("inc/facture-client-paiement")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/facture-client-paiement">Paiements associ&eacute;s</a></li>--%>
<%--                        <li class="<%=map.get("inc/fabrication-dechet")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-dechet&ismodal=true','modalContent')" href="#" >D&eacute;chets</a></li>--%>
                        <%-- <li class="<%=map.get("inc/fabrication-produit-fini")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-produit-fini">Produits Finis</a></li>--%>
<%--                        <li class="<%=map.get("inc/fabrication-residu")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-residu&ismodal=true','modalContent')" href="#" >R&eacute;sidu</a></li>--%>
<%--                        <li class="<%=map.get("inc/fabrication-ressource")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-ressource&ismodal=true','modalContent')" href="#" >Attribution</a></li>--%>
<%--                        <li class="<%=map.get("inc/fabrication-hs")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-hs&ismodal=true','modalContent')" href="#" >Heure Suppl&eacute;mentaire</a></li>--%>
<%--                        <li class="<%=map.get("inc/charge-personnel")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/charge-personnel&ismodal=true','modalContent')" href="#" >Charge personnelle</a></li>--%>
                        <li class="<%=map.get("inc/analyse-historique")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/analyse-historique">Historique Analyse</a></li>

                    <%}else {%>
                        <li class="<%=map.get("inc/fabrication-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-details">D&eacute;tails</a></li>
                        <li class="<%=map.get("inc/fabrication-mvtstock")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-mvtstock">Mouvement de stock</a></li>
                        <li class="<%=map.get("inc/fabrication-charge")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-charge">Charges rattach&eacute;es</a></li>
                        <% if(u.getUser().getIdrole().compareTo(ConstanteSocobis.CHEFFABR_RANG)==0){ %>
                        <li class="<%=map.get("inc/fabrication-rapprochement")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-rapprochement">Rapprochement</a></li>
                        <% } %>
                        <li class="<%=map.get("inc/fabrication-historique")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-historique">Historique de fabrication</a></li>
                        <% if(u.getUser().getIdrole().compareTo(ConstanteSocobis.CHEFFABR_RANG)==0){ %>
                        <li class="<%=map.get("inc/fabrication-rapprochement-globale")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-rapprochement-globale">Rapprochement Globale</a></li>
                        <% } %>
                        <%--                    <li class="<%=map.get("inc/facture-client-paiement")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/facture-client-paiement">Paiements associ&eacute;s</a></li>--%>
<%--                        <li class="<%=map.get("inc/fabrication-dechet")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-dechet">D&eacute;chets</a></li>--%>
                        <%-- <li class="<%=map.get("inc/fabrication-produit-fini")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-produit-fini">Produits Finis</a></li>--%>
<%--                        <li class="<%=map.get("inc/fabrication-residu")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-residu">R&eacute;sidu</a></li>--%>
<%--                        <li class="<%=map.get("inc/fabrication-ressource")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-ressource">Attribution</a></li>--%>
<%--                        <li class="<%=map.get("inc/fabrication-hs")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-hs">Heure Suppl&eacute;mentaire</a></li>--%>
<%--                        <li class="<%=map.get("inc/charge-personnel")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/charge-personnel">Charge personnelle</a></li>--%>
                        <li class="<%=map.get("inc/analyse-historique")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/analyse-historique">Historique Analyse</a></li>
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

<%--                        <div class="box-footer">--%>
<%--                            <a class="btn btn-warning pull-left"  href="<%= lien + "?but="+ pageModif +"&id=" + id + "&acte=update"%>" style="margin-right: 10px">Modifier</a>--%>



<%--                            <a class="btn btn-warning pull-left"  href="<%= lien + "?but=stock/mvtstock-saisie.jsp&idOf=" + t.getIdOffille() + "&idFab=" + id + "&idTypeMvStock=" + ConstanteSocobis.TYPE_MVT_ENTREE + "&isResidu=residu" %>" style="margin-right: 10px">Residu</a>--%>
<%--                            <%--%>
<%--                                if(t.getEtat() == ConstanteEtat.getEtatValider()){--%>
<%--                            %>--%>
<%--                                <a class="btn btn-info pull-left"  href="<%= lien + "?but=fabrication/attribuerRessource.jsp&idFab="+id+"" %>" style="margin-right: 10px">Ressource</a>--%>
<%--                                <a class="btn btn-info pull-left"  href="<%= lien + "?but=fabrication/heureSup-saisie.jsp&idFab="+id+"" %>" style="margin-right: 10px">Saisir HS</a>--%>
<%--                                <a href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageActuelListe+"&classe="+classe %>&nomtable=fabrication" style="margin-right: 10px"><button class="btn btn-danger">Supprimer</button></a>--%>
<%--                            <%--%>
<%--                                }--%>
<%--                            %>--%>
<%--                            <% if(t.getEtat()>=11){ %>--%>
<%--                            <a href="<%= lien + "?but=stock/mvtstock-saisie.jsp&idOf="+t.getIdOffille()+"&idFab=" + id+"&idTypeMvStock="+ConstanteSocobis.TYPE_MVT_ENTREE%>" style="margin-right: 10px"><button class="btn btn-info">Mouvement entree</button></a>--%>
<%--                            <a href="<%= lien + "?but=stock/mvtstock-saisie.jsp&idOf="+t.getIdOffille()+"&idFab=" + id+"&idTypeMvStock="+ConstanteSocobis.TYPE_MVT_SORTIE%>" style="margin-right: 10px"><button class="btn btn-info">Mouvement sortie</button></a>--%>
<%--                            <a href="<%= lien + "?but=apresTarif.jsp&acte=annulerVisa&id=" + id + "&bute="+pageActuel+"&classe=fabrication.Fabrication&nomtable=fabrication"%>" style="margin-right: 10px"><button class="btn btn-danger">Annuler</button></a>--%>
<%--                            <% } %>--%>
<%--                            <% if(t.getEtat()==1){ %>--%>
<%--                                <a href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute="+pageActuel+"&classe=fabrication.Fabrication&nomtable=fabrication"%>" style="margin-right: 10px"><button class="btn btn-success">Valider</button></a>--%>
<%--                            <% } %>--%>
<%--                            <a href="<%= lien + "?but=fabrication/charge/charge-saisie.jsp&id=" + id %>" style="margin-left: 10px"><button class="btn btn-primary">Saisir charge</button></a>--%>
<%--                            <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase("11")||pc.getChampByName("etat").getValeur().equalsIgnoreCase(String.valueOf(ConstanteProcess.bloque))) { %>--%>

<%--                            <a href="<%= lien + "?but=process/process-saisie.jsp&id=" + id+"&nomProcess=entamer&objet=fabrication.Fabrication" %>" style="margin-right: 10px"><button class="btn btn-success">(Re)Entamer</button></a>--%>
<%--                            <% } %>--%>
<%--                            <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase(String.valueOf(ConstanteProcess.entame))) { %>    &lt;%&ndash; ENTAMMEE &ndash;%&gt;--%>
<%--                            <a href="<%= lien + "?but=process/process-saisie.jsp&id=" + id+"&nomProcess=bloquer&objet=fabrication.Fabrication" %>" style="margin-right: 10px"><button class="btn btn-warning">Bloquer</button></a>--%>
<%--                            <a href="<%= lien + "?but=process/process-saisie.jsp&id=" + id+"&nomProcess=terminer&objet=fabrication.Fabrication" %>" style="margin-right: 10px"><button class="btn btn-success">Terminer</button></a>--%>
<%--                            <% } %>--%>

<%--                            <% if (t.getFabricationPrec()!=null) { %>--%>
<%--                            <a href="<%= lien + "?but=fabrication/fabrication-fiche.jsp&id="+t.getFabricationPrec()+"" %>" style="margin-right: 10px"><button class="btn btn-warning">precedent</button></a>--%>
<%--                            <% } %>--%>

<%--                            <% if (t.getFabricationSuiv()!=null) { %>    --%>
<%--                            <a href="<%= lien + "?but=fabrication/fabrication-fiche.jsp&id="+t.getFabricationSuiv()+"" %>" style="margin-right: 10px"><button class="btn btn-warning">suivant</button></a>--%>
<%--                            <% } %>--%>
<%--                        </div>--%>