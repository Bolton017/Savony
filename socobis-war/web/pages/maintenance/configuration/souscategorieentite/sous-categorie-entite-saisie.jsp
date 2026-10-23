<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="maintenance.configuration.Entite" %>
<%@ page import="maintenance.configuration.SousCategorieEntite" %>
<%@ page import="affichage.Liste" %>

<%
  try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "maintenance.configuration.SousCategorieEntite",
            nomtable = "SousCategorieEntite",
            apres = "maintenance/configuration/souscategorieentite/sous-categorie-entite-fiche.jsp",
            titre = "Saisie d'une cat&eacute;gorie de maintenance";
    if (request.getParameter("acte")!=null && request.getParameter("acte").equals("update")){
      titre = "Modification d'une cat&eacute;gorie de maintenance";
    }
    SousCategorieEntite categorie = new SousCategorieEntite();
    PageInsert pi = new PageInsert(categorie, request, u);
    pi.setLien((String) session.getValue("lien"));
    Liste[] liste = new Liste[1];
    Entite c = new Entite();
    liste[0] = new Liste("desce",c,"val","id");
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("val").setLibelle("Libell&eacute;");
    pi.getFormu().getChamp("desce").setLibelle("Entit&eacute;");
    pi.getFormu().getChamp("desce").setPageAppelComplete("maintenance.configuration.Entite","id","Entite","","");

    pi.preparerDataFormu();
%>
<div class="content-wrapper">
  <h1><%=titre%></h1>

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
