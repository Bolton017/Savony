<%--
    Document   : vente-details
    Created on : 22 mars 2024, 17:05:45
    Author     : Angela
--%>


<%@page import="fabrication.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="stock.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="stock.MvtStockFilleLib" %>


<%
    try{
        MvtStockFilleLib t = new MvtStockFilleLib();
        t.setNomTable("mvtstocktransfert");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"idmvtstock", "daty", "idproduitlib","entree","sortie","idmagasinlib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            String idTransfert = request.getParameter("id");
            pr.setAWhere(" and iddemande='"+idTransfert+"'");
        }
        String[] colSomme = null;
        //pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        pr.getTableau().transformerDataString();
        String lienTableau[] = {pr.getLien() + "?but=stock/mvtstock-fiche.jsp"};
        String colonneLien[] = {"idmvtstock"};
        String attributLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setColonneLien(colonneLien);

%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Ref", "Date", "Produit","Entr&eacute;e","Sortie","Magasin"};
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

