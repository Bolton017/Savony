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
<%@ page import="stock.EtatStockLot" %>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    Magasin mag = u.getMagasin();
    EtatStockLot t = new EtatStockLot();
    t.setNomTable("V_ETATSTOCK_INGLOT");
    String listeCrt[] = {"id","idProduitLib","idMagasin","idTypeProduitLib","dateDernierMouvement"};
    String listeInt[] = {"dateDernierMouvement"};
    String libEntete[] = {"id","idProduitLib","idTypeProduitLib","idMagasinLib","idUniteLib","pu","entree","sortie","reste","montantReste","idLot","idLotLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    if(mag != null){
        pr.setAWhere("AND IDMAGASIN='"+mag.getId()+"'");
    }
    pr.setTitre("&Eacute;tat de Stock");
    pr.setUtilisateur(u);
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/etatstock/etatstock-liste.jsp");


    // Initialisation Liste
    Liste[] dropDowns = new Liste[1];
    Magasin m = new Magasin();
    m.setNomTable("magasinpoint");
    dropDowns[0] = new Liste("idMagasin", m, "val", "id");

    pr.getFormu().changerEnChamp(dropDowns);
    pr.getFormu().getChamp("dateDernierMouvement1").setDefaut("01/01/2001");
    pr.getFormu().getChamp("dateDernierMouvement1").setVisible(false);
    pr.getFormu().getChamp("dateDernierMouvement1").setLibelle("-");
    pr.getFormu().getChamp("dateDernierMouvement2").setLibelle("Date");
    pr.getFormu().getChamp("dateDernierMouvement2").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
    pr.getFormu().getChamp("idTypeProduitLib").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    if(mag != null){
        pr.getFormu().getChamp("idMagasin").setAutre("disabled");
        pr.getFormu().getChamp("idMagasin").setDefaut(mag.getId());
    }
    //pr.getFormu().getChamp("idUnite").setLibelle("Unite");
    //pr.getFormu().getChamp("puVente1").setLibelle("Prix de vente minimum");
    //pr.getFormu().getChamp("puVente2").setLibelle("Prix de vente maximum");
    String[] colSomme = {"entree","sortie","reste","montantReste"};
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp", pr.getLien() + "?but=vente/lot/lot-fiche.jsp"};
    String colonneLien[] = {"id","idLot"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"R&eacute;f&eacute;rence","Produit","Cat&eacute;gorie","Magasin","Unit&eacute;","Prix unitaire","entr&eacute;e","sortie","reste","Montant Restant", "Id Lot", "Lot"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String enteteRecap[] = {"","Nombre","Somme des entr&eacute;es","Somme des sorties","Somme des restes","Somme des montants restants"};
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



