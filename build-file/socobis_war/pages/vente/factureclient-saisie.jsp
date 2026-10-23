<%--
  Created by IntelliJ IDEA.
  User: maroussia
  Date: 2025-05-05
  Time: 15:25
  To change this template use File | Settings | File Templates.
--%>

<%@page import="vente.*"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@ page import="faturefournisseur.As_BonDeCommande" %>
<%@ page import="faturefournisseur.As_BonDeCommande_Fille_CPL" %>
<%@ page import="faturefournisseur.ModePaiement" %>
<%@ page import="pertegain.Tiers" %>
<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = u = (UserEJB) session.getValue("u");
        String classeMere = "vente.FactureClient",
                classeFille = "vente.FactureClientDetails",
                titre = "Saisie facture Client",
                redirection = "vente/factureclient-fiche.jsp";
        String colonneMere = "idFactureClient";
        int taille = 10;
        String idbc = request.getParameter("idbondecommande");
        String idbl = request.getParameter("idbl");

        Vente mere = new Vente();
        VenteDetails fille = new VenteDetails();
        fille.setNomTable("factureclientfille_saisie");
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
        pi.setLien((String) session.getValue("lien"));

        System.out.println("Liennn" + (String) session.getValue("lien"));

        As_BonDeCommande[] dbc = null;
        As_BonDeCommande_Fille_CPL[] detailsBC = null;

        As_BondeLivraisonClient[] bls = null;
        As_BondeLivraisonClientFille_Cpl[] detailsbl = null;

        if (idbc != null && idbc.startsWith("BCL")) {
            As_BonDeCommande bc = new As_BonDeCommande();
            bc.setNomTable("AS_BONDECOMMANDEclient_MERECPL");
            dbc = (As_BonDeCommande[]) CGenUtil.rechercher(bc, null, null, " and id='" + idbc + "' ");
            As_BonDeCommande_Fille_CPL bcfille = new As_BonDeCommande_Fille_CPL();
            bcfille.setNomTable("as_bondecommandeclient_cpl");
            detailsBC = (As_BonDeCommande_Fille_CPL[]) CGenUtil.rechercher(bcfille, null, null, " and idbc='" + idbc + "' ");
            pi = new PageInsertMultiple(mere, fille, request, detailsBC.length, u);
            pi.getFormu().getChamp("idBc").setDefaut(idbc);

        } else if (idbl != null && idbl.startsWith("BLC")) {
            As_BondeLivraisonClient bl = new As_BondeLivraisonClient();
            bl.setId(idbl);
            bls = (As_BondeLivraisonClient[]) CGenUtil.rechercher(bl, null, null, "");
            As_BondeLivraisonClientFille_Cpl blf = new As_BondeLivraisonClientFille_Cpl();
            blf.setNumbl(idbl);
            detailsbl = (As_BondeLivraisonClientFille_Cpl[]) CGenUtil.rechercher(blf, null, null, "");
            pi = new PageInsertMultiple(mere, fille, request, detailsbl.length, u);
            pi.getFormu().getChamp("idBc").setDefaut(idbl);

        } else {
            pi = new PageInsertMultiple(mere, fille, request, taille, u);
        }
        Liste[] liste = new Liste[1];

        ModePaiement mp = new ModePaiement();
        liste[0] = new Liste("idModePaiement",mp,"val","id");

