<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="magasin.Magasin" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="maintenance.travaux.Travaux" %>
<%@ page import="maintenance.travaux.MoTravaux" %>
<%@ page import="maintenance.travaux.ProcessMaintenance" %>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        Travaux mere = new Travaux();
        mere.setNomTable("travaux");
        ProcessMaintenance fille = new ProcessMaintenance();
        fille.setNomTable("ProcessMaintenance");
        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        String butApresPost = "maintenance/travaux/Travaux-fiche.jsp";

        pi.setLien((String) session.getValue("lien"));


        pi.getFormufle().getChamp("idPersonnel_0").setLibelle("Personnel");
        pi.getFormufle().getChamp("heureDebut_0").setLibelle("Heure de d&eacute;but");
        pi.getFormufle().getChamp("heureFin_0").setLibelle("Heure de fin");
        pi.getFormufle().getChamp("dateDebut_0").setLibelle("Date de d&eacute;but");
        pi.getFormufle().getChamp("dateFin_0").setLibelle("Date de fin");
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("idTravaux"),request.getParameter("idTravaux"));
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idTravaux"),false);
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idPersonnel").getListeChamp(), "personnel.Personnel", "id", "PERSONNEL","","");

        for (int i = 0; i < nombreLigne; i++) {
            pi.getFormufle().getChamp("heureDebut_"+i).setType("time");
            pi.getFormufle().getChamp("heureFin_"+i).setType("time");
        }

        if (request.getParameter("idTravaux")!=null){
            pi.setDefautFille(new MoTravaux().genererProcessMaintenance(request.getParameter("idTravaux"),null));
        }

        pi.getFormufle().setOrdre(new String[]{"idTravaux","idPersonnel","dateDebut","heureDebut","dateFin","heureFin"});
        pi.preparerDataFormu();

        //Variables de navigation
        String classeMere = "maintenance.travaux.Travaux";
        String classeFille = "maintenance.travaux.ProcessMaintenance";
        String colonneMere = "idTravaux";
        //Preparer les affichages
        pi.getFormufle().makeHtmlInsertTableauIndex();
        pi.getFormufle().getBoutonsValiderAnnulerTabIndex();

%>
<div class="content-wrapper">
    <h1>Saisie de process de travaux</h1>
    <div class="box-body">
        <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
            <input name="acte" type="hidden" id="nature" value="insertFille">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
            <input name="idMere" type="hidden" id="idMere" value="<%= request.getParameter("idTravaux") %>">
            <input name="nomtable" type="hidden" id="nomtable" value="ProcessMaintenance">
        </form>
    </div>
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
