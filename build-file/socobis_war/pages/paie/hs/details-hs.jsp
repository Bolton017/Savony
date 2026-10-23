<%@page import="user.UserEJB"%>
<%@page import="bean.*"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Liste" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="mg.cnaps.paie.PaiePersonnelElementpaie" %>

<%

    try{
        PaiePersonnelElementpaie hmc = new PaiePersonnelElementpaie();
        hmc.setNomTable("HS_GROUPE");
        String listeCrt[] = {"id","matricule","nomPersonnel","date_debut","date_fin"};
        String listeInt[] = {"date_debut","date_fin"};
        String libEntete[] = {"id","matricule","nomPersonnel","hs_30_NI","hs_30_I","hs_50_NI","hs_50_I","date_debut","date_fin","etatlib"};
        PageRecherche pr = new PageRecherche(hmc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setTitre("Liste des d&eacute;tails HS");
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("paie/hs/details-hs.jsp");
        pr.getFormu().getChamp("id").setLibelle("id");
        pr.getFormu().getChamp("matricule").setLibelle("Matricule");
        pr.getFormu().getChamp("nomPersonnel").setLibelle("Personnel");
        pr.getFormu().getChamp("date_debut1").setLibelle("Date de d&eacute;but min");
        pr.getFormu().getChamp("date_debut2").setLibelle("Date de d&eacute;but max");
        pr.getFormu().getChamp("date_fin1").setLibelle("Date de fin min");
        pr.getFormu().getChamp("date_fin2").setLibelle("Date de fin max");
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);

        String lienTableau[] = {pr.getLien() + "?but=paie/fonction/paiepersonnelelementpaie-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);

        String libEnteteAffiche[] = { "Id","Matricule", "Personnel","HS 30% NI","HS 30% I","HS 50% NI","HS 50% I","Date de d&eacute;but", "Date de fin", "&Eacute;tat"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        
%>
        

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