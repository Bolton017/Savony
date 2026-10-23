<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="client.ZoneClient" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "client.ZoneClient";
    String nomTable = "ZONECLIENT";
    String apres = "client/zone/zone-fiche.jsp";

    ZoneClient o = new ZoneClient();
    o.setNomTable("ZONECLIENT");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une zone de livraison");


    pi.getFormu().getChamp("val").setLibelle("Libell&eacute;");
    pi.getFormu().getChamp("desce").setLibelle("Description");
    pi.getFormu().getChamp("forfait").setLibelle("Frais de livraison");
    pi.getFormu().getChamp("prixcarton").setLibelle("Prix par carton");
    pi.getFormu().getChamp("mincarton").setLibelle("Carton minimal");
 
    String[] ordre = {"val","desce","forfait","prixcarton","mincarton"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une zone de livraison");
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

