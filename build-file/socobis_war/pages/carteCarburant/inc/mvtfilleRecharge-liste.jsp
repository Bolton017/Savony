<%@page import="stock.MvtStockFilleLib"%>
<%@page import="stock.MvtStockFille"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="utils.ConstanteSocobis" %>

<%
    try{
    MvtStockFilleLib t = new MvtStockFilleLib();
    t.setNomTable("MVTSTOCKFILLELIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id", "libelleexacte", "Entree","sortie","pu","montant", "mvtsrc"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String idProduit = request.getParameter("id");
    String awhere = "";
    if(idProduit != null && !idProduit.isEmpty()){
        awhere = " and idProduit='"+idProduit+"'";
    }
    awhere += " and idTypeMvStock='"+ ConstanteSocobis.TYPE_MVT_ENTREE +"'";
    pr.setAWhere(awhere);
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
        MvtStockFilleLib[] liste=(MvtStockFilleLib[])pr.getListe();
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"ID", "Ingr&eacute;dients", "Entr&eacute;e","Sortie","Prix unitaire","montant", "Mouvement source"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
         }else
         {
               %><div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
         }
        out.print("<div class=\"col-md-12\" style=\"padding: 16px 8px;text-align: end;align-content: end;\" ><b>Montant Total : "+Utilitaire.formaterAr(AdminGen.calculSommeDouble(liste,"montant"))  +" Ar</b></div>");
        
    %>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>


