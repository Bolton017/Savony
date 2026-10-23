<%@page import="affichage.PageRecherche"%>
<%@ page import="produits.IngredientVente" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="client.ClientLib" %>
<%@ page import="user.UserEJB" %>
<% try{
    IngredientVente t = new IngredientVente();
    t.setNomTable("AS_INGREDIENT_VENTE_LIB_PRX");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"puUniteLib"};
    String idClient = request.getParameter("idClient");
    ClientLib client = null;
    int panier = 0;
    if (!Utilitaire.champNull(idClient).isEmpty()) {
        client = (ClientLib) new ClientLib().getById(idClient,"CLIENTLIBPANIER",null);
    }
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    UserEJB u = (user.UserEJB) session.getAttribute("u");
    String home_page = u.getHome_page();
    pr.setUtilisateur(u);
    if (client != null) {
        pr.setAWhere(" AND IDTYPECLIENT='"+client.getIdTypeClient()+"' and (daty+"+client.getDelai()+") <= SYSDATE ORDER BY daty desc");
        panier = client.getQtePanier();
    }
    String lien = (String) session.getAttribute("lien");
    pr.setLien(lien);
    pr.creerObjetPage(libEntete, null);
    pr.setCssBoxExtraMobile("commande-box");
    pr.setCssTitreExtraMobile("Body14pxSemiBold search-result__title m-0");
    pr.setCssColExtraMobile("Body14pxRegular m-0 price-tag");
    pr.setVisibleColMobile(false);

    pr.setLienAjoutPanier(lien + "?but=mobile/apresPanier.jsp");
    pr.ajouterParamPanier("bute", "mobile/commande-client.jsp");
    pr.ajouterParamPanier("acte", "insert");
    pr.ajouterParamPanier("idClient", idClient);
    String[] colInsertPanier = {"id","prixUnitaire","unite","pu"};
    pr.setColInsertPanier(colInsertPanier);

    pr.setFormatTitre("{id} - {libelle}");
%>

<div class="content-wrapper">
    <div class="mobile__header-container mb-5">
        <div class="mobile__title">
            <a href="javascript:history.back()" class="mobile__back-link" aria-label="Retour">
                <i class="material-symbols-rounded">arrow_back</i>
            </a>
            <a href="<%=lien%>?but=<%=home_page%>" class="mobile__header-logo-link" aria-label="Accueil">
                <img src="${pageContext.request.contextPath}/assets/img/logo-mobile-savonnerie.png" alt="Accueil" class="mobile__header-logo" />
            </a>
            <h1 class="mobile__header-title">Prise de commande</h1>
        </div>
        <div class="mobile__header-actions">
            <a href="<%= lien + "?but=mobile/valider-panier-client.jsp&idClient="+idClient%>" class=""><i class="material-symbols-rounded">shopping_cart</i> </a>
            <span class="mobile__panier-badge"><%=panier%></span>
        </div>
    </div>
    <%=pr.getHtmlSearchMobile()%>
    <%=pr.getHtmlInterfaceMobile()%>
</div>
<% } catch (Exception e) {
    e.printStackTrace();  %>
    <script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();</script>
<% }%>



