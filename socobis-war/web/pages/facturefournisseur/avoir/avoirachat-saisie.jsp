<%--
  Created by IntelliJ IDEA.
  User: tsinjoniaina
  Date: 25/09/2026
  Time: 09:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="avoir.AvoirAchat" %>
<%@ page import="avoir.AvoirAchatFille" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Liste" %>
<%@ page import="affichage.Champ" %>
<%@ page import="faturefournisseur.FactureFournisseur" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "avoir.AvoirAchat";
    String classeFille = "avoir.AvoirAchatFille";
    String nomTableFille = "AVOIRACHATFILLE";
    String colonneMere = "idMere";
    String apres = "facturefournisseur/avoir/avoirachat-fiche.jsp";

    AvoirAchat mere = new AvoirAchat();
    mere.setNomTable("AVOIRACHAT");
    AvoirAchatFille fille = new AvoirAchatFille();
    fille.setNomTable("AVOIRACHATFILLE");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie Avoir Achat");

    /*Liste[] liste = new Liste[1];
    Magasin liste0 = new Magasin();
    liste0.setNomTable("MAGASIN2");
    liste[0] = new Liste("idMagasin",liste0,"val","id");
    pi.getFormu().changerEnChamp(liste);*/

    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
    pi.getFormu().getChamp("idFournisseur").setLibelle("Fournisseur");
    pi.getFormu().getChamp("idFournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","fournisseur","echeance;taxe","echeance;taxe");
    pi.getFormu().getChamp("idFournisseur").setPageAppelInsert("fournisseur/fournisseur-saisie.jsp","idFournisseur;idFournisseurlibelle","id;nom");
    pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pi.getFormu().getChamp("idMagasin").setVisible(false);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idFacture").setVisible(false);

    Liste[] listeFille = new Liste[1];
    TypeObjet listeFille0 = new TypeObjet();
    listeFille0.setNomTable("DEVISE");
    listeFille[0] = new Liste("idDevise",listeFille0,"val","id");
    pi.getFormufle().changerEnChamp(listeFille);

    Champ.setDefaut(pi.getFormufle().getChampMulitple("idDevise").getListeChamp(),"AR");

    String idFactureFournisseur = request.getParameter("idFactureFournisseur");
    if(idFactureFournisseur!=null && !idFactureFournisseur.equals("")){
        FactureFournisseur f = new FactureFournisseur();
        f.setId(idFactureFournisseur);

        AvoirAchat a = f.genererAvoirAchatMereFille(null);
        pi.getFormu().setDefaut(a);
        AvoirAchatFille[] af = (AvoirAchatFille[]) a.getFille();
        pi.setDefautFille(af);
    }

    pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTOACHAT_CPL","pu;taux;compte_achat;compte_achat;libelle","pu;tauxDeChange;compte;comptelibelle;designation");
    affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampFille("idProduit"),"produits/as-ingredients-saisie.jsp","id;libelle");
    pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("pu_0").setLibelle("Prix Unitaire");
    pi.getFormufle().getChamp("remise_0").setLibelle("Remise(%)");
    pi.getFormufle().getChamp("tva_0").setLibelle("Tva(%)");
    pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
    pi.getFormufle().getChamp("taux_0").setLibelle("Taux De Change");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idMere").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("idFactureDetails").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);
    Champ.setAutre(pi.getFormufle().getChampFille("pu"),"onchange='calculerMontantAvoir()'");
    Champ.setAutre(pi.getFormufle().getChampFille("qte"),"onchange='calculerMontantAvoir()'");
    Champ.setAutre(pi.getFormufle().getChampFille("tva"),"onchange='calculerMontantAvoir()'");
    Champ.setAutre(pi.getFormufle().getChampFille("remise"),"onchange='calculerMontantAvoir()'");

    String[] ordre = {"daty", "idFournisseur", "designation", "remarque", "idMagasin"};
    pi.getFormu().setOrdre(ordre);

    String[] colOrdre = {"id","idProduit","designation","qte","pu","remise","tva","idDevise","taux", "idMere","idFactureDetails"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification de l'Avoir Achat");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <div class="col-md-12 nopadding" >
            <div class="col-md-12 cardradius">
                <h3 class="fontinter m-0" >Total  : <span id="montanttotal">0</span><span id="deviseLibelle"> Ar</span></h3>
            </div>
        </div>
        <%
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomtable" value=<%=nomTableFille%>>
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>
<script>
    function cleanNumber(val) {
        if (!val) return 0;
        return parseFloat(
            val
                .toString()
                .replace(/&nbsp;/g, "")   // retire le code HTML
                .replace(/\u00A0/g, "")   // retire espace insécable réel
                .replace(/\s/g, "")       // retire tous les autres espaces
                .replace(",", ".")        // virgule → point
        ) || 0;
    }
    function calculerMontantAvoir() {
        var puList = document.querySelectorAll('input[id^="pu_"]');
        let montantTtc = 0;
        puList.forEach(input => {
            let id = input.id.split("_")[1];
            let pu = cleanNumber(document.getElementById("pu_" + id)?.value);
            let qte = cleanNumber(document.getElementById("qte_" + id)?.value);
            let tva = cleanNumber(document.getElementById("tva_" + id)?.value);
            let remise = cleanNumber(document.getElementById("remise_" + id)?.value);
            let montantHt = pu * qte;
            let montantRemise = montantHt * (remise / 100);
            let montantHtNet = montantHt - montantRemise;
            let montantTva = montantHtNet * (tva / 100);
            montantTtc += (montantHtNet + montantTva);
        });
        document.getElementById("montanttotal").innerHTML = montantTtc.toLocaleString('fr-FR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }
    $(document).ready(function () {
        calculerMontantAvoir();
    });
</script>
<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>