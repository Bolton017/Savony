<%--
    Document   : vente-saisie
    Created on : 22 mars 2024, 14:37:44
    Author     : Angela
--%>
<%@ page import="client.Client" %>
<%@ page import="vente.Vente" %>
<%@ page import="vente.InsertionVente" %>
<%@ page import="user.UserEJB" %>
<%@ page import="vente.VenteDetails" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="java.util.List" %>
<%@ page import="affichage.Liste" %>
<%@ page import="annexe.Unite" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="personnel.Personnel" %>
<%@ page import="paie.employe.EmployeComplet" %>
<%@ page import="vente.VenteDetailsLib" %>
<%@ page import="java.io.IOException" %>
<%@ page import="magasin.Magasin" %>


<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");

        String classeMere = "vente.VentePaiement";
        String classeFille = "vente.VenteDetails";
        String butApresPost = "vente/vente-saisie-directe-apj.jsp";
        String colonneMere = "idVente";
        String nombreLigne = "1";
        int nbl = 1;
        String lien =(String) session.getValue("lien");

        String idPoint = (String)session.getAttribute("idPoint");
        Client client = new Client();
        client.setIdPoint(idPoint);
        client.clientPoint();
        Magasin mag = u.getMagasinEncoursVente();

        String idMagasin = mag.getId();


//        String currentPoint = session.getAttribute("idPoint").toString();
//        CaisseSession sessionCaisse = new CaisseSession();
//        sessionCaisse.setIdPoint(currentPoint);
//        int isExist = sessionCaisse.checkIfSessionOuverteExistePourPoint();
//        if(isExist==0) {
//            throw new IOException("Vous devez effectuer une ouverture de caisse avant de faire une vente");
//        }


        String idClient = "CLI000576";
        String nomClient = "Client Divers";

        if(client.getId()!=null){
            idClient = client.getId();
            nomClient = client.getNom();
        }

        String idReponsable = u.getUser().getTuppleID();
        String nomResponsable = u.getUser().getNomuser();

        Vente mere = new InsertionVente();
        mere.setNomTable("INSERTION_VENTE_PERSONNEL_VIDE");
        VenteDetailsLib fille = new VenteDetailsLib();
        fille.setNomTable("VENTEDETAILS_POS_STANDARD_SAV");
        Vente res = new Vente();
        VenteDetails[] vente_details = null;
        String titre = "Enregistrement d'une vente compl&egrave;te";

        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nbl, u);
        pi.setLien((String) session.getValue("lien"));
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTOVENTE_MGA2","pv;compte_vente;libelleComposant;codebarre;taux;photo;reference;unite","pu;compte;designation;codebarre;tauxDeChange;photo;reference;unite");
//        Liste[] listes = new Liste[1];
//        Personnel personnel = new Personnel();
////        TypeObjet tp = new TypeObjet();remiseMontant_0
////        tp.setNomTable("AS_UNITE");
//        listes[0] = new Liste("idResponsable", personnel,"nom","id");
//        pi.getFormu().changerEnChamp(listes);

        pi.getFormu().getChamp("idMagasin").setDefaut(idMagasin);

        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("designation").setVisible(false);
        pi.getFormu().getChamp("idMagasin").setVisible(false);
        pi.getFormu().getChamp("daty").setVisible(false);
        // ID CLIENT
        pi.getFormu().getChamp("idClient").setLibelle("Client");
        pi.getFormu().getChamp("idResponsable").setLibelle("Responsable");
        pi.getFormu().getChamp("nomClientDivers").setVisible(false);
        pi.getFormu().getChamp("idResponsable").setPageAppelComplete("budget.UtilisateurService","refuserStr","UTILISATEURSTR");
//        pi.getFormu().getChamp("idResponsable").setVisible(false);
//        pi.getFormu().getChamp("idResponsable").setAutocompleteDynamique("personnel.Personnel","nom","id","Personnel");
        pi.getFormu().getChamp("idClient").setAutocompleteDynamique("client.Client","nom","id","Client");
        pi.getFormu().getChamp("idClient").setPageAppelInsert("vente/vente-client-divers-saisie.jsp", "idClient;idClientlibelle", "id;nom");
//        pi.getFormu().getChamp("idClient").setDefaut(idClient);ST_INGREDIENTSAUTOVENTE_MGA2
        // INVISIBLE: Remarque , Etat, Origine, IdDevise
        pi.getFormu().getChamp("remarque").setVisible(false);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idOrigine").setVisible(false);
        pi.getFormu().getChamp("idDevise").setVisible(false);
        pi.getFormu().getChamp("estPrevu").setVisible(false);
        pi.getFormu().getChamp("datyPrevu").setVisible(false);
        pi.getFormu().getChamp("idCommercial").setVisible(false);
        pi.getFormu().getChamp("idmodepaiement").setVisible(false);
        pi.getFormu().getChamp("remise").setVisible(false);
        pi.getFormu().getChamp("remiseMontant").setVisible(false);
        pi.getFormu().getChamp("heureSaisie").setVisible(false);

        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("montantttc_0").setLibelle("Montant TTC");
//        pi.getFormufle().getChamp("montant_0").setLibelle("Montant");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        pi.getFormufle().getChamp("designation_0").setLibelle("Article");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        pi.getFormufle().getChamp("remise_0").setLibelle("Remise en %");
        pi.getFormufle().getChamp("ristourne_0").setLibelle("Ristourne en %");
        pi.getFormufle().getChamp("remiseMontant_0").setLibelle("Remise en Montant");
        pi.getFormufle().getChamp("idOrigine_0").setLibelle("Origine");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("photo_0").setLibelle("Image");
//        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("pu_0").setLibelle("Montant Sans TVA");
        pi.getFormufle().getChamp("pu_0").setVisible(false);
        pi.getFormufle().getChamp("reference_0").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormufle().getChamp("unite_0").setLibelle("Unit&eacute;");
        pi.getFormufle().getChamp("tauxDeChange_0").setLibelle("Taux de change");
        pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("pu"),"onChange='updateTotals()' readonly");
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("pu"),false);
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("qte"),"onChange='updateTotals()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("remiseMontant"),"onChange='updateTotals()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("compte"),"readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("tauxDeChange"),"readonly");
//        affichage.Champ.setAutre(pi.getFormufle().getChampFille("montant"),"readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("designation"),"readonly");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("tauxDeChange"),"1");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("idDevise"),"Ar");

        pi.getFormufle().getChampMulitple("compte").setVisible(false);
        pi.getFormufle().getChampMulitple("idDevise").setVisible(false);
        pi.getFormufle().getChampMulitple("tauxDeChange").setVisible(false);
        pi.getFormufle().getChampMulitple("remise").setVisible(false);
        pi.getFormufle().getChampMulitple("remiseMontant").setVisible(false);
        pi.getFormufle().getChampMulitple("reference").setVisible(false);
        pi.getFormufle().getChampMulitple("tva").setVisible(false);

        pi.getFormufle().getChampMulitple("idVente").setVisible(false);
        pi.getFormufle().getChampMulitple("montant").setVisible(false);
        pi.getFormufle().getChampMulitple("idProduit").setVisible(false);
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("ristourne").setVisible(false);
        pi.getFormufle().getChampMulitple("IdOrigine").setVisible(false);
        pi.getFormufle().getChampMulitple("puAchat").setVisible(false);
        pi.getFormufle().getChampMulitple("puVente").setVisible(false);
        pi.getFormufle().getChampMulitple("unite").setVisible(false);
//        pi.getFormufle().getChampMulitple("photo").setVisible(false);
        pi.preparerDataFormu();

        String[] ordreFille = new String[]{"photo", "idProduit", "designation", "pu","montantttc", "qte"};
        pi.getFormufle().setColOrdre(ordreFille);
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<link href="${pageContext.request.contextPath}/assets/css/vente-directe.css" rel="stylesheet" type="text/css" />
<div class="vd-header">
    <img src="${pageContext.request.contextPath}/assets/img/logo_A.png" alt="logo" id="site-logo">
    <div class="form-input w-100">
        <%--        CHANGE STE--%>
        <input value="" class="form-control ui-autocomplete-input ui-autocomplete-loading" id="idProduit_libelle" type="text"
               oninput="autoCompleteVenteDirect('idProduit_libelle','ST_INGVENTEPOS_STANDARD_SAV','produits.IngredientsPos',
  'photo;libelle;reference;quantite=1;pvTva;pv;codegros;pvgros;remise=0;prix=0;unite;compte_vente;codeBarre;tva;montantttc',
  'photo;designation;reference;qte;pvTva;pu;codegros;pu_pvgros;montantremise;prix;unite;compte;codeBarre;tva;montantttc','id')"
        />
        <input value='' class='form-control' id='idProduit' name='idProduit' type='hidden'/>
    </div>
    <div class="d-flex gap-2">
        <a class="btn btn-tertiary" href="${pageContext.request.contextPath}/pages/module.jsp?but=vente/vente-saisie-directe-apj.jsp" target="_blank">
            <i class="material-symbols-rounded">add</i>POS
        </a>
        <div class="dropdown">
            <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                Mouvement
                <span class="material-symbols-rounded">keyboard_arrow_down</span>
            </button>
            <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                <li><a href="${pageContext.request.contextPath}/pages/module.jsp?but=caisse/mvt/mvtcaisse-entree-pos.jsp">Entrée de caisse</a></li>
                <li><a href="${pageContext.request.contextPath}/pages/module.jsp?but=caisse/mvt/mvtcaisse-sortie-pos.jsp">Sortie de caisse</a></li>
                <li><a href="${pageContext.request.contextPath}/pages/module.jsp?but=caisse/virementIntraCaisse/virementIntraCaisse-saisie-pos.jsp">Transfert de caisse</a></li>
            </ul>
        </div>
        <a class="btn btn-tertiary" href="${pageContext.request.contextPath}/pages/module.jsp?but=cloturecaisse/cloturecaisse-saisie.jsp" >
            Clôture de caisse
        </a>
    </div>
    <div class="btn btn-tertiary">
        <i class="material-symbols-rounded">account_circle</i>
        <%=u.getUser().getNomuser()%>
    </div>
</div>
<div class="content-wrapper">
    <div class="box-body">
        <form class='container' id="venteForm" action="vente/apresVenteDirecteOptim.jsp" method="post" >
            <div class="row">
                <div class="col-md-8 d-flex vente-directe-left-container">

                    <!-- Conteneur Formulaire + Tableau -->
                    <div class="w-100" id="formTableContainer">
                        <%
                            out.println(pi.getFormu().getHtmlInsert());
                        %>
                        <br>
                        <div id="butfillejsp">
                            <%
                                out.println(pi.getFormufle().getHtmlTableauInsert());
                            %>
                            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
                        </div>
                    </div>
                    <!-- Conteneur du Clavier -->
                    <div class="d-none fade w-100" id="clavierContainer">
                        <button type="button" class="btn btn-secondary " id="btnCloseClavier">
                            <i class="material-symbols-rounded">close</i>
                        </button>
                        <%=pi.getHtmlClavierVisuel()%>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="d-flex vente-directe-right-container">
                        <h2 class="h520pxSemibold m-0" >R&eacute;sum&eacute; des commandes</h2>
                        <div class="box">
                            <div class="box-body recap-achat upside">
                                <div class="d-flex"><p class="Body14pxRegular" >Sous-total</p> <p id="recapSousTotal" class="Body14pxRegular" >0 Ar</p> </div>
                                <div class="d-flex"><p  class="Body14pxRegular" >Remises totales</p> <p id="recapRemises" class="Body14pxRegular">0 Ar</p> </div>
                            </div>
                            <div class="box-footer total-container">
                                <p class="Body12pxBold" >Total à payer</p>
                                <p id="totalGeneral" class="h142pxBold" style="color: var(--VD-main-color);">0 Ar</p>
                                <input type="hidden" name="totalGeneralInput" id="totalGeneralInput">
                                <div class="d-flex gap-2" style="justify-content: end;color: var(--Text-primary)">
                                    <p class="Body14pxRegular">Montant arrondi espèces :</p>
                                    <p id="montantArrondiEspeces" class="Body14pxRegular" style="font-weight: 600">0 Ar</p>
                                </div>
                            </div>
                            <div class="box-body recap-achat downside" style="border-top: 1px solid #eee; padding-top: 10px;">
                                <div class="d-flex">
                                    <p class="Body14pxRegular">Montant de la facture</p>
                                    <p id="montantFacture" class="Body14pxRegular" style="color: var(--VD-main-color);">0 Ar</p>
                                </div>
                                <div class="d-flex"><p class="h520pxRegular" >Montant payé</p> <p id="montantPayerTexte" class="h235pxBold" style="color: var(--VD-main-color);">0 Ar</p> </div>
                                <div class="d-flex"><p class="h520pxRegular" >&Agrave; retourner</p> <p id="montantRetourner" name="montantRetourner" class="h235pxBold" style="color: var(--VD-main-color);">0 Ar</p> </div>
                                <input type="hidden" name="aretourner" id="aretourner">
                            </div>
                        </div>
                        <div class="box d-none">
                            <button type="submit" style="margin-right: 8px" class="btn btn-small btn-primary pull-right " onclick="setPaymentMode('espece')">Payer en esp&egrave;ce</button>
                            <button style="margin-right: 8px" class="btn btn-small btn-tertiary pull-right nopadding" data-toggle="modal" data-target="#mvola" type="button" ><img src="${pageContext.request.contextPath}/assets/img/mvola.jpeg" alt="mvola" ></button>
                            <button style="margin-right: 8px" class="btn btn-tertiary btn-small pull-right nopadding" data-toggle="modal" data-target="#airtelmoney" type="button"><img src="${pageContext.request.contextPath}/assets/img/airtel.png" alt="airtel" ></button>
                            <button  style="margin-right: 8px" class="btn btn-tertiary btn-small pull-right nopadding" data-toggle="modal" data-target="#orangemoney" type="button"><img src="${pageContext.request.contextPath}/assets/img/orangemoney.png" alt="orangemoney" ></button>
                            <%--                        <button type="button" style="margin-right: 8px" class="btn btn-small btn-primary pull-left " data-toggle="modal" data-target="#paiement-multiple">Modes de paiement multiples</button>--%>
                            <button  style="margin-right: 8px" class="btn btn-secondary btn-small pull-left " data-toggle="modal" data-target="#cheque" type="button">Payer par ch&egrave;que</button>
                            <button  style="margin-right: 8px" class="btn btn-small btn-secondary pull-left " onclick="setPaymentMode('cartebancaire')" data-toggle="modal" data-target="#virement" type="button">Payer par carte bancaire</button>
                        </div>
                        <label class="toggle-button link">
                            <input type="checkbox" id="multiple-payment">
                            <div class="d-flex">
                                <span class="label" style="white-space: nowrap">Paiement multiple</span>
                            </div>
                            <input type="hidden" name="multiplePayment" id="multiplePaymentInput" value="false" />
                        </label>
                        <div class="paiement-container">
                            <div class="toggle-container">
                                <label class="toggle-button active">
                                    <input type="radio" name="payment-method" value="especes" checked>
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/payments.png">
                                        <span class="label">Espèces</span>
                                    </div>
                                </label>

                                <label class="toggle-button ">
                                    <input type="radio" name="payment-method" value="cheque">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/checkbook.png">
                                        <span class="label">Chèque</span>
                                    </div>
                                </label>
                                <label class="toggle-button">
                                    <input type="radio" name="payment-method" value="mvola">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/mvola.png">
                                    </div>
                                </label>
                                <label class="toggle-button">
                                    <input type="radio" name="payment-method" value="airtel">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/airtel.png">
                                    </div>
                                </label>
                                <label class="toggle-button">
                                    <input type="radio" name="payment-method" value="orange">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/orangemoney.png">
                                    </div>
                                </label>
                                <label class="toggle-button">
                                    <input type="radio" name="payment-method" value="visa">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/visa.png">
                                    </div>
                                </label>
                                <label class="toggle-button">
                                    <input type="radio" name="payment-method" value="bonAchat">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <i class="material-symbols-rounded">hand_package</i>
                                        <label class="label">BON D'ACHAT</label>
                                    </div>
                                </label>
                                <label class="toggle-button">
                                    <input type="radio" name="payment-method" value="cadeaux">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <i class="material-symbols-rounded">redeem</i>
                                        <span class="label" >CARTE CADEAUX</span>
                                    </div>
                                </label>
                            </div>
                        </div>
                        <div class="input-container">
                            <%--                            espece--%>
                            <div class="form-input w-100 paiement-section" data-mode="especes">
                                <div class="d-flex" style="justify-content: space-between;align-items: baseline">
                                    <label class="input-label" >Montant payé</label>
                                </div>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span>Espèces</span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" name="valeurEspece" id="valeurEspece" value="" autocomplete="off" />
                                </div>
                            </div>
                            <%--                            mvola--%>
                            <div class="form-input paiement-section d-none" data-mode="mvola">
                                <label class="input-label" >Référence</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span><img src="${pageContext.request.contextPath}/assets/img/mvola.png"> </span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refMvola" name="refMvola"/>
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="mvola">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantMvola" name="montantMvola"/>
                            </div>
                            <%--                            orange money--%>
                            <div class="form-input paiement-section d-none" data-mode="orange">
                                <label class="input-label" >Référence</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span><img src="${pageContext.request.contextPath}/assets/img/orangemoney.png"> </span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refOrange" name="refOrange"/>
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="orange">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantOrange" name="montantOrange"/>
                            </div>
                            <%--                            airtel money--%>
                            <div class="form-input paiement-section d-none" data-mode="airtel">
                                <label class="input-label" >Référence</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span><img src="${pageContext.request.contextPath}/assets/img/airtel.png"> </span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refAirtel" name="refAirtel"/>
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="airtel">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantAirtel" name="montantAirtel"/>
                            </div>


                            <%--                            cheque--%>
                            <div class="form-input paiement-section d-none" data-mode="cheque">
                                <label class="input-label" >Numéro chèque</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span>Chèque</span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refCheque" name="refCheque"/>
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="cheque">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantCheque" name="montantCheque"/>
                            </div>

                            <%--                            visa--%>
                            <div class="form-input paiement-section d-none" data-mode="visa">
                                <label class="input-label" >Référence Visa</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span>Visa</span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refVisa" name="refVisa" />
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="visa">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantVisa" name="montantVisa"/>
                            </div>
                            <%--                            carte bon d'achat--%>
                            <div class="form-input paiement-section d-none" data-mode="bonAchat">
                                <label class="input-label" >Référence du bon d'achat</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span>Bon d'achat</span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refBOA" name="refBOA" />
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="bonAchat">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantBOA" name="montantBOA"/>
                            </div>
                            <%--                            carte cadeaux--%>
                            <div class="form-input paiement-section d-none" data-mode="cadeaux">
                                <label class="input-label" >Référence de la carte cadeaux</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span>Carte cadeaux</span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refCarte" name="refCarte" />
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="cadeaux">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantCarte" name="montantCarte"/>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary btn-large w-100" style="justify-content: center;align-items: center">Payer</button>
                    </div>
                </div>
            </div>

            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="action" type="hidden" id="action" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
            <input name="nomtable" type="hidden" id="nomtable" value="Vente_Details">
            <%-- CHANGE STE 2--%>
            <input type="hidden" id="idPoint" value="<%=session.getAttribute("idPoint")%>">
        </form>
    </div>
