<%@page import="stock.TransfertStockDetailsCpl"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
    try{
    TransfertStockDetailsCpl t = new TransfertStockDetailsCpl();
    t.setNomTable("TRANSFERTSTOCKDETAILSCPL");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id","idproduitlib","quantite", "pu", "compteLocalisationDepartLib", "comptelocalisationarriveelib", "idSource"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        System.out.println("idmere "+request.getParameter("id"));
        pr.setAWhere(" and idTransfertStock='"+request.getParameter("id")+"' ");
    }
    String[] colSomme = null;

    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = { pr.getLien() + "?but=produits/as-ingredients-fiche.jsp" };
    String[] colonneLien = { "idProduitLib" };
    String[] attLien = { "id" };
    String[] valeurLien = { "idProduit" };

%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Ref", "Produit", "quantit&eacute;", "Prix unitaire", "Emplacement de d&eacute;part", "Emplacament d'arriv&eacute;e", "Mouvement source"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attLien);
        pr.getTableau().setValeurLien(valeurLien);
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
         }else
         {
               %><div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
         }

        
    %>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>


