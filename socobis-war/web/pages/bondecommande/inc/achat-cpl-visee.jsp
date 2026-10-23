<%@page import="faturefournisseur.As_BonDeCommande_Fille_CPL"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
    try{
    As_BonDeCommande_Fille_CPL t = new As_BonDeCommande_Fille_CPL();
    t.setNomTable("AS_BONDECOMMANDE_CPL_RECEPT");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id","produitlib","unitelib","quantite","qtelivrer","qtefacturer","resteLivre","resteFacture"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idbc='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.setNpp(20);
    pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =   {"id","produit","unit&eacute;","Quantit&eacute;","Quantit&eacute; livr&eacute;e","Quantit&eacute; factur&eacute;e","Reste &agrave; livrer","Reste &agrave; facturer"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
   
    <% }if(pr.getTableau().getHtml() == null){
                %><div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
    }
    %>  
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>