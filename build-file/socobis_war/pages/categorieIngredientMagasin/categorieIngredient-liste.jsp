<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="magasin.CategorieIngredientMagasinLib" %>
<%@ page import="affichage.Liste"%>
<%@ page import="bean.TypeObjet" %>
<%@ page import="produits.CategorieIngredient" %>

<% try{ 
    CategorieIngredientMagasinLib o = new CategorieIngredientMagasinLib();
    o.setNomTable("V_CATEGORIEINGREDIENTMAGLIB");
    String[] listeCrt = {"idMagasinLib","idCategorieIngredientLib"};
    String[] listeInt = {};
    String[] libEntete = {"id","idMagasin","idMagasinLib","idCategorieIngredientLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des Cat&eacute;gories d’Ingr&eacute;dient par Magasin");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("categorieIngredientMagasin/categorieIngredient-liste.jsp");
    
    Liste[] liste = new Liste[2];
    TypeObjet liste0 = new TypeObjet();
    liste0.setNomTable("MAGASINPOINT");
    liste[0] = new Liste("idMagasinLib",liste0,"val","val");
    CategorieIngredient liste1 = new CategorieIngredient();
    liste1.setNomTable("CATEGORIEINGREDIENT");
    liste[1] = new Liste("idCategorieIngredientLib",liste1,"val","val");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("idMagasinLib").setLibelle("Magasin");
    pr.getFormu().getChamp("idCategorieIngredientLib").setLibelle("Cat&eacute;gorie ingredient");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=categorieIngredientMagasin/categorieIngredient-fiche.jsp",pr.getLien() + "?but=magasin/magasin-fiche.jsp"};
    String[] colonneLien = {"id","idMagasin"};
    String[] attributLien = {"id","idMagasin"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","id Magasin","Magasin","Cat&eacute;gorie d'ingr&eacute;dient"};
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

