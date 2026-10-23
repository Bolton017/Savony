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
<%@ page import="stat.EtatStockProduitFini" %>
<%@ page import="utils.ConstanteAsync" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="java.util.Map" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="affichage.Graphe" %>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    EtatStock t = new EtatStock();
    t.setNomTable("V_ETATSTOCK_ING");
    String listeCrt[] = {"id","idProduitLib","idMagasin","dateDernierMouvement"};
    String listeInt[] = {"dateDernierMouvement"};
    String libEntete[] = {"id","idProduitLib","idMagasinLib","quantite","puvente", "totalVente"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setAWhere(" and categorieIngredient='"+ ConstanteSocobis.CATEGORIE_PRODUIT_FINI +"'");
    pr.setTitre("&Eacute;tat de Stock produit fini");
    pr.setUtilisateur(u);
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stat/stock-produit-fini-liste.jsp");

    // Initialisation Liste
    Liste[] dropDowns = new Liste[1];
    Magasin m = new Magasin();
    m.setNomTable("magasin2");
    dropDowns[0] = new Liste("idMagasin", m, "val", "id");

    pr.getFormu().changerEnChamp(dropDowns);

    pr.getFormu().getChamp("dateDernierMouvement1").setDefaut("01/09/2025");
    pr.getFormu().getChamp("dateDernierMouvement1").setLibelle("Date min");
    pr.getFormu().getChamp("dateDernierMouvement2").setLibelle("Date max");
    pr.getFormu().getChamp("dateDernierMouvement2").setDefaut(Utilitaire.dateDuJour());

    pr.getFormu().getChamp("idProduitLib").setLibelle("Ingr&eacute;dient");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");


    String[] colSomme = {};
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"id","Ingr&eacute;dient","Magasin","Quantit&eacute;","Valeur de vente", "Total Vente"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String titreGraph = "Graphique";
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
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
    <div class="row mt-4" style="margin-top: 20px;">
        <div class="col-md-12 mb-4">
            <div class="card h-100" style="
                        border-radius: 10px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                        border: 1px solid #e0e0e0;
                        background-color: white;
                        padding: 1em">
                <div class="card-body">
                    <h5 class="card-title text-center"><%= titreGraph %></h5>
                    <canvas id="graph_cheese"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>
<%
        String colAbs1 = "idProduitLib";
        String[] colOrd1 = {""};
        String[] colAff1 = {""};

        Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "idProduitLib", "reste")};
        Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_cheese", "");
        g1.setTypeGraphe("bar");
        out.println(g1.getHtml("ctx1"));
    }catch(Exception e){

        e.printStackTrace();
    }
%>



