<%@page import="affichage.PageRecherche"%>
<%@ page import="maintenance.configuration.Entite" %>
<%@ page import="affichage.Liste" %>
<%@ page import="maintenance.configuration.SousCategorieEntite" %>

<% try{
  SousCategorieEntite t = new SousCategorieEntite();
  t.setNomTable("souscategorieentite_cpl");
  String listeCrt[] = {"id", "val","idEntite"};
  String listeInt[] = {};
  String libEntete[] = {"id", "val","idEntiteLib"};
  PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
  pr.setTitre("Liste des cat&eacute;gories de maintenance");
  pr.setUtilisateur((user.UserEJB) session.getValue("u"));
  pr.setLien((String) session.getValue("lien"));
  pr.setApres("maintenance/configuration/souscategorieentite/sous-categorie-entite-liste.jsp");
  Liste[] liste = new Liste[1];
  Entite c = new Entite();
  liste[0] = new Liste("idEntite",c,"val","id");
  pr.getFormu().changerEnChamp(liste);
  pr.getFormu().getChamp("id").setLibelle("Id");
  pr.getFormu().getChamp("val").setLibelle("Libell&eacute;");
  pr.getFormu().getChamp("idEntite").setLibelle("Description");
  String[] colSomme = null;
  pr.creerObjetPage(libEntete, colSomme);

  //Definition des lienTableau et des colonnes de lien
  String lienTableau[] = {pr.getLien() + "?but=maintenance/configuration/souscategorieentite/sous-categorie-entite-fiche.jsp"};
  String colonneLien[] = {"id"};
  pr.getTableau().setLien(lienTableau);
  pr.getTableau().setColonneLien(colonneLien);
  String libEnteteAffiche[] = {"ID", "Libell&eacute;", "Entit&eacute;"};
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



