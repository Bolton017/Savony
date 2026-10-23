<%-- 
    Document   : ecriture-detail
    Created on : 30 juil. 2024, 15:15:57
    Author     : bruel
--%>

<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="vente.VenteLib" %>


<%
    try{
    VenteLib t = new VenteLib();
    t.setNomTable("MOUVEMENTCAISSE_DETAIL");
    String listeCrt[] = {};
    String listeInt[] = {};
        String libEntete[] = {"id", "designation","idClientLib","idDevise","daty","montantttc","montantpaye", "montantreste", "montantimpute", "etatlib"};

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idobjet='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"id", "D&eacute;signation","Client","devise","Date","Montant TTC","Montant Pay&eacute;","Montant Reste", "Montant Mouvement caisse","Etat"};
        String lienTableau[] = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
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