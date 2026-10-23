<%--
  Created by IntelliJ IDEA.
  User: tsinjoniaina
  Date: 25/09/2026
  Time: 09:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="avoir.AvoirAchatFilleLib" %>
<%@ page import="bean.AdminGen" %>

<% try{
    AvoirAchatFilleLib o = new AvoirAchatFilleLib();
    o.setNomTable("AVOIRACHATFILLELIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","idProduitLib","qte","pu","remise","tva","idDeviseLib","taux"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getAttribute("u"));
    pr.setLien((String) session.getAttribute("lien"));

    String id = request.getParameter("id");
    if (id != null && !id.isEmpty()) {
        pr.setAWhere(" AND idMere = '"+id+"'");
    }
    pr.creerObjetPage(libEntete, null);
    String idDevise = (String) request.getAttribute("idDevise");
    if(idDevise==null) idDevise="Ar";

    String[] libEnteteAffiche = {"Id","Produit","Quantit&eacute;","Prix unitaire","Remise(%)","TVA(%)","Devise","Taux de change"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="box-body">
    <%  if(pr.getTableau().getHtml() != null) { %>
    <% out.println(pr.getTableau().getHtml()); %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Montant HT:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantHT")) %> <%= idDevise %></b></td>
            </tr>
            <tr>
                <td><b>Montant TVA:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantTva")) %> <%= idDevise %></b></td>
            </tr>
            <tr>
                <td><b>Montant TTC:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantTTC")) %> <%= idDevise %></b></td>
            </tr>
        </table>
    </div>
    <% } else{ %>
    <center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center>
    <%  } %>
</div>

<% } catch (Exception e) {
    e.printStackTrace();%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>


