<%--
    Document   : vente-saisie
    Created on : 22 mars 2024, 14:37:44
    Author     : Angela
--%>

<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@page import="faturefournisseur.*"%>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        As_BonDeCommande mere = new As_BonDeCommande();
        As_BonDeCommande_Fille fille = new As_BonDeCommande_Fille();
        fille.setNomTable("AS_BONDECOMMANDE_FILLE");
        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));
        Liste[] liste = new Liste[2];
        liste[0] = new Liste("idDevise",new caisse.Devise(),"val","id");
        liste[0].setDefaut("AR");
        ModePaiement mp = new ModePaiement();
        liste[1] = new Liste("modepaiement",mp,"val","id");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("reference").setVisible(false);
        if (request.getParameter("idOffille")!=null && request.getParameter("idOffille").isEmpty()==false){
            pi.getFormu().getChamp("reference").setDefaut(request.getParameter("idOffille"));
        }
        pi.getFormu().getChamp("nbjournormal").setVisible(false);
        pi.getFormu().getChamp("nbjourweekend").setVisible(false);
        pi.getFormu().getChamp("nbjourspecial").setVisible(false);
        pi.getFormu().getChamp("idcategorie").setVisible(false);
        pi.getFormu().getChamp("idPoint").setVisible(false);
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("fournisseur").setLibelle("Fournisseur");
        pi.getFormu().getChamp("fournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","Fournisseur");
        pi.getFormu().getChamp("fournisseur").setPageAppelInsert("fournisseur/fournisseur-saisie.jsp","fournisseur;fournisseurlibelle","id;nom");
        pi.getFormu().getChamp("idDevise").setLibelle("Devise");
        pi.getFormu().getChamp("idDevise").setAutre("onChange='deviseModification()'");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("produit"),"maintenance.ressources.IngredientMaintenanceLib","id","AS_INGREDIENT_MAINTENANCE_LIB","libelle","designation");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("quantite"),"1");
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("quantite"),false);
        //affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampFille("produit"),"annexe/produit/produit-saisie.jsp","id;val");
        pi.getFormufle().getChamp("produit_0").setLibelle("Machine");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");

        pi.getFormufle().getChamp("remise_0").setLibelle("Remise");
        pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix Unitaire");
        pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("idbc").setVisible(false);
        pi.getFormufle().getChampMulitple("montant").setVisible(false);
        pi.getFormufle().getChampMulitple("unite").setVisible(false);
        pi.getFormufle().getChampMulitple("tauxDeChange").setVisible(false);
        pi.getFormufle().getChampMulitple("designation").setVisible(false);

