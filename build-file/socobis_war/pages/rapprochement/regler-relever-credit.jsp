<%--
    Document   : vente-saisie
    Created on : 22 mars 2024, 14:37:44
    Author     : Angela
--%>


<%@page import="caisse.Caisse"%>
<%@page import="vente.InsertionVente"%>
<%@page import="vente.*"%>
<%@page import="bean.TypeObjet"%>
<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="client.Client" %>
<%@ page import="faturefournisseur.ModePaiement" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    boolean carteExpiree = false;
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        String nomtable = "Vente_Details";
        InsertionVente mere = new InsertionVente();
        VenteDetailsLib fille = new VenteDetailsLib();
        fille.setNomTable("VENTE_DETAILS_VIDE");
        int nombreLigne = 10;
        As_BondeLivraisonClient blf = new As_BondeLivraisonClient();
        VenteDetails[] vente_details = null;
        if(request.getParameter("id")!=null){
            blf.setId(request.getParameter("id"));
            vente_details = blf.getListeVenteDetails("AS_BC_FILLE_AVEC_PRIX",null);
        }

        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));
        Liste[] liste = new Liste[5];
        liste[0] = new Liste("idMagasin",new magasin.Magasin(),"val","id");
        //liste[1] = new Liste("idDevise",new caisse.Devise(),"val","id");
        //liste[1].setDefaut("AR");
        liste[1] = new Liste("estPrevu");
        liste[1].makeListeOuiNon();
        ModePaiement mp = new ModePaiement();
        liste[2] = new Liste("modepaiement",mp,"val","id");

        Liste listemode = new Liste("modelivraison");

        String [] affVal = new String[2];
        String [] aff = new String[2];
        aff = new String[]{"LIVRAISON","RECUPERATION"};
        affVal = new String[]{"1","2"};

        listemode.ajouterValeur(affVal,aff);
        liste[3] = listemode;

        TypeObjet typeContrat = new TypeObjet();
        typeContrat.setNomTable("BANQUE_COMPTA");
        liste[4]=new Liste("referencefact",typeContrat,"val","ID");
        liste[4].setLibelle("Banque");

        if(request.getParameter("id")!=null && !request.getParameter("id").isEmpty()){
            if(request.getParameter("idClient")!=null && !request.getParameter("idClient").isEmpty()){
                pi.getFormu().getChamp("idClient").setDefaut(request.getParameter("idClient"));
            }

            if(request.getParameter("idPoint")!=null && !request.getParameter("idPoint").isEmpty()){
                pi.getFormu().getChamp("idMagasin").setDefaut(request.getParameter("idPoint"));
            }
        }

        pi.getFormu().changerEnChamp(liste);
        //pi.getFormu().getChamp("idMagasin").setAutre("onchange=\"updateFille(event, 'formId')\"");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idOrigine").setVisible(false);
        pi.getFormu().getChamp("referencefact").setVisible(false);
        pi.getFormu().getChamp("idMagasin").setLibelle("Point de vente");
        //pi.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
        //pi.getFormu().getChamp("referencefact").setLibelle("R&eacute;f&eacute;rence facture");
        //pi.getFormu().getChamp("referencefact").setVisible(false);
        pi.getFormu().getChamp("modelivraison").setLibelle("Mode de livraison");
        pi.getFormu().getChamp("fraislivraison").setLibelle("Frais de livraison (Par Kg)");
        pi.getFormu().getChamp("estPrevu").setLibelle("Est Pr&eacutevu");
        pi.getFormu().getChamp("datyPrevu").setLibelle("Date pr&eacute;visionnelle d'encaissement");
        //pi.getFormu().getChamp("designation").setDefaut("Vente particulier du "+utilitaire.Utilitaire.dateDuJour());
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("idClient").setLibelle("Client");
        pi.getFormu().getChamp("idClient").setPageAppelComplete("client.Client","id","Client_actif","echeance","echeancefacture");
        pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle;echeance","id;nom;echeancefacture");
        //pi.getFormu().getChamp("idClient").setAutre("onchange=\"updateFille(event, 'formId')\"");
        pi.getFormu().getChamp("idDevise").setLibelle("Devise");
        pi.getFormu().getChamp("idDevise").setVisible(false);
        pi.getFormu().getChamp("echeancefacture").setAutre("onChange='changerValeur()'");
        //i.getFormu().getChamp("echeancefacture").setAutre("readonly");
        pi.getFormu().getChamp("echeancefacture").setLibelle("Ech&eacute;ance facture");

        if(request.getParameter("idclient")!=null){
            pi.getFormu().getChamp("idclient").setDefaut(request.getParameter("idclient"));

        }
        //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"annexe.ProduitLib","id","PRODUIT_LIB_MGA","puVente;puAchat;taux;val;compte;compte","pu;puAchat;tauxDeChange;designation;compte;comptelibelle");
        //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTOVENTE","pv;compte_vente;libelle","pu;compte;designation");
        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id","AS_INGREDIENTS_LIB","compte_vente;idunite;idunitelib","compte;unite;unitelib","");
        //affichage.Champ.setAutre(pi.getFormufle().getChampFille("idProduit"),"readonly");

        double tva = 0.0;
        /*
        if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
            String idmagasin = request.getParameter("idMagasin");
            if(request.getParameter("idMagasin") != null && !request.getParameter("idMagasin").isEmpty()){
                session.setAttribute("idMagasin", request.getParameter("idMagasin"));
            }
            if(idmagasin == null || idmagasin.isEmpty()){
                idmagasin = (String) session.getAttribute("idMagasin");
            }
            Client c = null;
            if(request.getParameter("idClientlibelle")!=null && request.getParameter("idClientlibelle").split(" - ").length>0){
                String idclient = request.getParameter("idClientlibelle").split(" - ")[0];
                c = (Client)new Client().getById(idclient,"client",null);
                Calendar cal = Calendar.getInstance();
                cal.setTime(c.getDatecarte());
                cal.add(Calendar.YEAR, 1);
                Date dateCartePlusUnAn = cal.getTime();
                Date dateAujourdhui = new Date();
                carteExpiree = dateAujourdhui.compareTo(dateCartePlusUnAn) >= 0;
                tva = c.getTaxe();
                session.setAttribute("idclient", idclient);
            }else{
                c = (Client)new Client().getById((String) session.getAttribute("idclient"),"client",null);
                tva = c.getTaxe();
            }
            if(idmagasin!=null && c!=null){
                affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id","AS_INGREDIENT_VENTE_LIB","prixunitaire;compte_vente;libelle;idunite;idunitelib","pu;compte;designation;unite;unitelib"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"'");
            }
        }else{
            session.removeAttribute("idMagasin");
            session.removeAttribute("idclient");
        }
         */
        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA (En %)");
        pi.getFormufle().getChamp("designation_0").setLibelle("Designation");
        //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("compte"),"mg.cnaps.compta.ComptaCompte","compte","compta_compte","","");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        pi.getFormufle().getChamp("remise_0").setLibelle("Remise (En %)");
        pi.getFormufle().getChamp("idOrigine_0").setLibelle("Origine");

        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("PU Brut");
        pi.getFormufle().getChamp("punet_0").setLibelle("PU Net");
        pi.getFormufle().getChamp("montantht_0").setLibelle("Montant HT");
        pi.getFormufle().getChamp("montantttc_0").setLibelle("Montant TTC");
        pi.getFormufle().getChampMulitple("idVente").setVisible(false);
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("idOrigine").setVisible(false);
        pi.getFormufle().getChampMulitple("puAchat").setVisible(false);
        pi.getFormufle().getChampMulitple("puVente").setVisible(false);
        pi.getFormufle().getChampMulitple("idDevise").setVisible(false);
        pi.getFormufle().getChampMulitple("idbcfille").setVisible(false);
        pi.getFormufle().getChamp("tauxDeChange_0").setLibelle("Taux de change");
        pi.getFormufle().getChamp("unitelib_0").setLibelle("Unit&eacute;");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation ");
        pi.getFormu().getChamp("lieuLivraison").setLibelle("Lieu de livraison");
        pi.getFormu().getChamp("dateLivraison").setLibelle("Date de livraison");

        pi.getFormufle().getChampMulitple("tauxDeChange").setVisible(false);
        pi.getFormufle().getChampMulitple("compte").setVisible(false);
        pi.getFormufle().getChampMulitple("unite").setVisible(false);
        if(vente_details!=null && vente_details.length>0){
            pi.setDefautFille(vente_details);
            pi.getFormu().getChamp("idOrigine").setDefaut(request.getParameter("id"));
            pi.getFormu().getChamp("designation").setDefaut("Facturation de la livraison num "+request.getParameter("id"));
        }
        String[] order_form = {"daty","designation","referencefact","idMagasin","idClient","remarque","idDevise","estPrevu","datyPrevu","idOrigine","etat"};
        pi.getFormu().setOrdre(order_form);

        pi.preparerDataFormu();
        for(int i=0;i<nombreLigne;i++){
            // pi.getFormufle().getChamp("pu_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("qte_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("remise_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("tva_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("idDevise_"+i).setDefaut("AR");
            //pi.getFormufle().getChamp("compte_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("tva_"+i).setDefaut(tva+"");
            pi.getFormufle().getChamp("unitelib_"+i).setAutre("readonly");
            //pi.getFormufle().getChamp("unite_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("compte_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("punet_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("montantht_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("montantttc_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("designation_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("pu_"+i).setAutre("readonly");
        }
        String[] order = { "designation","idProduit","idOrigine","unite","unitelib", "pu", "compte", "qte", "remise","punet", "tva","montantht","montantttc" ,"tauxDeChange","idbcfille"};
        pi.getFormufle().setColOrdre(order);

        String[] ids = (String[]) request.getParameterValues("ids");
        System.err.println("==============================>"+ids.length);
        if(ids!=null && ids.length>0) {
            VenteDetailsLib[] ffd = new VenteDetails().getByIdsRelever(ids,null);
            InsertionVente vtd = new InsertionVente().getByIdsRelever(ids,null);
            pi.getFormu().setDefaut(vtd);
            pi.setDefautFille(ffd);
        }else{
            throw new Exception("Veuillez sélectionner au moins un relevé.");
        }

        if(request.getParameter("idBC")!=null && !request.getParameter("idBC").trim().isEmpty())
        {
            BonDeCommande bc = new BonDeCommande();
            bc.setId(request.getParameter("idBC"));
            InsertionVente v = bc.createVente();
            v.setDatyPrevu(null);
            Client c = (Client)new Client().getById(v.getIdClient(),"client",null);
            Calendar cal = Calendar.getInstance();
            cal.setTime(c.getDatecarte());
            cal.add(Calendar.YEAR, 1);
            Date dateCartePlusUnAn = cal.getTime();
            Date dateAujourdhui = new Date();
            carteExpiree = dateAujourdhui.compareTo(dateCartePlusUnAn) >= 0;
            BonDeCommandeFIlleCpl[] details = bc.getFilleBCLib();
            if (details != null && details.length > 0) {
                VenteDetailsLib[] lignes = new VenteDetailsLib[details.length];
                for (int i = 0; i < details.length; i++) {
                    BonDeCommandeFIlleCpl detail = details[i];
                    lignes[i] = detail.createVenteFilleLib();
                }
                pi.setDefautFille(lignes);
            }
            pi.getFormu().setDefaut(v);
            pi.getFormu().getChamp("dateLivraison").setDefaut(Utilitaire.datetostring(v.getDateLivraison()));
            affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id","AS_INGREDIENT_VENTE_LIB","compte_vente;libelle;idunite;idunitelib","compte;designation;unite;unitelib"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"'");
        }

        //Variables de navigation
        String classeMere = "vente.InsertionVente";
        String classeFille = "vente.VenteDetails";
        String butApresPost = "rapprochement/liste-rapprochement.jsp";
        String colonneMere = "idVente";
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

        String titre = "R&egrave;glement client";
        if(request.getParameter("acte")!=null){
            titre = "Modification de la facture client";
        }
