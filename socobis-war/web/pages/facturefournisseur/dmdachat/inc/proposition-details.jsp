<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.DmdAchatFille" %>

<%
    try{
        DmdAchatFille t = new DmdAchatFille();
        String[] listeCrt = {};
        String[] listeInt = {};
        String[] libEntete = {"idproduit","designation","quantite","qtestock"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setAWhere(" AND idmere='"+request.getParameter("id")+"'");
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);

        pr.getTableau().setLienFille("facturefournisseur/dmdachat/inc/plus/proposition-plus.jsp&iddmd=" + request.getParameter("id") + "&id=");


        String[] lienTableau = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneModal[] = {"idproduit"};
        String[] colonneLien = {"idproduit"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setModalOnClick(true,colonneModal);
        pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%
        String[] libEnteteAffiche =  {"Id produit","D&eacute;signation","Quantit&eacute;","Quantit&eacute; en stock"};
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