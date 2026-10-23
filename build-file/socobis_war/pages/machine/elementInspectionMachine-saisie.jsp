<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="machine.ElementInspectionMachine" %>
<%@ page import="affichage.Liste"%>
<%@ page import="machine.Machine" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "machine.ElementInspectionMachine";
    String nomTable = "ELEMENTINSPECTIONMACHINE";
    String apres = "machine/elementInspectionMachine-fiche.jsp";

    ElementInspectionMachine o = new ElementInspectionMachine();
    o.setNomTable("ELEMENTINSPECTIONMACHINE");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Insertion d'un &eacute;l&eacute;ment &agrave; v&eacute;rifier dans une machine");

    Liste[] liste = new Liste[1];
    Machine liste0 = new Machine();
    liste0.setNomTable("MACHINE");
    liste[0] = new Liste("idmachine",liste0,"val","id");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("idelementinspection").setLibelle("El&eacute;ment &agrave; insp&eacute;cter");
    pi.getFormu().getChamp("idmachine").setLibelle("Idmachine");
    pi.getFormu().getChamp("idelementinspection").setPageAppelComplete("machine.ElementInspection","id","ELEMENTINSPECTION","","");
 
    String[] ordre = {"idelementinspection","idmachine"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un &eacute;l&eacute;ment &agrave; v&eacute;rifier dans une machine");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
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

