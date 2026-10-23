<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 20/08/2025
  Time: 10:31
  To change this template use File | Settings | File Templates.
--%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@ page import="machine.Machine" %>

<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "machine.Machine",
                nomtable = "MACHINE",
                apres = "machine/machine-fiche.jsp",
                titre = "Nouvelle Machine";

        if(request.getParameter("acte")!=null){
            titre = "Modification Machine";
        }

        Machine machine = new Machine();
        machine.setNomTable("Machine");
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
