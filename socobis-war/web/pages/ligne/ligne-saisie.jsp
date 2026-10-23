<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="machine.*" %>

<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "machine.Ligne",
                nomtable = "LIGNE",
                apres = "ligne/ligne-fiche.jsp",
                titre = "Cr&eacute;ation d'une nouvelle ligne";

        if(request.getParameter("acte")!=null){
            titre = "Modification d'une ligne";
        }

        Ligne machine = new Ligne();
        machine.setNomTable("LIGNE");
        PageInsert pi = new PageInsert(machine, request, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("val").setLibelle("Nom");
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
