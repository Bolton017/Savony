<%@page import="affichage.PageUpdateMultiple"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@ page import="inventaire.Inventaire" %>
<%@ page import="produits.Ingredients" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="inventaire.InventaireFille" %>
<%@ page import="affichage.Liste" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="bean.ClassMAPTable" %>
<%
    try {
        UserEJB u = (UserEJB) session.getValue("u");
        String classeMere = "inventaire.Inventaire",
                classeFille = "inventaire.InventaireFille",
                titre = "Inventaire par Cat&eacute;gorie",
                redirection = "inventaire/inventaire-fiche.jsp";
        String colonneMere = "idInventaire";
        int taille = 10;

        ClassMAPTable[] var = (ClassMAPTable[]) session.getAttribute("resultat");

        Inventaire mere = new Inventaire();
        mere.setNomTable("inventaire");

        String idCategorie = request.getParameter("idCategorie");

        Ingredients ing = new Ingredients();
        String id = request.getParameter("id");
        redirection += "&id=" + id;
        Inventaire inv= ing.genererInventaireParCategorie(id, null);

        InventaireFille fille = new InventaireFille();
        InventaireFille[] details = null;
        if (inv != null) {
            details = (InventaireFille[]) inv.getFille();
            taille = details.length>10? details.length + 3 : 10;
        }

        if (details == null) {
            details = new InventaireFille[0];

        }

        int nombreLigne = details.length;
        if (var != null && var.length > 0) {
            nombreLigne = var.length;
            details = new InventaireFille[var.length];
            for (int i = 0; i < var.length; i++) {
                details[i] = new InventaireFille();
                details[i] = (InventaireFille) var[i];
            }
        }

        PageUpdateMultiple pi = new PageUpdateMultiple(mere, fille, details, request, (user.UserEJB) session.getValue("u"), nombreLigne);
        pi.setLien((String) session.getValue("lien"));
        pi.setTailleFille(taille);

        Liste[] liste = new Liste[2];
        Magasin m = new Magasin();
        m.setNomTable("magasinpoint");
        liste[0] = new Liste("idMagasin", m, "val", "id");

        TypeObjet to = new TypeObjet();
        to.setNomTable("categorieingredient");
        liste[1] = new Liste("idCategorie", to, "val", "id");

        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("daty").setLibelle("Date inventaire");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pi.getFormu().getChamp("idCategorie").setLibelle("Categorie");
        pi.getFormu().getChamp("etat").setVisible(false);


        if (details.length != 0) {
            pi.getFormufle().getChamp("idProduit_0").setLibelle("ID Produit");
            pi.getFormufle().getChamp("explication_0").setLibelle("Produit");
            pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
            pi.getFormufle().getChamp("quantiteTheorique_0").setLibelle("Quantit&eacute; th&eacute;orique");
            pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
            Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
            Champ.setVisible(pi.getFormufle().getChampFille("idInventaire"),false);
            Champ.setVisible(pi.getFormufle().getChampFille("idJauge"),false);
            Champ.setVisible(pi.getFormufle().getChampFille("quantiteTheorique"),false);
        }

        pi.getFormufle().setPageActuelle("pages/module.jsp?but=inventaire/inventaire-categorie-saisie2.jsp");
        pi.getFormufle().setClasseFille("inventaire.InventaireFille");

        if (var != null && var.length > 0) {
            pi.setDefautFille(var);
        }
        session.removeAttribute("resultat");

//        pi.getFormu().getChamp("etat").setVisible(false);
//        pi.getFormu().getChamp("idMagasindepart").setPageAppel("choix/choix-magasin.jsp","idMagasin;idMagasinlibelle");
//        pi.getFormu().getChamp("idMagasinarrive").setPageAppel("choix/choix-magasin.jsp","idMagasin;idMagasinlibelle");
//        pi.getFormu().getChamp("idMagasindepart").setLibelle("Magasin Depart");
//        pi.getFormu().getChamp("idMagasinarrive").setLibelle("Magasin Depart");

//
//        for(int i=0; i<pi.getNombreLigne(); i++){
//            pi.getFormufle().getChamp("idProduit_" + i).setPageAppel("choix/stock/etatstock-choix.jsp", "idProduit_" + i + ";idProduitlibelle_" + i);
//            pi.getFormufle().getChamp("idProduit_" + i).setAutre("readonly");
//        }
//
//        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
//        pi.getFormufle().getChamp("quantite_0").setLibelle("quantite");
//
//        Champ.setVisible(pi.getFormufle().getChampFille("idTransfertStock"),false);
//        Champ.setVisible(pi.getFormufle().getChampFille("id"),false);


        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<div class="content-wrapper">
    <h1><%=titre%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp&id=<%out.print(request.getParameter("id"));%>" method="post">
        <%

            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <div style="text-align: center;">
            <h2>Modification</h2>
        </div>
        <%
            pi.getFormufle().makeHtmlInsertTableauIndex();
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insertFille">
        <input name="bute" type="hidden" id="bute" value="<%=redirection%>">
        <input name="idMere" type="hidden" id="idMere" value="<%=id%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
        <input name="nomtable" type="hidden" id="classefille" value="inventaireFille">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
