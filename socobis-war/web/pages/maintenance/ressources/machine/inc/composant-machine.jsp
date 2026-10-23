<%@page import="maintenance.ressources.RecetteMaintenance"%>
<%@ page import="stock.*" %>
<%@ page import="affichage.*" %>
<% try{
    RecetteMaintenance  t = new RecetteMaintenance();
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","idProduitsLib","IdIngredientsLib","unitelib","quantite"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    System.out.println("id====="+request.getParameter("idproduit"));
    if(request.getParameter("idproduit") != null){
        pr.setAWhere(" and idproduits='"+request.getParameter("idproduit")+"'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableau().transformerDataString();
    //String[] lienTableau = {pr.getLien() + "?but=maintenance/demandetravaux/demandetravaux-fiche.jsp"};
    //String[] colonneLien = {"id"};
    //pr.getTableau().setLien(lienTableau);
    //pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"id","Machine","Composant","Unit&eacute;","Quantit&eacute;"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <%  }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }
%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>

