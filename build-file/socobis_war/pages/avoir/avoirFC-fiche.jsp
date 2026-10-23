<%-- 
    Document   : avoirFC-fiche
    Created on : 2 août 2024, 15:56:27
    Author     : randr
--%>


<%@page import="avoir.AvoirFCLib"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="fichier.AttacherFichier"%>
<%@page import="uploadbean.UploadService"%>
<%@page import="utils.ConstanteEtatStation"%>
<%
		 try{
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");
    AvoirFCLib avoir = new AvoirFCLib();
    avoir.setNomTable("avoirfclib_cpl");
    PageConsulte pc = new PageConsulte(avoir, request, u);
    pc.setTitre("Fiche de facture d'avoir");
    String pageActuel = "avoir/avoirFC-fiche.jsp";
    avoir =(AvoirFCLib) pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idMagasinLib").setLibelle("Magasin");
    pc.getChampByName("idVente").setLibelle(" Ref. Vente");
    pc.getChampByName("numfact").setLibelle("Num&eacute;ro de la facture");
    pc.getChampByName("idVente").setLien(lien+"?but=vente/vente-fiche.jsp", "id=");
    pc.getChampByName("idVenteLib").setVisible(false);
    pc.getChampByName("idCategorieLib").setLibelle("Cat&eacute;gorie");
    pc.getChampByName("idMotif").setLibelle("Motif");
//    pc.getChampByName("idtypeavoirlib").setLibelle("Type");
     pc.getChampByName("idDevise").setLibelle("Devise");
     pc.getChampByName("idDevise").setVisible(false);
     pc.getChampByName("montantHT").setLibelle("Montant HT ("+ avoir.getIddevise()+")");
     pc.getChampByName("montantTVA").setLibelle("Montant TVA ("+ avoir.getIddevise()+")");
     pc.getChampByName("montantTTC").setLibelle("Montant TTC ("+ avoir.getIddevise()+")");
     pc.getChampByName("resteapayer").setLibelle("Reste &agrave; payer ("+ avoir.getIddevise()+")");

     pc.getChampByName("montantHTAr").setLibelle("Montant HT (Ar)");
    pc.getChampByName("montantTVAAr").setLibelle("Montant TVA (Ar)");
    pc.getChampByName("montantTTCAr").setLibelle("Montant TTC (Ar)");
    pc.getChampByName("resteapayerar").setLibelle("Reste &agrave; payer (Ar)");
    pc.getChampByName("designation").setLibelle("D&eacute;signation");
             pc.getChampByName("typeavoir").setLibelle("Type");
             pc.getChampByName("clientlib").setLibelle("Client");
             pc.getChampByName("clientlib").setLien((String) session.getValue("lien") + "?but=client/client-fiche.jsp&id=" + avoir.getIdClient(), "nom=");
             pc.getChampByName("idorigine").setLibelle("Origine");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");

    if(avoir.getIddevise().compareToIgnoreCase("AR")==0) {
        pc.getChampByName("montantHTAr").setVisible(false);
        pc.getChampByName("montantTVAAr").setVisible(false);
        pc.getChampByName("montantTTCAr").setVisible(false);
        pc.getChampByName("resteapayerar").setVisible(false);
//        pc.getChampByName("montantHT").setLibelle("Montant HT ("+ avoir.getIddevise()+")");
//        pc.getChampByName("montantTVA").setLibelle("Montant TVA ("+ avoir.getIddevise()+")");
//        pc.getChampByName("montantTTC").setLibelle("Montant TTC ("+ avoir.getIddevise()+")");

    }

    pc.getChampByName("idMagasin").setVisible(false);
    //pc.getChampByName("idOrigine").setVisible(false);
    pc.getChampByName("idClient").setVisible(false);
    pc.getChampByName("idMotifLib").setVisible(false);
    pc.getChampByName("idCategorie").setVisible(false);
    pc.getChampByName("tauxdechange").setVisible(false);

    String[] ordre = {
            "daty", "designation", "typeavoir", "idVente","numfact", "clientlib", "idrepresentantLib", "idMagasinLib", "idDevise", "idMotif", "idCategorieLib", "idorigine", "compte", "montantHT", "montantTVA", "montantTTC", "montantHTAr", "montantTVAAr", "montantTTCAr", "resteapayer", "resteapayerar", "etat", "remarque"
    };

    pc.setOrdre(ordre);

    String pageModif = "avoir/avoirFC-saisie.jsp";
    String classe = "avoir.AvoirFC";

    Onglet onglet = new Onglet("page1");
    onglet.setDossier("inc");
    Map<String, String> map = new HashMap<String, String>();
    map.put("avoirfc-details", "");
     map.put("../../historique/inc/historique-liste", "");
     if(avoir.getEtat() >= ConstanteEtat.getEtatValider()) {
        map.put("/../../compta/ecriture/inc/sous-ecriture-detail", "");
        map.put("encaissement-vise-liste", "");
    }
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "avoirfc-details";
    }
    map.put(tab, "active");
    tab = "inc/" + tab + ".jsp";

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
    String dossier = "avoirfc/files/" + projectName;
%>

<div class="content-wrapper">
    <h1 class="box-title"><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-12 mb-5">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <% if(avoir.getEtat() ==1) { %>
                              <a  class="btn btn-danger pull-left"  href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annuler&bute=avoir/avoirFC-fiche.jsp&classe="+classe %>" style="margin-right: 10px !important">Annuler</a>
                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=avoir/avoirFC-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                                 <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&acte=update&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <% } %>

                            <% if(avoir.getEtat()>= 11) { %>
                            <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/mvt/mvtCaisse-saisie-entree-avoir.jsp&idOrigine=" + avoir.getId()%> " style="margin-right: 10px">D&eacute;caisser</a>
                            <% } %>
                            <% if(avoir.getEtat()== 11 && avoir.getResteapayer() == avoir.getMontantTTCAr()) { %>
                                <a class="btn btn-danger pull-left"  href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=annulerVisa&id=" + request.getParameter("id") + "&bute=avoir/avoirFC-fiche.jsp&classe=" + classe %>" >Annuler Visa</a>
                            <% } %>
<%--                             <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=fiche_vente_nouveau_avoir&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer</a>--%>
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj=" + pc.getChampByName("designation").getValeur() %>" style="margin-right: 10px;">Attacher Fichier</a>

                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row m-0">
        <div class="col-md-12 ">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("avoirfc-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=avoirfc-details">D&eacute;tails</a></li>
                    <% if(avoir.getEtat() > 0) { %>
                        <li class="<%=map.get("/../../compta/ecriture/inc/sous-ecriture-detail")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=/../../compta/ecriture/inc/sous-ecriture-detail">&Eacute;critures</a></li>
                        <li class="<%=map.get("encaissement-vise-liste")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=encaissement-vise-liste">Paiement</a></li>
                    <% } %>
                    <li class="<%=map.get("../../historique/inc/historique-liste")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=../../historique/inc/historique-liste">Historique</a></li>
                </ul>
                <div class="tab-content">       
                    <jsp:include page="<%= tab%>" >
                        <jsp:param name="idmere" value="<%= id%>" />
                    </jsp:include>
                </div>
            </div>
        </div>
    </div>
    <div class="row m-0">
        <%--<div class="col-md-1"></div>--%>
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
                                <!--<form action="../UploadDownloadFileServlet" method="get">
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


<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
		history.back();</script>

<% }%>