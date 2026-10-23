<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="bean.TypeObjet"%>
<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="caisse.Devise" %>
<%@ page import="annexe.Point" %>
<%@ page import="faturefournisseur.*" %>
<%@ page import="mg.cnaps.compta.ConstanteCompta" %>
<%@ page import="utils.ConstanteSocobis" %>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        DepenseSaisie mere = new DepenseSaisie();
        DepenseFilleSaisie fille = new DepenseFilleSaisie();

        FactureFournisseur fournisseur = new FactureFournisseur();
        FactureFournisseurDetails[] details = null;
        As_BonDeLivraison bonDeLivraison = new As_BonDeLivraison();
        As_BonDeCommande bonDeCommande = new As_BonDeCommande();
        Liste[] liste = new Liste[4];
        Point mag = new Point();
        mag.setNomTable("POINT");
        Devise d = new Devise();
//        liste[1] = new Liste("idDevise",d,"val","id");
//
//        liste[1].setDefaut("AR");
        if(request.getParameter("id")!=null){
            bonDeLivraison.setId(request.getParameter("id"));
            details = bonDeLivraison.getDetailsFacture(request.getParameter("id"),null);
            bonDeLivraison = (As_BonDeLivraison)bonDeLivraison.getById(request.getParameter("id"),"AS_BONDELIVRAISON",null);
            if(bonDeLivraison!=null){
                fournisseur = bonDeLivraison.genererFacture();
            }
        }else if(request.getParameter("idbc")!=null){
            bonDeCommande.setId(request.getParameter("idbc"));
            details = bonDeCommande.getDetailsFacture(request.getParameter("idbc"),null);
            bonDeCommande = (As_BonDeCommande)bonDeCommande.getById(request.getParameter("idbc"),"AS_BONDECOMMANDE",null);
            fournisseur = bonDeCommande.genererFacture();
//            liste[1].setDefaut(fournisseur.getIdDevise());
        }
        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));


        ModePaiement mp = new ModePaiement();
        liste[0] = new Liste("idModePaiement",mp,"val","id");

        liste[1] = new Liste("estPrevu");
        liste[1].makeListeOuiNon();

        TypeObjet typefacture = new TypeObjet();
        typefacture.setNomTable("type_facture");
        liste[2] = new Liste("idtypefacture",typefacture,"val","id");

        String dateJour= Utilitaire.dateDuJour();
        String periode = Utilitaire.getMois(dateJour);
        String annee = Utilitaire.getAnnee(dateJour);
        String[] val = {"01","02","03","04","05","06","07","08","09","10","11","12"};
        String[] aff = new String[val.length];
        for (int i = 0; i < val.length; i++) {
            aff[i] = val[i]+"/"+annee;
        }
        liste[3] = new Liste("periode",aff,val);
        //liste[6] = new Liste("typeTva",new TypeObjet("TYPETVA"),"val","id");
//        TypeAchat ta = new TypeAchat();
//        liste[5] = new Liste("typeachat",ta,"val","desce");

        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idtypefacture").setDefaut(ConstanteSocobis.TYPE_FACTURE);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pi.getFormu().getChamp("idMagasin").setVisible(false);
        pi.getFormu().getChamp("idMagasin").setDefaut(ConstanteSocobis.MAGASIN);
        pi.getFormu().getChamp("numero").setVisible(false);

        System.out.println(Utilitaire.getAnneeEnCours());
        pi.getFormu().getChamp("exercice").setDefaut(Utilitaire.getAnneeEnCours().replace("&nbsp;",""));
        pi.getFormu().getChamp("idtypefacture").setLibelle("Type de facture");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("libelle").setLibelle("Libell&eacute;");
        pi.getFormu().getChamp("totalfacture").setLibelle("Total R&eacute;el de la facture");
        pi.getFormu().getChamp("totalfacture").setAutre("onChange='changevaleurreel()'");
        //pi.getFormu().getChamp("typeTva").setLibelle("Type TVA");
        pi.getFormu().getChamp("designation").setVisible(false);

        pi.getFormu().getChamp("periode").setLibelle("P&eacute;riode (Mois)");
        pi.getFormu().getChamp("periode").setDefaut(periode);

        pi.getFormu().getChamp("idModePaiement").setLibelle("Mode de paiement");
        pi.getFormu().getChamp("typeachat").setLibelle("Type d'achat");
        pi.getFormu().getChamp("typeachat").setVisible(false);
        pi.getFormu().getChamp("typeachat").setDefaut(ConstanteSocobis.TYPE_ACHAT_PS);
        pi.getFormu().getChamp("libelle").setAutre("onchange=\"syncLibelle(this)\"");
        pi.getFormu().getChamp("exercice").setAutre("onchange=\"syncPeriode(this)\"");
        pi.getFormu().getChamp("typeachat").setDefaut(ConstanteSocobis.TYPE_ACHAT_PS);
        pi.getFormu().getChamp("idDmdAchat").setVisible(false);
        pi.getFormu().getChamp("typeFactureFournisseur").setDefaut(ConstanteSocobis.typeFactureDepenses);
        pi.getFormu().getChamp("typeFactureFournisseur").setVisible(false);


        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("daty").setDefaut(dateJour);
        pi.getFormu().getChamp("daty").setVisible(false);
        pi.getFormu().getChamp("jour").setDefaut("1");
        pi.getFormu().getChamp("idFournisseur").setLibelle("Fournisseur");
        //pi.getFormu().getChamp("idFournisseur").setPageAppel("choix/fournisseur/fournisseur-choix.jsp");
        //pi.getFormu().getChamp("idFournisseur").setPageAppelComplete("faturefournisseur.FournisseurCpl","id","FournisseurCpl");
        pi.getFormu().getChamp("idfournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","Fournisseur");
        ////pi.getFormu().getChamp("idFournisseur").setAutre("readonly");

        String[] ordre={"exercice","periode","jour","dateEcheancePaiement","idFournisseur","libelle","totalfacture","typeTva"};
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

