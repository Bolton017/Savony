<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="ristourne.*" %>

<%
    try{
        RistourneDetailsLib t = new RistourneDetailsLib();
        String[] listeCrt = {};
        String[] listeInt = {};
        String[] libEntete = {"id","idProduitLib","taux1", "taux2", "idOrigine"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setAWhere(" AND idRistourne='"+request.getParameter("id")+"'");
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);

//        String[] lienTableau = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
//        String colonneModal[] = {"idproduit"};
//        String[] colonneLien = {"idproduit"};
//        pr.getTableau().setLien(lienTableau);
//        pr.getTableau().setModalOnClick(true,colonneModal);
//        pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%
        String[] libEnteteAffiche =  {"ID","Produit","Taux simple", "Taux Facture avant &eacute;ch&eacute;ance", "Source"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {
    %><center><h4>Aucune donne trouv&eacute;e</h4></center><%
    }

%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>