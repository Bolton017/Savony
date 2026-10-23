
<%@page import="vente.BonDeCommandeFabDetails"%>
<%@page import="vente.As_BonDeLivraisonClientFilleBc"%>
<%@page import="produits.Recette"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="fabrication.*" %>
<%@ page import="vente.BonDeCommande" %>

<%
    BonDeCommandeFabDetails of = new BonDeCommandeFabDetails();
//    of.setIdbc(request.getParameter("id"));
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] =  {"idFabrication","libelleextacte", "qte"};
    PageRecherche pr = new PageRecherche(of, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setAWhere(" and idbc ='"+request.getParameter("id")+"' ");
    pr.getApres();
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
 
%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=fabrication/fabrication-fiche.jsp"};
        String colonneLien[] = {"idFabrication"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        String libEnteteAffiche[] =  {"ID Fabrication","Produit","Quantit&eacute;"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
         %>
       <%
          } 
        else
            {
               %><center><h4>Aucune donn&eacute;e trouv&eacute;</h4></center><%
        }
    %>
            
</div>
    
