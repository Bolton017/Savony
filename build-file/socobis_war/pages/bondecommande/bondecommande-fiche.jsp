<%@page import="utils.ConstanteSavonnerie" %>
<%@page import="faturefournisseur.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="fichier.AttacherFichier" %>
<%@page import="uploadbean.UploadService" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="java.net.URLEncoder" %>

<%
    UserEJB u = (user.UserEJB) session.getValue("u");

%>
<%
    try {
        As_BonDeCommandeCpl f = new As_BonDeCommandeCpl();
        f.setNomTable("As_BonDeCommande_MERECPL");
        PageConsulte pc = new PageConsulte(f, request, u);
        pc.setTitre("Bon de commande fournisseur");
        pc.getBase();
        As_BonDeCommandeCpl bc = (As_BonDeCommandeCpl) pc.getBase();
        String id = bc.getId();
        String devise = bc.getIdDevise();

        pc.getChampByName("id").setLibelle("Id");
        pc.getChampByName("daty").setLibelle("date");
        pc.getChampByName("dateLimite").setLibelle("Date limite de livraison");
        pc.getChampByName("reference").setLibelle("R&eacute;f&eacute;rence");
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("designation").setLibelle("d&eacute;signation");
        pc.getChampByName("fournisseurlib").setLibelle("Fournisseur");
        pc.getChampByName("fournisseurLib").setLien((String) session.getValue("lien") + "?but=fournisseur/fournisseur-fiche.jsp&id=" + bc.getFournisseur(), "nom=");
        pc.getChampByName("modepaiementlib").setLibelle("Mode de paiement");
        pc.getChampByName("modepaiementlib").setLibelle("Mode de paiement");
        pc.getChampByName("idDeviselib").setLibelle("Devise");
        pc.getChampByName("montantTVA").setLibelle("Montant TVA");
        pc.getChampByName("remise").setLibelle("Remise (en %)");
        pc.getChampByName("echeance").setLibelle("&Eacute;ch&eacute;ance");
        pc.getChampByName("dateEcheance").setLibelle("Date d'&eacute;ch&eacute;ance de paiement");
        pc.getChampByName("montantTVA").setLibelle("Montant TVA " + devise);
        pc.getChampByName("montantHT").setLibelle("Montant HT " + devise);
        pc.getChampByName("montantTTC").setLibelle("Montant TTC " + devise);
        pc.getChampByName("montantTTCAriary").setLibelle("Montant TTC ");
        if (devise.compareToIgnoreCase("AR") == 0) {
            pc.getChampByName("montantTTCAriary").setVisible(false);
        }
        pc.getChampByName("etat").setLibelle("&Eacute;tat");
        pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
        pc.getChampByName("idMagasinlib").setLibelle("Magasin");
        pc.getChampByName("idOrigine").setLibelle("Origine");

        pc.getChampByName("serviceLib").setLibelle("D&eacute;partement");
        pc.getChampByName("service").setVisible(false);
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("idDevise").setVisible(false);
        pc.getChampByName("fournisseur").setVisible(false);
        pc.getChampByName("modepaiement").setVisible(false);
        pc.getChampByName("idMagasin").setVisible(false);

        String[] ordre = {"id","daty","reference","designation","fournisseurlib","idMagasinLib","modepaiementlib", "idDeviselib","montantTTC","montantHT","montantTVA", "montantTTCAriary", "dateLimite","etatlib" ,"remarque"};
        pc.setOrdre(ordre);

        String pageActuel = "bondecommande/bondecommande-fiche.jsp";

        String lien = (String) session.getValue("lien");
        String pageModif = "bondecommande/bondecommande-saisie.jsp";
        String classe = "faturefournisseur.As_BonDeCommande";

        String idOrigine = pc.getChampByName("idOrigine").getValeur();
        if (idOrigine != null && idOrigine.startsWith("VNT"))pc.getChampByName("idOrigine").setLien(lien+"?but=vente/vente-fiche.jsp&id", "id=");
        if (idOrigine != null && idOrigine.startsWith("RPRC"))pc.getChampByName("idOrigine").setLien(lien+"?but=caisse/report/reportCaisse-fiche.jsp&id", "id=");
        if (idOrigine != null && idOrigine.startsWith("FCF"))pc.getChampByName("idOrigine").setLien(lien+"?but=facturefournisseur/facturefournisseur-fiche.jsp&id", "id=");
        if (idOrigine != null && idOrigine.startsWith("DMDA"))pc.getChampByName("idOrigine").setLien(lien+"?but=facturefournisseur/dmdachat/dmdachat-fiche.jsp", "id=");

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/bondecommande-liste-detail", "");
        map.put("inc/achat-cpl-visee", "");
        map.put("inc/facture-fournisseur", "");
        map.put("inc/commentaire-liste", "");
        map.put("../historique/inc/historique-liste", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/bondecommande-liste-detail";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
//        As_BonDeCommandeCpl bc = (As_BonDeCommandeCpl) pc.getBase();

        // Récupération des fichiers attachés
        AttacherFichier[] fichiers = UploadService.getUploadFile(request.getParameter("id"));
        configuration.CynthiaConf.load();
        String cdn = configuration.CynthiaConf.properties.getProperty("cdnReadUri");
        String projectName = pc.getChampByName("designation").getValeur()
                .replace("'", "_")
                .replace("/", "_")
                .replace("-", "_")
                .replace(":", "_")
                .replace("*", "_")
                .replace(" ", "_");
        String dossier = "As_BonDeCommandeCpl";
        int etat = bc.getEtat();
        String role = u.getUser().getIdrole();
        boolean afficher = false;
        boolean respachat = role.equalsIgnoreCase(ConstanteSavonnerie.ROLE_RESPACHAT);
        boolean cg = role.equalsIgnoreCase(ConstanteSavonnerie.ROLE_CG);
        boolean pdg = role.equalsIgnoreCase(ConstanteSavonnerie.ROLE_DG);

        if(etat == ConstanteEtat.getEtatCreer() && respachat){
            afficher = true;
        }
        if(etat <= ConstanteSavonnerie.VALIDERRSPACHAT && cg){
            afficher = true;
        }
        if(etat <= ConstanteSavonnerie.VALIDERCG && pdg){
            afficher = true;
        }
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=bondecommande/bondecommande-fiche.jsp"%>> <i
            class="fa fa-angle-left"></i></a><%=pc.getTitre()%>
    </h1>

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
                            <% if (afficher) { %>
                            <a class="btn btn-primary pull-right"
                               href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=bondecommande/bondecommande-fiche.jsp&classe=" + classe %> "
                               style="margin-right: 10px">Viser</a>

                            <% }
                                if (etat < 11) { %>
                            <a class="btn btn-secondary pull-right"
                               href="<%= lien + "?but="+ pageModif +"&id=" + id+"&acte=update"%>"
                               style="margin-right: 10px">Modifier</a>

                            <% }
                            %>
                            <% if (etat >= 11) {%>
                            <a class="btn btn-primary pull-right"
                               href="<%= (String) session.getValue("lien") + "?but=bondelivraison/bondelivraison-saisie.jsp&id=" + request.getParameter("id")%> "
                               style="margin-right: 10px">R&eacute;ceptionner</a>
                            <!-- <a class="btn btn-info pull-right"  href="<%=(String) session.getValue("lien") + "?but=bondecommande/apresFacturer.jsp&id=" + id%>"style="margin: 5px 10px 0 0">Facturer</a> -->
                            <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=facturefournisseur/facturefournisseur-saisie.jsp&idbc="+pc.getChampByName("id").getValeur()%>" style="margin-right: 10px">Insertion Facture Fournisseur</a>
<%--                            <a class="btn btn-tertiary pull-right"--%>
<%--                               href="${pageContext.request.contextPath}/ExportPDF?action=fiche_bc&id=<%=request.getParameter("id")%>"--%>
<%--                               style="margin-right: 10px">Imprimer</a>--%>
                            <%
                                String pdfBase   = request.getContextPath() + "/ExportPDF?action=fiche_bc&id="
                                        + URLEncoder.encode(id, "UTF-8");
                                String pdfApercu = pdfBase + "&inline=1";
                            %>
                            <button type="button" class="btn btn-tertiary pull-right"
                                    data-url="<%= pdfApercu %>"
                                    data-dl="<%= pdfBase %>"
                                    data-kind="pdf"
                                    data-name="BC <%= id %>"
                                    onclick="openPreview(this.dataset.url, this.dataset.kind, this.dataset.name, this.dataset.dl)"
                                    style="margin-right: 10px">Imprimer</button>

                            <% } %>
                            <a class="btn btn-tertiary pull-right"
                               href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj=" + pc.getChampByName("designation").getValeur() %>"
                               style="margin-right: 10px;">Attacher Fichier</a>

                            <% if (((As_BonDeCommandeCpl) pc.getBase()).getEtat() != ConstanteEtat.getEtatValider()) { %>
                                <a class="btn btn-primary pull-right"
                               href="<%= (String) session.getValue("lien") + "?but=bondecommande/apresMail.jsp&id=" + id %>"
                               style="margin-right: 10px;">Envoyer Email PDG</a>
                            <% } %>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=facturefournisseur/dmdachat/commentaire-demande-saisie.jsp&id=" + id +"&bute="+pageActuel%> " style="margin-right: 10px">Ajouter commentaire</a>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=bondecommande/inc/demande-avis-saisie.jsp&idObjet=" + id +"&bute="+pageActuel%> " style="margin-right: 10px">Demander avis</a>
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
                    <li class="<%=map.get("inc/bondecommande-liste-detail")%>"><a
                            href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondecommande-liste-detail">Détails</a>
                    </li>
                    <li class="<%=map.get("inc/as-bondelivraison")%>"><a
                            href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/as-bondelivraison">D&eacute;tails
                        de r&eacute;ception</a></li>
                    <li class="<%=map.get("inc/achat-cpl-visee")%>"><a
                            href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/achat-cpl-visee">Rapprochement</a>
                    </li>
                    <li class="<%=map.get("inc/facture-fournisseur")%>"><a
                            href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/facture-fournisseur">Factures</a>
                    </li>
                    <li class="<%=map.get("inc/commentaire-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/commentaire-liste">Commentaire</a></li>
                    <li class="<%=map.get("../historique/inc/historique-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=../historique/inc/historique-liste">Historique</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>">
                        <jsp:param name="idFactureFournisseur" value="<%= id %>"/>
                    </jsp:include>
                </div>
            </div>
        </div>
    </div>
    <% out.println(bc.getHtmlAttacherFichier(request.getContextPath()));%>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>