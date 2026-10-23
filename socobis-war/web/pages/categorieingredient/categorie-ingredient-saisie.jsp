<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 03/04/2025
  Time: 15:01
  To change this template use File | Settings | File Templates.
--%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="produits.CategorieIngredient" %>
<%@ page import="affichage.Champ" %>

<%
  try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "produits.CategorieIngredient",
            nomtable = "CATEGORIEINGREDIENT",
            apres = "categorieingredient/categorie-ingredient-fiche.jsp",
            titre = "Insertion nouvelle cat&eacutegorie d'ingr&eacute;dient";

    CategorieIngredient client = new CategorieIngredient();
    PageInsert pi = new PageInsert(client, request, u);
    pi.setLien((String) session.getValue("lien"));
    Champ[] liste = new Champ[1];
    TypeObjet typecateging = new TypeObjet();
    typecateging.setNomTable("typeCATEGORIEINGREDIENT");
    liste[0] = new Liste("desce", typecateging, "val", "id");
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("val").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("desce").setLibelle("Description");
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
  <h1> <%=titre%></h1>

  <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
    <%
      pi.getFormu().makeHtmlInsertTabIndex();
      out.println(pi.getFormu().getHtmlInsert());
      out.println(pi.getHtmlAddOnPopup());
    %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="<%=apres%>">
    <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
    <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
  </form>
</div>

<%
} catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>