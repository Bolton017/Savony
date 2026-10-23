

<%@page import="faturefournisseur.FactureFournisseurCpl"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    /*
    String id,produit,numbl;
    double quantite;
    String iddetailsfacturefournisseur;
    String magasin;
    String unite;
    */
    try {
        String lien = (String) session.getValue("lien");
        FactureFournisseurCpl bc = new FactureFournisseurCpl();
         bc.setNomTable("FACTUREFOURNISSEURCPL");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "idBc","designation","idFournisseurLib","idDevise","daty","montantttc","montantpaye", "montantreste", "dateEcheancePaiement","etatlib"};
        PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String id =request.getParameter("id");
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idobjet='"+id+"'");
        }
        String[] colSomme = null;
        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"ID Facture", "Id BC","D&eacute;signation","Fournisseur","devise","Date","Montant TTC","Montant pay&eacute;","Montant Restant", "date d'&Eacute;ch&eacute;ance de Paiement","&Eacute;tat"};
        String lienTableau[] = {pr.getLien() + "?but=facturefournisseur/facturefournisseur-fiche.jsp", pr.getLien() + "?but=bondecommande/bondecommande-fiche.jsp"};
        String colonneLien[] = {"id","idBc"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if (pr.getTableau().getHtml() != null) {
            out.println(pr.getTableau().getHtml());
        } else {
    %><center><h4>Aucune donne trouvee</h4></center><%
                   }


        %>
    <div class="box-footer">

    </div>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>

