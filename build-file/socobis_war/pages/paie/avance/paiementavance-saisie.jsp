
<%@page import="paie.employe.PaieRubrique"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@ page import="paie.avance.PaiementAvance" %>
<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String mapping = "paie.avance.PaiementAvance",
                nomtable = "PAIEMENTAVANCE",
                apres = "paie/avance/paiementavance-fiche.jsp";
        String titre = "Saisie de paiement d'avance";
        if (request.getParameter("acte")!=null && request.getParameter("acte").equals("update")){
            titre = "Modification de paiement d'avance";
        }

        PaiementAvance objet = new PaiementAvance();
        objet.setNomTable(nomtable);
        PageInsert pi = new PageInsert(objet, request, u);
        pi.setLien((String) session.getValue("lien"));

        pi.getFormu().getChamp("idavance").setLibelle("Avance");
        pi.getFormu().getChamp("idavance").setPageAppelComplete("paie.avance.Avance","id","AVANCE_LIB");
        pi.getFormu().getChamp("datepaiement").setLibelle("Date de paiement");
        pi.getFormu().getChamp("idavance").setLibelle("Avance");
        pi.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
        pi.getFormu().getChamp("idavance").setLibelle("Avance");
        pi.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
        pi.getFormu().getChamp("etat").setVisible(false);

        affichage.Champ[] liste = new affichage.Champ[2];
        Liste l1 = new Liste("debiterSalaire");
        l1.setLibelle("Debiter sur salaire");
        l1.makeListeOuiNon();
        liste[0] = l1;

        Liste l2 = new Liste("mois");
        String[] mois = {
                "Janvier",
                "F&eacute;vrier",
                "Mars",
                "Avril",
                "Mai",
                "Juin",
                "Juillet",
                "Ao&ucirc;t",
                "Septembre",
                "Octobre",
                "Novembre",
                "D&eacute;cembre"
        };
        String[] moisVal = {
                "1",
                "2",
                "3",
                "4",
                "5",
                "6",
                "7",
                "8",
                "9",
                "10",
                "11",
                "12"
        };
        l2.setValeurBrute(mois);
        l2.setColValeurBrute(moisVal);
        liste[1] = l2;

        pi.getFormu().changerEnChamp(liste);

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
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();</script>
<% }%>
