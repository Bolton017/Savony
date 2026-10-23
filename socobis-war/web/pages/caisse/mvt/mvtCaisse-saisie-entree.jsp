<%@page import="utils.ConstanteStation"%>
<%@page import="affichage.*"%>
<%@page import="caisse.MvtCaisse"%>
<%@page import="caisse.Caisse"%>
<%@page import="user.*"%>
<%@page import="vente.Vente"%>
<%@page import="utilitaire.*"%>
<%@ page import="bean.TypeObjet" %>
<%@ page import="change.TauxDeChange" %>
<%

        String[] tId;
    try{
        MvtCaisse mvt = null;
        tId = request.getParameterValues("ids");
        if(tId!=null){
            Vente facture = new Vente();
            mvt = facture.genererPaiementFacture(tId,null);
            System.out.println("*******misy de tonga");
        }

        String tauxliste = TauxDeChange.getLastTauxAllDevisesJson(null, null);

        String lien = (String) session.getValue("lien");

        UserEJB user = (UserEJB) session.getValue("u");
        MvtCaisse mouvement = new MvtCaisse();
        if(request.getParameter("acte") != null && !request.getParameter("acte").equals("")){
            mouvement.setNomTable("mouvementcaisseautocomplete");
        }
        PageInsert pageInsert = new PageInsert( mouvement, request, user );
        pageInsert.setLien(lien);


        affichage.Champ[] liste = new affichage.Champ[2];
        liste[0] = new Liste("idDevise",new caisse.Devise(),"val","id");
        Caisse c = new Caisse();
        //c.setIdPoint(ConstanteStation.getFichierCentre());
        //liste[1] = new Liste("idCaisse",c,"val","id");

        //	liste[0] = new Liste("idDevise",new caisse.Devise(),"val","id");
        liste[1] = new Liste("idCaisse",c,"val","id");
//        liste[2] = new Liste("idModePaiement",new TypeObjet("MODEPAIEMENT"),"val","id");

        pageInsert.getFormu().changerEnChamp(liste);

        pageInsert.getFormu().getChamp("designation").setDefaut("Paiement du "+utilitaire.Utilitaire.dateDuJour());
        pageInsert.getFormu().getChamp("designation").setLibelle("d&eacute;signation");
        pageInsert.getFormu().getChamp("credit").setLibelle("Entr&eacute;e de tr&eacute;sorerie");
        pageInsert.getFormu().getChamp("idCaisse").setLibelle("Tr&eacute;sorerie");
        pageInsert.getFormu().getChamp("idDevise").setLibelle("Devise");
        pageInsert.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pageInsert.getFormu().getChamp("idmodepaiement").setLibelle("Mode de paiement");
        pageInsert.getFormu().getChamp("idmodepaiement").setVisible(false);
        pageInsert.getFormu().getChamp("idReport").setVisible(false);
        pageInsert.getFormu().getChamp("idCaissier").setVisible(false);
        pageInsert.getFormu().getChamp("heure").setVisible(false);
        pageInsert.getFormu().getChamp("idDevise").setDefaut("AR");
        pageInsert.getFormu().getChamp("idDevise").setAutre("onChange=changerTaux()");
        pageInsert.getFormu().getChamp("montantRetourner").setLibelle("Montant &agrave; retourner");
        pageInsert.getFormu().getChamp("montantRetourner").setVisible(false);
        pageInsert.getFormu().getChamp("datycomptabilisation").setLibelle("Date de comptabilisation");
        pageInsert.getFormu().getChamp("taux").setDefaut("1");
        pageInsert.getFormu().getChamp("idVirement").setVisible(false);
        pageInsert.getFormu().getChamp("idVenteDetail").setVisible(false);
        pageInsert.getFormu().getChamp("idtraite").setVisible(false);
        pageInsert.getFormu().getChamp("idOp").setVisible(false);
        pageInsert.getFormu().getChamp("etat").setVisible(false);
        pageInsert.getFormu().getChamp("idOrigine").setVisible(false);
        pageInsert.getFormu().getChamp("debit").setVisible(false);
        pageInsert.getFormu().getChamp("etatversement").setVisible(false);
        pageInsert.getFormu().getChamp("idmvtcaissemere").setVisible(false);
        // pageInsert.getFormu().getChamp("idcaisse").setVisible(false);
        pageInsert.getFormu().getChamp("daty").setLibelle("Date");
        pageInsert.getFormu().getChamp("idTiers").setPageAppelComplete("client.Client","id","Client");
        pageInsert.getFormu().getChamp("idTiers").setPageAppelInsert("client/client-saisie.jsp","idTiers;idTierslibelle","id;nom");
        pageInsert.getFormu().getChamp("idTiers").setLibelle("Tiers");
        pageInsert.getFormu().getChamp("idPrevision").setLibelle("Pr&eacute;vision");
        pageInsert.getFormu().getChamp("idPrevision").setPageAppelComplete("prevision.Prevision", "id", "PREVISION");
        pageInsert.getFormu().getChamp("compte").setLibelle("Compte de regroupement");
        if(tId!=null){
            pageInsert.getFormu().setDefaut(mvt);
            pageInsert.getFormu().getChamp("idOrigine").setAutre("readonly");
            pageInsert.getFormu().getChamp("credit").setAutre("readonly");
            pageInsert.getFormu().getChamp("credit").setDefaut(Utilitaire.formaterAr(mvt.getCredit()));
        }
		String[] ordre = {"daty"};
        pageInsert.getFormu().setOrdre(ordre);

        String classe = "caisse.MvtCaisse";
        String nomTable = "MOUVEMENTCAISSE";
        String butApresPost = "caisse/mvt/mvtCaisse-fiche.jsp";

        pageInsert.preparerDataFormu();
        pageInsert.getFormu().makeHtmlInsertTabIndex();
        String titre = "Saisie d&#39;un mouvement d&#39;entr&eacute;e de tr&eacute;sorerie";
            if(request.getParameter("acte")!=null){
            titre = "Modification d&#39;un mouvement d&#39;entr&eacute;e de tr&eacute;sorerie";
        }
%>

    <div class="content-wrapper">
        <h1 align="center"><%=titre%></h1>
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

<script>
    var tauxListe = <%= tauxliste %>;

        function changerTaux() {
            var devise = document.getElementById('idDevise').value;
            var champTaux = document.getElementById('taux');

            if (tauxListe.hasOwnProperty(devise)) {
                champTaux.value = tauxListe[devise];
            } else {
                champTaux.value = 1;
                console.warn('Aucun taux trouve pour la devise: ' + devise);
            }
        }
</script>
<%
		
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
		
</script>


<% }%>