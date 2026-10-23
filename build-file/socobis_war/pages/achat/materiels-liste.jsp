<%@page import="affichage.PageRecherche"%>
<%@page import="affichage.Liste"%>
<%@ page import="produits.IngredientsLib" %>
<%@page import="bean.TypeObjet"%>

<% try {
    IngredientsLib t = new IngredientsLib();
    t.setNomTable("AS_INGREDIENTS_LIB");
    String[] listeCrt = {"id","libelle","unite"};
    String[] listeInt = {};
    String[] libEntete = {"id", "libelle","unite","pu"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setAWhere(" AND IDCATEGORIEINGREDIENT != 'CAT008' AND IDCATEGORIEINGREDIENT != 'CAT001'");
    pr.setTitre("Liste des mat&eacute;riels");
    pr.setUtilisateur((user.UserEJB) session.getAttribute("u"));
    pr.setLien((String) session.getAttribute("lien"));
    pr.setApres("achat/materiels-liste.jsp");
    Liste[] liste = new Liste[2];
    TypeObjet unite = new TypeObjet();
    unite.setNomTable("unite");
    liste[0] = new Liste("unite", unite, "val", "id");
    TypeObjet categorie=new TypeObjet();
    categorie.setNomTable("CATEGORIEINGREDIENTLIB_ACHT");
    liste[1] = new Liste("categorieingredient",categorie,"val","val");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("Id Produit");
    pr.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
    pr.creerObjetPage(libEntete, null);
    String[] lienTableau = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String[] colonneLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String[] libEnteteAffiche = {"Id Produit", "D&eacute;signation","Unit&eacute;","Prix unitaire"};
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
    <% } catch(Exception e) {
        e.printStackTrace();
    }
%>



