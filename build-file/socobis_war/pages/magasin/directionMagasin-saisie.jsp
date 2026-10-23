<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="magasin.DirectionMagasin" %>
<%@ page import="user.UserEJB" %>

<% try {
    UserEJB u = (UserEJB) session.getValue("u");
    String mapping = "magasin.DirectionMagasin";
    String nomTable = "directionmagasin";

    DirectionMagasin objet = new DirectionMagasin();
    objet.setNomTable(nomTable);
    PageInsert pi = new PageInsert(objet, request, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie direction magasin");

    String idmagadin = request.getParameter("id");
    if(idmagadin != null ){
        pi.getFormu().getChamp("idMagasin").setDefaut(idmagadin);
    }
    String apres = "magasin/magasin-fiche.jsp?id="+idmagadin;


    Liste[] listes = new Liste[2];
    TypeObjet magasin = new TypeObjet();
    magasin.setNomTable("MAGASIN2");
    listes[0] = new Liste("idMagasin", magasin, "val", "id");

    TypeObjet direction = new TypeObjet();
    direction.setNomTable("departement");
    listes[1] = new Liste("idDirection", direction, "val", "id");
    pi.getFormu().changerEnChamp(listes);

    if (request.getParameter("id") != null) {
        pi.getFormu().getChamp("idMagasin").setDefaut(request.getParameter("id"));
    }

    pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pi.getFormu().getChamp("idDirection").setLibelle("Direction");
    pi.getFormu().setOrdre(new String[]{"idMagasin", "idDirection"});

    String acte = request.getParameter("acte");
    if (acte != null && acte.equalsIgnoreCase("update")) {
        pi.setTitre("Modification direction magasin");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1><%= pi.getTitre() %></h1>
    <form action="<%= pi.getLien() %>?but=apresTarif.jsp" method="post" name="<%= nomTable %>" id="<%= nomTable %>">
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" value="insert">
        <input name="bute" type="hidden" value="<%= apres %>">
        <input name="classe" type="hidden" value="<%= mapping %>">
        <input name="nomtable" type="hidden" value="<%= nomTable %>">
    </form>
</div>

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script>alert('<%= e.getMessage() %>'); history.back();</script>
<% } %>
