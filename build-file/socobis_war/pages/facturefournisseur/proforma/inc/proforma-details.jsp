<%--
    Document   : vente-details
    Created on : 22 mars 2024, 17:05:45
    Author     : Angela
--%>


<%@page import="vente.VenteDetailsLib"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.proforma.ProformaFournisseurDetails" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="faturefournisseur.proforma.ProformaFournisseurDetailsCpl" %>


<%
    try{
        ProformaFournisseurDetailsCpl t = new ProformaFournisseurDetailsCpl();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "produitlib", "unitelib", "quantite", "montant"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("idProforma") != null){
            pr.setAWhere(" and idMere='"+request.getParameter("idProforma")+"'");
        }
        String[] colSomme = null;

        pr.creerObjetPage(libEntete, colSomme);

        Map<String,String> lienTab=new HashMap();
        lienTab.put("Valider",pr.getLien() + "?but=facturefournisseur/proforma/apresAction.jsp&to=11&iddmd=" + request.getParameter("iddmd"));
        lienTab.put("annuler",pr.getLien() + "?but=facturefournisseur/proforma/apresAction.jsp&to=0&iddmd=" + request.getParameter("iddmd"));
        pr.getTableau().setLienClicDroite(lienTab);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"id", "Produit", "Unit&eacute;", "Quantit&eacute;", "Montant"};
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
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>

