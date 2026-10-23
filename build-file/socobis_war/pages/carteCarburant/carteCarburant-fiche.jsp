<%@page import="produits.*" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="utils.ConstanteSocobis" %>
<%
    UserEJB u = (user.UserEJB) session.getValue("u");
    String lien = (String) session.getValue("lien");
    IngredientsLibWithStock a = new IngredientsLibWithStock();
    DecimalFormat df = new DecimalFormat("0.##################");
    PageConsulte pc = pc = new PageConsulte(a, request, u);

    String isDispo = pc.getChampByName("etatlib").getValeur();
    pc.getChampByName("libelle").setLibelle("Num&eacute;ro de carte");
    pc.getChampByName("reste").setLibelle("Solde carte carburant");
    pc.getChampByName("entree").setVisible(false);
    pc.getChampByName("sortie").setVisible(false);
    pc.getChampByName("unite").setVisible(false);
    pc.getChampByName("typestock").setVisible(false);
    pc.getChampByName("composelib").setVisible(false);
    pc.getChampByName("REFQUALIFICATIONLIB").setVisible(false);
    pc.getChampByName("REFPOSTLIB").setVisible(false);
    pc.getChampByName("pu").setVisible(false);
    pc.getChampByName("quantiteparpack").setVisible(false);
    pc.getChampByName("bienOuServ").setVisible(false);
    pc.getChampByName("categorieingredient").setVisible(false);
    pc.getChampByName("etatlib").setVisible(false);
    pc.getChampByName("pv").setVisible(false);
    pc.getChampByName("idFamilleLib").setVisible(false);
    pc.getChampByName("compte_vente").setVisible(false);
    pc.getChampByName("compte_achat").setVisible(false);
    pc.getChampByName("tva").setVisible(false);
    pc.getChampByName("idFournisseur").setVisible(false);
    pc.getChampByName("bienOuServ").setVisible(false);
    pc.getChampByName("REFPOSTLIB").setVisible(false);
    pc.getChampByName("REFQUALIFICATIONLIB").setVisible(false);
    pc.getChampByName("photo").setVisible(false);
    pc.getChampByName("daty").setVisible(false);
    pc.getChampByName("calorie").setVisible(false);
    pc.getChampByName("REFQUALIFICATION").setVisible(false);
    pc.getChampByName("REFPOST").setVisible(false);
    pc.getChampByName("idcategorieingredient").setVisible(false);
    pc.getChampByName("idcategorie").setVisible(false);
    pc.getChampByName("compose").setVisible(false);
    pc.getChampByName("parfums").setVisible(false);
    pc.getChampByName("seuil").setVisible(false);
    pc.getChampByName("actif").setVisible(false);

    pc.setTitre("Consultation composant");
    Ingredients base = (Ingredients) (pc.getBase());
    RecetteLib[] liste = base.getRecette(null, null);
    Recette[] listeBase = base.decomposerBase(null);
    RecetteLib[] listerecette = base.getRecetteIngredient(null, null);
    double montantTotal = AdminGen.calculSommeDouble(listeBase, "qtetotal");
    if (base.getCompose() > 0) pc.getChampByName("pu").setValeurDirect(Utilitaire.formaterAr(montantTotal));
    if (base.getCompose() == 0) pc.getChampByName("pu").setValeurDirect(Utilitaire.formaterAr(base.getPu()));

    boolean isDG = false;
    if (u.getUser().isSuperUser()) isDG = true;

    try {
        // insertion recette
        Recette proc = new Recette();
        PageInsert pi = new PageInsert(proc, request, u);
        String id = pc.getBase().getTuppleID();
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("idProduits").setLibelle("Produits");
        pi.getFormu().getChamp("idProduits").setAutre("readonly");
        pi.getFormu().getChamp("idproduits").setDefaut(request.getParameter("id"));
        pi.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
        pi.getFormu().getChamp("unite").setAutre("readonly");
        pi.getFormu().getChamp("idingredients").setLibelle("Ingr&eacute;dient");
        pi.getFormu().getChamp("idingredients").setPageAppelComplete("produits.IngredientsLib", "id", "as_ingredients_lib", "unite", "unite");
        pi.getFormu().getChamp("quantite").setLibelle("Quantit&eacute;");

        pi.getFormu().getChamp("idProduits").setAutre("readonly");
        pi.getFormu().setNbColonne(2);

        pi.preparerDataFormu();
        String pageActuel = "carteCarburant/carteCarburant-fiche.jsp";
        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/mvtfille-liste", "");
        map.put("inc/mvtfilleRecharge-liste", "");
        map.put("inc/mvtfilleSortie-liste", "");

        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/mvtfille-liste";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
%>
<style>
    .col-md-12.cardradius {
        border: none;
        border-top: none !important;
        padding: 0;
        margin-bottom: 20px;
    }

</style>
<div class="content-wrapper onepage-container">
    <h1 class="main-title"><a href="<%=(String) session.getValue("lien")%>?but=produits/as-ingredients-liste.jsp"><i
        class="fa fa-angle-left"></i></a><%=pc.getTitre()%>
    </h1>
    <div class="row m-0">
        <div class="col-md-12 mb-5" style="padding-bottom: 0;padding-top: 10px;">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <a class="btn btn-secondary pull-right" href="<%=(String) session.getValue("lien") + "?but=carteCarburant/carte-debiter.jsp&idcarte=" + request.getParameter("id")%>" style="margin-right: 10px">D&eacute;biter</a>
                        <a class="btn btn-secondary pull-right" href="<%=(String) session.getValue("lien") + "?but=facturefournisseur/dmdachat/dmdachat-saisie.jsp&idcarte=" + request.getParameter("id")%>" style="margin-right: 10px">Recharger</a>
                        <a class="btn btn-secondary pull-left" href="<%=(String) session.getValue("lien") + "?but=carteCarburant/carteCarburant-saisie.jsp&id=" + request.getParameter("id")+"&acte=update"%>" style="margin-right: 10px">Modifier</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row m-0" style="margin-top: 25px">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="<%=map.get("inc/mvtfille-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/mvtfille-liste">Historique</a></li>
                    <li class="<%=map.get("inc/mvtfilleRecharge-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/mvtfilleRecharge-liste">Recharge</a></li>
                    <li class="<%=map.get("inc/mvtfilleSortie-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/mvtfilleSortie-liste">Sortie</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>
        </div>
    </div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<script>
    const secondRow = document.querySelectorAll('.row')[3];
    const colMd3Divs = secondRow.querySelectorAll('div.col-md-3');
    colMd3Divs.forEach(div => {
        div.classList.remove('col-md-3');
        div.classList.add('col-md-1');
    });
    const colMd6Div = secondRow.querySelector('div.col-md-6');
    if (colMd6Div) {
        colMd6Div.classList.remove('col-md-6');
        colMd6Div.classList.add('col-md-12');
    }
</script>