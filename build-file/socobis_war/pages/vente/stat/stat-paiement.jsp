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
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="vente.stat.VenteParPaiement" %>

<% try{
    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));

    VenteParPaiement t = new VenteParPaiement();
    String listeCrt[] = {"jour","montant_brut","montant_remise_calc","montant_net_ht_calc", "montant_tva_calc", "montant_ttc_calc","mois","annee"};
    String listeInt[] =  {"jour","montant_brut","montant_remise_calc","montant_net_ht_calc", "montant_tva_calc", "montant_ttc_calc","mois","annee"};
    UserEJB user = (user.UserEJB) session.getValue("u");
    MapUtilisateur mapUser = user.getUser();
    String libEntete[] = new String[] {"jour","montant_brut","montant_remise_calc","montant_net_ht_calc", "montant_tva_calc", "montant_ttc_calc","mois","annee"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String[] colSomme = {"montant_brut","montant_remise_calc","montant_net_ht_calc", "montant_tva_calc", "montant_ttc_calc"};

    pr.getFormu().getChamp("jour1").setLibelle("Jour Min");
    pr.getFormu().getChamp("jour2").setLibelle("Jour Max");

    pr.getFormu().getChamp("mois1").setLibelle("Mois Min");
    pr.getFormu().getChamp("mois2").setLibelle("Mois Max");

    pr.getFormu().getChamp("annee1").setLibelle("Ann&eacute;e Min");
    pr.getFormu().getChamp("annee2").setLibelle("Ann&eacute;e Max");

    pr.getFormu().getChamp("montant_brut1").setLibelle("Montant Brut Min");
    pr.getFormu().getChamp("montant_brut2").setLibelle("Montant Brut Max");

    pr.getFormu().getChamp("montant_remise_calc1").setLibelle("Montant Remise Min");
    pr.getFormu().getChamp("montant_remise_calc2").setLibelle("Montant Remise Max");

    pr.getFormu().getChamp("montant_net_ht_calc1").setLibelle("Montant Net HT Min");
    pr.getFormu().getChamp("montant_net_ht_calc2").setLibelle("Montant Net HT Max");

    pr.getFormu().getChamp("montant_tva_calc1").setLibelle("Montant TVA Min");
    pr.getFormu().getChamp("montant_tva_calc2").setLibelle("Montant TVA Max");

    pr.getFormu().getChamp("montant_ttc_calc1").setLibelle("Montant TTC Min");
    pr.getFormu().getChamp("montant_ttc_calc2").setLibelle("Montant TTC Max");

    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableau().transformerDataString();

    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {null};
    String[] attributLien = {"id"};
    String colonneModal[] = {"client"};
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setModalOnClick(true,colonneModal);

    String libEnteteAffiche[] = new String[]{"Date","Montant BRUT","Montant Remise","Montant NET Hors Taxe", "Montant TVA", "Montant TTC","Mois","Ann&eacute;e"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String enteteRecap[] = {"","Nombre","Montant BRUT","Montant Remise","Montant NET Hors Taxe", "Montant TVA", "Montant TTC"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
%>
<script>
    function changerDesignation() {
        document.getElementById("bdlc-liste--form").submit();
    }
</script>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Statistique de Vente par Paiement</h1>
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