
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="maintenance.configuration.TypeMaintenance" %>

<%
  try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "maintenance.configuration.TypeMaintenance",
            nomtable = "TypeMaintenance",
            apres = "maintenance/configuration/typemaintenance/typemaintenance-fiche.jsp",
            titre = "Saisie d'un type de maintenance";
    if (request.getParameter("acte")!=null && request.getParameter("acte").equals("update")){
        titre = "Modification d'un type de maintenance";
    }
    TypeMaintenance categorie = new TypeMaintenance();
    PageInsert pi = new PageInsert(categorie, request, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("val").setLibelle("Libell&eacute;");
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
