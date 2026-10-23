<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="caisse.Devise" %>
<%@ page import="annexe.Point" %>
<%@ page import="faturefournisseur.*" %>
<%@ page import="rapprochement.ReleverDetailCpl" %>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        FactureFournisseur mere = new FactureFournisseur();
        FactureFournisseurDetails fille = new FactureFournisseurDetails();
        fille.setNomTable("FactureFournisseurFille");

        FactureFournisseur fournisseur = null;
        FactureFournisseurDetails[] details = null;

        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));

        Liste[] liste = new Liste[5];
        Point mag = new Point();
        mag.setNomTable("point");
        liste[0] = new Liste("idMagasin",mag,"val","id");
        Devise d = new Devise();
        liste[1] = new Liste("idDevise",d,"val","id");

        liste[1].setDefaut("AR");
        ModePaiement mp = new ModePaiement();
        liste[2] = new Liste("idModePaiement",mp,"val","id");

        liste[3] = new Liste("estPrevu");
        liste[3].makeListeOuiNon();

        TypeObjet typeachat = new TypeObjet();
        typeachat.setNomTable("TYPE_FACTURE");
        liste[4] = new Liste("idtypefacture", typeachat, "val", "id");
        //TypeObjet typeContrat = new TypeObjet();
        //typeContrat.setNomTable("BANQUE_COMPTA");
        //liste[4]=new Liste("reference",typeContrat,"val","ID");
        //liste[4].setLibelle("Banque");

        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("idModePaiement").setLibelle("Mode de paiement");

        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("idFournisseur").setLibelle("Fournisseur");
        pi.getFormu().getChamp("idFournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","fournisseur");
        pi.getFormu().getChamp("idFournisseur").setPageAppelInsert("fournisseur/fournisseur-saisie.jsp","idFournisseur;idFournisseurlibelle","id;nom");

        String[] ordre={"daty"};
        pi.getFormu().setOrdre(ordre);
        String ac_affiche_val = "null";
        String ac_valeur_val = "id";
        String ac_colFiltre_val = "null";
        String ac_nomTable_val = "ST_INGREDIENTSAUTOVENTE_CPL";
        String ac_classe_val = "produits.IngredientsLib";
        String ac_useMotcle_val = "true";
        String ac_champRetour_val = "pv;compte_achat;compte_achat;libelleComposant";
        String dependentFieldsToMap_str_val = "pu;compte;comptelibelle;designation";

        String onChangeParam = "dynamicAutocompleteDependant(this, " +
                "\"IDFOURNISSEUR\", " +
                "\"LIKE\", " +
                "\"idProduit\", " +
                "\"" + nombreLigne + "\", " +
                "\"" + ac_affiche_val + "\", " +
                "\"" + ac_valeur_val + "\", " +
                "\"" + ac_colFiltre_val + "\", " +
                "\"" + ac_nomTable_val + "\", " +
                "\"" + ac_classe_val + "\", " +
                "\"" + ac_useMotcle_val + "\", " +
                "\"" + ac_champRetour_val + "\", " +
                "\"" + dependentFieldsToMap_str_val + "\"" +
                ")";

        pi.getFormu().getChamp("idDevise").setLibelle("Devise");
        pi.getFormu().getChamp("typeachat").setLibelle("Type d'achat");
        pi.getFormu().getChamp("idtypefacture").setLibelle("Type de facture");
        pi.getFormu().getChamp("idObjet").setLibelle("ID de l'objet");
        pi.getFormu().getChamp("idRef").setLibelle("ID R&eacute;f&eacute;rence");
        pi.getFormu().getChamp("idDmdAchat").setLibelle("ID Demande d'achat");
        pi.getFormu().getChamp("idfactureprincipale").setLibelle("ID Facture principale");
        pi.getFormu().getChamp("numero").setLibelle("Num&eacute;ro");
        pi.getFormu().getChamp("dateEcheancePaiement").setVisible(false);
        pi.getFormu().getChamp("idDevise").setAutre("onChange='deviseModification()'");
        pi.getFormu().getChamp("idBc").setVisible(false);
        pi.getFormu().getChamp("devise").setVisible(false);
        pi.getFormu().getChamp("taux").setVisible(false);
        //pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");

        pi.getFormu().getChamp("estPrevu").setLibelle("Est pr&eacute;vu");
        pi.getFormu().getChamp("datyPrevu").setLibelle("Date pr&eacute;visionnelle de paiement");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","AS_INGREDIENTS_LIB","taux;compte_achat;compte_achat","tauxDeChange;compte;comptelibelle");
        affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampFille("idProduit"),"produits/as-ingredients-saisie.jsp","id;libelle");
        affichage.Champ.setPageAppelCompletePropre(pi.getFormufle().getChampFille("compte"),"mg.cnaps.compta.ComptaCompte","compte","compte6","","","");

        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("remises_0").setLibelle("remise");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
        pi.getFormufle().getChamp("tauxDeChange_0").setLibelle("Taux de change");

        pi.getFormufle().getChamp("mois_0").setLibelle("Mois");
        pi.getFormufle().getChamp("annee_0").setLibelle("Ann&eacute;e");

        pi.getFormufle().getChampMulitple("idFactureFournisseur").setVisible(false);
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("idbcDetail").setVisible(false);
        pi.getFormufle().getChampMulitple("idbcDevise").setVisible(false);
        pi.getFormufle().getChampMulitple("mois").setVisible(false);
        pi.getFormufle().getChampMulitple("annee").setVisible(false);

        pi.preparerDataFormu();
        for(int i=0;i<nombreLigne;i++){
            pi.getFormufle().getChamp("qte_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("qte_"+i).setDefaut("0");
            pi.getFormufle().getChamp("tva_"+i).setDefaut("0");
            pi.getFormufle().getChamp("idDevise_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("designation_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("idDevise_"+i).setDefaut("AR");
        }

        FactureFournisseur ocr = (FactureFournisseur) session.getAttribute("ocr");
        if(ocr!=null){
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            LocalDate localDate = ocr.getDaty().toLocalDate();
            String formattedDate = localDate.format(formatter);
            pi.getFormu().getChamp("designation").setDefaut(ocr.getDesignation());
            pi.getFormu().getChamp("daty").setDefaut(formattedDate);
            if(ocr.getIdFournisseur()!=null){
                pi.getFormu().getChamp("idFournisseur").setDefaut(ocr.getIdFournisseur());
            }
            if(ocr.getIdMagasin()!=null){
                pi.getFormu().getChamp("idMagasin").setDefaut(ocr.getIdMagasin());
            }
            pi.setDefautFille(ocr.getFille());
        }

        if(details!=null && details.length > 0){
            if(request.getParameter("idbc")!=null){
                fournisseur.setDesignation("Facturation de la commande num "+request.getParameter("idbc"));
            }
            pi.getFormu().setDefaut(fournisseur);
            pi.setDefautFille(details);
            pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        }

        session.removeAttribute("ocr");

        String[] ids = (String[]) request.getParameterValues("ids");
        if(ids!=null && ids.length>0) {
            FactureFournisseurDetails[] ffd = new FactureFournisseurDetails().getByIdsRelever(ids,null);
            ReleverDetailCpl [] rel = (ReleverDetailCpl []) CGenUtil.rechercher(new ReleverDetailCpl(),null,null,null," AND ID='"+ids[0]+"'");
            pi.getFormu().getChamp("reference").setDefaut(rel[0].getIdCaisse());
            pi.getFormu().getChamp("reference").setVisible(false);
            pi.setDefautFille(ffd);
        }else{
            throw new Exception("Veuillez sélectionner au moins un relevé.");
        }

        String iddmdachat = request.getParameter("iddmdachat");
        if (iddmdachat!=null && !iddmdachat.isEmpty()) {
            DmdAchat dmdAchat = (DmdAchat) new DmdAchat().getById(iddmdachat,"DMDACHAT",null);
            if (dmdAchat!=null){
                pi.getFormu().getChamp("daty").setDefaut(Utilitaire.datetostring(dmdAchat.getDaty()));
                pi.getFormu().getChamp("idFournisseur").setDefaut(dmdAchat.getFournisseur());
                pi.getFormu().getChamp("designation").setDefaut("Facture de la demande d'achat "+iddmdachat);
                FactureFournisseurDetails[] factureFournisseurDetails = dmdAchat.getFactureFournisseurDetails(null);
                pi.setDefautFille(factureFournisseurDetails);
            }
        }
        String classeMere = "faturefournisseur.FactureFournisseur";
        String classeFille = "faturefournisseur.FactureFournisseurDetails";
        String butApresPost = "rapprochement/liste-rapprochement.jsp";
        String colonneMere = "idFactureFournisseur";

        String[] colOrdre = {"designation","id","idProduit","compte","qte","pu","tva","idDevise","tauxDeChange","mois","annee"};
        pi.getFormufle().setColOrdre(colOrdre);
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <%if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update")) {%>
    <h1>Modification R&egrave;glement charge</h1>
    <% }else{ %>
    <h1>R&egrave;glement charge</h1>
    <% } %>
    <div class="box-body">
        <form id="formId" class='container' action="<%=pi.getLien()%>?but=rapprochement/apresReglerRelever.jsp" method="post" >
            <%
                out.println(pi.getFormu().getHtmlInsert());
            %>
            <div class="col-md-12" >
                <h3 class="fontinter" style="background: white;padding: 16px;margin-top: 10px;border-radius: 16px;" >Total  : <span id="montanttotal">0</span><span id="deviseLibelle">Ar</span></h3>
            </div>
            <div id="butfillejsp">
                <%
                    out.println(pi.getFormufle().getHtmlTableauInsert());
                %>
            </div>
            <% if (ids != null) {
                for (String id : ids) { %>
            <input type="hidden" name="idsRelever" value="<%= id %>">
            <%  } } %>
            <input name="acte" type="hidden" id="nature" value="debit">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="bute" type="hidden" id="acte" value="reglerDebit">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
        </form>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                var nombreLigne = <%=nombreLigne%>;
                for(var i=0;i<nombreLigne;i++){
                    calculerMontant(i);
                }
            });
        </script>
    </div>
