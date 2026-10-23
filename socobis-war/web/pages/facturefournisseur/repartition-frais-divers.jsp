<%@page import="faturefournisseur.FactureFournisseur"%>
<%@page import="faturefournisseur.FFDetailsPerteGain"%>
<%@page import="faturefournisseur.ModePaiement"%>
<%@page import="affichage.PageUpdateMultiple"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.Liste"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@ page import="magasin.Magasin" %>
<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = u = (UserEJB) session.getValue("u");
        String classeMere = "faturefournisseur.FactureFournisseur",
                classeFille = "faturefournisseur.FFDetailsPerteGain",
                titre = "R&eacute;partition Frais Accessoire",
                redirection = "facturefournisseur/facturefournisseur-fiche.jsp";
        String colonneMere = "idFactureFournisseur";

        FactureFournisseur mere = new FactureFournisseur();
        mere.setNomTable("FACTUREFOURNISSEUR_perte");
        FFDetailsPerteGain fille = new FFDetailsPerteGain();
        fille.setNomTable("FFAVECPERTE_FF_IDPG");
        fille.setIdFactureFournisseur(request.getParameter("id"));
        FFDetailsPerteGain[] details = (FFDetailsPerteGain[]) CGenUtil.rechercher(fille, null, null, "");
        int taille = 0 ;
        PageUpdateMultiple pi = new PageUpdateMultiple(mere, fille, details, request, (user.UserEJB) session.getValue("u"), taille);
        pi.setLien((String) session.getValue("lien"));
        Liste[] liste = new Liste[3];
        ModePaiement mp = new ModePaiement();
        liste[0] = new Liste("idModePaiement",mp,"val","id");
        Magasin magasin = new Magasin();
        magasin.setNomTable("magasin");
        liste[1] = new Liste("idMagasin", magasin, "val", "id");
        TypeObjet idDevise = new TypeObjet();
        idDevise.setNomTable("devise");
        liste[2] = new Liste("idDevise", idDevise, "val", "id");

        pi.getFormu().changerEnChamp(liste);
        //pi.getFormu().getChamp("idFournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","FOURNISSEUR");
        // pi.getFormu().getChamp("idFournisseur").setAutre("readonly");
        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pi.getFormu().getChamp("idFournisseur").setLibelle("Fournisseur");
        // pi.getFormu().getChamp("designation").setLibelle("d&eacute;signation");
        pi.getFormu().getChamp("reference").setLibelle("r&eacute;f&eacute;rence");
        pi.getFormu().getChamp("idModePaiement").setLibelle("Mode de paiement");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("idDevise").setLibelle("Devise");
        pi.getFormu().getChamp("DatyPrevu").setLibelle("Date pr&eacute;vu");
        pi.getFormu().getChamp("numero").setVisible(false);
        pi.getFormu().getChamp("typeachat").setVisible(false);
        pi.getFormu().getChamp("idObjet").setVisible(false);
        pi.getFormu().getChamp("idtypefacture").setVisible(false);
        pi.getFormu().getChamp("idRef").setVisible(false);
        pi.getFormu().getChamp("idDmdAchat").setVisible(false);
        pi.getFormu().getChamp("idfactureprincipale").setVisible(false);
        pi.getFormu().getChamp("service").setVisible(false);
        pi.getFormu().getChamp("typeFactureFournisseur").setVisible(false);
        pi.getFormu().getChamp("montantPerteGain").setLibelle("Montant perte gain");
        //griser
        pi.getFormu().getChamp("idMagasin").setAutre("readonly");
        pi.getFormu().getChamp("idFournisseur").setAutre("readonly");
        //pi.getFormu().getChamp("designation").setAutre("readonly");
        pi.getFormu().getChamp("reference").setAutre("readonly");
        pi.getFormu().getChamp("idModePaiement").setAutre("readonly");
        pi.getFormu().getChamp("daty").setAutre("readonly");
        pi.getFormu().getChamp("designation").setAutre("readonly");
        pi.getFormu().getChamp("idDevise").setAutre("readonly");
        pi.getFormu().getChamp("estPrevu").setLibelle("Est Pr&eacute;vu ");
        pi.getFormu().getChamp("estPrevu").setAutre("readonly");
        pi.getFormu().getChamp("DatyPrevu").setAutre("readonly");
        pi.getFormu().getChamp("idFournisseur").setAutre("readonly");
        pi.getFormu().getChamp("montantPerteGain").setAutre("readonly");

        pi.getFormu().getChamp("dateEcheancePaiement").setVisible(false);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idBc").setVisible(false);
        pi.getFormu().getChamp("taux").setVisible(false);
        pi.getFormu().getChamp("devise").setVisible(false);
        pi.getFormu().setOrdre(new String[]{"daty"});

        //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"annexe.ProduitLib","id","PRODUIT_LIB");
        pi.getFormufle().getChamp("idProduit_0").setLibelle("Id Produit");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        pi.getFormufle().getChamp("remises_0").setLibelle("remise");
        pi.getFormufle().getChamp("tauxDeChange_0").setLibelle("Taux de change");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
        pi.getFormufle().getChamp("montantPerteGain_0").setLibelle("Montant perte gain");
        pi.getFormufle().getChamp("libelleProduit_0").setLibelle("Produit");

        for (int i = 0; i < details.length; i++) {
            pi.getFormufle().getChamp("idProduit_" + i).setAutre("readonly");
            pi.getFormufle().getChamp("qte_"+ i).setAutre("readonly");
            pi.getFormufle().getChamp("pu_"+ i).setAutre("readonly");
            pi.getFormufle().getChamp("tva_"+ i).setAutre("readonly");
            pi.getFormufle().getChamp("remises_"+ i).setAutre("readonly");
            pi.getFormufle().getChamp("tauxDeChange_"+ i).setAutre("readonly");
            pi.getFormufle().getChamp("compte_"+ i).setAutre("readonly");
            pi.getFormufle().getChamp("idDevise_"+ i).setAutre("readonly");
            pi.getFormufle().getChamp("libelleProduit_"+ i).setAutre("readonly");
        }

        Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("idbcDetail"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("idFactureFournisseur"),false);
        // Champ.setVisible(pi.getFormufle().getChampFille("qtephysique"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("etat"),false);
        pi.getFormufle().setColOrdre(new String[]{"idProduit", "libelleProduit", "qte", "pu", "remises", "tva", "tauxDeChange", "idDevise", "montantPerteGain", "compte"});
        pi.preparerDataFormu();

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
        double montantTotalPerteGain =0;
%>
<div class="content-wrapper">
    <h1><%=titre%></h1>
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp&id=<%out.print(request.getParameter("id"));%>" method="post" >
        <%

            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <div style="text-align: center;">
        </div>
        <%
            pi.getFormufle().makeHtmlInsertTableauIndex();
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="updateInsert">
        <input name="bute" type="hidden" id="bute" value="<%=redirection%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=details.length%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
        <input name="isPerteGain" type="hidden" id="montantPerteGain" value="O">
        <input name="nomtable" type="hidden" id="nomtable" value="FACTUREFOURNISSEURFILLE">
    </form>
</div>
<script>
    function cocherCheckbox() {
        for (let i = 0; i <=<%=details.length%> ; i++) {
            const checkbox = document.getElementById('checkbox' + i);
            if (checkbox) {
                checkbox.checked = true;
            }
        }
    }
    document.addEventListener("DOMContentLoaded", function() {
        cocherCheckbox();
    });
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