</div>
<div id="globalLoader" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;z-index:99999;background:rgba(255,255,255,0.7);justify-content:center;align-items:center;">
    <div style="text-align:center;">
        <div class="spinner-border"  role="status"></div>
        <div style="margin-top:1rem;font-size:1.2rem;color:(--VD-main-color)">Chargement...</div>
    </div>
</div>
<script>
    function expandSingleClientInput() {
        const formTableContainer = document.getElementById('formTableContainer');
        if (!formTableContainer) return;

        const generatedInputs = Array.from(
            formTableContainer.querySelectorAll('.form-input')
        ).filter(function(element) {
            return !element.closest('#butfillejsp') && !element.closest('#uploadBox');
        });

        if (generatedInputs.length === 1) {
            generatedInputs[0].classList.add('w-100');
        }

        return generatedInputs.length;
    }

    expandSingleClientInput();
    document.addEventListener('DOMContentLoaded', expandSingleClientInput, { once: true });
    document.addEventListener('dynamicContentLoaded', expandSingleClientInput);
</script>
<script>
    const multipleInput = document.getElementById('multiple-payment');
    const hiddenInput = document.getElementById('multiplePaymentInput');

    multipleInput.addEventListener('change', function() {
        hiddenInput.value = this.checked ? 'true' : 'false';
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById("idClientlibelle").value = "<%=nomClient%>";
        document.getElementById("idClient").value = "<%=idClient%>";
        const form = document.getElementById('venteForm');

        form.addEventListener('submit', function(e) {
            const monetaryInputs = [
                'valeurEspece',
                'montantMvola',
                'montantOrange',
                'montantAirtel',
                'montantCheque',
                'montantVisa',
                'montantBOA',
                'montantCarte'
            ];

            monetaryInputs.forEach(inputId => {
                const input = document.getElementById(inputId);
                if (input && input.value) {
                    const rawValue = input.value.replace(/[^\d.]/g, '');
                    input.value = rawValue;
                }
            });

            document.querySelectorAll("input[name^='pvTva_'], input[name^='prix_'], input[name^='qte_'], input[name^='montantremise_']").forEach(input => {
                if (input.value) {
                    const isQuantity = input.name.indexOf('qte_') === 0;
                    const rawValue = isQuantity
                        ? normalizeQuantityInput(input.value).value.replace(',', '.')
                        : input.value.replace(/[^\d.]/g, '');
                    input.value = rawValue;
                }
            });

            const formData = new FormData(form)
            console.log("Form Data before submission1 :", formData);
        });
    });
</script>
<%--paiement multiple--%>
<script>
    var loader = document.getElementById('globalLoader');

    function showLoader() {
        if (!loader) return;

        loader.classList.remove('d-none');
        loader.style.display = 'flex';
    }

    function hideLoader() {
        if (!loader) return;

        loader.style.display = 'none';
        loader.classList.add('d-none');
    }
    function resetPaymentLoadingState() {
        hideLoader();

        const form = document.getElementById('venteForm');
        if (!form) return;

        const submitBtn = form.querySelector('button[type="submit"].btn-primary.btn-large');

        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.style.opacity = '1';
            submitBtn.style.cursor = 'pointer';
            submitBtn.style.pointerEvents = 'auto';
            submitBtn.style.backgroundColor = '';
            submitBtn.innerHTML = 'Payer';
        }
    }

    window.addEventListener('pageshow', function() {
        resetPaymentLoadingState();
    });

    window.addEventListener('error', function() {
        hideLoader();
    });

    window.addEventListener('unhandledrejection', function() {
        hideLoader();
    });

    document.addEventListener('DOMContentLoaded', function() {
        var form = document.getElementById('venteForm');

        if (!form) return;

        form.addEventListener('submit', function(e) {
            const formData = new FormData(form);
            console.log("Form Data before submission2 :", formData);

            saveCartState();

            const submitBtn = form.querySelector('button[type="submit"].btn-primary.btn-large');

            if (submitBtn) {
                submitBtn.style.backgroundColor = '#6c757d';
                submitBtn.style.cursor = 'not-allowed';
                submitBtn.style.opacity = '0.7';
                submitBtn.style.pointerEvents = 'none';
                submitBtn.innerHTML = 'Paiement en cours...';
                submitBtn.disabled = true;
            }

            showLoader();
        });
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const multipleInput = document.getElementById('multiple-payment');
        const paymentButtons = Array.from(document.querySelectorAll('.toggle-container .toggle-button'));
        const sections = Array.from(document.querySelectorAll('.paiement-section'));
        let lastClicked = paymentButtons.find(function(button) {
            const input = button.querySelector('input[name="payment-method"]');
            return input && input.value === 'especes';
        }) || null;

        function getMode(button) {
            const input = button && button.querySelector('input[name="payment-method"]');
            return input ? input.value : '';
        }

        function updateSections() {
            const activeModes = paymentButtons
                .filter(function(button) { return button.classList.contains('active'); })
                .map(getMode);

            sections.forEach(function(section) {
                section.classList.toggle('d-none', !activeModes.includes(section.dataset.mode));
            });
        }

        function selectOnly(button) {
            paymentButtons.forEach(function(candidate) {
                const active = candidate === button;
                const radio = candidate.querySelector('input[name="payment-method"]');
                candidate.classList.toggle('active', active);
                if (radio) radio.checked = active;
            });
        }

        if (lastClicked) selectOnly(lastClicked);

        paymentButtons.forEach(function(button) {
            button.addEventListener('click', function(event) {
                const mode = getMode(this);
                if (multipleInput && multipleInput.checked) {
                    event.preventDefault();
                    this.classList.toggle('active');
                    if (this.classList.contains('active')) lastClicked = this;
                } else {
                    selectOnly(this);
                    lastClicked = this;
                }

                updateSections();
                if (window.POSPayment) {
                    window.POSPayment.handleModeChange(mode, this.classList.contains('active'));
                }
            });
        });

        if (multipleInput) {
            multipleInput.addEventListener('change', function() {
                if (!this.checked) {
                    const selected = lastClicked && lastClicked.classList.contains('active')
                        ? lastClicked
                        : paymentButtons.find(function(button) { return button.classList.contains('active'); });
                    selectOnly(selected || paymentButtons[0]);
                    lastClicked = selected || paymentButtons[0];
                }

                updateSections();
                if (window.POSPayment) window.POSPayment.handleMultipleChange();
            });
        }

        updateSections();
    });
</script>


<%--Remove double th--%>
<script>
    let pendingQuantityRemovalRow = null;
    let quantityRemovalPreviousFocus = null;
    let pendingQuantityCorrection = null;
    const quantityInputCooldowns = new WeakMap();
    const quantityLastValidValues = new WeakMap();

    function normalizeQuantityInput(rawValue) {
        const raw = String(rawValue == null ? '' : rawValue).trim();
        let integerPart = '';
        let decimalPart = '';
        let decimalFound = false;

        for (let index = 0; index < raw.length; index++) {
            const character = raw.charAt(index);
            if (/\d/.test(character)) {
                if (decimalFound) decimalPart += character;
                else integerPart += character;
                continue;
            }
            if (!decimalFound && character === ',' && integerPart !== '') {
                decimalFound = true;
            }
        }

        if (integerPart === '') {
            return { raw: raw, value: '', hasDigits: false, needsFormatting: raw !== '' };
        }

        const normalized = decimalFound && decimalPart !== ''
            ? integerPart + ',' + decimalPart
            : integerPart;
        return {
            raw: raw,
            value: normalized,
            hasDigits: true,
            needsFormatting: raw !== normalized
        };
    }

    function rememberValidQuantity(qteInput) {
        if (!qteInput) return;
        const normalized = normalizeQuantityInput(qteInput.value);
        const quantity = Number(normalized.value.replace(',', '.'));
        if (normalized.hasDigits && !normalized.needsFormatting && Number.isFinite(quantity) && quantity > 0) {
            quantityLastValidValues.set(qteInput, normalized.value);
        }
    }

    // 1. Fonction pour supprimer la ligne et recalculer les totaux
    function removeLine(button) {
        const row = button.closest('tr');
        if (!row) return;

        // Si la ligne supprimée est la ligne 0 modèle, on la réinitialise et la masque au lieu de la détruire du DOM
        if (row.id === 'ligne-multiple-0') {
            row.querySelectorAll('input').forEach(input => {
                if (input.name === 'ids' && input.type === 'checkbox') {
                    input.checked = false;
                } else if (input.type !== 'checkbox' && input.type !== 'radio') {
                    input.value = '';
                }
            });
            row.classList.add('d-none');
        } else {
            // Pour les autres lignes, supprimer la ligne du DOM
            row.remove();
        }

        // Mettre à jour les totaux et synchroniser
        if (typeof updateTotals === 'function') updateTotals();
        if (typeof sync === 'function') sync();
    }

    function ensureQuantityRemovalModal() {
        let modal = document.getElementById('pos-quantity-removal-modal');
        if (modal) return modal;

        modal = document.createElement('div');
        modal.id = 'pos-quantity-removal-modal';
        modal.className = 'modal pos-quantity-confirm-modal';
        modal.setAttribute('role', 'alertdialog');
        modal.setAttribute('aria-modal', 'true');
        modal.setAttribute('aria-labelledby', 'pos-quantity-confirm-title');
        modal.setAttribute('aria-describedby', 'pos-quantity-confirm-description');
        modal.setAttribute('aria-hidden', 'true');
        modal.innerHTML = `
            <div class="pos-quantity-confirm-content">
                <div class="pos-quantity-confirm-header">
                    <h2 id="pos-quantity-confirm-title" class="h329pxBold">Quantité égale à zéro</h2>
                </div>
                <p id="pos-quantity-confirm-description" class="Body14pxRegular">
                    <span id="pos-quantity-confirm-message">La quantité renseignée est égale à zéro.</span>
                    <span id="pos-quantity-confirm-detail">Voulez-vous retirer <strong id="pos-quantity-confirm-product">cet article</strong> du panier&nbsp;?</span>
                </p>
                <div class="pos-quantity-confirm-actions">
                    <button type="button" class="btn btn-danger" id="pos-quantity-confirm-delete">Retirer du panier</button>
                    <button type="button" class="btn btn-secondary" id="pos-quantity-confirm-cancel">Conserver une unité</button>
                </div>
            </div>`;
        document.body.appendChild(modal);

        const cancelButton = modal.querySelector('#pos-quantity-confirm-cancel');
        const actionButton = modal.querySelector('#pos-quantity-confirm-delete');
        cancelButton.addEventListener('click', cancelQuantityRemoval);
        actionButton.addEventListener('click', confirmQuantityRemoval);
        modal.addEventListener('click', function(event) {
            if (event.target === modal) cancelQuantityRemoval();
        });
        modal.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                event.preventDefault();
                cancelQuantityRemoval();
                return;
            }
            if (event.key === 'ArrowLeft' || event.key === 'ArrowRight') {
                event.preventDefault();
                const target = document.activeElement === cancelButton ? actionButton : cancelButton;
                target.focus();
                return;
            }
            if (event.key === 'Enter' && (event.target === cancelButton || event.target === actionButton)) {
                event.preventDefault();
                event.target.click();
            }
        });
        return modal;
    }

    function closeQuantityRemovalModal(restoreFocus) {
        const modal = document.getElementById('pos-quantity-removal-modal');
        if (!modal) return;
        modal.classList.remove('is-open', 'show');
        modal.setAttribute('aria-hidden', 'true');
        document.body.classList.remove('pos-quantity-confirm-open');
        if (restoreFocus && quantityRemovalPreviousFocus && document.contains(quantityRemovalPreviousFocus)) {
            quantityRemovalPreviousFocus.focus();
        }
        pendingQuantityRemovalRow = null;
        pendingQuantityCorrection = null;
        quantityRemovalPreviousFocus = null;
    }

    function requestQuantityRemoval(row, reason) {
        if (!row) return false;
        const qteInput = row.querySelector("input[name^='qte_']");
        if (!qteInput) return false;

        qteInput.value = 1;
        pendingQuantityRemovalRow = row;
        quantityRemovalPreviousFocus = document.activeElement;

        const modal = ensureQuantityRemovalModal();
        const productName = row.dataset.productName
            || row.querySelector("input[name^='designation_']")?.value
            || 'cet article';
        const contents = {
            empty: {
                title: 'Quantité manquante',
                message: 'Aucune quantité n’a été renseignée.',
                cancel: 'Mettre la quantité à 1'
            },
            negative: {
                title: 'Quantité négative',
                message: 'Une quantité négative n’est pas autorisée.',
                cancel: 'Mettre la quantité à 1'
            },
            invalid: {
                title: 'Quantité invalide',
                message: 'Aucun chiffre exploitable n’a été trouvé.',
                cancel: 'Remettre la quantité à 1'
            },
            zero: {
                title: 'Quantité égale à zéro',
                message: 'La quantité renseignée est égale à zéro.',
                cancel: 'Conserver une unité'
            }
        };
        const content = contents[reason] || contents.zero;
        const title = modal.querySelector('#pos-quantity-confirm-title');
        const message = modal.querySelector('#pos-quantity-confirm-message');
        const detail = modal.querySelector('#pos-quantity-confirm-detail');
        const productLabel = modal.querySelector('#pos-quantity-confirm-product');
        const cancelButton = modal.querySelector('#pos-quantity-confirm-cancel');
        const actionButton = modal.querySelector('#pos-quantity-confirm-delete');
        pendingQuantityCorrection = null;
        if (title) title.textContent = content.title;
        if (message) message.textContent = content.message;
        if (productLabel) productLabel.textContent = productName;
        if (detail) {
            detail.textContent = ' Voulez-vous retirer ';
            const strong = document.createElement('strong');
            strong.id = 'pos-quantity-confirm-product';
            strong.textContent = productName;
            detail.appendChild(strong);
            detail.appendChild(document.createTextNode(' du panier ?'));
        }
        if (cancelButton) cancelButton.textContent = content.cancel;
        if (actionButton) {
            actionButton.textContent = 'Retirer du panier';
            actionButton.classList.remove('btn-primary');
            actionButton.classList.add('btn-danger');
        }
        const actions = modal.querySelector('.pos-quantity-confirm-actions');
        if (actions && actionButton && cancelButton) {
            actions.appendChild(actionButton);
            actions.appendChild(cancelButton);
        }
        modal.classList.add('is-open', 'show');
        modal.setAttribute('aria-hidden', 'false');
        document.body.classList.add('pos-quantity-confirm-open');
        modal.querySelector('#pos-quantity-confirm-cancel')?.focus();
        return true;
    }

    function requestQuantityFormatting(row, qteInput, formattedQuantity) {
        if (!row || !qteInput || !formattedQuantity) return false;

        pendingQuantityRemovalRow = row;
        quantityRemovalPreviousFocus = qteInput;
        pendingQuantityCorrection = {
            input: qteInput,
            value: formattedQuantity,
            previousValue: quantityLastValidValues.get(qteInput) || '1'
        };

        const modal = ensureQuantityRemovalModal();
        const title = modal.querySelector('#pos-quantity-confirm-title');
        const message = modal.querySelector('#pos-quantity-confirm-message');
        const detail = modal.querySelector('#pos-quantity-confirm-detail');
        const cancelButton = modal.querySelector('#pos-quantity-confirm-cancel');
        const actionButton = modal.querySelector('#pos-quantity-confirm-delete');
        if (title) title.textContent = 'Format de quantité invalide';
        if (message) {
            message.textContent = 'La quantité « ' + qteInput.value + ' » contient des caractères non autorisés. ';
        }
        if (detail) detail.textContent = ' La quantité sera corrigée en ' + formattedQuantity + '.';
        if (cancelButton) cancelButton.textContent = 'Annuler';
        if (actionButton) {
            actionButton.textContent = 'Confirmer';
            actionButton.classList.remove('btn-danger');
            actionButton.classList.add('btn-primary');
        }
        const actions = modal.querySelector('.pos-quantity-confirm-actions');
        if (actions && actionButton && cancelButton) {
            actions.appendChild(cancelButton);
            actions.appendChild(actionButton);
        }
        modal.classList.add('is-open', 'show');
        modal.setAttribute('aria-hidden', 'false');
        document.body.classList.add('pos-quantity-confirm-open');
        actionButton?.focus();
        return true;
    }

    function scheduleQuantityRemovalFromInput(row, qteInput) {
        if (!row || !qteInput) return false;

        const previousTimer = quantityInputCooldowns.get(qteInput);
        if (previousTimer) window.clearTimeout(previousTimer);

        const normalized = normalizeQuantityInput(qteInput.value);
        const quantity = Number(normalized.value.replace(',', '.'));
        const isImmediatelyValid = normalized.hasDigits
            && !normalized.needsFormatting
            && Number.isFinite(quantity)
            && quantity > 0;

        const timer = window.setTimeout(function() {
            quantityInputCooldowns.delete(qteInput);
            if (!document.contains(row)) return;

            const current = normalizeQuantityInput(qteInput.value);
            const currentQuantity = Number(current.value.replace(',', '.'));
            let reason = null;
            if (current.raw === '') {
                reason = 'empty';
            } else if (!current.hasDigits) {
                reason = 'invalid';
            } else if (/^\s*-/.test(String(qteInput.value)) && currentQuantity > 0) {
                reason = 'negative';
            } else if (Number.isFinite(currentQuantity) && currentQuantity === 0) {
                reason = 'zero';
            }
            if (!reason && current.needsFormatting) {
                requestQuantityFormatting(row, qteInput, current.value);
                return;
            }
            if (!reason) {
                quantityLastValidValues.set(qteInput, current.value);
                return;
            }

            if (requestQuantityRemoval(row, reason)) {
                updateTotals();
                sync();
            }
        }, 1000);

        quantityInputCooldowns.set(qteInput, timer);
        return isImmediatelyValid;
    }

    function cancelQuantityRemoval() {
        if (pendingQuantityCorrection) {
            const correction = pendingQuantityCorrection;
            correction.input.value = correction.previousValue;
            quantityLastValidValues.set(correction.input, correction.previousValue);
            closeQuantityRemovalModal(true);
            updateTotals();
            sync();
            return;
        }
        const row = pendingQuantityRemovalRow;
        const qteInput = row && row.querySelector("input[name^='qte_']");
        if (qteInput) qteInput.value = 1;
        closeQuantityRemovalModal(true);
    }

    function confirmQuantityRemoval() {
        if (pendingQuantityCorrection) {
            const correction = pendingQuantityCorrection;
            correction.input.value = correction.value;
            quantityLastValidValues.set(correction.input, correction.value);
            closeQuantityRemovalModal(true);
            updateTotals();
            sync();
            return;
        }
        const row = pendingQuantityRemovalRow;
        if (!row) {
            closeQuantityRemovalModal(false);
            return;
        }

        closeQuantityRemovalModal(false);
        removeLine(row);
        if (typeof refreshProductPreview === 'function') refreshProductPreview();
    }

    document.addEventListener('focusin', function(event) {
        if (event.target && event.target.matches("input[name^='qte_']")) {
            rememberValidQuantity(event.target);
        }
    });

    // 2. Fonction pour nettoyer les anciens boutons et ajouter le nouveau bouton personnalisé
    function formaterActionLigne(tr) {
        if (!tr) return;

        // A. Effacer la colonne du bouton "Dupliquer" (glyphicon-duplicate)
        const duplicateLink = tr.querySelector('a[onclick*="duplicateSingleRow"]');
        if (duplicateLink) {
            const tdDuplicate = duplicateLink.closest('td');
            if (tdDuplicate) tdDuplicate.remove();
        }

        // B. Remplacer l'ancien bouton "Supprimer" par le nouveau bouton stylisé
        const deleteLink = tr.querySelector('a[onclick*="delete_line"]');
        if (deleteLink) {
            const tdDelete = deleteLink.closest('td');
            if (tdDelete) {
                tdDelete.style.textAlign = 'center';
                tdDelete.style.verticalAlign = 'middle';
                tdDelete.innerHTML = `
                <button type="button" class="btn btn-tertiary btn-danger " onclick="removeLine(this)">
                    <i class="material-symbols-rounded">delete</i>
                </button>
            `;
            }
        }
    }

    // 3. Appliquer le nettoyage sur toutes les lignes du tableau
    function nettoyerBoutonsTableau() {
        document.querySelectorAll('#ajout_multiple_ligne tr').forEach(tr => {
            formaterActionLigne(tr);
        });
    }
    function masquerEnTeteImageEnDouble() {
        const table = document.querySelector('#butfillejsp table');
        if (!table) return;

        // 1. Trouver les <th> avec le texte "Image" ou "Photo"
        const imageHeaders = [];
        table.querySelectorAll('thead th').forEach(th => {
            const text = th.textContent.trim().toLowerCase();
            if (text === 'image' || text === 'photo') {
                imageHeaders.push(th);
            }
        });

        // 2. Si un doublon est trouvé, MASQUER visuellement (sans supprimer du DOM)
        if (imageHeaders.length > 1) {
            for (let i = 1; i < imageHeaders.length; i++) {
                const thDoublon = imageHeaders[i];
                const colIndex = Array.from(thDoublon.parentNode.children).indexOf(thDoublon);

                // Cacher uniquement l'en-tête
                thDoublon.style.display = 'none';

                // Cacher la cellule de chaque ligne tout en conservant ses <input> pour les autres scripts
                table.querySelectorAll('tbody tr').forEach(tr => {
                    if (tr.children[colIndex]) {
                        tr.children[colIndex].style.display = 'none';
                    }
                });
            }
        }
    }
