
<%@ page import="stock.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.As_BonDeCommandeCpl" %>
<%@ page import="faturefournisseur.FactureFournisseurCpl" %>


<%
    try{
        FactureFournisseurCpl t = new FactureFournisseurCpl();
        t.setNomTable("FACTUREFOURNISSEURCPL_TOUS");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "daty","designation","idFournisseurLib","idDevise","montantttc","montantpaye", "montantreste","dateecheancepaiement","etatlib"};
        String libEnteteAffiche[] = {"id","Date","D&eacute;signation","Fournisseur","devises","Montant TTC","Montant pay&eacute;","Montant Restant","Date d'&eacute;ch&eacute;ance de paiement","&Eacute;tat"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            String idFab = request.getParameter("id");
            pr.setAWhere(" and idRef='"+idFab+"'");
            pr.setApres("maintenance/travaux/Otravaux-details-fiche.jsp&id="+idFab+"&tab=inc/achat-details");
        }
        String[] colSomme = null;
        //pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        pr.getTableau().transformerDataString();
        String lienTableau[] = {pr.getLien() + "?but=facturefournisseur/facturefournisseur-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%
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

