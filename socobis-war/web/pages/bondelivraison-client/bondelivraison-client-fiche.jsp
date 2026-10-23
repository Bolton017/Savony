<%--
    Document   : bondelivraison-client-fiche
    Created on : 29 juil. 2024, 17:39:44
    Author     : drana
--%>

<%@page import="java.util.*"%>
<%@page import="annexe.Unite"%>
<%@page import="magasin.Magasin"%>
<%@page import="user.*"%>
<%@page import="vente.*"%>
<%@page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@page import="fichier.AttacherFichier"%>
<%@page import="uploadbean.UploadService"%>
<%@page import="utils.ConstanteEtatStation"%>
<%@ page import="java.net.URLEncoder" %>


<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");
%>
<%
try{
    As_BondeLivraisonClient_Cpl f = new As_BondeLivraisonClient_Cpl();
    f.setNomTable("AS_BONDELIVRAISON_CLIENT_CPL");
    PageConsulte pc = new PageConsulte(f, request, u);
    pc.setTitre("Fiche de bon de livraison client");
    As_BondeLivraisonClient_Cpl blf=(As_BondeLivraisonClient_Cpl)pc.getBase();
    String id=blf.getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("daty").setLibelle("date");
    pc.getChampByName("idclientlib").setLibelle("Client");
    pc.getChampByName("idClientLib").setLien((String) session.getValue("lien") + "?but=client/client-fiche.jsp&id=" + blf.getIdclient(), "nom=");
    pc.getChampByName("idClient").setLibelle("ID Client");
    pc.getChampByName("idClient").setVisible(false);
//    pc.getChampByName("idClient").setLien(lien+"?but=client/client-fiche.jsp", "id=");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("designation").setVisible(false);
    pc.getChampByName("idVente").setLibelle("Ref. Facture");
    pc.getChampByName("idVente").setLien(lien+"?but=vente/vente-fiche.jsp", "id=");
    pc.getChampByName("idBC").setLibelle("Ref. Bon de Commande");
    pc.getChampByName("magasin").setLibelle("Magasin");
    pc.getChampByName("vehicule").setLibelle("Voiture");
    pc.getChampByName("chauffeur").setLibelle("&Eacute;quipe de livraison");
    pc.getChampByName("description").setLibelle("Description");
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    //pc.getChampByName("etat").setAutre("readonly");
     pc.getChampByName("idVente").setAutre("readonly");
     pc.getChampByName("idBC").setAutre("readonly");
     pc.getChampByName("idMagasin").setAutre("readonly");
     pc.getChampByName("idMagasin").setVisible(false);
       pc.getChampByName("etat").setVisible(false);
     pc.getChampByName("idBC").setLien(lien+"?but=vente/bondecommande/bondecommande-fiche.jsp", "id=");
    String[] ordre = {
            "daty",
            "idBC",
            "idVente",
            "magasin",
            "idclientlib",
            "idrepresentantLib",
            "description",
            "vehicule",
            "chauffeur",
            "etatLib",
            "remarque"
    };
    pc.setOrdre(ordre);

    String pageActuel = "bondelivraison-client/bondelivraison-client-fiche.jsp";

    String pageModif = "bondelivraison-client/bondelivraison-client-saisie.jsp";
    String classe = "vente.As_BondeLivraisonClient";

    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/bondelivraisonclient-liste-detail", "");
    map.put("../historique/inc/historique-liste", "");
    String tab = request.getParameter("tab");

    if (tab == null || tab.trim().isEmpty()) {
        tab = "inc/bondelivraisonclient-liste-detail";
    }
//    if (!map.containsKey(tab)) {
//        tab = "inc/bondelivraisonclient-liste-detail";
//    }
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
    String dossier = "bondelivraisonclient/files/" + projectName;
    String idVente = pc.getChampByName("idVente").getValeur();
    String idBc = pc.getChampByName("idBC").getValeur();

    String paramsFacture = "";
    if (idVente != null && !idVente.isEmpty()) {
        paramsFacture = "&idv=" + idVente;
    } else {
        paramsFacture = "&ido=" + idBc;
    }
%>

<div class="content-wrapper">

    <h1 class="box-title"><a href=<%= lien + "?but=bondelivraison-client/bondelivraison-client-fiche.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

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
                            <a class="btn btn-primary pull-left"  style="margin-left: 10px;" href="<%= lien+ "?but=transport/course-saisie.jsp&livraison="+request.getParameter("id") %>">
                                G&eacute;n&eacute;rer Course
                            </a>
                            <% if(blf.getEtat() < ConstanteEtatStation.getEtatPreparer()){%>
                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=bondelivraison-client/apresLivraisonBC.jsp&acte=valider_preparation&id=" + request.getParameter("id") + "&bute=bondelivraison-client/bondelivraison-client-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Valider le chargement</a>
                            <% } %>
                            <% if(blf.getEtat() == ConstanteEtatStation.getEtatPreparer()){%>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=bondelivraison-client/bondelivraison-client-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Valider</a>
                             <% } %>


                            <% if(blf.getEtat() == ConstanteEtat.getEtatValider()){%>

                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=stock/mvtstock-saisie.jsp&idBLC=" + request.getParameter("id") + "&classe=" + classe %> " style="margin-right: 10px">Livrer</a>
                            <% } %>
                            <% if(blf.getEtat() < ConstanteEtat.getEtatValider()){%>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id+"&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <% } %>

                            <% if(blf.getEtat() >= ConstanteEtat.getEtatValider()){ %>
                                <%--<a class="btn btn-primary pull-right"  href="<%=(String) session.getValue("lien") + "?but=apres-livraison-generer-mvtstock.jsp?idBLC=" + id%>" >G&eacute;n&eacute;rer mouvement de stock</a>--%>

                              <%  if(blf.getIdvente()==null||blf.getIdvente().compareTo("")==0) {
                            %>
                               <!-- <a class="btn btn-primary pull-right" href="<%= lien + "?but=vente/vente-saisie.jsp&id="+pc.getChampByName("id").getValeur()+"&idClient="+pc.getChampByName("idClient").getValeur()+"&idPoint="+pc.getChampByName("idMagasin").getValeur()%>" style="margin-right: 10px">Facturer</a>-->
                            <% } %>
                            <% } %>
<%--                            <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=imprimerBL&id=<%=request.getParameter("id")%>" >Imprimer</a>--%>
                            <%
                                String pdfBase   = request.getContextPath() + "/ExportPDF?action=imprimerBL&id="
                                        + URLEncoder.encode(id, "UTF-8");
                                String pdfApercu = pdfBase + "&inline=1";
                            %>
                            <button type="button" class="btn btn-tertiary pull-right"
                                    data-url="<%= pdfApercu %>"
                                    data-dl="<%= pdfBase %>"
                                    data-kind="pdf"
                                    data-name="Bon de livraison <%= id %>"
                                    onclick="openPreview(this.dataset.url, this.dataset.kind, this.dataset.name, this.dataset.dl)"
                                    style="margin-right: 10px">Imprimer</button>
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj=" + pc.getChampByName("designation").getValeur() %>" style="margin-right: 10px;">Attacher Fichier</a>

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
                    <li class="<%=map.get("inc/bondelivraisonclient-liste-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondelivraisonclient-liste-detail">D&eacute;tails</a></li>
                    <li class="<%=map.get("inc/mouvementstock-liste-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/mouvementstock-liste-detail">Mouvement de Stock</a></li>
                    <li class="<%=map.get("../vente/bondecommande/inc/vente-cpl-visee")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %><%= paramsFacture %>&tab=../vente/bondecommande/inc/vente-cpl-visee">Facture</a></li>
<%--                    <li class="<%=map.get("inc/rapprochement")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/rapprochement">Rapprochement</a></li>--%>
                    <li class="<%=map.get("../historique/inc/historique-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=../historique/inc/historique-liste">Historique</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="numbl" value="<%= id %>" />
                    </jsp:include>
                    </div>
                </div>
            </div>

    </div>
    <div class="row m-0">
        <div class="col-md-12 cardradius">
            <div class="box-title">
                <h2 class="h520pxSemibold m-0">Les fichiers attach&eacute;s</h2>
            </div>
            <div class="box-body">
                <table class="table table-striped table-bordered table-condensed table-responsive tree">
                    <thead>
                    <tr>
                        <th class="contenuetable"></th>
                        <th class="contenuetable">Libell&eacute;</th>
                        <th class="contenuetable">Fichier</th>
                        <th class="contenuetable">Voir</th>
                        <th class="contenuetable">#</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%if (fichiers == null || fichiers.length == 0) {%>
                    <tr>
                        <td colspan="5" style="text-align: center;"><strong>Aucun fichier</strong></td>
                    </tr>
                    <%} else {
                        for (AttacherFichier fichier : fichiers) {%>
                    <tr class="treegrid-1 treegrid-expanded">
                        <td><span class="treegrid-expander glyphicon glyphicon-minus"></span></td>
                        <td><%=fichier.getChemin()%></td>
                        <td><%=Utilitaire.champNull(fichier.getLibelle())%></td>
                        <td><a href="#" class="btn btn-primary" onclick="javascript:pagePopUp('<%=cdn + dossier + "/" + fichier.getChemin()%>')">Voir</a></td>
                        <td></td>
                    </tr>
                    <%}
                    }%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>



<%
	} catch (Exception e) {
		e.printStackTrace();

            }%>