%>
<div class="content-wrapper">
    <h1><%= titre %></h1>
    <div class="box-body">
        <form id="formId" class='container' action="<%=pi.getLien()%>?but=rapprochement/apresReglerRelever.jsp" method="post" >
            <%

                out.println(pi.getFormu().getHtmlInsert());
            %>
            <div class="col-md-12" >
                <div class="col-md-12 cardradius">
                    <h3 class="fontinter" style="background: white;padding: 16px;margin-top: 10px;border-radius: 16px;" >Total  : <span id="montanttotal">0</span><span id="deviseLibelle"> Ar</span></h3>
                </div>
                <div id="butfillejsp">
                    <script>
                        <%
                        if(carteExpiree) {
                        %>
                        (function() {
                            if(typeof jQuery === 'undefined') {
                                window.alert('La carte du client est expiré.');
                            } else {
                                if(typeof jAlert === 'undefined') {
                                    alert('La carte du client est expiré.');
                                } else {
                                    jAlert('La carte du client est expiré.', 'Attention');
                                }
                            }
                        })();
                        <%
                        }
                        %>
                    </script>
                    <%
                        out.println(pi.getFormufle().getHtmlTableauInsert());
                    %>
                </div>
                    <% if (ids != null) {
                for (String id : ids) { %>
                <input type="hidden" name="idsRelever" value="<%= id %>">
                    <%  } } %>
                <input name="acte" type="hidden" id="nature" value="credit">
                <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
                <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
                <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
                <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
                <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
                <input name="nomtable" type="hidden" id="nomtable" value="<%= nomtable %>">
        </form>
    </div>
