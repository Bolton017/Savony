<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="faturefournisseur.proforma.ProformaFournisseurCpl" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="fichier.AttacherFichier" %>
<%@ page import="uploadbean.UploadService" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="utils.ConstanteSavonnerie" %>
<%@ page import="java.net.URLEncoder" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    ProformaFournisseurCpl o = new ProformaFournisseurCpl();
    o.setNomTable("PROFORMAFOURNISSEUR_MERECPL2");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un proforma");
    o = (ProformaFournisseurCpl) pc.getBase();
    String id = o.getId();
    String devise = o.getIdDevise();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("designation").setLibelle("D&eacute;signation");
    pc.getChampByName("reference").setLibelle("R&eacute;f&eacute;rence");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("modepaiementlib").setLibelle("Mode de paiement");
    pc.getChampByName("idDeviselib").setLibelle("Devise");
    pc.getChampByName("fournisseurlib").setLibelle("Fournisseur");
    pc.getChampByName("fournisseurLib").setLien((String) session.getValue("lien") + "?but=fournisseur/fournisseur-fiche.jsp&id=" + o.getFournisseur(), "nom=");
    pc.getChampByName("echeance").setLibelle("&Eacute;ch&eacute;ance");
    pc.getChampByName("dateEcheance").setLibelle("Date d'&eacute;ch&eacute;ance de paiement");
    pc.getChampByName("montantTVA").setLibelle("Montant TVA " + devise);
    pc.getChampByName("montantHT").setLibelle("Montant HT "+devise);
    pc.getChampByName("montantTTC").setLibelle("Montant TTC "+devise);
    pc.getChampByName("montantTTCARIARY").setLibelle("Montant TTC");
    if (devise.compareToIgnoreCase("AR")==0) {
        pc.getChampByName("montantTTCARIARY").setVisible(false);
    }
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("remise").setLibelle("Remise en %");
    pc.getChampByName("remise").setVisible(false);
    pc.getChampByName("remisemontant").setLibelle("Remise en Montant");
    pc.getChampByName("remisemontant").setVisible(false);
    pc.getChampByName("idOrigine").setLibelle("ID Origine");
    pc.getChampByName("modepaiement").setVisible(false);
    pc.getChampByName("fournisseur").setVisible(false);
    pc.getChampByName("idDevise").setVisible(false);
    pc.getChampByName("etat").setVisible(false);
    if(pc.getChampByName("idOrigine").getValeur().startsWith("DMD")){
      pc.getChampByName("idOrigine").setLien(lien+"?but=facturefournisseur/dmdachat/dmdachat-fiche.jsp", "id=");
    }
    String pageActuel = "facturefournisseur/proforma/proforma-fiche.jsp";


    String[] ordre = {"id","designation","reference","daty","remarque","modepaiementlib","idDeviselib","fournisseurlib","echeance","dateEcheance","montantTVA","montantHT","montantTTC","montantTTCARIARY","etatlib"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "facturefournisseur/proforma/proforma-saisie.jsp&acte=update";
    String pageApresDelete = "facturefournisseur/proforma/proforma-liste.jsp";
    String classe = "faturefournisseur.proforma.ProformaFournisseur";

    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/proforma-liste-detail", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/proforma-liste-detail";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";

    ProformaFournisseurCpl proforma = (ProformaFournisseurCpl) pc.getBase();
    int etat = proforma.getEtat();

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
    String dossier = pc.getBase().getClass().getSimpleName();
    String designationEncode = java.net.URLEncoder.encode(pc.getChampByName("designation").getValeur(), "UTF-8");
    String idParam = request.getParameter("id");
    String role = u.getUser().getIdrole();
    boolean afficher = role.equalsIgnoreCase(ConstanteSavonnerie.ROLE_CG)
        || role.equalsIgnoreCase(ConstanteSavonnerie.ROLE_DG)
        || role.equalsIgnoreCase(ConstanteSavonnerie.ROLE_RESPACHAT)
        || role.equalsIgnoreCase(ConstanteSavonnerie.ROLE_CHEFFAB)
        || role.equalsIgnoreCase(ConstanteSavonnerie.ROLE_CHEF_DEP);
%>

<div class="content-wrapper">

<h1 class="box-title"><a href=<%= lien + "?but=" + pageRetour%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
                            <%-- if (afficher && etat < 11) { %>
                                <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=facturefournisseur/proforma/proforma-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                            <% } --%>
                            <% if( etat < 11 ) { %>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id+"&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <% } %>
                            <% if(etat >= 11) {%>
    <%--                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=facturefournisseur/proforma/proforma-saisie.jsp&id=" + request.getParameter("id")%> " style="margin-right: 10px">R&eacute;ceptionner</a>--%>
                                <!-- <a class="btn btn-info pull-right"  href="<%=(String) session.getValue("lien") + "?but=facturefournisseur/proforma/apresFacturer.jsp&id=" + id%>"style="margin: 5px 10px 0 0">Facturer</a> -->
                                <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=facturefournisseur/proforma/apresGenerer.jsp&p=fiche&id="+pc.getChampByName("id").getValeur()%>" style="margin-right: 10px">G&eacute;n&eacute;rer BC</a>
                            <% } %>
<%--                            <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=proformaFF&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer</a>--%>
                                <%
                                    String pdfBase   = request.getContextPath() + "/ExportPDF?action=proformaFF&id="
                                            + URLEncoder.encode(id, "UTF-8");
                                    String pdfApercu = pdfBase + "&inline=1";
                                %>
                                <button type="button" class="btn btn-tertiary pull-right"
                                        data-url="<%= pdfApercu %>"
                                        data-dl="<%= pdfBase %>"
                                        data-kind="pdf"
                                        data-name="Proforma <%= id %>"
                                        onclick="openPreview(this.dataset.url, this.dataset.kind, this.dataset.name, this.dataset.dl)"
                                        style="margin-right: 10px">Imprimer</button>
                                <a class="btn btn-tertiary pull-right" href="<%= lien + "?but=pageupload.jsp&id=" + idParam + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&nomprj=" + designationEncode %>" style="margin-right: 10px;">Attacher Fichier</a>
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
                    <li class="<%=map.get("inc/proforma-liste-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/proforma-liste-detail">Détails</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idFactureFournisseur" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
    <%=pc.getHtmlAttacherFichier()%>
</div>




<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

