

<%@ page import="transport.*" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%
    try{
    CourseFille a = new CourseFille();
    PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));
    //Modification des affichages
    pi.getFormu().getChamp("idmere").setVisible(false);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idobjet").setLibelle("Objet");
    pi.getFormu().getChamp("datedepart").setLibelle("Date de d&eacute;part");
    pi.getFormu().getChamp("heuredepart").setLibelle("Heure de d&eacute;part");
    pi.getFormu().getChamp("datearrivee").setLibelle("Date d' arriv&eacute;e");
    pi.getFormu().getChamp("heurearrivee").setLibelle("Heure d' arriv&eacute;e");
    pi.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
     pi.getFormu().getChamp("heurearrivee").setType("time");
     pi.getFormu().getChamp("heuredepart").setType("time");
    pi.getFormu().getChamp("idpersonnel").setPageAppelComplete("personnel.LogPersonnel", "id", "LOG_PERSONNEL", "", "");
    //Variables de navigation
    String classe = "transport.CourseFille";
    String butApresPost = "transport/course-fille-fiche.jsp";
    String nomTable = "coursefille";
    //Generer les affichages
    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>
<div class="content-wrapper">
    <h1 align="center">Saisie d'une d&eacute;tail course</h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
} %>

