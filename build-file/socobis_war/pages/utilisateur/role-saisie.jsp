<%@page import="utilisateur.Role"%>
<%@page import="historique.MapRoles"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%
    try{
    MapRoles a = new MapRoles();
    PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));
    //Variables de navigation
    String classe = "historique.MapRoles";
    String butApresPost = "utilisateur/role-liste.jsp";
    String nomTable = "roles";
    //pi.getFormu().getChamp("idrole").setLibelle("Role");
    pi.getFormu().getChamp("descrole").setLibelle("Description");
    pi.getFormu().getChamp("rang").setLibelle("Rang");
    //Generer les affichages
    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>
<div class="content-wrapper">
    <h1 align="center">Saisie Utilisateur</h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
} %>

