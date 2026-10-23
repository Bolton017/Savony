<%@page import="affichage.*"%>
<%@page import="prevision.*"%>
<%@page import="user.*"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="budget.SituationBudgetRecettesAnnuel" %>

<% try{
    SituationBudgetRecettesAnnuel situation = new SituationBudgetRecettesAnnuel();
    situation.setNomTable("SITUATION_BUDGET_RECETTES_VIDE");
    String[] intervalles = {"moisdebut"};
    String[] criteres = { "compte", "annee","moisdebut"};
    String[] libEntete = {"compte", "annee","moisdebutlib","moisfinlib","budget","montantfacture","resteapayer","paiement","ecartfacturebudget","ecartbudgetpaiement"};
    String[] libEnteteAffiche = {"Compte", "Ann&eacute;e","Mois d&eacute;but","Mois fin","Budget Recettes","Recettes","Reste &agrave; payer Recettes","Recettes pay&eacute;s","&eacute;cart Budget et Effectif","&eacute;cart Budget Paiement"};
    PageRecherche pr = new PageRecherche( situation, request, criteres, intervalles, 4, libEntete, libEntete.length );
    affichage.Champ[] liste = new affichage.Champ[2];
    Liste listeMois = new Liste("moisdebut1");
    listeMois.makeListeMois();
    liste[0] = listeMois;

    Liste listeMois2 = new Liste("moisdebut2");
    listeMois2.makeListeMois();
    liste[1] = listeMois2;

    pr.getFormu().changerEnChamp(liste);

    pr.setTitre("Situation budgetaire des d&eacute;penses annuelles");
    pr.setUtilisateur((UserEJB) session.getAttribute("u"));
    pr.setLien((String) session.getAttribute("lien"));
    pr.getFormu().getChamp("moisdebut1").setDefaut(""+1);
    pr.getFormu().getChamp("moisdebut2").setDefaut(""+12);
    pr.getFormu().getChamp("moisdebut1").setLibelle("Mois d&eacute;but");
    pr.getFormu().getChamp("moisdebut2").setLibelle("Mois fin");
    pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
    pr.setApres("budget/budget-recettes-annuel.jsp");
    String[] colSomme = {};
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
    String[] libelles ={" ","Nombre", "Total Budget Recettes","Total Recettes","Total Reste &agrave; payer Recettes","Total Recettes pay&eacute;s","Total &eacute;cart Budget et Effectif"};
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


<% }catch(Exception e){
    e.printStackTrace();
}
%>

