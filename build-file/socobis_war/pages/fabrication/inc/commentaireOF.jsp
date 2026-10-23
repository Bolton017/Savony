<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="fabrication.CommentaireOFLib" %>

<% try{ 
    CommentaireOFLib o = new CommentaireOFLib();
    o.setNomTable("COMMENTAIREOF_LIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","idObjet","val","nomUser"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String idOF = request.getParameter("id");
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idObjet='"+idOF+"'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","R&eacute;f. Ordre de fabrication","Description","Nom"};
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

