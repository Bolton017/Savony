<%-- 
    Document   : client-saisie.php
    Created on : 22 mars 2024, 14:50:09
    Author     : SAFIDY
--%>


<%@page import="client.Client"%>
<%@page import="affichage.PageInsert"%> 
<%@page import="user.UserEJB"%> 
<%@page import="bean.TypeObjet"%> 
<%@page import="affichage.Liste"%>
<%@ page import="fabrication.ProcessFab" %>


<%
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String nomProcess=request.getParameter("nomProcess");
    nomProcess=nomProcess.substring(0, 1).toUpperCase() + nomProcess.substring(1);
    String  mapping = "fabrication.ProcessFab",
            nomtable = "Process",
            titre = nomProcess;

    ProcessFab proc = new ProcessFab();
    PageInsert pi = new PageInsert(proc, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.getFormu().getChamp("refObjet").setDefaut(request.getParameter("id"));
    String apres="fabrication/fabrication-fiche.jsp&id="+request.getParameter("id")+"&tab=inc/fabrication-details";
    pi.getFormu().getChamp("heure").setDefaut(utilitaire.Utilitaire.heureCouranteHM());
    pi.getFormu().getChamp("idUtilisateur").setVisible(false);
    pi.getFormu().getChamp("acteur").setLibelle("responsable");
    pi.getFormu().getChamp("acteur").setPageAppelComplete("personnel.Personnel","id","PERSONNEL");
    pi.getFormu().getChamp("action").setDefaut(nomProcess);
    pi.getFormu().getChamp("objet").setDefaut(request.getParameter("objet"));
    //pi.getFormu().getChamp("objet").setVisible(false);
    pi.getFormu().getChamp("dateHistorique").setLibelle("Date");
    pi.getFormu().getChamp("ecart").setVisible(false);

    pi.getFormu().getChamp("objet").setVisible(false);
    pi.getFormu().getChamp("action").setVisible(false);
    pi.getFormu().getChamp("refObjet").setVisible(false);
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
