
<%@page import="vente.VenteLot"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    try{
    VenteLot t = new VenteLot();
    t.setNomTable("VENTELOTLIB");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "datyprevu","designation","idClientLib","idDevise","referencefacture","numerofacture","montantttc","montantpaye", "montantreste"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idlot='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"id", "Date","D&eacute;signation","Client","devise","R&eacute;f&eacute;rence de la facture","Numero de la facture","Montant TTC","Montant Pay&eacute;","Montant restant"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        VenteLot[] liste=(VenteLot[]) pr.getTableau().getData();
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

