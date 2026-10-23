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
    lv.setNomTable("as_ingredients_lib");
    
    String listeCrt[] = {"id","libelle", "unite","idcategorie"};
    String listeInt[] = null;
    String libEntete[] = {"id", "libelle", "unite", "pu", "quantiteparpack", "seuil","categorieingredient"};

    
    PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    
    affichage.Champ[] liste = new affichage.Champ[2];
	
    TypeObjet ou = new TypeObjet();
    ou.setNomTable("as_unite");
    liste[0] = new Liste("unite", ou, "VAL", "VAL");
    
    TypeObjet ob = new TypeObjet();
    ob.setNomTable("CATEGORIEINGREDIENT");
    liste[1] = new Liste("idcategorie", ob, "val", "id");
    pr.getFormu().changerEnChamp(liste);
    
    
    pr.setApres("produits/as-ingredients-liste.jsp");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

        pr.getFormu().setAnotherButton("" +
                "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=produits/as-ingredients-saisie.jsp&currentMenu=MENUDYN0304008\">\n" +
                "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un ingredient</a>"
        );
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
        <form action="<%=pr.getLien()%>?but=produits/as-ingredients-liste.jsp" method="post" name="incident" id="incident">
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