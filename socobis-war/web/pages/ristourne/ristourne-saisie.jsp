<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@page import="ristourne.*"%>
<%@page import="vente.*"%>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        Vente[] ventes = null;
        VenteDetailsLib[] venteDetails = null;
        if(request.getParameterValues("ids")!=null){
            Vente v = new Vente();
            ventes=v.controllerVentePaiementMultiple(request.getParameterValues("ids"));
            VenteDetailsLib vd = new VenteDetailsLib();
            vd.setNomTable("VENTE_DETAILS_CPL");
            venteDetails = vd.getDistinctProduit(request.getParameterValues("ids"));
        }
        Ristourne mere = new Ristourne();
        RistourneDetailsLib fille = new RistourneDetailsLib();
        int nombreLigne = 10;
        if(venteDetails!=null && venteDetails.length>0){
            nombreLigne = venteDetails.length;
        }
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));
        if(request.getParameterValues("ids")!=null) {
            String ids = String.join(",", request.getParameterValues("ids"));
            pi.getFormu().getChamp("idOrigine").setDefaut(ids);
        }

        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("idClient").setLibelle("Client");
        pi.getFormu().getChamp("idClient").setPageAppelComplete("client.Client","id","CLIENT");
        pi.getFormu().getChamp("idOrigine").setLibelle("Source");
        pi.getFormu().getChamp("idOrigine").setAutre("readonly");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("datedebutristourne").setLibelle("Date D&eacute;but Ristourne");
        pi.getFormu().getChamp("taux").setAutre("onchange=\"changeTauxFille()\"");
        pi.getFormu().getChamp("datefinristourne").setLibelle("Date Fin Ristourne");
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("estLiaisonPaiement").setVisible(false);
        pi.getFormu().getChamp("idVente").setVisible(false);

        pi.setTitre("Saisie d'une Ristourne");

        Liste [] liste = new Liste[1];
        String[] valMois = {"1","2","3","4","5","6","7","8","9","10","11","12"};
        String[] affMois = {"Janvier","Fevrier","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Decembre"};
        liste[0] = new Liste("mois" ,affMois,valMois);
        pi.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());
        pi.getFormu().changerEnChamp(liste);


        pi.getFormufle().getChamp("idproduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("idOrigine_0").setLibelle("Source");
        pi.getFormufle().getChamp("idProduitLib_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("taux1_0").setLibelle("Taux Ristourne (%)");
        //pi.getFormufle().getChamp("taux2_0").setLibelle("Taux Facture avant &eacute;ch&eacute;ance");
        if(ventes!=null){
            pi.getFormu().getChamp("idClient").setDefaut(ventes[0].getIdClient());
        }
        if(venteDetails!=null){
            pi.setNombreLigne(venteDetails.length);
            for (int i = 0; i < venteDetails.length; i++) {
                pi.getFormufle().getChamp("idproduit_"+i).setDefaut(venteDetails[i].getIdProduit());
                pi.getFormufle().getChamp("idProduitLib_"+i).setDefaut(venteDetails[i].getIdProduitLib());
                pi.getFormufle().getChamp("idorigine_"+i).setDefaut(venteDetails[i].getIdOrigine());
            }
        }

        String taux = "";
        if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
            taux = request.getParameter("taux");
        }

        for (int i = 0; i < pi.getNombreLigne(); i++) {
            //pi.getFormufle().getChamp("taux1_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("idProduitLib_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("taux1_"+i).setDefaut(taux+"");
        }

        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("taux2").setVisible(false);
        pi.getFormufle().getChampMulitple("idRistourne").setVisible(false);
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","id","AS_INGREDIENTS_LIB","libelle","idProduitLib");
        String[] order_fille = {"idproduit", "idProduitLib", "taux1","idOrigine"};
        pi.getFormufle().setColOrdre(order_fille);
        pi.preparerDataFormu();

        String classeMere = "ristourne.Ristourne";
        String classeFille = "ristourne.RistourneDetails";
        String butApresPost = "ristourne/ristourne-fiche.jsp";
        String colonneMere = "idRistourne";

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <h1>Cr&eacute;ation ristourne</h1>
    <div class="box-body">
        <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
            <%

                out.println(pi.getFormu().getHtmlInsert());
            %>
            <div class="col-md-12" >
                <h3 class="fontinter" style="background: white;padding: 16px;margin-top: 10px;border-radius: 16px;">Total  : <span id="montanttotal">0</span><span id="deviseLibelle">Ar</span></h3>
            </div>
            <div id="butfillejsp">
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>

            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
            <input name="nomtable" type="hidden" id="nomtable" value="RISTOURNEDETAILS">
        </form>
    </div>
</div>
</div>
<script language="JavaScript">
    function changeTauxFille() {
        var taux = document.getElementById("taux").value;
        console.log(taux);

        // Appliquer la valeur à tous les inputs "taux1"
        for (let i = 0; i < <%=pi.getNombreLigne()%>; i++) {
            let tauxs = document.getElementById("taux1_"+i);
            tauxs.value = taux;
        }

        // Rafraîchir la page avec le paramètre taux
        //let url = new URL(window.location.href);
        //url.searchParams.set("taux", taux);
        //window.location.href = url.toString();
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
