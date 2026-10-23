<%@page import="affichage.*"%>
<%@page import="caisse.MvtCaisse"%>
<%@page import="caisse.Caisse"%>
<%@page import="caisse.Devise"%>
<%@page import="user.*"%>
<%@ page import="change.TauxDeChange" %>
<%


    try{

        String lien = (String) session.getValue("lien");

        UserEJB user = (UserEJB) session.getValue("u");
        MvtCaisse mouvement = new MvtCaisse();
        PageInsert pageInsert = new PageInsert( mouvement, request, user );
        pageInsert.setLien(lien);

        String tauxliste = TauxDeChange.getLastTauxAllDevisesJson(null, null);

        Liste[] listes = new Liste[2];
        listes[0] = new Liste("idCaisse", new Caisse(),"val", "id");
        listes[1] = new Liste("idDevise", new Devise(),"val", "id");
        String[] order = {"daty"};
        pageInsert.getFormu().setOrdre(order);
        pageInsert.getFormu().changerEnChamp(listes);
        pageInsert.getFormu().getChamp("designation").setDefaut("Sortie du "+utilitaire.Utilitaire.dateDuJour());
        pageInsert.getFormu().getChamp("designation").setLibelle("d&eacute;signation");
        pageInsert.getFormu().getChamp("datycomptabilisation").setLibelle("Date de comptabilisation");
        pageInsert.getFormu().getChamp("etatversement").setLibelle("&Eacute;tat de versement");
        pageInsert.getFormu().getChamp("etatversement").setVisible(false);
        pageInsert.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pageInsert.getFormu().getChamp("idtraite").setLibelle("ID Traite");
        pageInsert.getFormu().getChamp("idtraite").setVisible(false);
        pageInsert.getFormu().getChamp("debit").setLibelle("Sortie de tr&eacute;sorerie");
        pageInsert.getFormu().getChamp("idCaisse").setLibelle("Tr&eacute;sorerie");
        pageInsert.getFormu().getChamp("daty").setLibelle("Date");
        pageInsert.getFormu().getChamp("idModePaiement").setVisible(false);
        pageInsert.getFormu().getChamp("heure").setVisible(false);
        pageInsert.getFormu().getChamp("idReport").setVisible(false);
        pageInsert.getFormu().getChamp("idCaissier").setVisible(false);
        pageInsert.getFormu().getChamp("idDevise").setDefaut("AR");
        pageInsert.getFormu().getChamp("idDevise").setAutre("onChange=changerTaux()");
        pageInsert.getFormu().getChamp("taux").setDefaut("1");
        pageInsert.getFormu().getChamp("idmvtcaissemere").setVisible(false);
        pageInsert.getFormu().getChamp("idVirement").setVisible(false);
        pageInsert.getFormu().getChamp("idVenteDetail").setVisible(false);
        pageInsert.getFormu().getChamp("idOp").setVisible(false);
        pageInsert.getFormu().getChamp("idOrigine").setVisible(false);
        pageInsert.getFormu().getChamp("etat").setVisible(false);
        pageInsert.getFormu().getChamp("idDevise").setLibelle("Devise");
        pageInsert.getFormu().getChamp("montantRetourner").setLibelle("Montant &agrave; retourner");
        pageInsert.getFormu().getChamp("montantRetourner").setVisible(false);
        pageInsert.getFormu().getChamp("credit").setVisible(false);
        pageInsert.getFormu().getChamp("idTiers").setPageAppelComplete("faturefournisseur.Fournisseur","id","fournisseur");
        pageInsert.getFormu().getChamp("idTiers").setPageAppelInsert("fournisseur/fournisseur-saisie.jsp","idTiers;idTierslibelle","id;nom");
        pageInsert.getFormu().getChamp("idTiers").setLibelle("Tiers");
        pageInsert.getFormu().getChamp("idPrevision").setLibelle("Pr&eacute;vision");
        pageInsert.getFormu().getChamp("idPrevision").setPageAppelComplete("prevision.Prevision", "id", "PREVISION");
        pageInsert.getFormu().getChamp("compte").setLibelle("Compte de regroupement");

        String classe = "caisse.MvtCaisse";
        String nomTable = "MOUVEMENTCAISSE";
        String butApresPost = "caisse/mvt/mvtCaisse-fiche.jsp";

        pageInsert.preparerDataFormu();
        pageInsert.getFormu().makeHtmlInsertTabIndex();
        String titre = "Saisie d&#39;un mouvement de sortie de caisse";
            if(request.getParameter("acte")!=null){
            titre = "Modification d&#39;un mouvement de sortie de caisse";
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

    }catch(Exception e){
    
        e.printStackTrace();
    }

%>