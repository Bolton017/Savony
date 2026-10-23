<%--
    Document   : etatcaisse-liste
    Created on : 2 avr. 2024, 10:11:22
    Author     : 26134
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="affichage.Liste"%>
<%@page import="user.UserEJB"%>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="bean.*" %>
<%@ page import="stock.EtatStockAvecEngagement" %>
<%@ page import="annexe.TypeProduit" %>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    Magasin mag = u.getMagasin();
    utilisateursocobis.UtilisateurStation user = new utilisateursocobis.UtilisateurStation();
    user.setTuppleId(u.getUser().getTuppleID());
    user = user.getUtilisateurByrefuser();
    EtatStockAvecEngagement t = new EtatStockAvecEngagement();
    t.setNomTable("V_ETATSTOCK_ING_ENG");
    String listeCrt[] = {"id","idProduitLib","idMagasin","idTypeProduitLib","idUniteLib","iddepartement"};
    String listeInt[] = {};
    String libEntete[] = {"id","idProduitLib","idTypeProduitLib","idMagasinLib","departementlib","idUniteLib","pu","entree","sortie","reste","montantReste"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    if(mag != null){
        pr.setAWhere("AND IDMAGASIN='"+mag.getId()+"'");
    }
    pr.setTitre("&Eacute;tat de Stock avec engagement");
    pr.setUtilisateur(u);
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/etatstock/etatstock-avec-engagement.jsp");


    // Initialisation Liste
    Liste[] dropDowns = new Liste[4];
    Magasin m = new Magasin();
    m.setNomTable("magasinpoint");
    dropDowns[0] = new Liste("idMagasin", m, "val", "id");

    TypeObjet unite = new TypeObjet();
    unite.setNomTable("AS_UNITE");
    dropDowns[1] = new Liste("idUniteLib", unite, "val", "val");
    dropDowns[2] = new Liste("idTypeProduitLib", new TypeProduit(), "val","val");
    TypeObjet dep = new TypeObjet("departement");
    dropDowns[3] = new Liste("iddepartement", dep, "val", "id");
    pr.getFormu().changerEnChamp(dropDowns);
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
    pr.getFormu().getChamp("idTypeProduitLib").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("iddepartement").setLibelle("d&eacute;partement");

    if(user.getIddepartement() != null){
        String awhere = " and iddepartement = '" + user.getIddepartement() + "'";
        pr.getFormu().getChamp("iddepartement").setDefaut(user.getIddepartement());
        pr.getFormu().getChamp("iddepartement").setAutre("readonly onclick=\"return false\" style=\"pointer-events:none;\"");
        pr.setAWhere(pr.getAWhere() +  awhere);
    }
    if(mag != null){
        pr.getFormu().getChamp("idMagasin").setAutre("disabled");
        pr.getFormu().getChamp("idMagasin").setDefaut(mag.getId());
    }
    pr.getFormu().getChamp("idUniteLib").setLibelle("Unit&eacute;");
    //pr.getFormu().getChamp("puVente1").setLibelle("Prix de vente minimum");
    //pr.getFormu().getChamp("puVente2").setLibelle("Prix de vente maximum");
    String[] colSomme = {"montantReste"};
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"id","Produit","Cat&eacute;gorie","Magasin","d&eacute;partement","Unit&eacute;","Prix unitaire","entr&eacute;e","sortie","reste","Montant Restant"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String enteteRecap[] = {"","Nombre","Somme des montants restants"};
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



