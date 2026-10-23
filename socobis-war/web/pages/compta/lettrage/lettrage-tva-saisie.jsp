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

<%
    try{
        UserEJB u = (UserEJB) session.getAttribute("u");

        ComptaSousEcritureLib  a = new ComptaSousEcritureLib ();
        a.setNomTable("COMPTA_SOUSECRITURE_LETTRE");

        String listeCrt[] = {"id","daty","exercice", "idjournal","compte"};
        String listeInt[] = {"daty"};

        String libEntete[] = { "id","daty","exercice","compte","ecriture","journal","debit","credit"};

        PageRechercheChoix pr = new PageRechercheChoix(a, request, listeCrt, listeInt, 3, libEntete, libEntete.length,true);
        pr.setPreciserChoix(true);
        System.out.println(pr.getPremier());

        // pr.getFormu().getChamp("compte").setAutre("required");
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("compta/lettrage/lettrage-tva-saisie.jsp");
        pr.setAWhere(" AND LETTRAGE is NULL AND (compte LIKE '445%')");

        pr.getFormu().getChamp("daty1").setLibelle("Date Min");
        pr.getFormu().getChamp("daty2").setLibelle("Date Max");
        
        pr.getFormu().getChamp("exercice").setDefaut(Utilitaire.getAnneeEnCours());
        pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());
        pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());

        affichage.Liste[] listeJournal = new affichage.Liste[1];
        Journal j = new Journal();
        j.setNomTable("COMPTA_JOURNAL_ECRITURE_VIEW");
        listeJournal[0] = new Liste("idjournal", j, "desce", "id");
        pr.getFormu().changerEnChamp(listeJournal);
        pr.getFormu().getChamp("idjournal").setLibelle("Journal");
        //pr.getFormu().getChamp("numero").setLibelle("Libelle");


        String[] colSomme = null;

        pr.setNpp(300);

        pr.creerObjetPage(libEntete, colSomme);

        int nombreLigne = pr.getTableau().getData().length;
        String nomtable = "compta_lettrage";

        Configuration[] lettrageParram = null;
        lettrageParram = (Configuration[]) CGenUtil.rechercher(new Configuration(), null, null, " AND TYPECONFIG = 'lettrage'");
        System.out.println("json "+lettrageParram[0].getRemarque());
        char[] l = lettrageParram[0].getRemarque().toLowerCase().toCharArray();
        String lettre = Utilitaire.incrementLettre(l);
        System.out.println("lettre" +lettre);
%>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Lettrage</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=compta/lettrage/lettrage-tva-saisie.jsp" method="post" name="incident" id="incident">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <input name="premier" type="hidden"  value="false">
        </form>
        <% if (!pr.getPremier()) {%>
        <form action="<%=pr.getLien()%>?but=compta/lettrage/apresLettrage.jsp" id='modif-form' method="post" data-parsley-validate>
            <div class="result mt-5 table-result">
                <div class="row" >
                    <div class="col-md-3 mb-5">
                        <label class="input-label" for="lettreInitial">Lettre</label>
                        <input class="form-control" id="lettreInitial" name="lettreInitial" type="text" readonly value="<%=lettre.toUpperCase()%>" >
                    </div>
                    <div class="col-md-3"  >
                        <label>Total d&eacute;bit</label>
                        <input class="form-control montant" id="totalDebit" name="totalDebit" readonly value="0" type="text">
                    </div>
                    <div class="col-md-3">
                        <label for="totalCredit" class="input-label">Total cr&eacute;dit</label>
                        <input class="form-control montant" id="totalCredit" name="totalCredit" readonly value="0" type="text">
                    </div>
                    <div class="col-md-3">
                        <label class="input-label" for="ecart" >&Eacute;cart</label>
                        <input class="form-control" id="ecart" name="ecart" type="text" readonly value="0" readonly>
                    </div>
                </div>
                <%
                    String libEnteteAffiche[] = {"ID","Date","Exercice","Compte","Libell&eacute;","Journal","D&eacute;bit","Cr&eacute;dit"};
                    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
                    pr.getTableau().setNameBoutton("Lettrer");
                    pr.getTableau().setNameActe("insertMereLierFille");
                    pr.getTableau().setNameActe2("insertMereLierFille");

                    String lienTableau[] = {pr.getLien() + "?but=compta/lien-fiche.jsp&type=compte", pr.getLien() + "?but=compta/ecriture/sousecriture-fiche.jsp"};
                    String colonneLien[] = {"compte","id"};

                    pr.getTableau().setLien(lienTableau);
                    pr.getTableau().setColonneLien(colonneLien);
                    String html = pr.getTableau().getHtmlWithCheckbox();
                    String htmlDebit = pr.getTableau().getHtmlWithCheckbox();
                    if (htmlDebit != null && !htmlDebit.trim().isEmpty() && !htmlDebit.trim().equalsIgnoreCase("null")) {
                        out.println(htmlDebit);
                    } else {
                %>
                <p style="font-style: italic; margin-top: 10px;">Aucune donn&eacute;e disponnible</p>
                <%
                    }
                %>
            
            </div>
            <input name="acte" type="hidden" id="acte" value="insertMereLierFille">
            <input name="bute" type="hidden" id="bute" value="compta/lettrage/lettrage-tva-saisie.jsp">
            <input name="classe" type="hidden" id="classe" value="mg.cnaps.compta.ComptaLettrage">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=nombreLigne%>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="id"/>
            <input name="colonneFille" type="hidden" id="colonneFille" value="lettrage"/>
            <input name="classeFille" type="hidden" id="classe" value="mg.cnaps.compta.ComptaEcriture"/>
            <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
            <input name="lettre" type="hidden" id="lettre" value="<%=lettre%>">

        </form>
        <% } %>
    </section>
</div>


<%}catch(Exception e){
    e.printStackTrace();
}%>

<script>
    document.addEventListener("DOMContentLoaded", function () {

        function parseMontant(text) {
            if (!text) return 0;
            return parseFloat(
                text.replace(/\u00a0/g, '')
                    .replace(/\s/g, '')
            ) || 0;
        }

        window.recalculerTotaux = function () {
            let totalDebit = 0;
            let totalCredit = 0;

            document.querySelectorAll('input[type="checkbox"][name="ids"]:checked')
                .forEach(cb => {
                    const tr = cb.closest("tr");
                    const tds = tr.querySelectorAll("td");

                    const debitText  = tds[7]?.innerText || "0";
                    const creditText = tds[8]?.innerText || "0";

                    totalDebit  += parseMontant(debitText);
                    totalCredit += parseMontant(creditText);
                });

            const ecart = totalDebit - totalCredit;

            document.getElementById("totalDebit").value  = totalDebit.toLocaleString('fr-FR');
            document.getElementById("totalCredit").value = totalCredit.toLocaleString('fr-FR');
            document.getElementById("ecart").value       = ecart.toLocaleString('fr-FR');
        };

        document.addEventListener("change", function (e) {
            if (e.target.matches('input[type="checkbox"][name="ids"]')) {
                recalculerTotaux();
            }
        });

        if (typeof window.CocheToutCheckbox === "function") {
            const originalCocheTout = window.CocheToutCheckbox;

            window.CocheToutCheckbox = function () {
                originalCocheTout.apply(this, arguments);
                recalculerTotaux();
            };
        }

    });
</script>
