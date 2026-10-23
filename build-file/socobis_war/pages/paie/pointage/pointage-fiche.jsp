<%@page import="mg.spat.AttacherFichier"%>
<%@page import="affichage.PageConsulte"%>
<%@page import="user.UserEJB"%>
<%@page import="utilitaire.ConstanteEtat"%>
<%@ page import="paie.pointage.Pointage" %>

<%
    Pointage pointage;
    String pageActuel = "paie/pointage/pointage-fiche.jsp";
%>

<%
    try {
        String id = request.getParameter("id");
        String classe = "paie.pointage.Pointage";
        String butefiche = "paie/pointage/pointage-fiche.jsp";
        String lien = (String) session.getValue("lien");

        UserEJB u = (UserEJB) session.getAttribute("u");
        pointage = new Pointage();
        pointage.setNomTable("POINTAGE_LIB");

        PageConsulte pc = new PageConsulte(pointage, request, u);
        pc.setTitre("Fiche du pointage");
        pc.getChampByName("nompersonnel").setLibelle("Personnel");
        pc.getChampByName("matricule").setLibelle("Matricule Personnel");
        pc.getChampByName("heurenormal").setLibelle("Heure Normale");
        pc.getChampByName("heuresupnormal").setLibelle("Heure Suppl&eacute;mentaire Normale");
        pc.getChampByName("heuresupnuit").setLibelle("Heure Suppl&eacute;mentaire de Nuit");
        pc.getChampByName("heuresupweekend").setLibelle("Heure Suppl&eacute;mentaire Week-end");
        pc.getChampByName("heuresupferie").setLibelle("Heure Suppl&eacute;mentaire Feri&eacute;");
        pc.getChampByName("annee").setLibelle("ann&eacute;e");
        pc.getChampByName("absence").setLibelle("Heure d'absence");
        pc.getChampByName("directionlib").setLibelle("Direction");
        pc.getChampByName("moislib").setLibelle("Mois");
        pc.getChampByName("etat").setLibelle("&Eacute;tat");

        // hidden fields
        pc.getChampByName("idpersonnel").setVisible(false);
        pc.getChampByName("direction").setVisible(false);
        pc.getChampByName("mois").setVisible(false);
        pc.getChampByName("daty").setVisible(false);

        pointage = (Pointage) pc.getBase();
        configuration.CynthiaConf.load();
%>
<div class="content-wrapper">
    <h1><%= pc.getTitre() %></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box" style="text-align: center">
                    <%
                        out.println(pc.getHtml());
                    %>
                        <div class="box-footer">

                            <!-- <a class="btn btn-warning"
                               href="<%= (String) session.getValue("lien") %>?but=paie/editionmoisannee/editionmoisannee-modif.jsp&id=<%= pointage.getId() %>"
                               aria-label="Modifier l'&eacute;dition de paie"
                               title="Modifier">Modifier</a> -->

                            <%
                                if(pointage.getEtat() <= ConstanteEtat.getEtatCreer()) {
                            %>
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute="+butefiche+"&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                            <% } %>
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + pc.getBase().getClass().getSimpleName() + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") %>" style="margin-right: 10px;">Attacher Fichier</a>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <%=pc.getHtmlAttacherFichier()%>
</div>
<script>
    $('#fiche .row .col-md-6').removeClass('col-md-6').removeClass('col-md-center').addClass('col-md-8').addClass('col-md-offset-2');
</script>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();

</script>
<% }%>

<style>
    .button-group .btn {
        margin-bottom: 10px;
    }
    .button-group {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        justify-content: flex-end;
    }
</style>
