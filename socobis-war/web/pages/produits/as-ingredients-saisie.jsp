<%-- 
    Document   : as-commande-modif.jsp
    Created on : 29 d�c. 2016, 19:50:47
    Author     : Joe
--%>
<%@ page import="user.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="bean.*" %>
<%@ page import="affichage.*"%>
<%@page import="produits.Ingredients"%>
<%@ page import="rh.QualificationPaie" %>
<%@ page import="utils.ConstanteSavonnerie" %>
<%
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    Ingredients  a = new Ingredients();
    PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));
    UserEJB u = (UserEJB) session.getAttribute("u");

    affichage.Liste[] liste = new affichage.Liste[6];

    TypeObjet op = new TypeObjet();
    op.setNomTable("as_unite");
    liste[0] = new Liste("unite", op, "VAL", "id");
    TypeObjet op1 = new TypeObjet();
    op1.setNomTable("CATEGORIEINGREDIENT");
    liste[1] = new Liste("categorieIngredient", op1, "val", "id");
    String[] valeurs = {"","CUMP","FIFO","LIFO"};
    String[] affiches = {"Aucun","CUMP","FIFO","LIFO"};
    liste[2] = new Liste("typeStock" ,affiches,valeurs);

    String[] valeur = {"0","1"};
    String[] affiche = {"non","oui"};
    liste[3] = new Liste("compose" ,affiche,valeur);

    // TypeObjet poste = new TypeObjet();
    // poste.setNomTable("poste");
    // liste[4] = new Liste("refpost", poste, "val", "id");
    // liste[4].ajouterValeur(new String[]{""}, new String[]{"-"});

    // QualificationPaie qual = new QualificationPaie();
    // liste[5] = new Liste("refqualification", qual, "val", "id");
    // liste[5].ajouterValeur(new String[]{""}, new String[]{"-"});

    // liste[4].setDeroulanteDependante(liste[5],"idPoste","onchange");
//    liste[4] = new Liste("idFournisseur",affiche,affiche);
    TypeObjet ta = new TypeObjet();
    ta.setNomTable("typeatelier");
    liste[4] = new Liste("atelier", ta, "VAL", "id");
        String[] valeurA = {"1","0"};
        String[] afficheA = {"Oui","Non"};
    liste[5] = new Liste("actif" ,afficheA,valeurA);
    // TypeObjet famille = new TypeObjet();
    // famille.setNomTable("FAMILLEPRODUIT");
    // liste[7] = new Liste("idFamille", famille, "VAL", "ID");

    //liste[7] = new Liste("idmagasin",new magasin.Magasin(),"val","id");
    //liste[7].setLibelle("Magasin");
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("compte_stock").setLibelle("Compte de stock");
    pi.getFormu().getChamp("COMPTE_SORTIE_STOCK").setLibelle("compte de variation de stock");
    pi.getFormu().getChamp("refqualification").setLibelle("Classification");
    pi.getFormu().getChamp("refpost").setLibelle("Poste");
    pi.getFormu().getChamp("pu").setLibelle("Prix unitaire");
    pi.getFormu().getChamp("photo").setLibelle("Photo");
    pi.getFormu().getChamp("typeStock").setType("Type stock");
    pi.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
    pi.getFormu().getChamp("compose").setLibelle("Compos&eacute;");
    pi.getFormu().getChamp("pvgros").setLibelle("Prix de vente en gros");
    pi.getFormu().getChamp("categorieIngredient").setLibelle("Cat&eacute;gorie");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("qteLimite").setLibelle("Quantit&eacute; limite");
    pi.getFormu().getChamp("pv").setLibelle("Prix de vente");    
    pi.getFormu().getChamp("compte_vente").setLibelle("Compte associ&eacute; aux ventes");
    pi.getFormu().getChamp("compte_vente").setDefaut(ConstanteSavonnerie.COMPTE_VENTE);
    pi.getFormu().getChamp("compte_achat").setLibelle("Compte associ&eacute; aux achats");
    pi.getFormu().getChamp("compte_achat").setDefaut(ConstanteSavonnerie.COMPTE_ACHAT);
    pi.getFormu().getChamp("compte_vente").setPageAppelComplete("mg.cnaps.compta.ComptaCompte", "compte", "COMPTA_COMPTE");
    pi.getFormu().getChamp("compte_achat").setPageAppelComplete("mg.cnaps.compta.ComptaCompte", "compte", "COMPTA_COMPTE");
    pi.getFormu().getChamp("refpost").setLibelle("Poste");
    pi.getFormu().getChamp("parfums").setLibelle("Code article");
    pi.getFormu().getChamp("codebarre").setLibelle("Code-barres");
    pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pi.getFormu().getChamp("compte_ristourne").setLibelle("Compte Ristourne");
    pi.getFormu().getChamp("idFournisseur").setLibelle("Est un P&eacute;trin");
    pi.getFormu().getChamp("idFamille").setLibelle("Famille Produit");
    pi.getFormu().getChamp("filepath").setLibelle("Chemin du fichier");
    pi.getFormu().getChamp("typeStock").setLibelle("Type de stock");
    pi.getFormu().getChamp("compte_stock").setPageAppelComplete("mg.cnaps.compta.ComptaCompte", "compte", "COMPTA_COMPTE");
    pi.getFormu().getChamp("compte_sortie_stock").setPageAppelComplete("mg.cnaps.compta.ComptaCompte", "compte", "COMPTA_COMPTE");
    pi.getFormu().getChamp("idFamille").setVisible(false);
    pi.getFormu().getChamp("filepath").setVisible(false);
