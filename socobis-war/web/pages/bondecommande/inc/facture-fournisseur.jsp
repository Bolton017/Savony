<%@page import="faturefournisseur.FactureFournisseurCpl"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    try {
        String lien = (String) session.getValue("lien");
        FactureFournisseurCpl bc = new FactureFournisseurCpl();
        bc.setNomTable("FACTUREFOURNISSEURCPL");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "numero", "designation","idFournisseurLib","idDevise","daty","montantht","montanttva","montantttc","montantpaye", "montantreste", "dateEcheancePaiement","etatlib"};
        PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String id = request.getParameter("id");
        if(id != null){
            pr.setAWhere(pr.getAWhere() + " and idbc='"+id+"'");
        }
        String[] colSomme = null;
        pr.setNpp(20);
        pr.creerObjetPage(libEntete, colSomme);
        int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"ID Facture", "Num&eacute;ro", "D&eacute;signation","Fournisseur","Devise","Date","Montant HT","Montant TVA","Montant TTC","Montant pay&eacute;","Montant Restant", "Date d'&Eacute;ch&eacute;ance","&Eacute;tat"};
        String lienTableau[] = {pr.getLien() + "?but=facturefournisseur/facturefournisseur-fiche.jsp"};
        String colonneLien[] = {"id"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setLienFille("facturefournisseur/inc/facture-fournisseur-liste-detail.jsp&id=");
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if (pr.getTableau().getHtml() != null) {
            out.println(pr.getTableau().getHtml());
        } else {
    %><center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center><%
        }
    %>
    <div class="box-footer">

    </div>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>