</script>

<%--TOGGLE CLAVIER--%>

<script>
    let bloquerOuvertureClavier = false;

    // Détection du conteneur Tableau/Formulaire
    function getFormTableContainer() {
        let el = document.querySelector('#formTableContainer #butfillejsp');
        if (!el) {
            const parent = document.querySelector('.vente-directe-left-container');
            if (parent && parent.children.length > 0) {
                el = parent.children[0];
            }
        }
        return el;
    }

    // Détection du conteneur Clavier
    function getClavierContainer() {
        let el = document.getElementById('clavierContainer');
        if (!el) {
            const parent = document.querySelector('.vente-directe-left-container');
            if (parent && parent.children.length > 1) {
                el = parent.children[1];
            }
        }
        return el;
    }

    function ouvrirClavierVisuel(inputTarget) {
        if (bloquerOuvertureClavier) return;

        const clavier = getClavierContainer();
        const formTable = getFormTableContainer();

        if (!clavier || !formTable) {
            console.error("[Clavier] Impossible de trouver les blocs HTML.");
            return;
        }

        // Masquer le tableau et afficher le clavier (Forcé en CSS direct)
        formTable.style.setProperty('display', 'none', 'important');
        clavier.style.setProperty('display', 'block', 'important');
        clavier.classList.remove('d-none', 'hidden', 'hide');
        clavier.classList.add('in', 'show');

        if (typeof setActiveInput === 'function' && inputTarget) {
            setActiveInput(inputTarget);
        }
    }

    let clavierBlockTimer = null;
    function fermerClavierVisuel() {
        bloquerOuvertureClavier = true;

        // Réinitialiser le z-index dynamique sur tous les blocs (y compris paiement-section)
        document.querySelectorAll('.vd-header, #formTableContainer, #butfillejsp, .paiement-section').forEach(el => {
            // el.style.removeProperty('position');
            el.style.removeProperty('z-index');
        });

        if (clavierBlockTimer) {
            clearTimeout(clavierBlockTimer);
            clavierBlockTimer = null;
        }

        if (typeof activeInput !== 'undefined') {
            activeInput = null;
        }

        // 1. Retirer le focus uniquement si l'élément actif N'EST PAS l'input de recherche produit
        if (document.activeElement && document.activeElement.id !== 'idProduit_libelle') {
            if (typeof document.activeElement.blur === 'function') {
                document.activeElement.blur();
            }
        }

        // 2. Fermer la modale ABC si elle était ouverte
        if (typeof $ !== 'undefined' && $('#clavier-abc').length) {
            $('#clavier-abc').modal('hide');
            $('.modal-backdrop').remove();
            $('body').removeClass('modal-open');
        }

        // 3. Masquer le clavier et réafficher le tableau
        const clavier = getClavierContainer();
        const formTable = getFormTableContainer();

        if (clavier) {
            clavier.style.setProperty('display', 'none', 'important');
            clavier.classList.add('d-none', 'hidden', 'hide');
            clavier.classList.remove('in', 'show');
        }

        if (formTable) {
            formTable.style.setProperty('display', 'block', 'important');
            formTable.classList.remove('d-none', 'hidden', 'hide');
        }

        clavierBlockTimer = setTimeout(function() {
            bloquerOuvertureClavier = false;
            clavierBlockTimer = null;
        }, 300);
    }

    // Exposer globalement les fonctions
    window.ouvrirClavierVisuel = ouvrirClavierVisuel;
    window.fermerClavierVisuel = fermerClavierVisuel;

    document.addEventListener('DOMContentLoaded', function() {
        const btnClose = document.getElementById('btnCloseClavier');

        function verifierEtOuvrirClavier(e) {
            if (bloquerOuvertureClavier) return;

            const input = e.target;
            if (!input || !document.body.contains(input)) return;

            // ⛔ BLOQUER LE CLAVIER VIRTUEL POUR TOUT LE TABLEAU (y compris qte)
            if (input.closest('#butfillejsp')) {
                return;
            }

            // Ignorer la liste déroulante Autocomplete
            if (input.closest('.ui-autocomplete') || input.closest('.ui-menu-item')) {
                return;
            }

            // Détecter tout champ de saisie texte/numérique (hors masqués)
            const isInputSaisie = input.tagName === 'INPUT' && !['hidden', 'checkbox', 'radio', 'submit', 'button', 'file'].includes(input.type.toLowerCase());

            if (isInputSaisie) {

                const header = input.closest('.vd-header');
                const formTable = input.closest('#formTableContainer');
                const butFille = input.closest('#butfillejsp');
                const paiementSection = input.closest('.paiement-section'); // <--- Détection de la section paiement

                // 1. Réinitialiser d'abord le z-index sur tous les conteneurs
                document.querySelectorAll('.vd-header, #formTableContainer, #butfillejsp, .paiement-section').forEach(el => {
                    // el.style.removeProperty('position');
                    el.style.removeProperty('z-index');
                });

                // 2. Si le champ est dans le header (.vd-header)
                if (header) {
                    // header.style.setProperty('position', 'relative', 'important');
                    header.style.setProperty('z-index', '2000', 'important');
                    ouvrirClavierVisuel(input);
                }
                // 3. Si le champ est dans le formulaire ou le tableau (#formTableContainer / #butfillejsp)
                else if (formTable || butFille) {
                    if (formTable) {
                        // formTable.style.setProperty('position', 'relative', 'important');
                        formTable.style.setProperty('z-index', '2000', 'important');
                    }
                    if (butFille) {
                        // butFille.style.setProperty('position', 'relative', 'important');
                        butFille.style.setProperty('z-index', '2000', 'important');
                    }
                    ouvrirClavierVisuel(input);
                }
                // 4. Si le champ est dans la section de paiement (.paiement-section)
                else if (paiementSection) {
                    // paiementSection.style.setProperty('position', 'relative', 'important');
                    paiementSection.style.setProperty('z-index', '2000', 'important');
                    ouvrirClavierVisuel(input);
                }
            }
        }

        // Écouteurs sur le focus et le clic
        document.addEventListener('focusin', verifierEtOuvrirClavier);
        document.addEventListener('click', verifierEtOuvrirClavier);

        // Bouton de fermeture
        if (btnClose) {
            btnClose.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                fermerClavierVisuel();
            });
        }
    });
</script>
<script>
    // ================================================================
    // VERROUILLAGE AUTOMATIQUE DES CHAMPS DANS BUTFILLEJSP
    // ================================================================
    function verrouillerChampsButFille() {
        const container = document.getElementById('butfillejsp');
        if (!container) return;

        // Cibler tous les inputs visibles (non hidden, non checkbox/radio)
        const inputs = container.querySelectorAll('input:not([type="hidden"]):not([type="checkbox"]):not([type="radio"])');

        inputs.forEach(input => {
            // Identification du champ quantité
            const isQte = (input.name && input.name.startsWith('qte_')) || input.classList.contains('qte-editable-input');

            if (!isQte) {
                // Verrouillage strict de tous les autres champs
                input.readOnly = true;
                input.setAttribute('readonly', 'readonly');
                input.tabIndex = -1;
                input.style.pointerEvents = 'none'; // Empêche le clic / focus
                input.style.userSelect = 'none';
            } else {
                // La quantité reste accessible uniquement au clavier physique et boutons + / -
                input.readOnly = false;
                input.removeAttribute('readonly');
                input.removeAttribute('tabindex');
                input.style.pointerEvents = 'auto';
                input.style.userSelect = 'auto';
            }
        });
    }

    // Lancement au chargement + observation des ajouts/modifications dynamiques de lignes
    document.addEventListener('DOMContentLoaded', function() {
        verrouillerChampsButFille();

        const targetNode = document.getElementById('butfillejsp');
        if (targetNode) {
            const observer = new MutationObserver(function() {
                verrouillerChampsButFille();
            });
            observer.observe(targetNode, { childList: true, subtree: true });
        }
    });
