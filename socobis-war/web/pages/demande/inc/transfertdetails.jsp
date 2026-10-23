<%@page import="stock.TransfertStockCpl"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="demande.DemandeTransfertFilleCpl" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    try{
        TransfertStockCpl t = new TransfertStockCpl();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","daty","designation","idMagasinDepartlib","idMagasinArrivelib","etatlib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and iddemande='"+request.getParameter("id")+"'");
        }

//        String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
//        String colonneLien[] = {"idProduit"};
//        pr.getTableau().setLien(lienTableau);
//        pr.getTableau().setColonneLien(colonneLien);

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        String lienTableau[] = {pr.getLien() + "?but=stock/transfertstock/transfertstock-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLienFille("stock/transfertstock/inc/transfertstockdetails-liste.jsp&id=");
        Map<String,String> lienTab=new HashMap();
        lienTab.put("Valider",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=stock/transfertstock/transfertstock-fiche.jsp&classe=stock.TransfertStock&nomtable=TRANSFERTSTOCK");
        pr.getTableau().setLienClicDroite(lienTab);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Ref","Date","D&eacute;signation","Magasin de d&eacute;part","Magasin d'arriv&eacute;e","&Eacute;tat"};
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