//        pi.getFormufle().getChamp("tauxDeChange_0").setLibelle("Taux de change");
//        pi.getFormufle().getChampMulitple("tauxDeChange").setAutre("readonly");
        pi.preparerDataFormu();
        for(int i=0;i<nombreLigne;i++){
            // pi.getFormufle().getChamp("pu_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("quantite_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("quantite_"+i).setDefaut("0");
            pi.getFormufle().getChamp("tva_"+i).setDefaut("0");
            pi.getFormufle().getChamp("idDevise_"+i).setDefaut("AR");
            pi.getFormufle().getChamp("tauxDeChange_"+i).setDefaut("1");
            pi.getFormufle().getChamp("produit_"+i).setPageAppelInsert("maintenance/ressources/machine/machine-saisie.jsp","produit_"+i+";produit_"+i+"libelle","idIngredient;libelle");
        }

        affichage.Champ.setAutre(pi.getFormufle().getChampFille("pu"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("quantite"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("tva"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("remise"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("produit"),"onchange='calculerMontantV2()'");
        //Variables de navigation
        String classeMere = "faturefournisseur.As_BonDeCommande";
        String classeFille = "faturefournisseur.As_BonDeCommande_Fille";
        String butApresPost = "bondecommande/bondecommande-fiche.jsp";
        String colonneMere = "idbc";
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <% if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update")) {%>
    <h1 align="center">Modification d'un bon de commande fournisseur </h1>
    <% }else{ %>
    <h1 align="center">Enregistrement d'un bon de commande fournisseur</h1>
    <% } %>

    <div class="box-body">
        <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
            <%

                out.println(pi.getFormu().getHtmlInsert());
            %>
            <div class="col-md-12" >
                <h3 class="fontinter" style="background: white;padding: 16px;margin-top: 10px;border-radius: 16px;">Total  : <span id="montanttotal">0</span><span id="deviseLibelle">Ar</span></h3>
            </div>
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
            <input name="nomtable" type="hidden" id="nomtable" value="AS_BONDECOMMANDE_FILLE">
        </form>
    </div>
</div>
</div>
<script>
    function calculerMontant(indice,source) {
        var val = 0;
        $('input[id^="quantite_"]').each(function() {
            var quantite =  parseFloat($("#"+$(this).attr('id').replace("quantite","pu")).val());
            var montant = parseFloat($(this).val());
            if(!isNaN(quantite) && !isNaN(montant)){
                var value =quantite * montant;
                val += value;
            }
        });
        $("#montanttotal").html(val.toFixed(2));
    }

    function calculerMontantV2(){
        var listChamp = document.querySelectorAll('input[id^="pu_"]');
        let montantTtc = 0;
        for (let i = 0; i < listChamp.length; i++) {
            let pu = parseFloat(document.getElementById("pu_"+i)?.value || 0);
            let qte = parseFloat(document.getElementById("quantite_"+i)?.value || 0);
            let tva = parseFloat(document.getElementById("tva_"+i)?.value || 0);
            let remise = parseFloat(document.getElementById("remise_"+i)?.value || 0);
            let montantremise = (pu*qte)*(remise/100);
            montantTtc += ((pu*qte)-montantremise)+(((pu*qte)-montantremise)*(tva/100));
        }
        document.getElementById("montanttotal").innerHTML = montantTtc.toLocaleString('en-US');
    }

    function bloquerChamp(){
        var listChamp = document.querySelectorAll('input[id^="pu_"]');
        for (let i = 0; i < listChamp.length; i++) {
            document.getElementById("produit_"+i+"libelle").setAttribute("readonly","");
            document.getElementById("produit_"+i+"searchBtn").setAttribute("disabled","");
        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        bloquerChamp();
        calculerMontantV2();
    });
    function deviseModification() {

        var nombreLigne = parseInt($("#nombreLigne").val());
        for(let iL=0;iL<nombreLigne;iL++){
            $(function(){
                var mapping = {
                    "AR": {
                        "table": "produit_achat_lib_mga",
                    },
                    "USD": {
                        "table": "produit_achat_lib_usd"
                    },
                    "EUR": {
                        "table": "produit_achat_lib_euro"
                    }
                };
                $("#deviseLibelle").html($('#idDevise').val());
                var idDevise = $('#idDevise').val();
                $("#idDevise_"+iL).val(idDevise);
                let autocompleteTriggered = false;
                $("#produit_"+iL+"libelle").autocomplete('destroy');
                $("#tauxDeChange_"+iL).val('');
                $("#pu_"+iL).val('');
                $("#produit_"+iL+"libelle").autocomplete({
                    source: function(request, response) {
                        $("#produit_"+iL).val('');
                        if (autocompleteTriggered) {
                            fetchAutocomplete(request, response, "null", "id", "null", mapping[idDevise].table, "annexe.ProduitLib", "true","puVente;puAchat;taux;val");
                        }
                    },
                    select: function(event, ui) {
                        $("#produit_"+iL+"libelle").val(ui.item.label);
                        $("#produit_"+iL).val(ui.item.value);
                        $("#produit_"+iL).trigger('change');
                        $(this).autocomplete('disable');
                        var champsDependant = ['pu_'+iL,'puAchat_'+iL,'tauxDeChange_'+iL,'designation_'+iL];
                        for(let i=0;i<champsDependant.length;i++){
                            $('#'+champsDependant[i]).val(ui.item.retour.split(';')[i]);
                        }
                        autocompleteTriggered = false;
                        return false;
                    }
                }).autocomplete('disable');
                $("#produit_"+iL+"libelle").off('keydown');
                $("#produit_"+iL+"libelle").keydown(function(event) {
                    if (event.key === 'Tab') {
                        event.preventDefault();
                        autocompleteTriggered = true;
                        $(this).autocomplete('enable').autocomplete('search', $(this).val());
                    }
                });
                $("#produit_"+iL+"libelle").off('input');
                $("#produit_"+iL+"libelle").on('input', function() {
                    $("#produit_"+iL).val('');
                    autocompleteTriggered = false;
                    $(this).autocomplete('disable');
                });
                $("#produit_"+iL+"searchBtn").off('click');
                $("#produit_"+iL+"searchBtn").click(function() {
                    autocompleteTriggered = true;
                    $("#produit_"+iL+"libelle").autocomplete('enable').autocomplete('search', $("#produit_"+iL+"libelle").val());
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

