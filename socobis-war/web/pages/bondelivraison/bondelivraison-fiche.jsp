<%-- 
    Document   : encaissement-fiche
    Created on : 3 avr. 2024, 16:22:00
    Author     : Angela
--%>

<%@page import="faturefournisseur.As_BonDeLivraison_Lib"%>
<%@page import="faturefournisseur.As_BonDeLivraison"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="constante.ConstanteEtat" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="fichier.AttacherFichier" %>
<%@ page import="uploadbean.UploadService" %>

<%
    try {
        //Information sur les navigations via la page
        String lien = (String) session.getValue("lien");
        String pageModif = "bondelivraison/bondelivraison-saisie.jsp";
        String classe = "faturefournisseur.As_BonDeLivraison";
        String pageActuel = "bondelivraison/bondelivraison-fiche.jsp";

        //Information sur la fiche
        As_BonDeLivraison_Lib objet = new As_BonDeLivraison_Lib();
        objet.setNomTable("AS_BONDELIVRAISON_LIBMP");
        PageConsulte pc = new PageConsulte(objet, request, (user.UserEJB) session.getValue("u"));
        objet = (As_BonDeLivraison_Lib) pc.getBase();
        String id = request.getParameter("id");
        pc.getChampByName("id").setLibelle("Id");
        pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
        pc.getChampByName("idFactureFournisseur").setLibelle("ID Facture Fournisseur");
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("magasinlib").setLibelle("Magasin");
        pc.getChampByName("magasin").setVisible(false);
        pc.getChampByName("idFournisseur").setVisible(false);
        pc.getChampByName("idFournisseurLib").setLibelle("Fournisseur");
        pc.getChampByName("idFournisseurLib").setLien((String) session.getValue("lien") + "?but=fournisseur/fournisseur-fiche.jsp&id=" + objet.getIdFournisseur(), "nom=");
        String idBC = objet.getIdbc();
        if(idBC!=null && idBC.startsWith("BC")){
            pc.getChampByName("idbc").setLien(lien+"?but=bondecommande/bondecommande-fiche.jsp", "id="+objet.getIdbc()+"&libelle=");
        }else if(idBC!=null && idBC.startsWith("FCF")){
            pc.getChampByName("idbc").setLien(lien+"?but=facturefournisseur/facturefournisseur-fiche.jsp", "id="+objet.getIdbc()+"&libelle=");
        }
        pc.getChampByName("idbc").setLibelle("R&eacute;f. bon de commande");
        if(objet.getIdFactureFournisseur()!=null){
            pc.getChampByName("idFactureFournisseur").setLien(lien+"?but=facturefournisseur/facturefournisseur-fiche.jsp", "id=");
        }
      

        pc.setTitre("Fiche d'un bon de r&eacute;ception");
        Onglet onglet = new Onglet("page1");
        onglet.setDossier("inc");
        Map<String, String> map = new HashMap<String, String>();
        map.put("bondelivraison-details", "");
        map.put("rapprochement-stock", "");
        map.put("facture-fournisseur", "");
        map.put("../../historique/inc/historique-liste", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "bondelivraison-details";
        }
        map.put(tab, "active");
        tab = "inc/" + tab + ".jsp";

//        String genererMouvement = "stock/mvtstock-saisie.jsp";
        String genererMouvement = "stock/mvtstock-saisie.jsp";

        // Récupération des fichiers attachés
        AttacherFichier[] fichiers = UploadService.getUploadFile(request.getParameter("id"));
        configuration.CynthiaConf.load();
        String cdn = configuration.CynthiaConf.properties.getProperty("cdnReadUri");
        String projectName = id != null ? id.replace("'","_").replace("/","_").replace("-","_").replace(":", "_").replace("*", "_").replace(" ", "_") : "default";
        String dossier = "bondelivraison/files/" + projectName;


%>
<div class="content-wrapper">
    <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=bondelivraison/bondelivraison-liste.jsp"><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
       <div class="row m-0">

        <div class="col-md-12 nopadding mb-5" >
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body ">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <a class="btn btn-primary pull-right"  style="margin-right: 10px;" href="<%= lien+ "?but=transport/course-saisie.jsp&livraison="+request.getParameter("id") %>">
                                G&eacute;n&eacute;rer Course
                            </a>
                            <div class="separator pull-right"></div>
                            <% if (objet.getEtat() < ConstanteEtat.getEtatValider()) {%>
                            <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id + "&acte=annuler&bute="+pageActuel+"&classe=" + classe%>" style="margin-left: 10px">Annuler</a>
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute="+pageActuel+"&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id + "&acte=update"%>" style="margin-right: 10px">Modifier</a>
                           <% } else { %>
                            <% if (objet.isgenerateStock() == false) {%>
                               <a class="btn btn-secondary pull-right" href="<%=(String) session.getValue("lien")%>?but=<%= genererMouvement+"&idBLF="+request.getParameter("id") %>">
                            
                                    G&eacute;n&eacute;rer Entr&eacute;e de Stock
                               </a>
                                   <%} if(objet.getIdFactureFournisseur()==null||objet.getIdFactureFournisseur().compareTo("")==0)
                            {%>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=facturefournisseur/facturefournisseur-saisie.jsp&idBL="+pc.getChampByName("id").getValeur()%>" style="margin-right: 10px">Insertion Facture Fournisseur</a>
                            <%}%>
                           <% }%>
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj=" + id %>" style="margin-right: 10px;">Attacher Fichier</a>
                            
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row m-0" >
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("bondelivraison-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=bondelivraison-details">D&eacute;tails</a></li>
                    <li class="<%=map.get("bondelivraison-mvtstock")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=bondelivraison-mvtstock">Mouvement de Stock</a></li>
                    <li class="<%=map.get("rapprochement-stock")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=rapprochement-stock">Rapprochement de Stock</a></li>
                    <li class="<%=map.get("facture-fournisseur")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=facture-fournisseur">Factures</a></li>
                    <li class="<%=map.get("course-liste")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=course-liste">Course</a></li>
                    <li class="<%=map.get("../../historique/inc/historique-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=../../historique/inc/historique-liste">Historique</a></li>

                </ul>

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