</script>
<script>
    // Variables globales
    let activeInput = null;
    let isShiftActive = false;

    // Fonction pour gérer l'activation des inputs
    function setActiveInput(input) {
        // Retirer la classe active de tous les inputs
        document.querySelectorAll('.form-control').forEach(el => {
            el.classList.remove('active');
        });

        // Ajouter la classe active à l'input cliqué
        if (input) {
            input.classList.add('active');
            activeInput = input;
        }
    }

    // Initialiser les écouteurs sur tous les inputs avec la classe form-control
    function initVirtualKeyboard() {
        document.querySelectorAll('.form-control:not(select)').forEach(input => {
            input.addEventListener('focus', () => {
                setActiveInput(input);
            });

            input.addEventListener('click', () => {
                setActiveInput(input);
            });
        });
    }

    // Fonction pour ajouter du texte à l'input actif
    function addText(char) {
        if (!activeInput) return;

        const cursorPos = activeInput.selectionStart || activeInput.value.length;
        const textBefore = activeInput.value.substring(0, cursorPos);
        const textAfter = activeInput.value.substring(cursorPos);

        if (isShiftActive) {
            activeInput.value = textBefore + char.toUpperCase() + textAfter;
            isShiftActive = false;
            // Désactiver visuellement tous les boutons maj
            document.querySelectorAll('.btn-clavier.maj').forEach(btn => {
                btn.classList.remove('active');
            });
        } else {
            activeInput.value = textBefore + char.toLowerCase() + textAfter;
        }

        // Repositionner le curseur
        const newPos = cursorPos + 1;
        activeInput.setSelectionRange(newPos, newPos);
        activeInput.focus();

        const inputEvent = new Event('input', { bubbles: true, cancelable: true });
        activeInput.dispatchEvent(inputEvent);
    }

    // Fonction pour supprimer un caractère
    function deleteChar() {
        if (!activeInput) return;

        const cursorPos = activeInput.selectionStart || activeInput.value.length;
        if (cursorPos > 0) {
            const textBefore = activeInput.value.substring(0, cursorPos - 1);
            const textAfter = activeInput.value.substring(cursorPos);
            activeInput.value = textBefore + textAfter;

            // Repositionner le curseur
            const newPos = cursorPos - 1;
            activeInput.setSelectionRange(newPos, newPos);
            activeInput.focus();
        }
    }

    // Variables pour la répétition
    let repeatInterval = null;
    let repeatTimeout = null;

    // Fonction pour exécuter l'action d'un bouton
    function executeButtonAction(btn) {
        // 1. Bouton MAJ (Shift) - pas de répétition
        if (btn.classList.contains('maj')) {
            isShiftActive = !isShiftActive;
            btn.classList.toggle('active');
            return false; // Pas de répétition
        }

        // 2. Bouton DELETE (Supprimer)
        if (btn.classList.contains('delete')) {
            deleteChar();
            return true; // Répétition activée
        }

        // 3. Bouton ESPACE
        if (btn.classList.contains('space-touch')) {
            addText(' ');
            return true; // Répétition activée
        }

        // 5. Boutons normaux avec data-key (lettres et chiffres)
        const key = btn.getAttribute('data-key');
        if (key) {
            addText(key);
            return true; // Répétition activée
        }

        // 6. Fallback : utiliser le texte du bouton si pas de data-key
        const btnText = btn.textContent.trim();
        if (btnText && btnText !== 'ABC' && btnText !== '123' && btnText !== 'Espace') {
            addText(btnText);
            return true; // Répétition activée
        }

        return false;
    }

    // Fonction pour arrêter la répétition
    function stopRepeat() {
        if (repeatTimeout) {
            clearTimeout(repeatTimeout);
            repeatTimeout = null;
        }
        if (repeatInterval) {
            clearInterval(repeatInterval);
            repeatInterval = null;
        }
    }

    // Initialisation au chargement du DOM
    document.addEventListener('DOMContentLoaded', function() {
        // Initialiser le clavier virtuel
        initVirtualKeyboard();

        // Gérer TOUS les boutons du clavier de manière généralisée
        document.querySelectorAll('.btn-clavier').forEach(btn => {
            // Gestion du mousedown pour démarrer la répétition
            btn.addEventListener('mousedown', (e) => {
                e.preventDefault();

                // Exécuter l'action immédiatement
                const shouldRepeat = executeButtonAction(btn);

                // Si le bouton doit se répéter
                if (shouldRepeat) {
                    // Attendre 500ms avant de commencer la répétition
                    repeatTimeout = setTimeout(() => {
                        // Répéter toutes les 100ms
                        repeatInterval = setInterval(() => {
                            executeButtonAction(btn);
                        }, 100);
                    }, 500);
                }
            });

            // Arrêter la répétition quand on relâche le bouton
            btn.addEventListener('mouseup', stopRepeat);
            btn.addEventListener('mouseleave', stopRepeat);

            // Support tactile pour mobile
            btn.addEventListener('touchstart', (e) => {
                e.preventDefault();
                const shouldRepeat = executeButtonAction(btn);

                if (shouldRepeat) {
                    repeatTimeout = setTimeout(() => {
                        repeatInterval = setInterval(() => {
                            executeButtonAction(btn);
                        }, 100);
                    }, 500);
                }
            });

            btn.addEventListener('touchend', stopRepeat);
            btn.addEventListener('touchcancel', stopRepeat);

            btn.addEventListener('mousedown', function() {
                btn.classList.add('is-active');
            });
            btn.addEventListener('mouseup', function() {
                btn.classList.remove('is-active');
            });
            btn.addEventListener('mouseleave', function() {
                btn.classList.remove('is-active');
            });
            // For touch devices
            btn.addEventListener('touchstart', function() {
                btn.classList.add('is-active');
            });
            btn.addEventListener('touchend', function() {
                btn.classList.remove('is-active');
            });
            btn.addEventListener('touchcancel', function() {
                btn.classList.remove('is-active');
            });
        });

        // Arrêter la répétition si on relâche en dehors du document
        document.addEventListener('mouseup', stopRepeat);
        document.addEventListener('touchend', stopRepeat);
    });

    // Save cart state before form submission
    function saveCartState() {
        const cartState = {
            products: gatherProductData(),
            client: {
                id: document.getElementById('idClient')?.value || '',
                nom: document.getElementById('idClient_libelle')?.value || document.getElementById('idClientlibelle')?.value || ''
            },
            productPreview: {
                photo: document.getElementById('selectedProductImage')?.src || '',
                name: document.getElementById('selectedProductName')?.textContent || '',
                code: document.getElementById('selectedProductCode')?.textContent || '',
                price: document.getElementById('selectedProductPrice')?.textContent || ''
            },
            timestamp: Date.now()
        };

        sessionStorage.setItem('cartStateBeforeSubmit', JSON.stringify(cartState));
        console.log('Cart state saved:', cartState);
    }

    // Restore cart state after page reload
    function restoreCartState() {
        const savedState = sessionStorage.getItem('cartStateBeforeSubmit');

        if (!savedState) {
            console.log('No saved cart state found');
            return;
        }

        try {
            const cartState = JSON.parse(savedState);

            // Check if state is less than 5 minutes old
            if (Date.now() - cartState.timestamp > 300000) {
                sessionStorage.removeItem('cartStateBeforeSubmit');
                return;
            }

            // Restore client
            if (cartState.client.id) {
                const idClientInput = document.getElementById('idClient');
                const idClientLibelleInput = document.getElementById('idClient_libelle') || document.getElementById('idClientlibelle');
                if (idClientInput) idClientInput.value = cartState.client.id;
                if (idClientLibelleInput) idClientLibelleInput.value = cartState.client.nom;
            }

            // Restore products
            if (cartState.products && cartState.products.length > 0) {
                const tbody = document.getElementById("ajout_multiple_ligne");
                if (!tbody) return;

                const rows = Array.from(tbody.querySelectorAll('tr'));

                rows.forEach(function(row) {
                    if (row.id !== 'ligne-multiple-0') {
                        row.remove();
                    }
                });

                const line0 = document.getElementById('ligne-multiple-0');

                if (line0) {
                    line0.querySelectorAll('input').forEach(function(input) {
                        if (input.name === 'ids' && input.type === 'checkbox') {
                            input.checked = false;
                        } else if (input.type !== 'checkbox' && input.type !== 'radio') {
                            input.value = '';
                        }
                    });

                    line0.dataset.remiseUnitaire = '';
                    line0.classList.add('d-none');
                }

                cartState.products.forEach(function(product, index) {
                    restoreProductRow(product, index);
                });

                updateTotals();
                sync();
            }

            // Restore product preview
            if (cartState.productPreview && cartState.productPreview.name) {
                updateProductPreview(cartState.productPreview);
            }

            console.log('Cart state restored successfully');

            // La restauration ne doit pas réinjecter un ancien panier au rechargement suivant.
            sessionStorage.removeItem('cartStateBeforeSubmit');

        } catch (error) {
            console.error('Error restoring cart state:', error);
            sessionStorage.removeItem('cartStateBeforeSubmit');
        }
    }

    // Helper function to restore a single product row
    function restoreProductRow(product, index) {
        const tbody = document.getElementById("ajout_multiple_ligne");
        if (!tbody || !product) return;

        let row = null;
        let rowCount = 0;

        const line0 = document.getElementById("ligne-multiple-0");
        const designation0 = document.getElementById("designation_0");

        if (
            index === 0 &&
            line0 &&
            designation0 &&
            (!designation0.value || designation0.value.trim() === "")
        ) {
            row = line0;
            rowCount = 0;
        } else {
            const addLineButton = document.getElementById("addLines");

            if (addLineButton) {
                addLineButton.dispatchEvent(new Event("click"));

                if (typeof attachEvents === "function") {
                    attachEvents();
                }

                const rows = tbody.querySelectorAll("tr");

                if (rows.length > 0) {
                    row = rows[rows.length - 1];

                    const match = row.id ? row.id.match(/\d+$/) : null;

                    if (match) {
                        rowCount = parseInt(match[0], 10);
                    }
                }
            }
        }

        if (!row) {
            console.error("[RESTORE] Ligne introuvable :", product);
            return;
        }

        row.classList.remove("d-none");

        const checkbox = document.getElementById("checkbox" + rowCount);

        if (checkbox) {
            checkbox.checked = true;
        }

        function setRowValue(name, value) {
            let input = row.querySelector(
                "[name='" + name + "_" + rowCount + "']"
            );

            if (!input) {
                input = document.createElement("input");
                input.type = "hidden";
                input.name = name + "_" + rowCount;
                input.id = name + "_" + rowCount;
                row.appendChild(input);
            }

            input.value =
                value !== undefined && value !== null
                    ? value
                    : "";

            return input;
        }

        function clearCellDisplay(cell, exceptInput) {
            if (!cell) return;

            Array.from(cell.childNodes).forEach(function(node) {
                if (node === exceptInput) {
                    return;
                }

                if (
                    node.nodeType === Node.ELEMENT_NODE &&
                    node.tagName === "INPUT"
                ) {
                    return;
                }

                cell.removeChild(node);
            });
        }

        const quantite = parseAmount(product.quantite || 0);
        const prixUnitaire = parseAmount(product.prixunitaire || 0);
        const montantremise = parseAmount(product.montantremise || 0);
        const originalPrice = parseAmount(
            product.originalPrice || prixUnitaire
        );

        const montantBrut = product.isWeightBased
            ? prixUnitaire
            : quantite * prixUnitaire;

        const montantTTC = Math.max(
            montantBrut - montantremise,
            0
        );

        setRowValue("idProduit", product.id || "");
        setRowValue("designation", product.designation || "");
        setRowValue("reference", product.reference || "");
        setRowValue("qte", quantite);
        setRowValue("pvTva", prixUnitaire);
        setRowValue("pu", prixUnitaire);
        setRowValue("montantttc", montantTTC);
        setRowValue("montantremise", montantremise);
        setRowValue("photo", product.urlPhoto || "");
        setRowValue("compte", product.compte || "");
        setRowValue(
            "unite",
            product.isWeightBased ? "UNT00004" : "UNT00001"
        );
        setRowValue("basePriceKg", originalPrice);
        setRowValue("estEnGros", 0);
        setRowValue("idDevise", "Ar");
        setRowValue("tauxDeChange", 1);

        let idsInput = row.querySelector("input[name='ids']");

        if (!idsInput) {
            idsInput = document.createElement("input");
            idsInput.type = "hidden";
            idsInput.name = "ids";
            row.appendChild(idsInput);
        }

        idsInput.value = rowCount;

        if (product.isWeightBased) {
            row.dataset.remiseUnitaire = montantremise;
        } else {
            row.dataset.remiseUnitaire =
                quantite > 0
                    ? montantremise / quantite
                    : montantremise;
        }

        row.dataset.productPhoto = product.urlPhoto || "";
        row.dataset.productName = product.designation || "";
        row.dataset.productCode = product.id || "";
        row.dataset.productReference = product.reference || "";
        row.dataset.productPrice = prixUnitaire;
        row.dataset.productOriginalPrice = originalPrice;

        const photoInput = row.querySelector(
            "[name='photo_" + rowCount + "']"
        );

        if (photoInput) {
            photoInput.type = "hidden";

            const tdImage = photoInput.closest("td");

            if (tdImage) {
                tdImage.querySelectorAll("img").forEach(function(img) {
                    img.remove();
                });

                const img = document.createElement("img");
                img.className = "product-img";
                img.alt = "Produit";
                img.src = resolveProductImage(
                    product.urlPhoto
                );

                img.onerror = function() {
                    this.onerror = null;
                    this.src = productImageFallback;
                };

                tdImage.insertBefore(img, photoInput);
            }
        }

        const designationInput = row.querySelector(
            "[name='designation_" + rowCount + "']"
        );

        if (designationInput) {
            designationInput.type = "hidden";

            const tdArticle = designationInput.closest("td");

            if (tdArticle) {
                clearCellDisplay(
                    tdArticle,
                    designationInput
                );

                const articleLabel =
                    document.createElement("span");

                articleLabel.className =
                    "Body14pxRegular";

                articleLabel.textContent =
                    product.designation || "";

                tdArticle.insertBefore(
                    articleLabel,
                    designationInput
                );
            }
        }

        const montantInput =
            row.querySelector(
                "[name='montantttc_" + rowCount + "']"
            ) ||
            row.querySelector(
                "[name='montant_" + rowCount + "']"
            );

        if (montantInput) {
            montantInput.type = "hidden";

            const tdMontant =
                montantInput.closest("td");

            if (tdMontant) {
                clearCellDisplay(
                    tdMontant,
                    montantInput
                );

                const montantLabel =
                    document.createElement("span");

                montantLabel.className =
                    "Body14pxRegular";

                montantLabel.textContent =
                    formatAmount(montantTTC, true);

                tdMontant.insertBefore(
                    montantLabel,
                    montantInput
                );

                tdMontant.classList.add(
                    "montant-row"
                );
            }
        }

        const qteInput = row.querySelector(
            "[name='qte_" + rowCount + "']"
        );

        if (qteInput) {
            const tdQte = qteInput.closest("td");

            if (tdQte) {
                qteInput.type = "text";
                qteInput.className =
                    "qte-editable-input Body14pxSemiBold";

                qteInput.value = quantite;

                const minusBtn =
                    document.createElement("button");

                minusBtn.className =
                    "btn btn-secondary btn-small minus-btn-qte";

                minusBtn.type = "button";

                minusBtn.innerHTML =
                    '<i class="material-symbols-rounded">remove</i>';

                minusBtn.onclick = function() {
                    const currentQte =
                        parseAmount(
                            qteInput.value || 0
                        );

                    const uniteInput =
                        row.querySelector(
                            "[name='unite_" +
                            rowCount +
                            "']"
                        );

                    const isWeightBased =
                        uniteInput &&
                        uniteInput.value ===
                        "UNT00004";

                    const decrement =
                        isWeightBased ? 10 : 1;

                    const newQte =
                        Math.max(
                            currentQte - decrement,
                            0
                        );

                    if (newQte === 0) {
                        requestQuantityRemoval(row);
                        return;
                    }

                    qteInput.value = newQte;

                    if (isWeightBased) {
                        const puInput =
                            row.querySelector(
                                "[name='pvTva_" +
                                rowCount +
                                "']"
                            );

                        const basePriceInput =
                            row.querySelector(
                                "[name='basePriceKg_" +
                                rowCount +
                                "']"
                            );

                        if (
                            puInput &&
                            basePriceInput
                        ) {
                            puInput.value =
                                (
                                    newQte *
                                    parseAmount(
                                        basePriceInput.value
                                    )
                                ) / 1000;
                        }
                    }

                    updateTotals();
                    sync();
                };

                const plusBtn =
                    document.createElement("button");

                plusBtn.className =
                    "btn btn-secondary btn-small plus-btn-qte";

                plusBtn.type = "button";

                plusBtn.innerHTML =
                    '<i class="material-symbols-rounded">add</i>';

                plusBtn.onclick = function() {
                    const currentQte =
                        parseAmount(
                            qteInput.value || 0
                        );

                    const uniteInput =
                        row.querySelector(
                            "[name='unite_" +
                            rowCount +
                            "']"
                        );

                    const isWeightBased =
                        uniteInput &&
                        uniteInput.value ===
                        "UNT00004";

                    const increment =
                        isWeightBased ? 10 : 1;

                    const newQte =
                        currentQte + increment;

                    qteInput.value = newQte;

                    if (isWeightBased) {
                        const puInput =
                            row.querySelector(
                                "[name='pvTva_" +
                                rowCount +
                                "']"
                            );

                        const basePriceInput =
                            row.querySelector(
                                "[name='basePriceKg_" +
                                rowCount +
                                "']"
                            );

                        if (
                            puInput &&
                            basePriceInput
                        ) {
                            puInput.value =
                                (
                                    newQte *
                                    parseAmount(
                                        basePriceInput.value
                                    )
                                ) / 1000;
                        }
                    }

                    updateTotals();
                    sync();
                };

                qteInput.addEventListener(
                    "input",
                    function() {
                        if (scheduleQuantityRemovalFromInput(row, qteInput)) {
                            updateTotals();
                            sync();
                        }
                    }
                );

                const qteWrapper =
                    document.createElement("div");

                qteWrapper.className =
                    "d-flex gap-1 qte-action-container";

                qteWrapper.appendChild(
                    minusBtn
                );

                qteWrapper.appendChild(
                    qteInput
                );

                qteWrapper.appendChild(
                    plusBtn
                );

                tdQte.innerHTML = "";

                tdQte.appendChild(
                    qteWrapper
                );
            }
        }

        if (
            typeof formaterActionLigne ===
            "function"
        ) {
            formaterActionLigne(row);
        }

        if (
            typeof verrouillerChampsButFille ===
            "function"
        ) {
            verrouillerChampsButFille();
        }

        updateTotals();
    }

    // Rendre les fonctions disponibles globalement
    window.setActiveInput = setActiveInput;
    window.initVirtualKeyboard = initVirtualKeyboard;
</script>
<script>
    function swapclavier(){
        e.preventDefault();
        $('.modal-body .clavier-container').toggleClass('d-none');
        $('.clavier-abc-container').toggleClass('d-none');
    }
</script>
<%--par defaut eo @ produit ny cursor--%>
<script>
    function focusOnProduit() {
        const input = document.getElementById("idProduit_libelle");
        if (input) {
            input.value = ""; // Vider le champ
            bloquerOuvertureClavier = true; // Empêcher l'ouverture du clavier lors du focus auto
            input.focus();
            setTimeout(function() {
                bloquerOuvertureClavier = false;
            }, 300);
        }
    }
    //gestion de focus sur recherche produit
    window.onload = function() {
        focusOnProduit();
        restoreCartState();

        const observer = new MutationObserver(() => {
            // Ne pas remettre le focus si la fermeture du clavier est en cours
            if (bloquerOuvertureClavier) return;

            const activeElement = document.activeElement;
            const isUserTyping = activeElement && (
                activeElement.id === 'idClient_libelle' ||
                activeElement.classList.contains('ui-autocomplete-input') ||
                (activeElement.tagName === 'INPUT' && activeElement.type !== 'hidden')
            );

            // Si l'utilisateur n'est pas en train de taper ET que le clavier est fermé,
            // on ne ré-applique PAS brusquement le focus si un élément vient d'être ajouté.
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true,
            attributes: true
        });

        sendMessage("BIENVENUE !!!");
    };
</script>

