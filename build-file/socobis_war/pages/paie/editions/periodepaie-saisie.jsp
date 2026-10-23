<%@page import="paie.edition.PeriodePaie"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="java.sql.Date" %>
<%@ page import="utilitaire.Utilitaire" %>

<%
    try{
        String acte = "insert";
        String titre = "Saisie P&eacute;riode de Paie";
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "paie.edition.PeriodePaie",
                nomtable = "PERIODEPAIE",
                actuel = "paie/editions/periodepaie-saisie.jsp",
                apres = "paie/editions/periodepaie-fiche.jsp";

        PeriodePaie objet = new PeriodePaie();
        objet.setNomTable(nomtable);

        PageInsert pi = new PageInsert(objet, request, u);
        pi.setLien((String) session.getValue("lien"));
        if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update"))
        {
            titre = "Modification P&eacute;riode de Paie";
            pi.getFormu().getChamp("id").setVisible(false);
        }
        pi.getFormu().getChamp("datedebut").setLibelle("Date D&eacute;but");
        pi.getFormu().getChamp("datefin").setLibelle("Date Fin");
        pi.getFormu().getChamp("etat").setVisible(false);
        // pi.getFormu().getChamp("moisLib").setLibelle("Libell&eacute; du Mois");

        affichage.Champ[] liste = new affichage.Champ[2];
        Liste moisListe = new Liste("mois");
        moisListe.makeListeMois();
        liste[0] = moisListe;

        TypeObjet cp = new TypeObjet();
        cp.setNomTable("CATEGORIE_PAIE");
        liste[1] = new Liste("idcategoriepaie", cp, "val", "id");

        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("mois").setLibelle("Mois");
        pi.getFormu().getChamp("moislib").setVisible(false);
        
        pi.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
        pi.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());

        pi.getFormu().getChamp("idcategoriepaie").setLibelle("Cat&eacute;gorie de Paie");

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
