<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="magasin.CategorieIngredientMagasin" %>
<%@ page import="affichage.Liste"%>
<%@ page import="bean.TypeObjet" %>
<%@ page import="produits.CategorieIngredient" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "magasin.CategorieIngredientMagasin";
    String nomTable = "CATEGORIEINGREDIENTMAGASIN";
    String apres = "categorieIngredientMagasin/categorieIngredient-fiche.jsp";

    CategorieIngredientMagasin o = new CategorieIngredientMagasin();
    o.setNomTable("CATEGORIEINGREDIENTMAGASIN");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("");

    Liste[] liste = new Liste[2];
    TypeObjet liste0 = new TypeObjet();
    liste0.setNomTable("MAGASINPOINT");
    liste[0] = new Liste("idMagasin",liste0,"val","id");
    CategorieIngredient liste1 = new CategorieIngredient();
    liste1.setNomTable("CATEGORIEINGREDIENT");
    liste[1] = new Liste("idCategorieIngredient",liste1,"val","id");
    pi.getFormu().changerEnChamp(liste);
    if(request.getParameter("id") != null){
        pi.getFormu().getChamp("idMagasin").setDefaut(request.getParameter("id"));
    }

    pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pi.getFormu().getChamp("idCategorieIngredient").setLibelle("Cat&eacute;gorie d'ingr&eacute;dient");
 
    String[] ordre = {"idMagasin","idCategorieIngredient"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

