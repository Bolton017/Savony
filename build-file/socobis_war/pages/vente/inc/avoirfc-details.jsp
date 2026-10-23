<%-- 
    Document   : avoirfc-details
    Created on : 9 ao�t 2024, 15:37:27
    Author     : bruel
--%>

<%@page import="avoir.AvoirFCLib"%>
<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    try{
    AvoirFCLib t = new AvoirFCLib();
    t.setNomTable("AVOIRFCLIB");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] =  {"id", "idMagasinLib", "idMotifLib" , "idCategorieLib", "montantHT", "montantTVA", "montantTTC", "montantHTAr", "montantTVAAr", "montantTTCAr","etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idvente='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.setNpp(10);
    String lienTableau[] = {pr.getLien() + "?but=avoir/avoirFC-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLienFille("avoir/inc/avoirfc-details.jsp&id=");
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
         String libEnteteAffiche[] =  {"Ref.", "Magasin", "Motif" , "Cat&eacute;gorie", "Montant HT", "Montant TVA", "Montant TTC", "Montant HT Ar", "Montant TVA Ar", "Montant TTC Ar","&Eacute;tat"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
         }else
         {
               %><center><h4>Aucune donne trouvee</h4></center><%
         }

        
    %>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>
