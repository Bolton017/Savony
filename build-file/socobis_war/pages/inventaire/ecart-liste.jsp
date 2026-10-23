<%@page import="inventaire.InventaireFilleLib"%>
<%@page import="inventaire.InventaireLib"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="affichage.Liste"%>
<%@page import="magasin.Magasin"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@page import="user.UserEJB"%>
<%@ page import="prevision.Service" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="magasin.DirectionMagasinLib" %>
<%@ page import="utils.ConstanteSavonnerie" %>
<%@ page import="bean.TypeObjet" %>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");

    utilisateursocobis.UtilisateurStation user = new utilisateursocobis.UtilisateurStation();
    user.setTuppleId(u.getUser().getTuppleID());
    user = user.getUtilisateurByrefuser();
    String idDepartement = null;
    if(user.getService() != null) {
        idDepartement = user.getService().getDepartement();
    }

    InventaireFilleLib inventaire = new InventaireFilleLib();
    inventaire.setNomTable("v_inventaireFilleCpl_2");
    String listeCrt[] = {"idInventaire", "dateInv","idproduitlib","idProduit","idDepartement","idMagasin"};
    String listeInt[] = {"dateInv"};
    String libEntete[] = {"idInventaire","id","dateInv","idDepartementLib", "idMagasinLib","idProduit","idproduitlib","idUniteLib","quantiteTheorique","quantite","ecart","montantTheorique","montantReelle","ecartMontant"};
    PageRecherche pr = new PageRecherche(inventaire, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des &eacute;carts d'inventaires");

    Liste[] dropDowns = null;

    if  (ConstanteSavonnerie.DEPARTEMENT_DG.equalsIgnoreCase(idDepartement) || idDepartement == null)
    {
        dropDowns = new Liste[2];
        dropDowns[0] = new Liste( "idMagasin", new DirectionMagasinLib(), "idMagasinLib" , "idMagasin" );
        dropDowns[0].setApresW(" AND idDirection = '" + idDepartement + "'");
        TypeObjet dep = new TypeObjet("DEPARTEMENT");
        dropDowns[1] = new Liste( "idDepartement", dep, "val", "id");
        dropDowns[1].setDeroulanteDependante(dropDowns[0], "idDirection", "onchange");
        dropDowns[1].setDefaut(idDepartement);

    } else if (idDepartement != null && !idDepartement.isEmpty())
    {
        dropDowns = new Liste[1];
        dropDowns[0] = new Liste( "idMagasin",  new DirectionMagasinLib(), "idMagasinLib" , "idMagasin" );
        dropDowns[0].setApresW(" AND idDirection = '" + idDepartement + "'");
        pr.getFormu().getChamp("idDepartement").setAutre("readonly");
        pr.getFormu().getChamp("idDepartement").setDefaut(idDepartement);

    }

    pr.getFormu().changerEnChamp(dropDowns);

    pr.setNpp(50);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("inventaire/ecart-liste.jsp");
    pr.getFormu().getChamp("idInventaire").setLibelle("Id");
    pr.getFormu().getChamp("idProduit").setLibelle("Id produit");
    pr.getFormu().getChamp("idproduitlib").setLibelle("Produit");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement");
    pr.getFormu().getChamp("dateInv1").setLibelle("Date inventaire min");
    pr.getFormu().getChamp("dateInv1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("dateInv2").setLibelle("Date inventaire max");
    pr.getFormu().getChamp("dateInv2").setDefaut(utilitaire.Utilitaire.dateDuJour());
  
    String[] colSomme = {"ecart" , "ecartMontant"};
    pr.creerObjetPage(libEntete, colSomme);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=inventaire/inventaire-fiche.jsp" , pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"idInventaire", "idProduit"};
    String varColonneLien[] = {"id", "id"};
    String valeurLien[] = {"idInventaire", "idProduit"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(varColonneLien);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setValeurLien(valeurLien);
    
    String libEnteteAffiche[] = {"Id","ID Inventaire Fille","Date inventaire","D&eacute;partement","Magasin","ID Produit","Produit", "Unit&eacute;","Quantit&eacute; th&eacute;orique","quantit&eacute; Inventaire"," &Eacute;cart quantit&eacute;","valeur th&eacute;orique","valeur inventaire","&Eacute;cart valeur"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
      
%>
<script>
    function changerDesignation() {
        document.invliste.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post"  name="invliste"  id="invliste">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            </form>
        <%
            String[] recapEntete = { "", "Nombre", "somme des &eacute;carts en quantit&eacute;", "somme des &eacute;carts en montant"};
            pr.getTableauRecap().setLibeEntete(recapEntete);
         
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<script>
    var tousOption = document.querySelector('#idDepartement option[value="%"]');
    if (tousOption) {
        tousOption.remove();
    }
</script>
    <%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



