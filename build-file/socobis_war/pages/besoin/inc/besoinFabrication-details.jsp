<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="besoin.BesoinFabricationDetailsLib" %>

<% try{ 
    BesoinFabricationDetailsLib o = new BesoinFabricationDetailsLib();
    o.setNomTable("BESOINFABRICATIONDETAILSCPL");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","idproduitlib","qte","unite"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idbesoinfabrication='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Produit","Quantit&eacute;","Unit&eacute;"};
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

