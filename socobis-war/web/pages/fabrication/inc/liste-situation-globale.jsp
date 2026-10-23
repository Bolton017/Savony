<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="fabrication.SituationOfFille" %>

<% try{ 
    SituationOfFille o = new SituationOfFille();
    o.setNomTable("SITUATIONOFFILLEWATELIER");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"idingredients","libingredients","qteof","qtefabrique","raf","atelierlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setApres("fabrication/ordre-fabrication-details-fiche.jsp&id="+request.getParameter("id"));
        pr.setAWhere(" and IDPRODUITS='"+request.getParameter("id")+"'");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id Produit","Produit","Quantit&eacute; OF","Quantit&eacute; fabriqu&eacute;e","Reste a faire","Atelier"};
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

