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
        As_BonDeCommande_Fille_CPL t = new As_BonDeCommande_Fille_CPL();
    t.setNomTable("AS_BONDECOMMANDE_CPL_RECEPT");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"produit","produitlib","designation","unitelib","quantite","qtelivrer","qtefacturer","pu","remise","montant","montantht","montantTva","montantTTC","montantTtcAr"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idbc='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.setNpp(100);
    pr.creerObjetPage(libEntete, colSomme);

        String[] lienTableau = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String[] colonneModal = {"produit"};
        String[] colonneLien = {"produit"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setModalOnClick(true, colonneModal);
%>

<div class="box-body">
    <%

        String libEnteteAffiche[] =   {"ID","produit","D&eacute;signation","unit&eacute;","Quantit&eacute;","Quantit&eacute; re&ccedil;ue", "Quantit&eacute; factur&eacute;e","Prix unitaire H.T","Remise (%)","Montant H.T","Net H.T","Montant TVA","Montant TTC","Montant TTC AR"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Montant HT:</b></td>
                <td><b><%= Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montant")) %> <%= ((As_BonDeCommande_Fille_CPL)pr.getListe()[0]).getIdDevise() %></b></td>
            </tr>
            <tr>
                <td><b>Montant Remise:</b></td>
                <td><b><%= Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"remiseMontant")) %> <%= ((As_BonDeCommande_Fille_CPL)pr.getListe()[0]).getIdDevise() %></b></td>
            </tr>
            <tr>
                <td><b>Net HT:</b></td>
                <td><b><%= Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantHT")) %> <%= ((As_BonDeCommande_Fille_CPL)pr.getListe()[0]).getIdDevise() %></b></td>
            </tr>
            <tr>
                 <td><b>Montant TVA:</b></td>
                <td><b><%= Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantTVA")) %> <%= ((As_BonDeCommande_Fille_CPL)pr.getListe()[0]).getIdDevise() %></b></td>
            </tr>
            <tr>
                <td><b>Montant TTC:</b></td>
                <td><b><%= Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantTTC")) %> <%= ((As_BonDeCommande_Fille_CPL)pr.getListe()[0]).getIdDevise() %></b></td>
            </tr>
        </table>
    </div>
    <% }if(pr.getTableau().getHtml() == null){
                %><div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
    }
    %>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>