<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 28/10/2025
  Time: 09:24
  To change this template use File | Settings | File Templates.
--%>
<%@page import="user.UserEJB"%>
<%@page import="bean.*"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Liste" %>
<%@ page import="paie.edition.PeriodePaie" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="paie.categorie.CategoriePaie" %>

<%
  try {
    PeriodePaie pp = new PeriodePaie();
    pp.setNomTable("PERIODEPAIELIB");
    String listeCrt[] = {"id", "mois", "datedebut", "datefin", "annee", "categorieLib"};
    String listeInt[] = {"mois"};
    String libEntete[] = {"id", "moislib", "datedebut", "datefin", "annee", "categorieLib"};
    PageRecherche pr = new PageRecherche(pp, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des p&eacute;riodes de paie");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/editions/periodepaie-liste.jsp");
    affichage.Champ[] liste = new affichage.Champ[3];
    Liste moisListe = new Liste("mois1");
    moisListe.makeListeMois();
    Liste moisListe2 = new Liste("mois2");
    moisListe2.makeListeMois();
    liste[0] = moisListe;
    liste[1] = moisListe2;
    CategoriePaie cp = new CategoriePaie();
    liste[2] = new Liste("categorieLib", cp, "val", "val");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("mois1").setLibelle("Mois min");
    pr.getFormu().getChamp("mois2").setLibelle("Mois max");
    pr.getFormu().getChamp("datedebut").setDefaut(utilitaire.Utilitaire.dateDuJour() + "");
    pr.getFormu().getChamp("datefin").setDefaut(utilitaire.Utilitaire.dateDuJour() + "");
    pr.getFormu().getChamp("datedebut").setLibelle("Date de d&eacute;but");
    pr.getFormu().getChamp("datefin").setLibelle("Date de fin");
    pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
    pr.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());
    pr.getFormu().getChamp("categorieLib").setLibelle("Cat&eacute;gorie");


    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=paie/editions/periodepaie-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String libEnteteAffiche[] = { "ID", "Mois","Date de d&eacute;but","Date de fin", "Ann&eacute;e", "Cat&eacute;gorie"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    pr.getFormu().setAnotherButton(
          "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=paie/editions/periodepaie-saisie.jsp&currentMenu=MENDYN1765357238059192\">\n" +
          "                    <i class=\"material-symbols-rounded\">add</i>Saisir une p&eacute;riode de paie" +
          "                </a>"
    );
%>

<div class="content-wrapper">

  <div class="row">
    <section class="content-header">
      <h1><%= pr.getTitre() %></h1>
    </section>
  </div>

  <section class="content">
    <div class="row">
      <div class="col-md-12">
        <form action="<%= pr.getLien() %>?but=<%= pr.getApres() %>" method="post" name="recap" id="recap">
          <%= pr.getFormu().getHtmlEnsemble() %>
        </form>

        <%= pr.getTableauRecap().getHtml() %>
        <br>

        <%= pr.getTableau().getHtml() %>
        <%= pr.getBasPage() %>
      </div>
    </div>
  </section>

</div>

<script>
  function changerDesignation() {
    document.recap.submit();
  }
</script>

<%
  } catch (Exception e) {
    e.printStackTrace();
  }
%>

