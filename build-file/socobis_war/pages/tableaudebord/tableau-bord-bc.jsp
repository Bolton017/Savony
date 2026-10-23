<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>

<%@ page import="java.sql.Date" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.DayOfWeek" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@page import="tableaudebord.TableauBordBc" %>
<%@page import="user.*" %>
<%@page import="bean.*" %>
<%@page import="utilitaire.*" %>
<%@page import="affichage.*" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.Map" %>
<%@ page import="tableaudebord.PageRechercheTableauBord" %>

<%
  try {
    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(DayOfWeek.MONDAY));
    LocalDate sunday = today.with(nextOrSame(DayOfWeek.SUNDAY));

    TableauBordBc tableauBordBc = new TableauBordBc();

    String[] listeCritere = { "daty" , "libelleProduit" };
    String[] listeInt = { "daty" };
    String[] libEntete = { "produit", "libelleProduit","quantite", "qteOf", "qteOfRestante", "qteFab", "qteFabRestante" };
    String[] colSomme = null;

    PageRecherche pr = new PageRecherche(tableauBordBc, request, listeCritere, listeInt, 3, libEntete, libEntete.length);

    pr.setTitre("Tableau de bord des bons de commande");
    pr.setUtilisateur((UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("tableaudebord/tableau-bord-bc.jsp");

    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.datetostring(Date.valueOf(sunday)));
    pr.getFormu().getChamp("libelleProduit").setLibelle("Produit");

    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = { pr.getLien() + "?but=annexe/produit/produit-fiche.jsp" };
    String[] colonneLien = { "PRODUIT" };

    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String[] attributLien = { "PRODUIT" };
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {
      "ID Produit",
      "Produit",
      "Quantit&eacute;",
      "Quantit&eacute; Ordre de fabrication",
      "Quantit&eacute; Ordre de fabrication restante",
      "Quantit&eacute; Fabriqu&eacute;",
      "Quantit&eacute; Fabriqu&eacute; restante"
    };

    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
      System.out.println("LENGHT=="+pr.getTableau().getData().length);
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
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>

<%
  } catch (Exception e) {
    e.printStackTrace();
  }
%>