<%-- 
    Document   : as-tarifproduits-liste
    Created on : 1 d�c. 2016, 10:54:53
    Author     : Joe
--%>
<%@page import="mg.allosakafo.produits.TarifProduits"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.PageRecherche"%>

<% 
    TarifProduits lv = new TarifProduits();
    lv.setNomTable("as_prixproduit_libelle");
    
    String listeCrt[] = {"id", "produit", "dateapplication"};
    String listeInt[] = {"dateapplication"};
    String libEntete[] = {"id", "produit", "montant", "dateapplication", "observation"};

    PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, 5);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    
    pr.setApres("produits/as-tarifproduits-liste.jsp");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
%>
<script>
    function changerDesignation() {
        document.incident.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste prix des produits</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=produits/as-tarifproduits-liste.jsp" method="post" name="incident" id="incident">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>

        </form>
        <%  String lienTableau[] = {pr.getLien() + "?but=produits/as-tarifproduits-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            String libEnteteAffiche[] = {"Id", "Produit", "Montant", "Date application", "Observation"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());

        %>
    </section>
</div>