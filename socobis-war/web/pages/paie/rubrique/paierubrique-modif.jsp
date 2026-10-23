<%--
    Document   : paierubrique-modif
    Created on : 22 d�c. 2020, 09:53:12
    Author     : Sanda
--%>

<%@page import="paie.employe.PaieRubrique"%>
<%@page import="affichage.PageUpdate"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String mapping = "paie.employe.PaieRubrique",
                nomtable = "paie_rubrique",
                apres = "paie/rubrique/paierubrique-fiche.jsp",
                titre = "Modification de la rubrique de paie";

        PaieRubrique objet = new PaieRubrique();
        objet.setNomTable(nomtable);
        PageUpdate pi = new PageUpdate(objet, request, u);
        pi.setLien((String) session.getValue("lien"));

        pi.getFormu().getChamp("formule").setType("textarea");
        pi.getFormu().getChamp("id").setVisible(false);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("comptepcg").setVisible(false);
        pi.getFormu().getChamp("cpt_gen_db").setVisible(false);
        pi.getFormu().getChamp("cpt_gen_cr").setVisible(false);
        pi.getFormu().getChamp("cpt_ana_db").setVisible(false);
        pi.getFormu().getChamp("cpt_ana_cr").setVisible(false);
        pi.getFormu().getChamp("nature").setVisible(false);
        pi.getFormu().getChamp("bcs").setVisible(false);
        pi.getFormu().getChamp("bg").setVisible(false);
        pi.getFormu().getChamp("avantage").setVisible(false);
        pi.getFormu().getChamp("formule").setVisible(false);
        pi.getFormu().getChamp("comptepcg").setPageAppel("choix/comptaCompteChoix.jsp");
        pi.getFormu().getChamp("cpt_gen_db").setPageAppel("choix/comptaCompteChoix.jsp");
        pi.getFormu().getChamp("cpt_gen_cr").setPageAppel("choix/comptaCompteChoix.jsp");
        pi.getFormu().getChamp("cpt_ana_db").setPageAppel("choix/comptaCompteChoix.jsp");
        pi.getFormu().getChamp("cpt_ana_cr").setPageAppel("choix/comptaCompteChoix.jsp");
        pi.getFormu().getChamp("isinfini").setLibelle("Nature");
        pi.getFormu().getChamp("typerubrique").setLibelle("Type rubrique");
        pi.getFormu().getChamp("val").setLibelle("Libell&eacute;");
        pi.getFormu().getChamp("desce").setLibelle("Abr&eacute;viation");
        pi.getFormu().getChamp("rang").setLibelle("Rang");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("comptepcg").setLibelle("Compte PCG");
        pi.getFormu().getChamp("code").setLibelle("Code Rubrique");
        pi.getFormu().getChamp("typerubrique").setLibelle("Type de rubrique");
        pi.getFormu().getChamp("bcs").setLibelle("Base cotisation");
        pi.getFormu().getChamp("bg").setLibelle("Base gratification");
        pi.getFormu().getChamp("imposable").setLibelle("Imposable");
        pi.getFormu().getChamp("cpt_ana_cr").setLibelle("CPT ANAL CR");
        pi.getFormu().getChamp("cpt_ana_db").setLibelle("CTP ANAL DB");
        pi.getFormu().getChamp("cpt_gen_db").setLibelle("CPT GEN DB");
        pi.getFormu().getChamp("cpt_gen_cr").setLibelle("CPT GEN CR");
        pi.getFormu().getChamp("desce").setVisible(false);
        pi.getFormu().getChamp("rang").setVisible(false);
        pi.getFormu().getChamp("bcs").setVisible(false);
        pi.getFormu().getChamp("bg").setVisible(false);
        pi.getFormu().getChamp("rang").setVisible(false);
        pi.getFormu().getChamp("isinfini").setVisible(false);
        pi.getFormu().getChamp("afficher").setVisible(false);
        pi.getFormu().getChamp("regroupement").setVisible(false);
        pi.getFormu().getChamp("arrondi").setVisible(false);
        pi.getFormu().getChamp("inserted").setVisible(false);
        pi.getFormu().getChamp("sommable").setVisible(false);
        pi.getFormu().getChamp("beneficiaire").setVisible(false);
        pi.getFormu().getChamp("remarqueFormule").setVisible(false);
        pi.getFormu().getChamp("uniteFormule").setVisible(false);
        pi.getFormu().getChamp("qteFormule").setVisible(false);
        pi.getFormu().getChamp("majoration").setVisible(false);
        pi.getFormu().getChamp("qte").setVisible(false);
        pi.getFormu().getChamp("pu").setVisible(false);

        affichage.Champ[] liste = new affichage.Champ[4];
        Liste l1 = new Liste("typerubrique");
        l1.setLibelle("Type de rubrique");
        String a1[] = {"Gain", "Retenue"};
        String v1[] = {"G", "R"};
        l1.setValeurBrute(a1);
        l1.setColValeurBrute(v1);
        liste[0] = l1;
//
//        Liste l2 = new Liste("bcs");
//        String a2[] = {"Non", "Oui"};
//        String v2[] = {"", "C"};
//        l2.setValeurBrute(a2);
//        l2.setColValeurBrute(v2);
//        liste[1] = l2;
//
//        Liste l3 = new Liste("bg");
//        String a3[] = {"Non", "Oui"};
//        String v3[] = {"", "G"};
//        l3.setValeurBrute(a3);
//        l3.setColValeurBrute(v3);
//        liste[2] = l3;

        Liste l4 = new Liste("imposable");
        String a4[] = {"Non", "Oui"};
        String v4[] = {"", "I"};
        l4.setValeurBrute(a4);
        l4.setColValeurBrute(v4);
        liste[1] = l4;

        Liste l5 = new Liste("nature");
        String a5[] = {"Fixe", "Variable"};
        String v5[] = {"fixe", "variable"};
        l5.setValeurBrute(a5);
        l5.setColValeurBrute(v5);
        liste[2] = l5;

        Liste l6 = new Liste("avantage");
        String a6[] = {"Non", "Oui"};
        String v6[] = {"", "A"};
        l6.setValeurBrute(a6);
        l6.setColValeurBrute(v6);
        liste[3] = l6;

//        Liste l7 = new Liste("isinfini");
//        String a7[] = {"Fixe", "Automatique"};
//        String v7[] = {"0", "1"};
//        l7.setValeurBrute(a7);
//        l7.setColValeurBrute(v7);
//        liste[6] = l7;


//        Liste l8 = new Liste("afficher");
//        String a8[] = {"Non", "Oui"};
//        String v8[] = {"0", "1"};
//        l8.setValeurBrute(a8);
//        l8.setColValeurBrute(v8);
//        liste[7] = l8;

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
        <input name="acte" type="hidden" id="nature" value="update">
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
