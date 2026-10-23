<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 3/5/25
  Time: 2:16 PM
  To change this template use File | Settings | File Templates.
--%>


<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="personnel.Personnel" %>
<%
    try{
        Personnel a = new Personnel();
        PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("telephone").setLibelle("T&eacute;l&eacute;phone");
        //Variables de navigation
        String classe = "personnel.Personnel";
        String butApresPost = "personnel/personnel-liste.jsp";
        String nomTable = "Personnel";
        String title = "Saisie Personnel";
        //Generer les affichages
        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
%>
<div class="content-wrapper">
    <h1 align="center"><%=title%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
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


