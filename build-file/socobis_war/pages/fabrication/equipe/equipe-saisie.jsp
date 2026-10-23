<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="fabrication.equipe.Equipe" %>

<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "fabrication.equipe.EquipeEmp",
                nomtable = "equipe",
                apres = "fabrication/equipe/equipe-fiche.jsp",
                titre = "Insertion &Eacute;quipe";

        Equipe equipe = new Equipe();
        equipe.setNomTable(nomtable);
        PageInsert pi = new PageInsert(equipe, request, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("val").setLibelle("Nom &eacute;quipe");
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