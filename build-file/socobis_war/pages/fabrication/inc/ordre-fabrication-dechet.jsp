

<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="affichage.*" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="stock.MvtStockFilleLib" %>

<%
    try{
        MvtStockFilleLib t = new MvtStockFilleLib();
        t.setNomTable("MVTSTFILLEOFCATVISEGROUPE");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"idProduit", "libelle","categorieIngredient","entree","montant"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idof='"+request.getParameter("id")+"' and entree>0 and CATEGORIEINGREDIENT ='Déchets'");
        }
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =   {"ID Produit","D&eacute;signation","Categorie", "Entr&eacute;e", "Montant"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneLien[] = {"idProduit"};
        String[] attributLien = {"id"};
        String colonneModal[] = {"idProduit"};
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setModalOnClick(true,colonneModal);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {
    %><div style="text-align: center;"><h4>Aucun donn&eacute; trouv&eacute;</h4></div><%
    }


%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>
