<%--
    Document   : vente-details
    Created on : 22 mars 2024, 17:05:45
    Author     : Angela
--%>


<%@page import="vente.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    try{
        As_BondeLivraisonClientFille_Cpl t = new As_BondeLivraisonClientFille_Cpl();
        t.setNomTable("rapprochement_bf_client");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"produit", "idProduitlib","quantite","unitelib","qtelivree","qterestealivrer","qtesortie","resteasortir"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and NUMBL='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;

        pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneLien[] = {"produit"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        String libEnteteAffiche[] =  {"Ref. Produit", "Libell&eacute;","Quantit&eacute;","Unit&eacute;","Quantit&eacute; Livr&eacute;e","Quantit&eacute; Restante &Agrave; livrer","Quantit&eacute; Sortie","Reste &agrave; Sortir"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        As_BondeLivraisonClientFille_Cpl[] liste=(As_BondeLivraisonClientFille_Cpl[]) pr.getTableau().getData();
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