</div>
<script>
    function calculerMontant(indice,source) {
        var val = 0;
        $('input[id^="qte_"]').each(function() {
            var quantite =  parseFloat($("#"+$(this).attr('id').replace("qte","pu")).val());
            var montant = parseFloat($(this).val());
            if(!isNaN(quantite) && !isNaN(montant)){
                var value =quantite * montant;
                val += value;
            }
        });
        $("#montanttotal").html(Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(val));
    }
    function deviseModification() {

        var nombreLigne = parseInt($("#nombreLigne").val());
        for(let iL=0;iL<nombreLigne;iL++){
            $(function(){
                var mapping = {
                    "AR": {
                        "table": "ST_INGREDIENTSAUTOACHAT_CPL",
                    },
                    "USD": {
                        "table": "ST_INGREDIENTSAUTOACHAT_USD"
                    },
                    "EUR": {
                        "table": "ST_INGREDIENTSAUTOACHAT_EUR"
                    }
                };
                $("#deviseLibelle").html($('#idDevise').val());
                var idDevise = $('#idDevise').val();
                $("#idDevise_"+iL).val(idDevise);
                let autocompleteTriggered = false;
                $("#idProduit_"+iL+"libelle").autocomplete('destroy');
                $("#tauxDeChange_"+iL).val('');
                $("#pu_"+iL).val('');
                $("#idProduit_"+iL+"libelle").autocomplete({
                    source: function(request, response) {
                        $("#idProduit_"+iL).val('');
                        if (autocompleteTriggered) {
                            fetchAutocomplete(request, response, "null", "id", "null", mapping[idDevise].table, "produits.IngredientsLib", "true","pu;taux;compte;compte");
                        }
                    },
                    select: function(event, ui) {
                        $("#idProduit_"+iL+"libelle").val(ui.item.label);
                        $("#idProduit_"+iL).val(ui.item.value);
                        $("#idProduit_"+iL).trigger('change');
                        $(this).autocomplete('disable');
                        var champsDependant = ['pu_'+iL,'tauxDeChange_'+iL,'compte_'+iL,'compte_'+iL+'libelle'];
                        for(let i=0;i<champsDependant.length;i++){
                            $('#'+champsDependant[i]).val(ui.item.retour.split(';')[i]);
                        }
                        autocompleteTriggered = false;
                        return false;
                    }
                }).autocomplete('disable');
                $("#idProduit_"+iL+"libelle").off('keydown');
                $("#idProduit_"+iL+"libelle").keydown(function(event) {
                    if (event.key === 'Tab') {
                        event.preventDefault();
                        autocompleteTriggered = true;
                        $(this).autocomplete('enable').autocomplete('search', $(this).val());
                    }
                });
                $("#idProduit_"+iL+"libelle").off('input');
                $("#idProduit_"+iL+"libelle").on('input', function() {
                    $("#idProduit_"+iL).val('');
                    autocompleteTriggered = false;
                    $(this).autocomplete('disable');
                });
                $("#idProduit_"+iL+"searchBtn").off('click');
                $("#idProduit_"+iL+"searchBtn").click(function() {
                    autocompleteTriggered = true;
                    $("#idProduit_"+iL+"libelle").autocomplete('enable').autocomplete('search', $("#idProduit_"+iL+"libelle").val());
                });
            });
        }
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
