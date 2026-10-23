
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.*"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@ page import="paie.configuration.FormationDiplome" %>
<%
    try {
        FormationDiplome a = new FormationDiplome();
        a.setNomTable("FORMATION_DIPLOME");
        String titre="Saisie d'une formation ou dipl&ocirc;me";
        if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update"))
        {
            titre = "Modification de la formation/dipl&ocirc;me";
        }
        PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("val").setLibelle("Valeur");
        pi.getFormu().getChamp("desce").setLibelle("Description");

        String classe = "paie.configuration.FormationDiplome";

        String butApresPost = "paie/configuration/formation-diplome-saisie.jsp";
        String nomTable = "FORMATION_DIPLOME";
        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1 align="center"><%=titre %></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
</div>
<%
    }catch (Exception e) {
        e.printStackTrace();

    } %>
