<%-- 
    Document   : avoir-details
    Created on : 9 ao�t 2024, 10:22:24
    Author     : bruel
--%>


<%@page import="avoir.AvoirFCFilleLib"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    try{
    AvoirFCFilleLib t = new AvoirFCFilleLib();
    t.setNomTable("AVOIRFCFILLELIB");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "idproduitlib","qte","pu","remise","tva","montantht","montantremise","montantttc","idDevise","tauxDeChange"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and IDAVOIRFC='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    AvoirFCFilleLib[] listeFille=(AvoirFCFilleLib[]) pr.getTableau().getData();

    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Ref.","Produit","Quantit&eacute;","PU H.T","Remise (%)","TVA (%)","Net H.T","Montant de la remise","Montant TTC","Devise","Taux de change"};

        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        AvoirFCFilleLib[] liste=(AvoirFCFilleLib[]) pr.getTableau().getData();
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
        <div class="w-100" style="display: flex; flex-direction: row-reverse;">
            <table style="width: 20%"class="table">
                <tr>
                    <td><b>Total H.T:</b></td>
                    <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montantht")) %> <%=((AvoirFCFilleLib)pr.getListe()[0]).getIdDevise()%></b></td>
                </tr>
                <tr>
                    <td><b>Remise globale:</b></td>
                    <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantremise")) %> <%= ((AvoirFCFilleLib)pr.getListe()[0]).getIdDevise() %></b></td>
                </tr>
                <tr>
                    <td><b>Total taxe:</b></td>
                    <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montanttva")) %> <%=((AvoirFCFilleLib)pr.getListe()[0]).getIdDevise()%></b></td>
                </tr>
                <tr>
                    <td><b>Net &agrave; retourner:</b></td>
                    <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montantttc")) %> <%=((AvoirFCFilleLib)pr.getListe()[0]).getIdDevise()%></b></td>
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

