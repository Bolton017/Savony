<%--
  Created by IntelliJ IDEA.
  User: tsinjoniaina
  Date: 25/09/2026
  Time: 10:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="avoir.AvoirAchatLib" %>

<% try{
    AvoirAchatLib o = new AvoirAchatLib();
    o.setNomTable("AVOIRACHATCALC_AVEC_LIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","designation","daty","idFournisseurLib", "montantHt", "montantTva", "montantTtc","remarque", "etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getAttribute("u"));
    pr.setLien((String) session.getAttribute("lien"));

    String id = request.getParameter("id");
    if (id != null && !id.isEmpty()) {
        pr.setAWhere(" AND idFacture = '"+id+"'");
    }
    pr.creerObjetPage(libEntete, null);

    String[] lienTableau = {pr.getLien() + "?but=facturefournisseur/avoir/avoirachat-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","D&eacute;signation","Date","Fournisseur", "Montant HT", "Montant TVA", "Montant TTC","Remarque", "&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="box-body">
    <%  if(pr.getTableau().getHtml() != null){
        out.println(pr.getTableau().getHtml());
    } else{ %>
    <center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center>
    <%  } %>
</div>

<% } catch (Exception e) {
    e.printStackTrace(); %>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>


