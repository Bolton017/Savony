<%--
    Document   : as-produits-liste
    Created on : 1 d�c. 2016, 10:39:44
    Author     : Joe
--%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="produits.Ingredients"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="produits.IngredientsLib" %>

<%
  try
  {
    IngredientsLib lv = new IngredientsLib();
    lv.setNomTable("Matiere_premiere_ACTIF");

    String listeCrt[] = {"id","libelle", "unite"};
    String listeInt[] = {};
    String libEntete[] = {"id", "libelle", "unite",};


    PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
    affichage.Champ[] liste = new affichage.Champ[1];

    TypeObjet ou = new TypeObjet();
    ou.setNomTable("as_unite");
    liste[0] = new Liste("unite", ou, "VAL", "VAL");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("unite").setLibelle("Unit&eacute;");

    pr.setApres("produits/matiere-premieres.jsp");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String libEnteteAffiche[] = { "Id","D&eacute;signation", "Unit&eacute;"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>
<script>
  function changerDesignation() {
    document.incident.submit();
  }
</script>
<div class="content-wrapper">
  <section class="content-header">
    <h1>Liste ingredients</h1>
  </section>
  <section class="content">
    <form action="<%=pr.getLien()%>?but=produits/produit-fini-liste.jsp" method="post" name="incident" id="incident">
      <%
        out.println(pr.getFormu().getHtmlEnsemble());
      %>

    </form>
    <%  String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
      String colonneLien[] = {"id"};
      pr.getTableau().setLien(lienTableau);
      pr.getTableau().setColonneLien(colonneLien);
      out.println(pr.getTableauRecap().getHtml());%>
    <br>
    <%

      out.println(pr.getTableau().getHtml());
      out.println(pr.getBasPage());

    %>
  </section>
</div>
<%
  }
  catch (Exception e)
  {
    e.printStackTrace();
  }
%>