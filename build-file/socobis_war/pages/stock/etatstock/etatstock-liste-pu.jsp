<%--
    Document   : etatcaisse-liste
    Created on : 2 avr. 2024, 10:11:22
    Author     : 26134
--%>


<%@page import="produits.CategorieIngredient"%>
<%@page import="utils.ConstanteStation"%>
<%@page import="stock.PageRechercheEtatStock"%>
<%@page import="stock.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="affichage.Liste"%>
<%@page import="user.UserEJB"%>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="utils.ConstanteSavonnerie" %>
<%@ page import="magasin.DirectionMagasinLib" %>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    utilisateursocobis.UtilisateurStation user = new utilisateursocobis.UtilisateurStation();
    user.setTuppleId(u.getUser().getTuppleID());
    user = user.getUtilisateurByrefuser();
    EtatStockParEntree t = new EtatStockParEntree();
    String listeCrt[] = {"id","idProduit","idProduitLib","iddepartement","idMagasin","idTypeProduitLib","idFournisseurLib","daty","compteLocalisationLib"};
    String listeInt[] = {};
    String libEntete[] = {
            "id",
            "daty",
            "idProduit",
            "idProduitLib",
            "idTypeProduitLib",
            "idFournisseurLib",
            "idMagasinLib",
            "departementlib",
            "invdaty",
            "invquantite",
            "idUniteLib",
            "pu",
            "reste",
            "entree",
            "sortie",
            "compteLocalisationLib"
    };
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);

    pr.setTitre("&Eacute;tat de stock par entr&eacute;e");
    pr.setUtilisateur(u);
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/etatstock/etatstock-liste-pu.jsp");

    Liste[] dropDowns = new Liste[3];
    DirectionMagasinLib m = new DirectionMagasinLib();
    String aWhere = "";
    if(user.getService() != null && !user.getService().getDepartement().equals(ConstanteSavonnerie.DEPARTEMENT_DG)) {
        aWhere = " and idDirection = '" + user.getService().getDepartement() + "'";
        pr.setAWhere(" and idDepartement = '" + user.getService().getDepartement() + "'");
    }
    dropDowns[0] = new Liste("idMagasin", m, "idMagasinLib", "idMagasin",aWhere);

    TypeObjet dep = new TypeObjet("departement");
    dropDowns[2] = new Liste("iddepartement", dep, "val", "id");
    dropDowns[2].setDeroulanteDependante(dropDowns[0], "idDirection", "onchange");


    TypeObjet idTypeProduitLib = new TypeObjet();
    idTypeProduitLib.setNomTable("CATEGORIEINGREDIENT");
    dropDowns[1] = new Liste("idTypeProduitLib", idTypeProduitLib, "val", "val");

    pr.getFormu().changerEnChamp(dropDowns);
    if(user.getService() != null && !user.getService().getDepartement().equals(ConstanteSavonnerie.DEPARTEMENT_DG)) {
        pr.getFormu().getChamp("iddepartement").setDefaut(user.getService().getDepartement());
        pr.getFormu().getChamp("iddepartement").setAutre("readonly onclick=\"return false\" style=\"pointer-events:none;\"");
    }
    pr.getFormu().getChamp("id").setLibelle("Source");
    pr.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty").setLibelle("Date du jour");
    pr.getFormu().getChamp("idFournisseurLib").setLibelle("Fournisseur");
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
    pr.getFormu().getChamp("idProduit").setLibelle("Ref Produit");
    pr.getFormu().getChamp("idTypeProduitLib").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("compteLocalisationLib").setLibelle("Emplacement");
    pr.getFormu().getChamp("iddepartement").setLibelle("d&eacute;partement");

    String[] colSomme = {"entree","sortie","reste","montantReste"};
    pr.creerObjetPage(libEntete, colSomme);

//    pr.getFormu().setAnotherButton(
//        "                <a id='export-btn-excel' class='btn btn-secondary btn-small btn-bg-white' href='#' onclick='exportExcel()'>\n" +
//        "                    <i class='material-symbols-rounded'>download</i> Exporter en excel\n" +
//        "                </a>"
//    );

    String lienFiltre = pr.getLien() + "?but=stock/mvtstockfille-liste.jsp";
    String[] lienTableau = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp", lienFiltre, lienFiltre,  pr.getLien() + "?but=fournisseur/fournisseur-fiche.jsp"};
    String[] colonneLien = {"idProduit","entree","sortie", "idFournisseurLib"};
    String[] attributLien = {"id","entree","sortie", "id"};
    String[] valeurLien = {"idProduit","entree","sortie", "idFournisseur"};
    String[] urllien = new String[] {"", "idProduit-idMagasin-invdaty-idProduit-id","idProduit-idMagasin-invdaty-idProduit-id", ""};
    String[] urllienAffiche = new String[] {"", "idProduit-idMagasin-invdaty-clicStock-clickStockEntree","idProduit-idMagasin-invdaty-clicStock-clickStockEntree", ""};

    pr.getTableau().setValeurLien(valeurLien);
    pr.getTableau().setUrlLien(urllien);
    pr.getTableau().setUrlLienAffiche(urllienAffiche);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);
    String[] enteteRecap = {"","Nombre","Somme des entr&eacute;es","Somme des sorties","Somme des restes", "Somme des Montants Restant"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    //Definition des libelles à afficher

    String libEnteteAffiche[] = {
            "Source",
            "Date d'entr&eacute;e",
            "Ref Produit",
            "Produit",
            "Cat&eacute;gorie",
            "Fournisseur",
            "Magasin",
            "d&eacute;partement",
            "Date d'inventaire",
            "quantit&eacute; d'inventaire",
            "Unit&eacute;",
            "Prix unitaire",
            "quantit&eacute;",
            "entr&eacute;e",
            "sortie",
            "Emplacement"
    };
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

<script>
    function exportExcel() {
        var idValue = document.getElementById("id").value;
        var idProduitValue = document.getElementById("idProduit").value;
        var idProduitLibValue = document.getElementById("idProduitLib").value;
        var idMagasinValue = document.getElementById("idMagasin").value;
        var idTypeProduitLibValue = document.getElementById("idTypeProduitLib").value;
        var datyValue = document.getElementById("daty").value;
        var awhere = "<%= pr.getAWhere() %>";
        var selectMagasin = document.getElementById("idMagasin");
        var libelleMagasin = selectMagasin.options[selectMagasin.selectedIndex].text;



        var exportUrl = "${pageContext.request.contextPath}/ExportExcel?action=etat_stock"
            + "&id=" + encodeURIComponent(idValue)
            + "&idProduit=" + encodeURIComponent(idProduitValue)
            + "&idProduitLib=" + encodeURIComponent(idProduitLibValue)
            + "&idMagasin=" + encodeURIComponent(idMagasinValue)
            + "&idTypeProduitLib=" + encodeURIComponent(idTypeProduitLibValue)
            + "&daty=" + encodeURIComponent(datyValue)
            + "&awhere=" + encodeURIComponent(awhere)
            + "&idMagasinLib=" + encodeURIComponent(libelleMagasin)

        var exportButton = document.getElementById("export-btn-excel");
        exportButton.href = exportUrl;
    }
    document.getElementById("export-btn-excel").addEventListener("click", exportExcel);
</script>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



