<%@page import="stock.TransfertStockCpl"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="demande.SituationDemandeTransfert" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    try{
        SituationDemandeTransfert t = new SituationDemandeTransfert();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"idproduit","produit","qtedemande","qtelivre","qterecu","qtestock"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and id='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneLien[] = {"idProduit"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Ref produit","D&eacute;signation","Quantit&eacute; demand&eacute;e","Quantit&eacute; livr&eacute;e","Quantit&eacute; reçue","Quantit&eacute; en stock"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPageOnglet());
        }else
        {
    %><div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
    }


%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>


