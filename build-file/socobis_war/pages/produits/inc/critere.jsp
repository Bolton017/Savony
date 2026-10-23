<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="production.CritereProduitLib" %>

<% try{ 
    CritereProduitLib o = new CritereProduitLib();
    o.setNomTable("CRITEREPRODUITLIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","idcriterelib","idtypeproduitlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    if(request.getParameter("id") != null){
        pr.setAWhere("WHERE idTypeProduit = " + request.getParameter("id"));
    }
    String[] lienTableau = {pr.getLien() + "?but=production/critereProduit-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Crit&egrave;re","Type Produit"};
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
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

