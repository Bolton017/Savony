<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="rapport.mapping.MailRapport" %>

<%
    try{
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "rapport.mapping.MailRapport",
                nomtable = "MAILRAPPORT",
                apres = "rapport/configuration/mailrapport/mailrapport-fiche.jsp",
                titre = "Saisie Destinataire/Cc";

        if(request.getParameter("acte")!=null && request.getParameter("acte").equals("update")){
            titre = "Modification Destinataire/Cc";
        }

        MailRapport mailRapport = new MailRapport();
        PageInsert pi = new PageInsert(mailRapport, request, u);
        pi.setLien((String) session.getValue("lien"));

        pi.getFormu().getChamp("val").setLibelle("E-Mail");
        pi.getFormu().getChamp("desce").setLibelle("Description");

        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
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