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
<%@ page import="utils.*" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="change.TauxDeChange" %>
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

        VenteLib venteModif = null;
        if ("update".equals(request.getParameter("acte")) && request.getParameter("id") != null && !request.getParameter("id").isEmpty()) {
            venteModif = (VenteLib) new VenteLib().getById(request.getParameter("id"), "VENTE_CPL", null);
        }

        if (request.getParameter("idBC") != null && !request.getParameter("idBC").trim().isEmpty()) {
            BonDeCommande b = new BonDeCommande();
            b.setId(request.getParameter("idBC"));
            BonDeCommandeFIlleCpl[] dtl = b.getFilleBCLib();
            if (dtl != null && dtl.length > 10)nombreLigne = dtl.length;
        }

        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));
        Liste[] liste = new Liste[6];
        Magasin m = new Magasin();
        m.setNomTable("MAGASINVENTE");
        liste[0] = new Liste("idMagasin",m,"val","id");
        liste[0].setDefaut(ConstanteStation.idMagasinProduitfini);
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
        String[] tarifValue = {"0","1"};
//        String[] tarifLibelle = {"Sans Frais","Frais De Livraison","Tarif De Livraison Uniquement", "Tarif et Frais de Livraison"};
        String[] tarifLibelle = {"Sans Frais","Avec Frais"};
        liste[4] = new Liste("typefraistransport", tarifLibelle, tarifValue);
        liste[5] = new Liste("idDevise",new caisse.Devise(),"val","id");
        liste[5].setDefaut("AR");
        //new ChampCompte("compte",pi.getFormufle());

        if(request.getParameter("id")!=null && !request.getParameter("id").isEmpty()){
            if(request.getParameter("idClient")!=null && !request.getParameter("idClient").isEmpty()){
                pi.getFormu().getChamp("idClient").setDefaut(request.getParameter("idClient"));
            }

            if(request.getParameter("idPoint")!=null && !request.getParameter("idPoint").isEmpty()){
                pi.getFormu().getChamp("idMagasin").setDefaut(request.getParameter("idPoint"));
            }
        }

        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idMagasin").setAutre("onchange=\"updateFille(event, 'formId')\"");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idOrigine").setVisible(false);
        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        //pi.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
        pi.getFormu().getChamp("referencefact").setLibelle("R&eacute;f&eacute;rence facture");
        pi.getFormu().getChamp("referencefact").setVisible(false);
        pi.getFormu().getChamp("modelivraison").setLibelle("Mode de livraison");
//        pi.getFormu().getChamp("fraislivraison").setLibelle("Frais de livraison Totale");
        pi.getFormu().getChamp("fraislivraison").setVisible(false);
//        pi.getFormu().getChamp("fraislivraison").setDefaut("0");

        pi.getFormu().getChamp("montantLivraison").setLibelle("Frais de livraison Totale");
        pi.getFormu().getChamp("montantLivraison").setDefaut("0");

//        pi.getFormu().getChamp("fraislivraison").setVisible(false);
        pi.getFormu().getChamp("estPrevu").setLibelle("Est Pr&eacutevu");
        pi.getFormu().getChamp("datyPrevu").setLibelle("Date pr&eacute;visionnelle d'encaissement");
        //pi.getFormu().getChamp("designation").setDefaut("Vente particulier du "+utilitaire.Utilitaire.dateDuJour());
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("idClient").setLibelle("Client");
        //pi.getFormu().getChamp("idClient").setPageAppelComplete("client.Client","id","Client_actif","echeance;idzoneclient;idzoneclientlib","echeancefacture;idzoneclient;idzoneclientlibelle");
        pi.getFormu().getChamp("idClient").setPageAppelComplete("client.ClientLib","id","clientLib_actif" ,"echeance;idzoneclient;idzoneclientLib;idModePaiement;forfait","echeancefacture;idzoneclient;idzoneclientlibelle;modepaiement;montantLivraison");

        pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle;echeance;idzoneclient;idzoneclientlib","id;nom;echeancefacture;idzoneclient;idzoneclientlibelle;modepaiement");

        pi.getFormu().getChamp("idClient").setAutre("onchange=\"updateFille(event, 'formId')\"");
        pi.getFormu().getChamp("idDevise").setLibelle("Devise");
        pi.getFormu().getChamp("idDevise").setAutre("onchange=\"updateFille(event, 'formId')\"");
        pi.getFormu().getChamp("echeancefacture").setAutre("onChange='changerValeur()'");
        //i.getFormu().getChamp("echeancefacture").setAutre("readonly");
        pi.getFormu().getChamp("echeancefacture").setLibelle("Ech&eacute;ance facture");
        pi.getFormu().getChamp("idzoneclient").setLibelle("Zone Client");
        pi.getFormu().getChamp("idzoneclient").setPageAppelComplete("client.ZoneClient", "id", "ZONECLIENT","forfait","montantLivraison");
        pi.getFormu().getChamp("commercial").setPageAppelComplete("personnel.LogPersonnel","id","LOG_PERSONNEL_COM","id","val");
        pi.getFormu().getChamp("typefraistransport").setLibelle("Tarif");
