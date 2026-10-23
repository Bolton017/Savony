<%@page import="inventaire.InventaireLib"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="utilitaire.ConstanteEtat" %>
<%@ page import="fichier.AttacherFichier" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="uploadbean.UploadService" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    
%>
<%
    InventaireLib unite = new InventaireLib();
    PageConsulte pc = new PageConsulte(unite, request, u);
    pc.setTitre("Fiche inventaire");
    unite = (InventaireLib) pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("Id").setLibelle("Id");
    pc.getChampByName("designation").setLibelle("D&eacute;signation");
    pc.getChampByName("idMagasinlib").setLibelle("Magasin");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("MotsClesss").setVisible(false);
    pc.getChampByName("idcategorielib").setLibelle("Cat&eacute;gorie");
    pc.getChampByName("idcategorielib").setVisible(false);
    pc.getChampByName("idDepartement").setVisible(false);
    pc.getChampByName("idDepartementLib").setLibelle("D&eacute;partement");
    pc.getChampByName("montantQuantite").setLibelle("Total des quantit&eacute;s");

    pc.getChampByName("idMagasin").setVisible(false);
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idcategorie").setVisible(false);
    String pageActuel = "inventaire/inventaire-fiche.jsp";

    String[] order = {"daty", "heure", "designation", "idMagasinlib", "idDepartementLib", "montantQuantite","etatlib", "remarque"};
    pc.setOrdre(order);

    String lien = (String) session.getValue("lien");
    String pageModif = "inventaire/inventaire-saisie.jsp&acte=update";
    String pageModifPu = "inventaire/inventaire-modif-pu.jsp&acte=update";
    String classe = "inventaire.Inventaire";
    
    Map<String, String> map = new HashMap<String, String>();
    map.put("inventairefille-liste", "");
    map.put("../historique/inc/historique-liste", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inventairefille-liste";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";

    AttacherFichier[] fichiers = UploadService.getUploadFile(request.getParameter("id"));
    String projectName = pc.getChampByName("designation").getValeur()
            .replace("'","_")
            .replace("/","_")
            .replace("-","_")
            .replace(":", "_")
            .replace("*", "_")
            .replace(" ", "_");
    String dossierTemp = "mvtstock/files/"+projectName;
    String dossier = dossierTemp;
%>

<div class="content-wrapper">
        <h1 class="box-title"><a href=<%= lien + "?but=inventaire/inventaire-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row">
        <div class="col-md-12 mb-5">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <%
                                if(unite.getEtat() < ConstanteEtat.getEtatValider()){
                            %>
                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=inventaire/inventaire-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
<%--                                <% if(u.getUser().getIdrole().equals(ConstanteSocobis.DG_RANG)) { %>--%>
                                    <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&modifpu=true&id=" + id%>" style="margin-right: 10px">Modifier avec PU</a>
<%--                                <% } %>--%>
                                <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annuler&bute=inventaire/inventaire-liste.jsp&classe="+classe%>">Annuler</a>
                            <% }else{ %>
                            <a class="btn btn-danger pull-left" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=annulerVisa&id=" + request.getParameter("id") + "&bute=inventaire/inventaire-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Annuler</a>
                            <% } %>
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj="+ pc.getChampByName("designation").getValeur() %>" style="margin-right: 10px; margin-bottom: 10px;/*! display: block; *//*! margin: 5px auto; *//*! width: 111px; *//*! max-width: 111px; */">Attacher Fichier</a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("inventairefille-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inventairefille-liste">Détails de l'inventaire</a></li>
                    <li class="<%=map.get("../historique/inc/historique-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=../historique/inc/historique-liste">Historique</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idInventaire" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>

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

