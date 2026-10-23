<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@page import="faturefournisseur.*"%>
<%@ page import="magasin.Magasin" %>
<%@ page import="produits.CategorieIngredient" %>
<%@ page import="maintenance.travaux.TravauxCpl" %>
<%@ page import="affichage.Champ" %>
<%@ page import="maintenance.utils.ConstanteMaintenance" %>
<%@ page import="produits.IngredientsLibWithStock" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="budget.UtilisateurService" %>
<%@ page import="prevision.Service" %>
<%@ page import="utils.ConstanteSavonnerie" %>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        DmdAchat mere = new DmdAchat();
        DmdAchatFille fille = new DmdAchatFille();
        int nombreLigne = 10;
        String idcarte = request.getParameter("idcarte");
        IngredientsLibWithStock carte = null;
        if(idcarte!=null&&idcarte.compareToIgnoreCase("")!=0){
            Connection c = null;
            carte = (IngredientsLibWithStock) new IngredientsLibWithStock().getById(idcarte,"as_ingredients_lib_with_stock",c);
            nombreLigne = 1;
        }
        String defautCategorie = ConstanteSavonnerie.CATEGORIE_MATIERE_PREMIERE;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));

        Liste[] listes = new Liste[4];
        Magasin magasin = new Magasin();
        magasin.setNomTable("MAGASIN2");
        listes[0] = new Liste("idMagasin", magasin, "val", "id");
        CategorieIngredient categorieIngredient = new CategorieIngredient();
        categorieIngredient.setNomTable("CATEGORIEINGREDIENTLIB_ACHT");
        listes[1] = new Liste("idCategorie", categorieIngredient, "val", "id");
        Service service = new Service();
        listes[2] = new Liste("destinataire", service, "libelle", "compte");
        listes[3] = new Liste("idPriorite", new TypeObjet("PRIORITEDMDACHAT"), "val", "id");

        pi.getFormu().changerEnChamp(listes);

        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("daty").setAutre("readonly onclick=\"return false\" style=\"pointer-events:none;\"");
        pi.getFormu().getChamp("fournisseur").setLibelle("Fournisseur");
        pi.getFormu().getChamp("fournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","Fournisseur");
        pi.getFormu().getChamp("fournisseur").setPageAppelInsert("fournisseur/fournisseur-saisie.jsp","fournisseur;fournisseurlibelle","id;nom");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idPriorite").setLibelle("Priorit&eacute;");
        pi.getFormu().getChamp("idPriorite").setDefaut(ConstanteSavonnerie.PRIORITE_NORMAL);
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("dateLimite").setLibelle("Date limite de livraison");
        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pi.getFormu().getChamp("echeance").setLibelle("&Eacute;ch&eacute;ance");
        pi.getFormu().getChamp("echeance").setAutre("onChange='changerValeur()'");
        pi.getFormu().getChamp("destinataire").setLibelle("D&eacute;partement Cible");
        pi.getFormu().getChamp("idCategorie").setDefaut(defautCategorie);
        UtilisateurService us = new UtilisateurService();
        us.setRefuser(u.getUser().getTuppleID());
        us = us.getUserService(null);
        if (us != null) {
            pi.getFormu().getChamp("service").setDefaut(us.getIdService());
        }
        pi.getFormu().getChamp("service").setVisible(false);
        pi.getFormu().getChamp("dateEcheance").setLibelle("Date d'&eacute;ch&eacute;ance de paiement");
        pi.getFormu().getChamp("dateEcheance").setAutre("onChange='changerEcheance()'");
        pi.getFormu().getChamp("idCategorie").setLibelle("Cat&eacute;gorie");
