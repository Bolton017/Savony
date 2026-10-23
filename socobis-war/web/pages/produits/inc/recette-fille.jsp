<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="production.CritereProduitLib" %>
<%@ page import="produits.RecetteFilleLib" %>

<% try{ 
    RecetteFilleLib o = new RecetteFilleLib();
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"idIngredientLib","idUnite","qte"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    String[] colSomme = null;
    if(request.getParameter("idMere") != null){
        pr.setAWhere(" and idmere='" + request.getParameter("idMere") + "'");
    }
    pr.creerObjetPage(libEntete, colSomme);
    String[] libEnteteAffiche = {"Ingr&eacute;dient","Unit&eacute;","Quantit&eacute;"};
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

