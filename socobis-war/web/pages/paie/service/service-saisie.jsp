<%@page import="paie.log.LogService"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="utils.ConstanteAsync" %>


<%
    try{
        String acte = "insert";
        String titre = "Saisie d'un service";
        if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update"))
        {
            titre = "Modification Service";
        }
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "paie.log.LogService",
                nomtable = "LOG_SERVICE",
                actuel = "paie/service/service-saisie.jsp",
                apres = "paie/service/service-fiche.jsp";

        LogService objet = new LogService();
        objet.setNomTable(nomtable);

        PageInsert pi = new PageInsert(objet, request, u);
        pi.setLien((String) session.getValue("lien"));

        pi.getFormu().getChamp("libelle").setLibelle("Libell&eacute;");
        pi.getFormu().getChamp("code_service").setLibelle("Code Service");
        pi.getFormu().getChamp("code_dr").setVisible(false);
         pi.getFormu().getChamp("code_dr").setDefaut(ConstanteAsync.directionTana);

        affichage.Champ[] liste = new affichage.Champ[1];

        TypeObjet liste1 = new TypeObjet();
        liste1.setNomTable("log_direction");

        liste[0] = new Liste("dr_rattache", liste1, "val", "id");

        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("dr_rattache").setLibelle("Direction Rattach&eacute;e");

        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="<%= acte %>">
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
<% } %>
