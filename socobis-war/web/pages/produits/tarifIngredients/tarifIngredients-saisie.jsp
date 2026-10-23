<%@ page import="user.UserEJB" %>
<%@ page import="produits.TarifIngredients" %>
<%@ page import="affichage.PageInsert" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Liste" %>
<%@ page import="produits.TarifIngredientsLib" %>
<%@ page import="produits.Ingredients" %>
<%@ page import="produits.IngredientsLib" %><%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 19/09/2025
  Time: 09:39
  To change this template use File | Settings | File Templates.
--%>
<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "produits.TarifIngredients",
                nomtable = "tarif_ingredients",
                apres = "produits/as-ingredients-fiche.jsp",
                titre = "Saisie de tarif ingr&eacute;dient";


        TarifIngredientsLib tarifIngredients = new TarifIngredientsLib();
        PageInsert pi = new PageInsert(tarifIngredients, request, u);
        pi.setLien((String) session.getValue("lien"));

        affichage.Liste[] listes = new affichage.Liste[1];
        TypeObjet typeObjet = new TypeObjet("typeclient");
        listes[0] = new Liste("idTypeClient", typeObjet, "val", "id");

        //TypeObjet unite = new TypeObjet("AS_UNITE");
        //listes[1] = new Liste("unite", unite, "val", "id");

        pi.getFormu().changerEnChamp(listes);

        pi.getFormu().getChamp("idIngredientlib").setLibelle("Ingr&eacute;dient");
        pi.getFormu().getChamp("idIngredient").setLibelle("Ingr&eacute;dient");
        pi.getFormu().getChamp("unitelib").setLibelle("Unit&eacute;");
        pi.getFormu().getChamp("idIngredient").setPageAppelComplete("produits.Ingredients","id","AS_INGREDIENTS");
        pi.getFormu().getChamp("idTypeClient").setLibelle("Type de client");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("prixUnitaire").setLibelle("Prix unitaire");
        pi.getFormu().getChamp("idIngredientLib").setVisible(false);
        pi.getFormu().getChamp("idTypeClientLib").setVisible(false);
        //pi.getFormu().getChamp("unitelib").setVisible(false);

        if(request.getParameter("idIng")!=null && !request.getParameter("idIng").equals("")){
            String id = request.getParameter("idIng");
            IngredientsLib ingredients = (IngredientsLib) new IngredientsLib().getById(id, "AS_INGREDIENTS_LIB2", null);
            apres = apres+"&id="+id;

            pi.getFormu().getChamp("idIngredientLib").setDefaut(ingredients.getLibelle());
            pi.getFormu().getChamp("idIngredientLib").setVisible(true);
            pi.getFormu().getChamp("idIngredientLib").setAutre("readonly");
            pi.getFormu().getChamp("idIngredient").setVisible(false);
            pi.getFormu().getChamp("idIngredient").setDefaut(id);
            pi.getFormu().getChamp("unite").setDefaut(ingredients.getUnite());
            System.err.println("=============================>"+ingredients.getUniteLib());
            System.err.println("=============================>"+ingredients.getUnite());
            pi.getFormu().getChamp("unitelib").setDefaut(ingredients.getUniteLib());
            pi.getFormu().getChamp("unitelib").setAutre("readonly");
            pi.getFormu().getChamp("unite").setVisible(false);
        }

        if(request.getParameter("acte")!=null && request.getParameter("acte").compareToIgnoreCase("update")==0){
            titre = "Modification du tarif ingr&eacute;dient";
        }

        String[] ordre = {"idIngredientLib", "idIngredient"};
        pi.getFormu().setOrdre(ordre);

        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
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

