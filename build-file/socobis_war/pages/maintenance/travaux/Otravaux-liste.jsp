<%@page import="affichage.PageRecherche"%>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="maintenance.travaux.OrdreTravaux" %>

<% try{
  OrdreTravaux t = new OrdreTravaux();
  t.setNomTable("OTRAVLIB");
  String listeCrt[] = {"id", "lancepar", "remarque", "libelle", "besoin", "daty"};
  String listeInt[] = {"daty","besoin"};
  String libEntete[] = {"id", "daty", "besoin", "libelle", "lancepar", "remarque"};
  PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
  pr.setTitre("Liste des ordres de travaux");
  pr.setUtilisateur((user.UserEJB) session.getValue("u"));
  pr.setLien((String) session.getValue("lien"));
  pr.setApres("maintenance/travaux/Otravaux-liste.jsp");
  pr.getFormu().getChamp("daty1").setLibelle("Date min");
  pr.getFormu().getChamp("daty2").setLibelle("Date max");
  pr.getFormu().getChamp("besoin1").setLibelle("Date de Besoin min");
  pr.getFormu().getChamp("besoin2").setLibelle("Date de Besoin max");
  pr.getFormu().getChamp("lancepar").setLibelle("Lanc&eacute; par");
  pr.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
  String[] colSomme = null;
  pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.getDebutSemaineString());
  pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.getFinSemaineString());
  pr.getFormu().getChamp("besoin1").setDefaut(Utilitaire.getDebutSemaineString());
  pr.getFormu().getChamp("besoin2").setDefaut(Utilitaire.getFinSemaineString());

  if(request.getParameter("id")!=null && request.getParameter("id").compareToIgnoreCase("")!=0) {
    pr.getFormu().getChamp("id").setDefaut(request.getParameter("id"));
  }
  if(request.getParameter("etaty")!=null && request.getParameter("etaty").compareToIgnoreCase("")!=0) {
    pr.setAWhere(" and etat>=" + request.getParameter("etaty"));
  }

  pr.creerObjetPage(libEntete, colSomme);

  //Definition des lienTableau et des colonnes de lien
  String lienTableau[] = {pr.getLien() + "?but=maintenance/travaux/Otravaux-fiche.jsp"};
  String colonneLien[] = {"id"}; // Colonne contenant un lien, passé comme paramètre dans l'URL
  pr.getTableau().setLien(lienTableau);
  pr.getTableau().setColonneLien(colonneLien);
  //Remplacer le nom de l'attribut passé dans l'URL, par exemple passer 'idObjet' au lieu de 'id' du colonneLien
  String[] attributLien = {"id"};
  pr.getTableau().setAttLien(attributLien);

  //Definition des libelles à afficher
  String libEnteteAffiche[] = {"ID", "Date","Date de besoin","D&eacute;signation","Lanc&eacute; par", "Remarque"};
  pr.getTableau().setLibelleAffiche(libEnteteAffiche);
  pr.getTableau().setLienFille("maintenance/travaux/inc/ordre-fabrication-details.jsp&id=");
//      pr.getFormu().setAnotherButton(
//            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=maintenance/travaux/Otravaux-saisie.jsp&currentMenu=MNDNMT0117\">\n" +
//            "                    <i class=\"material-symbols-rounded\">add</i>Saisir un ordre de travaux" +
//            "                </a>"
//    );

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



