<%@page import="affichage.*"%>
<%@page import="bean.*"%>
<%@page import="user.*"%>
<%@page import="caisse.Caisse" %>
<%@page import="caisse.MvtCaisse" %>
<%@ page import="caisse.Devise" %>
<%@ page import="utilitaire.Utilitaire" %>

<%
    try{

        /**
         * Data for mapping 
         *
         **/
        String nomTable = "MOUVEMENTCAISSE";
        String id = request.getParameter("id");
        String bute = "caisse/mvt/mvtCaisse-fiche.jsp";
        UserEJB user = (UserEJB) session.getValue("u");
        String lien = (String) session.getValue("lien");
        String classe = "caisse.MvtCaisse";

        String titre = "Modification de mouvement de caisse";

        String autreparsley = "data-parsley-range='[8, 40]' required";
        MvtCaisse mouvement = new MvtCaisse();

        PageUpdate pageUpdate = new PageUpdate( mouvement, request, user );

        Liste[] listes = new Liste[2];
        listes[0] = new Liste("idCaisse", new Caisse(), "val", "id");
        listes[1] = new Liste("idDevise", new Devise(), "val", "id");
        pageUpdate.getFormu().changerEnChamp(listes);

        String acte = request.getParameter("acte");
        if (acte != null) {
            titre = "Validation Comptable du mouvement caisse";
            pageUpdate.getFormu().getChamp("designation").setAutre("readonly");
            pageUpdate.getFormu().getChamp("credit").setAutre("readonly");
            pageUpdate.getFormu().getChamp("debit").setAutre("readonly");
            pageUpdate.getFormu().getChamp("daty").setAutre("readonly");
            pageUpdate.getFormu().getChamp("idDevise").setAutre("readonly");
            pageUpdate.getFormu().getChamp("idTiers").setAutre("readonly");
            pageUpdate.getFormu().getChamp("compte").setAutre("readonly");
            pageUpdate.getFormu().getChamp("idPrevision").setAutre("readonly");
            pageUpdate.getFormu().getChamp("idTraite").setAutre("readonly");
            pageUpdate.getFormu().getChamp("idModePaiement").setAutre("readonly");
            pageUpdate.getFormu().getChamp("taux").setAutre("readonly");
            pageUpdate.getFormu().getChamp("reference").setAutre("readonly");
        }

        pageUpdate.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pageUpdate.getFormu().getChamp("credit").setLibelle("Cr&eacute;dit");
        pageUpdate.getFormu().getChamp("debit").setLibelle("D&eacute;bit");
        pageUpdate.getFormu().getChamp("daty").setLibelle("Date");
        pageUpdate.getFormu().getChamp("datycomptabilisation").setLibelle("Date de Comptabilisation");
        //pageUpdate.getFormu().getChamp("datycomptabilisation").setDefaut(Utilitaire.dateDuJour());
        pageUpdate.getFormu().getChamp("idDevise").setLibelle("Devise");
        pageUpdate.getFormu().getChamp("idTiers").setLibelle("Tiers");
        pageUpdate.getFormu().getChamp("idTiers").setPageAppelComplete("faturefournisseur.Fournisseur","id","Fournisseur");
        //pageUpdate.getFormu().getChamp("idTiers").setPageAppelInsert("client/client-saisie.jsp","idTiers;idTierslibelle","id;nom");
        pageUpdate.getFormu().getChamp("compte").setLibelle("Compte");
        pageUpdate.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pageUpdate.getFormu().getChamp("idPrevision").setLibelle("Pr&eacute;vision");
        pageUpdate.getFormu().getChamp("idTraite").setLibelle("Traite");
        pageUpdate.getFormu().getChamp("idModePaiement").setLibelle("Mode de paiement");


        pageUpdate.setLien(lien);
        pageUpdate.getFormu().getChamp("idCaisse").setLibelle("Caisse");
        pageUpdate.getFormu().getChamp("etat").setVisible(false);
        pageUpdate.getFormu().getChamp("idVenteDetail").setVisible(false);
        pageUpdate.getFormu().getChamp("idVirement").setVisible(false);
        pageUpdate.getFormu().getChamp("id").setVisible(false);
        pageUpdate.getFormu().getChamp("idOp").setVisible(false);
        pageUpdate.getFormu().getChamp("idReport").setVisible(false);
        pageUpdate.getFormu().getChamp("idCaissier").setVisible(false);
        pageUpdate.getFormu().getChamp("montantRetourner").setVisible(false);
        pageUpdate.getFormu().getChamp("idOrigine").setVisible(false);
        pageUpdate.getFormu().getChamp("etatversement").setVisible(false);
        pageUpdate.getFormu().getChamp("idmvtcaissemere").setVisible(false);

        String[] ordre = {"daty","designation","idCaisse","debit","idDevise","taux","idTiers","compte","idPrevision"};
        pageUpdate.getFormu().setOrdre(ordre);
        pageUpdate.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pageUpdate.getFormu().getChamp("idDevise").setLibelle("Devise");
        pageUpdate.getFormu().getChamp("daty").setLibelle("Date");
        pageUpdate.getFormu().getChamp("idPrevision").setLibelle("Pr&eacute;vision");

        pageUpdate.preparerDataFormu();
%>
<style>
    .col-md-12.cardradius.input-container {
        padding: 0;
        border: none !important;
        border-top: none !important;
    }

    #uploadBox {
        display: none;
    }

</style>
<div class="content-wrapper">
    <h1><%= titre %></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <form action="<%= lien %>?but=apresTarif.jsp&id=<%= id %>" method="post">
                        <%
                            out.println(pageUpdate.getFormu().getHtmlInsert());
                        %>
                        <div class="row">
                            <div class="col-md-12" style="padding-top:12px">
                                <button class="btn btn-primary pull-right" name="Submit2" type="submit">Valider</button>
                            </div>
                            <br><br>
                        </div>
                        <input name="acte" type="hidden" id="acte" value="updateMvt">
                        <input name="bute" type="hidden" id="bute" value="<%= bute %>">
                        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
                        <input name="rajoutLien" type="hidden" id="rajoutLien" value="id-<%= id %>" >
                        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>


<%    }catch(Exception e){
    e.printStackTrace();
}


%>