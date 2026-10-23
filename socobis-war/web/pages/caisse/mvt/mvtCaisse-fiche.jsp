
<%@page import="caisse.MvtCaisseCpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.LinkedHashMap"%>
<%@ page import="caisse.MvtCaisse" %>
<%@ page import="utils.ConstanteAsync" %>

<%
    try {


    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    String lien = (String) session.getValue("lien");
    MvtCaisseCpl caisse = new MvtCaisseCpl();
    PageConsulte pc = new PageConsulte(caisse, request, u);
    pc.setTitre("Mouvement de tr&eacute;sorerie");
    pc.getBase();
    String iff=request.getParameter("idFF");
    String id=pc.getBase().getTuppleID();
    MvtCaisse base=(MvtCaisse)pc.getBase();
    if(base.getDebit()>0) pc.getChampByName("credit").setVisible(false);
    else pc.getChampByName("debit").setVisible(false);
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("designation").setLibelle("D&eacute;signation");
    pc.getChampByName("idCaisseLib").setLibelle("Tr&eacute;sorerie");
    pc.getChampByName("idCaisseLib").setLien(lien + "?but=caisse/caisse-fiche.jsp&id="+base.getIdCaisse(),"nom=");
    pc.getChampByName("idVenteDetail").setVisible(false);
    pc.getChampByName("idmvtcaissemere").setVisible(false);
    pc.getChampByName("idVirement").setVisible(false);
    pc.getChampByName("debit").setLibelle("Sortie de tr&eacute;sorerie ("+base.getIdDevise()+") ");
    pc.getChampByName("idModePaiementLib").setLibelle("Mode de paiement");
    pc.getChampByName("idModePaiementLib").setVisible(false);
    pc.getChampByName("reference").setLibelle("R&eacute;f&eacute;rence");
    pc.getChampByName("datycomptabilisation").setLibelle("Date de comptabilisation");
    pc.getChampByName("credit").setLibelle("Entr&eacute;e de tr&eacute;sorerie ("+base.getIdDevise()+")");
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
    pc.getChampByName("idCaisse").setVisible(false);
    pc.getChampByName("idOrigine").setLibelle("Origine");
    String idOrigine = pc.getChampByName("idOrigine").getValeur();
    pc.getChampByName("idOrigine").setLien(lien+"?but=caisse/mvt/mvt-dispatch.jsp", "idOrigine=");
    //if (idOrigine != null && idOrigine.startsWith("VNT"))pc.getChampByName("idOrigine").setLien(lien+"?but=vente/vente-fiche.jsp&id", "id=");
    //if (idOrigine != null && idOrigine.startsWith("RPRC"))pc.getChampByName("idOrigine").setLien(lien+"?but=caisse/report/reportCaisse-fiche.jsp&id", "id=");
    //if (idOrigine != null && idOrigine.startsWith("FCF"))pc.getChampByName("idOrigine").setLien(lien+"?but=facturefournisseur/facturefournisseur-fiche.jsp&id", "id=");
    pc.getChampByName("idVente").setVisible(false);
    pc.getChampByName("daty").setLibelle("Date");
//    pc.getChampByName("idModePaiementLib").setLibelle("Mode de paiement");
//    pc.getChampByName("idModePaiement").setVisible(false);
    pc.getChampByName("idDevise").setLibelle("Devise");
    pc.getChampByName("idPrevision").setLibelle("Pr&eacute;vision");
    pc.getChampByName("soldecredit").setVisible(false);
    pc.getChampByName("soldedebit").setVisible(false);
    pc.getChampByName("idVente").setLien(lien+"?but=vente/vente-fiche.jsp&id", "id=");
    pc.getChampByName("idTiers").setVisible(false);
    //pc.getChampByName("idOrigine").setVisible(false);
    pc.getChampByName("idop").setVisible(false);
     pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idtraite").setVisible(false);
    pc.getChampByName("idreport").setLibelle("Report");
    pc.getChampByName("idreport").setVisible(false);
    pc.getChampByName("idecriture").setLibelle("&Eacute;criture");
    pc.getChampByName("idEcriture").setLien(lien + "?but=compta/ecriture/ecriture-fiche.jsp", "id=");

    String[] colOrdre = new String[] {"designation", "daty", "heure", "etatLib", "reference", "idCaisseLib", "credit", "tiers", "idDevise", "taux", "datycomptabilisation", "idecriture", "compte", "idOrigine", "idtraite", "idPrevision", "idreport"};
    pc.setOrdre(colOrdre);

    LinkedHashMap<String, String[]> rubrique = new LinkedHashMap<>();
    rubrique.put("Information g&eacute;n&eacute;rale", new String[]{"designation",
            "daty",
            "heure",
            "etatLib",
            "reference",
            "idOrigine",
            "idtraite",
            "idPrevision",
            "idreport",});
    rubrique.put("Tr&eacute;sorerie et comptabilit&eacute;", new String[]{"idCaisseLib",
            "credit",
            "debit",
            "tiers",
            "idDevise",
            "taux",
            "datycomptabilisation",
            "idecriture",
            "compte",});
    pc.setRubrique(rubrique);
    String pageActuel = "caisse/mvt/mvtCaisse-fiche.jsp";
    String classe = "caisse.MvtCaisse";
    Onglet onglet =  new Onglet("page1");
    onglet.setDossier("inc");
    caisse = (MvtCaisseCpl) pc.getBase();
    Map<String, String> map = new HashMap<String, String>();
    String tab = request.getParameter("tab") == null ? "liaisonpaiement-vente" : request.getParameter("tab");
    map.put("/../../../compta/ecriture/inc/sous-ecriture-detail", "");
    map.put("liaisonpaiement-vente","");
    map.put("liaisonpaiement-achat","");
    map.put("/../../../historique/inc/historique-liste", "");
    if(request.getParameter("tab")=="/../../../historique/inc/historique-liste") {
        tab="/../../../historique/inc/historique-liste";
    }
    if(caisse.getIdtraite()!=null){
        pc.getChampByName("idtraite").setLibelle("Traite");
        pc.getChampByName("idtraite").setLien(lien+"?but=facture/traite-fiche.jsp&id", "id=");
    }
    if(caisse.getIdOrigine()!=null && caisse.getIdOrigine().startsWith("VNT")){
        //pc.getChampByName("idOrigine").setLien("?but=vente/vente-fiche.jsp","id=");
        map.put("origine-vente-details", "");
        if (tab == null) {
            tab = "origine-vente-details";
        }
    }else if(caisse.getIdOrigine()!=null && caisse.getIdOrigine().startsWith("FCF")){
        //pc.getChampByName("idOrigine").setLien("?but=facturefournisseur/facturefournisseur-fiche.jsp","id=");
        map.put("origine-achat-details", "");
        if (tab == null) {
            tab = "origine-achat-details";
        }
    }
    onglet.setDossier("inc");
    map.put(tab, "active");
    tab = "inc/" + tab + ".jsp";
    String pageModif = "caisse/mvt/mvtCaisse-saisie-entree.jsp";

    if(caisse.getCredit()>0 && caisse.getDebit()<=0){
        pageModif="caisse/mvt/mvtCaisse-saisie-entree.jsp";
    }
        if(caisse.getDebit()>0 && caisse.getCredit()<=0){
        pageModif="caisse/mvt/mvtCaisse-saisie-sortie.jsp";
    }

%>

<div class="content-wrapper">
    <%if(iff!=null){%>
    <h1 class="box-title"><a href=<%= lien + "?but=facturefournisseur/facturefournisseur-fiche.jsp&id="+iff%> ><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <%}else{%>
    <h1 class="box-title"><a href=<%= lien + "?but=caisse/mvt/mvtCaisse-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <%}%>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <%=pc.getDuplicateButtonJS(pageModif,id)%>
                        <div class="box-footer">
                            <% if(caisse.getEtat() == ConstanteEtat.getEtatProforma()) { %>
<%--                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id")+ "&bute=caisse/mvt/mvtCaisse-fiche.jsp&classe=" + classe  %> " >Validation Comptable</a>--%>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id")+ "&bute=caisse/mvt/mvtCaisse-fiche.jsp&classe=" + classe  %> " >Validation avec &eacute;critures</a>
                            <% } %>
                            <% if(caisse.getEtat() > 0 && caisse.getEtat() < 8) { %>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=validerMvt&id=" + request.getParameter("id") + "&bute=caisse/mvt/mvtCaisse-fiche.jsp&classe=" + classe %> " >Valider</a>                            <% }
                            if( caisse.getEtat() != 11 ){ %>
                        <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id +"&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <%   }
                                if(caisse.getEtat() == 11 ){
                            %>
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=prevision/prevision-non-regle.jsp&idMvtCaisse=" + request.getParameter("id") %>" style="margin-right: 10px">Attacher prevision</a>
                            <%
                                }
                                if( caisse.getEtat() != 11 ){ %>
<%--                            <a class="btn btn-warning pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/mvt/mvtCaisse-modif.jsp&id=" + request.getParameter("id") %>" style="margin-right: 10px">Modifier</a>--%>
                            <%    }
                            %>

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
                    <% if(caisse.getIdOrigine()!=null && caisse.getIdOrigine().startsWith("FCF")){ %>
                    <li class="<%=map.get("origine-achat-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=origine-achat-details&id1=<%= id  %>">D&eacute;tails origine</a></li>
                    <% } %>
                    <% if(caisse.getIdOrigine()!=null && caisse.getIdOrigine().startsWith("VNT")){ %>
                    <li class="<%=map.get("origine-achat-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=origine-vente-details&id1=<%= id  %>">D&eacute;tails origine</a></li>
                    <% } %>
                    <% if (caisse.getEtat() >= ConstanteEtat.getEtatValider()) {%>
                    <li class="<%=map.get("/../../../compta/ecriture/inc/sous-ecriture-detail")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=/../../../compta/ecriture/inc/sous-ecriture-detail">&Eacute;critures</a></li>

                    <% }%>
                    <li class="<%=map.get("liaisonpaiement-vente")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=liaisonpaiement-vente&id1=<%= id  %>">Paiements li&eacute;s aux ventes</a></li>
                    <li class="<%=map.get("liaisonpaiement-achat")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=liaisonpaiement-achat&id1=<%= id  %>">Paiements li&eacute;s aux achats</a></li>
                    <li class="<%=map.get("/../../../historique/inc/historique-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=/../../../historique/inc/historique-liste">Historique</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab%>" >
                        <jsp:param name="idmere" value="<%= id%>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>


</div>
</div>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>