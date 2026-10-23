<%-- 
    Document   : produit-recherche
    Created on : 26 janv. 2024, 10:25:56
    Author     : Angela
--%>




<%@page import="annexe.ProduitLib"%>
<%@page import="annexe.TypeProduit"%>
<%@page import="annexe.Unite"%>
<%@page import="annexe.Categorie"%>
<%@page import="annexe.Produit"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="affichage.Liste"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="produits.IngredientsLib" %>
<%@page import="bean.TypeObjet"%>

<% try{ 
    IngredientsLib t = new IngredientsLib();
    t.setNomTable("AS_INGREDIENTS_LIB");
    String listeCrt[] = {"id", "parfums","libelle","categorieingredient","unite"};
    String listeInt[] = {};
    String libEntete[] = {"id","parfums", "libelle","categorieingredient","unite","pv"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setNpp(10);
    pr.setTitre("Liste des composants ");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("annexe/produit/produit-liste.jsp");
    Liste[] liste = new Liste[2];
    TypeObjet unite = new TypeObjet();
    unite.setNomTable("unite");
    liste[0] = new Liste("unite", unite, "val", "id");
    TypeObjet categorie=new TypeObjet();
    categorie.setNomTable("CATEGORIEINGREDIENTLIB_ACHT");
    liste[1] = new Liste("categorieingredient",categorie,"val","val");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("parfums").setLibelle("Code produit");
    pr.getFormu().getChamp("categorieingredient").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"id"};
    Map<String,String> lienTab=new HashMap<>();
    lienTab.put("modifier",pr.getLien() + "?but=produits/as-ingredients-modif.jsp");
//    lienTab.put("Rendre indisponible",pr.getLien() + "?but=rdv/rdv-saisie.jsp");
//    lienTab.put("Rendre disponible",pr.getLien() + "?but=rdv/rdv-saisie.jsp");
    pr.getTableau().setLienClicDroite(lienTab);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"R&eacute;f&eacute;rence","Code produit", "D&eacute;signation","Cat&eacute;gorie","Unit&eacute;","Prix de vente"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=produits/as-ingredients-saisie.jsp&currentMenu=MENUDYN0304008\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un article</a>"
    );
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



