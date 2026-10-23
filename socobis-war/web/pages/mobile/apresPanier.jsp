<%@ page import="affichage.PageInsert" %>
<%@ page import="panier.Panier" %>
<%@ page import="user.UserEJB" %>
<%@ page import="produits.IngredientVente" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="bean.CGenUtil" %>
<html>
<% try {
    String lien = (String) session.getAttribute("lien");
    UserEJB u = (UserEJB) session.getAttribute("u");
    String bute = request.getParameter("bute");
    String acte = request.getParameter("acte");
    String idClient = request.getParameter("idClient");

    if (acte.equalsIgnoreCase("insert")) {
        IngredientVente ing = new IngredientVente();
        ing.setNomTable("AS_INGREDIENT_VENTE_LIB_PRX");
        PageInsert pi = new PageInsert(ing,request);
        ing = (IngredientVente) pi.getObjectAvecValeur();

        String qteAjoutPanier = pi.getParamSansNull("qteAjoutPanier");
        Panier panier = ing.toPanier();
        panier.setIdClient(idClient);
        panier.setQte(Utilitaire.stringToDouble(qteAjoutPanier));
        u.createObject(panier);
    }
    if (acte.equalsIgnoreCase("cancel")) {
        Panier panier = new Panier();
        panier.setId(request.getParameter("id"));
        u.annulerObject(panier);
    }
    if (acte.equalsIgnoreCase("annulerMultiple")) {
        String[] ids = request.getParameterValues("ids");
        if (ids == null || ids.length == 0) {
            throw new Exception("Aucune ligne de panier à annuler");
        }
        u.annulerObjectMultiple(new Panier(), ids);
    }
    if (acte.equalsIgnoreCase("validerMultiple")) {
        String[] ids = request.getParameterValues("ids");
        if (ids == null || ids.length == 0) {
            throw new Exception("Aucune ligne de panier à valider");
        }
        String aWhere = " and id in ("+Utilitaire.tabToString(ids, "'", ",")+" ) order by id desc";
        Panier[] paniers = (Panier[]) CGenUtil.rechercher(new Panier(),null,null,null,aWhere);
        Panier panier = new Panier();
        panier.setIdClient(idClient);
        panier.validerObjectMultiple(u.getUser().getTuppleID(),null,paniers);
    }
    if (acte.equalsIgnoreCase("updateMultiple")) {
        String[] ids = request.getParameterValues("ids");
        if (ids == null || ids.length == 0) {
            throw new Exception("Aucune ligne de panier à modifier");
        }
        String aWhere = " and id in ("+Utilitaire.tabToString(ids, "'", ",")+" ) order by id desc";
        Panier[] paniers = (Panier[]) CGenUtil.rechercher(new Panier(),null,null,null,aWhere);
        String[] qtes = request.getParameterValues("qtes");
        for (int i = 0; i < paniers.length; i++) {
            Panier p = paniers[i];
            p.setMode("modif");
            p.setQte(Utilitaire.stringToDouble(qtes[i]));
        }
        u.updateObjectMultiple(paniers);
    }
%>
<script> document.location.replace("<%=lien%>?but=<%=bute%>&idClient=<%=idClient%>");</script>
<% } catch (Exception ex) {
    ex.printStackTrace(); %>
<script>alert("<%=ex.getMessage()%>"); history.back();</script>
<% return; } %>
</html>