//        pi.getFormu().getChamp("idDevise").setLibelle("Devise");
        pi.getFormu().getChamp("idDevise").setVisible(false);
        pi.getFormu().getChamp("idDevise").setDefaut("AR");
        pi.getFormu().getChamp("datyPrevu").setVisible(false);
//        pi.getFormu().getChamp("idDevise").setAutre("onChange='deviseModification()'");
        pi.getFormu().getChamp("idBc").setVisible(false);
        pi.getFormu().getChamp("devise").setVisible(false);
        pi.getFormu().getChamp("taux").setVisible(false);
        pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormu().getChamp("idRef").setVisible(false);
        if(request.getParameter("idTravaux")!=null){
            pi.getFormu().getChamp("idRef").setDefaut(request.getParameter("idTravaux"));
        }
        if(request.getParameter("idElementMaintenance")!=null){
            pi.getFormu().getChamp("idObjet").setDefaut(request.getParameter("idElementMaintenance"));
        }
        if(request.getParameter("id")!=null){
            pi.getFormu().getChamp("idObjet").setDefaut(request.getParameter("id"));
            pi.getFormu().getChamp("idObjet").setAutre("readonly");
            pi.getFormu().getChamp("idObjet").setLibelle("Source");
        }
        else {
            pi.getFormu().getChamp("idObjet").setLibelle("Consommateur");
            pi.getFormu().getChamp("idObjet").setPageAppelComplete("maintenance.ressources.IngredientMaintenanceLib","id","AS_INGREDIENT_MAINTENANCE_LIB","","");
        }
        pi.getFormu().getChamp("idObjet").setVisible(false);

        pi.getFormu().getChamp("estPrevu").setLibelle("Est pr&eacute;vu");
        pi.getFormu().getChamp("dateEcheancePaiement").setLibelle("Date pr&eacute;visionnelle de paiement");
