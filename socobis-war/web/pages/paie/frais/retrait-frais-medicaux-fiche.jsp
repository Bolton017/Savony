<%-- 
    Document   : activites-fiche
    Created on : 18 mai 2021, 15:07:35
    Author     : nyamp
--%>


<%@page import="mg.fer.paie.FraisMedicauxRetrait"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.HashMap"%>
<%@page import="utilitaire.ConstanteEtat"%>
<%@page import="bean.CGenUtil"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="service.UploadService"%>
<%@page import="mg.allosakafo.AttacherFichier"%>
<%@page import="affichage.PageConsulte"%>
<%@page import="user.UserEJB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    FraisMedicauxRetrait e = new FraisMedicauxRetrait();
    e.setNomTable("retrait_frais_medicaux_libcomplet");
    PageConsulte pc = new PageConsulte(e, request, u);
    pc.setTitre("Demande de remboursement");
//    pc.getChampByName("idDistrict").setVisible(false);
//    pc.getChampByName("datesaisie").setVisible(false);
//    pc.getChampByName("iduser").setVisible(false);
//   
//    pc.getChampByName("idDistrictlib").setLibelle("District");
//    pc.getChampByName("val").setLibelle("Libellé");
//    pc.getChampByName("desce").setLibelle("Description");
//    
//    pc.getChampByName("iduser").setVisible(false);
//    pc.getChampByName("datesaisie").setVisible(false);
    e = (FraisMedicauxRetrait) pc.getBase();
    
    
    String bute="paie/frais/retrait-frais-medicaux-fiche.jsp";
    String classe="mg.fer.paie.FraisMedicauxRetrait";
    String modifPage="paie/frais/retrait-frais-medicaux-modif.jsp";
    
  
    String lien = (String) session.getValue("lien");
    String redirect = lien + "?but="+modifPage+"&id=" + request.getParameter("id");

    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("idpersonnel").setLibelle("Id Personnel");
    pc.getChampByName("idpersonnel_lib").setLibelle("Personnel");
    pc.getChampByName("montant").setLibelle("Montant accordé");
//     pc.getChampByName("montant").setAutre("readonly");
    String id= e.getId();
    AttacherFichier[] fichiers = UploadService.getUploadFile(id);
    configuration.CynthiaConf.load();
    String cdn = configuration.CynthiaConf.properties.getProperty("cdnReadUri");
    String dossier="activite";
    
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-7 col-md-offset-2">

            <div class="box">
                <div class="box-body">
                    <%
                        out.println(pc.getHtml());
                    %>
                </div>
                <div class="box-footer">
                    <p>
                        <a class="btn btn-info"  href="<%=(String) session.getValue("lien") + "?but=pageupload.jsp&id=" + e.getId() + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute="   +bute+"&id=" + e.getId() %>" style="margin-right: 10px">Attacher Fichier</a> 
                        <a class="btn btn-warning"  href="<%=(String) session.getValue("lien") + "?but="+modifPage+"&id=" + e.getId() %>" style="margin-right: 10px">Modifier</a>

                        <a class="btn btn-success pull-left"  href="<%=(String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&classe="+classe+"&bute="+bute+"&id=" + request.getParameter("id")%>" style="margin-right: 10px">Valider</a>

                    </p>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-2"></div>
    <div class="col-md-8">
        <div class="box-title">

            <h2 class="box-title" style="margin-left: 10px;">Les fichiers attachés</h2>
        </div>
        <div class="box-body">
            <table class="table table-striped table-bordered table-condensed table-responsive tree">
                <thead>
                    <tr>
                        <th style="background-color:#bed1dd;"></th>
                        <th style="background-color:#bed1dd;">Libellé</th>
                        <th style="background-color:#bed1dd;">Fichier</th>
                        <th style="background-color:#bed1dd;">Voir</th>
                        <th style="background-color:#bed1dd;">#</th>
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
                        <td><%=utilitaire.Utilitaire.champNull(fichier.getLibelle())%></td>
                        <td><a href="#" class="btn btn-primary" onclick="javascript:pagePopUp('<%=cdn + dossier + "/" + fichier.getChemin()%>')">Voir</a></td>
                        <td></td>
                    </tr>
                    <%}
                        }%>


                </tbody>
            </table>
        </div>
    </div>
    <div class="col-md-2"></div>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();</script>
<% }%>
