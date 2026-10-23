<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@page import="mg.cnaps.compta.ComptaSousEcriture" %>
<%@page import="mg.cnaps.compta.ComptaEcriture" %>
<%@ page import="mg.cnaps.compta.Journal" %>
<script type="text/javascript">

    window.onload = function() {
        var selectElement = document.getElementById("journal");
        if (selectElement) {
            selectElement.addEventListener("change", handleSelectChange);
        }
    };

    function handleSelectChange(event) {
        // Récupérer la valeur sélectionnée
        var selectedValue = event.target.value;
        console.log("Valeur sélectionnée : " + selectedValue);
        var hiddenInputs = document.querySelectorAll('input[type="hidden"][id^="journal_"]');;
        hiddenInputs.forEach(function(input) {
            input.value = selectedValue;  // Met à jour la valeur de chaque input
        });
    }
</script>

<%
    try{
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    ComptaEcriture  mere = new ComptaEcriture();
    ComptaSousEcriture fille = new ComptaSousEcriture();
    int nombreLigne = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    nombreLigne = pi.getNombreLigne(); // en modification : nb sous-ecritures existantes + 10
     pi.setLien((String) session.getValue("lien"));
    affichage.Liste[] liste = new affichage.Liste[1];
//    TypeObjet journal = new TypeObjet();
//    journal.setNomTable("COMPTA_JOURNAL_ECRITURE_VIEW");
//    liste[0] = new Liste("journal", journal, "desce", "id");
//    ComptaEcriture exercice = new ComptaEcriture();
//    exercice.setNomTable("COMPTA_EXERCICE");
//    liste[0] = new Liste("exercice", exercice, "id", "id", " and etat = '1'");
//    liste[0].setDefaut(String.valueOf(Utilitaire.getAnneeEnCours()));
    Journal j = new Journal();
    j.setNomTable("COMPTA_JOURNAL_VIEW");
    liste[0] = new Liste("journal", j, "desce", "id");

        pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("exercice").setDefaut(Utilitaire.getAnneeEnCours());
    pi.getFormu().getChamp("designation").setLibelle("Libell&eacute;");
    pi.getFormu().getChamp("daty").setLibelle("Date");
//    pi.getFormu().getChamp("daty").setAutre("readonly");
    pi.getFormu().getChamp("dateComptable").setLibelle("Date Comptable");
    pi.getFormu().getChamp("dateComptable").setVisible(false);
//    pi.getFormu().getChamp("horsExercice").setLibelle("Hors Exercice");
    pi.getFormu().getChamp("dateSaisie").setLibelle("Date de saisie");
    pi.getFormu().getChamp("dateSaisie").setDefaut(Utilitaire.dateDuJour());
    pi.getFormu().getChamp("dateSaisie").setAutre("readonly");
    pi.getFormu().getChamp("lettrage").setVisible(false);
    pi.getFormu().getChamp("horsExercice").setVisible(false);
    pi.getFormu().getChamp("horsExercice").setDefaut("0");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("od").setVisible(false);
//    pi.getFormu().getChamp("dateSaisie").setVisible(false);
    pi.getFormu().getChamp("dateModif").setVisible(false);
    pi.getFormu().getChamp("idModificateur").setVisible(false);
    pi.getFormu().getChamp("credit").setVisible(false);
    pi.getFormu().getChamp("debit").setVisible(false);
    pi.getFormu().getChamp("od").setVisible(false);
    pi.getFormu().getChamp("periode").setVisible(false);
    pi.getFormu().getChamp("trimestre").setVisible(false);
     pi.getFormu().getChamp("trimestre").setDefaut("0");
    //  pi.getFormu().getChamp("journal").setDefaut("");
    pi.getFormu().getChamp("annee").setVisible(false);
    pi.getFormu().getChamp("origine").setVisible(false);
    pi.getFormu().getChamp("origine").setDefaut("VNT");
    pi.getFormu().getChamp("idobjet").setVisible(false);
    pi.getFormu().getChamp("remarque").setVisible(false);
    pi.getFormufle().getChamp("Compte_0").setLibelle("Compte");
    pi.getFormufle().getChamp("remarque_0").setLibelle("Libell&eacute;");
    pi.getFormufle().getChamp("compte_aux_0").setLibelle("Auxiliaire");
    pi.getFormufle().getChamp("analytique_0").setLibelle("Analytique");
//    pi.getFormufle().getChamp("Folio_0").setLibelle("Folio");
    pi.getFormufle().getChamp("libellePiece_0").setLibelle("Pi&egrave;ce");
    pi.getFormufle().getChamp("debit_0").setLibelle("Debit");
    pi.getFormufle().getChamp("credit_0").setLibelle("Credit");
    pi.getFormufle().getChamp("daty_0").setLibelle("date");
    pi.getFormufle().setColOrdre(new String[]{"Compte","compte_aux","analytique","debit", "credit","remarque","libellePiece"});
    for (int i = 0; i < nombreLigne ; i++) {
        pi.getFormufle().getChamp("etat_"+i).setDefaut("1");
        pi.getFormufle().getChamp("remarque_"+i).setType("textarea");
        pi.getFormufle().getChamp("compte_"+i).setAutreHidden("onchange=\"handleAccountChange(this)\"");
        pi.getFormufle().getChamp("debit_"+i).setAutre("onchange=\"loadCompteJournal(this)\"");
        pi.getFormufle().getChamp("credit_"+i).setAutre("onchange=\"loadCompteJournal(this)\"");
    }
    String aWhere1 = "and TYPECOMPTE='1'";
    new ChampCompte("compte",pi.getFormufle(), aWhere1);
    String aWhere2 = "and TYPECOMPTE='3'";
    //new ChampCompte("analytique",pi.getFormufle(), aWhere2);
    //affichage.Champ.setPageAppelCompletePropre(pi.getFormufle().getChampFille("compte"), "mg.cnaps.compta.ComptaCompte", "compte", "compta_compte", "", "", "");
    affichage.Champ.setPageAppelCompletePropre(pi.getFormufle().getChampFille("analytique"), "mg.cnaps.compta.ComptaCompte", "compte", "compta_compte", "", "", aWhere2);
    //affichage.Champ.setPageAppelCompletePropre(pi.getFormufle().getChampFille("analytique"), "mg.cnaps.compta.ComptaCompte", "compte", "compta_compte", "", "", "");
    affichage.Champ.setPageAppelCompletePropre(pi.getFormufle().getChampFille("compte_aux"),"pertegain.Tiers","id","TIERS","", "", "");
     //affichage.Champ.setAutocomplete(pi.getFormufle().getChampFille("compte"),"libelle","compte","compta_compte"," AND typecompte='1'");
    affichage.Champ.setDefaut(pi.getFormufle().getChampFille("debit"),"0");
    affichage.Champ.setDefaut(pi.getFormufle().getChampFille("credit"),"0");
     affichage.Champ.setDefaut(pi.getFormufle().getChampFille("exercice"),String.valueOf(Utilitaire.getAnneeEnCours()));
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idMere"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("reference_engagement"), false);
   // affichage.Champ.setVisible(pi.getFormufle().getChampFille("compte_aux"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("lettrage"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("journal"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("exercice"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("etat"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("Folio"), false);
//    affichage.Champ.setVisible(pi.getFormufle().getChampFille("analytique"), false);
     affichage.Champ.setVisible(pi.getFormufle().getChampFille("daty"), false);
    //  affichage.Champ.setVisible(pi.getFormufle().getChampFille("libellepiece"), false);

    affichage.Champ.setVisible(pi.getFormufle().getChampFille("source"), false);
//    affichage.Champ.setAutre(pi.getFormufle().getChampFille("compte"), "onchange=\"checkBalance(this)\"");
//    new ChampCompteAux("compte_aux", pi.getFormufle());
    pi.preparerDataFormu();

    //Variables de navigation
    String classeMere = "mg.cnaps.compta.ComptaEcriture";
    String classeFille = "mg.cnaps.compta.ComptaSousEcriture";
    String butApresPost = "compta/ecriture/ecriture-fiche.jsp";
    String colonneMere = "idMere";
    //Preparer les affichages
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <!-- A modifier -->
    <h1>Insertion Multiple</h1>
    <!--  -->
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%

            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
    </form>

</div>
<script>
    function setDefaultAmounts(accountInput) {
        const match = accountInput.id.match(/\d+/);
        if (!match) return;
        const index = match[0];
        const debitField = document.getElementById("debit_" + index);
        const creditField = document.getElementById("credit_" + index);

        if (debitField && creditField) {
            if (debitField.value.trim() === '' && creditField.value.trim() === '') {
                debitField.value = '0';
                creditField.value = '0';
            }
        }
    }

    function handleAccountChange(accountInput) {
        if (!accountInput.isAutoFilled) {
            setDefaultAmounts(accountInput);
        }
        checkBalance(accountInput);
        if (accountInput.isAutoFilled) {
            delete accountInput.isAutoFilled;
        }
    }

    function checkBalance(input) {
        const match = input.id.match(/\d+/);
        if (!match) {
            return;
        }
        const index = match[0];
        const debitField  = document.getElementById("debit_"  + index);
        const creditField = document.getElementById("credit_" + index);
        function toNum(v) { return parseFloat(v) || 0; }

        let totalDebit = 0;
        document.querySelectorAll("[id^='debit_']").forEach(d => {
            totalDebit += toNum(d.value);
        });

        let totalCredit = 0;
        document.querySelectorAll("[id^='credit_']").forEach(c => {
            totalCredit += toNum(c.value);
        });
        const diff = totalDebit - totalCredit;

        if (!debitField || !creditField) {
            return;
        }

        if (diff > 0) {
            creditField.value = diff;
            debitField.value = '';
        }
        else if (diff < 0) {
            debitField.value = -diff;
            creditField.value = '';
        }
        else {
            debitField.value = '';
            creditField.value = '';
        }
    }

    window.addEventListener("DOMContentLoaded", function () {
        const select = document.getElementById("journal");
        if (!select) return;
        for (let option of select.options) {
            if (!option.text.includes("**")) continue;
            const parts = option.text.split("**");
            const visibleText = parts[0].trim();
            const hiddenValue = parts[1].trim();
            option.dataset.compte = hiddenValue;
            option.text = visibleText;
        }

        document.querySelectorAll('input[name^="debit_"]').forEach(function(input) {
            if (parseFloat(input.value) === 0) {
                input.value = '';
            }
        });

        document.querySelectorAll('input[name^="credit_"]').forEach(function(input) {
            if (parseFloat(input.value) === 0) {
                input.value = '';
            }
        });

        // select.addEventListener("change", function () {
        //     const compteInput = document.getElementById("compte_0libelle");
        //     if (compteInput) compteInput.value = '';
        //
        //     const compteInputHidden = document.getElementById("compte_0");
        //     if(compteInputHidden) compteInputHidden.value = '';
        //
        //     document.querySelectorAll('input[name^="debit_"]').forEach(function(input) {
        //         if (parseFloat(input.value) === 0) {
        //             input.value = '';
        //         }
        //     });
        //
        //     document.querySelectorAll('input[name^="credit_"]').forEach(function(input) {
        //         if (parseFloat(input.value) === 0) {
        //             input.value = '';
        //         }
        //     });
        // });
    });

    // function getCompteJournal() {
    //     const select = document.getElementById("journal");
    //     const option = select.options[select.selectedIndex];
    //     const text = option.text;
    //
    //     if (text.includes(" - ")) {
    //         const parts = text.split(" - ");
    //         if (parts.length > 1) {
    //             const compte = parts[1].trim();
    //             if (compte.startsWith("512")) {
    //                 return compte;
    //             }
    //         }
    //     }
    //
    //     if (option.dataset.compte) {
    //         const compte = String(option.dataset.compte).trim();
    //         if (compte.startsWith("512")) {
    //             return compte;
    //         }
    //     }
    //
    //     return '';
    // }
    //
    //
    // function loadCompteJournal(input) {
    //     const match = input.id.match(/\d+/);
    //     if (!match) return;
    //     const index = parseInt(match[0]);
    //
    //     const nextIndex = index + 1;
    //     const nextCompte = document.getElementById("compte_" + nextIndex);
    //     if (!nextCompte) return;
    //     if (nextCompte.value && nextCompte.value.trim() !== "") return;
    //     const nextCompteLibelle = document.getElementById("compte_" + nextIndex+"libelle");
    //     const compteJournal = getCompteJournal();
    //     if (!compteJournal) return;
    //
    //     nextCompte.isAutoFilled = true;
    //     nextCompte.value = compteJournal;
    //
    //     if (nextCompteLibelle) {
    //         nextCompteLibelle.value = getCompteJournal();
    //         const checkbox = document.getElementById("checkbox" + nextIndex);
    //         if (checkbox) checkbox.checked = true;
    //     }
    //     const event = new Event("change", { bubbles: true });
    //     nextCompte.dispatchEvent(event);
    // }

  window.addEventListener("DOMContentLoaded", function () {
    var designation = document.getElementById("designation");
    if (!designation) return;

    designation.removeAttribute("oninput"); // évite l'erreur "checkbox is not defined"

    designation.addEventListener("input", function () {
        document.querySelectorAll('[id^="remarque_"]').forEach(function (champ) {
            champ.value = designation.value;
        });
    });
});

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