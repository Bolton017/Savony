<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="mg.cnaps.compta.*"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.*"%>
<%@page import="mg.cnaps.configuration.Configuration"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="bean.CGenUtil"%>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="mg.cnaps.compta.Journal" %>
<%
    try{
        UserEJB u = (UserEJB) session.getAttribute("u");

        ComptaSousEcritureLib  a = new ComptaSousEcritureLib ();
        a.setNomTable("COMPTA_SOUSECRITURE_LETTRE");

        String listeCrt[] = {"id","exercice","daty", "journal","ecriture","compte","compte_aux"};
        String listeInt[] = {"daty"};

        String libEntetedebit[] = { "id","daty","compte","journal", "compte_auxlib","ecriture","montant"};
        String libEnteteCredit[] = { "id","daty","compte","journal","compte_auxlib","ecriture","montant"};

        PageRechercheChoix prdebit  = new PageRechercheChoix(a, request, listeCrt, listeInt, 3, libEntetedebit, libEntetedebit.length, true);
        PageRechercheChoix prcredit = new PageRechercheChoix(a, request, listeCrt, listeInt, 3, libEnteteCredit, libEnteteCredit.length, true);

        prdebit.setPreciserChoix(true);
        prcredit.setPreciserChoix(true);

        prdebit.setUtilisateur((user.UserEJB) session.getValue("u"));
        prdebit.setLien((String) session.getValue("lien"));
        prdebit.setApres("compta/lettrage/lettrage-saisie.jsp");

        prcredit.setUtilisateur((user.UserEJB) session.getValue("u"));
        prcredit.setLien((String) session.getValue("lien"));
        prcredit.setApres("compta/lettrage/lettrage-saisie.jsp");
        prdebit.setAWhere(prdebit.getAWhere() + " AND (LETTRAGE IS NULL OR LETTRE = LOWER(LETTRE)) AND (ORIGINE IN ('FCF','VNT')) AND (COMPTE LIKE '401%' OR COMPTE LIKE '411%' OR COMPTE LIKE '445%')");
        prcredit.setAWhere(prcredit.getAWhere() + " AND (LETTRAGE IS NULL) AND (ORIGINE NOT IN ('FCF','VNT')) AND (COMPTE LIKE '401%' OR COMPTE LIKE '411%' OR COMPTE LIKE '445%')");

        affichage.Liste[] listeJournalDebit = new affichage.Liste[1];
        Journal jDebit = new Journal();
        jDebit.setNomTable("COMPTA_JOURNAL_ECRITURE_VIEW");
        listeJournalDebit[0] = new Liste("journal", jDebit, "val", "id");
        prdebit.getFormu().changerEnChamp(listeJournalDebit);

        affichage.Liste[] listeJournalCredit = new affichage.Liste[1];
        Journal jCredit = new Journal();
        jCredit.setNomTable("COMPTA_JOURNAL_ECRITURE_VIEW");
        listeJournalCredit[0] = new Liste("journal", jCredit, "val", "id");
        prcredit.getFormu().changerEnChamp(listeJournalCredit);

        prdebit.getFormu().getChamp("daty1").setLibelle("Date Min");
        prdebit.getFormu().getChamp("compte_aux").setLibelle("Auxiliaire");
        prdebit.getFormu().getChamp("compte_aux").setPageAppelComplete("pertegain.Tiers","id","tiers");
        prdebit.getFormu().getChamp("daty2").setLibelle("Date Max");
        prdebit.getFormu().getChamp("ecriture").setLibelle("&Eacute;criture");
        prdebit.getFormu().getChamp("exercice").setDefaut(Utilitaire.getAnneeEnCours());

        prcredit.getFormu().getChamp("daty1").setLibelle("Date Min");
        prcredit.getFormu().getChamp("compte_aux").setLibelle("Auxiliaire");
        prcredit.getFormu().getChamp("compte_aux").setPageAppelComplete("pertegain.Tiers","id","tiers");
        prcredit.getFormu().getChamp("daty2").setLibelle("Date Max");
        prcredit.getFormu().getChamp("exercice").setDefaut(Utilitaire.getAnneeEnCours());

        prdebit.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());
        prdebit.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());


        String[] colSomme = null;

        prdebit.setNpp(50);
        prcredit.setNpp(50);

        prdebit.creerObjetPage(libEntetedebit, colSomme);
        prcredit.creerObjetPage(libEnteteCredit, colSomme);

        int nombreLigneDebit = (prdebit.getTableau().getData() != null) ? prdebit.getTableau().getData().length : 0;
        int nombreLigneCredit = (prcredit.getTableau().getData() != null) ? prcredit.getTableau().getData().length : 0;
        int nombreLigne = nombreLigneDebit + nombreLigneCredit; // total si besoin pour le formulaire

        String nomtable = "compta_lettrage";

        Configuration[] lettrageParram = null;
        lettrageParram = (Configuration[]) CGenUtil.rechercher(new Configuration(), null, null, " AND TYPECONFIG = 'lettrage'");
        char[] l = lettrageParram[0].getRemarque().toLowerCase().toCharArray();
        String lettre = Utilitaire.incrementLettre(l);
