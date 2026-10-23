<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="rapport.mapping.CRConfig" %>
<%@ page import="affichage.Liste" %>

<%
    try{
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "rapport.mapping.CRConfig",
                nomtable = "CRCONFIG",
                apres = "rapport/configuration/cr/config-envoi.jsp&acte=update&id=CRCF000001",
                titre = "Configuration de l'envoi";

        CRConfig crConfig = new CRConfig();
        PageInsert pi = new PageInsert(crConfig, request, u);
        pi.setLien((String) session.getValue("lien"));

        Liste[] listes = new Liste[5];

        String[] aff = {"Activ&eacute;", "Desactiv&eacute;"};
        String[] val = {"1", "0"};
        String[] jourSemaine = {"Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi"};

        listes[0] = new Liste("jourEnvoi", jourSemaine, jourSemaine);
        listes[1] = new Liste("journaliere", aff, val);
        listes[2] = new Liste("hebdomadaire", aff, val);
        listes[3] = new Liste("mensuel", aff, val);

        String[] aff2 = {"Non", "Oui"};
        String[] val2 = {"0", "1"};
        listes[4] = new Liste("finMois", aff2, val2);

        pi.getFormu().changerEnChamp(listes);

        pi.getFormu().getChamp("heureEnvoi").setVisible(false);
        pi.getFormu().getChamp("jourEnvoi").setLibelle("Jour d'envoi");
        pi.getFormu().getChamp("dateEnvoi").setLibelle("Date d'envoi (Entre 1 et 28)");
        pi.getFormu().getChamp("finMois").setLibelle("Fin du mois");
        pi.getFormu().getChamp("journaliere").setLibelle("CR Journali&egrave;r");
        pi.getFormu().getChamp("hebdomadaire").setLibelle("CR Hebdomadaire");
        pi.getFormu().getChamp("mensuel").setLibelle("CR Mensuel");

        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
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
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>