//        pi.getFormu().getChamp("typefraistransport").setDefaut("0");

        if(request.getParameter("idclient")!=null){
            pi.getFormu().getChamp("idclient").setDefaut(request.getParameter("idclient"));

        }
        //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"annexe.ProduitLib","id","PRODUIT_LIB_MGA","puVente;puAchat;taux;val;compte;compte","pu;puAchat;tauxDeChange;designation;compte;comptelibelle");
        //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTOVENTE","pv;compte_vente;libelle","pu;compte;designation");
        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id","AS_INGREDIENT_VENTE_LIB","prixunitaire;compte_vente;libelle;idunite;idunitelib;tva","pu;compte;designation;unite;unitelib;tva"," AND 1<2");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idPrevision"),"prevision.Prevision","id","PREVISION","","");
        //affichage.Champ.setAutre(pi.getFormufle().getChampFille("idProduit"),"readonly");
        double tva = 0.0;
        String idDevise = ConstanteSocobis.Devise;
        String tauxDevise = "1";
         String idmagasin = request.getParameter("idMagasin");
        if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
            if(idmagasin == null || idmagasin.isEmpty()){
                idmagasin =ConstanteStation.idMagasinProduitfini;
            }
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
            if(c != null){
                tva = c.getTaxe();
                if(c.getDatecarte() != null){
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(c.getDatecarte());
                    cal.add(Calendar.YEAR, 1);
                    Date dateCartePlusUnAn = cal.getTime();
                    Date dateAujourdhui = new Date();
                    carteExpiree = dateAujourdhui.compareTo(dateCartePlusUnAn) >= 0;
                }
            }
            if(idmagasin!=null && c!=null){
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
                        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id",table,"pu;compte_vente;libelle;idunite;idunitelib;tva","pu;compte;designation;unite;unitelib;tva"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"' and (daty+"+c.getDelai()+") <= SYSDATE  ORDER BY daty desc");
                    }
                    if (idDevise.equals("EUR")){
                        table=  "AS_INGREDIENT_VENTE_LIB_EURO";
                        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id",table,"pu;compte_vente;libelle;idunite;idunitelib;tva","pu;compte;designation;unite;unitelib;tva"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"' and (daty+"+c.getDelai()+") <= SYSDATE  ORDER BY daty desc");
                    }
                    if (idDevise.equals("AR")){
                        table=  "AS_INGREDIENT_VENTE_LIB_PRX";
                        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id",table,"prixunitaire;compte_vente;libelle;idunite;idunitelib;tva","pu;compte;designation;unite;unitelib;tva"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"' and (daty+"+c.getDelai()+") <= SYSDATE  ORDER BY daty desc");
                    }
                    affichage.Champ.setValeur(pi.getFormufle().getChampFille("idDevise"),idDevise);
                    tauxDevise = String.valueOf(TauxDeChange.getLastTaux(null, null, idDevise));
                }else{
                    affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id",table,"prixunitaire;compte_vente;libelle;idunite;idunitelib;tva","pu;compte;designation;unite;unitelib;tva"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"' and (daty+"+c.getDelai()+") <= SYSDATE  ORDER BY daty desc");
                }
            }
        }else{
            session.removeAttribute("idMagasin");
            session.removeAttribute("idclient");
            session.removeAttribute("idDevise");
        }
        if (!"true".equals(request.getParameter("onchanged")) && venteModif != null && venteModif.getIdDevise() != null && !venteModif.getIdDevise().trim().isEmpty()) {
            idDevise = venteModif.getIdDevise().trim();
            tauxDevise = String.valueOf(TauxDeChange.getLastTaux(null, null, idDevise));
        }
        if ("true".equals(request.getParameter("onchanged")) && request.getParameter("idDevise") != null && !request.getParameter("idDevise").isEmpty()) {
            idDevise = request.getParameter("idDevise");
            tauxDevise = String.valueOf(TauxDeChange.getLastTaux(null, null, idDevise));
        }
        if (!"true".equals(request.getParameter("onchanged")) && venteModif != null && venteModif.getIdClient() != null && !venteModif.getIdClient().isEmpty()) {
            Client clientModif = (Client) new Client().getById(venteModif.getIdClient(), "client", null);
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
                affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id",table,colonnesRetour,"pu;compte;designation;unite;unitelib;tva"," AND IDTYPECLIENT='"+clientModif.getIdTypeClient()+"' and (daty+"+clientModif.getDelai()+") <= SYSDATE  ORDER BY daty desc");
                session.setAttribute("idclient", clientModif.getId());
                session.setAttribute("idMagasin", venteModif.getIdMagasin());
                session.setAttribute("idDevise", idDevise);
            }
        }

        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("idPrevision_0").setLibelle("Pr&eacute;vision");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA (En %)");
        pi.getFormufle().getChamp("designation_0").setLibelle("Designation");
        //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("compte"),"mg.cnaps.compta.ComptaCompte","compte","compta_compte","","");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        pi.getFormufle().getChamp("remise_0").setLibelle("Remise (En %)");
        pi.getFormufle().getChamp("ristourne_0").setLibelle("Ristourne (En %)");
        pi.getFormufle().getChamp("idOrigine_0").setLibelle("Origine");

        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix Unitaire Brut");
        pi.getFormufle().getChamp("punet_0").setLibelle("Prix Unitaire Net");
        pi.getFormufle().getChamp("montantht_0").setLibelle("Montant HT");
        pi.getFormufle().getChamp("montantttc_0").setLibelle("Montant TTC");
        pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
        pi.getFormufle().getChampMulitple("idVente").setVisible(false);
        pi.getFormufle().getChampMulitple("id").setVisible(false);
         pi.getFormufle().getChampMulitple("idOrigine").setVisible(false);
        pi.getFormufle().getChampMulitple("puAchat").setVisible(false);
        pi.getFormufle().getChampMulitple("puVente").setVisible(false);
        pi.getFormufle().getChampMulitple("idbcfille").setVisible(false);
        pi.getFormufle().getChamp("tauxDeChange_0").setLibelle("Taux de change");
        pi.getFormufle().getChamp("unitelib_0").setLibelle("Unit&eacute;");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation ");
        pi.getFormu().getChamp("lieuLivraison").setLibelle("Lieu de livraison");
        pi.getFormu().getChamp("dateLivraison").setLibelle("Date de livraison");

        //pi.getFormufle().getChampMulitple("compte").setVisible(false);
        pi.getFormufle().getChampMulitple("unite").setVisible(false);
        if(vente_details!=null && vente_details.length>0){
            pi.setDefautFille(vente_details);
            pi.getFormu().getChamp("idOrigine").setDefaut(request.getParameter("id"));
            pi.getFormu().getChamp("designation").setDefaut("Facturation de la livraison num "+request.getParameter("id"));
        }
        String[] order_form = {"daty","designation","idMagasin","idClient","commercial","remarque","idDevise","estPrevu","datyPrevu","idOrigine","etat","referencefact"};
        pi.getFormu().setOrdre(order_form);

        pi.preparerDataFormu();
        if (!"true".equals(request.getParameter("onchanged")) && venteModif != null) {
            pi.getFormu().getChamp("idDevise").setValeur(idDevise);
        }
        for(int i=0;i<nombreLigne;i++){
           // pi.getFormufle().getChamp("pu_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("qte_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("idProduit_"+i).setAutreHidden("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("pu_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("remise_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("ristourne_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("tva_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("idDevise_"+i).setDefaut("AR");
            //pi.getFormufle().getChamp("compte_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("tva_"+i).setDefaut(tva+"");
            pi.getFormufle().getChamp("unitelib_"+i).setAutre("readonly");
            //pi.getFormufle().getChamp("unite_"+i).setAutre("readonly");
            //pi.getFormufle().getChamp("compte_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("punet_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("montantht_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("montantttc_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("idDevise_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("idDevise_"+i).setDefaut(idDevise);
            pi.getFormufle().getChamp("tauxDeChange_"+i).setDefaut(tauxDevise);
            //pi.getFormufle().getChamp("pu_"+i).setAutre("readonly");
        }
        String[] order = { "idProduit","idOrigine", "designation","unite","unitelib", "pu", "compte", "qte", "remise","ristourne","punet", "tva","montantht","montantttc" ,"idDevise","tauxDeChange","idbcfille","idPrevision"};
        pi.getFormufle().setColOrdre(order);

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
            if(v.getIdDevise() != null && !v.getIdDevise().isEmpty()){
                idDevise = v.getIdDevise();
                tauxDevise = String.valueOf(TauxDeChange.getLastTaux(null, null, idDevise));
                affichage.Champ.setValeur(pi.getFormufle().getChampFille("idDevise"), idDevise);
                affichage.Champ.setValeur(pi.getFormufle().getChampFille("tauxDeChange"), tauxDevise);
            }
            pi.getFormu().getChamp("dateLivraison").setDefaut(Utilitaire.datetostring(v.getDateLivraison()));
            bc = bc.getBonDeCommande(null);
            double montantLivraison = bc.getMontantLivraison();
            pi.getFormu().getChamp("montantLivraison").setDefaut(String.valueOf(montantLivraison));
            String tableBC = "AS_INGREDIENT_VENTE_LIB_PRX";
            String colonnesBC = "prixunitaire;compte_vente;libelle;idunite;idunitelib";
            if (idDevise.equals("USD")) {
                tableBC = "AS_INGREDIENT_VENTE_LIB_USD";
                colonnesBC = "pu;compte_vente;libelle;idunite;idunitelib";
            }
            if (idDevise.equals("EUR")) {
                tableBC = "AS_INGREDIENT_VENTE_LIB_EURO";
                colonnesBC = "pu;compte_vente;libelle;idunite;idunitelib";
            }
            affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id",tableBC,colonnesBC,"pu;compte;designation;unite;unitelib"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"' and (daty+"+c.getDelai()+") <= SYSDATE and rownum = 1 ORDER BY daty desc");
        }

        //Variables de navigation
        String classeMere = "vente.InsertionVente";
        String classeFille = "vente.VenteDetails";
        String butApresPost = "vente/vente-fiche.jsp";
        String colonneMere = "idVente";
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

        String titre = "Enregistrement d'une facture client";
        if(request.getParameter("acte")!=null){
            classeMere = "vente.Vente";
            titre = "Modification de la facture client";
        }
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
                    <h3 class="fontinter" style="background: white;padding: 16px;margin-top: 10px;border-radius: 16px;" >Total  : <span id="montanttotal">0</span><span id="deviseLibelle"> <%=idDevise%></span></h3>
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
            val += parseNombre($(this).val());
        });
        $("#montanttotal").html(formatNumber(val));
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
    $(document).ready(function () {
    var lignes = <%=pi.getNombreLigne()%>
    for (let i = 0; i < lignes; i++) {
        calculerMontant(i);
    }
    });
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
    function formatNumber(number) {
        if (number === null || number === undefined || isNaN(number)) return '';
        return Number(number).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, " ");
    }

    $(window).on('load', function () {
        let i = 0;
        $('input[id^="montantttc_"]').each(function () {
            let montantht = parseNombre(document.getElementById('montantht_' + i).value);
            let tva = parseNombre(document.getElementById('tva_' + i).value);
            this.value = formatNumber(montantht + (montantht * (tva/100)));
            i++;
        });
    });


    // function formatNumber(number) {
    //     return number.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, " ");
    // }
    function parseNombre(valeur) {
        if (valeur === null || valeur === undefined) {
            return 0;
        }
        valeur = valeur
            .toString()
            .replace(/\s/g, '')   // Supprime les espaces
            .replace(',', '.');   // Remplace la virgule décimale
        return parseFloat(valeur) || 0;
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
        var puApresRistourne = puApresRemise - (puApresRemise * ristourne / 100);
        var punet = puApresRistourne;
        var montantht = puApresRistourne * qte;
        var montantttc = montantht + (montantht * tva / 100);
        document.getElementById('punet_' + indice).value = formatNumber(punet);
        document.getElementById('montantht_' + indice).value = formatNumber(montantht);
        document.getElementById('montantttc_' + indice).value = formatNumber(montantttc);
        var val = 0;
        $('input[id^="montantttc_"]').each(function () {
            var montant = parseNombre($(this).val());
            if (!isNaN(montant)) {
                val += montant;
            }
        });
        $("#montanttotal").html(formatNumber(val));
    }
    var dateEcheanceInitiale = null;
    document.getElementById("modepaiement").addEventListener("change", function () {
        calculerDateEcheance();
    });
    function calculerDateEcheance() {
        var select = document.getElementById("modepaiement");
        var inputDate = document.getElementById("datyPrevu");
        if (dateEcheanceInitiale === null) {
            dateEcheanceInitiale = inputDate.value;
        }
        var texte = select.options[select.selectedIndex].text;
        var match = texte.match(/\b\d+\b(?!\s*%)/);
        if (!match) {
            inputDate.value = dateEcheanceInitiale;
            return;
        }
        var nbJours = parseInt(match[0], 10);
        var parts = dateEcheanceInitiale.split("/");
        if (parts.length !== 3) {
            return;
        }
        var date = new Date(
            parseInt(parts[2], 10),
            parseInt(parts[1], 10) - 1,
            parseInt(parts[0], 10)
        );
        date.setDate(date.getDate() + nbJours);
        var jour = ("0" + date.getDate()).slice(-2);
        var mois = ("0" + (date.getMonth() + 1)).slice(-2);
        var annee = date.getFullYear();
        inputDate.value = jour + "/" + mois + "/" + annee;
    }
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