%>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Lettrage</h1>
    </section>
    <section class="content">
        <form action="<%=prdebit.getLien()%>?but=compta/lettrage/lettrage-saisie.jsp" method="post" name="incident" id="incident">
            <%
                out.println(prdebit.getFormu().getHtmlEnsemble());
            %>
            <br>
            <input name="premier" type="hidden"  value="false">
        </form>

        <form action="<%=prdebit.getLien()%>?but=compta/lettrage/apresLettrage.jsp" id='modif-form' method="post" data-parsley-validate>
            <div class="result mt-5 table-result">
                <div class="row" >
                    <div class="col-md-3">
                        <label class="input-label" for="lettreInitial">Lettre</label>
                        <input class="form-control" id="lettreInitial" name="lettreInitial" type="text" readonly value="<%=lettre.toUpperCase()%>" >
                    </div>
                    <div class="col-md-3"  >
                        <label>Total D&eacute;bit</label>
                        <input class="form-control montant" id="totalDebit" name="totalDebit" readonly value="0" type="text">
                    </div>
                    <div class="col-md-3">
                        <label for="totalCredit" class="input-label">Total Cr&eacute;dit</label>
                        <input class="form-control montant" id="totalCredit" name="totalCredit" readonly value="0" type="text">
                    </div>
                    <div class="col-md-3">
                        <label class="input-label" for="ecart" >&Eacute;cart</label>
                        <input class="form-control" id="ecart" name="ecart" type="text" readonly value="0" readonly>
                    </div>
                </div>

                    <%
                    String libEnteteAffiche[] = {"ID","Date","Compte", "Journal", "Auxiliaire","Libell&eacute;","Montant"};
                    String lienTableau[] = {prdebit.getLien() + "?but=compta/lien-fiche.jsp&type=compte", prdebit.getLien() + "?but=compta/ecriture/sousecriture-fiche.jsp"};
                    String colonneLien[] = {"compte","id"};

                    prdebit.getTableau().setLien(lienTableau);
                    prdebit.getTableau().setColonneLien(colonneLien);
                    prdebit.getTableau().setLibelleAffiche(libEnteteAffiche);
                    prdebit.getTableau().setNameBoutton("Lettrer");
                    prdebit.getTableau().setNameActe("insertMereLierFille");
                    prdebit.getTableau().setNameActe2("insertMereLierFille");

                    prcredit.getTableau().setLien(lienTableau);
                    prcredit.getTableau().setColonneLien(colonneLien);
                    prcredit.getTableau().setLibelleAffiche(libEnteteAffiche);
                    prcredit.getTableau().setNameBoutton("Lettrer");
                    prcredit.getTableau().setNameActe("insertMereLierFille");
                    prcredit.getTableau().setNameActe2("insertMereLierFille");
                %>

                <div class="row">
                    <div class="col-md-6">
                        <div class="col-md-12 nopadding" id="bloc-debit">
                            <h4 class="h520pxSemibold" >Facture</h4>
                            <%
                                String htmlDebit = prdebit.getTableau().getHtmlWithCheckbox();
                                if (htmlDebit != null && !htmlDebit.trim().isEmpty() && !htmlDebit.trim().equalsIgnoreCase("null")) {
                                    out.println(htmlDebit);
                                } else {
                            %>
                            <p style="font-style: italic; margin-top: 10px;">Aucune facture à lettrer</p>
                            <%
                                }
                            %>
                        </div>
                        <div class="col-md-6" id="bloc-credit">
                            <h4 class="h520pxSemibold">Paiement</h4>
                            <%
                                String htmlCredit = prcredit.getTableau().getHtmlWithCheckbox();
                                if (htmlCredit != null && !htmlCredit.trim().isEmpty() && !htmlCredit.trim().equalsIgnoreCase("null")) {
                                    out.println(htmlCredit);
                                } else {
                            %>
                            <p style="font-style: italic; margin-top: 10px;">Aucun paiement à lettrer</p>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>

                <input name="acte" type="hidden" id="acte" value="insertMereLierFille">
                <input name="bute" type="hidden" id="bute" value="compta/lettrage/lettrage-saisie.jsp">
                <input name="classe" type="hidden" id="classe" value="mg.cnaps.compta.ComptaLettrage">
                <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=nombreLigne%>">
                <input name="colonneMere" type="hidden" id="colonneMere" value="id"/>
                <input name="colonneFille" type="hidden" id="colonneFille" value="lettrage"/>
                <input name="classeFille" type="hidden" id="classe" value="mg.cnaps.compta.ComptaEcriture"/>
                <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
                <input name="lettre" type="hidden" id="lettre" value="<%=lettre%>">
        </form>
    </section>
</div>

<%}catch(Exception e){
    e.printStackTrace();
}%>

