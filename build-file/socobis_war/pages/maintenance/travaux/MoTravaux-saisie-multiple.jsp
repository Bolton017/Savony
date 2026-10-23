<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="magasin.Magasin" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="maintenance.travaux.Travaux" %>
<%@ page import="maintenance.travaux.MoTravaux" %>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        Travaux mere = new Travaux();
        mere.setNomTable("travaux");
        MoTravaux fille = new MoTravaux();
        fille.setNomTable("MOTRAVAUX");
        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        String butApresPost = "maintenance/travaux/Travaux-fiche.jsp";

        pi.setLien((String) session.getValue("lien"));


        pi.getFormufle().getChamp("idPersonnel_0").setLibelle("Personnel");
        pi.getFormufle().getChamp("dureeEstimatif_0").setLibelle("Duree Estimatif");
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("idTravaux"),request.getParameter("idTravaux"));
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("tauxHoraire"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idTravaux"),false);
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idPersonnel").getListeChamp(), "personnel.Personnel", "id", "PERSONNEL","","");

        for (int i = 0; i < nombreLigne; i++) {
            pi.getFormufle().getChamp("dureeEstimatif_"+i).setType("time");
            pi.getFormufle().getChamp("dureeEstimatif_"+i).setAutre("step='1'");
        }
        pi.preparerDataFormu();

        //Variables de navigation
        String classeMere = "maintenance.travaux.Travaux";
        String classeFille = "maintenance.travaux.MoTravaux";
        String colonneMere = "idTravaux";
        //Preparer les affichages
        pi.getFormufle().makeHtmlInsertTableauIndex();
        pi.getFormufle().getBoutonsValiderAnnulerTabIndex();

%>
<div class="content-wrapper">
    <h1>Saisie d'affectation des personnels</h1>
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
            <input name="nomtable" type="hidden" id="nomtable" value="MOTRAVAUX">
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
