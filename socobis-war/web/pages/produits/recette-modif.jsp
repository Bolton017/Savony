<%@page import="mg.allosakafo.produits.Recette"%>
<%@page import="user.*"%> 
<%@ page import="bean.TypeObjet" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>

<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        Recette a = new Recette();
        PageUpdate pi = new PageUpdate(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        UserEJB u = (UserEJB) session.getAttribute("u");

        affichage.Champ[] liste = new affichage.Champ[1];
        TypeObjet op = new TypeObjet();
        op.setNomTable("AS_UNITE");
        liste[0] = new Liste("unite", op, "VAL", "id");
        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("id").setVisible(false);

        pi.getFormu().getChamp("idproduits").setLibelle("Produit");
        pi.getFormu().getChamp("idproduits").setPageAppel("choix/listeProduitChoix.jsp");

        pi.getFormu().getChamp("idingredients").setLibelle("Ingredient");
        pi.getFormu().getChamp("idingredients").setPageAppel("choix/listeIngredientChoix.jsp");

        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1 class="box-title">Modification recette</h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="appro" id="appro">
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <div class="row">
            <div class="col-md-11">
                <button class="btn btn-primary pull-right" name="Submit2" type="submit">Modifier</button>
            </div>
            <br><br> 
        </div>
        <input name="acte" type="hidden" id="acte" value="update">
        <input name="bute" type="hidden" id="bute" value="produits/recette-saisie.jsp">
        <input name="classe" type="hidden" id="classe" value="mg.allosakafo.produits.Recette">
    </form>
</div>
<%} catch (Exception ex) {
        ex.printStackTrace();
    }%>   