<script src="/aigledor/dist/js/socket.io.min.js"></script>
<script>

    const amountFormatter = new Intl.NumberFormat('fr-FR', {
        minimumFractionDigits: 0,
        maximumFractionDigits: 2
    });
    const productImageFallback = '${pageContext.request.contextPath}/assets/img/products/no_image.png';

    function getIdNumber() {
        const ids = [];
        // Sélectionner tous les inputs dont le name commence par "designation_"
        const designations = document.querySelectorAll("input[name^='designation_']");
        if (!designations || designations.length == 0) {
            ids.push(0);
        }
        else
        {
            designations.forEach(input => {
                const match = input.name.match(/^designation_(\d+)$/);
                if (match) {
                    ids.push(parseInt(match[1], 10));
                }
            });
        }
        return ids;
    }

    function sync() {
        setupListeners();
        // Optionnel : appeler gatherProductData() pour initialiser l'état
        const products = gatherProductData();
        save(products);
        console.log("product sync", products);
    }

    function parseAmount(value) {
        if (value === null || value === undefined) {
            return 0;
        }
        const normalized = value.toString()
            .replace(/Ar/gi, '')
            .replace(/[\s\u00A0]/g, '')
            .replace(/,/g, '.');
        const parsed = Number(normalized);
        return Number.isFinite(parsed) ? parsed : 0;
    }

    function formatAmount(value, withCurrency) {
        const formatted = amountFormatter.format(Number(value) || 0);
        return withCurrency ? formatted + ' Ar' : formatted;
    }

    function setCellDisplay(cell, text) {
        if (!cell) {
            return;
        }
        Array.from(cell.childNodes).forEach(node => {
            if (node.nodeType === 3 && node.textContent.trim() !== '') {
                cell.removeChild(node);
            }
        });
        const hiddenInputs = cell.querySelectorAll("input[type='hidden']");
        let span = cell.querySelector('.cell-value');
        if (!span) {
            span = document.createElement('span');
            span.className = 'cell-value';
            if (hiddenInputs.length > 0) {
                cell.insertBefore(span, hiddenInputs[0]);
            } else {
                cell.appendChild(span);
            }
        }
        // span.textContent = text;
    }

    function getCellDisplay(cell) {
        if (!cell) {
            return '';
        }
        const span = cell.querySelector('.cell-value');
        if (span) {
            return span.textContent.trim();
        }
        return cell.textContent.trim();
    }


    function parseWeightBarcode(barcode) {
        const cleaned = barcode.trim();
        const codeLen = 13;
        console.log("Full barcode scanned:", cleaned);
        console.log("Barcode length:", cleaned.length);

        const validWeightPrefixes = ["20", "21", "22"];
        const prefix = cleaned.substring(0, 2);

        if (cleaned.length !== codeLen || !/^\d{13}$/.test(cleaned) || !validWeightPrefixes.includes(prefix)) {
            return { isWeightBased: false, productCode: null, weight: null };
        }


        const productCode = cleaned.substring(4, 7);
        const weightStr = cleaned.substring(7, 12);
        const weight = parseInt(weightStr, 10);

        return {
            isWeightBased: true,
            productCode: productCode,
            weight: isNaN(weight) ? 0 : weight
        };
    }

    async function getProductByBarcode(barcode) {
        const barcodeInfo = parseWeightBarcode(barcode);

        try {
            const response = await fetch(`${pageContext.request.contextPath}/ApresTarif?acte=pos&reference=${barcodeInfo.productCode}`);
            const data = await response.json();

            if (data.productPos) {
                console.log('Product retrieved from barcode:', data.productPos);
                return {
                    product: data.productPos,
                    barcodeInfo: barcodeInfo,
                    isWeightUnit: data.productPos.unite === "UNT00004"
                };
            } else {
                console.log('No product found for reference:', barcodeInfo.productCode);
                return { product: null, error: "Product not found" };
            }
        } catch (error) {
            console.error('Error fetching product by barcode:', error);
            return { product: null, error: error.message };
        }
    }

    window.parseWeightBarcode = parseWeightBarcode;
    window.formatAmount = formatAmount;
    window.parseAmount = parseAmount;
    window.setCellDisplay = setCellDisplay;
    window.getCellDisplay = getCellDisplay;
    window.refreshProductPreview = refreshProductPreview;
    window.removeProductRow = removeProductRow;

    function resolveProductImage(photo) {
        console.log({photo})
        if (!photo) {
            return `${pageContext.request.contextPath}/assets/img/products/no_image.png`;
        }
        if (/^https?:\/\//i.test(photo)) {
            return photo;
        }
        return `${pageContext.request.contextPath}/assets/img/produit/`+photo;
    }

    // Exemple d'utilisation
    const img = document.createElement("img");
    img.className = "logo";
    img.alt = "photo du produit";

    img.src = resolveProductImage(val);

    // imageFallback
    img.onerror = function() {
        this.onerror = null; // empêche boucle infinie
        this.src = `${pageContext.request.contextPath}/assets/img/products/no_image.png`;
    };

    cell.appendChild(img);


    function updateProductPreview({ photo, name, code, price }) {
        console.log({photo})

        const box = document.getElementById('selectedProductBox');
        if (!box) {
            return;
        }

        box.classList.remove('d-none');

        const imageElement = document.getElementById('selectedProductImage');
        if (imageElement) {
            imageElement.src = resolveProductImage(photo);
            imageElement.onerror = function () {
                this.onerror = null;
                this.src = productImageFallback;
            };
        }

        const nameElement = document.getElementById('selectedProductName');
        if (nameElement) {
            nameElement.textContent = name && name.trim() !== '' ? name : 'Aucun produit';
        }

        const codeElement = document.getElementById('selectedProductCode');
        if (codeElement) {
            // Use reference instead of ID
            codeElement.textContent = code && code.trim() !== '' ? code : '--';
        }

        const priceElement = document.getElementById('selectedProductPrice');
        if (priceElement) {
            const numericPrice = parseAmount(price);
            priceElement.textContent = formatAmount(numericPrice, true);
        }
    }

    function hideProductPreview() {
        const box = document.getElementById('selectedProductBox');
        if (!box) {
            return;
        }
        box.classList.add('d-none');
    }

    function refreshProductPreview(previewData) {
        if (previewData && (previewData.name || previewData.photo || previewData.code)) {
            // updateProductPreview(previewData);
            return;
        }

        const rows = document.querySelectorAll('#panierBody tr');
        if (!rows.length) {
            hideProductPreview();
            return;
        }

        const lastRow = rows[rows.length - 1];
        const data = {
            photo: lastRow?.dataset?.productPhoto || '',
            name: lastRow?.dataset?.productName || '',
            code: lastRow?.dataset?.productReference || lastRow?.dataset?.productCode || '',
            price: lastRow?.dataset?.productOriginalPrice || lastRow?.dataset?.productPrice || ''
        };
        // updateProductPreview(data);
    }

    function removeProductRow(button) {
        const row = button.closest('tr');
        if (!row) {
            return;
        }
        row.remove();
        updateTotals();
        refreshProductPreview();
        sync();
    }

    function adjustModalQuantity(delta) {
        const modalQuantite = document.getElementById("modalQuantite");
        if (!modalQuantite) {
            return;
        }

        const currentValue = parseAmount(modalQuantite.value || 0);
        const updated = Math.max(currentValue + delta, 0);
        modalQuantite.value = Number.isInteger(updated) ? updated : updated.toFixed(2);
    }

    document.addEventListener("click", function (e) {
        const modifierBtn = e.target.closest(".btn-modifier");
        if (!modifierBtn) {
            return;
        }

        const tr = modifierBtn.closest("tr");
        if (!tr) {
            return;
        }

        const cells = Array.from(tr.querySelectorAll("td"));
        if (cells.length < 7) {
            return;
        }

        const modalPhoto = document.getElementById("modalPhoto");
        const modalArticle = document.getElementById("modalArticle");
        const modalCode = document.getElementById("modalCode");
        const modalPrix = document.getElementById("modalPrix");
        const modalRemise = document.getElementById("modalRemise");
        const modalQuantite = document.getElementById("modalQuantite");

        const articleCell = cells[1];
        const codeCell = cells[2];
        const quantiteCell = cells[3];
        const prixUnitaireCell = cells[4];
        const remiseCell = cells[5];

        if (modalPhoto) {
            const photo = tr.querySelector("img")?.src || "";
            modalPhoto.src = photo;
        }
        if (modalArticle) {
            modalArticle.textContent = getCellDisplay(articleCell);
        }
        if (modalCode) {
            modalCode.textContent = getCellDisplay(codeCell);
        }
        if (modalPrix) {
            modalPrix.textContent = getCellDisplay(prixUnitaireCell);
        }

        const quantiteValue = parseAmount(tr.querySelector("input[name^='qte_']")?.value || getCellDisplay(quantiteCell));
        const remiseValue = parseAmount(tr.querySelector("input[name^='montantremise_']")?.value || getCellDisplay(remiseCell));

        if (modalQuantite) {
            modalQuantite.value = Number.isInteger(quantiteValue) ? quantiteValue : quantiteValue.toFixed(2);
        }
        if (modalRemise) {
            modalRemise.value = remiseValue.toString();
        }
    });

    function autoCompleteDyn(inputID, table, classe, champRetour,valeur) {
        let input = document.getElementById(inputID);
        if (!input) {
            return;
        }
        input.addEventListener('keydown', function (event) {
            if (event.key === 'Enter' || event.key === 'Tab') {
                event.preventDefault();
                let prest = input.value;
                if (prest != null && prest.trim() !== "") {
                    let temp = prest.split("::");
                    input.value = temp[0].trim();
                }
            } else {

                $('#' + inputID).autocomplete({
                    source: function (request, response) {
                        let rep =  fetchAutocomplete(request, response, "null", valeur, "null", table, classe, "true",champRetour,"null");
                        console.log("REP", rep)
                    },
                    minLength: 0,
                    select: function (event, ui) {
                        let selectedObj = ui.item;
                        let prest = selectedObj.value;
                        let temp = prest.split("::");
                        let compte = temp[0].trim();

                        let prest2 = selectedObj.label;
                        let temp2 = prest2.split("::");
                        let compte2 = temp2[0].trim();

                        document.getElementById(inputID).value = compte2;
                        let tempinput = inputID.split("_");
                        console.log(selectedObj);
                        console.log(compte2);
                        console.log('#',inputID);
                        console.log('#',tempinput[0])
                        $('#'+tempinput[0]).val(compte)
                        document.getElementById(tempinput[0]).dispatchEvent(new Event("change"));

                        setTimeout(() => {
                            const input = document.getElementById(inputID);
                            input.value = compte2;
                            console.log('Set value:', input.value);

                            // Après sélection du client, refocuser sur le champ produit
                            if (inputID === 'idClient_libelle') {
                                setTimeout(() => {
                                    focusOnProduit();
                                }, 100);
                            }
                        }, 10);

                        return false;
                    }
                });
            }
        });
    }

    // autocomplete efa tonga de miselectionner produit hoazy raha iray ilay resultat hitany
    function autoCompleteVenteDirect(inputID, table, classe, champRetour, inputNom, valeur) {
        const champsBase = champRetour.split(";").filter(c => !c.includes("="));
        const inputNames = inputNom.split(";");

        const defaults = {};
        champRetour.split(";").forEach(c => {
            if (c.includes("=")) {
                const [key, val] = c.split("=");
                defaults[key] = val;
            }
        });

        let input = document.getElementById(inputID);
        if (!input) return;

        // L'attribut oninput rappelle cette fonction à chaque frappe : invalider
        // la sélection différée et les réponses des recherches précédentes.
        clearTimeout(input.posSingleResultTimer);
        const setupVersion = input.posAutocompleteSetupVersion = (input.posAutocompleteSetupVersion || 0) + 1;
        if (!input.posCompositionBound) {
            input.addEventListener('compositionstart', function() { input.posIsComposing = true; });
            input.addEventListener('compositionend', function() { input.posIsComposing = false; });
            input.posCompositionBound = true;
        }

        $('#' + inputID).autocomplete({
            source: function(request, response) {
                clearTimeout(input.posSingleResultTimer);
                const requestVersion = input.posAutocompleteRequestVersion = (input.posAutocompleteRequestVersion || 0) + 1;
                const searchTerm = request.term;
                const barcodeInfo = parseWeightBarcode(searchTerm);
                console.log("BARCODE  INFO",barcodeInfo)

                if (barcodeInfo.isWeightBased) {
                    const productCode = barcodeInfo.productCode;
                    const codegrosSearchRequest = { term: productCode };
                    fetchAutocomplete(codegrosSearchRequest, function(codegrosResults) {
                        console.log("Codegros search results:", codegrosResults);

                        const codegrosMatch = codegrosResults.find(result => {
                            let codegros = '';
                            const values = (result.retour || "").split(";");
                            champsBase.forEach((col, idx) => {
                                if (col === 'codegros' && values[idx]) {
                                    codegros = values[idx].toString();
                                }
                            });

                            if (!codegros) {
                                const valueParts = result.value.split(' - ');
                                console.log('===> valueParts', valueParts);
                                for (let i = 0; i < valueParts.length; i++) {
                                    let valiny = '[' + i + ']' + ' ===> '  + valueParts[i];
                                    console.log('valiny ======> ', valiny);
                                }
                                if (valueParts.length >= 5) {
                                    codegros = valueParts[4]; // codegros is the 5th element (0-indexed: 4)
                                }
                            }
                            return codegros === productCode;
                        });

                        if (codegrosMatch) {
                            const values = (codegrosMatch.retour || "").split(";");
                            let codegros = '', reference = '', pvgros = '', pv = '';
                            champsBase.forEach((col, idx) => {
                                if (col === 'codegros' && values[idx]) codegros = values[idx].toString();
                                if (col === 'reference' && values[idx]) reference = values[idx].toString();
                                if (col === 'pvgros' && values[idx]) pvgros = values[idx].toString();
                                if (col === 'pv' && values[idx]) pv = values[idx].toString();
                            });

                            handleProductSelection(codegrosMatch, inputID, champRetour, inputNom, valeur, defaults, barcodeInfo.weight);
                            $('#' + inputID).autocomplete("close");
                        } else {
                            fetchAutocompletePrecis(codegrosSearchRequest, function(refResults) {
                                if (refResults && refResults.length > 0) {
                                    const single = refResults[0];
                                    handleProductSelection(single, inputID, champRetour, inputNom, valeur, defaults, barcodeInfo.weight);
                                    $('#' + inputID).autocomplete("close");
                                } else {
                                    response(refResults);
                                }
                            }, "null", valeur, "null", table, classe, "true", champsBase.join(";"), "null", "true");
                        }
                    }, "null", valeur, "null", table, classe, "true", champsBase.join(";"), "null");
                } else {
                    console.log("Regular search term, not weight-based");
                    const searchRequest = { term: searchTerm };
                    fetchAutocomplete(searchRequest, function(results) {
                        console.log("Search results for non-weight code:", results);
                        if (setupVersion !== input.posAutocompleteSetupVersion ||
                            requestVersion !== input.posAutocompleteRequestVersion ||
                            input.value.trim() !== searchTerm.trim()) {
                            response([]);
                            return;
                        }
                        const wholesaleMatch = results.find(result => {
                            let codegros = '';
                            const values = (result.retour || "").split(";");
                            champsBase.forEach((col, idx) => {
                                if (col === 'codegros' && values[idx]) {
                                    codegros = values[idx].toString();
                                }
                            });

                            if (!codegros) {
                                const valueParts = result.value.split(' - ');
                                if (valueParts.length >= 5) {
                                    codegros = valueParts[4]; // codegros is the 5th element (0-indexed: 4)
                                }
                            }

                            return codegros === searchTerm;
                        });

                        if (wholesaleMatch) {
                            const values = (wholesaleMatch.retour || "").split(";");
                            let codegros = '', reference = '', pvgros = '', pv = '';
                            champsBase.forEach((col, idx) => {
                                if (col === 'codegros' && values[idx]) codegros = values[idx].toString();
                                if (col === 'reference' && values[idx]) reference = values[idx].toString();
                                if (col === 'pvgros' && values[idx]) pvgros = values[idx].toString();
                                if (col === 'pv' && values[idx]) pv = values[idx].toString();
                            });

                            handleProductSelection(wholesaleMatch, inputID, champRetour, inputNom, valeur, defaults);
                            $('#' + inputID).autocomplete("close");
                        } else {
                            response(results);
                            if (results && results.length === 1) {
                                const single = results[0];
                                const term = searchTerm.trim().toLowerCase();
                                const values = (single.retour || "").split(";");
                                let isExactMatch = false;

                                champsBase.forEach((col, idx) => {
                                    if (values[idx]) {
                                        const val = values[idx].toString().toLowerCase().trim();
                                        if (val === term) {
                                            isExactMatch = true;
                                        }
                                    }
                                });

                                if (!isExactMatch) {
                                    if ((single.label && single.label.toLowerCase() === term) ||
                                        (single.value && single.value.toLowerCase() === term)) {
                                        isExactMatch = true;
                                    }
                                }

                                if (isExactMatch && !input.posIsComposing) {
                                    handleProductSelection(single, inputID, champRetour, inputNom, valeur, defaults);
                                    $('#' + inputID).autocomplete("close");
                                } else if (!input.posIsComposing) {
                                    // Un seul résultat partiel : attendre la fin de la saisie
                                    // avant de l'ajouter au panier.
                                    input.posSingleResultTimer = setTimeout(function() {
                                        if (setupVersion !== input.posAutocompleteSetupVersion ||
                                            requestVersion !== input.posAutocompleteRequestVersion ||
                                            input.posIsComposing || !document.contains(input) ||
                                            document.activeElement !== input ||
                                            input.value.trim().toLowerCase() !== term) return;
                                        handleProductSelection(single, inputID, champRetour, inputNom, valeur, defaults);
                                        $('#' + inputID).autocomplete("close");
                                    }, 500);
                                }
                            }
                        }
                    }, "null", valeur, "null", table, classe, "true", champsBase.join(";"), "null");
                }
            },
            minLength: 0,
            select: function(event, ui) {
                if (event) event.preventDefault(); // EMPÊCHE jQuery UI de remettre le texte dans l'input !
                const currentInput = $('#' + inputID).val();
                const barcodeInfo = parseWeightBarcode(currentInput);

                if (barcodeInfo.isWeightBased) {
                    let codegros = '';
                    let unite='';
                    const values = (ui.item.retour || "").split(";");
                    champsBase.forEach((col, idx) => {
                        if (col === 'codegros' && values[idx]) {
                            codegros = values[idx].toString();
                        }
                        if (col === 'unite' && values[idx]) {
                            unite = values[idx].toString();
                        }
                    });

                    ui.item.unite = unite;

                    if (!codegros) {
                        const valueParts = ui.item.value.split(' - ');
                        if (valueParts.length >= 5) {
                            codegros = valueParts[4]; // codegros is the 5th element (0-indexed: 4)
                        }
                    }


                    const isWholesale = codegros === barcodeInfo.productCode;
                    handleProductSelection(ui.item, inputID, champRetour, inputNom, valeur, defaults, barcodeInfo.weight);
                } else {
                    let codegros = '';
                    const values = (ui.item.retour || "").split(";");
                    champsBase.forEach((col, idx) => {
                        if (col === 'codegros' && values[idx]) {
                            codegros = values[idx].toString();
                        }
                    });

                    if (!codegros) {
                        const valueParts = ui.item.value.split(' - ');
                        if (valueParts.length >= 5) {
                            codegros = valueParts[4]; // codegros is the 5th element (0-indexed: 4)
                        }
                    }
                    if (codegros === currentInput) {
                        handleProductSelection(ui.item, inputID, champRetour, inputNom, valeur, defaults);
                    } else {
                        handleProductSelection(ui.item, inputID, champRetour, inputNom, valeur, defaults);
                    }
                }
                return false;
            }
        });
    }


    // Check for existing products, if so add. Helper method 1 here. Consult Stefan for any queries

    function getExistingProductRow(productId) {
        if (!productId) return null;
        const normalized = productId.toString().trim();
        let found = null;

        document.querySelectorAll("input[name^='idProduit_']").forEach(input => {
            if (found) return;
            const val = (input.value || "").toString().trim();
            if (val && val === normalized) {
                const row = input.closest('tr');
                // ignorer la ligne modèle non-remplie (designation vide)
                const designation = row?.querySelector("input[name^='designation_']")?.value?.trim();
                if (row && designation) {
                    found = row;
                }
            }
        });

        return found;
    }

    // Check for existing products, if so add. Helper method 2 here. Consult Stefan for any queries
    function incrementProductRow(row, overrideQuantity) {
        const qteInput = row.querySelector("input[name^='qte_']");
        const puInput = row.querySelector("input[name^='pvTva_']");
        const basePriceKgInput = row.querySelector("input[name^='basePriceKg_']");
        const uniteInput = row.querySelector("input[name^='unite_']");

        if (!qteInput) return;

        const uniteCode = uniteInput?.value || '';
        const isWeightBased = uniteCode === "UNT00004";

        // Produit au poids : on ajoute le poids scanné (ou 10g par défaut)
        // Produit à l'unité : on ajoute 1
        const increment = isWeightBased
            ? (overrideQuantity !== null && overrideQuantity !== undefined ? overrideQuantity : 10)
            : 1;

        const currentQte = parseAmount(qteInput.value || 0);
        const newQte = currentQte + increment;
        qteInput.value = newQte;

        if (isWeightBased && basePriceKgInput && puInput) {
            const basePricePerKg = parseAmount(basePriceKgInput.value);
            puInput.value = (newQte * basePricePerKg) / 1000;
        }

        updateTotals();
        sync();

        // petit retour visuel pour confirmer au caissier
        row.classList.add('row-qty-updated');
        setTimeout(() => row.classList.remove('row-qty-updated'), 500);
    }

    function handleProductSelection(selectedObj, inputID, champRetour, inputNom, valeur, defaults, overrideQuantity = null) {
        if (!selectedObj || !selectedObj.value) return;

        const champsBase = champRetour.split(";").filter(c => !c.includes("="));
        const inputNames = inputNom.split(";");
        const productIdCandidate = selectedObj.value.split("::")[0].trim();
        if (!productIdCandidate) return;

        // 1. Vérifier si le produit existe déjà dans le panier (Incrémenter si oui)
        const existingRow = getExistingProductRow(productIdCandidate);
        if (existingRow) {
            incrementProductRow(existingRow, overrideQuantity);
            fermerClavierVisuel();
            setTimeout(function() {
                focusOnProduit();
            }, 50);
            return;
        }

        let tbody = document.getElementById("ajout_multiple_ligne");
        if (!tbody) return;

        // 2. Déterminer la ligne à utiliser (ligne 0 modèle si vide, sinon nouvelle ligne)
        let row = null;
        let rowCount = 0;
        const line0 = document.getElementById("ligne-multiple-0");
        const desig0 = document.getElementById("designation_0");

        if (line0 && desig0 && (!desig0.value || desig0.value.trim() === "")) {
            row = line0;
            rowCount = 0;
        } else {
            let addLineButton = document.getElementById("addLines");
            if (addLineButton) {
                addLineButton.dispatchEvent(new Event("click"));
                if (typeof attachEvents === 'function') attachEvents();

                // Récupérer la toute dernière ligne insérée dans le tableau
                const allRows = document.querySelectorAll("#ajout_multiple_ligne tr");
                if (allRows.length > 0) {
                    row = allRows[allRows.length - 1];
                    const match = row.id ? row.id.match(/\d+$/) : null;
                    if (match) {
                        rowCount = parseInt(match[0], 10);
                    }
                }
            }

            if (!row) {
                let idsInput = getIdNumber();
                rowCount = idsInput.length > 0 ? idsInput[idsInput.length - 1] + 1 : 1;
                row = document.getElementById("ligne-multiple-" + rowCount);
            }
        }

        if (!row) {
            console.error("[POS] Ligne HTML introuvable pour rowCount:", rowCount);
            return;
        }

        row.classList.remove("d-none");

        const check = document.getElementById("checkbox" + rowCount);
        if (check) {
            check.checked = true;
        }

        // ID du produit
        let hiddenID = document.getElementById("idProduit_" + rowCount);
        if (!hiddenID) {
            hiddenID = document.createElement("input");
            hiddenID.type = "hidden";
            hiddenID.name = "idProduit_" + rowCount;
            hiddenID.id = "idProduit_" + rowCount;
            row.appendChild(hiddenID);
        }
        hiddenID.value = productIdCandidate;

        let hiddenEstEnGros = document.getElementById("estEnGros_" + rowCount);
        if (!hiddenEstEnGros) {
            hiddenEstEnGros = document.createElement("input");
            hiddenEstEnGros.type = "hidden";
            hiddenEstEnGros.name = "estEnGros_" + rowCount;
            hiddenEstEnGros.id = "estEnGros_" + rowCount;
            row.appendChild(hiddenEstEnGros);
        }
        hiddenEstEnGros.value = "0";

        // ================================================================
        // ➕ NOUVEAU : AJOUTER ICI (Devise & Taux de change)
        // ================================================================
        let hiddenDevise = document.getElementById("idDevise_" + rowCount);
        if (!hiddenDevise) {
            hiddenDevise = document.createElement("input");
            hiddenDevise.type = "hidden";
            hiddenDevise.name = "idDevise_" + rowCount;
            hiddenDevise.id = "idDevise_" + rowCount;
            row.appendChild(hiddenDevise);
        }
        hiddenDevise.value = "Ar";

        let hiddenTaux = document.getElementById("tauxDeChange_" + rowCount);
        if (!hiddenTaux) {
            hiddenTaux = document.createElement("input");
            hiddenTaux.type = "hidden";
            hiddenTaux.name = "tauxDeChange_" + rowCount;
            hiddenTaux.id = "tauxDeChange_" + rowCount;
            row.appendChild(hiddenTaux);
        }
        hiddenTaux.value = "1";

        const valeurs = (selectedObj.retour || "").split(";");
        const finalColumns = champRetour.split(";").map(c => c.split("=")[0]);
        const productId = productIdCandidate;
        const productPreviewData = { photo: '', name: '', code: productId, price: '' };

        let photoVal = '', designationVal = '', qteVal = '1', puVal = '0', pvgrosVal = '', remiseVal = '0', prixVal = '0', compteVenteVal = '';
        let referenceVal = '', codegrosVal = '';

        champsBase.forEach((col, idx) => {
            if (valeurs[idx] !== undefined) {
                if (col === 'reference') referenceVal = valeurs[idx].toString();
                if (col === 'codegros') codegrosVal = valeurs[idx].toString();
                if (col === 'pvgros') pvgrosVal = valeurs[idx].toString();
                if (col === 'compte' || col === 'compte_vente') compteVenteVal = valeurs[idx].toString();
                if (col === 'remise') remiseVal = valeurs[idx].toString();
            }
        });

        const labelParts = (selectedObj.label || "").split(' - ');
        if (labelParts.length >= 4) referenceVal = labelParts[3].trim();
        if (labelParts.length >= 5) codegrosVal = labelParts[4].trim();

        const originalInput = document.getElementById(inputID)
            ? document.getElementById(inputID).value : "";
        const barcodeInfo = parseWeightBarcode(originalInput);

        let isWholesaleCode = false;
        if (barcodeInfo.isWeightBased) {
            isWholesaleCode = codegrosVal && barcodeInfo.productCode.toString() === codegrosVal;
        } else {
            isWholesaleCode = codegrosVal && originalInput.toString() === codegrosVal;
        }

        if (isWholesaleCode) {
            hiddenEstEnGros.value = "1";
        }

        // Remplir les inputs
        finalColumns.forEach((col, idx) => {
            const val = defaults[col] !== undefined ? defaults[col] : (champsBase.indexOf(col) >= 0 ? valeurs[champsBase.indexOf(col)] : "");
            if (inputNames[idx] === 'qte' && overrideQuantity !== null) {
                qteVal = overrideQuantity.toString();
            } else {
                if (inputNames[idx] === 'photo') photoVal = val;
                if (inputNames[idx] === 'designation') designationVal = val;
                if (inputNames[idx] === 'qte') qteVal = val || '1';
                if (inputNames[idx] === 'reference') referenceVal = val;
                if (inputNames[idx] === 'pu') {
                    const priceToUse = isWholesaleCode && pvgrosVal ? pvgrosVal : val;
                    if (overrideQuantity !== null) {
                        const uniteParts = selectedObj.retour ? selectedObj.retour.split(';') : [];
                        const uniteCode = uniteParts.length >= 7 ? uniteParts[6] : null;
                        const basePrice = parseAmount(priceToUse);
                        puVal = uniteCode === "UNT00004"
                            ? ((overrideQuantity * basePrice) / 1000).toString()
                            : basePrice.toString();
                    } else {
                        puVal = priceToUse;
                    }
                }
                if (inputNames[idx] === 'pu_pvgros') pvgrosVal = val;
                if (inputNames[idx] === 'montantremise') remiseVal = val || '0';
                if (inputNames[idx] === 'prix') prixVal = val || '0';
                if (inputNames[idx] === 'compte') compteVenteVal = val;
            }

            if (inputNames[idx]) {
                let hiddenInput = document.getElementById(inputNames[idx] + "_" + rowCount);
                if (!hiddenInput) {
                    hiddenInput = document.createElement("input");
                    hiddenInput.type = "hidden";
                    hiddenInput.name = inputNames[idx] + "_" + rowCount;
                    hiddenInput.id = inputNames[idx] + "_" + rowCount;
                    row.appendChild(hiddenInput);
                }

                let inputValue = val;
                if (inputNames[idx] === 'qte' && overrideQuantity !== null) {
                    inputValue = overrideQuantity.toString();
                } else if (inputNames[idx] === 'pu') {
                    inputValue = puVal;
                } else if (inputNames[idx] === 'reference') {
                    inputValue = referenceVal;
                } else if (inputNames[idx] === 'compte') {
                    inputValue = compteVenteVal;
                }

                hiddenInput.value = inputValue;
            }
        });

        // addLine clone le HTML de la dernière ligne : remplacer son ancien libellé visible.
        const designationInput = row.querySelector("[name='designation_" + rowCount + "']");
        if (designationInput) {
            designationInput.type = "hidden";
            const articleCell = designationInput.closest("td");
            if (articleCell) {
                Array.from(articleCell.childNodes).forEach(function(node) {
                    if (node.nodeType !== Node.ELEMENT_NODE || node.tagName !== "INPUT") {
                        articleCell.removeChild(node);
                    }
                });
                const articleLabel = document.createElement("span");
                articleLabel.className = "Body14pxRegular";
                articleLabel.textContent = designationVal;
                articleCell.insertBefore(articleLabel, designationInput);
            }
        }

        // Stocker le prix de base pour les calculs au poids
        let basePriceKgInput = document.getElementById("basePriceKg_" + rowCount);
        if (!basePriceKgInput) {
            basePriceKgInput = document.createElement("input");
            basePriceKgInput.type = "hidden";
            basePriceKgInput.name = "basePriceKg_" + rowCount;
            basePriceKgInput.id = "basePriceKg_" + rowCount;
            row.appendChild(basePriceKgInput);
        }
        basePriceKgInput.value = parseAmount(puVal);

        // CHANGE STE : Base de remise par unité
        row.dataset.remiseUnitaire = (parseAmount(remiseVal) || 0) / (parseAmount(qteVal) || 1);

        // Affichage Image
        const photoInput = document.getElementById("photo_" + rowCount);
        if (photoInput) {
            photoInput.type = "hidden";
            const tdimg = photoInput.closest('td');
            if (tdimg) {
                tdimg.querySelectorAll("img").forEach(i => i.remove());
                const img = document.createElement("img");
                img.className = "product-img";
                img.alt = "Produit sélectionné";
                img.src = resolveProductImage(photoVal);
                img.onerror = function() { this.src = productImageFallback; };
                tdimg.insertBefore(img, photoInput);
            }
        }

        // Quantité & Boutons +/-
        const qteVisibleInput = document.getElementById("qte_" + rowCount) || row.querySelector("input[name^='qte_']");
        if (qteVisibleInput) {
            const tdqte = qteVisibleInput.closest("td");
            if (tdqte) {
                const minusBtn = document.createElement("button");
                minusBtn.className = "btn btn-secondary btn-small minus-btn-qte";
                minusBtn.type = "button";
                minusBtn.innerHTML = '<i class="material-symbols-rounded">remove</i>';
                minusBtn.onclick = function() {
                    const qteHiddenInput = row.querySelector("input[name^='qte_']");
                    const puInput = row.querySelector("input[name^='pvTva_']");
                    const basePriceKgInput = row.querySelector("input[name^='basePriceKg_']");
                    const uniteInput = row.querySelector("input[name^='unite_']");
                    const currentQte = parseAmount(qteHiddenInput?.value || 0);
                    const uniteCode = uniteInput?.value || '';
                    const isWeightBased = uniteCode === "UNT00004";
                    const decrement = isWeightBased ? 10 : 1;
                    const newQte = Math.max(currentQte - decrement, 0);

                    if (newQte === 0) {
                        requestQuantityRemoval(row);
                        return;
                    }

                    if (qteHiddenInput) qteHiddenInput.value = newQte;
                    if (qteVisibleInput) qteVisibleInput.value = newQte;

                    if (isWeightBased && basePriceKgInput && puInput) {
                        const basePricePerKg = parseAmount(basePriceKgInput.value);
                        puInput.value = (newQte * basePricePerKg) / 1000;
                    }
                    updateTotals();
                    sync();
                };

                const plusBtn = document.createElement("button");
                plusBtn.className = "btn btn-secondary btn-small plus-btn-qte";
                plusBtn.type = "button";
                plusBtn.innerHTML = '<i class="material-symbols-rounded">add</i>';
                plusBtn.onclick = function() {
                    const qteHiddenInput = row.querySelector("input[name^='qte_']");
                    const puInput = row.querySelector("input[name^='pvTva_']");
                    const basePriceKgInput = row.querySelector("input[name^='basePriceKg_']");
                    const uniteInput = row.querySelector("input[name^='unite_']");
                    const currentQte = parseAmount(qteHiddenInput?.value || 0);
                    const uniteCode = uniteInput?.value || '';
                    const isWeightBased = uniteCode === "UNT00004";
                    const increment = isWeightBased ? 10 : 1;
                    const newQte = currentQte + increment;
                    if (qteHiddenInput) qteHiddenInput.value = newQte;
                    if (qteVisibleInput) qteVisibleInput.value = newQte;

                    if (isWeightBased && basePriceKgInput && puInput) {
                        const basePricePerKg = parseAmount(basePriceKgInput.value);
                        puInput.value = (newQte * basePricePerKg) / 1000;
                    }
                    updateTotals();
                    sync();
                };

                qteVisibleInput.addEventListener('input', function() {
                    if (scheduleQuantityRemovalFromInput(row, qteVisibleInput)) {
                        updateTotals();
                        sync();
                    }
                });

                const qteWrapper = document.createElement("div");
                qteWrapper.className = "d-flex gap-1 qte-action-container";
                qteWrapper.appendChild(minusBtn);
                qteWrapper.appendChild(qteVisibleInput);
                qteWrapper.appendChild(plusBtn);

                tdqte.innerHTML = "";
                tdqte.appendChild(qteWrapper);
            }
        }

        // Unité
        let uniteCode = '';
        let uniteLibelle = '';
        champsBase.forEach((col, idx) => {
            if (col === 'unite' && valeurs[idx]) uniteCode = valeurs[idx].toString();
            if (col === 'uniteLibelle' && valeurs[idx]) uniteLibelle = valeurs[idx].toString();
        });
        if (!uniteLibelle && uniteCode === "UNT00004") uniteLibelle = "Gramme";
        else if (!uniteLibelle) uniteLibelle = "Unité";

        const hiddenUnite = document.getElementById("unite_" + rowCount);
        if (hiddenUnite) {
            const tdunite = hiddenUnite.closest("td");
            if (tdunite) {
                const unitSpan = document.createElement("span");
                unitSpan.className = "Body14pxRegular";
                unitSpan.textContent = uniteLibelle;
                tdunite.innerHTML = "";
                tdunite.appendChild(unitSpan);
                tdunite.appendChild(hiddenUnite);
            }
        }

        row.dataset.productPhoto = photoVal;
        row.dataset.productName = designationVal;
        row.dataset.productCode = productId;
        row.dataset.productReference = referenceVal;
        row.dataset.productPrice = puVal;

        try {
            if (typeof formaterActionLigne === 'function') {
                formaterActionLigne(row);
            }
        } catch(err) {}

        // CHANGE STE : Vérification asynchrone des remises particulières
        (function() {
            const idClient = document.querySelector("[name='idClient']")?.value
                || document.getElementById("idClient")?.value
                || "";
            const idPoint = '<%=session.getAttribute("idPoint")%>';

            fetch(`${pageContext.request.contextPath}/IngredientsRemiseServlet`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: new URLSearchParams({
                    idProduit: productId,
                    idClient: idClient,
                    idPoint: idPoint
                })
            })
                .then(response => response.json())
                .then(data => {
                    if (!row.isConnected ||
                        row.querySelector("[name='idProduit_" + rowCount + "']")?.value !== productId ||
                        (document.querySelector("[name='idClient']")?.value || document.getElementById("idClient")?.value || "") !== idClient) {
                        return;
                    }
                    if (data.hasRemise) {
                        row.dataset.remiseUnitaire = parseAmount(data.remise);
                        row.querySelector("[name='montantremise_" + rowCount + "']").value = data.remise;
                        row.querySelector("[name='pvTva_" + rowCount + "']").value = data.pvRemise; // Valeur numérique brute

                        updateTotals();
                        sync();
                    }
                })
                .catch(error => {
                    console.error("Error checking remise:", error);
                });
        })();

        // MAJ TOTAUX & SYNC
        sync();
        updateTotals();
        refreshProductPreview(productPreviewData);

        // FERMETURE DU CLAVIER ET CONSERVATION DU FOCUS SUR LA RECHERCHE
        fermerClavierVisuel();

        const searchInput = document.getElementById(inputID);
        if (searchInput) {
            if (typeof $ !== 'undefined' && $(searchInput).data('ui-autocomplete')) {
                try { $(searchInput).autocomplete("close"); } catch(e){}
            }
        }

        setTimeout(function() {
            focusOnProduit();
        }, 50);
    }


