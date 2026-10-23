<%-- 
    Document   : ecriture-detail
    Created on : 30 juil. 2024, 15:15:57
    Author     : bruel
--%>

<%@page import="paiement.LiaisonPaiement"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    try{
    LiaisonPaiement t = new LiaisonPaiement();
    t.setNomTable("LiaisonPaiement");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] =  {"id","id1", "montant"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and id2='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;

        String lienTableau[] = {pr.getLien() + "?but=caisse/mvt/mvtCaisse-fiche.jsp"};
        String colonneLien[] = {"id1"};
        String attLien[] = {"id"};
        pr.getTableau().setAttLien(attLien);
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Ref.","Ref. Paiement", "Montant"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        LiaisonPaiement[] liste=(LiaisonPaiement[]) pr.getTableau().getData();
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