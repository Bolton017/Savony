<%@page import="stock.EtatStockLocalisation"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="affichage.Liste"%>
<%@page import="user.UserEJB"%>
<%@ page import="bean.TypeObjet" %>
<%@ page import="prevision.Service" %>
<%@ page import="magasin.DirectionMagasinLib" %>
<%@ page import="utils.ConstanteSavonnerie" %>

<% try{
    UserEJB u = (UserEJB) session.getAttribute("u");
    utilisateursocobis.UtilisateurStation user = new utilisateursocobis.UtilisateurStation();
    user.setTuppleId(u.getUser().getTuppleID());
    user = user.getUtilisateurByrefuser();
    EtatStockLocalisation t = new EtatStockLocalisation();
    String[] listeCrt = {"idProduit","codeProduit","idProduitLib","categorieIngredient","iddepartement","idMagasin","idUniteLib","compteLocalisationLib"};
    String[] listeInt = {};
    String[] libEntete = {"idProduit","codeProduit","idProduitLib","idTypeProduitLib","idMagasinLib","departementlib","compteLocalisationLib","pu","invquantite","invdaty","idUniteLib","entree","sortie","reste","montantReste"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);

    pr.setTitre("&Eacute;tat de Stock Par Emplacement");
    pr.setUtilisateur(u);
    pr.setLien((String) session.getAttribute("lien"));
    pr.setApres("stock/etatstock/etatstock-liste-emplacement.jsp");
    pr.setNpp(50);

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
    pr.getFormu().getChamp("compteLocalisationLib").setLibelle("Emplacement");
    pr.getFormu().getChamp("codeProduit").setLibelle("Code produit");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("idUniteLib").setLibelle("Unit&eacute;");
    pr.getFormu().getChamp("iddepartement").setLibelle("d&eacute;partement");


    String[] colSomme = {"invquantite","entree","sortie","reste","montantReste"};
    pr.creerObjetPage(libEntete, colSomme);

    String lienFiltre = pr.getLien() + "?but=stock/mvtstockfille-liste.jsp";
    String lienProduit = pr.getLien() + "?but=produits/as-ingredients-fiche.jsp";
    String[] lienTableau = {lienProduit,lienFiltre, lienFiltre};
    String[] colonneLien = {"idProduit","entree", "sortie"};
    String[] attLien = {"id","entree", "sortie"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attLien);

    //Definition des libelles à afficher
    String[] libEnteteAffiche = {"Ref Produit","Code produit","Produit","Cat&eacute;gorie","Magasin","d&eacute;partement","Emplacement","Prix unitaire","Quantit&eacute; d’inventaire","Date d’inventaire","Unit&eacute;","entr&eacute;e","sortie","reste","Montant Restant"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] enteteRecap = {"","Nombre","Somme des quantit&eacute;s d’inventaire","Somme des entr&eacute;es","Somme des sorties","Somme des restes","Somme des montants restants"};
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