</script>
<%--calcul prix et calcul montant total a payer avec remise --%>
<script>

    // ================================================================
    // FORMATER L'AFFICHAGE DU PRIX UNITAIRE (PU)
    // ================================================================
    function formaterChampsPU() {
        document.querySelectorAll("#butfillejsp input[name^='pu_'], #butfillejsp input[name^='pvTva_'], #butfillejsp input[name^='montantttc_']").forEach(input => {
            // Ignorer si le champ est vide ou s'il a déjà le focus
            if (!input.value) return;

            const montantNumerique = parseAmount(input.value);

            // Formate avec "Ar" (ex: "15 000 Ar")
            // Note : mettez 'false' à la place de 'true' si vous souhaitez uniquement "15 000" sans "Ar"
            input.value = formatAmount(montantNumerique, true);
        });
    }

    function updateTotals() {
        let sousTotal = 0;
        let remiseTotale = 0;
        document.querySelectorAll("#ajout_multiple_ligne tr").forEach(tr => {
            const qteInput = tr.querySelector("input[name^='qte_']");
            const puInput = tr.querySelector("input[name^='pvTva_']");
            const remiseInput = tr.querySelector("input[name^='montantremise_']");
            const prixInput = tr.querySelector("input[name^='montant_']");
            const uniteInput = tr.querySelector("input[name^='unite_']");

            const montantCell = tr.querySelector(".montant-row");
            const qteMinusBtn = tr.querySelector(".minus-btn-qte");
            const qtePlusBtn = tr.querySelector(".plus-btn-qte");

            // Change Ste

            const quantite = parseAmount(qteInput?.value || 0);
            const prixUnitaire = parseAmount(puInput?.value || 0);
            const uniteCode = uniteInput?.value || '';
            const isWeightBased = uniteCode === "UNT00004";

            const remiseUnitaire = tr.dataset.remiseUnitaire !== undefined
                ? parseAmount(tr.dataset.remiseUnitaire)
                : parseAmount(remiseInput?.value || 0);
            const remise = isWeightBased
                ? parseAmount(remiseInput?.value || 0) // produits au poids: remise non multipliée par la quantité
                : remiseUnitaire * quantite;
            if (remiseInput) {
                remiseInput.value = remise;
            }

            //Change Ste

            if (isWeightBased) {
                qteMinusBtn?.setAttribute("disabled", true);
                qtePlusBtn?.setAttribute("disabled", true);
            } else {
                qteMinusBtn?.removeAttribute("disabled");
                qtePlusBtn?.removeAttribute("disabled");
            }


            const montantBrut = isWeightBased
                ? prixUnitaire
                : quantite * prixUnitaire;

            sousTotal += montantBrut;
            remiseTotale += remise;

            const montantNet = Math.max(montantBrut - remise, 0);

            if (prixInput) {
                prixInput.value = montantNet.toFixed(2);
            }
            if (montantCell) {
                montantCell.textContent = formatAmount(montantNet, true);
            }
            const prixCell = prixInput ? prixInput.closest('td') : tr.querySelector("td:nth-last-child(2)");
            if (prixCell) {
                setCellDisplay(prixCell, formatAmount(montantNet));
            }
        });

        const total = Math.max(sousTotal - remiseTotale, 0);

        const montantFactureElement = document.getElementById("montantFacture");
        if (montantFactureElement) montantFactureElement.textContent = formatAmount(total, true);

        const sousTotalElement = document.getElementById("recapSousTotal");
        if (sousTotalElement) {
            sousTotalElement.textContent = formatAmount(sousTotal, true);
        }
        const remiseElement = document.getElementById("recapRemises");
        if (remiseElement) {
            remiseElement.textContent = formatAmount(remiseTotale, true);
        }

        const totalElement = document.getElementById("totalGeneral");
        if (totalElement) {
            const roundedTotal = roundToNearest100(total);
            sendMessage("A PAYER: " + formatNumberWithSpaces(total) + " Ar");
            totalElement.textContent = formatAmount(total, true);

            const roundedCashElement = document.getElementById("montantArrondiEspeces");
            if (roundedCashElement) roundedCashElement.textContent = formatAmount(roundedTotal, true);

            const totalElementInput = document.getElementById("totalGeneralInput");
            if (totalElementInput) totalElementInput.value = total;
        }

        if (window.POSPayment && typeof window.POSPayment.refreshTotals === 'function') {
            window.POSPayment.refreshTotals();
        } else if (typeof calculerRetour === 'function') calculerRetour();
        formaterChampsPU();
    }

    function roundToNearest100(number) {
        return Math.round(number / 100) * 100;
    }

    function formatNumberWithSpaces(number) {
        return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
    }

    function sendMessage(texte) {
        const endpoint = "http://192.168.88.90:3100/lcd";
        const data = {
            message: texte
        };
        fetch(endpoint, {
            method: "POST",
            headers: {
                "content-type": "application/json"
            },
            body: JSON.stringify(data)
        })
            .then(
                (response) => {
                    if (!response.ok) {
                        throw new Error("Erreur réseau lors de l'envoi du message au LCD");
                    }
                    return response.json();
                }
            )
            .then(
                (result) => {
                    console.log("Message envoyé au LCD avec succès :", result);
                }
            ).catch(
            (error) => {
                console.error("Erreur lors de l'envoi du message au LCD :", error);
            }
        );
    }

    function attachEvents() {
        // document.querySelectorAll("input[name^='qte_'], input[name^='pu_'], input[name^='montantremise_']").forEach(input => {
        //     input.removeEventListener("input", updateTotals);
        //     input.addEventListener("input", updateTotals);
        //     input.removeEventListener("change", updateTotals);
        //     input.addEventListener("change", updateTotals);
        //     input.removeEventListener("blur", updateTotals);
        //     input.addEventListener("blur", updateTotals);
        // });
        document.querySelectorAll("a[onclick^='delete_line']").forEach(button => {
            button.removeEventListener("click", updateTotals);
            button.addEventListener("click", updateTotals);
        });
    }

    window.updateTotals = updateTotals;

    document.addEventListener("DOMContentLoaded", function() {
        attachEvents();
        checkPaymentValidation();
        updateTotals();
        refreshProductPreview();

        masquerEnTeteImageEnDouble();
        nettoyerBoutonsTableau();
        document.getElementById("ligne-multiple-0").classList.add("d-none");
        document.querySelectorAll('.box-footer.borderless.nopadding').forEach(footer => {
            footer.classList.add("d-none");
        })
    });

