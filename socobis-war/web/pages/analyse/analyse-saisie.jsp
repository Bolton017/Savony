<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="analyse.Analyse" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "analyse.Analyse";
    String nomTable = "ANALYSE";
    String apres = "analyse/analyse-fiche.jsp";

    Analyse o = new Analyse();
    o.setNomTable("ANALYSE");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie analyse");

    String idFab = request.getParameter("idFab");

     if (idFab != null)
    {
        pi.getFormu().getChamp("idfabrication").setDefaut(idFab);
        pi.getFormu().getChamp("idfabrication").setAutre("readonly");
    }


    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idfabrication").setLibelle("Fabrication");
    pi.getFormu().getChamp("idcritere").setLibelle("Crit&egrave;re");
    pi.getFormu().getChamp("valeur").setLibelle("Valeur");
    pi.getFormu().getChamp("idresponsable").setLibelle("Responsable");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idfabrication").setPageAppelComplete("fabrication.Fabrication","id","FABRICATIONCPL","idOf","id");
    pi.getFormu().getChamp("idcritere").setPageAppelComplete("produits.Critere","id","CRITERE","id","id");
    pi.getFormu().getChamp("idresponsable").setPageAppelComplete("personnel.LogPersonnel","id","LOG_PERSONNEL","id","val");
 
    String[] ordre = {"daty","idfabrication","idcritere","valeur","idresponsable"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification analyse");
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