//        TypeObjet magasin = new TypeObjet();
//        magasin.setNomTable("magasin");
//        liste[1] = new Liste("idMagasin", magasin, "val", "id");

        /*TypeObjet devise = new TypeObjet();
        devise.setNomTable("devise");
        liste[1] = new Liste("devise", devise, "val", "id");*/

        pi.getFormu().changerEnChamp(liste);

        Liste[] listeremise = new Liste[1];
        TypeObjet remise = new TypeObjet();
        remise.setNomTable("typeremise");
        listeremise[0] = new Liste("idtyperemise", remise, "val", "id");
        pi.getFormufle().changerEnChamp(listeremise);
        pi.getFormufle().getChamp("idtyperemise_0").setLibelle("Type remise");

        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idmodeledispo"), "boutique.article.ModeleDispoLib", "id", "modeledispo_lib", "prixvente", "pu");

        pi.getFormu().getChamp("idFournisseur").setPageAppelComplete("tiers.Tiers","id","clientlib");
        if(request.getParameter("fournisseur")!=null && request.getParameter("fournisseur").compareToIgnoreCase("") != 0){
            Tiers[] tiers= (Tiers[]) CGenUtil.rechercher(new Tiers(),null,null," and id='"+request.getParameter("fournisseur")+"' ");
            pi.getFormu().getChamp("idFournisseur").setDefaut(tiers[0].getId());
            pi.getFormu().getChamp("idFournisseur").setValeurLibelle(tiers[0].getNom());
        }
        pi.getFormu().getChamp("idMagasin").setDefaut("1");
        pi.getFormu().getChamp("idFournisseur").setLibelle("Client*");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation*");
        pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormu().getChamp("idModePaiement").setLibelle("Mode de paiement");
        pi.getFormu().getChamp("dateEcheancePaiement").setLibelle("Date &eacutech&eacuteance de paiement");
        pi.getFormu().getChamp("devise").setVisible(false);
        pi.getFormu().getChamp("devise").setDefaut("1");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("idMagasin").setVisible(false);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idBc").setLibelle("Source");
        pi.getFormu().getChamp("idBc").setAutre("readonly");
        pi.getFormu().getChamp("taux").setVisible(false);
        pi.getFormu().getChamp("taux").setDefaut("1");

        if (dbc != null && dbc.length > 0) {

            pi.getFormu().getChamp("idFournisseur").setDefaut(dbc[0].getFournisseur());
            pi.getFormu().getChamp("idFournisseur").setAutre("readonly");
            pi.getFormu().getChamp("idFournisseur").setValeurLibelle(Utilitaire.champNull(dbc[0].getFournisseurlib()));
            //pi.getFormufle().getChamp("idModeleDispoLib_0").setLibelle("Modele");

            for (int i = 0; i < detailsBC.length; i++) {
                //pi.getFormufle().getChamp("idModeleDispo_" + i).setPageAppelComplete("boutique.article.ModeleDispoLib","id","modeledispo_lib");
//                pi.getFormufle().getChamp("idModeleDispo_" + i).setDefaut(detailsBC[i].getIdmodeledispo());
//                pi.getFormufle().getChamp("idModeleDispo_" + i).setValeurLibelle(detailsBC[i].getIdmodeledispolib());
//                pi.getFormufle().getChamp("idtyperemise_" + i).setDefaut(detailsBC[i].getIdtyperemise());

                //pi.getFormufle().getChamp("idModeleDispo_" + i).setVisible(false);
                //pi.getFormufle().getChamp("idmodeledispolib_" + i).setDefaut(detailsBC[i].getIdmodeledispolib());
                //pi.getFormufle().getChamp("idModeleDispoLib_"+i).setAutre("readonly");
                //pi.getFormufle().getChamp("montant_" + i).setLibelle("Montant");
                //pi.getFormufle().getChamp("montant_" + i).setDefaut(Utilitaire.formaterAr(detailsBC[i].getPu()*detailsBC[i].getQuantite()));
                //pi.getFormufle().getChamp("montant_" + i).setAutre("readonly");
                pi.getFormufle().getChamp("idbcDetail_" + i).setDefaut(detailsBC[i].getId());
                pi.getFormufle().getChamp("idbcDetail_" + i).setAutre("readonly");

                pi.getFormufle().getChamp("qte_" + i).setDefaut(String.valueOf(detailsBC[i].getQuantite()));

                pi.getFormufle().getChamp("pu_" + i).setDefaut(String.valueOf(detailsBC[i].getPu()));
                pi.getFormufle().getChamp("tva_" + i).setDefaut(String.valueOf(detailsBC[i].getTva()));
                pi.getFormufle().getChamp("tva_" + i).setVisible(false);

                pi.getFormufle().getChamp("remises_" + i).setDefaut(String.valueOf(detailsBC[i].getRemise()));
                pi.getFormufle().getChamp("montant_" + i).setDefaut(Utilitaire.formaterAr(detailsBC[i].getPu() * detailsBC[i].getQuantite()));
                pi.getFormufle().getChamp("montant_" + i).setAutre("readonly");
            }
        } else if (bls != null && bls.length > 0) {
            pi.getFormu().getChamp("designation").setDefaut(bls[0].getRemarque());
            for (int i = 0; i < detailsbl.length; i++) {
                //pi.getFormufle().getChamp("idModeleDispo_" + i).setPageAppelComplete("boutique.article.ModeleDispoLib","id","modeledispo_lib");
//                pi.getFormufle().getChamp("idModeleDispo_" + i).setDefaut(detailsbl[i].getIdmodeledispo());
//                pi.getFormufle().getChamp("idModeleDispo_" + i).setValeurLibelle(detailsbl[i].getIdmodeledispolib());

                pi.getFormufle().getChamp("idbcDetail_" + i).setDefaut(detailsbl[i].getId());
                pi.getFormufle().getChamp("idbcDetail_" + i).setAutre("readonly");
                //pi.getFormufle().getChamp("idModeleDispo_" + i).setVisible(false);
                //pi.getFormufle().getChamp("idmodeledispolib_" + i).setDefaut(detailsbl[i].getIdmodeledispolib());
                //pi.getFormufle().getChamp("idModeleDispoLib_"+i).setAutre("readonly");
                //pi.getFormufle().getChamp("montant_" + i).setLibelle("Montant");
                //pi.getFormufle().getChamp("montant_" + i).setDefaut(Utilitaire.formaterAr(detailsbl[i].getPu()*detailsbl[i].getQuantite()));
                //pi.getFormufle().getChamp("montant_" + i).setAutre("readonly");
                pi.getFormufle().getChamp("pu_" + i).setDefaut("" + detailsbl[i].getPu());

                pi.getFormufle().getChamp("qte_" + i).setDefaut(String.valueOf(detailsbl[i].getQuantite()));
                pi.getFormufle().getChamp("qte_" + i).setAutre("readonly");

                pi.getFormufle().getChamp("pu_" + i).setAutre("onblur='calculerMontant(" + i + ")'");
                pi.getFormufle().getChamp("qte_" + i).setAutre("onblur='calculerMontant(" + i + ")'");
                pi.getFormufle().getChamp("montant_" + i).setAutre("readonly");
                pi.getFormufle().getChamp("montant_" + i).setLibelle("Montant");
            }
        } else {
            for (int i = 0; i < taille; i++) {
                //pi.getFormufle().getChamp("idModeleDispo_" + i).setPageAppelComplete("boutique.article.ModeleDispoLib","id","modeledispo_lib","prixachat","pu");
                //pi.getFormufle().getChamp("qte_" + i).setDefaut("0");
                pi.getFormufle().getChamp("pu_" + i).setDefaut("0");
                pi.getFormufle().getChamp("tva_" + i).setVisible(false);
                pi.getFormufle().getChamp("tva_" + i).setDefaut("0");
                pi.getFormufle().getChamp("remises_" + i).setDefaut("0");
                pi.getFormufle().getChamp("pu_" + i).setAutre("onblur='calculerMontant(" + i + ")'");
                pi.getFormufle().getChamp("qte_" + i).setAutre("onblur='calculerMontant(" + i + ")'");
                pi.getFormufle().getChamp("montant_" + i).setAutre("readonly");
                pi.getFormufle().getChamp("montant_" + i).setLibelle("Montant");
                //pi.getFormufle().getChamp("idModeleDispoLib_" + i).setVisible(false);
                pi.getFormufle().getChamp("idModeleDispo_0").setVisible(true);

            }
        }

        //pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("idModeleDispo_0").setLibelle("Modele");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Pu");
        pi.getFormufle().getChamp("tva_0").setLibelle("tva");
        pi.getFormufle().getChamp("remises_0").setLibelle("Remise");
        pi.getFormufle().getChamp("montant_0").setLibelle("Montant");
        Champ.setVisible(pi.getFormufle().getChampFille("id"), false);
        Champ.setVisible(pi.getFormufle().getChampFille("idbcDetail"), false);
        Champ.setVisible(pi.getFormufle().getChampFille("idFactureClient"), false);
        Champ.setVisible(pi.getFormufle().getChampFille("tva"), false);
        pi.preparerDataFormu();

