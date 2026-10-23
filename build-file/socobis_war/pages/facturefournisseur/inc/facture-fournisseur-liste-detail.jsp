
<%@page import="faturefournisseur.FactureFournisseurDetailsCpl"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.FactureFournisseurCpl" %>

<%
    try{
        double montantHT = 0;
        double montantTva = 0;
        double montantTTC = 0;

        FactureFournisseurCpl f = null;
        f = (FactureFournisseurCpl) new FactureFournisseurCpl().getById(request.getParameter("id"), "FACTUREFOURNISSEURCPL", null);
        if(f!=null) {
            montantHT = f.getMontantht();
            montantTva = f.getMontanttva();
            montantTTC = f.getMontantttc();
        }

        FactureFournisseurDetailsCpl t = new FactureFournisseurDetailsCpl();

        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","libelleexacte","qte","pu","tauxDeChange","remise","tva","montant","montantht", "montantttc", "puavecfraisaccessoire", "montantavecfraisaccessoire"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idFactureFournisseur='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;

        String idDevise = (String) request.getAttribute("idDevise");
        if(idDevise==null) idDevise="Ar";
        pr.creerObjetPage(libEntete, colSomme);
        //pr.getTableau().setLienFille("stock/historiqueprix-liste.jsp&idFFD=");
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"R&eacute;f&eacute;rence","Produit","Quantit&eacute;","Prix unitaire","taux","Remise(%)","TVA","Montant HT","Net HT", "montant TTC", "PU avec Frais accessoire (AR)", "Montant TTC avec frais accessoire (AR)"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Total H.T:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(), "montant")) %> <%= idDevise %></b></td>
            </tr>
            <tr>
                <td><b>Montant Remise:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(), "remiseMontant")) %> <%= idDevise %></b></td>
            </tr>
            <tr>
                <td><b>Total Net H.T:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantHT")) %> <%= idDevise %></b></td>
            </tr>
            <tr>
                <td><b>Total TVA:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantTva")) %> <%= idDevise %></b></td>
            </tr>
            <tr>
                <td><b>Net &agrave; payer:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantTTC")) %> <%= idDevise %></b></td>
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