//        pi.getFormu().getChamp("idMagasin").setAutre("onchange=\"updateFille(event, 'formId')\"");
        pi.getFormu().getChamp("idCategorie").setAutre("onchange=\"updateFille(event, 'formId')\"");
        if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
            String idCategorie = request.getParameter("idCategorie");
            String awhere = "";
            if(!Utilitaire.champNull(idCategorie).isEmpty()){
                awhere += " and idCategorie = '" + idCategorie + "'";
            }
            //affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"stock.MvtStockEntreeAvecReste","idProduit","V_ETATSTOCK_ENTREE_DMDACHAT","idProduitLib;pu;quantite","designation;pu;qtestock",con);
            Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","idproduit","AS_INGREDIENTS_LIB","id;libelle;pu;unite","idproduit;designation;pu;unite",awhere);
        } else {
            String awhere = " and idCategorie = '" + defautCategorie + "'";
            Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","idproduit","AS_INGREDIENTS_LIB","id;libelle;pu;unite","idproduit;designation;pu;unite",awhere);
        }
//        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","idproduit","AS_INGREDIENTS_LIB","id;libelle;pu","idproduit;designation;pu");
        affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampFille("idProduit"),"produits/as-ingredients-saisie.jsp","id;libelle");
        //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("unite"),"annexe.Unite","id","AS_UNITE","","");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("idproduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("qtestock_0").setLibelle("Quantit&eacute; en stock");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix Unitaire");
        pi.getFormufle().getChamp("unite_0").setLibelle("Unit&eacute;");
        pi.getFormufle().getChamp("unite_0").setAutre("readonly");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
       // pi.getFormufle().getChamp("qtestock").setAutre("readonly");
        for(int i=0; i<pi.getNombreLigne(); i++){
           //pi.getFormufle().getChamp("qtestock_" + i).setAutre("readonly");
           pi.getFormufle().getChamp("unite_"+i).setAutre("readonly");
       }

        String[] orderFille = new String[] {"id", "idproduit", "designation", "quantite", "unite", "pu", "remarque"};

        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("idmere").setVisible(false);
        //pi.getFormufle().getChampMulitple("pu").setVisible(false);
        pi.getFormufle().getChampMulitple("qtestock").setVisible(false);
        pi.getFormufle().getChampMulitple("tva").setVisible(false);
        pi.getFormufle().getChampMulitple("quantite").setAutre("onChange='calculerMontant()'");
        pi.getFormufle().getChampMulitple("pu").setAutre("onChange='calculerMontant()'");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("quantite"),"0");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("tva"),"0");

        if(carte!=null) {
            affichage.Champ.setDefaut(pi.getFormufle().getChampMulitple("idproduit").getListeChamp(), carte.getId());
            affichage.Champ.setDefaut(pi.getFormufle().getChampMulitple("designation").getListeChamp(), carte.getLibelle());
            affichage.Champ.setDefaut(pi.getFormufle().getChampMulitple("pu").getListeChamp(), carte.getPu()+"");
            affichage.Champ.setDefaut(pi.getFormufle().getChampMulitple("unite").getListeChamp(), carte.getUnite());
        }

        String titre = "Saisie demande d'achat";

        String idTravaux = request.getParameter("idTravaux");
        if(idTravaux!=null && !idTravaux.equals("")){
            titre = "Demande de service externe";
            TravauxCpl[] travauxCpls = (TravauxCpl[]) CGenUtil.rechercher(new TravauxCpl(), null, null, " and id = '"+idTravaux+"'");
            if(travauxCpls.length!=0){
                Champ.setVisible(pi.getFormufle().getChampFille("qtestock"), false);
                affichage.Champ.setAutre(pi.getFormufle().getChampFille("idproduit"),"readonly");
                pi.getFormufle().getChamp("quantite_0").setDefaut("1");
                pi.getFormu().getChamp("idObjet").setDefaut(idTravaux);
                pi.getFormu().getChamp("dateLimite").setDefaut(Utilitaire.datetostring(travauxCpls[0].getBesoin()));
                affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","idproduit","AS_INGREDIENTS_LIB","id;libelle;pu;unite","idproduit;designation;pu;unite");
                pi.getFormufle().getChamp("idproduit_0").setDefaut(ConstanteMaintenance.produitServiceExterne);
                titre = "Demande de service externe";
                pi.setNombreLigne(1);
            }
        }else {
            //affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampFille("idproduit"),"annexe/produit/produit-saisie.jsp","id;val");
            //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"stock.MvtStockEntreeAvecReste","idproduit","V_ETATSTOCK_ENTREE_DMDACHAT","idProduitLib;pu;quantite","designation;pu;qtestock");
            affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","idproduit","AS_INGREDIENTS_LIB","id;libelle;pu;unite","idproduit;designation;pu;unite");
        }

        pi.getFormu().getChamp("idObjet").setVisible(false);

        pi.getFormufle().setColOrdre(orderFille);
        pi.preparerDataFormu();

        String classeMere = "faturefournisseur.DmdAchat";
        String classeFille = "faturefournisseur.DmdAchatFille";
        String butApresPost = "facturefournisseur/dmdachat/dmdachat-fiche.jsp";
        String colonneMere = "idmere";

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
        System.out.println("Titre = "+titre);
