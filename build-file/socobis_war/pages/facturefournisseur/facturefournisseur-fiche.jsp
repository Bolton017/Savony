<%@page import="fichier.AttacherFichier"%>
<%@page import="uploadbean.UploadService"%>
<%@page import="faturefournisseur.FactureFournisseurCpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="utils.ConstanteAsync" %>
<%@ page import="java.net.URLEncoder" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    
%>
<%
    try{
    FactureFournisseurCpl f = new FactureFournisseurCpl();
    f.setNomTable("FACTUREFOURNISSEURCPL");
    PageConsulte pc = new PageConsulte(f, request, u);
    pc.setTitre("D&eacute;tail de la facture fournisseur");
    f=(FactureFournisseurCpl)pc.getBase();
    request.setAttribute("factureFournisseur", f);
    String id=pc.getBase().getTuppleID();
    String devise = f.getIdDevise();
    pc.getChampByName("Id").setLibelle("Id");
    pc.getChampByName("idMagasinLib").setLibelle("Magasin");
    pc.getChampByName("numero").setLibelle("Num&eacute;ro");
    pc.getChampByName("idFournisseurLib").setLibelle("Fournisseur");
    pc.getChampByName("idFournisseurLib").setLien((String) session.getValue("lien") + "?but=fournisseur/fournisseur-fiche.jsp&id=" + f.getIdFournisseur(), "nom=");
    pc.getChampByName("designation").setLibelle("d&eacute;signation");
    pc.getChampByName("reference").setLibelle("r&eacute;f&eacute;rence");
    pc.getChampByName("idModePaiementLib").setLibelle("Mode de paiement");
    pc.getChampByName("montantPaye").setLibelle("Montant Pay&eacute;");
    pc.getChampByName("montantReste").setLibelle("Montant Restant");
    pc.getChampByName("dateEcheancePaiement").setLibelle("Date pr&eacutevisionnelle de paiement");
    pc.getChampByName("idDevise").setLibelle("Devise");
    pc.getChampByName("montanttva").setLibelle("Montant TVA " + devise);
    pc.getChampByName("montantttc").setLibelle("Montant TTC " + devise);
    pc.getChampByName("montantht").setLibelle("Montant HT " +devise);
    pc.getChampByName("montantttcAr").setLibelle("Montant TTC");
    if (devise.compareToIgnoreCase("AR") == 0) {
        pc.getChampByName("montantttcAr").setVisible(false);
    }
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("tauxdechange").setLibelle("Taux de change");
    pc.getChampByName("tauxdechange").setVisible(false);
    pc.getChampByName("typefacture").setLibelle("Type de Facture");
	pc.getChampByName("idBc").setLibelle("R&eacute;f&eacute;rence du bon de commande");
    pc.getChampByName("idecriture").setLien(request.getContextPath() + "/pages/module.jsp?but=compta/ecriture/ecriture-fiche.jsp", "id=");
    pc.getChampByName("taux").setVisible(false);
    pc.getChampByName("service").setVisible(false);
	pc.getChampByName("idMagasin").setVisible(false);
	pc.getChampByName("idFournisseur").setVisible(false);
	pc.getChampByName("idModePaiement").setVisible(false);
	pc.getChampByName("etatLib").setVisible(false);
    pc.getChampByName("devise").setVisible(false);
    pc.getChampByName("idPrevision").setVisible(false);
    pc.getChampByName("idObjet").setVisible(false);
    pc.getChampByName("idref").setVisible(false);
    pc.getChampByName("typeachat").setVisible(false);
    pc.getChampByName("idtypefacture").setVisible(false);
    pc.getChampByName("idfactureprincipale").setVisible(false);
    pc.getChampByName("typeFactureFournisseurLib").setVisible(false);
    pc.getChampByName("typeFactureFournisseur").setVisible(false);
//    pc.getChampByName("remiseMontant").setLibelle("Remise Montant");
    pc.getChampByName("remise").setLibelle("Remise en %");
    pc.getChampByName("idfactureprincipale").setLibelle("Facture principale");

    String lien = (String) session.getValue("lien");
    if(pc.getChampByName("idfactureprincipale").getValeur() != null && !pc.getChampByName("idfactureprincipale").getValeur().equals("")) {
        pc.getChampByName("idfactureprincipale").setVisible(true);
        if(pc.getChampByName("idfactureprincipale").getValeur().startsWith("VNT")) {
            pc.getChampByName("idfactureprincipale").setLien(lien+"?but=vente/vente-fiche.jsp", "id=");
        }else{
            pc.getChampByName("idfactureprincipale").setLien(lien+"?but=facturefournisseur/facturefournisseur-fiche.jsp", "id=");
        }
    }
    String pageActuel = "facturefournisseur/facturefournisseur-fiche.jsp";

    pc.getChampByName("idBc").setLien(lien+"?but=bondecommande/bondecommande-fiche.jsp", "id=");

    String pageModif = "facturefournisseur/facturefournisseur-saisie.jsp";
    String pageRepartition= "facturefournisseur/repartition-frais-divers.jsp";
    String classe = "faturefournisseur.FactureFournisseur";
    
    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/facture-fournisseur-liste-detail", "");
    map.put("inc/mvtcaisse-details", "");
    map.put("../compta/ecriture/inc/sous-ecriture-detail", "");
    map.put("inc/facture-fournisseur-bl.jsp", "");
    map.put("inc/facturefournisseur-lier", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/facture-fournisseur-liste-detail";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    String idDevise = ((FactureFournisseurCpl)pc.getBase()).getIdDevise();
    request.setAttribute("idDevise", idDevise);
    
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
        String dossierTemp = "achat/files/"+projectName;
        String dossier = dossierTemp;

%>

<div class="content-wrapper">
   
    <h1 class="box-title"><a href=<%= lien + "?but=facturefournisseur/facturefournisseur-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

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
                            <% if (f.getEtat() < 11) { %>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=facturefournisseur/facturefournisseur-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id+"&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <% }
                            %>
                            <% if (f.getEtat() >= 11) { %>
                                <!--<a class="btn btn-primary pull-right" href="<%= lien + "?but="+ "facturefournisseur/apresLivraisonFacture.jsp" +"&id=" + id%>" style="margin-right: 10px">R&eacute;ceptionner</a>-->
                                <!--<a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=bondelivraison/bondelivraison-saisie.jsp&idfacture="+id%> " style="margin-right: 10px">R&eacute;ceptionner</a>-->
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ "facturefournisseur/avoir/avoirachat-saisie.jsp&idFactureFournisseur=" + id %>" style="margin-right: 10px">G&eacute;n&eacute;rer Avoir</a>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ "caisse/mvt/mvtCaisse-saisie-sortie-fc.jsp" +"&idOrigine=" + id+"&devise="+f.getIdDevise()+"&montant="+f.getMontantreste()+"&tiers="+f.getIdFournisseur()+"&idPrevision="+f.getIdPrevision()%>" style="margin-right: 10px">D&eacute;caisser</a>
                                <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/planPaiement-saisie.jsp&idvt="+id+"&classe=faturefournisseur.FactureFournisseur&table="+f.getNomTable()+"&bute="+pageActuel%>" style="margin-right: 10px">Plan de Paiement</a>
                                <% if(f.getIdtypefacture() != null && !f.getIdtypefacture().equals(ConstanteAsync.TYPE_FRAIS_ACCESSOIRE)) { %>
                                    <a class="btn btn-secondary pull-right" href="<%= lien + "?but=facturefournisseur/fraisaccessoire-saisie.jsp&idFactureFournisseur=" + id%>" style="margin-right: 10px;">Ajouter Frais accessoire</a>
                                    <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageRepartition +"&id=" + id%>" style="margin-right: 10px">R&eacute;partition frais accessoire</a>
                                    <a class="btn btn-secondary pull-right"  href="<%= (String) session.getValue("lien") + "?but=facturefournisseur/apresRecalculer.jsp&id=" + request.getParameter("id") + "&bute=facturefournisseur/facturefournisseur-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Re-Calculer frais accessoire</a>
                            <% }
                            }
                            %>
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj="+ pc.getChampByName("designation").getValeur() %>" style="margin-right: 10px;/*! display: block; *//*! margin: 5px auto; *//*! width: 111px; *//*! max-width: 111px; */">Attacher Fichier</a>
                            <!----<a class="btn btn-secondary pull-right"  href="<%= (String) session.getValue("lien") + "?but=facture/reference-facture-saisie.jsp&type=facture&id="+id%>" style="margin-right: 10px">Ajouter r&eacute;f&eacute;rence Facture</a>---->
<%--                            <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=fiche_ff&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer</a>--%>
                            <%
                                String pdfBase   = request.getContextPath() + "/ExportPDF?action=fiche_ff&id="
                                        + URLEncoder.encode(id, "UTF-8");
                                String pdfApercu = pdfBase + "&inline=1";
                            %>
                            <button type="button" class="btn btn-tertiary pull-right"
                                    data-url="<%= pdfApercu %>"
                                    data-dl="<%= pdfBase %>"
                                    data-kind="pdf"
                                    data-name="Facture Fournisseur <%= id %>"
                                    onclick="openPreview(this.dataset.url, this.dataset.kind, this.dataset.name, this.dataset.dl)"
                                    style="margin-right: 10px">Imprimer</button>
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
                    <!-- a modifier -->
                    <li class="<%=map.get("inc/facture-fournisseur-liste-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/facture-fournisseur-liste-detail">Détails</a></li>
                    <li class="<%=map.get("inc/facture-fournisseur-bl")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/facture-fournisseur-bl">Bon de réception rattaché</a></li>
                    <li class="<%=map.get("../compta/ecriture/inc/sous-ecriture-detail")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=../compta/ecriture/inc/sous-ecriture-detail">&Eacute;critures</a></li>
                       
                    <li class="<%=map.get("inc/mvtcaisse-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=inc/mvtcaisse-details">Mouvement de caisse</a></li>
                    <li class="<%=map.get("inc/liste-prevision")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=inc/liste-prevision">Plan de paiements</a></li>
                    <li class="<%=map.get("inc/facturefournisseur-lier")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=inc/facturefournisseur-lier">Frais Accessoire</a></li>
                    <li class="<%=map.get("inc/avoir")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/avoir">Avoir(s) </a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idFactureFournisseur" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
    <div class="row m-0">
        <%--        <div class="col-md-1"></div>--%>
        <div class="col-md-12 bottom-vente-fiche nopadding">
            <div class="box">
                <h2 class="box-title" style="margin-left: 10px;">Les fichiers attach&eacute;s</h2>
                <div class="box-body" style="padding: 0 20px 20px 20px;">
                    <table class="table table-striped table-bordered table-condensed tree" style="color: #4e4e4e;">
                        <thead>
                        <tr>
                            <th class='contenuetable'></th>
                            <th class='contenuetable'>Libell&eacute;</th>
                            <th class='contenuetable'>Fichier</th>
                            <th class='contenuetable'>Date d`upload</th>
                            <th class='contenuetable'>T&eacute;l&eacute;charger</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%if (fichiers == null || fichiers.length == 0) { %>
                        <tr>
                            <td colspan="3" style="text-align: center;"><strong>Aucun fichier</strong></td>
                        </tr>
                        <%} else {
                            for (AttacherFichier fichier : fichiers) {%>
                        <tr class="treegrid-1 treegrid-expanded">
                            <td><span class="treegrid-expander glyphicon glyphicon-minus"></span></td>
                            <td><%=fichier.getChemin()%></td>
                            <td><%=Utilitaire.champNull(fichier.getLibelle())%></td>
                            <td><%=fichier.getDaty()%></td>
                            <td>
                                <!--                                    <form action="../UploadDownloadFileServlet" method="get">
                                            <input type="submit" value="download">
                                            <input type="hidden" name="fileName" value="<%=cdn + dossier + "/" + fichier.getChemin()%>">
                                        </form>-->
                                <a href="../FileManager2?parent=<%= "/"+dossier + "/" +fichier.getChemin()  %>" class="btn btn-success" >T&eacute;l&eacute;charger</a>
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
<style>
    .bottom-vente-fiche {
        padding: 0 30px 0 30px; !important;
    }
</style>

<% } catch(Exception e) { 
    e.printStackTrace();
    throw e;
} %>