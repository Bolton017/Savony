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


<%
    try{
        VenteDetailsLib t = new VenteDetailsLib();
        t.setNomTable("VENTE_DETAILS_POIDS");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "idproduitlib","unitelib","qte","pu","remise","tva","montantht","montantremise","montantttc","idDevise","tauxDeChange","reste"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idVente='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;

        pr.creerObjetPage(libEntete, colSomme);
        int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Ref.","Produit","Unit&eacute;","Quantit&eacute;","PU H.T","Remise (%)","TVA (%)","Net H.T","Montant de la remise","Montant TTC","Devise","Taux de change","Reste &agrave; Livrer"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Total H.T:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montant")) %> <%= ((VenteDetailsLib)pr.getListe()[0]).getIdDevise() %></b></td>
            </tr>
            <tr>
                <td><b>Remise globale:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantremise")) %> <%= ((VenteDetailsLib)pr.getListe()[0]).getIdDevise() %></b></td>
            </tr>
<%--            <tr>--%>
<%--                <td><b>Participation transport:</b></td>--%>
<%--                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"frais")) %> <%= ((VenteDetailsLib)pr.getListe()[0]).getIdDevise() %></b></td>--%>
<%--            </tr>--%>
            <tr>
                <td><b>Total Net H.T:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantht")) %> <%= ((VenteDetailsLib)pr.getListe()[0]).getIdDevise() %></b></td>
            </tr>
            <tr>
                <td><b>Total Taxe:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montanttva")) %> <%= ((VenteDetailsLib)pr.getListe()[0]).getIdDevise() %></b></td>
            </tr>
            <tr>
                <td><b>Net &agrave; payer:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantttc")) %> <%= ((VenteDetailsLib)pr.getListe()[0]).getIdDevise() %></b></td>
            </tr>
        </table>
    </div>
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

