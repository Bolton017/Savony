<%@page import="paie.employe.BanqueAgence"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>


<%
    try{
        String acte = "insert";
        String titre = "Saisie d'un Banque Agence";
        if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update"))
        {
            titre = "Modification Banque Agence";
        }
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "paie.employe.BanqueAgence",
                nomtable = "Banque_agence",
                actuel = "paie/employe/banqueagence-saisie.jsp",
                apres = "paie/employe/banqueagence-fiche.jsp";

        BanqueAgence objet = new BanqueAgence();
        objet.setNomTable("Banque_agence");

        PageInsert pi = new PageInsert(objet, request, u);
        pi.setLien((String) session.getValue("lien"));

        pi.getFormu().getChamp("nom").setLibelle("Nom de l'Agence");
        pi.getFormu().getChamp("codeAgence").setLibelle("Code Agence");

        affichage.Champ[] liste = new affichage.Champ[1];

        TypeObjet liste1 = new TypeObjet();
        liste1.setNomTable("Banque");

        liste[0] = new Liste("idBanque", liste1, "val", "id");

        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idBanque").setLibelle("Banque");

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
