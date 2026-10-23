<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="magasin.DirectionMagasinLib" %>

<% try {
    DirectionMagasinLib objet = new DirectionMagasinLib();
    objet.setNomTable("DIRECTIONMAGASINLIB");

    String[] criteres = {};
    String[] entetes = {"id", "idDirectionLib"};
    PageRecherche pr = new PageRecherche(objet, request, criteres, new String[]{}, 4, entetes, entetes.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    String idMagasin = request.getParameter("id");
    if (idMagasin != null && !idMagasin.isEmpty()) {
        pr.setAWhere(" and idMagasin = '" + idMagasin + "'");
    }

    pr.creerObjetPage(entetes, null);
    String[] liens = {pr.getLien() + "?but=magasin/directionMagasin-saisie.jsp&acte=update"};
    pr.getTableau().setLien(liens);
    pr.getTableau().setColonneLien(new String[]{"id"});
    pr.getTableau().setAttLien(new String[]{"id"});
    pr.getTableau().setLibelleAffiche(new String[]{"Id", "Direction"});
%>
<div class="box-body">
    <% if (pr.getTableau().getHtml() != null) { %>
        <%= pr.getTableau().getHtml() %>
    <% } else { %>
        <center><h4>Aucune direction trouv&eacute;e</h4></center>
    <% } %>
</div>
<% } catch (Exception e) {
    e.printStackTrace();
%>
<script>alert('<%= e.getMessage() %>'); history.back();</script>
<% } %>
