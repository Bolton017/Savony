<%@page import="proforma.ProformaDetailsLib"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="constante.ConstanteEtat" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@page import="fichier.AttacherFichier"%>
<%@page import="configuration.*"%>
<%@page import="uploadbean.*"%>

<%
    try {
        //Information sur les navigations via la page
        String lien = (String) session.getValue("lien");
        String classe = "proforma.ProformaDetailsLib";
        String pageActuel = "vente/proforma/proforma-detail-fiche.jsp";

        //Information sur la fiche
        ProformaDetailsLib dp = new ProformaDetailsLib();
        ProformaDetailsLib base = new ProformaDetailsLib();

        dp.setNomTable("PROFORMADETAILS_CPL");
        PageConsulte pc = new PageConsulte(dp, request, (user.UserEJB) session.getValue("u"));
        String id = request.getParameter("id");
        pc.getChampByName("id").setLibelle("Id");
        pc.getChampByName("designation").setLibelle("D&eacute;signation");
        pc.getChampByName("idDevise").setLibelle("Devise");
        pc.getChampByName("idProforma").setLibelle("Proforma");

        pc.getChampByName("idDemandePrixFille").setLien(lien+"?but=vente/demandeprix/demandeprix-fille-fiche.jsp", "id=");
        
        pc.getChampByName("idDemandePrixFille").setLibelle("DemandePrixFille");
        pc.getChampByName("idOrigine").setLibelle("Origine");
        pc.getChampByName("idProduitLib").setLibelle("Produit");
        pc.getChampByName("idProformaLib").setLibelle("D&eacute;signation");
        pc.getChampByName("uniteLib").setLibelle("Unit&eacute;");
        pc.getChampByName("remisemontant").setLibelle("Montant remise");
        pc.getChampByName("montanttotal").setLibelle("Montant total");
        pc.getChampByName("montanttva").setLibelle("Montant (TVA)");
        pc.getChampByName("montantttc").setLibelle("Montant (TTC)");
        pc.getChampByName("compte").setLibelle("Compte");
        pc.getChampByName("pu").setLibelle("Prix Unitaire");
        pc.getChampByName("remise").setLibelle("Remise");
        pc.getChampByName("tva").setLibelle("TVA");
        pc.getChampByName("qte").setLibelle("Quantit&eacute;");
        pc.getChampByName("puAchat").setLibelle("Prix Unitaire d' Achat");
        pc.getChampByName("puVente").setLibelle("Prix Unitaire de Vente");
        pc.getChampByName("puRevient").setLibelle("Prix Unitaire de Revient");
        pc.getChampByName("tauxDeChange").setLibelle("Taux de change");
        pc.getChampByName("datedebut").setLibelle("Date de début");
        pc.getChampByName("idDemandePrixFille").setVisible(false);
        pc.getChampByName("designation").setVisible(false);
        pc.getChampByName("unite").setVisible(false);
        pc.getChampByName("puTotal").setVisible(false);
        pc.getChampByName("idProforma").setLien(lien+"?but=vente/proforma/proforma-fiche.jsp", "id=");
        pc.setTitre("Fiche des d&eacute;tails du proforma");

   //     pc.getChampByName("idDevis").setLibelle("Devis");

     //   pc.getChampByName("idDevis").setLien(lien+"?but=devis/devis-fiche.jsp", "id=");

        pc.getChampByName("idProduit").setVisible(false);

        Onglet onglet = new Onglet("recapitulations");
        onglet.setDossier("inc");
        Map<String, String> map = new HashMap<String, String>();
        map.put("recapitulations", "");

     /*   String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "recapitulations";
        }
        map.put(tab, "active");
        tab = "inc/" + tab + ".jsp";
*/
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
        String dossierTemp = "vente/files/"+projectName;
        String dossier = dossierTemp;

        base = (ProformaDetailsLib) pc.getBase();
        double vente = base.getQte() * base.getPuVente();
        double qte = base.getQte();
%>
<div class="content-wrapper">
    <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=vente/vente-liste.jsp"><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-12 mb-5">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj="+ pc.getChampByName("designation").getValeur() %>" style="margin-right: 10px;/*! display: block; *//*! margin: 5px auto; *//*! width: 111px; *//*! max-width: 111px; */">Attacher Fichier</a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                </ul>
                <div class="tab-content">
                </div>
            </div>

        </div>
    </div-->

    <div class="row m-0">
<%--        <div class="col-md-1"></div>--%>
            <div class="col-md-12 mb-5 ">
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
                                    <th class='contenuetable'>Telecharger</th>
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
                                        <a href="../FileManager2?parent=<%= "/"+dossier + "/" +fichier.getChemin()  %>" class="btn btn-success" >Telecharger</a>
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
    }%>
