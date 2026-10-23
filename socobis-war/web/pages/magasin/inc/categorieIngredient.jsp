<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="magasin.CategorieIngredientMagasinLib" %>

<% try{ 
    CategorieIngredientMagasinLib o = new CategorieIngredientMagasinLib();
    o.setNomTable("V_CATEGORIEINGREDIENTMAGLIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","idCategorieIngredientLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    String idMagasin = request.getParameter("id");
    if(idMagasin != null && !idMagasin.isEmpty()){
        pr.setAWhere(" and idMagasin='"+idMagasin+"'");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=categorieIngredientMagasin/categorieIngredient-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Cat&eacute;gorie d'ingr&eacute;dient"};
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

