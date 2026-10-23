<%-- 
    Document   : bondecommande-saisie
    Created on : 17 juil. 2024, 16:27:57
    Author     : micha
--%>


<%@page import="bean.CGenUtil"%>
<%@page import="affichage.PageUpdateMultiple"%>
<%@page import="vente.*"%>
<%@page import="bean.UnionIntraTable"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="java.util.Calendar"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.PageInsert"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="faturefournisseur.ModePaiement"%>
<%@page import="annexe.Unite"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="proforma.ProformaLib" %>
<%@ page import="proforma.Proforma" %>
<%@ page import="proforma.ProformaDetails" %>
<%@ page import="proforma.ProformaDetailsLib" %>
<%@ page import="client.Client" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="change.TauxDeChange" %>
<%@ page import="magasin.*" %>
<%@ page import="java.sql.Connection" %>
<%
    try{
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    BonDeCommande mere = new BonDeCommande();
    BonDeCommandeFIlleCpl fille = new BonDeCommandeFIlleCpl();
    fille.setNomTable("BONDECOMMANDE_CLIENT_FILLE_V");
    int nombreLigne = 10;
    String idProforma = request.getParameter("idProforma");
    ProformaDetailsLib[] dtl = null;
    BonDeCommande bcProforma = null;

    if (idProforma != null && !idProforma.trim().isEmpty()) {
        Proforma prof = new Proforma();
        prof.setId(idProforma);
        dtl = prof.getFilleProformaLib();
        if (dtl != null && dtl.length >= nombreLigne)nombreLigne = dtl.length+5;
        bcProforma = prof.createBonDeCommande();
    }
    BonDeCommande bcModif = null;
    if ("update".equals(request.getParameter("acte")) && request.getParameter("id") != null && !request.getParameter("id").isEmpty()) {
        bcModif = (BonDeCommande) new BonDeCommande().getById(request.getParameter("id"), "BONDECOMMANDE_CLIENT", null);
    }
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("dateBesoin").setVisible(false);
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("idClient").setLibelle("Client");
    pi.getFormu().getChamp("idClient").setAutre("onchange=\"updateFille(event, 'formId')\"");
    pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idProforma").setAutre("readonly");
//    pi.getFormu().getChamp("fraislivraison").setLibelle("Frais de livraison HT totale");
    pi.getFormu().getChamp("fraislivraison").setVisible(false);
    pi.getFormu().getChamp("montantLivraison").setLibelle("Frais de livraison Totale");
    pi.getFormu().getChamp("montantLivraison").setDefaut("0");

    pi.getFormu().getChamp("idProforma").setLibelle("ID Proforma");
    pi.getFormu().getChamp("modelivraison").setLibelle("Mode de livraison");
    pi.getFormu().getChamp("lieuLivraison").setLibelle("Lieu de livraison");
    pi.getFormu().getChamp("dateLivraison").setLibelle("Date de livraison");
    pi.getFormu().getChamp("idzoneclient").setLibelle("Zone Client");
    pi.getFormu().getChamp("idzoneclient").setPageAppelComplete("client.ZoneClient", "id", "ZONECLIENT","forfait","montantLivraison");
//    pi.getFormu().getChamp("typefraistransport").setDefaut("0");

    Liste[] liste = new Liste[5];
    ModePaiement mp = new ModePaiement();
    liste[0] = new Liste("modepaiement",mp,"val","id");
    //liste[1] = new Liste("idDevise",new caisse.Devise(),"val","id");
    //liste[1].setDefaut("AR");
    //liste[1].setLibelle("Devise");
    //liste[1].setLibelle("Devise");
        Magasin m = new Magasin();
        m.setNomTable("MAGASINVENTE");
    liste[1] = new Liste("idMagasin",m,"val","id");
    liste[1].setLibelle("Magasin");

    Liste listemode = new Liste("modelivraison");

    String [] affVal = new String[2];
    String [] aff = new String[2];
    aff = new String[]{"LIVRAISON","RECUPERATION"};
    affVal = new String[]{"1","2"};

    listemode.ajouterValeur(affVal,aff);
    liste[2] = listemode;
    String[] tarifValue = {"0","1"};
    //String[] tarifLibelle = {"Sans Frais","Frais De Livraison","Tarif De Livraison Uniquement", "Tarif et Frais de Livraison"};
    String[] tarifLibelle = {"Sans Frais","Avec Frais"};
    liste[3] = new Liste("typefraistransport", tarifLibelle, tarifValue);
    liste[4] = new Liste("idDevise",new caisse.Devise(),"val","id");
    liste[4].setDefaut(ConstanteSocobis.Devise);
    liste[4].setLibelle("Devise");

    pi.getFormu().changerEnChamp(liste);
//    pi.getFormu().getChamp("typefraistransport").setLibelle("Type de frais de transport ");
    pi.getFormu().getChamp("typefraistransport").setLibelle("Tarif");
    pi.getFormu().getChamp("idMagasin").setDefaut(ConstanteSocobis.MAGASIN);
//    = {"daty","designation","remarque","reference","idDevise","idMagasin","idClient","commercial","modepaiement"};
        String [] ordre =   {"daty","designation","idProforma","reference","idClient","commercial","idMagasin","idDevise","modepaiement","dateLivraison","modelivraison","lieuLivraison","remarque"};
    pi.getFormu().setOrdre(ordre);
    pi.getFormu().getChamp("idMagasin").setAutre("onchange=\"updateFille(event, 'formId')\"");
    pi.getFormu().getChamp("idDevise").setAutre("onchange=\"updateFille(event, 'formId')\"");
    pi.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
    pi.getFormu().getChamp("modelivraison").setLibelle("Mode de livraison");
      pi.getFormu().getChamp("commercial").setPageAppelComplete("personnel.LogPersonnel","id","LOG_PERSONNEL_COM","id","val");
    //pi.getFormu().getChamp("fournisseur").setPageAppel("choix/fournisseur/fournisseur-choix.jsp","fournisseur;fournisseurlibelle");
    pi.getFormu().getChamp("idClient").setPageAppelComplete("client.ClientLib","id","clientLib_actif" ,"idzoneclient;idzoneclientlib;idModePaiement;forfait","idzoneclient;idzoneclientlibelle;modepaiement;montantLivraison");
    pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientLibelle","id;nom");
    affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("produit"),"produits.IngredientVente","id","AS_INGREDIENT_VENTE_LIB","prixunitaire;compte_vente;libelle;idunite;idunitelib;tva","pu;compte;designation;unite;uniteLib;tva"," AND 1>2");

        String idDevise = ConstanteSocobis.Devise;
        String tauxDevise = "1";
        double tva = 0.0;
        Client clientCourant = null;
        if (request.getParameter("idProforma")!=null || request.getParameter("id")!=null || (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true"))){
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
            }else if(bcProforma != null && bcProforma.getIdClient() != null && !bcProforma.getIdClient().isEmpty() && !"true".equals(request.getParameter("onchanged"))){
                c = (Client)new Client().getById(bcProforma.getIdClient(),"client",null);
                if(c != null){
                    session.setAttribute("idclient", c.getId());
                }
            }else if(session.getAttribute("idclient") != null){
                c = (Client)new Client().getById((String) session.getAttribute("idclient"),"client",null);
            }
            if(c != null){
                tva = c.getTaxe();
            }
            clientCourant = c;
            //if(idmagasin!=null && c!=null){
               // affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("produit"),"produits.IngredientVente","id","AS_INGREDIENT_VENTE_LIB","pu;compte_vente;libelle;idunite;idunitelib","pu;compte;designation;unite;uniteLib"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"' AND IDMAGASIN='"+idmagasin+"'");
            //}
            if(c!=null){
                //affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id","AS_INGREDIENT_VENTE_LIB","pu;compte_vente;libelle;idunite;idunitelib","pu;compte;designation;unite;uniteLib"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"' AND IDMAGASIN='"+idmagasin+"'");
                //affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientVente","id","AS_INGREDIENT_VENTE_LIB","pu;compte_vente;libelle;idunite;idunitelib","pu;compte;designation;unite;uniteLib"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"'");
                String table = "AS_INGREDIENT_VENTE_LIB_PRX";
                if(request.getParameter("idDevise") != null && !request.getParameter("idDevise").isEmpty()){
                    session.setAttribute("idDevise", request.getParameter("idDevise"));
                }
                String deviseChoisie = request.getParameter("idDevise");
                if((deviseChoisie == null || deviseChoisie.isEmpty()) && "true".equals(request.getParameter("onchanged"))){
                    deviseChoisie = (String) session.getAttribute("idDevise");
                }
                if((deviseChoisie == null || deviseChoisie.isEmpty()) && bcProforma != null){
                    deviseChoisie = bcProforma.getIdDevise();
                }
                if (deviseChoisie != null && !deviseChoisie.isEmpty()){
                    idDevise = deviseChoisie;
                    if (idDevise.equals("USD")){
                        table=  "AS_INGREDIENT_VENTE_LIB_USD";
                        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("produit"),"produits.IngredientVente","id",table,"pu;compte_vente;libelle;idunite;idunitelib;tva","pu;compte;designation;unite;uniteLib;tva"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"' and (daty+"+c.getDelai()+") <= SYSDATE ORDER BY daty desc");
                    }
                    if (idDevise.equals("EUR")){
                        table=  "AS_INGREDIENT_VENTE_LIB_EURO";
                        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("produit"),"produits.IngredientVente","id",table,"pu;compte_vente;libelle;idunite;idunitelib;tva","pu;compte;designation;unite;uniteLib;tva"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"' and (daty+"+c.getDelai()+") <= SYSDATE ORDER BY daty desc");
                    }
                    if (idDevise.equals("AR")){
                        table=  "AS_INGREDIENT_VENTE_LIB_PRX";
                        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("produit"),"produits.IngredientVente","id",table,"prixunitaire;compte_vente;libelle;idunite;idunitelib;tva","pu;compte;designation;unite;uniteLib;tva"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"' and (daty+"+c.getDelai()+") <= SYSDATE ORDER BY daty desc");
                    }
                    affichage.Champ.setValeur(pi.getFormufle().getChampFille("idDevise"),idDevise);
                    tauxDevise = String.valueOf(TauxDeChange.getLastTaux(null, null, idDevise));
                }else{
                    affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("produit"),"produits.IngredientVente","id",table,"prixunitaire;compte_vente;libelle;idunite;idunitelib;tva","pu;compte;designation;unite;uniteLib;tva"," AND IDTYPECLIENT='"+c.getIdTypeClient()+"' and (daty+"+c.getDelai()+") <= SYSDATE ORDER BY daty desc");
                }
            }
        }else{
            session.removeAttribute("idMagasin");
            session.removeAttribute("idclient");
            session.removeAttribute("idDevise");
        }
        if (!"true".equals(request.getParameter("onchanged")) && bcModif != null && bcModif.getIdDevise() != null && !bcModif.getIdDevise().isEmpty()) {
            idDevise = bcModif.getIdDevise();
            tauxDevise = String.valueOf(TauxDeChange.getLastTaux(null, null, idDevise));
        }
        if ("true".equals(request.getParameter("onchanged")) && request.getParameter("idDevise") != null && !request.getParameter("idDevise").isEmpty()) {
            idDevise = request.getParameter("idDevise");
            tauxDevise = String.valueOf(TauxDeChange.getLastTaux(null, null, idDevise));
        }
        if (!"true".equals(request.getParameter("onchanged")) && bcModif != null && bcModif.getIdClient() != null && !bcModif.getIdClient().isEmpty()) {
            Client clientModif = (Client) new Client().getById(bcModif.getIdClient(), "client", null);
            String idmagasinModif = bcModif.getIdMagasin();
            if (clientModif != null) {
                tva = clientModif.getTaxe();
                clientCourant = clientModif;
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
                affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("produit"),"produits.IngredientVente","id",table,colonnesRetour,"pu;compte;designation;unite;uniteLib;tva"," AND IDTYPECLIENT='"+clientModif.getIdTypeClient()+"' and (daty+"+clientModif.getDelai()+") <= SYSDATE ORDER BY daty desc");
                session.setAttribute("idclient", clientModif.getId());
                session.setAttribute("idMagasin", idmagasinModif);
                session.setAttribute("idDevise", idDevise);
            }
        }

    //Nommage et visibilite 
        
    for (int i = 0; i < nombreLigne; i++) {
        pi.getFormufle().getChamp("quantite_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("produit_"+i).setAutreHidden("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("remise_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("pu_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("ristourne_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("tva_"+i).setAutre("onChange='calculerMontant("+i+")'");
        //pi.getFormufle().getChamp("tva_"+i).setDefaut("20");
        pi.getFormufle().getChamp("produit_" + i).setLibelle("Produit");
        pi.getFormufle().getChamp("idDevise_"+i).setDefaut("AR");
        pi.getFormufle().getChamp("unite_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("unitelib_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("tva_"+i).setDefaut(tva+"");
        pi.getFormufle().getChamp("punet_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("montantht_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("montantttc_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("idDevise_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("idDevise_"+i).setDefaut(idDevise);
        pi.getFormufle().getChamp("tauxdechange_"+i).setDefaut(tauxDevise);
        //pi.getFormufle().getChamp("pu_"+i).setAutre("readonly");
    }

    //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("produit").getListeChamp(), "produits.IngredientsLib", "id", "as_ingredients_lib", "pv;tva;unite","pu;tva;unite");



    pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
    pi.getFormufle().getChamp("pu_0").setLibelle("Prix Unitaire");
    pi.getFormufle().getChamp("montant_0").setLibelle("Montant");
    pi.getFormufle().getChamp("tva_0").setLibelle("TVA (%)");
    pi.getFormufle().getChamp("remise_0").setLibelle("Remise (%)");
    pi.getFormufle().getChamp("ristourne_0").setLibelle("Ristourne (%)");
    pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
    pi.getFormufle().getChamp("tauxdechange_0").setLibelle("Taux de Change");
    pi.getFormufle().getChamp("punet_0").setLibelle("Prix Unitaire Net");
    pi.getFormufle().getChamp("montantht_0").setLibelle("Montant HT");
    pi.getFormufle().getChamp("montantttc_0").setLibelle("Montant TTC");
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idbc"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("montant"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("ristourne"),false);
    //affichage.Champ.setDefaut(pi.getFormufle().getChampFille("tva"), "20");
//    pi.getFormufle().getChampMulitple("unite").setVisible(false);
    //pi.getFormufle().getChamp("unite_0").setLibelle("Unit&eacute;");
    if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update")) {
        pi.getFormufle().getChamp("unite_0").setLibelle("Unit&eacute;");
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("unitelib"),false);
    } else {
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("unite"),false);
        pi.getFormufle().getChamp("unitelib_0").setLibelle("Unit&eacute;");
    }


    BonDeCommande ocr = (BonDeCommande) session.getAttribute("ocr");
    if(ocr!=null){
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        LocalDate localDate = ocr.getDaty().toLocalDate();
        String formattedDate = localDate.format(formatter);
        pi.getFormu().getChamp("designation").setDefaut(ocr.getDesignation());
        pi.getFormu().getChamp("daty").setDefaut(formattedDate);
        if(ocr.getIdClient()!=null){
            pi.getFormu().getChamp("idClient").setDefaut(ocr.getIdClient());
        }
        if(ocr.getIdMagasin()!=null){
            pi.getFormu().getChamp("idMagasin").setDefaut(ocr.getIdMagasin());
        }
        pi.setDefautFille(ocr.getFille());
    }
    session.removeAttribute("ocr");

        if (idProforma != null && !idProforma.trim().isEmpty()) {
            pi.getFormu().getChamp("idProforma").setDefaut(request.getParameter("idProforma"));
            //pi.getFormu().getChamp("idMagasin").setAutre("disabled");
            Proforma proforma = new Proforma();
            proforma.setId(idProforma);
            proforma = proforma.getProforma(null);
            BonDeCommande bc = bcProforma;
            ProformaDetailsLib[] details = proforma.getFilleProformaLib();
            if (details != null && details.length > 0) {
                BonDeCommandeFIlleCpl[] lignes = new BonDeCommandeFIlleCpl[details.length];
                for (int i = 0; i < details.length; i++) {
                    ProformaDetailsLib detail = details[i];
                    lignes[i] = detail.createBonDeCommandeFilleLib();
                }
                pi.setDefautFille(lignes);
            }
            double montantLivraison = proforma.getMontantLivraison();
            pi.getFormu().setDefaut(bc);
            if(bc.getIdDevise() != null && !bc.getIdDevise().isEmpty()){
                idDevise = bc.getIdDevise();
            }
            pi.getFormu().getChamp("idMagasin").setDefaut(bc.getIdMagasin());
            pi.getFormu().getChamp("idClient").setDefaut(bc.getIdClient());
            pi.getFormu().getChamp("montantLivraison").setDefaut(String.valueOf(montantLivraison));
            pi.getFormu().getChamp("idzoneclient").setDefaut(bc.getIdzoneclient());
        }

        Client clientAdresse = null;
        if ("true".equals(request.getParameter("onchanged"))) {
            clientAdresse = clientCourant;
        } else if (bcModif != null) {
            clientAdresse = clientCourant;
        } else {
            String idClientInit = null;
            if (bcProforma != null) idClientInit = bcProforma.getIdClient();
            else if (ocr != null) idClientInit = ocr.getIdClient();
            if (idClientInit != null && !idClientInit.isEmpty()) {
                clientAdresse = (Client) new Client().getById(idClientInit, "client", null);
            }
            int modeInit = bcProforma != null ? bcProforma.getModelivraison() : 0;
            boolean lieuVide = bcProforma == null || bcProforma.getLieuLivraison() == null || bcProforma.getLieuLivraison().trim().isEmpty();
            if (clientAdresse != null && clientAdresse.getAdresse() != null && lieuVide && (modeInit == 0 || modeInit == 1)) {
                pi.getFormu().getChamp("lieuLivraison").setDefaut(clientAdresse.getAdresse());
            }
        }
        String idClientAdresse = clientAdresse != null && clientAdresse.getId() != null ? clientAdresse.getId() : "";
        String adresseClient = clientAdresse != null && clientAdresse.getAdresse() != null ? clientAdresse.getAdresse() : "";
        adresseClient = adresseClient.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;");
      String[] colOrdre = {"id","produit","designation","unite","unitelib","quantite","pu","remise", "ristourne","punet","tva","montantht","montantttc","idDevise","tauxdechange"};
      pi.getFormufle().setColOrdre(colOrdre);


    //Variables de navigation
    String classeMere = "vente.BonDeCommande";
    String classeFille = "vente.BonDeCommandeFille";
    String butApresPost = "vente/bondecommande/bondecommande-fiche.jsp";
    String colonneMere = "idbc";
    //Preparer les affichages
     pi.preparerDataFormu();
    if (!"true".equals(request.getParameter("onchanged")) && bcModif != null && clientAdresse != null && clientAdresse.getAdresse() != null
            && (bcModif.getLieuLivraison() == null || bcModif.getLieuLivraison().trim().isEmpty())
            && (bcModif.getModelivraison() == 0 || bcModif.getModelivraison() == 1)) {
        pi.getFormu().getChamp("lieuLivraison").setValeur(clientAdresse.getAdresse());
    }
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
       
%>
<div class="content-wrapper">
    <!-- A modifier -->
    <%
        if (request.getParameter("acte")!=null && request.getParameter("acte")!=""){
            out.println("<h1>Modification d&rsquo;un bon de commande client</h1>");
        }else{
            out.println("<h1>Saisie d&rsquo;un bon de commande client</h1>");
        }
    %>
    <!--  -->
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
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
            <input type="hidden" id="adresseClientCourant" data-idclient="<%=idClientAdresse%>" value="<%=adresseClient%>">
            <script>
                (function () {
                    var info = document.getElementById('adresseClientCourant');
                    if (!info) return;
                    var idClient = info.getAttribute('data-idclient');
                    if (typeof window.dernierClientLieuLivraison === 'undefined') {
                        window.dernierClientLieuLivraison = idClient;
                        return;
                    }
                    if (!idClient || idClient === window.dernierClientLieuLivraison) return;
                    window.dernierClientLieuLivraison = idClient;
                    var mode = document.getElementById('modelivraison');
                    var lieu = document.getElementById('lieuLivraison');
                    if (mode && lieu && mode.value === '1') {
                        lieu.value = info.value;
                    }
                })();
            </script>
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
    document.addEventListener('DOMContentLoaded', function() {
        var val = 0;
        $('input[id^="montantttc_"]').each(function() {
            val += parseNombre($(this).val());
        });
        $("#montanttotal").html(formatNumber(val));
        const modeLivraison = document.getElementById('modelivraison');
        if (modeLivraison) {
            modeLivraison.addEventListener('change', function () {
                const info = document.getElementById('adresseClientCourant');
                const lieu = document.getElementById('lieuLivraison');
                if (!lieu) return;
                if (this.value === '1') {
                    lieu.value = info ? info.value : '';
                } else {
                    lieu.value = '';
                }
            });
        }
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

    function parseNombre(valeur) {
        if (valeur === null || valeur === undefined) return 0;
        var n = parseFloat(valeur.toString().replace(/\s/g, '').replace(',', '.'));
        return isNaN(n) ? 0 : n;
    }

    function formatNumber(number) {
        if (number === null || number === undefined || isNaN(number)) return '';
        return Number(number).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, " ");
    }
    function calculerMontant(indice) {
        var champPu = document.getElementById('pu_' + indice);
        if (!champPu) return;
        // Valeurs
        var pu = parseNombre(champPu.value);
        var qte = parseNombre(document.getElementById('quantite_' + indice).value);
        var remise = parseNombre(document.getElementById('remise_' + indice).value);
        var ristourne = parseNombre(document.getElementById('ristourne_' + indice).value);
        var tva = parseNombre(document.getElementById('tva_' + indice).value);

        var puApresRemise = pu - (pu * remise / 100);
        var puNet = puApresRemise - (puApresRemise * ristourne / 100);

        var montantHtNet = puNet * qte;

        var montantTva = montantHtNet * tva / 100;
        var montantTtc = montantHtNet + montantTva;

        // Mise à jour UI
        document.getElementById('punet_' + indice).value = formatNumber(puNet);
        document.getElementById('montantht_' + indice).value = formatNumber(montantHtNet);
        document.getElementById('montantttc_' + indice).value = formatNumber(montantTtc);

        // Total général
        var total = 0;
        $('input[id^="montantttc_"]').each(function () {
            total += parseNombre($(this).val());
        });

        $("#montanttotal").html(formatNumber(total));
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

