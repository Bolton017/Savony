<%@page import="utilisateur.Role"%>
<%@page import="utilisateursocobis.UtilisateurStation"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="prevision.Service" %>
<%
    try{
    UtilisateurStation a = new UtilisateurStation();
    PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));
    //Modification des affichages
        affichage.Champ[] liste = new affichage.Champ[2];
        Role role = new Role();
        liste[0] = new Liste("idrole", role, "descrole", "idrole");
        liste[1] = new Liste("idService", new Service(), "libelle", "compte");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idrole").setLibelle("R&ocirc;le");
        pi.getFormu().getChamp("teluser").setLibelle("Telephone");
        pi.getFormu().getChamp("nomuser").setLibelle("Nom");
        pi.getFormu().getChamp("loginuser").setLibelle("Login");
        pi.getFormu().getChamp("pwduser").setLibelle("Mot de passe");
        pi.getFormu().getChamp("idService").setLibelle("D&eacute;partement");
        pi.getFormu().getChamp("pwduser").setType("password");
        pi.getFormu().getChamp("adruser").setVisible(false);
    //Variables de navigation
    String classe = "utilisateursocobis.UtilisateurStation";
    String butApresPost = "utilisateur/utilisateur-liste.jsp";
    String nomTable = "utilisateur";
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

