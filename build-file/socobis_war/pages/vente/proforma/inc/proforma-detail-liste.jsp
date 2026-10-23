<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 05/08/2025
  Time: 14:10
  To change this template use File | Settings | File Templates.
--%>

<%@page import="proforma.*"%>
<%@ page import="affichage.*" %>
<%@ page import="bean.AdminGen" %>


<%
  try {
    ProformaDetailsLib t = new ProformaDetailsLib();
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "idProduitlib", "qte","unitelib", "pu","remise","tva", "puTotal", "montanttotal","remisemontant", "montanttva", "montantttc", "idDevise", "tauxdechange"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if (request.getParameter("id") != null) {
      pr.setAWhere(" and idProforma='" + request.getParameter("id") + "'");
    }
    String[] colSomme = null;
    pr.setNpp(100);
    pr.creerObjetPage(libEntete, colSomme);
    ProformaDetailsLib[] listeFille=(ProformaDetailsLib[]) pr.getTableau().getData();
    String lienTableau[] = {pr.getLien() + "?but=vente/proforma/proforma-detail-fiche.jsp", pr.getLien() + "?but=devis/devis-fiche.jsp"};
    String colonneLien[] = {"id"};
    String attLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(attLien);
    pr.getTableau().setColonneLien(colonneLien);
  pr.getTableau().transformerDataString();

%>

<div class="box-body">
  <%  String libEnteteAffiche[] = {"Ref.", "Produit", "Quantit&eacute;","Unit&eacute;","P.U HT","Remise en (%)","TVA en (%)","Montant H.T", "Net H.T","Montant de la remise", "Taxe", "Montant TTC", "Devise", "Taux de Change"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    //pr.getTableau().setTailleImage("100");
    pr.getTableau().getData();
    if (pr.getTableau().getHtml() != null) {
      out.println(pr.getTableau().getHtml());
      %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Total H.T:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"puTotal")) %> <%=((ProformaDetailsLib)pr.getListe()[0]).getIdDevise()%></b></td>
            </tr>
<%--            <tr>--%>
<%--                <td><b>Transport:</b></td>--%>
<%--                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"fraistransport")) %> <%=((ProformaDetailsLib)pr.getListe()[0]).getIdDevise()%> </b></td>--%>
<%--            </tr>--%>
<%--            <tr>--%>
<%--                <td><b>Ristourne:</b></td>--%>
<%--                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montantristourne")) %> <%=((ProformaDetailsLib)pr.getListe()[0]).getIdDevise()%></b></td>--%>
<%--            </tr>--%>
            <tr>
                <td><b>Total remise:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"remisemontant")) %> <%=((ProformaDetailsLib)pr.getListe()[0]).getIdDevise()%></b></td>
            </tr>
            <tr>
                <td><b>Total net H.T:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montanttotal")) %> <%=((ProformaDetailsLib)pr.getListe()[0]).getIdDevise()%></b></td>
            </tr>
            <tr>
                <td><b>Total taxe:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montanttva")) %> <%=((ProformaDetailsLib)pr.getListe()[0]).getIdDevise()%></b></td>
            </tr>
            <tr>
                <td><b>Net &agrave; payer:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montantttc")) %> <%=((ProformaDetailsLib)pr.getListe()[0]).getIdDevise()%></b></td>
            </tr>
        </table>
    </div>

    <%    } else {
  %><center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center><%
  }
%>
</div>
<%    } catch (Exception e) {
  e.printStackTrace();
}%>

