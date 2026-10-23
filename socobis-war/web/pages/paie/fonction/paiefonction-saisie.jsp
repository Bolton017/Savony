<%-- 
    Document   : paiefonction-saisie
    Created on : 21 d�c. 2020, 15:09:08
    Author     : Sanda
--%>

<%@page import="paie.edition.PaieFonction"%>
<%@page import="affichage.PageInsert"%> 
<%@page import="user.UserEJB"%> 
<%@page import="affichage.Liste"%> 
<%@page import="bean.TypeObjet"%> 
<%
    try{
    String acte = "insert";
    String titre = "Saisie d'une fonction";
        if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update"))
    {
        titre = "Modification fonction";
    }
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "paie.edition.PaieFonction",
            nomtable = "paie_fonction",
            apres = "paie/fonction/paiefonction-fiche.jsp";

    PaieFonction  objet = new PaieFonction();
    objet.setNomTable(nomtable);
    PageInsert pi = new PageInsert(objet, request, u);
    pi.setLien((String) session.getValue("lien"));

    pi.getFormu().getChamp("idgroupefonction").setPageAppelComplete("bean.TypeObjet","id","paie_groupefonction");
//    pi.getFormu().getChamp("idgroupefonction").setAutre("readonly");

    pi.getFormu().getChamp("desce").setLibelle("Description");
    pi.getFormu().getChamp("val").setLibelle("Code fonction");
    pi.getFormu().getChamp("idgroupefonction").setLibelle("Groupe");
    pi.getFormu().getChamp("gratification").setVisible(false);
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form class='container' action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
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
<script language="JavaScript"> 
	alert('<%=e.getMessage()%>');
    history.back();</script>
<% }%>
