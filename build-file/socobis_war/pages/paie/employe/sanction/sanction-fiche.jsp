<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.*"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@ page import="paie.employe.sanction.Sanction"%>
<%@ page import="paie.employe.sanction.SanctionCPL" %>
<%@ page import="constante.ConstanteEtat" %>

<%
    try {
        String lien = (String) session.getValue("lien");
        UserEJB u = (UserEJB) session.getAttribute("u");

        String id = request.getParameter("id");
        String nomTable = "SANCTION_CPL";
        String classe = "paie.employe.sanction.Sanction";
        String pageActuel = "paie/employe/sanction/sanction-fiche.jsp";

        SanctionCPL sanctionCPL = new SanctionCPL();
        sanctionCPL.setNomTable(nomTable);

        PageConsulte pc = new PageConsulte(sanctionCPL, request, u);

        pc.setTitre("Fiche de la sanction");
        pc.getChampByName("idPersonne").setLien(lien+"?but=paie/employe/personnel-fiche-portrait.jsp", "id=");
        pc.getChampByName("nompersonnel").setLibelle("Nom Personnel");
        pc.getChampByName("idPersonne").setLibelle("ID Personne");
        pc.getChampByName("reglementLib").setLibelle("Libell&eacute; reglement");
        pc.getChampByName("libelleFaute").setLibelle("Description de la faute");
        pc.getChampByName("sanction").setLibelle("Sanction appliqu&eacute;e");
        pc.getChampByName("daty").setLibelle("Date d'enregistrement");
        pc.getChampByName("dateDebut").setLibelle("Date de d&eacute;but de la sanction");
        pc.getChampByName("duree").setLibelle("Dur&eacute;e");
        pc.getChampByName("niveauSanction").setLibelle("Niveau de sanction");
        pc.getChampByName("reglementLib").setLibelle("Sanction");
        pc.getChampByName("etat").setLibelle("&Eacute;tat");
        pc.getChampByName("matricule").setLibelle("Matricule");
        pc.getChampByName("numeroregle").setLibelle("R&egrave;gle nº");
        sanctionCPL = (SanctionCPL) pc.getBase();
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=compta/exercice/ouvertureCloture.jsp"><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%>
    </h1>
    <div class="row m-0">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                        <% if (sanctionCPL.getEtat() < ConstanteEtat.getEtatValider()) {%>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=paie/employe/sanction/sanction-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Viser</a>

                            <a class="btn btn-secondary pull-right"  href="<%=(String) session.getValue("lien") + "?but=paie/employe/sanction/sanction-saisie.jsp&id=" + id + "&acte=update"%>" style="margin-right: 10px">Modifier</a>
                        <% } %>
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + pc.getBase().getClass().getSimpleName() + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") %>" style="margin-right: 10px;">Attacher Fichier</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%
        out.println(pc.getHtmlAttacherFichier());
    %>
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
