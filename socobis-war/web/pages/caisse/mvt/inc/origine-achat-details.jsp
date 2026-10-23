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
<%@ page import="faturefournisseur.FactureFournisseurCpl" %>


<%
    try{
    FactureFournisseurCpl t = new FactureFournisseurCpl();
    t.setNomTable("FF_VNT_MVTCAISSE_ORIGINE");
    String listeCrt[] = {};
    String listeInt[] = {};
        String libEntete[] = {"id", "designation","idFournisseurLib","idDevise","daty","montantttc","montantpaye", "montantreste","etatlib"};

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idorigine='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"id", "D&eacute;signation","Fournisseur","devises","Date","Montant TTC","Montant pay&eacute;","Montant Reste","&Eacute;tat"};
        String lienTableau[] = {pr.getLien() + "?but=facturefournisseur/facturefournisseur-fiche.jsp"};
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