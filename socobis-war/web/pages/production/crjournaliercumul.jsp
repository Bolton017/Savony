<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="production.CrProdJournalierAvecCumul" %>
<%@ page import="affichage.Liste"%>
<%@ page import="produits.IngredientsLib" %>
<%@ page import="produits.Ingredients" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{ 
    CrProdJournalierAvecCumul o = new CrProdJournalierAvecCumul();
    o.setNomTable("CRPRODJOURNALIERAVECCUMUL");
    String[] listeCrt = {"daty","idIngredients"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"idIngredients","libelle","daty","qteCarton","qteFabrique","qteKg","qteFabriqueKg","objectif","ecartObjectif","cumulMois"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("CR de production journalier");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("production/crjournaliercumul.jsp");
    
//    Liste[] liste = new Liste[1];
//    Ingredients liste0 = new Ingredients();
//    liste0.setNomTable("AS_INGREDIENTS_LIB");
//    liste[0] = new Liste("idIngredients",liste0,"libelle","id");
//    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.getDebutAnnee(Utilitaire.getAnnee(Utilitaire.dateDuJour())));
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idIngredients").setLibelle("Produit");
    pr.getFormu().getChamp("idIngredients").setPageAppelComplete("produits.Ingredients","libelle", "id");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id Produit", "Libell&eacute;","Date","Quantit&eacute; en cartons","Quantit&eacute; fabriqu&eacute;e","Quantit&eacute; en kg","Quantit&eacute; fabriqu&eacute;e en kg","Objectif","&Eacute;cart &agrave; l'objectif","Cumul du mois"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
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

