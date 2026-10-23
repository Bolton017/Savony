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
<%@ page import="bean.ClassMAPTable" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="prevision.Service" %>
<%@ page import="utils.ConstanteSavonnerie" %>
<%@ page import="magasin.DirectionMagasinLib" %>
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

    Magasin mag = u.getMagasin();
    EtatStock t = new EtatStock();
    t.setNomTable("V_ETATSTOCK_ING");
    String listeCrt[] = {"idProduitLib","idMagasin","idTypeProduitLib", "daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"idProduit","reste","pu"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    if(mag != null){
        pr.setAWhere("AND IDMAGASIN='"+mag.getId()+"'");
    }
    pr.setTitre("Fichier d'inventaire par entr&eacute;e");
    pr.setUtilisateur(u);
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/inventaire/fichier-inventaire.jsp");

    Liste[] dropDowns = null;

//    if (ConstanteSavonnerie.DEPARTEMENT_DG.equalsIgnoreCase(idDepartement) || idDepartement == null)
//    {
//        dropDowns = new Liste[2];
//        dropDowns[0] = new Liste( "idMagasin", new DirectionMagasinLib(), "idMagasinLib" , "idMagasin" );
////        dropDowns[0].setApresW(" AND idDirection = '" + idDepartement + "'");
//        TypeObjet dep = new TypeObjet("DEPARTEMENT");
//        dropDowns[1] = new Liste( "idDepartement", dep, "val", "id");
//        dropDowns[1].setDeroulanteDependante(dropDowns[0], "idDirection", "onchange");
//        dropDowns[1].setDefaut(idDepartement);
//
//    }
//    else if (idDepartement != null && !idDepartement.isEmpty())
//    {
//        dropDowns = new Liste[1];
//        dropDowns[0] = new Liste( "idMagasin",  new DirectionMagasinLib(), "idMagasinLib" , "idMagasin" );
//        dropDowns[0].setApresW(" AND idDirection = '" + idDepartement + "'");
//        pr.getFormu().getChamp("idDepartement").setAutre("readonly");
//        pr.getFormu().getChamp("idDepartement").setDefaut(idDepartement);
//
//    }

    dropDowns = new Liste[1];
    dropDowns[0] = new Liste( "idMagasin",  new DirectionMagasinLib(), "idMagasinLib" , "idMagasin" );

    pr.getFormu().changerEnChamp(dropDowns);
    pr.getFormu().getChamp("daty1").setDefaut("01/01/2001");
    pr.getFormu().getChamp("daty1").setVisible(false);
    pr.getFormu().getChamp("daty1").setLibelle("-");
    pr.getFormu().getChamp("daty2").setLibelle("Date");
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
    pr.getFormu().getChamp("idTypeProduitLib").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
//    pr.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement");
    if(mag != null){
        pr.getFormu().getChamp("idMagasin").setAutre("disabled");
        pr.getFormu().getChamp("idMagasin").setDefaut(mag.getId());
    }
    String[] colSomme = {"reste"};
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() +"?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"idProduit"};
    String varColonneLien[] = {"id"};

    String[] urllien = new String[] {"idProduit","idMagasin-idProduit-invdaty-idProduit","idMagasin-idProduit-invdaty-idProduit"};
    String[] urllienAffiche = new String[] {"idProduit","idMagasin-idProduit-invdaty-clicStock","idMagasin-idProduit-invdaty-clicStock"};

    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setUrlLien(urllien);
    pr.getTableau().setUrlLienAffiche(urllienAffiche);
    pr.getTableau().setAttLien(varColonneLien);

    String libEnteteAffiche[] = {"idProduit","quantite","pu"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String enteteRecap[] = {"","Nombre","Somme des quantit&eacute;s"};
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
<%--<script>--%>
<%--    var tousOption = document.querySelector('#idDepartement option[value="%"]');--%>
<%--    if (tousOption) {--%>
<%--        tousOption.remove();--%>
<%--    }--%>
<%--</script>--%>
    <%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



