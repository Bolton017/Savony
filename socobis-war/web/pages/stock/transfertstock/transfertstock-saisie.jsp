<%@page import="magasin.Magasin"%>
<%@page import="annexe.Categorie"%>
<%@page import="annexe.Point"%>
<%@page import="stock.TypeMvtStock"%>
<%@page import="stock.TransfertStockDetails"%>
<%@page import="stock.TransfertStock"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@ page import="fabrication.Of" %>
<%@ page import="demande.DemandeTransfert" %>
<%@ page import="vente.Vente" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="utils.ConstanteSavonnerie" %>
<%@ page import="magasin.DirectionMagasinLib" %>
<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (UserEJB) session.getValue("u");
        utilisateursocobis.UtilisateurStation user = new utilisateursocobis.UtilisateurStation();
        user.setTuppleId(u.getUser().getTuppleID());
        user = user.getUtilisateurByrefuser();
        String classeMere = "stock.TransfertStock",
               classeFille = "stock.TransfertStockDetails",
               titre = "Saisie de transfert de stock",
			   redirection = "stock/transfertstock/transfertstock-fiche.jsp";
        String colonneMere = "idTransfertStock";

        if(request.getParameter("acte")!=null){
            titre = "Modification du transfert de stock";
        }

        int taille = 10;
        String idOf = request.getParameter("idOf");
        TransfertStock preRempli = null;
        if (idOf != null && !idOf.isEmpty()) {
            Of of = new Of();
            of.setId(idOf);
            if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
                String idMagasinDepart = request.getParameter("idMagasinDepart");
                String idMagasinArrive = request.getParameter("idMagasinArrive");
                preRempli = of.genererTransfertStock(idMagasinDepart, idMagasinArrive,null);
            }else{
                preRempli = of.genererTransfertStock(null);
            }

            if (preRempli != null && preRempli.getFille() != null && preRempli.getFille().length > 0) {
                taille = preRempli.getFille().length >=10 ? (preRempli.getFille().length + 3) : 10;
            }

        }

        String idfc_client = request.getParameter("idfc_client");
        if (idfc_client != null && !idfc_client.isEmpty()) {
            Vente vente = new Vente();
            vente.setId(idfc_client);

            preRempli = vente.genererTransfertStock(null);


            if (preRempli != null && preRempli.getFille() != null && preRempli.getFille().length > 0) {
                taille = preRempli.getFille().length >=10 ? (preRempli.getFille().length + 3) : 10;
            }

        }

        String idDemandeTransfert = request.getParameter("idDemande");
        if (idDemandeTransfert != null && !idDemandeTransfert.isEmpty()) {
            DemandeTransfert dm = new DemandeTransfert();
            dm.setId(idDemandeTransfert);
            if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
                String idMagasinDepart = request.getParameter("idMagasinDepart");
                String idMagasinArrive = request.getParameter("idMagasinArrive");
                preRempli = dm.genererTransfertStock(idMagasinDepart, idMagasinArrive,null);
            }else{
                preRempli = dm.genererTransfertStock(null);
            }

            if (preRempli != null && preRempli.getFille() != null && preRempli.getFille().length > 0) {
                taille = preRempli.getFille().length >=10 ? (preRempli.getFille().length + 3) : 10;
            }
        }

        TransfertStock mere = new TransfertStock();
        mere.setNomTable("TransfertStock");
        TransfertStockDetails fille = new TransfertStockDetails();
        fille.setNomTable("TransfertStockDetails");
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("isvente").setVisible(false);

        Liste[] liste = new Liste[2];
        DirectionMagasinLib m1 = new DirectionMagasinLib();
        m1.setNomTable("DirectionMagasinLib");

        Magasin m2 = new Magasin();
        m2.setNomTable("magasinpoint");

        String awhereproduit = "";
        if(user.getService() != null && !user.getService().getDepartement().equals(ConstanteSavonnerie.DEPARTEMENT_DG)) {
            awhereproduit = "and idDirection = '" + user.getService().getDepartement() + "'";
        }

        liste[0] = new Liste("idMagasinDepart", m1, "idMagasinLib", "idmagasin",awhereproduit);
        liste[1] = new Liste("idMagasinArrive", m2, "val", "id");
        liste[1].ajouterVide();
        liste[0].ajouterVide();


        pi.getFormu().changerEnChamp(liste);
        String[] order = {"daty"};
        pi.getFormu().setOrdre(order);

        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("iddemande").setLibelle("Demande transfert");
        pi.getFormu().getChamp("iddemande").setPageAppelComplete("demande.DemandeTransfert","id","demandetransfert");
        pi.getFormu().getChamp("idMagasinDepart").setLibelle("Magasin de d&eacute;part");
        pi.getFormu().getChamp("idMagasinArrive").setLibelle("Magasin d'arriv&eacute;e");
        pi.getFormu().getChamp("idMagasinArrive").setAutre("onchange=\"updateFille(event, 'formId')\"");
        pi.getFormu().getChamp("idMagasinDepart").setAutre("onchange=\"updateFille(event, 'formId')\"");
        pi.getFormu().getChamp("idOf").setLibelle("Ordre de Fabrication Relatif");

        if(idDemandeTransfert != null && !idDemandeTransfert.isEmpty()){
            pi.getFormu().getChamp("idDemande").setVisible(false);
        }
        pi.getFormu().getChamp("idOf").setPageAppelComplete("fabrication.Of","id","OFAB");
        if(request.getParameter("idOf")!=null && !request.getParameter("idOf").isEmpty()) {
            pi.getFormu().getChamp("idOf").setValeur(idOf);
        }

        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("quantite_0").setLibelle("quantit&eacute;");
        pi.getFormufle().getChamp("idSource_0").setLibelle("Mouvement source");
        pi.getFormufle().getChamp("remarque_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("idFournisseur_0").setLibelle("Fournisseur");
        pi.getFormufle().getChamp("daty_0").setLibelle("Date");
        pi.getFormufle().getChamp("compteLocalisationDepart_0").setLibelle("Emplacement de depart");
        pi.getFormufle().getChamp("compteLocalisationArrivee_0").setLibelle("Emplacement d'arriv&eacute;e");
//        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idFournisseur"), "faturefournisseur.Fournisseur","id","fournisseur");

        String awheremagdep = "and 1 > 2";
        String awheremagArr = "and 1 > 2";
        String idMagasinDepart = "";
        String idMagasinArrive = "";
        String awhereMagdepSrc = "";

        if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
            if(request.getParameter("idMagasinDepart")!=null){
                session.setAttribute("idMagasinDepart", request.getParameter("idMagasinDepart"));
            }
            if(request.getParameter("idMagasinArrive")!=null){
                session.setAttribute("idMagasinArrive", request.getParameter("idMagasinArrive"));
            }
        }
        if(preRempli!=null){
            idMagasinDepart = preRempli.getIdMagasinDepart();
            idMagasinArrive = preRempli.getIdMagasinArrive();
            awhereMagdepSrc = "and idmagasin = '" + idMagasinDepart + "'";
            awheremagdep = " and classy = '" + idMagasinDepart + "'";
            awheremagArr = " and classy = '" + idMagasinArrive + "'";
        }

        if(session.getAttribute("idMagasinDepart") != null){
            idMagasinDepart = session.getAttribute("idMagasinDepart").toString();
            awhereMagdepSrc = "and idmagasin = '" + idMagasinDepart + "'";
            awheremagdep = " and classy = '" + idMagasinDepart + "'";
        }
        if(session.getAttribute("idMagasinArrive") != null){
            idMagasinArrive = session.getAttribute("idMagasinArrive").toString();
            awheremagArr = " and classy = '" + idMagasinArrive + "'";
        }

        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("compteLocalisationDepart"),"mg.cnaps.compta.Localisation","id","localisation","","",awheremagdep);
        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("compteLocalisationArrivee"),"mg.cnaps.compta.Localisation","id","localisation","","",awheremagArr);
        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTO","pu;libelle","pu;designation","");
        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idsource"),"stock.MvtStockEntreeAvecReste","id","V_ETATSTOCK_ENTREE","pu;idproduit","pu;idProduit",awhereMagdepSrc);





        Champ.setVisible(pi.getFormufle().getChampFille("idTransfertStock"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("daty"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("idFournisseur"),false);
        //Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idFournisseur"),"faturefournisseur.Fournisseur","id","fournisseur");

        String[] ordrefle = {"idProduit","remarque","quantite","pu","compteLocalisationDepart","compteLocalisationArrivee","idsource"};
        pi.getFormufle().setColOrdre(ordrefle);
        if(preRempli!=null){
            pi.setDefautFille(preRempli.getFille());
            pi.getFormu().setDefaut(preRempli);
        }



        affichage.Champ.setAutoCompleteDependante(pi.getFormufle().getChampFille("idProduit"), pi.getFormufle().getChampFille("idsource"), "stock.MvtStockEntreeAvecReste", "V_ETATSTOCK_ENTREE", "idProduit", "pu", "pu");

        pi.preparerDataFormu();

//        pi.getFormufle().setNbLigne(5);

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<style>
        .col-md-12.cardradius {
        margin-bottom: 20px;
    }

</style>
<div class="content-wrapper" >
    <h1><%=titre%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%

            out.println(pi.getFormu().getHtmlInsert());
        %>
        <div>
            <h3 class="h329pxBold">Détails du transfert de stock</h3>
        </div>
        <div id="butfillejsp">
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= taille %>">
        </div>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=redirection%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="classefille" value="TransfertStockDetails">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>

<%
	} catch (Exception e) {
		e.printStackTrace();
        session.removeAttribute("idMagasinDepart");
        session.removeAttribute("idMagasinArrive");
%>
    <script language="JavaScript">
        alert("<%=e.getMessage()%>");
        history.back();
    </script>
<% }%>
