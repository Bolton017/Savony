<%@page import="paie.annexe.Ville"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>

<%
    try {
        String acte = "insert";
        String titre = "Saisie d'une ville/commune";
        if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update")) {
            acte = "update";
            titre = "Modification d'une ville/commune";
        }

        UserEJB u = (user.UserEJB) session.getValue("u");
        String mapping = "paie.annexe.Ville";
        String nomtable = "VILLE";
        String apres = "paie/annexe/ville-fiche.jsp";

        Ville objet = new Ville();
        objet.setNomTable(nomtable);

        PageInsert pi = new PageInsert(objet, request, u);
        pi.setLien((String) session.getValue("lien"));

        TypeObjet pays = new TypeObjet();
        pays.setNomTable("PAYS");
        Liste[] liste = new Liste[1];
        liste[0] = new Liste("idPays", pays, "val", "id");
        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("nom").setLibelle("Ville/Commune");
        pi.getFormu().getChamp("codePostal").setLibelle("Code postal");
        pi.getFormu().getChamp("idPays").setLibelle("Pays");

        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1><%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="<%=acte%>">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
        String message = e.getMessage();
        if (message == null || message.trim().isEmpty()) {
            message = e.getClass().getName();
        }
        message = message.replace("\\", "\\\\").replace("'", "\\'").replace("\r", " ").replace("\n", " ");
%>
<script language="JavaScript">
    alert('<%=message%>');
    history.back();
</script>
<% } %>
