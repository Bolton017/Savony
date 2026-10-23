<%-- 
    Document   : ecriture-detail
    Created on : 30 juil. 2024, 15:15:57
    Author     : bruel
--%>

<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="analyse.AnalyseCpl" %>

<%
    try{
    AnalyseCpl t = new AnalyseCpl();
    t.setNomTable("ANALYSECPL");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] =  {"id", "idcriterelib","idfabricationlib", "idresponsablelib","valeur","etatlib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idfabrication ='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
         String libEnteteAffiche[] =  {"ID", "Crit&egrave;re","Fabrication",  "Responsable","Valeur","&Eacute;tat"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        AnalyseCpl[] liste=(AnalyseCpl[]) pr.getTableau().getData();
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