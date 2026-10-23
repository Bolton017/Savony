<%@ page import="user.UserEJB" %>
<%@ page import="maintenance.travaux.TravauxCpl" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="utilitaire.ConstanteEtat" %>
<%@ page import="utils.ConstanteProcess" %>
<%@ page import="utils.ConstanteSocobis" %>

<%
  try{
    UserEJB u =(user.UserEJB)session.getValue("u");
    String ismodal = request.getParameter("ismodal");
    String lien = (String) session.getValue("lien");
    TravauxCpl t = new TravauxCpl();
    t.setNomTable("TRAVAUXCPL");
    PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
    t = (TravauxCpl) pc.getBase();
    String id=pc.getBase().getTuppleID( );

//    HeureSupFabrication[] hfille = null;
//    if(id!=null && !id.isEmpty()){
//      hfille = t.genererHeureSup(null);
//    }

    pc.getChampByName("id").setLibelle("ID");
    pc.getChampByName("lanceparLib").setLibelle("Entit&eacute;");
    pc.getChampByName("lancepar").setVisible(false);
    pc.getChampByName("cibleLib").setLibelle("Cible");
      pc.getChampByName("cible").setVisible(false);
      pc.getChampByName("cibleLib").setVisible(false);
    pc.getChampByName("remarque").setLibelle("Description");
    pc.getChampByName("libelle").setLibelle("D&eacute;signation");
    pc.getChampByName("besoin").setLibelle("Date de besoin");
    pc.getChampByName("FABRICATIONPREC").setLibelle("Travaux pr&eacute;c&eacute;dente ");
    pc.getChampByName("fabricationSuiv").setLibelle("Travaux Suivant ");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("ingredientMaintenanceLib").setLibelle("Objet");
    pc.getChampByName("idOffille").setLien(lien+"?but=maintenance/travaux/Otravaux-details-fiche.jsp", "id=");
    pc.getChampByName("idOffille").setLibelle("Ordre de travaux fille associ&eacute;");
    pc.getChampByName("idIngredientMaintenance").setVisible(false);
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("fabricationSuiv").setVisible(false);
    pc.getChampByName("FABRICATIONPREC").setVisible(false);
//    cacher ordre de travaux
    pc.getChampByName("idOffille").setVisible(false);
    pc.getChampByName("idOf").setVisible(false);


    pc.getChampByName("etatlib").setLibelle("&Eacute;TAT");
    pc.getChampByName("idOf").setLibelle("Ordre de travaux associ&eacute;");
    pc.getChampByName("idOf").setLien(lien+"?but=maintenance/travaux/Otravaux-fiche.jsp", "id=");
    pc.setTitre("Fiche de travaux");
    String pageModif = "maintenance/travaux/Travaux-saisie.jsp";
    String pageActuel = "maintenance/travaux/Travaux-fiche.jsp";
    String pageActuelListe = "maintenance/travaux/Travaux-liste.jsp";
    String classe = "maintenance.travaux.Travaux";

    Map<String, String> map = new HashMap<String, String>();
//    map.put("inc/fabrication-details", "");
    map.put("inc/travaux-process-liste", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
      tab = "inc/travaux-recap";
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
            <div class="box-footer  ">
              <% if(t.getEtat() < ConstanteEtat.getEtatValider()){ %>
              <%--                                    <a class="btn btn-secondary pull-right" href="<%= lien + "?but=fabrication/heureSup-saisie.jsp&idFab="+id+"" %>">Saisir HS</a>--%>
              <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageActuelListe+"&classe="+classe %>&nomtable=travaux">Supprimer</a>

              <% } %>
              <% if(t.getEtat()==1){ %>
                <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id + "&acte=update"%>">Modifier</a>
              <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute="+pageActuel+"&classe=maintenance.travaux.Travaux&nomtable=Travaux"%>">Valider</a>
              <% } %>
              <% if (t.getEtat()>=11){ %>
<%--                <a class="btn btn-primary pull-right" href="<%= lien + "?but=facturefournisseur/facturefournisseur-saisie.jsp&idTravaux=" + id+"&idElementMaintenance="+t.getIdIngredientMaintenance() %>" style="margin-right: 10px">G&eacute;n&eacute;rer achat</a>--%>
                <a class="btn btn-secondary pull-right" href="<%= lien + "?but=stock/mvtstock-saisie.jsp&idOf="+t.getIdOffille()+"&idTravaux=" + id+"&idTypeMvStock="+ConstanteSocobis.TYPE_MVT_SORTIE%>">Mouvement de sortie</a>
                <a class="btn btn-secondary pull-right" href="<%= lien + "?but=maintenance/travaux/MoTravaux-saisie-multiple.jsp&idTravaux=" + id%>">Affecter du personnel</a>
                 <a class="btn btn-secondary pull-right" href="<%= lien + "?but=facturefournisseur/dmdachat/dmdachat-saisie.jsp&idTravaux="+id%>">Demande d'externalisation</a>
                <a class="btn btn-secondary pull-right" href="<%= lien + "?but=maintenance/travaux/process/processmaintenance-saisie.jsp&idTravaux=" + id%>">Ajout processus</a>
              <% } %>
              <% if(t.getEtat()<11){ %>
              <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&acte=annulerVisa&id=" + id + "&bute="+pageActuel+"&classe=maintenance.travaux.Travaux&nomtable=Travaux"%>">Annuler</a>
              <% } %><% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase("11")||pc.getChampByName("etat").getValeur().equalsIgnoreCase(String.valueOf(ConstanteProcess.bloque))) { %>
                <a class="btn btn-primary pull-right" style="margin-right: 2px;" href="<%= lien + "?but=maintenance/travaux/process/process-saisie.jsp&id=" + id+"&nomProcess=entamer&objet=maintenance.travaux.Travaux" %>">(Re)Entamer</a>
              <% } %>

              <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase(String.valueOf(ConstanteProcess.entame))) { %>
                  <a class="btn btn-danger pull-left" href="<%= lien + "?but=maintenance/travaux/process/process-saisie.jsp&id=" + id+"&nomProcess=bloquer&objet=maintenance.travaux.Travaux" %>">Pause</a>
                  <a class="btn btn-primary pull-right" href="<%= lien + "?but=maintenance/travaux/process/process-saisie.jsp&id=" + id+"&nomProcess=terminer&objet=maintenance.travaux.Travaux" %>">Terminer</a>
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
<%--          <li class="<%=map.get("inc/fabrication-details")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-details&ismodal=true','modalContent')" href="#">D&eacute;tails</a></li>--%>
          <li class="<%=map.get("inc/fabrication-mvtstock")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-mvtstock&ismodal=true','modalContent')" href="#" >Sortie de Pi&egrave;ces</a></li>
<%--            <li class="<%=map.get("inc/achat-details")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/inc/achat-details&ismodal=true', 'modalContent')">Achats</a></li>--%>
            <li class="<%=map.get("inc/travaux-process-liste")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/travaux-process-liste&ismodal=true', 'modalContent')">Historique</a></li>
            <li class="<%=map.get("inc/motravaux-liste")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/motravaux-liste&ismodal=true', 'modalContent')">Personnels affect&eacute;s</a></li>
            <li class="<%=map.get("inc/travaux-demandeachat")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/travaux-demandeachat">Demande de service Externe</a></li>
            <li class="<%=map.get("inc/travaux-facture")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/travaux-facture">Charges Externes</a></li>
            <li class="<%=map.get("inc/details-process")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/details-process&ismodal=true', 'modalContent')">D&eacute;tails du processus</a></li>
            <li class="<%=map.get("inc/rapprochement-travaux")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/rapprochement-travaux&ismodal=true', 'modalContent')">Rapprochement</a></li>
            <li class="<%=map.get("inc/travaux-recap")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/travaux-recap&ismodal=true', 'modalContent')">R&eacute;capitulation</a></li>

          <%--                    <li class="<%=map.get("inc/facture-client-paiement")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/facture-client-paiement">Paiements associ&eacute;s</a></li>--%>
<%--          <li class="<%=map.get("inc/fabrication-dechet")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-dechet&ismodal=true','modalContent')" href="#" >D&eacute;chets</a></li>--%>
          <%-- <li class="<%=map.get("inc/fabrication-produit-fini")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-produit-fini">Produits Finis</a></li>--%>
<%--          <li class="<%=map.get("inc/fabrication-residu")%>"><a onclick="ouvrirModal(event,'moduleLeger.jsp?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-residu&ismodal=true','modalContent')" href="#" >R&eacute;sidu</a></li>--%>

          <%}else {%>
<%--          <li class="<%=map.get("inc/fabrication-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-details">D&eacute;tails</a></li>--%>
          <li class="<%=map.get("inc/fabrication-mvtstock")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-mvtstock">Sortie de Pi&egrave;ces</a></li>
<%--          <li class="<%=map.get("inc/achat-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/achat-details">Achats</a></li>--%>
            <li class="<%=map.get("inc/travaux-process-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/travaux-process-liste">Historique</a></li>
            <li class="<%=map.get("inc/motravaux-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/motravaux-liste">Personnels affect&eacute;s</a></li>
          <li class="<%=map.get("inc/travaux-demandeachat")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/travaux-demandeachat">Demande de service Externe</a></li>
          <li class="<%=map.get("inc/travaux-facture")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/travaux-facture">Charges Externes</a></li>
            <li class="<%=map.get("inc/details-process")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/details-process">D&eacute;tails du processus</a></li>
            <li class="<%=map.get("inc/rapprochement-travaux")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/rapprochement-travaux">Rapprochement</a></li>
            <li class="<%=map.get("inc/travaux-recap")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/travaux-recap">R&eacute;capitulation</a></li>

        <%--                    <li class="<%=map.get("inc/facture-client-paiement")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/facture-client-paiement">Paiements associ&eacute;s</a></li>--%>
<%--          <li class="<%=map.get("inc/fabrication-dechet")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-dechet">D&eacute;chets</a></li>--%>
          <%-- <li class="<%=map.get("inc/fabrication-produit-fini")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-produit-fini">Produits Finis</a></li>--%>
<%--          <li class="<%=map.get("inc/fabrication-residu")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-residu">R&eacute;sidu</a></li>--%>
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

<%--                            <a href="<%= lien + "?but=maintenance/travaux/process/process-saisie.jsp&id=" + id+"&nomProcess=entamer&objet=fabrication.Fabrication" %>" style="margin-right: 10px"><button class="btn btn-success">(Re)Entamer</button></a>--%>
<%--                            <% } %>--%>
<%--                            <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase(String.valueOf(ConstanteProcess.entame))) { %>    &lt;%&ndash; ENTAMMEE &ndash;%&gt;--%>
<%--                            <a href="<%= lien + "?but=maintenance/travaux/process/process-saisie.jsp&id=" + id+"&nomProcess=bloquer&objet=fabrication.Fabrication" %>" style="margin-right: 10px"><button class="btn btn-warning">Bloquer</button></a>--%>
<%--                            <a href="<%= lien + "?but=maintenance/travaux/process/process-saisie.jsp&id=" + id+"&nomProcess=terminer&objet=fabrication.Fabrication" %>" style="margin-right: 10px"><button class="btn btn-success">Terminer</button></a>--%>
<%--                            <% } %>--%>

<%--                            <% if (t.getFabricationPrec()!=null) { %>--%>
<%--                            <a href="<%= lien + "?but=fabrication/fabrication-fiche.jsp&id="+t.getFabricationPrec()+"" %>" style="margin-right: 10px"><button class="btn btn-warning">precedent</button></a>--%>
<%--                            <% } %>--%>

<%--                            <% if (t.getFabricationSuiv()!=null) { %>    --%>
<%--                            <a href="<%= lien + "?but=fabrication/fabrication-fiche.jsp&id="+t.getFabricationSuiv()+"" %>" style="margin-right: 10px"><button class="btn btn-warning">suivant</button></a>--%>
<%--                            <% } %>--%>
<%--                        </div>--%>
