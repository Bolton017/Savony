<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="faturefournisseur.proforma.ProformaFournisseurDetailsCpl" %>

<%
    try{
        ProformaFournisseurDetailsCpl t = new ProformaFournisseurDetailsCpl();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "produitlib", "pu", "quantite", "montant" , "fournisseurlib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and produit='"+request.getParameter("id")+"' and idoriginemere = '" + request.getParameter("iddmd") + "'");
            System.out.println("Where = " + pr.getAWhere());
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
        String libEnteteAffiche[] =  {"id", "Produit", "Prix unitaire", "Quantit&eacute;", "Montant", "Fournisseur"};
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

