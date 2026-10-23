<%@page import="affichage.*"%>
<%@page import="prevision.*"%>
<%@page import="user.*"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="budget.SituationBudgetDepenses" %>

<% try{
    SituationBudgetDepenses situation = new SituationBudgetDepenses();
    situation.setNomTable("SITUATION_BUDGET_RECETTES");
    String[] intervalles = {};
    String[] criteres = {"compte", "mois", "annee"};
    String[] libEntete = {"compte", "moislib", "annee","budget","montantfacture","paiement","resteapayer","ecartfacturebudget"};
    String[] libEnteteAffiche = {"Compte", "Mois", "ann&eacute;e","Budget Recettes","Engag&eacute;","Pay&eacute;","Reste &agrave; payer","Disponible"};
    PageRecherche pr = new PageRecherche( situation, request, criteres, intervalles, 3, libEntete, libEntete.length );
    pr.setTitre("Situation budgetaire des d&eacute;penses");
    pr.setUtilisateur((UserEJB) session.getAttribute("u"));
    pr.setLien((String) session.getAttribute("lien"));
    pr.setAWhere(" AND compte like '7%'");

    pr.setApres("budget/budget-recettes-liste.jsp");
    Liste[] liste = new Liste[1];
    String[] valMois = {"1","2","3","4","5","6","7","8","9","10","11","12"};
    String[] affMois = {"Janvier","F&eacute;vrier","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","D&eacute;cembre"};
    liste[0] = new Liste("mois" ,affMois,valMois);
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
    String[] colSomme = {"budget","montantfacture","resteapayer","paiement","ecartfacturebudget"};
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap<>();
    lienTab.put("modifier",pr.getLien() + "?but=budget/budget-modif.jsp");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String[] lienTableau = {pr.getLien() + "?but=budget/budget-fiche.jsp"};
    String[] colonneLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] libelles = {" ","Nombre", "Total Budget Recettes","Total Recettes","Total Reste &agrave; payer Recettes","Total Recettes pay&eacute;s","Total &eacute;cart Budget et Effectif"};
    pr.getTableauRecap().setLibeEntete(libelles);
%>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="budget" id="budget">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <br>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <%
            out.println(pr.getTableau().getHtml());
        %>
        <%
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>