</script>
<script>

    // Change Ste
    function checkRemiseForRow(rowCount, productId, idClient, rowEl) {

        const idPoint = '<%=session.getAttribute("idPoint")%>';

        return fetch(`${pageContext.request.contextPath}/IngredientsRemiseServlet`, {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: new URLSearchParams({
                idProduit: productId,
                idClient: idClient,
                idPoint: idPoint
            })
        })
            .then(response => response.json())
            .then(data => {

                console.log("Checking remise:");
                console.log("Product:", productId);
                console.log("Client:", idClient);
                console.log("Point:", idPoint);
                console.log("Response:", data);

                // On utilise l'élément <tr> passé par recheckRemiseAllRows quand il est
                // disponible ; sinon on retombe sur la recherche par ID (autres appelants).
                const row = rowEl || document.getElementById("montantremise_" + rowCount)?.closest('tr');
                if (!row || !row.isConnected ||
                    row.querySelector("[name='idProduit_" + rowCount + "']")?.value !== productId ||
                    (document.querySelector("[name='idClient']")?.value || document.getElementById("idClient")?.value || "") !== idClient) {
                    return;
                }

                if (data.hasRemise) {

                    console.log("=== REMISE FOUND 2 ===");
                    console.log("Remise:", data.remise);
                    console.log("PV Remise:", data.pvRemise);

                    // data.remise est une remise PAR UNITE : mémorisée comme base,
                    // updateTotals() la multipliera par la quantité de la ligne.
                    row.dataset.remiseUnitaire = parseAmount(data.remise);
                    row.querySelector("[name='montantremise_" + rowCount + "']").value = data.remise;
                    row.querySelector("[name='pvTva_" + rowCount + "']").value = data.pvRemise;

                    console.log("Product:", productId);
                    console.log("NEW PU INPUT:", row.querySelector("[name='pvTva_" + rowCount + "']").value);
                    console.log("NEW REMISE INPUT:", row.querySelector("[name='montantremise_" + rowCount + "']").value);


                    updateTotals();

                } else {

                    console.log("No remise found for product:", productId);

                    // Reset remise if the new client does not have one
                    row.dataset.remiseUnitaire = 0;
                    row.querySelector("[name='montantremise_" + rowCount + "']").value = 0;

                    updateTotals();

                    // Here you need to decide:
                    // either restore original price
                    // or leave current price
                }

            })
            .catch(error => {
                console.error("Error checking remise:", error);
            });
    }

    // Change Ste

    // Change Ste
    $(document).ready(function () {
        $("#idClient").on("change", function () {

            let idClient = $(this).val();

            console.log("Client changed:", idClient);

            recheckRemiseAllRows(idClient);

        });
    });

    // CHECK REMISE HERE - rerun remise check for every already-selected product when the client changes
    function recheckRemiseAllRows(idClient) {

        console.log("Rechecking remise for client:", idClient);

        const promises = [];

        document.querySelectorAll("#ajout_multiple_ligne tr").forEach(tr => {
            const idProduitInput = tr.querySelector("input[name^='idProduit_']");
            if (!idProduitInput || !idProduitInput.value) return;

            const rowCount = idProduitInput.name.split("_")[1];
            promises.push(checkRemiseForRow(rowCount, idProduitInput.value, idClient, tr));
        });

        Promise.all(promises).then(() => {
            updateTotals();
            sync();
        });
    }

    // Change Ste

    function calculerMontant(indice,source) {
        var val = 0;
        $('input[id^="qte_"]').each(function() {
            var quantite =  parseFloat($("#"+$(this).attr('id').replace("qte","pvTva")).val());
            var montant = parseFloat($(this).val());
            if(!isNaN(quantite) && !isNaN(montant)){
                var value =quantite * montant;
                val += value;
            }
        });

        $('input[id^="montantremise_"]').each(function() {
            var remise = parseFloat($(this).val());  // <-- récupérer la valeur
            if (!isNaN(remise) && remise > 0) {
                val = val - remise;  // appliquer la remise en %
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
                        "table": "ST_INGREDIENTSAUTOVENTE_MGA",
                    },
                    "USD": {
                        "table": "ST_INGREDIENTSAUTOVENTE_EURO"
                    },
                    "EUR": {
                        "table": "ST_INGREDIENTSAUTOVENTE_USD"
                    }
                };
                $("#deviseLibelle").html($('#idDevise').val());
                var idDevise = $('#idDevise').val();
                $("#idDevise_"+iL).val(idDevise);
                let autocompleteTriggered = false;
                $("#idProduit_"+iL+"libelle").autocomplete('destroy');
                $("#tauxDeChange_"+iL).val('');
                $("#pvTva_"+iL).val('');
                $("#idProduit_"+iL+"libelle").autocomplete({
                    source: function(request, response) {
                        $("#idProduit_"+iL).val('');
                        if (autocompleteTriggered) {
                            fetchAutocomplete(request, response, "null", "id", "null", mapping[idDevise].table, "produits.IngredientsLib", "true","pv;libelleComposant;codebarre;taux");
                        }
                    },
                    select: function(event, ui) {
                        $("#idProduit_"+iL+"libelle").val(ui.item.label);
                        $("#idProduit_"+iL).val(ui.item.value);
                        $("#idProduit_"+iL).trigger('change');
                        $(this).autocomplete('disable');
                        var champsDependant = ['pvTva_'+iL,'compte_'+iL,'designation_'+iL,'codebarre_'+iL,'tauxDeChange_'+iL];
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

    function getIdNumber() {
        const ids = [];
        // Sélectionner tous les inputs dont le name commence par "designation_"
        document.querySelectorAll("input[name^='designation_']").forEach(input => {
            const match = input.name.match(/^designation_(\d+)$/);
            if (match) {
                ids.push(parseInt(match[1], 10));
            }
        });
        return ids;
    }

    function extractProductValue(id) {
        const designationInput = document.querySelector("[name='designation_"+id+"']");
        const idProduitInput = document.querySelector("[name='idProduit_"+id+"']");
        const quantiteInput = document.querySelector("[name='qte_"+id+"']");
        const prixInput = document.querySelector("[name='pvTva_"+id+"']");
        const montantremiseInput = document.querySelector("[name='montantremise_"+id+"']");
        const photoInput = document.querySelector("[name='photo_"+id+"']");
        const referenceInput = document.querySelector("[name='reference_"+id+"']");
        const basePriceKgInput = document.querySelector("[name='basePriceKg_"+id+"']");
        const compteVenteInput = document.querySelector("[name='compte_"+id+"']");


        // Get the row element
        const row = quantiteInput ? quantiteInput.closest('tr') : null;

        // FIX: Check the hidden unite input instead of a select
        const unitInput = document.querySelector("[name='unite_"+id+"']");

        if (!designationInput || !quantiteInput || !prixInput) {
            return null;
        }

        const designation = designationInput.value.trim();
        if (!designation) {
            return null;
        }

        const quantite = Number(quantiteInput.value);
        const prixunitaire = Number(prixInput.value);
        const montantremise = montantremiseInput ? Number(montantremiseInput.value) : 0;

        // FIX: Determine if the product is weight-based using the hidden input value (UNT00004)
        const isWeightBased = unitInput && unitInput.value === "UNT00004";

        return {
            id: idProduitInput ? idProduitInput.value : '',
            designation,
            reference: referenceInput?.value || '',
            quantite: isNaN(quantite) ? 0 : quantite,
            prixunitaire: isNaN(prixunitaire) ? 0 : prixunitaire,
            originalPrice: basePriceKgInput?.value || prixunitaire,
            montantremise: isNaN(montantremise) ? 0 : montantremise,
            urlPhoto: photoInput.value,
            isWeightBased: isWeightBased,
            compte: compteVenteInput ? compteVenteInput.value : ''
        };
    }

    function gatherProductData() {
        const ids = getIdNumber();
        const products = [];
        ids.forEach(id => {
            const product = extractProductValue(id);
            if (product) {
                products.push(product);
            }
        });
        return products;
    }
    function checkAndUpdateListener(id) {
        const input = document.getElementById(id);
        if (input) {
            if (!input.dataset.listenerAdded) {
                const update = () => {
                    const products = gatherProductData();
                    save(products);
                    console.log(products);
                };
                input.addEventListener('change', update);
                input.addEventListener('input', update);
                input.dataset.listenerAdded = 'true'; // marque en mémoire
            }
        }
    }

    function setupLinkListeners() {
        document.querySelectorAll("td a").forEach(link => {
            if (!link.dataset.listenerAdded) {
                link.addEventListener("click", () => {
                    sync();
                });
                link.dataset.listenerAdded = "true";
            }
        });
    }


    function setupListeners() {
        const ids = getIdNumber();
        ids.forEach(id => {
            checkAndUpdateListener("idProduit_" + id+"libelle");
            checkAndUpdateListener("designation_" + id);
            checkAndUpdateListener("qte_" + id);
            checkAndUpdateListener("pvTva_" + id);
            checkAndUpdateListener("remise_" + id);
            checkAndUpdateListener("montantremise_" + id);
        });
        setupLinkListeners();
    }

    function save(products) {
        // Exemple de sauvegarde dans localStorage
        localStorage.setItem('products', JSON.stringify(products));
        sendProducts(products);
        console.log('Données sauvegardées:', products);
    }

    function sync() {
        setupListeners();
        // Optionnel : appeler gatherProductData() pour initialiser l'état
        const products = gatherProductData();
        save(products);
        console.log("product sync", products);
    }

    document.addEventListener("DOMContentLoaded", function() {
        sync();
        console.log("Caisse script loaded");
    });

    // now setup socket connection
    const my_ip = window.location.hostname;
    const socket = io(my_ip+":3000"); // ton serveur socket
    socket.on("connect", () => {
        console.log("Connecté au serveur socket avec l'ID:", socket.id);
        // S'identifier en tant que caissier
        socket.emit("register", "caissier");
    });
    socket.on("registered", (data) => {
        console.log("Enregistré en tant que:", data);
    });
    socket.on("disconnect", () => {
        console.log("Déconnecté du serveur socket");
    });
    function sendProducts(produits = null) {
        try {
            let products = produits ? produits : gatherProductData();
            if (typeof socket !== 'undefined' && socket && typeof socket.emit === 'function') {
                socket.emit("send_products", products);
            }
        } catch (e) {
            // Ignorer complètement les erreurs socket pour ne pas bloquer le clavier
        }
    }
    // Envoyer les produits toutes les 30 secondes
    setInterval(sendProducts, 30000);

</script>

<script>
    let currentEditRow = null;

    document.addEventListener("click", function (e) {
        const btn = e.target.closest(".btn-modifier");
        if (!btn) {
            return;
        }

        currentEditRow = btn.closest("tr");
        if (!currentEditRow) {
            return;
        }

        const modalQuantite = document.getElementById("modalQuantite");
        const modalRemise = document.getElementById("modalRemise");
        const modalPrix = document.getElementById("modalPrix");
        const modalPhoto = document.getElementById("modalPhoto");
        const modalArticle = document.getElementById("modalArticle");
        const modalCode = document.getElementById("modalCode");

        //Récupération correcte des données depuis les inputs cachés
        const photoInput = currentEditRow.querySelector("input[name^='photo_']");
        const designationInput = currentEditRow.querySelector("input[name^='designation_']");
        const idProduitInput = currentEditRow.querySelector("input[name^='idProduit_']");
        const qteInput = currentEditRow.querySelector("input[name^='qte_']");
        const remiseInput = currentEditRow.querySelector("input[name^='montantremise_']");
        const prixUnitaireInput = currentEditRow.querySelector("input[name^='pvTva_']");

        //Affichage de l'image
        if (modalPhoto && photoInput) {
            const photoValue = photoInput.value;
            modalPhoto.src = resolveProductImage(photoValue);
            modalPhoto.onerror = function() {
                this.src = `${pageContext.request.contextPath}/assets/img/products/no_image.png`;
            };
        }

        //Affichage du nom de l'article
        if (modalArticle && designationInput) {
            modalArticle.textContent = designationInput.value || "Aucun article";
        }

        //Affichage de l'ID/Code produit
        if (modalCode && idProduitInput) {
            modalCode.textContent = idProduitInput.value || "--";
        }

        //Affichage du prix formaté
        if (modalPrix && prixUnitaireInput) {
            const prixValue = parseAmount(prixUnitaireInput.value || 0);
            modalPrix.textContent = formatAmount(prixValue, true);
        }

        //Valeurs pour les champs modifiables
        const qteValue = parseAmount(qteInput?.value || 0);
        const remiseValue = parseAmount(remiseInput?.value || 0);

        if (modalQuantite) {
            modalQuantite.value = Number.isInteger(qteValue) ? qteValue : qteValue.toFixed(2);
        }
        if (modalRemise) {
            modalRemise.value = remiseValue.toString();
        }
    });

    const modificationModal = document.getElementById("modif");
    if (modificationModal) {
        const minusBtn = document.getElementById("modalMinus");
        if (minusBtn) {
            minusBtn.addEventListener("click", function() {
                adjustModalQuantity(-1);
            });
        }

        const plusBtn = document.getElementById("modalPlus");
        if (plusBtn) {
            plusBtn.addEventListener("click", function() {
                adjustModalQuantity(1);
            });
        }

        modificationModal.addEventListener("click", function(e){
            if (!e.target.matches(".btn.btn-small.btn-primary")) {
                return;
            }
            if (!currentEditRow) {
                return;
            }

            const modalQuantite = document.getElementById("modalQuantite");
            const modalRemise = document.getElementById("modalRemise");

            const newQte = parseAmount(modalQuantite?.value || 0);
            const newRem = parseAmount(modalRemise?.value || 0);

            const qteInput = currentEditRow.querySelector("input[name^='qte_']");
            const remInput = currentEditRow.querySelector("input[name^='montantremise_']");

            if (qteInput) {
                qteInput.value = newQte;
            }
            if (remInput) {
                remInput.value = newRem;
            }

            //Change Ste

            // La remise saisie dans le modal est le montant TOTAL pour la ligne à la
            // quantité choisie ; on en déduit la base par unité pour que les futures
            // variations de quantité (boutons +/-) continuent à faire varier la remise
            // proportionnellement.
            currentEditRow.dataset.remiseUnitaire = newQte > 0 ? (newRem / newQte) : newRem;

            //Change Ste

            const quantityCell = qteInput ? qteInput.closest('td') : currentEditRow.cells[3];
            if (quantityCell) {
                const qteDisplay = Number.isInteger(newQte) ? newQte : newQte.toFixed(2);
                setCellDisplay(quantityCell, qteDisplay.toString());
            }

            const remiseCell = remInput ? remInput.closest('td') : currentEditRow.cells[5];
            if (remiseCell) {
                setCellDisplay(remiseCell, formatAmount(newRem));
            }

            updateTotals();

            if (modalQuantite) {
                modalQuantite.value = (Number.isInteger(newQte) ? newQte : newQte.toFixed(2)).toString();
            }
            if (modalRemise) {
                modalRemise.value = newRem.toString();
            }

            if (typeof $ !== "undefined" && typeof $('#modif').modal === "function") {
                $('#modif').modal('hide');
            } else if (typeof bootstrap !== "undefined" && bootstrap.Modal) {
                const modalInstance = bootstrap.Modal.getInstance(modificationModal);
                if (modalInstance) {
                    modalInstance.hide();
                }
            }
            sync();
        });
    }

</script>

<%--eto mode de paiement ( set caisse selon mode paiement ) pour tpe et espece seulement --%>
<script>
    function setPaymentMode(mode) {
        let form = document.getElementById("venteForm");

        let old = document.getElementById("paymentModeInput");
        if (old) old.remove();

        let hidden = document.createElement("input");
        hidden.type = "hidden";
        hidden.name = "modePaiement";
        hidden.value = mode;
        hidden.id = "paymentModeInput";
        form.appendChild(hidden);
    }
</script>

<script>
    function setPaymentWithRef(mode, refInputId) {
        let form = document.getElementById("venteForm");
        if (!form) return;

        document.querySelectorAll("#venteForm input#paymentModeInput, #venteForm input#paymentRefInput")
            .forEach(el => el.remove());

        let refValue = document.getElementById(refInputId)?.value || "";

        let hiddenMode = document.createElement("input");
        hiddenMode.type = "hidden";
        hiddenMode.name = "modePaiement";
        hiddenMode.value = mode;
        hiddenMode.id = "paymentModeInput";
        form.appendChild(hiddenMode);

        let hiddenRef = document.createElement("input");
        hiddenRef.type = "hidden";
        hiddenRef.name = "referencePaiement";
        hiddenRef.value = refValue;
        hiddenRef.id = "paymentRefInput";
        form.appendChild(hiddenRef);

        form.submit();
    }
</script>
<%-- Gestion centralisée des montants exacts, arrondis et paiements multiples --%>
<script>
    (function(window) {
        'use strict';

        const MODES = {
            especes: 'valeurEspece',
            mvola: 'montantMvola',
            orange: 'montantOrange',
            airtel: 'montantAirtel',
            cheque: 'montantCheque',
            visa: 'montantVisa',
            bonAchat: 'montantBOA',
            cadeaux: 'montantCarte'
        };
        const REFERENCES = {
            mvola: 'refMvola',
            orange: 'refOrange',
            airtel: 'refAirtel',
            cheque: 'refCheque',
            visa: 'refVisa',
            bonAchat: 'refBOA',
            cadeaux: 'refCarte'
        };
        const selectionOrder = [];

        const rules = {
            requiredAmount: function(exactTotal, roundedCashTotal, activeModes) {
                return activeModes.length === 1 && activeModes[0] === 'especes'
                    ? roundedCashTotal
                    : exactTotal;
            },
            remainingAmount: function(exactTotal, otherPayments) {
                return Math.max(exactTotal - otherPayments, 0);
            },
            balanceMode: function(activeModes, orderedModes) {
                for (let index = orderedModes.length - 1; index >= 0; index--) {
                    const mode = orderedModes[index];
                    if (mode !== 'especes' && activeModes.includes(mode)) return mode;
                }
                for (let index = activeModes.length - 1; index >= 0; index--) {
                    if (activeModes[index] !== 'especes') return activeModes[index];
                }
                return '';
            },
            cashChange: function(exactTotal, roundedCashTotal, activeModes, amounts) {
                if (!activeModes.includes('especes')) return 0;
                const cashPaid = amounts.especes || 0;
                if (activeModes.length === 1) {
                    return Math.max(cashPaid - roundedCashTotal, 0);
                }
                const nonCashPaid = activeModes.reduce(function(sum, mode) {
                    return mode === 'especes' ? sum : sum + (amounts[mode] || 0);
                }, 0);
                const cashRequired = Math.max(exactTotal - nonCashPaid, 0);
                return Math.max(cashPaid - cashRequired, 0);
            }
        };

        function getExactTotal() {
            const element = document.getElementById('totalGeneral');
            return element ? parseAmount(element.textContent) : 0;
        }

        function getRoundedCashTotal() {
            const element = document.getElementById('montantArrondiEspeces');
            if (element) return parseAmount(element.textContent);
            return Math.round(getExactTotal() / 100) * 100;
        }

        function getActiveModes() {
            return Array.from(
                document.querySelectorAll('.toggle-container .toggle-button.active input[name="payment-method"]')
            ).map(function(input) { return input.value; });
        }

        function isEffectiveMultiple() {
            const checkbox = document.getElementById('multiple-payment');
            return !!(checkbox && checkbox.checked && getActiveModes().length > 1);
        }

        function getSingleMode() {
            const modes = getActiveModes();
            return modes.length === 1 ? modes[0] : '';
        }

        function readAmountById(inputId) {
            const input = document.getElementById(inputId);
            if (!input || !input.value) return 0;
            const raw = input.value.replace(/\D/g, '');
            return raw ? parseInt(raw, 10) : 0;
        }

        function readModeAmount(mode) {
            return MODES[mode] ? readAmountById(MODES[mode]) : 0;
        }

        function usesImplicitSingleCash(activeModes) {
            return activeModes.length === 1
                && activeModes[0] === 'especes'
                && readModeAmount('especes') <= 0;
        }

        function getEffectiveModeAmount(mode, activeModes) {
            if (mode === 'especes' && usesImplicitSingleCash(activeModes)) {
                return getRoundedCashTotal();
            }
            return readModeAmount(mode);
        }

        function formatInputAmount(amount) {
            return amount > 0 ? Math.round(amount).toLocaleString('fr-FR') + ' Ar' : '';
        }

        function writeAmount(mode, amount, automatic) {
            const input = document.getElementById(MODES[mode]);
            if (!input) return;
            input.value = formatInputAmount(amount);
            if (automatic) input.dataset.paymentAuto = 'true';
            else delete input.dataset.paymentAuto;
        }

        function getAmounts(activeModes) {
            const amounts = {};
            activeModes.forEach(function(mode) {
                amounts[mode] = getEffectiveModeAmount(mode, activeModes);
            });
            return amounts;
        }

        function getPaidAmount(activeModes) {
            return activeModes.reduce(function(sum, mode) {
                return sum + getEffectiveModeAmount(mode, activeModes);
            }, 0);
        }

        function hideAmountError() {
            const error = document.getElementById('amount-error');
            if (error) error.style.display = 'none';
        }

        function showAmountError(input, message) {
            if (!input) return;
            let error = document.getElementById('amount-error');
            const parent = input.closest('.form-input') || input.parentNode;
            if (!error) {
                error = document.createElement('div');
                error.id = 'amount-error';
                error.className = 'error-message';
                error.style.cssText = 'color:red;margin-top:5px;font-size:14px;font-weight:bold;' +
                    'background:#ffe6e6;padding:5px;border:1px solid #ff0000;border-radius:4px;';
            }
            if (error.parentNode !== parent) parent.appendChild(error);
            error.textContent = message;
            error.style.display = 'block';
        }

        function setPaymentButtonState(valid) {
            const button = document.querySelector('#venteForm button[type="submit"].btn-primary.btn-large');
            if (!button) return;
            button.disabled = !valid;
            button.style.opacity = valid ? '1' : '0.6';
            button.style.cursor = valid ? 'pointer' : 'not-allowed';
        }

        function syncSubmissionState(activeModes) {
            const effectiveMultiple = isEffectiveMultiple();
            const hidden = document.getElementById('multiplePaymentInput');
            if (hidden) hidden.value = effectiveMultiple ? 'true' : 'false';

            if (activeModes.length === 1) {
                document.querySelectorAll('input[name="payment-method"]').forEach(function(radio) {
                    radio.checked = radio.value === activeModes[0];
                });

                const referenceId = REFERENCES[activeModes[0]];
                let referenceHidden = document.getElementById('paymentRefInput');
                if (!referenceHidden) {
                    referenceHidden = document.createElement('input');
                    referenceHidden.type = 'hidden';
                    referenceHidden.name = 'referencePaiement';
                    referenceHidden.id = 'paymentRefInput';
                    document.getElementById('venteForm').appendChild(referenceHidden);
                }
                referenceHidden.value = referenceId
                    ? (document.getElementById(referenceId)?.value || '')
                    : '';
            }
        }

        function clearInactiveAmounts(activeModes) {
            Object.keys(MODES).forEach(function(mode) {
                if (activeModes.includes(mode)) return;
                writeAmount(mode, 0, false);
            });
        }

        function applySingleDefault(activeModes, force) {
            if (activeModes.length !== 1 || !force) return;
            const mode = activeModes[0];
            if (mode === 'especes') return;
            const input = document.getElementById(MODES[mode]);
            if (!input) return;
            const target = rules.requiredAmount(getExactTotal(), getRoundedCashTotal(), activeModes);
            const current = readModeAmount(mode);
            if (current <= 0) {
                writeAmount(mode, target, true);
            }
        }

        function updateBalanceInputState(activeModes) {
            const balanceMode = activeModes.length > 1
                ? rules.balanceMode(activeModes, selectionOrder)
                : '';
            Object.keys(MODES).forEach(function(mode) {
                const input = document.getElementById(MODES[mode]);
                if (input) input.readOnly = mode === balanceMode;
            });
            return balanceMode;
        }

        function rebalance(activeModes) {
            if (activeModes.length < 2) return;
            const balanceMode = updateBalanceInputState(activeModes);
            if (!balanceMode) return;

            const otherPayments = activeModes.reduce(function(sum, mode) {
                return mode === balanceMode ? sum : sum + readModeAmount(mode);
            }, 0);
            writeAmount(
                balanceMode,
                rules.remainingAmount(getExactTotal(), otherPayments),
                true
            );
        }

        function updateRecapDisplay(activeModes) {
            const exactTotal = getExactTotal();
            const roundedCashTotal = getRoundedCashTotal();
            const paid = getPaidAmount(activeModes);
            const required = rules.requiredAmount(exactTotal, roundedCashTotal, activeModes);
            const change = rules.cashChange(exactTotal, roundedCashTotal, activeModes, getAmounts(activeModes));
            const paidElement = document.getElementById('montantPayerTexte');
            const changeElement = document.getElementById('montantRetourner');
            const changeInput = document.getElementById('aretourner');

            if (paidElement) paidElement.textContent = formatAmount(paid, true);
            if (changeInput) changeInput.value = change;

            if (changeElement) {
                if (paid < required) {
                    changeElement.textContent = 'Montant payé inférieur';
                    changeElement.className = 'Body14pxRegular';
                } else {
                    changeElement.textContent = formatAmount(change, true);
                    changeElement.className = 'h520pxSemibold';
                }
            }

            if (typeof sendMessage === 'function') {
                sendMessage(
                    'PAYE: ' + formatNumberWithSpaces(paid) + ' Ar||' +
                    'MONNAIE: ' + formatNumberWithSpaces(change) + ' Ar'
                );
            }
            return change;
        }

        function getFirstInvalid(activeModes) {
            if (!activeModes.length) return null;
            for (let index = 0; index < activeModes.length; index++) {
                const mode = activeModes[index];
                const amountInput = document.getElementById(MODES[mode]);
                if (readModeAmount(mode) <= 0 && !(mode === 'especes' && usesImplicitSingleCash(activeModes))) {
                    return amountInput;
                }
                if (mode !== 'especes') {
                    const referenceInput = document.getElementById(REFERENCES[mode]);
                    if (!referenceInput || !referenceInput.value.trim()) return referenceInput || amountInput;
                }
            }

            const required = rules.requiredAmount(getExactTotal(), getRoundedCashTotal(), activeModes);
            if (getPaidAmount(activeModes) < required) {
                return document.getElementById(MODES[activeModes[activeModes.length - 1]]);
            }
            return null;
        }

        function validate(showError) {
            const activeModes = getActiveModes();
            const invalidInput = getFirstInvalid(activeModes);
            const valid = !!activeModes.length && !invalidInput;
            setPaymentButtonState(valid);

            if (valid) {
                hideAmountError();
            } else if (showError && invalidInput) {
                const required = rules.requiredAmount(getExactTotal(), getRoundedCashTotal(), activeModes);
                showAmountError(
                    invalidInput,
                    'Montant minimum requis : ' + formatAmount(required, true)
                );
            }
            return valid;
        }

        function applyState(options) {
            const settings = options || {};
            const activeModes = getActiveModes();
            clearInactiveAmounts(activeModes);
            syncSubmissionState(activeModes);
            updateBalanceInputState(activeModes);

            if (activeModes.length === 1) {
                applySingleDefault(activeModes, !!settings.forceSingle);
            } else if (settings.rebalance !== false) {
                rebalance(activeModes);
            }

            updateRecapDisplay(activeModes);
            validate(false);
        }

        function handleAmountInput(event) {
            const input = event.currentTarget;
            delete input.dataset.paymentAuto;
            const raw = input.value.replace(/\D/g, '');
            input.value = raw ? formatInputAmount(parseInt(raw, 10)) : '';

            applyState({ sourceInputId: input.id, rebalance: true });
            try {
                const position = input.value.length - (input.value ? 3 : 0);
                input.setSelectionRange(position, position);
            } catch (ignored) {}
        }

        function handleModeChange(mode, active) {
            const previousIndex = selectionOrder.indexOf(mode);
            if (previousIndex >= 0) selectionOrder.splice(previousIndex, 1);
            if (active) selectionOrder.push(mode);
            applyState({ forceSingle: getActiveModes().length === 1, rebalance: true });
        }

        function handleMultipleChange() {
            applyState({ forceSingle: getActiveModes().length === 1, rebalance: true });
        }

        function refreshTotals() {
            applyState({ forceSingle: false, rebalance: true });
        }

        function prepareForSubmit() {
            const activeModes = getActiveModes();
            if (activeModes.length === 1) applySingleDefault(activeModes, false);
            else rebalance(activeModes);
            syncSubmissionState(activeModes);
            updateRecapDisplay(activeModes);
            return validate(true);
        }

        function applyImplicitCashForSubmission(activeModes) {
            if (!usesImplicitSingleCash(activeModes)) return function() {};
            const input = document.getElementById(MODES.especes);
            if (!input) return function() {};

            const previousValue = input.value;
            input.value = String(getRoundedCashTotal());
            return function() {
                if (document.contains(input)) input.value = previousValue;
            };
        }

        function resetRejectedSubmission() {
            if (typeof hideLoader === 'function') hideLoader();
            const button = document.querySelector('#venteForm button[type="submit"].btn-primary.btn-large');
            if (!button) return;
            button.disabled = false;
            button.style.opacity = '1';
            button.style.cursor = 'pointer';
            button.style.pointerEvents = 'auto';
            button.style.backgroundColor = '';
            button.textContent = 'Payer';
        }

        function init() {
            getActiveModes().forEach(function(mode) { selectionOrder.push(mode); });

            Object.keys(MODES).forEach(function(mode) {
                const input = document.getElementById(MODES[mode]);
                if (!input || input.dataset.paymentEngine) return;
                input.dataset.paymentEngine = 'true';
                input.addEventListener('input', handleAmountInput);
                input.addEventListener('blur', function() { validate(false); });
            });

            Object.keys(REFERENCES).forEach(function(mode) {
                const input = document.getElementById(REFERENCES[mode]);
                if (!input || input.dataset.paymentEngine) return;
                input.dataset.paymentEngine = 'true';
                input.addEventListener('input', function() {
                    syncSubmissionState(getActiveModes());
                    validate(false);
                });
            });

            const form = document.getElementById('venteForm');
            if (form && !form.dataset.paymentEngine) {
                form.dataset.paymentEngine = 'true';
                form.addEventListener('submit', function(event) {
                    if (prepareForSubmit()) {
                        const restoreImplicitCash = applyImplicitCashForSubmission(getActiveModes());
                        window.setTimeout(restoreImplicitCash, 0);
                        return;
                    }
                    event.preventDefault();
                    event.stopImmediatePropagation();
                    resetRejectedSubmission();
                    const activeModes = getActiveModes();
                    const required = rules.requiredAmount(getExactTotal(), getRoundedCashTotal(), activeModes);
                    alert('Paiement incomplet. Montant minimum requis : ' + formatAmount(required, true));
                    const invalidInput = getFirstInvalid(activeModes);
                    if (invalidInput) invalidInput.focus();
                }, true);
            }

            applyState({ forceSingle: true, rebalance: true });
        }

        window.POSPayment = {
            rules: rules,
            init: init,
            refreshTotals: refreshTotals,
            handleModeChange: handleModeChange,
            handleMultipleChange: handleMultipleChange,
            prepareForSubmit: prepareForSubmit,
            getExactTotal: getExactTotal,
            getRoundedCashTotal: getRoundedCashTotal,
            getActiveModes: getActiveModes,
            getPaidAmount: getPaidAmount
        };

        window.MODES = MODES;
        window.getPaymentInputId = function(mode) { return MODES[mode] || ''; };
        window.getMontantInputId = window.getPaymentInputId;
        window.getRefInputId = function(mode) { return REFERENCES[mode] || ''; };
        window.getModesActifs = getActiveModes;
        window.isMultiple = isEffectiveMultiple;
        window.getSingleMode = getSingleMode;
        window.getRawMontant = readAmountById;
        window.setMontant = function(inputId, amount) {
            const mode = Object.keys(MODES).find(function(key) { return MODES[key] === inputId; });
            if (mode) writeAmount(mode, amount, false);
        };
        window.getSomme = function(excludeId) {
            return getActiveModes().reduce(function(sum, mode) {
                return MODES[mode] === excludeId ? sum : sum + readModeAmount(mode);
            }, 0);
        };
        window.hideAmountError = hideAmountError;
        window.showAmountError = showAmountError;
        window.checkSingleModeAmount = function() {
            return getActiveModes().length === 1 && validate(false);
        };
        window.checkPaymentValidation = function() { return validate(false); };
        window.controler = function() { return validate(false); };
        window.calculerRetour = function() { return updateRecapDisplay(getActiveModes()); };
        window.updateRecap = function() { return updateRecapDisplay(getActiveModes()); };
        window.pasteMontantPayer = function() { return updateRecapDisplay(getActiveModes()); };
        window.pasteMontantPayerMultiple = window.pasteMontantPayer;
        window.attachSubmitGuard = function() {};

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', init);
        } else {
            init();
        }
    })(window);
</script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        var btn = document.getElementById('btnClavierABC');
        var modal = document.getElementById('clavier-abc');

        if (!btn || !modal) return;

        // Fonction pour ouvrir le modal
        function openModal() {
            // Empêcher d'ouvrir plusieurs fois
            if (modal.classList.contains('in')) return;

            modal.style.display = 'block';
            modal.setAttribute('aria-hidden', 'false');
            document.body.classList.add('modal-open');

            // Légère temporisation pour activer la transition .fade -> .in
            setTimeout(function() {
                modal.classList.add('in');
            }, 10);
        }

        // Fonction pour fermer le modal
        function closeModal() {
            modal.classList.remove('in');
            modal.setAttribute('aria-hidden', 'true');
            document.body.classList.remove('modal-open');

            // Attendre la fin de la transition (300ms environ comme Bootstrap)
            setTimeout(function() {
                modal.style.display = 'none';
            }, 300);
        }

        // Clic sur le bouton (ou tap mobile)
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            openModal();
        });
        btn.addEventListener('touchstart', function(e) {
            e.preventDefault();
            openModal();
        });

        // Clic sur la zone hors de la modale
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                closeModal();
            }
        });

        // Clic sur un bouton de fermeture interne (si présent)
        modal.addEventListener('click', function(e) {
            if (e.target.classList.contains('close')) {
                closeModal();
            }
        });

        // Fermeture avec la touche ESC
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && modal.classList.contains('in')) {
                closeModal();
            }
        });
        function addLinkAccueilLogo() {
            const img = document.getElementById("site-logo");
            const link = document.createElement("a");
            link.href = "<%=lien%>?but=accueil.jsp";

            img.parentNode.insertBefore(link, img);
            link.appendChild(img);
        }
        addLinkAccueilLogo();
    });
</script>


<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script>
    hideLoader();
    alert('<%=e.getMessage()%>');
    // eto ny manala redirection
    <%--window.location.href = "${pageContext.request.contextPath}/pages/module.jsp?but=vente/vente-saisie-directe-apj.jsp";--%>
</script>

<div id="errorMessage" class="alert alert-danger"
     style="
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        z-index: 99999;
        min-width: 300px;
        max-width: 500px;
        padding: 20px 30px;
        text-align: center;
        font-size: 18px;
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.3);
     ">
    <%= e.getMessage() %>
</div>

<%--<script>--%>
<%--    setTimeout(function(){--%>
<%--        window.location.href = "${pageContext.request.contextPath}/pages/module.jsp?but=caisse/ouveturecaisse/ouverturecaisse-saisie.jsp";--%>
<%--    }, 900);--%>
<%--</script>--%>
<% }%>
