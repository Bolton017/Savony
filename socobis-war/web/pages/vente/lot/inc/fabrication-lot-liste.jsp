
<%@page import="fabrication.FabricationLot"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    try{
    FabricationLot t = new FabricationLot();
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "lanceparLib", "cibleLib", "remarque", "libelle", "daty","idOf","idOffille","etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idlot='"+request.getParameter("id")+"'");
    } 
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
    
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"ID", "Lanc&eacute;e par", "Cible", "Remarque", "D&eacute;signation", "Date","Id ordre de fabrication","Id Ordre de fabrication fille","&eacute;tat"};
         pr.getTableau().setLibelleAffiche(libEnteteAffiche);
         String lienTableau[] = {pr.getLien() + "?but=fabrication/fabrication-fiche.jsp" , pr.getLien() + "?but=fabrication/ordre-fabrication-fiche.jsp", pr.getLien() + "?but=fabrication/ordre-fabrication-details-fiche.jsp"};
        String colonneLien[] = {"id" , "idOf","idOffille"};
        String[] urlLienMultiple = {"id", "idOf","idOffille"};
        String[] urlLienAffiche = {"id", "id","id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setUrlLienAffiche(urlLienAffiche);
        pr.getTableau().setUrlLien(urlLienMultiple);
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


