<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="faturefournisseur.proforma.ProformaFournisseurCpl" %>

<%
    try{
        ProformaFournisseurCpl t = new ProformaFournisseurCpl();
        t.setNomTable("PROFORMAFOURNISSEUR_MERECPL");
        String[] listeCrt = {};
        String[] listeInt = {};
        String[] libEntete = {"id","designation","fournisseurlib","etatlib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setAWhere(" AND idOrigine='"+request.getParameter("id")+"' and etat >= 11");
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        pr.setNpp(10);


        pr.creerObjetPage(libEntete, colSomme);

        pr.getTableau().setLienFille("facturefournisseur/proforma/inc/proforma-details-valide.jsp&iddmd=" + request.getParameter("id") + "&idProforma=");

        String[] lienTableau = {pr.getLien() + "?but=facturefournisseur/proforma/proforma-fiche.jsp"};
        String colonneModal[] = {"id"};
        String[] colonneLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setModalOnClick(true,colonneModal);
        pr.getTableau().setColonneLien(colonneLien);


        Map<String,String> lienTab=new HashMap();
        lienTab.put("Generer BC",pr.getLien() + "?but=facturefournisseur/proforma/apresGenerer.jsp&iddmd=" + request.getParameter("id"));
        pr.getTableau().setLienClicDroite(lienTab);
%>

<div class="box-body">
    <%
        String[] libEnteteAffiche =  {"Id","D&eacute;signation","Fournisseur","Etat"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {
    %><center><h4>Aucune donne trouv&eacute;e</h4></center><%
    }

%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>