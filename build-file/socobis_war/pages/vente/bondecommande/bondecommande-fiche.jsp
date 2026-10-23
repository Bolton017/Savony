<%@page import="faturefournisseur.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="vente.BonDeCommandeCpl"%>
<%@page import="fichier.AttacherFichier"%>
<%@page import="uploadbean.UploadService"%>
<%@ page import="java.net.URLEncoder" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
%>
<%
    try{
    String lien = (String) session.getValue("lien");
    BonDeCommandeCpl f = new BonDeCommandeCpl();
    f.setNomTable("BONDECOMMANDE_CLIENT_CPL");
    PageConsulte pc = new PageConsulte(f, request, u);
    pc.setTitre("Bon de commande client");
    String id=pc.getBase().getTuppleID();
    f = (BonDeCommandeCpl)pc.getBase();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("reference").setLibelle("R&eacute;f&eacute;rence");
    pc.getChampByName("daty").setLibelle("date");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("modepaiementlib").setLibelle("Mode de paiement");
    pc.getChampByName("designation").setLibelle("d&eacute;signation");
    pc.getChampByName("idclientlib").setLibelle("Client");
    pc.getChampByName("etatFacturation").setLibelle("&Eacute;tat facturation");
    pc.getChampByName("idClientLib").setLien((String) session.getValue("lien") + "?but=client/client-fiche.jsp&id=" + f.getIdClient(), "nom=");

    pc.getChampByName("etatlib").setLibelle("Etat");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idclient").setVisible(false);
    pc.getChampByName("idMagasinLib").setLibelle("Magasin");
    pc.getChampByName("idProforma").setLien(lien+"?but=vente/proforma/proforma-fiche.jsp", "id=");
    pc.getChampByName("id").setVisible(false);
    pc.getChampByName("idproforma").setLien(lien+"?but=vente/proforma/proforma-fiche.jsp", "id=");
    pc.getChampByName("idproforma").setLibelle("Ref. Proforma");
    pc.getChampByName("modelivraisonlib").setLibelle("Mode de livraison");
    pc.getChampByName("nbfacture").setLibelle("Nombre de facture");
    pc.getChampByName("nbfacture").setVisible(false);
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("modepaiement").setVisible(false);
    pc.getChampByName("motsclesss").setVisible(false);
    pc.getChampByName("lieuLivraison").setLibelle("Lieu de livraison");
    pc.getChampByName("dateLivraison").setLibelle("Date de livraison");

        pc.getChampByName("idZoneClientLib").setLibelle("Zone Client");
        pc.getChampByName("idZoneClientLib").setLien((String) session.getValue("lien") + "?but=client/zone/zone-fiche.jsp&id=" + f.getIdzoneclient(), "val=");
        pc.getChampByName("idZoneClient").setVisible(false);
        pc.getChampByName("commercialLib").setLibelle("Commercial");
        pc.getChampByName("commercial").setVisible(false);
        pc.getChampByName("montantTtcAr").setVisible(false);
        pc.getChampByName("idDevise").setVisible(false);
        pc.getChampByName("Fraislivraison").setVisible(false);
        pc.getChampByName("idMagasin").setVisible(false);
        pc.getChampByName("montantTtcAr").setLibelle("Montant TTC (AR)");
        pc.getChampByName("montantHT").setLibelle("Montant HT ("+f.getIdDevise()+")");
        pc.getChampByName("montantRemise").setLibelle("Montant de la Remise ("+f.getIdDevise()+")");
        pc.getChampByName("montantTva").setLibelle("Montant TVA ("+f.getIdDevise()+")");
        pc.getChampByName("montantTTC").setLibelle("Montant TTC ("+f.getIdDevise()+")");
        if(f.getIdDevise().compareToIgnoreCase("AR")==0) {
            pc.getChampByName("montantTtcAr").setVisible(false);
        }
        String[] ordre = {
                "daty",
                "designation",
                "idClientLib",
                "idZoneClientLib",
                "reference",
                "commercialLib",
                "idMagasinLib",
                "idproforma",
                "dateLivraison",
                "modepaiementlib",
                "modelivraisonlib",
                "lieuLivraison",
                "idDevise",
                "montantHT",
                "montantRemise",
                "montantTva",
                "montantTTC",
                "etatlib",
                "remarque"
        };
        pc.setOrdre(ordre);

    String pageActuel = "vente/bondecommande/bondecommande-fiche.jsp";

    String pageModif = "vente/bondecommande/bondecommande-saisie.jsp";
    String classe = "vente.BonDeCommande";
    
    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/bondecommande-detail", "");
    map.put("inc/bondecommande-liste-detail", "");
    map.put("inc/bondecommande-besoin", "");
    map.put("inc/livraisondetail-bc", "");
    map.put("inc/fabricationdetail-bc", "");
    map.put("inc/vente-cpl-visee", "");
    map.put("/../../historique/inc/historique-liste", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/bondecommande-detail";
    }

    map.put(tab, "active");
    tab = tab + ".jsp";

    // Récupération des fichiers attachés
    AttacherFichier[] fichiers = UploadService.getUploadFile(request.getParameter("id"));
    configuration.CynthiaConf.load();
    String cdn = configuration.CynthiaConf.properties.getProperty("cdnReadUri");
    String projectName = pc.getChampByName("designation").getValeur()
                .replace("'","_")
                .replace("/","_")
                .replace("-","_")
                .replace(":", "_")
                .replace("*", "_")
                .replace(" ", "_");
    String dossier = "bondecommande/files/" + projectName;
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=bondecommande/bondecommande-fiche.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
<%--                            <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=fabrication/fabrication-saisie.jsp&idBC=" + id + "&classe=" + classe%> " style="margin-right: 10px">Fabriquer</a>--%>
<%--                            <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=fabrication/ordre-fabrication-saisie.jsp&idBC=" + id + "&classe=" + classe%> " style="margin-right: 10px">Generer OF</a>--%>
                            <% if (f.getEtat() < ConstanteEtat.getEtatValider()) {%>
                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=vente/bondecommande/bondecommande-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&acte=update&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <% } %>
                            <% if (f.getEtat() >= ConstanteEtat.getEtatValider()) {%>
                                <!--a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=bondelivraison-client/bondelivraison-client-saisie.jsp&idbc_client=" + request.getParameter("id") + "&classe=" + classe%> " style="margin-right: 10px">Livrer</a-->
                                <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/vente-saisie.jsp&idBC=" + request.getParameter("id")%> " style="margin-right: 10px">Facturer</a>
<%--                                <a class="btn btn-warning pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Facturer</a>--%>
                                    <% if (f.getEtat() == ConstanteEtat.getEtatValider()) {%>
                                    <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/bondecommande/apresPreparer.jsp&id=" + request.getParameter("id") + "&classe=" + classe%>" style="margin-right: 10px">Pr&eacute;parer</a>
                                <% }} %>
                                <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj=" + pc.getChampByName("designation").getValeur() %>" style="margin-right: 10px;">Attacher Fichier</a>
<%--                                <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=fiche_vente_bc&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer</a>--%>
<%--                                <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=preparation&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer Pr&eacute;paration</a>--%>
                                <%
                                    String pdfBase   = request.getContextPath() + "/ExportPDF?action=fiche_vente_bc&id="
                                            + URLEncoder.encode(id, "UTF-8");
                                    String pdfApercu = pdfBase + "&inline=1";
                                %>
                                <button type="button" class="btn btn-tertiary pull-right"
                                        data-url="<%= pdfApercu %>"
                                        data-dl="<%= pdfBase %>"
                                        data-kind="pdf"
                                        data-name="BC <%= id %>"
                                        onclick="openPreview(this.dataset.url, this.dataset.kind, this.dataset.name, this.dataset.dl)"
                                        style="margin-right: 10px">Imprimer en PDF</button>

                                <%
                                    String pdfBase2   = request.getContextPath() + "/ExportPDF?action=preparation&id="
                                            + URLEncoder.encode(id, "UTF-8");
                                    String pdfApercu2 = pdfBase2 + "&inline=1";
                                %>
                                <button type="button" class="btn btn-tertiary pull-right"
                                        data-url="<%= pdfApercu2 %>"
                                        data-dl="<%= pdfBase2 %>"
                                        data-kind="pdf"
                                        data-name="Pr&eacute;paration <%= id %>"
                                        onclick="openPreview(this.dataset.url, this.dataset.kind, this.dataset.name, this.dataset.dl)"
                                        style="margin-right: 10px">Imprimer Pr&eacute;paration</button>
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
                        <li class="<%=map.get("inc/bondecommande-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondecommande-detail">Détails </a></li>
    <%--                    <li class="<%=map.get("inc/bondecommande-liste-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondecommande-liste-detail">Détails de Fabrication</a></li>--%>
                    <%-- <li class="<%=map.get("inc/bondecommande-besoins")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondecommande-besoins">Besoins</a></li> --%>
                    <li class="<%=map.get("inc/livraisondetail-bc")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/livraisondetail-bc">Livraisons</a></li>
<%--                    <li class="<%=map.get("inc/fabricationdetail-bc")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabricationdetail-bc">Fabrications</a></li>--%>
<%--                    <li class="<%=map.get("inc/ordre-fabrication-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/ordre-fabrication-details">Ordre de Fabrication</a></li>--%>
                    <li class="<%=map.get("inc/vente-cpl-visee")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/vente-cpl-visee">Factures</a></li>
                        <li class="<%=map.get("../../historique/inc/historique-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=../../historique/inc/historique-liste">Historique</a></li>
                    </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idbc" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="box">
                <h2 class="box-title" style="margin-left: 10px;">Les fichiers attach&eacute;s</h2>
                <div class="box-body" style="padding: 0 20px 20px 20px;">
                    <table class="table table-striped table-bordered table-condensed tree" style="color: #4e4e4e;">
                        <thead>
                        <tr>
                            <th class='contenuetable'></th>
                            <th class='contenuetable'>Libell&eacute;</th>
                            <th class='contenuetable'>Fichier</th>
                            <th class='contenuetable'>Date d'upload</th>
                            <th class='contenuetable'>T&eacute;l&eacute;charger</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%if (fichiers == null || fichiers.length == 0) { %>
                        <tr>
                            <td colspan="5" style="text-align: center;"><strong>Aucun fichier</strong></td>
                        </tr>
                        <%} else {
                            for (AttacherFichier fichier : fichiers) {%>
                        <tr class="treegrid-1 treegrid-expanded">
                            <td><span class="treegrid-expander glyphicon glyphicon-minus"></span></td>
                            <td><%=fichier.getChemin()%></td>
                            <td><%=Utilitaire.champNull(fichier.getLibelle())%></td>
                            <td><%=fichier.getDaty()%></td>
                            <td>
                                <a href="../FileManager2?parent=<%= "/" + dossier + "/" + fichier.getChemin() %>" class="btn btn-success">T&eacute;l&eacute;charger</a>
                            </td>
                        </tr>
                        <%}
                        }%>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    </div>
</div>


<%
	} catch (Exception e) {
		e.printStackTrace();
%>
    <script language="JavaScript">
        alert('<%=e.getMessage()%>');
        history.back();
    </script>
<% }%>
