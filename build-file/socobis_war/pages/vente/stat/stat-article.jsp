<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 21/08/2025
  Time: 16:29
  To change this template use File | Settings | File Templates.
--%>

<%@page import="affichage.PageRecherche"%>
<%@ page import="fabrication.*" %>
<%@ page import="produits.Ingredients" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.Date" %>
<%@ page import="historique.MapUtilisateur" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="vente.stat.VenteParArticle" %>

<% try{
    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));

    VenteParArticle t = new VenteParArticle();
    String listeCrt[] = {"designation","categorieproduitlib","qte_totale","montant_ht", "montant_tva", "montant_ttc", "montant_remise", "poids_total", "frais_total","mois","annee"};
    String listeInt[] = {"qte_totale","montant_ht", "montant_tva", "montant_ttc", "montant_remise", "poids_total", "frais_total","mois","annee"};
    UserEJB user = (user.UserEJB) session.getValue("u");
    MapUtilisateur mapUser = user.getUser();
    String libEntete[] = new String[]{"idProduit","designation","categorieproduitlib","qte_totale","montant_ht", "montant_tva", "montant_ttc", "montant_remise", "poids_total", "frais_total","mois","annee"};

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String[] colSomme = {"qte_totale","montant_ttc","poids_total","frais_total"};

    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("categorieproduitlib").setLibelle("Cat&eacute;gorie");


    pr.getFormu().getChamp("mois1").setLibelle("Mois Min");
    pr.getFormu().getChamp("mois2").setLibelle("Mois Max");

    pr.getFormu().getChamp("annee1").setLibelle("Ann&eacute;e Min");
    pr.getFormu().getChamp("annee2").setLibelle("Ann&eacute;e Max");

    pr.getFormu().getChamp("qte_totale1").setLibelle("Quantit&eacute; Min");
    pr.getFormu().getChamp("qte_totale2").setLibelle("Quantit&eacute; Max");

    pr.getFormu().getChamp("montant_ht1").setLibelle("Montant HT Min");
    pr.getFormu().getChamp("montant_ht2").setLibelle("Montant HT Max");

    pr.getFormu().getChamp("montant_tva1").setLibelle("Montant TVA Min");
    pr.getFormu().getChamp("montant_tva2").setLibelle("Montant TVA Max");

    pr.getFormu().getChamp("montant_ttc1").setLibelle("Montant TTC Min");
    pr.getFormu().getChamp("montant_ttc2").setLibelle("Montant TTC Max");

    pr.getFormu().getChamp("montant_remise1").setLibelle("Montant Remise Min");
    pr.getFormu().getChamp("montant_remise2").setLibelle("Montant Remise Max");

    pr.getFormu().getChamp("poids_total1").setLibelle("Poids Min");
    pr.getFormu().getChamp("poids_total2").setLibelle("Poids Max");

    pr.getFormu().getChamp("frais_total1").setLibelle("Frais Min");
    pr.getFormu().getChamp("frais_total2").setLibelle("Frais Max");





    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableau().transformerDataString();

    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"idProduit"};
    String[] attributLien = {"id"};
    String colonneModal[] = {"idProduit"};
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setModalOnClick(true,colonneModal);

    String libEnteteAffiche[] = new String[]{"ID","D&eacute;signation","Cat&eacute;gorie","Quantit&eacute;","Montant HT","Montant TVA","Montant TTC","Montant Remise","Poids","Frais","Mois","Ann&eacute;e"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String enteteRecap[] = {"","Nombre","Quantit&eacute; Total","Montant TTC Total","Poids Total","Frais Total"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
%>
<script>
    function changerDesignation() {
        document.getElementById("bdlc-liste--form").submit();
    }
</script>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Statistique de Vente par Article</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bdlc-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>