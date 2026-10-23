<%@page import="stock.MvtStockFilleLib"%> 
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<% 
               
    try{
        MvtStockFilleLib  t = new MvtStockFilleLib();
    t.setNomTable("mvtstockfillelib");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id","idmvtstock","idproduitlib","entree","sortie"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" AND idmvtstock in (select id from mvtstock where idtransfert ='"+request.getParameter("id")+"') ");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=stock/mvtstock-fiche.jsp"};
        String colonneLien[] = {"idmvtstock"};
        String attr[] = {"id"};
        pr.getTableau().setLien(lienTableau);

        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attr);
        String libEnteteAffiche[] =   {"Ref.","Ref. Mouvement Stock","Produit","Entr&eacute;e","Sortie"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);

//        Map<String,String> lienTab=new HashMap<>();
//        lienTab.put("Valider",pr.getLien() + "?but=stock/mvtstock-fiche.jsp");
//        lienTab.put("Valider",pr.getLien() + "?but=apresTarif.jsp&bute=stock/mvtstock-fiche.jsp&acte=valider&id="+pr.getFormu().getChamp("idmvtstock").getValeur());
//        pr.getTableau().setLienClicDroite(lienTab);

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