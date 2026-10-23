<%--
    Document   : etatcaisse-liste
    Created on : 2 avr. 2024, 10:11:22
    Author     : 26134
--%>


<%@page import="produits.CategorieIngredient"%>
<%@page import="utils.ConstanteStation"%>
<%@page import="stock.PageRechercheEtatStock"%>
<%@page import="stock.EtatStock"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="annexe.TypeProduit"%>
<%@page import="annexe.Unite"%>
<%@page import="affichage.Liste"%>

<% try{
    EtatStock t = new EtatStock();
    t.setNomTable("V_ETATSTOCK_ING_MAGASIN");
    String listeCrt[] = {"id","idProduitLib","idMagasin","idTypeProduitLib","puVente"};
    String listeInt[] = {"puVente"};
    String libEntete[] = {"id","idProduitLib","idTypeProduitLib","idMagasinLib","puVente","quantite","entree","sortie","reste","idUniteLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    // pr.setAWhere("AND IDPOINT='"+ConstanteStation.getFichierCentre()+"'");
    pr.setTitre("Etat de Stock");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/etatstock/etatstock-magasin.jsp");


    // Initialisation Liste
    Liste[] dropDowns = new Liste[1];
    Magasin mag= new Magasin();
    mag.setNomTable("magasinpoint");
    dropDowns[0] = new Liste("idMagasin", mag, "val", "id");

    pr.getFormu().changerEnChamp(dropDowns);
    pr.getFormu().getChamp("idProduitLib").setLibelle("Ingredient");
    pr.getFormu().getChamp("idTypeProduitLib").setLibelle("Categorie ingredient");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    //pr.getFormu().getChamp("idUnite").setLibelle("Unite");
    pr.getFormu().getChamp("puVente1").setLibelle("Prix de vente minimum");
    pr.getFormu().getChamp("puVente2").setLibelle("Prix de vente maximum");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"id","Ingr&eacute;dient","Cat&eacute;gorie","Magasin","Prix de Vente","quantit&eacute;","entr&eacute;e","sortie","reste","Unit&eacute;"};
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
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