%>
<div class="content-wrapper">
    <h1><%= titre %></h1>
    <div class="box-body">
        <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
            <%
                out.println(pi.getFormu().getHtmlInsert());
            %>
            <div class="col-md-12 nopadding" >
                <div class="col-md-12 cardradius">
                    <h3 class="fontinter" style="background: white;padding: 16px;margin-top: 10px;border-radius: 16px;" >Total  : <span id="montanttotal">0</span> Ar</h3>
                </div>
            </div>
            <div id="butfillejsp">
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>

            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
            <input name="nomtable" type="hidden" id="nomtable" value="DMDACHATFILLE">
            </div>
        </form>
    </div>
</div>
</div>
<script>
    $(document).ready(function () {
        var lignes = <%=pi.getNombreLigne()%>
        for (let i = 0; i < lignes; i++) {
            calculerMontant(i);
        }
    });

    function parseNombre(valeur) {
        if (valeur === null || valeur === undefined || valeur === '') {
            return 0;
        }
        return parseFloat(
            valeur.toString()
                .replace(/[\s\u00A0\u202F]/g, '') // enlève espace, espace insécable, espace fine
                .replace(',', '.')               // virgule décimale -> point
        );
    }

    function calculerMontant() {
        var val = 0;
        $('input[id^="quantite_"]').each(function() {
            var idPu = $(this).attr('id').replace("quantite", "pu");
            var quantite = parseNombre($(this).val());
            var pu = parseNombre($("#" + idPu).val());
            if (!isNaN(quantite) && !isNaN(pu)) {
                val += quantite * pu;
            }
        });
        $("#montanttotal").html(
            val.toLocaleString('fr-FR', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            })
        );
    }

    function sanitizeNumber(val) {
        var n = parseFloat(val);
        return isNaN(n) ? 0 : n;
    }

    function changerValeur() {
        const champ = document.getElementById("echeance"); 
        const champDaty = document.getElementById("dateEcheance");

        if (!champ || !champDaty) return;  
        const today = new Date();
        const date = new Date(today.getFullYear(), today.getMonth(), today.getDate());

        if (isNaN(date.getTime())) {
            alert("Date invalide !");
            return;
        }
        const nbJours = sanitizeNumber(champ.value);
        date.setDate(date.getDate() + nbJours);

        const formattedDate = [
            String(date.getDate()).padStart(2, '0'),
            String(date.getMonth() + 1).padStart(2, '0'),
            date.getFullYear()
        ].join("/");

        champDaty.value = formattedDate;
        champ.dispatchEvent(new Event("input"));
    }
    function changerEcheance() {
    const champEcheance = document.getElementById("echeance");
    const champDateEcheance = document.getElementById("dateEcheance");

    if (!champEcheance || !champDateEcheance || !champDateEcheance.value)
        return;

    
    const today = new Date();
    const dateDepart = new Date(
        today.getFullYear(),
        today.getMonth(),
        today.getDate()
    );

    
    const tab = champDateEcheance.value.split("/");
    if (tab.length !== 3) return;

    const dateFin = new Date(
        parseInt(tab[2]),
        parseInt(tab[1]) - 1,
        parseInt(tab[0])
    );

    if (isNaN(dateFin.getTime())) return;

    
    const diff = Math.round(
        (dateFin - dateDepart) / (1000 * 60 * 60 * 24)
    );

    champEcheance.value = diff;
    champEcheance.dispatchEvent(new Event("input"));
}

</script>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
