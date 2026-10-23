<%@ page import="user.UserEJB" %>
<%@ page import="paie.conge.ReportSoldeConge" %>
<%@ page import="affichage.PageInsert" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="utilitaire.Utilitaire" %>

<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");

        String mapping = "paie.conge.ReportSoldeConge";
        String nomTable = "REPORTSOLDECONGE";
        String apres = "paie/conge/reportsoldeconge-fiche.jsp";
        String titre = "Saisie Report Solde Cong&eacute;";

        ReportSoldeConge reportSoldeConge = new ReportSoldeConge();
        reportSoldeConge.setNomTable(nomTable);

        PageInsert pi = new PageInsert(reportSoldeConge, request, u);
        pi.setLien((String) session.getValue("lien"));

        affichage.Champ[] liste = new Champ[1];
        Liste mois = new Liste("mois");
        mois.makeListeMois();
        liste[0] = mois;
        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("idpersonnel").setPageAppelComplete("paie.log.LogPersonnelValide","id","log_personnel_v2");
        pi.getFormu().getChamp("idpersonnel").setLibelle("Personel Matricule");
        pi.getFormu().getChamp("annee").setLibelle("Ann&eacute;");
        pi.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());
        pi.getFormu().getChamp("conge").setLibelle("Nombre de jours de cong&eacute;");
        pi.getFormu().getChamp("mois").setLibelle("Mois");

        pi.preparerDataFormu();
%>


<div class="content-wrapper">
    <h1> <%=titre%> </h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%= nomTable %>" id="<%= nomTable %>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>

        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
    </form>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
%>

<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();</script>
<% } %>