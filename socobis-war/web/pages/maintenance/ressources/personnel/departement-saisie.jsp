
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="maintenance.ressources.DepartementMaintenance" %>

<%
    try{
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "maintenance.ressources.DepartementMaintenance",
                nomtable = "departementmaintenance",
                apres = "maintenance/ressources/personnel/departement-fiche.jsp",
                titre = "Saisie d'un nouveau d&eacute;partement";

        if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update")) {
            titre = "Modification d'un d&eacute;partement";
        }

        DepartementMaintenance client = new DepartementMaintenance();
        PageInsert pi = new PageInsert(client, request, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("val").setLibelle("D&eacute;partement");
        pi.getFormu().getChamp("desce").setLibelle("Description");

        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>
