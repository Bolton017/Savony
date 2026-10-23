<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 31/07/2025
  Time: 11:30
  To change this template use File | Settings | File Templates.
--%>
<%@page import="magasin.Magasin"%>
<%@page import="annexe.Categorie"%>
<%@page import="annexe.Point"%>
<%@page import="demande.DemandeTransfertFille"%>
<%@page import="demande.DemandeTransfert"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@ page import="fabrication.Of" %>
<%@ page import="java.lang.reflect.Type" %>
<%@ page import="fabrication.Fabrication" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="magasin.DirectionMagasinLib" %>
<%@ page import="utils.ConstanteSavonnerie" %>
<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = u = (UserEJB) session.getValue("u");
        utilisateursocobis.UtilisateurStation user = new utilisateursocobis.UtilisateurStation();
        user.setTuppleId(u.getUser().getTuppleID());
        user = user.getUtilisateurByrefuser();
        String classeMere = "demande.DemandeTransfert",
                classeFille = "demande.DemandeTransfertFille",
                titre = "Saisie d'une demande de transfert",
                redirection = "demande/demandetransfert-fiche.jsp";
        String colonneMere = "idDemandeTransfert";
        int taille = 10;
        String idOf = request.getParameter("idOf");

        DemandeTransfert preRempli = null;
        if (idOf != null && !idOf.isEmpty()) {
            Of of = new Of();
            of.setId(idOf);
            if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
                String categorie = request.getParameter("categorieingredient");
                preRempli = of.genererDemandeTransfert(idOf,categorie,null);
            }else{
                preRempli = of.genererDemandeTransfert(idOf,null,null);
            }
            if(preRempli != null && preRempli.getFille() != null && preRempli.getFille().length > 0) {
                taille = preRempli.getFille().length >=10 ? (preRempli.getFille().length + 3) : 10;
            }

        }
        String acte = request.getParameter("acte");
        if(acte !=null && !acte.isEmpty() && acte.compareTo("update")==0){
            titre = "Modification d'une demande de transfert";
        }
        String idFab = request.getParameter("idFab");
        if (idFab != null && !idFab.isEmpty()) {
            Fabrication fabrication = new Fabrication();
            fabrication.setId(idFab);
            if (request.getParameter("categorieingredient") != null && !request.getParameter("categorieingredient").isEmpty()) {
                String idcat = request.getParameter("categorieingredient");
                preRempli = fabrication.genererDemandeTransfertFab(idFab, idcat, null);
            } else {
                preRempli = fabrication.genererDemandeTransfertFab(idFab, null, null);
            }
        }

        DemandeTransfert mere = new DemandeTransfert();
        mere.setNomTable("demandetransfert");
        DemandeTransfertFille fille = new DemandeTransfertFille();
        fille.setNomTable("demandetransfertfille");
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("etat").setVisible(false);
        String awhereproduit = "";

        if(user.getService() != null && !user.getService().getDepartement().equals(ConstanteSavonnerie.DEPARTEMENT_DG)) {
            awhereproduit = "and idDirection = '" + user.getService().getDepartement() + "'";
        }
        Liste[] liste = new Liste[3];
        DirectionMagasinLib m1 = new DirectionMagasinLib();

        Magasin m2 = new Magasin();
        m2.setNomTable("magasin2");

        TypeObjet type = new TypeObjet();
        type.setNomTable("categorieingredient");


        liste[0] = new Liste("idMagasinDepart", m1, "idMagasinLib", "idmagasin",awhereproduit);
        liste[1] = new Liste("idMagasinArrive", m2, "val", "id");
        liste[2] = new Liste("categorieingredient", type, "val", "id");
        pi.getFormu().changerEnChamp(liste);

        String[] order = {"daty"};
        pi.getFormu().setOrdre(order);

        pi.getFormu().getChamp("daty").setLibelle("Date de demande");
        pi.getFormu().getChamp("categorieingredient").setLibelle("Cat&eacute;gories d'ingrédients");
        pi.getFormu().getChamp("idMagasinDepart").setDefaut(Point.getDefaultMagasin());
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("idMagasinDepart").setLibelle("Magasin de d&eacute;part");
        pi.getFormu().getChamp("idMagasinArrive").setLibelle("Magasin d'arriv&eacute;e");
        pi.getFormu().getChamp("categorieingredient").setAutre("onchange=\"updateFille(event, 'formId')\"");
        pi.getFormu().getChamp("idOf").setLibelle("Ordre de Fabrication associ&eacute;");
        pi.getFormu().getChamp("idFabrication").setLibelle("Fabrication");
        pi.getFormu().getChamp("idFabrication").setVisible(false);
        pi.getFormu().getChamp("idFabrication").setPageAppelComplete("fabrication.Fabrication","id","FABRICATION");

        pi.getFormu().getChamp("idOf").setPageAppelComplete("fabrication.Of","id","OFAB");
        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("quantite_0").setLibelle("quantit&eacute;");
        pi.getFormufle().getChamp("remarque_0").setLibelle("D&eacute;signation");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","as_ingredients","pu;compte_vente;libelle","pu;compte;remarque");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idsource"),"stock.MvtStockEntreeAvecReste","id","V_ETATSTOCK_ENTREE","pu","pu");
        Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("idSource"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("pu"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("idDemandeTransfert"),false);

        if(preRempli!=null){
            if(preRempli.getFille()!=null){
                pi.setDefautFille(preRempli.getFille());
            }
            pi.getFormu().setDefaut(preRempli);
        }
        pi.preparerDataFormu();

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<div class="content-wrapper" >
    <h1><%=titre%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%

            out.println(pi.getFormu().getHtmlInsert());
        %>
        <div>
            <h3 class="h329pxBold">Détails de la demande de transfert</h3>
        </div>
        <div id="butfillejsp">
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= taille %>">
        </div>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=redirection%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="classefille" value="DemandeTransfertFille">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert("<%=e.getMessage()%>");
    history.back();
</script>
<% }%>

