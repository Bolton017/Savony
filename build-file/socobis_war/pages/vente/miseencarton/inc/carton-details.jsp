<%@page import="vente.AsBonDeLivraisonClientFilleCPL"%>
<%@page import="vente.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    try{
    CartonFilleCpl t = new CartonFilleCpl();
    t.setNomTable("CARTONFILLE_CPL");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id","produitlib","quantite","idbcfille","remarque"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idmere='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"Id","Produit", "Quantite","Id BC Fille","Remarque"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        CartonFilleCpl[] liste=(CartonFilleCpl[]) pr.getTableau().getData();
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <%  }if(pr.getTableau().getHtml() == null)
         {
               %><center><h4>Aucune donne trouvee</h4></center><%
         }

        
    %>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>
