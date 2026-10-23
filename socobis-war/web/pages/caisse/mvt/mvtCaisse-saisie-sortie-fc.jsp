<%@page import="utils.ConstanteStation"%>
<%@page import="affichage.*"%>
<%@page import="caisse.MvtCaisse"%>
<%@page import="caisse.Caisse"%>
<%@page import="user.*"%>
<%@ page import="utilitaire.Utilitaire" %>

<%


    try{

        String lien = (String) session.getValue("lien");

        UserEJB user = (UserEJB) session.getValue("u");
        MvtCaisse mouvement = new MvtCaisse();
        PageInsert pageInsert = new PageInsert( mouvement, request, user );
        pageInsert.setLien(lien);
        String  montant= Utilitaire.formaterAr(request.getParameter("montant")) ;
        String idOrigine=request.getParameter("idOrigine");
        String devise=request.getParameter("devise");
        String tiers=request.getParameter("tiers");
        String prev=request.getParameter("idPrevision");

        affichage.Champ[] liste = new affichage.Champ[1];
//				liste[0] = new Liste("idDevise",new caisse.Devise(),"val","id");
				Caisse c = new Caisse();
				//c.setIdPoint(ConstanteStation.getFichierCentre());
				liste[0] = new Liste("idCaisse",c,"val","id");
			
        pageInsert.getFormu().changerEnChamp(liste);
				pageInsert.getFormu().getChamp("designation").setDefaut("Paiement de la facture : "+idOrigine);
        pageInsert.getFormu().getChamp("idCaisse").setLibelle("Caisse");
        pageInsert.getFormu().getChamp("idDevise").setLibelle("Devise");
        pageInsert.getFormu().getChamp("idtraite").setLibelle("ID Traite");
        pageInsert.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pageInsert.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pageInsert.getFormu().getChamp("debit").setLibelle("D&eacute;bit");
        pageInsert.getFormu().getChamp("daty").setLibelle("Date");
        pageInsert.getFormu().getChamp("montantRetourner").setVisible(false);

        //pageInsert.getFormu().getChamp("datycomptabilisation").setLibelle("Date de comptabilisation");
        pageInsert.getFormu().getChamp("idtiers").setLibelle("Fournisseur");
        pageInsert.getFormu().getChamp("idtiers").setPageAppelComplete("faturefournisseur.Fournisseur","id","Fournisseur");
        pageInsert.getFormu().getChamp("idDevise").setDefaut(devise);
        pageInsert.getFormu().getChamp("idDevise").setAutre("readonly");
        String tauxParam = request.getParameter("taux");
        if (tauxParam != null && !tauxParam.isEmpty()) {
            pageInsert.getFormu().getChamp("taux").setDefaut(tauxParam);
        } else if (devise != null && !devise.equalsIgnoreCase("AR")) {
            double lastTaux = change.TauxDeChange.getLastTaux(null, null, devise);
            pageInsert.getFormu().getChamp("taux").setDefaut(String.valueOf(lastTaux));
        } else {
            pageInsert.getFormu().getChamp("taux").setDefaut("1");
        }
        pageInsert.getFormu().getChamp("idVirement").setVisible(false);

        pageInsert.getFormu().getChamp("idReport").setVisible(false);
        pageInsert.getFormu().getChamp("idCaissier").setVisible(false);
        pageInsert.getFormu().getChamp("heure").setVisible(false);
        pageInsert.getFormu().getChamp("idModePaiement").setVisible(false);
        pageInsert.getFormu().getChamp("idVenteDetail").setVisible(false);
        pageInsert.getFormu().getChamp("idtraite").setVisible(false);
        pageInsert.getFormu().getChamp("etatversement").setVisible(false);
        pageInsert.getFormu().getChamp("idmvtcaissemere").setVisible(false);
        pageInsert.getFormu().getChamp("datycomptabilisation").setVisible(false);
        pageInsert.getFormu().getChamp("idOp").setVisible(false);
        pageInsert.getFormu().getChamp("idOrigine").setVisible(false);
				pageInsert.getFormu().getChamp("credit").setVisible(false);
        pageInsert.getFormu().getChamp("etat").setVisible(false);
				pageInsert.getFormu().getChamp("idOrigine").setDefaut(idOrigine);
				pageInsert.getFormu().getChamp("idOrigine").setVisible(false);
        pageInsert.getFormu().getChamp("debit").setDefaut(montant);
				pageInsert.getFormu().getChamp("idTiers").setDefaut(tiers);
        //pageInsert.getFormu().getChamp("idTiers").setVisible(false);
        pageInsert.getFormu().getChamp("idPrevision").setLibelle("Pr&eacute;vision");
        pageInsert.getFormu().getChamp("idPrevision").setDefaut(prev);
        pageInsert.getFormu().getChamp("idprevision").setVisible(false);
        //pageInsert.getFormu().getChamp("idPrevision").setPageAppelComplete("prevision.Prevision", "id", "PREVISION");
        pageInsert.getFormu().getChamp("compte").setLibelle("Compte de regroupement");
        String[] ordre={"daty"};
        pageInsert.getFormu().setOrdre(ordre);

        String classe = "caisse.MvtCaisse";
        String nomTable = "MOUVEMENTCAISSE";
        String butApresPost = "caisse/mvt/mvtCaisse-fiche.jsp";

        pageInsert.preparerDataFormu();
        pageInsert.getFormu().makeHtmlInsertTabIndex();

%>

    <div class="content-wrapper">
        <h1 align="center">D&eacute;caissement</h1>
        <form action="<%=pageInsert.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
            <%
                out.println(pageInsert.getFormu().getHtmlInsert());
            %>
            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classe %>">
            <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
        </form>
    </div>

<%

    }catch(Exception e){
    
        e.printStackTrace();
    }

%>