<%@page import="user.UserEJB"%>
<%@page import="bean.*"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Liste" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="paie.hs.HsMoisCpl" %>

<%

    try{

        HsMoisCpl hmc = new HsMoisCpl();
        hmc.setNomTable("HSMOIS_CPL");
        String listeCrt[] = {"id", "moisLib", "annee", "idCategorie", "idDepartement", "daty"};
        String listeInt[] = {};
        String libEntete[] = {"id", "moisLib", "annee", "idCategorieLib", "idDepartementLib", "daty", "etatLib"};
        PageRecherche pr = new PageRecherche(hmc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setTitre("HS Mois Liste");
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("paie/hs/hsmois-liste.jsp");

        affichage.Champ[] liste = new affichage.Champ[2];

        TypeObjet categorie = new TypeObjet();
        categorie.setNomTable("CATEGORIE_PAIE_SALAIRE");
        Liste l1 = new Liste("idCategorie", categorie, "val", "val");
        liste[0] = l1;

        TypeObjet departement = new TypeObjet();
        departement.setNomTable("DEPARTEMENT");
        Liste l2 = new Liste("idDepartement", departement, "val", "val");
        liste[1] = l2;
    

        pr.getFormu().changerEnChamp(liste);
        pr.getFormu().getChamp("id").setLibelle("id");
        pr.getFormu().getChamp("moisLib").setLibelle("Mois");
        pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
        pr.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());
        pr.getFormu().getChamp("idCategorie").setLibelle("Categorie");
        pr.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement");
        pr.getFormu().getChamp("daty").setLibelle("Date");
        pr.getFormu().getChamp("daty").setDefaut(utilitaire.Utilitaire.dateDuJour() + "");

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);

        String lienTableau[] = {pr.getLien() + "?but=paie/hs/hsmois-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);

        String libEnteteAffiche[] = { "ID", "Mois", "Ann&eacute;e", "Categorie", "D&eacute;partement", "Date", "&Eacute;tat"};
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