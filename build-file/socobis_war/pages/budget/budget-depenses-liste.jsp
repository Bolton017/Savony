<%@page import="affichage.*"%>
<%@page import="prevision.*"%>
<%@page import="user.*"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="budget.SituationBudgetDepenses" %>

<%

    try{
        SituationBudgetDepenses situation = new SituationBudgetDepenses();
        situation.setNomTable("situation_budget_depenses");
        String[] intervalles = {};
        String[] criteres = {"service", "compte", "mois", "annee"};
        String[] libEntete = {"service", "compte", "moislib", "annee","budget","montantfacture","paiement","resteapayer","ecartfacturebudget"};
        String[] libEnteteAffiche = {"D&eacute;partement", "Compte", "Mois", "ann&eacute;e","Budget D&eacute;penses","Engag&eacute;","Pay&eacute;","Reste &agrave; payer","Disponible"};
        PageRecherche pr = new PageRecherche( situation, request, criteres, intervalles, 3, libEntete, libEntete.length );
        pr.setAWhere(" AND compte like '6%'");
        pr.setTitre("Situation budgetaire des d&eacute;penses");
        pr.setUtilisateur((UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        pr.setApres("budget/budget-depenses-liste.jsp");
        Liste[] liste = new Liste[1];
        String[] valMois = {"1","2","3","4","5","6","7","8","9","10","11","12"};
        String[] affMois = {"Janvier","F&eacute;vrier","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","D&eacute;cembre"};
        liste[0] = new Liste("mois" ,affMois,valMois);
        pr.getFormu().changerEnChamp(liste);
        pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
        String[] colSomme = {"budget","montantfacture","resteapayer","paiement","ecartfacturebudget"};
        pr.creerObjetPage(libEntete, colSomme);

        Map<String,String> lienTab=new HashMap();
        lienTab.put("modifier",pr.getLien() + "?but=budget/budget-modif.jsp");
        pr.getTableau().setLienClicDroite(lienTab);

        //Definition des lienTableau et des colonnes de lien
        String lienTableau[] = {pr.getLien() + "?but=budget/budget-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);

%>


<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="budget" id="budget">
            <%
                String libelles[]={" ","Nombre", "Total Budget D&eacute;penses","Total D&eacute;penses","Total Reste &agrave; payer D&eacute;penses","Total D&eacute;penses pay&eacute;s","Total &eacute;cart Budget et Effectif"};
                pr.getTableauRecap().setLibeEntete(libelles);
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

