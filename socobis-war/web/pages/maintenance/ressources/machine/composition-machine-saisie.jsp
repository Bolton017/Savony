
<%@page import="maintenance.ressources.RecetteMaintenance"%>
<%@page import="user.*"%> 
<%@ page import="bean.TypeObjet" %>
<%@page import="affichage.*"%>
<%
    try {

        String autreparsley = "data-parsley-range='[8, 40]' required";

        RecetteMaintenance a = new RecetteMaintenance();
        PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));

        affichage.Champ[] liste = new affichage.Champ[1];

        TypeObjet op = new TypeObjet();
        op.setNomTable("AS_UNITE");
        liste[0] = new Liste("unite", op, "VAL", "id");
        
        pi.getFormu().changerEnChamp(liste);

        if (request.getParameter("idproduit") != null ) {
            pi.getFormu().getChamp("idproduits").setValeur("" + request.getParameter("idproduit"));
        }
        
        pi.getFormu().getChamp("idproduits").setLibelle("Machine");
        pi.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
        pi.getFormu().getChamp("quantite").setLibelle("Quantit&eacute;");
        pi.getFormu().getChamp("uniteLib").setLibelle("Unit&eacute; libell&eacute;");
        pi.getFormu().getChamp("idproduits").setPageAppelComplete("produits.IngredientsLib", "id","AS_INGREDIENTS_LIB");
        pi.getFormu().getChamp("idproduits").setAutre("readonly");
        //pi.getFormu().getChamp("idproduits").setPageAppel("choix/listeProduitChoix.jsp");
        pi.getFormu().getChamp("idProduitsLib").setVisible(false);
        pi.getFormu().getChamp("idIngredientsLib").setVisible(false);
        pi.getFormu().getChamp("idIngredientsMaintenance").setVisible(false);
        pi.getFormu().getChamp("idingredients").setLibelle("Composant");
        pi.getFormu().getChamp("idingredients").setPageAppelComplete("produits.IngredientsLib", "id","AS_INGREDIENTS_LIB");
        //pi.getFormu().getChamp("idingredients").setPageAppel("choix/listeIngredientChoix.jsp");

        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1>Composition machine</h1>
    <!--  -->
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="starticle" id="starticle">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="maintenance/ressources/machine/composition-machine-saisie.jsp">
        <input name="classe" type="hidden" id="classe" value="produits.Recette">
    </form>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>