</div>
<script>
    const champ = document.getElementById("echeancefacture");

    document.addEventListener("DOMContentLoaded", function () {
        const champidFournisseur = document.getElementById("idClient");
        const observer = new MutationObserver(function (mutationsList) {
            for (let mutation of mutationsList) {
                if (mutation.type === "attributes" && mutation.attributeName === "value") {
                    console.log("Nouvelle valeur :", champidFournisseur.value);
                    changerValeur();
                    // Ton code ici
                }
            }
        });

        observer.observe(champidFournisseur, { attributes: true });
    });


    champ.addEventListener("input", function () {
        console.log("La valeur a changé :", this.value);
    });

    function sanitizeNumber(str) {
        return parseFloat(str.replace(/\s/g, '').replace(',', '.')) || 0;
    }
    changerValeur();
    function changerValeur() {
        const champDaty = document.getElementById("datyPrevu");

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


</script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        var val = 0;
        $('input[id^="montantttc_"]').each(function() {
            var montant = parseFloat($(this).val().replace(/\s/g, ''));
            if(!isNaN(montant)){
                val += montant;
            }
        });
        $("#montanttotal").html(Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(val));
        const deviseSelect = document.getElementById('idDevise');
        deviseSelect.addEventListener('change', function() {
            const deviseSelectionne = this.value;
            for (let i = 0; i <= 10; i++) {
                const champDevise = document.getElementById('idDevise_' + i);
                if (champDevise) {
                    champDevise.value = deviseSelectionne;
                    if (champDevise.tagName === 'SELECT') {
                        for (let j = 0; j < champDevise.options.length; j++) {
                            if (champDevise.options[j].value === deviseSelectionne) {
                                champDevise.selectedIndex = j;
                                break;
                            }
                        }
                    }
                    const event = new Event('change');
                    champDevise.dispatchEvent(event);
                }
            }
        });
    });
