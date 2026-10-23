<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="maintenance.configuration.UniteMaintenance" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "maintenance.configuration.UniteMaintenance";
    String nomTable = "unitemaintenance";
    String apres = "maintenance/configuration/unite/unitemaintenance-fiche.jsp";

    UniteMaintenance o = new UniteMaintenance();
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une unit&eacute; de maintenance");

    pi.getFormu().getChamp("echelle").setLibelle("Echelle");
    pi.getFormu().getChamp("val").setLibelle("Libell&eacute;");
    pi.getFormu().getChamp("desce").setLibelle("D&eacute;scription");
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une unit&eacute; de maintenance");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1> <%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

