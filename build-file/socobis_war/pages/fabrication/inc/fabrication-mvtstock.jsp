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
<%@ page import="produits.Ingredients" %>


<%
    try{
        MvtStockLib t = new MvtStockLib();
        t.setNomTable("MvtStockLib");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "daty", "designation","idTypeMvStocklib","idMagasinlib","idVentelib","montantTot","etatlib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            String idFab = request.getParameter("id");
            pr.setAWhere(" and IDOBJET='"+idFab+"'");
            pr.setApres("fabrication/fabrication-fiche.jsp&id="+idFab+"&tab=inc/fabrication-mvtstock");
        }
        String[] colSomme = null;
        //pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        pr.getTableau().transformerDataString();
        String lienTableau[] = {pr.getLien() + "?but=stock/mvtstock-fiche.jsp"};
        String colonneLien[] = {"id"};
        String colonneModal[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setModalOnClick(true,colonneModal);
        pr.getTableau().setLienFille("stock/mvtfille-liste.jsp&id=");
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"id","Date","d&eacute;signation", "Type de mouvement","Magasin","Vente","montant","&Eacute;tat"};
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

