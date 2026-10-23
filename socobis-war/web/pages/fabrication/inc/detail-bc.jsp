
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="vente.BonDeCommandeFille" %>
<%@ page import="vente.BonDeCommandeGlobale" %>
<%
  try{
    BonDeCommandeGlobale t = new BonDeCommandeGlobale();
    t.setNomTable("BONDECOMMANDE_CLIENT_GLOBALE");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"idbc","idClientLib","quantite","qteOf","qteFab","qteOfRestante","qteFabRestante"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
      pr.setAWhere(" and idbc='"+request.getParameter("id")+"'");
    } else if (request.getParameter("produit")!=null) {
      pr.setAWhere(" and produit='"+request.getParameter("produit")+"' and QTEOFRESTANTE > 0");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
  <%
    String lienTableau[] = {pr.getLien() + "?but=vente/bondecommande/bondecommande-fiche.jsp"};
    String colonneLien[] = {"idbc"};
    String[] attributLien = {"idbc"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);
    String libEnteteAffiche[] =   {"Bon de commande","Client","Quantit&eacute;","Quantit&eacute; OF","Quantit&eacute; Fabrication","Reste OF", "Reste à Fabriquer"};
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