<%@page import="mg.allosakafo.produits.*"%>
<%@page import="user.*"%> 
<%@ page import="bean.TypeObjet" %>
<%@page import="affichage.*"%>
<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    IngredientsPrecuit  a = new IngredientsPrecuit();
    PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));    
    
    pi.getFormu().getChamp("id1").setPageAppel("choix/ingredientChoix.jsp");
     pi.getFormu().getChamp("id2").setPageAppel("choix/ingredientChoix.jsp");
    pi.getFormu().getChamp("id1").setLibelle("Ingredient Initial");
    pi.getFormu().getChamp("id2").setLibelle("Ingredient final");
	pi.getFormu().getChamp("Quantite1").setLibelle("Quantite Initial");
    pi.getFormu().getChamp("Quantite2").setDefaut("Quantite final");
    
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1>Enregistrer ingredient Precuit</h1>
    <!--  -->
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="starticle" id="starticle">
    <%
        pi.getFormu().makeHtmlInsertTabIndex();
        out.println(pi.getFormu().getHtmlInsert());
    %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="produits/ingredientsPrecuit-saisie.jsp">
    <input name="classe" type="hidden" id="classe" value="mg.allosakafo.produits.IngredientPrecuit">
    </form>
</div>