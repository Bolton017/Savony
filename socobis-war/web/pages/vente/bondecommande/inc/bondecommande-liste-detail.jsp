<%@page import="faturefournisseur.As_BonDeCommande_Fille_CPL"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="vente.BonDeCommandeFIlleCpl" %>
<%@ page import="vente.BonDeCommande" %>

<%
    try{
        BonDeCommandeFIlleCpl t = new BonDeCommandeFIlleCpl();
        t.setNomTable("BC_CLIENT_FILLE_CPL_LIB");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"produit","produitlib","unitelib","quantite", "poidstotal","pu","remise", "montanttotal", "montantremise", "montanttva", "montantttc", "qtereste"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idbc='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        BonDeCommandeFIlleCpl[] listeFille=(BonDeCommandeFIlleCpl[]) pr.getTableau().getData();
        if(listeFille.length>0) {
            BonDeCommande o = new BonDeCommande();
            o.setFille(listeFille);
            //o.calculerRevient(null);
        }

%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneLien[] = {"produit"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        String libEnteteAffiche[] =   {"ID","Produit","Unit&eacute;","Quantit&eacute;", "Poids Total","Prix Unitaire H.T","remise(%)", "Montant H.T", "Net H.T","Taxe","Montant TTC","Reste &agrave; facturer"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Total H.T:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montanttotal")) %> Ar</b></td>
            </tr>
            <tr>
                <td><b>Total net H.T:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montantremise")) %> Ar</b></td>
            </tr>
            <tr>
                <td><b>Total taxe:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montanttva")) %> Ar</b></td>
            </tr>
            <tr>
                <td><b>Net &agrave; payer:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montantttc")) %> Ar</b></td>
            </tr>
        </table>
    </div>
    <% }if(pr.getTableau().getHtml() == null){
    %><div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
    }
%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>