<script>
    document.addEventListener("DOMContentLoaded", function () {

        document.querySelectorAll('#bloc-debit .box-footer button').forEach(function(btn) {
            if (btn.textContent.trim() === 'Lettrer') {
                btn.style.display = 'none';
            }
        });

        function parseMontant(text) {
            if (!text) return 0;
            return parseFloat(
                text.replace(/\u00a0/g, '')
                    .replace(/\s/g, '')
            ) || 0;
        }

        function getMontantFromRow(tr) {
            // On cherche la dernière cellule numérique de la ligne plutôt qu'un index fixe,
            // pour être robuste si la structure du tableau change.
            const tds = tr.querySelectorAll("td");
            if (!tds.length) return 0;
            // Essai sur les 3 dernières colonnes, la première qui donne un nombre > 0 est retenue
            for (let i = tds.length - 1; i >= 0; i--) {
                const val = parseMontant(tds[i].innerText);
                if (val !== 0) return val;
            }
            return 0;
        }

        window.recalculerTotaux = function () {
            let totalDebit = 0;
            let totalCredit = 0;

            const blocDebit = document.getElementById("bloc-debit");
            const blocCredit = document.getElementById("bloc-credit");

            if (blocDebit) {
                blocDebit.querySelectorAll('input[type="checkbox"]:checked').forEach(cb => {
                    const tr = cb.closest("tr");
                    if (tr) totalDebit += getMontantFromRow(tr);
                });
            }

            if (blocCredit) {
                blocCredit.querySelectorAll('input[type="checkbox"]:checked').forEach(cb => {
                    const tr = cb.closest("tr");
                    if (tr) totalCredit += getMontantFromRow(tr);
                });
            }

            const ecart = totalDebit - totalCredit;

            document.getElementById("totalDebit").value  = totalDebit.toLocaleString('fr-FR');
            document.getElementById("totalCredit").value = totalCredit.toLocaleString('fr-FR');
            document.getElementById("ecart").value       = ecart.toLocaleString('fr-FR');
        };

        // Délégation large : on écoute au niveau du document, sur change ET click,
        // et on filtre uniquement par "est une checkbox dans un des deux blocs".
        function onCheckboxInteraction(e) {
            const cb = e.target.closest('input[type="checkbox"]');
            if (!cb) return;
            if (cb.closest("#bloc-debit") || cb.closest("#bloc-credit")) {
                // petit délai pour laisser le DOM/attribut "checked" se mettre à jour avant de lire
                setTimeout(recalculerTotaux, 0);
            }
        }

        document.addEventListener("change", onCheckboxInteraction);
        document.addEventListener("click", onCheckboxInteraction);

        if (typeof window.CocheToutCheckbox === "function") {
            const originalCocheTout = window.CocheToutCheckbox;
            window.CocheToutCheckbox = function () {
                originalCocheTout.apply(this, arguments);
                setTimeout(recalculerTotaux, 0);
            };
        }

    });
</script>