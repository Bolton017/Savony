<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="faturefournisseur.historique.HistoriqueValidationDmdAchat" %>

<% try{ 
    HistoriqueValidationDmdAchat o = new HistoriqueValidationDmdAchat();
    o.setNomTable("HISTORIQUEVALIDATIONDMDACHAT");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","nomuser","daty","heure"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    if(request.getParameter("id")!=null && !request.getParameter("id").equals("")){
        pr.setAWhere(" and idDmdAchat = '"+request.getParameter("id")+"' ORDER BY daty, heure desc");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Utilisateur","Date","Heure"};
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

