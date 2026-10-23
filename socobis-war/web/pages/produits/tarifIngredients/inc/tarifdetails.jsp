
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="vente.BonDeCommandeFille" %>
<%@ page import="vente.BonDeCommandeGlobale" %>
<%@ page import="produits.ImportPrixDetails" %>
<%@ page import="produits.ImportPrixDetailsCpl" %>
<%
    try{
        ImportPrixDetailsCpl t = new ImportPrixDetailsCpl();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"libelle","idIngredient","grammage","quantiteParPack","poids","unitemorceau", "ptHT","ptTTC", "puHtMorceau", "puTTCMorceau", "typeclientLib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idMere='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneLien[] = {"idIngredient"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        String libEnteteAffiche[] = {"Libellé", "ID", "Grammage", "Quantité par Pack", "Poids","Unit&eacute;", "Prix HT", "Prix TTC", "Prix Unitaire HT Morceau", "Prix Unitaire TTC Morceau", "Type Client"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
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