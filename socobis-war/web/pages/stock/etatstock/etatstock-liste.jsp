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
<%@page import="user.UserEJB"%>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="prevision.Service" %>
<%@ page import="magasin.DirectionMagasinLib" %>
<%@ page import="utils.ConstanteSavonnerie" %>


<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    utilisateursocobis.UtilisateurStation user = new utilisateursocobis.UtilisateurStation();
    user.setTuppleId(u.getUser().getTuppleID());
    user = user.getUtilisateurByrefuser();
    EtatStock t = new EtatStock();
    t.setNomTable("V_ETATSTOCK_ING");
    String listeCrt[] = {"idProduit","codeProduit","idProduitLib","iddepartement","idMagasin","categorieIngredient","idUniteLib"};
    String listeInt[] = {};
    String libEntete[] = {"idProduit","idProduitLib","codeProduit","idTypeProduitLib","idMagasinLib","departementlib","idUniteLib","pu","invquantite","invdaty","entree","sortie","reste","montantReste"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);

    pr.setTitre("&Eacute;tat de Stock");
    pr.setUtilisateur(u);
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/etatstock/etatstock-liste.jsp");


    // Initialisation Liste
    Liste[] dropDowns = new Liste[4];
    DirectionMagasinLib m = new DirectionMagasinLib();
    String aWhere = "";
    if(user.getService() != null && !user.getService().getDepartement().equals(ConstanteSavonnerie.DEPARTEMENT_DG)) {
        aWhere = " and idDirection = '" + user.getService().getDepartement() + "'";
    }
    dropDowns[0] = new Liste("idMagasin", m, "idMagasinLib", "idMagasin",aWhere);

    TypeObjet dep = new TypeObjet("departement");
    dropDowns[3] = new Liste("iddepartement", dep, "val", "id");
    dropDowns[3].setDeroulanteDependante(dropDowns[0], "idDirection", "onchange");

    TypeObjet tp = new TypeObjet();
    tp.setNomTable("CATEGORIEINGREDIENT");
    dropDowns[1] = new Liste("categorieIngredient", tp, "val", "id");

     TypeObjet unite = new TypeObjet();
    unite.setNomTable("AS_UNITE");
    dropDowns[2] = new Liste("idUniteLib", unite, "val", "val");

    pr.getFormu().changerEnChamp(dropDowns);

    if(user.getService() != null && !user.getService().getDepartement().equals(ConstanteSavonnerie.DEPARTEMENT_DG)) {
        pr.getFormu().getChamp("iddepartement").setDefaut(user.getService().getDepartement());
        pr.getFormu().getChamp("iddepartement").setAutre("readonly onclick=\"return false\" style=\"pointer-events:none;\"");
    }
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
    pr.getFormu().getChamp("idProduit").setLibelle("Ref Produit");
    pr.getFormu().getChamp("categorieIngredient").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("codeProduit").setLibelle("Code produit");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("idUniteLib").setLibelle("Unit&eacute;");
    pr.getFormu().getChamp("iddepartement").setLibelle("d&eacute;partement");


    //pr.getFormu().getChamp("idUnite").setLibelle("Unite");
    //pr.getFormu().getChamp("puVente1").setLibelle("Prix de vente minimum");
    //pr.getFormu().getChamp("puVente2").setLibelle("Prix de vente maximum");
    String[] colSomme = {"invquantite","entree","sortie","reste","montantReste"};
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienFiltre = pr.getLien() + "?but=stock/mvtstockfille-liste.jsp";
    String lienProduit = pr.getLien() + "?but=produits/as-ingredients-fiche.jsp";
    String[] lienTableau = {lienProduit,lienFiltre, lienFiltre};
    String[] colonneLien = {"idProduit","entree", "sortie"};
    String varColonneLien[] = {"id", "entree", "sortie"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(varColonneLien);

//    String[] urllien = new String[] {"idMagasin-idProduit-invdaty-idProduit","idMagasin-idProduit-invdaty-idProduit"};
//    String[] urllienAffiche = new String[] {"idMagasin-idProduit-invdaty-clicStock","idMagasin-idProduit-invdaty-clicStock"};
//
//    pr.getTableau().setLien(lienTableau);
//    pr.getTableau().setColonneLien(colonneLien);
//    pr.getTableau().setUrlLien(urllien);

    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"Ref Produit","Produit","Code produit","Cat&eacute;gorie","Magasin","d&eacute;partement","Unit&eacute;","Prix unitaire","Quantit&eacute; d’inventaire","Date d’inventaire","entr&eacute;e","sortie","reste","Montant Restant"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String enteteRecap[] = {"","Nombre","Somme des quantit&eacute;s d’inventaire","Somme des entr&eacute;es","Somme des sorties","Somme des restes","Somme des montants restants"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

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