//        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTOACHAT_CPL","taux;compte_achat;compte_achat","tauxDeChange;compte;comptelibelle");
        affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampFille("idProduit"),"produits/as-ingredients-saisie.jsp","id;libelle");
        //affichage.Champ.setPageAppelCompletePropre(pi.getFormufle().getChampFille("compte"),"mg.cnaps.compta.ComptaCompte","compte","compte6","","","");

        pi.getFormufle().getChamp("idProduit_0").setLibelle("Intitul&eacute;");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA en (%)");
        pi.getFormufle().getChamp("remises_0").setLibelle("remise");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Montant TTC");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
        pi.getFormufle().getChamp("tauxDeChange_0").setLibelle("Taux de change");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("tauxDeChange"),"1");
        pi.getFormufle().getChampMulitple("tauxDeChange").setVisible(false);
        pi.getFormufle().getChamp("compteanalytique_0").setLibelle("Analytique");
        new ChampCompte("compteanalytique",pi.getFormufle());
        //affichage.Champ.setPageAppelCompletePropre(pi.getFormufle().getChampFille("compteanalytique"), "mg.cnaps.compta.ComptaCompte", "compte", "compta_compte", "", "", " and typeCompte='"+ConstanteCompta.type_compte_analytique+"'");

        pi.getFormufle().getChamp("mois_0").setLibelle("Mois");
        pi.getFormufle().getChamp("annee_0").setLibelle("Ann&eacute;e");
        pi.getFormufle().getChamp("intitule_0").setLibelle("Intitul&eacute;");
        pi.getFormufle().getChamp("libelle_0").setLibelle("Libell&eacute;");
        pi.getFormufle().getChamp("debit_0").setLibelle("Montant");
        pi.getFormufle().getChamp("credit_0").setLibelle("Cr&eacute;dit");
        pi.getFormufle().getChamp("montanttva_0").setLibelle("Montant TVA");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");

        pi.getFormufle().getChampMulitple("idFactureFournisseur").setVisible(false);
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("idbcDetail").setVisible(false);
        pi.getFormufle().getChampMulitple("idbcDevise").setVisible(false);
        pi.getFormufle().getChampMulitple("mois").setVisible(false);
        pi.getFormufle().getChampMulitple("annee").setVisible(false);
        pi.getFormufle().getChampMulitple("qte").setVisible(false);
        pi.getFormufle().getChampMulitple("libelle").setVisible(false);
        pi.getFormufle().getChampMulitple("compteanalytique").setVisible(false);

        affichage.Champ.setAutre(pi.getFormufle().getChampFille("pu"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("qte"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("tva"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("remises"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("idProduit"),"onchange='calculerMontantV2()'");
      //  affichage.Champ.setAutre(pi.getFormufle().getChampFille("montanttva"),"readonly");


        pi.preparerDataFormu();
        for(int i=0;i<nombreLigne;i++){
            pi.getFormufle().getChamp("qte_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("qte_"+i).setDefaut("1");
            pi.getFormufle().getChamp("tva_"+i).setDefaut("0");
            pi.getFormufle().getChamp("idDevise_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("idProduit_"+i).setAutreHidden("onchange=\"synccompte(" + i + ")\"");
            pi.getFormufle().getChamp("pu_"+i).setAutre("onchange=\"syncmontanttva(" + i + ")\"");
            pi.getFormufle().getChamp("tva_"+i).setAutre("onchange=\"syncmontanttva(" + i + ")\"");
            pi.getFormufle().getChamp("designation_"+ i).setType("textarea");
        }
//        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("compte"), "mg.cnaps.compta.ComptaCompteIngredients","compte","COMPTA_COMPTE_INGREDIENTS","libelle;libelle","intitule;idProduit");
        new ChampCompteIng("compte",pi.getFormufle());
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
            //pi.getFormu().getChamp("iddevise").setDefaut("AR");
            pi.setDefautFille(details);
            pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
            //pi.getFormu().getChamp("designation").setDefaut("Facturation de la commande num "+request.getParameter("idbc"));
        }

        session.removeAttribute("ocr");

        String iddmdachat = request.getParameter("iddmdachat");
        if (iddmdachat!=null && !iddmdachat.isEmpty()) {
            DmdAchat dmdAchat = (DmdAchat) new DmdAchat().getById(iddmdachat,"DMDACHAT",null);
            if (dmdAchat!=null){
                pi.getFormu().getChamp("daty").setDefaut(Utilitaire.datetostring(dmdAchat.getDaty()));
                pi.getFormu().getChamp("idFournisseur").setDefaut(dmdAchat.getFournisseur());
                pi.getFormu().getChamp("idbc").setDefaut(iddmdachat);
                pi.getFormu().getChamp("iddmdachat").setDefaut(iddmdachat);
                pi.getFormu().getChamp("designation").setDefaut("Facture de la demande d'achat "+iddmdachat);
                FactureFournisseurDetails[] factureFournisseurDetails = dmdAchat.getFactureFournisseurDetails(null);
                pi.setDefautFille(factureFournisseurDetails);
            }
        }

        //Variables de navigation
        String classeMere = "faturefournisseur.DepenseSaisie";
        String classeFille = "faturefournisseur.DepenseFilleSaisie";
        String butApresPost = "facturefournisseur/facturefournisseur-fiche.jsp";
        String colonneMere = "idFactureFournisseur";
        
        //Preparer les affichages
        String[] colOrdre = {"compte","idProduit","compteanalytique","designation","qte","pu","tva","montanttva","tauxDeChange"};
        pi.getFormufle().setColOrdre(colOrdre);
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <%if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update")) {%>
    <h1>Modification D&eacute;pense  / Facture Fournisseur</h1>
    <% }else{ %>
    <h1>D&eacute;pense / Facture Fournisseur</h1>
    <% } %>
    <div class="box-body">
        <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
            <%

                out.println(pi.getFormu().getHtmlInsert());
            %>
          <div class="col-md-12 nopadding" >
                <div class="col-md-12 cardradius">
                    <h4 class="fontinter m-0" style="margin-bottom: 6px !important;"><strong>Total HT :</strong> <span id="totalht">0</span> Ar</h4>
                    <h4 class="fontinter m-0" style="margin-bottom: 6px !important;"><strong>Total TVA :</strong> <span id="totaltva">0</span> Ar</h4>
                    <h4 class="fontinter m-0" style="margin-bottom: 6px !important;"><strong>Total TTC :</strong> <span id="montanttotal">0</span> Ar</h4>
                    <h4 class="fontinter m-0" style="margin-bottom: 6px !important;"><strong>Total R&eacute;el de la facture :</strong> <span id="montanttotalreel">0</span> Ar</h4>
                    <h4 class="fontinter m-0"><strong>&Eacute;cart :</strong> <span id="ecart">0</span> Ar</h4>
                </div>
            </div>
            <div id="butfillejsp">
                <%
                    out.println(pi.getFormufle().getHtmlTableauInsert());
                %>
            </div>

            <input type="hidden" name="taxe" id="taxe" value="">
            <input type="hidden" name="echeance" id="echeance" value="">
            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
        </form>
    </div>
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
    document.getElementById("exercice").removeAttribute("onblur");
    document.getElementById("exercice").removeAttribute("oninput");
    var val = document.getElementById("exercice").value;
    val = cleanNumber(val);
    document.getElementById("exercice").value = val;

    // Appel automatique de calculerMontant pour chaque ligne au chargement
    $(document).ready(function () {
        calculerMontantV2();

        const echeanceInput = document.getElementById('echeance');
        const observer = new MutationObserver(() => {
            changerValeur();
        });

        observer.observe(echeanceInput, {
            attributes: true,
            attributeFilter: ['value']
        });


        const TAXE_VALUE = <%= ConstanteCompta.constante_tva %>;

        const taxeInput = document.getElementById('taxe');
        const tvaInputs = document.querySelectorAll('[id^="tva_"]');

        const observer2 = new MutationObserver(() => {
            const newValue = taxeInput.value;

            if (newValue === '1.0') {
                tvaInputs.forEach(input => {
                    input.value = TAXE_VALUE;
                });
            } else {
                tvaInputs.forEach(input => {
                    input.value = '0';
                });
            }
        });

        observer2.observe(taxeInput, {
            attributes: true,
            attributeFilter: ['value']
        });
    });
</script>
<script>
    function updateEcart() {
        const totalReel = cleanNumber(document.getElementById('montanttotalreel').textContent);
        const totalTTC  = cleanNumber(document.getElementById('montanttotal').textContent);
        const ecart = totalReel - totalTTC;

        document.getElementById('ecart').style.color = (ecart !== 0) ? 'red' : 'black';
        document.getElementById('ecart').textContent = ecart.toLocaleString('fr-FR', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
    }

    function changevaleurreel() {
        let totalfacture = cleanNumber(document.getElementById("totalfacture")?.value);
        $("#montanttotalreel").html(Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(totalfacture));
        updateEcart();
    }

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


    function calculerMontantV2() {
        var puList = document.querySelectorAll('input[id^="pu_"]');
        let totalHT = 0;
        let totalTVA = 0;

        puList.forEach(input => {
            let id = input.id.split("_")[1];

            let pu = cleanNumber(document.getElementById("pu_" + id)?.value);
            let montantTva = cleanNumber(document.getElementById("montanttva_" + id)?.value);

            totalHT += pu;
            totalTVA += montantTva;
        });

        const totalTTC = totalHT + totalTVA;

        const fmt = (v) => v.toLocaleString('fr-FR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

        document.getElementById("totalht").innerHTML = fmt(totalHT);
        document.getElementById("totaltva").innerHTML = fmt(totalTVA);
        document.getElementById("montanttotal").innerHTML = fmt(totalTTC);

        updateEcart();
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

    function syncPeriode(input) {
        let exercice;
        if (input) {
            exercice = input.value;
        } else {
            if (!champ) return;
            exercice = champ.value;
        }
        if (!exercice) return;
        addExerciceSurPeriode(exercice);
    }

    function addExerciceSurPeriode(exercice) {
        const select = document.getElementById('periode');
        if (!select) return;
        for (const option of select.options) {
            const mois = option.getAttribute('value');
            option.textContent = mois + '/' + exercice;
        }
    }

    function sanitizeNumber(str) {
        return parseFloat(str.replace(/\s/g, '').replace(',', '.')) || 0;
    }

    function changerValeur() {
        var champ = document.getElementById("echeance");
        const champDaty = document.getElementById("dateEcheancePaiement");

        let jour, mois, annee;

        const today = new Date();
        jour = today.getDate();
        mois = today.getMonth() + 1;
        annee = today.getFullYear();
        const date = new Date(annee, mois - 1, jour);

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

    function syncLibelle(input) {
        var valeur = input.value;
        var inputs = document.querySelectorAll("input[name^='libelle_'], input[id^='libelle_']");
        inputs.forEach(function(el) {
            el.value = valeur;
        });
    }

    function synccompte(index) {
        var inputCompte = document.querySelector(
            "input[name='compte_" + index + "'], input[id='compte_" + index + "']"
        );
        if (!inputCompte) {
            return;
        }
        var inputCompteLibelle = document.querySelector(
            "input[name='comptelibelle_" + index + "'], input[id='comptelibelle_" + index + "']"
        );
        if (!inputCompteLibelle) {
            return;
        }
        // Vérifier si la valeur est déjà remplie
        if (inputCompte.value) {
            inputCompteLibelle.value = inputCompte.value;
            return;
        }
        // Sinon, observer la valeur du hidden
        var observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
                if (mutation.attributeName === "value") {
                    inputCompteLibelle.value = inputCompte.value;
                    observer.disconnect();
                }
            });
        });
        observer.observe(inputCompte, { attributes: true });
    }


    function calculPU(montantTTC, tva) {
        return montantTTC / (1 + tva/100);
    }

    function calculTotal() {
        var val = 0;
        $('input[id^="pu_"]').each(function() {
            var montant = parseFloat($(this).val());
            if (!isNaN(montant)) {
                val += montant;
            }
        });
        $("#montanttotal").html(
            Intl.NumberFormat('fr-FR', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            }).format(val)
        );
    }

    // Quand le PU (montant TTC) change
    function syncmontanttva(index) {
        var puInput = document.getElementById("pu_" + index);
        var tvaInput = document.getElementById("tva_" + index);
        var montantTVAInput = document.getElementById("montanttva_" + index);

        if (!puInput || !tvaInput || !montantTVAInput) return;

        var pu = parseFloat(puInput.value) || 0;
        var tva = parseFloat(tvaInput.value) || 0;
        var montantTVA = pu * (tva / 100);
        montantTVAInput.value = montantTVA.toFixed(2);

        calculerMontantV2(); // remplace calculTotal() + updateEcart()
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
<script language="JavaScript">
document.addEventListener("DOMContentLoaded", function () {

    const form = document.getElementById("formId");
    if (!form) return;

    const originalAction = form.action;

    document.querySelectorAll(".box-footer").forEach(function (footer) {
        if (footer.querySelector(".btn-save-validate")) {
            return;
        }

        const btn = document.createElement("button");
        btn.type = "button";
        btn.className = "btn btn-success btnradius pull-right btn-save-validate";
        btn.style.marginLeft = "15px";
        btn.textContent = "Enregistrer & valider";
        btn.onclick = function () {
            form.action = "module.jsp?but=compta/depense/apresEnregistrerValider.jsp";
            form.submit();
            form.action = originalAction;
        };
        const saveBtn = footer.querySelector(
            "button[type='submit']:not([value='deleteFille'])"
        );

        if (saveBtn) {
            footer.insertBefore(btn, saveBtn);
        } else {
            footer.appendChild(btn);
        }
    });
    $(document).ready(function () {
        $(document).on('keyup', 'input[id^="tva_"]', function() {
            syncTva(this);
        });
    });
    document.querySelectorAll('input[name^="pu_"]').forEach(function(input) {
        input.value = '';
    });

    document.querySelectorAll('input[name^="tva_"]').forEach(function(input) {
        input.value = '';
    });

    document.querySelectorAll('input[name^="montanttva_"]').forEach(function(input) {
        input.value = '';
    });

    function syncTva(input) {
        var valeur = input.value;

        var inputs = document.querySelectorAll("input[id^='tva_']");
        inputs.forEach(function(el) {
            var idLigne = el.id.split("_")[1];
            el.value = valeur;

            var puInput = document.getElementById("pu_" + idLigne);
            var montantTVAInput = document.getElementById("montanttva_" + idLigne);
            if (puInput && montantTVAInput) {
                var pu = parseFloat(puInput.value) || 0;
                var tva = parseFloat(valeur) || 0;
                montantTVAInput.value = (pu * (tva / 100)).toFixed(2);
            }
        });

        calculerMontantV2();
    }

});
</script>