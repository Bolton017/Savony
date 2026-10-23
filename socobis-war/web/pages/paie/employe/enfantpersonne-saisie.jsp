<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="paie.employe.EnfantPersonnel" %>
<%@ page import="affichage.Liste" %>

<% try{

    String idp = request.getParameter("id");
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "paie.employe.EnfantPersonnel",
            nomtable = "ENFANTPERSONNEL",
            apres = "paie/employe/enfantpersonne-fiche.jsp",
            titre = "Saisie enfant";

    EnfantPersonnel o = new EnfantPersonnel();
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));

    Liste[] liste = new affichage.Liste[1];
    String[] classe = {"Masculin","F&eacute;minin"};
    String[] classeValue = {"1","0"};
    liste[0] = new Liste("genre");
    liste[0].makeListeString(classe,classeValue);
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("idPersonnel").setLibelle("Personne");
    pi.getFormu().getChamp("dateNaissance").setLibelle("Date de naissance");
    pi.getFormu().getChamp("idPersonnel").setPageAppelComplete("paie.log.LogPersonnel", "id", "log_personnel_v2", "","");

    if(idp != null && idp.compareToIgnoreCase("")!=0){
        pi.getFormu().getChamp("idPersonnel").setDefaut(idp);
    }

    pi.preparerDataFormu();



    String acte = request.getParameter("acte");
    if (acte!=null && acte.equals("update")){
        titre = "Modification enfant";
    }
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