//    pi.getFormu().getChamp("compte_vente").setVisible(false);
//    pi.getFormu().getChamp("compte_achat").setVisible(false);
    pi.getFormu().getChamp("idFournisseur").setVisible(false);
    pi.getFormu().getChamp("refpost").setVisible(false);
    pi.getFormu().getChamp("refqualification").setVisible(false);
    pi.getFormu().getChamp("qteLimite").setVisible(false);
//    pi.getFormu().getChamp("calorie").setVisible(false);
    pi.getFormu().getChamp("pv").setVisible(false);
    pi.getFormu().getChamp("photo").setVisible(false);
    pi.getFormu().getChamp("idmagasin").setVisible(false);
    pi.getFormu().getChamp("libelleVente").setVisible(false);
    pi.getFormu().getChamp("PUVenteEuro").setVisible(false);
    pi.getFormu().getChamp("PUVenteUSD").setVisible(false);
    pi.getFormu().getChamp("quantiteParPack").setVisible(false);
    pi.getFormu().getChamp("calorie").setLibelle("Poids");
    pi.getFormu().getChamp("tva").setVisible(false);
    pi.getFormu().getChamp("reste").setVisible(false);
    String[] formOrder={"daty","libelle","parfums","seuil","idmagasin","unite","pu","actif","photo","compose","categorieIngredient","qteLimite","pv","compte_vente","compte_achat","filepath","typeStock","refpost","refqualification","idFournisseur","libelleVente","PUVenteEuro","PUVenteUSD","quantiteParPack","calorie","tva","reste","idfamille"};
    pi.getFormu().setOrdre(formOrder);
    pi.preparerDataFormu();
    String titre="Saisie d'un produit";
        if(request.getParameter("acte")!=null){
            titre = "Modification d'un produit";
        }
%>
<div class="content-wrapper">
    <h1 class="box-title"><%=titre%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="appro" id="appro" >
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="acte" value="insert">
        <input name="bute" type="hidden" id="bute" value="produits/as-ingredients-fiche.jsp">
        <input name="classe" type="hidden" id="classe" value="produits.Ingredients">
    </form>
</div>

<%} catch(Exception ex){
    ex.printStackTrace();
}%>