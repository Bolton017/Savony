<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="calculBesoin.CalculBesoinFilleLib" %>

<% try{ 
    CalculBesoinFilleLib o = new CalculBesoinFilleLib();
    o.setNomTable("CALCULBESOINFILLELIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","idproduitLib","qte"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    String id = request.getParameter("id");
    if(id != null) {
        pr.setAWhere(" AND IDMERE = '" + id + "' ");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Produit","Qte"};
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

