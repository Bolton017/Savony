<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="fabrication.equipe.EquipeEmp" %>

<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "fabrication.equipe.EquipeEmp",
                nomtable = "equipeemp",
                apres = "fabrication/equipe/equipe-employe-fiche.jsp",
                titre = "Insertion &Eacute;quipe d'un personnel";

        EquipeEmp equipe = new EquipeEmp();
        equipe.setNomTable(nomtable);
        PageInsert pi = new PageInsert(equipe, request, u);
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            pi.getFormu().getChamp("val").setDefaut(id);
        }
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("val").setLibelle("&Eacute;quipe");
        pi.getFormu().getChamp("desce").setLibelle("Personnel");
        pi.getFormu().getChamp("desce").setPageAppelComplete("personnel.Personnel","id","PERSONNEL_MATRICULE");
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