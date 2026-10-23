<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="production.CritereProduit" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "production.CritereProduit";
    String nomTable = "CRITEREPRODUIT";
    String apres = "production/critereProduit-fiche.jsp";
    String idCritereProduit = request.getParameter("id");
    CritereProduit o = new CritereProduit();
    o.setNomTable("CRITEREPRODUIT");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie crit&egrave;re produit");
    if(idCritereProduit != null){
        pi.getFormu().getChamp("idTypeProduit").setDefaut(idCritereProduit);
    }

    pi.getFormu().getChamp("idcritere").setLibelle("Crit&egrave;re");
    pi.getFormu().getChamp("idTypeProduit").setLibelle("Type produit");
    pi.getFormu().getChamp("idcritere").setPageAppelComplete("bean.TypeObjet","id","CRITERE","id","val");
    pi.getFormu().getChamp("idTypeProduit").setPageAppelComplete("bean.TypeObjet","id","TYPEPRODUIT","id","val");
 
    String[] ordre = {"idcritere","idTypeProduit"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification crit&egrave;re produit");
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