//        pi.getFormufle().setNbLigne(5);
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<div class="container-apj">
    <div class="simple-block mt-5">
        <h1 class="title"><%=titre%></h1>
        <form class="col-12" action="module.jsp?but=apresMultiple.jsp" method="post" >
            <%

                out.println(pi.getFormu().getHtmlInsert());
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%=redirection%>">
            <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
            <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
            <input name="nomtable" type="hidden" id="classefille" value="FACTURECLIENTFILLE">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="10">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
        </form>
    </div>
</div>
<script language="JavaScript">
    function calculerMontant(indice) {
        var quantite, pu, montant;
        quantite = parseFloat($('#qte_' + indice).val());
        pu = parseFloat($('#pu_' + indice).val());
        if (!isNaN(quantite) && !isNaN(pu)) {
            montant = quantite * pu;
            $('#montant_' + indice).val(montant.toFixed(2));
        } else {
            $('#montant_' + indice).val('');
        }
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

<script>
    document.addEventListener("DOMContentLoaded", function () {
        var originalButton = document.getElementById("idFournisseursearchBtn");

        var newButton = originalButton.cloneNode(true);

        newButton.classList.add("btn", "btn-search", "ms-2");
        newButton.removeAttribute("id");
        newButton.setAttribute("onclick", "pagePopUp('popup/tiers/tiers-popup.jsp?champReturn=idFournisseur;idFournisseurlibelle&champUrl=id;nom')");

        var icon = newButton.querySelector("i");
        icon.classList.remove("fa-search");
        icon.classList.add("fa-plus");

        originalButton.insertAdjacentElement('afterend', newButton);
    });

    window.addEventListener('load', function() {
        let firstLimit = 10;
        for( let i = 0; i <firstLimit ; i++ ) {
            let currentId = 'idModeleDispo_'+i+'libelle';
            let input = document.getElementById('idModeleDispo_'+i+'libelle');
            input.addEventListener('keydown', function(event) {
                console.log('Mandalo lava be ty sakalava ty');
                if (event.key === 'Enter') {
                    event.preventDefault();
                    const currentInput = event.target;
                    const currentId = currentInput.id;
                    const nextId = currentId.replace(/\d+/, function(num) {
                        return parseInt(num) + 1;
                    });
                    const nextInput = document.getElementById(nextId);
                    const numMatch = nextId.match(/\d+/);
                    let checkboxname = 'checkbox';
                    let prevNum = -5;
                    if (numMatch) {
                        prevNum = parseInt(numMatch[0]) - 1;
                        checkboxname = checkboxname + prevNum;
                    }
                    $('#'+currentId).autocomplete({
                        source: function(request, response) {
                            $.ajax({
                                url: "/produit-boutique/autocomplete",
                                method: "GET",
                                contentType: "application/x-www-form-urlencoded",
                                dataType: "json",
                                data: {
                                    libelle: request.term,
                                    affiche: null,
                                    valeur: 'id',
                                    nomTable: 'modeledispo_lib',
                                    classe: 'boutique.article.ModeleDispoLib',
                                    champRetour: 'prixvente',
                                    colFiltre: 'id',
                                    useMotcle: true
                                },
                                success: function(data) {
                                    console.log(data);
                                    response($.map(data.valeure, function(item) {
                                        return {
                                            label: item.id,
                                            value: item.valeur,
                                            retour: item.retour
                                        };
                                    }));
                                }
                            });
                        },

                        response: function( event, ui ) {
                            let item = ui.content[0];
                            $('#pu_'+prevNum).val(item.retour);
                            $('#idModeleDispo_'+prevNum).val(item.label);
                            $('#idModeleDispo_'+prevNum+'libelle').val(item.value);
                            $('#qte_'+prevNum).val(1);
                            $('#montant_'+prevNum).val(item.retour);

                        }
                    });
                    $('#'+currentId).autocomplete('enable').autocomplete('search', event.target.value);
                    const checkbox = document.getElementById(checkboxname);
                    checkbox.checked = true;

                    if (nextInput) {
                        nextInput.focus();
                    }
                }
            });
        }
    });

</script>

