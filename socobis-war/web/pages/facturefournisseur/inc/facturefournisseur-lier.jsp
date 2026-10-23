<%-- 
    Document   : mvtcaisse-details
    Created on : 26 mars 2024, 09:49:32
    Author     : Angela
--%>

<%@page import="caisse.MvtCaisseCpl"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.FactureFournisseurCpl" %>


<%
    try {
        FactureFournisseurCpl bc = new FactureFournisseurCpl();
        bc.setNomTable("FACTUREFOURNISSEURCPL_LIER");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "designation","idFournisseurLib","montantttc","montantpaye", "montantreste","idDevise"};
        PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if (request.getParameter("id") != null) {
            pr.setAWhere(" and id1='" + request.getParameter("id") + "'");
        }
        String[] colSomme = null;
        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        String lienTableau[] = {pr.getLien() + "?but=facturefournisseur/facturefournisseur-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);

%>

<div class="box-body">
    <%  String libEnteteAffiche[] = {"id", "d&eacute;signation","Fournisseur","montant ttc","montant paye", "montant reste","Devise"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        pr.getTableau().getData();
        if (pr.getTableau().getHtml() != null) {
            out.println(pr.getTableau().getHtml());
        } else {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }


%>
</div>
<%    } catch (Exception e) {
    e.printStackTrace();
}%>