</script>
<script>
    function formatNumber(number) {
        if (isNaN(number)) return '';
        return number.toLocaleString('fr-FR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }

    $(window).on('load', function () {
        let i = 0;
        $('input[id^="montantttc_"]').each(function () {
            let montantht = parseFloat(document.getElementById('montantht_' + i).value.replace(/\s/g, '')) || 0;
            let tva = parseFloat(document.getElementById('tva_' + i).value.replace(/\s/g, '')) || 0;
            this.value = formatNumber(montantht + (montantht * (tva/100)));
            i++;
        });
    });


    // function formatNumber(number) {
    //     return number.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, " ");
    // }
    function calculerMontant(indice) {
        // Récupérer les valeurs des champs
        var pu = parseFloat(document.getElementById('pu_' + indice).value.replace(/\s/g, '')) || 0;
        var qte = parseFloat(document.getElementById('qte_' + indice).value.replace(/\s/g, '')) || 0;
        var remise = parseFloat(document.getElementById('remise_' + indice).value.replace(/\s/g, '')) || 0;
        var tva = parseFloat(document.getElementById('tva_' + indice).value.replace(/\s/g, '')) || 0;

        // Calculer le PU Net (PU après remise)
        var punet = pu - (pu * remise / 100) + ((pu * tva / 100));

        // Calculer le Montant HT
        var montantht = (pu - (pu * remise / 100)) * qte;

        // Calculer le Montant TTC (HT + TVA)
        var montantttc = montantht + (montantht * (tva / 100));

        console.log(montantttc);
        // Mettre à jour les champs calculés
        document.getElementById('pu_' + indice).value = formatNumber(pu);
        document.getElementById('punet_' + indice).value = formatNumber(punet);
        document.getElementById('montantht_' + indice).value = formatNumber(montantht);
        document.getElementById('montantttc_' + indice).value = formatNumber(montantttc);

        var val = 0;
        $('input[id^="montantttc_"]').each(function() {
            var montant = parseFloat($(this).val().replace(/\s/g, ''));
            if(!isNaN(montant)){
                val += montant;
            }
        });
        $("#montanttotal").html(Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(val));
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