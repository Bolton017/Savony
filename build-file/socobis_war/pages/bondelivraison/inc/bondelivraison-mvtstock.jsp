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
        String libEntete[] = {"id","daty", "designation", "idMagasinlib","montantTot","idTypeMvStocklib","etatlib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            String idFab = request.getParameter("id");
            pr.setAWhere(" and IDOBJET='"+idFab+"'");
            pr.setApres("bondelivraison/bondelivraison-fiche.jsp&id="+idFab+"&tab=bondelivraison-mvtstock");
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
        String libEnteteAffiche[] =  {"id","Date", "d&eacute;signation", "Magasin","montant","Type de Mouvement","&Eacute;tat"};
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