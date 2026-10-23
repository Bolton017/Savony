
<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 05/08/2025
  Time: 11:44
  To change this template use File | Settings | File Templates.
--%>

<%@page import="utils.ConstanteSocobis"%>
<%@page import="magasin.Magasin"%>
<%@page import="vente.*"%>
<%@page import="user.*"%>
<%@page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="client.Client" %>
<%@ page import="proforma.Proforma" %>
<%@ page import="proforma.ProformaDetails" %>
<%@ page import="proforma.ProformaDetailsLib" %>
<%@ page import="change.TauxDeChange" %>
<%
    try{
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        PageInsertMultiple pi=null;
        Proforma mere = new Proforma();
        ProformaDetailsLib fille = new ProformaDetailsLib();
        fille.setNomTable("PROFORMA_DETAILS_VIDE");
        int nombreLigne = 10;
        pi = new PageInsertMultiple(mere,fille,request, nombreLigne,u);
        Proforma prerempli = null;

        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
//        pi.getFormu().getChamp("fraislivraison").setLibelle("Frais de Livraison(Par Kg)");
//        pi.getFormu().getChamp("fraislivraison").setDefaut("0");
        pi.getFormu().getChamp("fraislivraison").setVisible(false);

        pi.getFormu().getChamp("montantLivraison").setLibelle("Tarif de la zone");
        pi.getFormu().getChamp("montantLivraison").setDefaut("0");

        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idClient").setLibelle("Client");
        pi.getFormu().getChamp("idClient").setPageAppelComplete("client.ClientLib","id","clientLib_actif" ,"idzoneclient;idzoneclientlib;forfait","idzoneclient;idzoneclientlibelle;montantLivraison");
        pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle","id;nom");
        pi.getFormu().getChamp("idClient").setAutre("onchange=\"updateFille(event, 'formId')\"");

        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("idMagasin").setLibelle("Point");
        //pi.getFormu().getChamp("idorigine").setLibelle("ID Origine");
        pi.getFormu().getChamp("idorigine").setVisible(false);
        pi.getFormu().getChamp("datyPrevu").setVisible(false);
        pi.getFormu().getChamp("remise").setVisible(false);
        pi.getFormu().getChamp("tva").setVisible(false);
        pi.getFormu().getChamp("echeance").setVisible(false);
        pi.getFormu().getChamp("reglement").setVisible(false);
        pi.getFormu().getChamp("estPrevu").setVisible(false);
        pi.getFormu().getChamp("dateValidite").setVisible(false);
        pi.getFormu().getChamp("dateValidite").setDefaut(utilitaire.Utilitaire.dateDuJour());
        pi.getFormu().getChamp("nbJour").setLibelle("Validit&eacute; (en Jour)");
        pi.getFormu().getChamp("nbJour").setDefaut("30");

//        if(request.getParameter("idDmd")!=null && !request.getParameter("idDmd").isEmpty()){
//            String idDmd = request.getParameter("idDmd");
//            DmdPrix demandePrix = new DmdPrix();
//            prerempli = (Proforma) demandePrix.genererProforma(idDmd, null);
//
//        }
//        ProformaDetails[] detFille = null;
//        if(request.getParameter("id")!=null && !request.getParameter("id").isEmpty()){
//            Proforma pro = new Proforma();
//            pro.setId(request.getParameter("id"));
//            prerempli = (Proforma) pro.getProforma(null);
//            if(prerempli!=null){
//                ProformaDetails [] temp = (ProformaDetails[]) prerempli.getFilleProforma();
//                detFille = new ProformaDetails[temp.length-1];
//                for (int i = 0; i < temp.length; i++) {
//                    if(temp[i].getIdProduit().compareToIgnoreCase(ConstanteLocation.id_produit_caution)!=0){
//                        detFille[i] = temp[i];
//                    }
//                }
//                prerempli.setIdOrigine(request.getParameter("id"));
//            }
//        }

        String idDevis = request.getParameter("idDevis");
       /*if(idDevis != null && !idDevis.isEmpty()){
            Devis devis = new Devis();
            devis.setId(idDevis);
            prerempli = (Proforma) devis.genererProforma(idDevis, null);
        }*/

        Liste[] liste = new Liste[4];
        Magasin m = new Magasin();
        m.setNomTable("MAGASINVENTE");
        liste[0] = new Liste("idMagasin",m,"val","id");
        //liste[0].setDefaut(ConstanteSocobis.MAGASIN);
        liste[1] = new Liste("idDevise",new caisse.Devise(),"val","id");
        String[] tarifValue = {"0","1","2","3"};
        String[] tarifLibelle = {"Sans Frais","Avec Frais"};
        liste[2] = new Liste("typefraistransport", tarifLibelle, tarifValue);
        Liste listeS = new Liste("checkStock");
        listeS.makeListeOuiNon();
        liste[3] = listeS;
        listeS.setDefaut("1");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idMagasin").setAutre("onchange=\"updateFille(event, 'formId')\"");
        pi.getFormu().getChamp("idDevise").setAutre("onchange=\"updateFille(event, 'formId')\"");
        pi.getFormu().getChamp("idMagasin").setDefaut(ConstanteSocobis.MAGASIN);
        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pi.getFormu().getChamp("checkStock").setLibelle("Check stock");
        pi.getFormu().getChamp("idReservation").setVisible(false);

        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("pu_0").setLibelle("PU Brut");
        pi.getFormufle().getChamp("iddemandeprixfille_0").setLibelle("Demande de prix");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA (%)");
        //pi.getFormufle().getChamp("remise_0").setLibelle("Remise");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        //pi.getFormufle().getChamp("unite_0").setVisible(false);
        pi.getFormufle().getChamp("unitelib_0").setLibelle("Unit&eacute;");
        pi.getFormufle().getChamp("remise_0").setLibelle("Remise (%)");
        pi.getFormufle().getChamp("ristourne_0").setLibelle("Ristourne (%)");
        pi.getFormufle().getChamp("punet_0").setLibelle("PU Net");
        pi.getFormufle().getChamp("montantht_0").setLibelle("Montant HT");
        pi.getFormufle().getChamp("montantttc_0").setLibelle("Montant TTC");
        pi.getFormufle().getChampMulitple("datedebut").setVisible(false);

        pi.getFormu().getChamp("idDevise").setLibelle("Devise");
        pi.getFormufle().getChamp("tauxdechange_0").setLibelle("Taux de change");
        pi.getFormu().getChamp("idDevise").setDefaut(ConstanteSocobis.Devise);
        pi.getFormu().getChamp("idzoneclient").setLibelle("Zone client");
        pi.getFormu().getChamp("idzoneclient").setPageAppelComplete("client.ZoneClient", "id", "ZONECLIENT","forfait","montantLivraison");
        pi.getFormu().getChamp("typefraistransport").setLibelle("Tarif");
        pi.getFormu().getChamp("typefraistransport").setDefaut("3");

        //pi.getFormufle().getChampMulitple("remise").setVisible(false);
        //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id","AS_INGREDIENT_VENTE_LIB","prixunitaire;compte_vente;libelle;idunite","pu;compte;designation;unite");
        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id","AS_INGREDIENT_VENTE_LIB","prixunitaire;compte_vente;libelle;idunite;idunitelib;tva","pu;compte;designation;unite;uniteLib;tva"," AND 1>2");
        String idDevise = ConstanteSocobis.Devise;
        String tauxDevise = "1";
        Proforma proformaModif = null;
        if ("update".equals(request.getParameter("acte")) && request.getParameter("id") != null && !request.getParameter("id").isEmpty()) {
            proformaModif = (Proforma) new Proforma().getById(request.getParameter("id"), "PROFORMA", null);
        }
        double tva = 0.0;
        if (request.getParameter("id")!=null || (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true"))){
            String idmagasin = request.getParameter("idMagasin");
            if(request.getParameter("idMagasin") != null && !request.getParameter("idMagasin").isEmpty()){
                session.setAttribute("idMagasin", request.getParameter("idMagasin"));
            }
            if(idmagasin == null || idmagasin.isEmpty()){
                idmagasin = (String) session.getAttribute("idMagasin");
            }
            Client c = null;
            String libClient = request.getParameter("idClientlibelle");
            if(libClient != null && libClient.split(" - ").length > 1){
                String idclient = libClient.split(" - ")[0];
                c = (Client)new Client().getById(idclient,"client",null);
                if(c != null){
                    session.setAttribute("idclient", idclient);
                }
            }else if(session.getAttribute("idclient") != null){
                c = (Client)new Client().getById((String) session.getAttribute("idclient"),"client",null);
            }
            if(c!=null){
                tva = c.getTaxe();
                //affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id","AS_INGREDIENT_VENTE_LIB","prixunitaire;compte_vente;libelle;idunite;idunitelib","pu;compte;designation;unite;uniteLib"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"' AND IDMAGASIN='"+idmagasin+"'");
                String table = "AS_INGREDIENT_VENTE_LIB_PRX";
                if(request.getParameter("idDevise") != null && !request.getParameter("idDevise").isEmpty()){
                    session.setAttribute("idDevise", request.getParameter("idDevise"));
                }
                String deviseChoisie = request.getParameter("idDevise");
                if(deviseChoisie == null || deviseChoisie.isEmpty()){
                    deviseChoisie = (String) session.getAttribute("idDevise");
                }
                if (deviseChoisie != null && !deviseChoisie.isEmpty()){
                    idDevise = deviseChoisie;
                    if (idDevise.equals("USD")){
                        table=  "AS_INGREDIENT_VENTE_LIB_USD";
                        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id",table,"pu;compte_vente;libelle;idunite;idunitelib;tva","pu;compte;designation;unite;uniteLib;tva"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"' and (daty+"+c.getDelai()+") <= SYSDATE ORDER BY daty desc");
                    }
                    if (idDevise.equals("EUR")){
                        table=  "AS_INGREDIENT_VENTE_LIB_EURO";
                        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id",table,"pu;compte_vente;libelle;idunite;idunitelib;tva","pu;compte;designation;unite;uniteLib;tva"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"' and (daty+"+c.getDelai()+") <= SYSDATE ORDER BY daty desc");
                    }
                    if (idDevise.equals("AR")){
                        table=  "AS_INGREDIENT_VENTE_LIB_PRX";
                        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id",table,"prixunitaire;compte_vente;libelle;idunite;idunitelib;tva","pu;compte;designation;unite;uniteLib;tva"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"' and (daty+"+c.getDelai()+") <= SYSDATE ORDER BY daty desc");
                    }
                    affichage.Champ.setValeur(pi.getFormufle().getChampFille("idDevise"),idDevise);
                    tauxDevise = String.valueOf(TauxDeChange.getLastTaux(null, null, idDevise));
                }else{
                    affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id",table,"prixunitaire;compte_vente;libelle;idunite;idunitelib;tva","pu;compte;designation;unite;uniteLib;tva"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"' and (daty+"+c.getDelai()+") <= SYSDATE ORDER BY daty desc");
                }
//                pi.getFormu().getChamp("idzoneclient").set;
            }
        }else{
            session.removeAttribute("idMagasin");
            session.removeAttribute("idclient");
            session.removeAttribute("idDevise");
        }
        if (!"true".equals(request.getParameter("onchanged")) && proformaModif != null && proformaModif.getIdDevise() != null && !proformaModif.getIdDevise().isEmpty()) {
            idDevise = proformaModif.getIdDevise();
            tauxDevise = String.valueOf(TauxDeChange.getLastTaux(null, null, idDevise));
        }
        if ("true".equals(request.getParameter("onchanged")) && request.getParameter("idDevise") != null && !request.getParameter("idDevise").isEmpty()) {
            idDevise = request.getParameter("idDevise");
            tauxDevise = String.valueOf(TauxDeChange.getLastTaux(null, null, idDevise));
        }
        if (!"true".equals(request.getParameter("onchanged")) && proformaModif != null && proformaModif.getIdClient() != null && !proformaModif.getIdClient().isEmpty()) {
            Client clientModif = (Client) new Client().getById(proformaModif.getIdClient(), "client", null);
            String idmagasinModif = proformaModif.getIdMagasin();
            if (clientModif != null) {
                tva = clientModif.getTaxe();
                String table = "AS_INGREDIENT_VENTE_LIB_PRX";
                String colonnesRetour = "prixunitaire;compte_vente;libelle;idunite;idunitelib;tva";
                if (idDevise.equals("USD")) {
                    table = "AS_INGREDIENT_VENTE_LIB_USD";
                    colonnesRetour = "pu;compte_vente;libelle;idunite;idunitelib;tva";
                }
                if (idDevise.equals("EUR")) {
                    table = "AS_INGREDIENT_VENTE_LIB_EURO";
                    colonnesRetour = "pu;compte_vente;libelle;idunite;idunitelib;tva";
                }
                affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id",table,colonnesRetour,"pu;compte;designation;unite;uniteLib;tva"," AND IDTYPECLIENT='"+clientModif.getIdTypeClient()+"' and (daty+"+clientModif.getDelai()+") <= SYSDATE ORDER BY daty desc");
                session.setAttribute("idclient", clientModif.getId());
                session.setAttribute("idMagasin", idmagasinModif);
                session.setAttribute("idDevise", idDevise);
            }
        }

        for (int i = 0; i < pi.getNombreLigne(); i++) {
            pi.getFormufle().getChamp("qte_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("idProduit_"+i).setAutreHidden("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("pu_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("remise_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("ristourne_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("tva_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("id_"+i).setAutre("readonly");
            //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"annexe.ProduitLib","id","PRODUIT_LIB","id;puVente;desce","id;pu;designation");
            pi.getFormufle().getChamp("iddemandeprixfille_"+i).setAutre("readonly");
            //pi.getFormufle().getChamp("unite_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("unitelib_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("compte_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("punet_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("montantht_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("montantttc_"+i).setAutre("readonly");
//            pi.getFormufle().getChamp("pu_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("tva_"+i).setDefaut(tva+"");
            pi.getFormufle().getChamp("iddevise_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("iddevise_"+i).setDefaut(idDevise);
            pi.getFormufle().getChamp("tauxdechange_"+i).setDefaut(tauxDevise);
            //pi.getFormufle().getChamp("tva_"+i).setAutre("readonly");
        }

        affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idDemandePrixFille"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idProforma"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idOrigine"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("puAchat"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("puVente"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("puRevient"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("compte"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("unite"),false);
        //affichage.Champ.setVisible(pi.getFormufle().getChampFille("tva"),false);
        //affichage.Champ.setVisible(pi.getFormufle().getChampFille("remise"),false);

        String[] colOrdre = {"idProduit","designation","unitelib", "qte", "pu","remise", "ristourne","punet","tva","montantht","montantttc","unite","idDevise", "tauxdechange", "iddemandeprixfille", "compte","datedebut"};
        pi.getFormufle().setColOrdre(colOrdre);

        pi.preparerDataFormu();
        if (!"true".equals(request.getParameter("onchanged")) && proformaModif != null) {
            ProformaDetailsLib[] detailsModif = proformaModif.getFilleProformaLib();
            if (detailsModif != null) {
                for (int i = 0; i < pi.getNombreLigne(); i++) {
                    String idLigne = pi.getFormufle().getChamp("id_" + i).getValeur();
                    if (idLigne == null || idLigne.isEmpty()) continue;
                    for (ProformaDetailsLib detail : detailsModif) {
                        if (idLigne.equals(detail.getId())) {
                            pi.getFormufle().getChamp("unitelib_" + i).setValeur(detail.getUniteLib());
                            break;
                        }
                    }
                }
            }
        }

        //Variables de navigation
        String classeMere = "proforma.Proforma";
        String classeFille = "proforma.ProformaDetails";
        String butApresPost = "vente/proforma/proforma-fiche.jsp";
        String colonneMere = "idProforma";

        String[] ordre =  {"daty","designation","idClient","idmagasin","iddevise","remarque"};;
        pi.getFormu().setOrdre(ordre);

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
        String titre = "Saisie d'un Proforma";
        if(request.getParameter("acte")!=null){
            titre = "Modification d'un Proforma";
        }
%>
<div class="content-wrapper">
    <h1><%= titre %></h1>
    <form id="formId"  class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >

        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <div class="col-md-12 cardradius">
            <h3 class="fontinter" style="background: white;padding: 16px;margin-top: 10px;border-radius: 16px;" >Total  : <span id="montanttotal">0</span><span id="deviseLibelle"> <%=idDevise%></span></h3>
        </div>
        <div id="butfillejsp">
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
            <input type="hidden" id="tauxDeviseCourant" data-devise="<%=idDevise%>" value="<%=tauxDevise%>">
            <script>
                (function () {
                    var info = document.getElementById('tauxDeviseCourant');
                    if (!info) return;
                    var devise = info.getAttribute('data-devise');
                    if (typeof window.deviseTauxApplique === 'undefined') {
                        window.deviseTauxApplique = devise;
                        return;
                    }
                    if (devise === window.deviseTauxApplique) return;
                    window.deviseTauxApplique = devise;
                    if (typeof indicesLignes !== 'function') return;
                    indicesLignes().forEach(function (i) {
                        setValeurChamp('idDevise_' + i, devise);
                        setValeurChamp('tauxDeChange_' + i, info.value);
                        setValeurChamp('tauxdechange_' + i, info.value);
                        calculerMontant(i);
                    });
                    $("#deviseLibelle").html(' ' + devise);
                })();
            </script>
        </div>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
    </form>

</div>
<script>
    $(document).ready(function () {
        var lignes = <%=pi.getNombreLigne()%>
        for (let i = 0; i < lignes; i++) {
            calculerMontant(i);
        }
    });

</script>

<script>
    function parseNombre(valeur) {
        if (valeur === null || valeur === undefined) return 0;
        var n = parseFloat(valeur.toString().replace(/\s/g, '').replace(',', '.'));
        return isNaN(n) ? 0 : n;
    }

    function formatNumber(number) {
        if (number === null || number === undefined || isNaN(number)) return '';
        return Number(number).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, " ");
    }
    function indicesLignes() {
        var indices = [];
        $('#ajout_multiple_ligne tr[id^="ligne-multiple-"]').each(function () {
            var n = parseInt(this.id.replace('ligne-multiple-', ''), 10);
            if (!isNaN(n)) indices.push(n);
        });
        return indices;
    }
    function setValeurChamp(id, valeur) {
        var champ = document.getElementById(id);
        if (champ) champ.value = valeur;
    }
    function calculerMontant(indice) {
        var champPu = document.getElementById('pu_' + indice);
        if (!champPu) return;

        var pu = parseNombre(champPu.value);
        var qte = parseNombre(document.getElementById('qte_' + indice).value);
        var remise = parseNombre(document.getElementById('remise_' + indice).value);
        var ristourne = parseNombre(document.getElementById('ristourne_' + indice).value);
        var tva = parseNombre(document.getElementById('tva_' + indice).value);

        var puApresRemise = pu - (pu * remise / 100);
        var puNet = puApresRemise - (puApresRemise * ristourne / 100);

        var htFinal = puNet * qte;

        var montantTVA = htFinal * tva / 100;
        var montantTTC = htFinal + montantTVA;

        document.getElementById('punet_' + indice).value = formatNumber(puNet);
        document.getElementById('montantht_' + indice).value = formatNumber(htFinal);
        document.getElementById('montantttc_' + indice).value = formatNumber(montantTTC);

        var total = 0;
        $('input[id^="montantttc_"]').each(function () {
            total += parseNombre($(this).val());
        });

        $("#montanttotal").html(formatNumber(total));
    }
    document.addEventListener('DOMContentLoaded', function() {
        const deviseSelect = document.getElementById('idDevise');
        function appliquerDevise(deviseSelectionne) {
            $("#deviseLibelle").html(' ' + deviseSelectionne);
            for (let i = 0; i < <%=pi.getNombreLigne()%>; i++) {
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
        }
        if (deviseSelect) {
            appliquerDevise(deviseSelect.value);
            deviseSelect.addEventListener('change', function() {
                appliquerDevise(this.value);
            });
        }
    });
</script>

<script>
    $(function () {
        $("#idClientsearchBtn").on("mousedown", function (e) { e.preventDefault(); });
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



