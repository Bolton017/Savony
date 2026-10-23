<%-- 
    Document   : avoirFC-saisie
    Created on : 2 ao�t 2024, 14:51:01
    Author     : randr
--%>

<%@page import="avoir.AvoirFC"%>
<%@page import="avoir.AvoirFCFille"%>
<%@page import="bean.TypeObjet"%>
<%@page import="user.*"%> 
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@page import="vente.*"%>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="avoir.AvoirFCLib" %>
<%@ page import="magasin.Magasin" %>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        String titre = "";
        if(request.getParameter("acte") != null && !request.getParameter("acte").isEmpty()){
            titre = "Modification d'une facture d'avoir";
        }else{
            titre="Enregistrement d'une facture d'avoir";
        }
        Vente vente = null;
        VenteDetails[] venteDetails = null;
        int nombreLigne = 10;

        if(request.getParameter("idvente")!=null){
            vente = new Vente();
            vente.setId(request.getParameter("idvente"));
            vente = (Vente) CGenUtil.rechercher(vente, null, null, "")[0];
            venteDetails = (VenteDetails[]) CGenUtil.rechercher(new VenteDetails(), null, null, " and IDVENTE = '"+vente.getId()+"'");
            if(venteDetails.length > nombreLigne) nombreLigne = venteDetails.length;
        }
        // rechargement des lignes (updateFille) : charger la facture avant de construire la page pour dimensionner nombreLigne
        if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
            vente=(Vente)new Vente().getById(request.getParameter("idVentelibelle"),"VENTE",null);
            if(vente!=null){
                venteDetails = (VenteDetails[]) CGenUtil.rechercher(new VenteDetails(), null, null, " and IDVENTE = '"+vente.getId()+"'");
                if(venteDetails.length > nombreLigne) nombreLigne = venteDetails.length;
            }
        }

        String idDevise = ConstanteSocobis.Devise;
        String deviseVente = null;
        if(vente!=null){
            VenteLib venteLib = (VenteLib) new VenteLib().getById(vente.getId(), "VENTE_CPL", null);
            if(venteLib!=null && venteLib.getIdDevise()!=null && !venteLib.getIdDevise().trim().isEmpty()){
                deviseVente = venteLib.getIdDevise().trim();
                idDevise = deviseVente;
            }
        }
        boolean avoirModif = "update".equals(request.getParameter("acte")) && request.getParameter("id") != null && !request.getParameter("id").isEmpty();
        if(avoirModif && !"true".equals(request.getParameter("onchanged"))){
            AvoirFCFille[] lignesModif = (AvoirFCFille[]) CGenUtil.rechercher(new AvoirFCFille(), null, null, " and IDAVOIRFC = '"+request.getParameter("id")+"'");
            if(lignesModif.length > 0 && lignesModif[0].getIdDevise()!=null && !lignesModif[0].getIdDevise().trim().isEmpty()){
                idDevise = lignesModif[0].getIdDevise().trim();
            }
        }

        AvoirFCLib mere = new AvoirFCLib();
        mere.setNomTable("AVOIRFC_VIDE");
        AvoirFCFille fille = new AvoirFCFille();
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));
        Liste[] liste = new Liste[4];
        Magasin m = new Magasin();
        m.setNomTable("MAGASINVENTE");
        liste[0] = new Liste("idMagasin", m,"val","id");
        TypeObjet cat = new TypeObjet();
        cat.setNomTable("categorieavoirfc");
        liste[1] = new Liste("idCategorie",cat,"val","id");
        TypeObjet typeavoir = new TypeObjet();
        typeavoir.setNomTable("typeavoir");
        liste[2] = new Liste("idtypeavoir",typeavoir,"val","id");
        liste[3] = new Liste("iddevise",new caisse.Devise(),"val","id");
        liste[3].setDefaut(idDevise);
        liste[3].setLibelle("Devise");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("idMotif").setLibelle("Motif");
        pi.getFormu().getChamp("idClient").setLibelle("Client");
        pi.getFormu().getChamp("idtypeavoir").setLibelle("Type");
        pi.getFormu().getChamp("idVente").setLibelle("ID Facture client");
        pi.getFormu().getChamp("idCategorie").setLibelle("Cat&eacute;gorie");
        pi.getFormu().getChamp("idClient").setPageAppelComplete("client.Client","id","Client");
        pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle","id;nom");
        if(vente!=null){
            pi.getFormu().getChamp("idVente").setAutre("readonly");
        }
        pi.getFormu().getChamp("idVente").setDefaut(""+request.getParameter("id"));

        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("numavoir").setVisible(false);
        pi.getFormu().getChamp("idOrigine").setVisible(false);
        pi.getFormu().getChamp("idristourne").setVisible(false);
        if(vente==null){
            pi.getFormu().getChamp("idVente").setPageAppelComplete("vente.Vente","id","VENTE","designation;id;idMagasin;idClient;idClient","designation;idOrigine;idMagasin;idClient;idClientlibelle");
            pi.getFormu().getChamp("idVente").setAutre("onchange=\"updateFille(event, 'formId')\"");
        }
        //fille
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"annexe.ProduitLib","id","PRODUIT_LIB_MGA","puVente;puAchat;taux;val","pu;puAchat;tauxDeChange;designation");
        affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampFille("idProduit"),"annexe/produit/produit-saisie.jsp","id;val");
        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        pi.getFormufle().getChamp("designation_0").setLibelle("Designation");
        pi.getFormufle().getChamp("remise_0").setLibelle("remise en pourcentage");
        pi.getFormufle().getChamp("idOrigine_0").setLibelle("Origine");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("tauxDeChange_0").setLibelle("Taux de change");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        String[] ordre={"daty"};
        pi.getFormu().setOrdre(ordre);
        //pi.getFormufle().getChampMulitple("tauxDeChange").setAutre("readonly");
        pi.preparerDataFormu();
        if(avoirModif && !"true".equals(request.getParameter("onchanged"))){
            pi.getFormu().getChamp("iddevise").setValeur(idDevise);
        }
        for(int i=0;i<nombreLigne;i++){
           // pi.getFormufle().getChamp("pu_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("qte_"+i).setDefaut("0");
            pi.getFormufle().getChamp("tva_"+i).setDefaut("0");
            pi.getFormufle().getChamp("idDevise_"+i).setDefaut("AR");
            pi.getFormufle().getChamp("idDevise_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("idDevise_"+i).setDefaut(idDevise);
            pi.getFormufle().getChamp("idDevise_"+i).setLibelle("Devise");
            // Ajouter les événements onChange pour calculer le total
            pi.getFormufle().getChamp("qte_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("idProduit_"+i).setAutreHidden("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("remise_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("tva_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("pu_"+i).setAutre("onChange='calculerMontant("+i+")'");
        }
        pi.getFormufle().getChampMulitple("id").setVisible(false);
         pi.getFormufle().getChampMulitple("idAvoirFC").setVisible(false);
        pi.getFormufle().getChampMulitple("IdOrigine").setVisible(false);
        pi.getFormufle().getChampMulitple("puAchat").setVisible(false);
        pi.getFormufle().getChampMulitple("idVentedetails").setVisible(false);
        pi.getFormufle().getChampMulitple("puVente").setVisible(false);


        if(vente!=null){
            pi.getFormu().getChamp("designation").setDefaut(vente.getDesignation());
            pi.getFormu().getChamp("idVente").setDefaut(vente.getId());
            pi.getFormu().getChamp("idOrigine").setDefaut(vente.getId());
            System.out.println("ID MADAGASIN="+vente.getIdMagasin());
            if(vente.getIdMagasin()!=null)pi.getFormu().getChamp("idMagasin").setDefaut(String.valueOf(vente.getIdMagasin()));
            pi.getFormu().getChamp("idClient").setDefaut(vente.getIdClient());
            pi.getFormu().getChamp("iddevise").setDefaut(idDevise);

            for (int i = 0; i < venteDetails.length; i++) {
                pi.getFormufle().getChamp("idProduit_"+i).setDefaut(venteDetails[i].getIdProduit());
                pi.getFormufle().getChamp("pu_"+i).setDefaut(String.valueOf(venteDetails[i].getPu()));
                pi.getFormufle().getChamp("remise_"+i).setDefaut(String.valueOf(venteDetails[i].getRemise()));
                pi.getFormufle().getChamp("tva_"+i).setDefaut(String.valueOf(venteDetails[i].getTva()));
                pi.getFormufle().getChamp("tauxDeChange_"+i).setDefaut(String.valueOf(venteDetails[i].getTauxDeChange()));
                pi.getFormufle().getChamp("designation_"+i).setDefaut(venteDetails[i].getDesignation());
                pi.getFormufle().getChamp("qte_"+i).setDefaut(String.valueOf(venteDetails[i].getQte()));
                if(venteDetails[i].getIdDevise()!=null && !venteDetails[i].getIdDevise().trim().isEmpty()){
                    pi.getFormufle().getChamp("idDevise_"+i).setDefaut(venteDetails[i].getIdDevise().trim());
                }
            }
        }
        /*String[] ordref={"idProduit","designation"};*/
        String[] ordref={"idProduit","designation","qte","pu","remise","tva","idDevise","tauxDeChange"};
        pi.getFormufle().setColOrdre(ordref);
        //Variables de navigation
        String classeMere = "avoir.AvoirFC";
        String classeFille = "avoir.AvoirFCFille";
        String butApresPost = "avoir/avoirFC-fiche.jsp";
        String colonneMere = "idAvoirFC";
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <h1><%= titre %></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%

            out.println(pi.getFormu().getHtmlInsert());
        %>
        <div class="col-md-12 cardradius">
            <h3 class="m-0" style="margin-top: 10px;" >Total  : <span id="montanttotal">0</span><span id="deviseLibelle"> <%=idDevise%></span></h3>
        </div>
        <div id="butfillejsp">
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
            <%-- dans le bloc recharge par updateFille pour suivre le nombre de lignes de la facture choisie --%>
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input type="hidden" id="deviseFactureCourante" value="<%= deviseVente != null ? deviseVente : "" %>">
            <script>
                (function () {
                    var info = document.getElementById('deviseFactureCourante');
                    if (!info || !info.value) return;
                    var deviseSelect = document.getElementById('iddevise');
                    if (deviseSelect && deviseSelect.value !== info.value) {
                        deviseSelect.value = info.value;
                        deviseSelect.dispatchEvent(new Event('change'));
                    }
                })();
            </script>
            <script>
                // re-execute par updateFille apres rechargement des lignes (changement de facture client)
                if (typeof calculerMontant === 'function') calculerMontant(0);
            </script>
        </div>

        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
    </form>
</div>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const deviseSelect = document.getElementById('iddevise') || document.getElementById('idDevise');
    if (deviseSelect) {
        $("#deviseLibelle").html(' ' + deviseSelect.value);
        deviseSelect.addEventListener('change', function () {
            $("#deviseLibelle").html(' ' + this.value);
            var devise = this.value;
            indicesLignes().forEach(function (i) {
                setValeurChamp('idDevise_' + i, devise);
            });
        });
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
$(document).ready(function () {
    var lignes = <%=nombreLigne%>
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

    function calculerMontant(indice) {
        var val = 0;
        $('input[id^="pu_"]').each(function() {
            var i = $(this).attr('id').split('_')[1];
            var pu = parseNombre($('#pu_' + i).val());
            var qte = parseNombre($('#qte_' + i).val());
            var remise = parseNombre($('#remise_' + i).val());
            var tva = parseNombre($('#tva_' + i).val());

            var montantht = (pu - (pu * remise / 100)) * qte;
            var montantttc = montantht + (montantht * (tva / 100));

            val += montantttc;
        });

        $("#montanttotal").html(formatNumber(val));
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

