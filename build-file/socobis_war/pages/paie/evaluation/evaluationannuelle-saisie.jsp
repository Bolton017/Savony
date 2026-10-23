<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.evaluation.EvaluationAnnuelle" %>
<%@ page import="paie.evaluation.EvaluationDetail" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Liste" %>
<%@ page import="affichage.Champ" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="paie.evaluation.EvaluationCritere" %>
<%@ page import="net.sourceforge.jeval.function.string.Eval" %>
<%@ page import="poste.TypeCompetencesFP" %>
<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "paie.evaluation.EvaluationAnnuelle";
    String classeFille = "paie.evaluation.EvaluationDetail";
    String nomTableFille = "EVALUATION_DETAIL";
    String colonneMere = "idevaluation";
    String apres = "paie/evaluation/evaluationannuelle-saisie.jsp";

    EvaluationAnnuelle mere = new EvaluationAnnuelle();
    mere.setNomTable("EVALUATION_ANNUELLE");
    EvaluationDetail fille = new EvaluationDetail();
    fille.setNomTable("EVALUATION_DETAIL");
//    EvaluationCritere evaluationCritere = new EvaluationCritere();
//    EvaluationCritere[] evaluationCriteres = evaluationCritere.evaluationCriteres();
    int taille = 10;
//    if (evaluationCriteres.length > 0){
//        taille = evaluationCriteres.length;
//    }
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'un &eacute;valuation annuelle");


    pi.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
    pi.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());
    pi.getFormu().getChamp("noteglobale").setLibelle("Note globale");
    pi.getFormu().getChamp("noteglobale").setVisible(false);
    pi.getFormu().getChamp("commentaire").setLibelle("Remarque");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idpersonnel").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","id","id");

//    Liste[] listeFille = new Liste[1];
//    EvaluationCritere evaluationCritere1 = new EvaluationCritere();
//    TypeObjet listeFille0 = new TypeObjet();
//    listeFille0.setNomTable("EVALUATION_CRITERE");
//    listeFille[0] = new Liste("idcritere",evaluationCritere1,"val","id");
//    pi.getFormufle().changerEnChamp(listeFille);

    pi.getFormufle().getChamp("idcritere_0").setLibelle("Crit&egrave;re");
    pi.getFormufle().getChamp("note_0").setLibelle("Note sur 20");
    pi.getFormufle().getChamp("commentaire_0").setLibelle("Commentaire");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idevaluation").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("idcritere").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("note").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("commentaire").getListeChamp(),false);

    pi.getFormufle().getChamp("competence_0").setLibelle("Comp&eacute;tence");
    pi.getFormufle().getChamp("appreciation_0").setLibelle("Appr&eacute;ciation");
//    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    pi.getFormufle().getChamp("autoEvaluation_0").setLibelle("Auto-&eacute;valuation");
    pi.getFormufle().getChamp("evaluationSuperieur_0").setLibelle("&Eacute;valuation sup&eacute;rieur");
    pi.getFormufle().getChamp("synthese_0").setLibelle("Synth&egrave;se");

    Liste[] listes = new Liste[1];
    listes[0] = new Liste("idTypeCompetenceFP", new TypeCompetencesFP(), "val", "id");
    pi.getFormufle().changerEnChamp(listes);

    pi.getFormufle().getChamp("idTypeCompetenceFP_0").setLibelle("Type de comp&eacute;tence");

//    Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idTypeCompetenceFP").getListeChamp(), "poste.TypeCompetencesFP", "id", "TYPE_COMPETENCES_FP", "id", "id");
    Champ.setAutre(pi.getFormufle().getChampMulitple("appreciation").getListeChamp(), "readonly");
    Champ.setAutre(pi.getFormufle().getChampMulitple("synthese").getListeChamp(), "readonly");
    Champ.setVisible(pi.getFormufle().getChampMulitple("remarque").getListeChamp(), false);
     Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(), false);

//    if (evaluationCriteres.length > 0){
//        for (int i = 0; i < taille; i++) {
//            pi.getFormufle().getChamp("idcritere_" + i).setDefaut(evaluationCriteres[i].getId());
//        }
//    }

    String[] colOrdre = {"id","idTypeCompetenceFP", "competence", "autoEvaluation", "evaluationSuperieur", "appreciation", "synthese"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un &eacute;valuation annuelle");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomtable" value=<%=nomTableFille%>>
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>
<%--<script>--%>
<%--    document.addEventListener("DOMContentLoaded", function () {--%>
<%--        const taille = <%=taille%>;--%>

<%--        <% if (evaluationCriteres.length > 0) { %>--%>
<%--        for (let i = 0; i < taille; i++) {--%>
<%--            const checkbox = document.getElementById("checkbox" + i);--%>
<%--            if (checkbox) {--%>
<%--                checkbox.checked = true;--%>
<%--            }--%>
<%--        }--%>
<%--        <% } %>--%>
<%--    });--%>
<%--</script>--%>

<script>
    $(document).ready(function () {
        // Récupérer le nombre de lignes défini dans la page (taille)
        var lignes = parseInt($('#nombreLigne').val()) || <%=taille%>;

        // Attacher un écouteur d'événement sur chaque ligne pour les champs autoEvaluation et evaluationSuperieur
        for (let i = 0; i < lignes; i++) {
            $('#autoEvaluation_' + i + ', #evaluationSuperieur_' + i).on('input', function() {
                calculerSyntheseEtAppreciation(i);
            });
        }
    });

    function calculerSyntheseEtAppreciation(indice) {
        // 1. Récupérer les valeurs saisies (en gérant les virgules et les espaces)
        let autoInput = $('#autoEvaluation_' + indice).val();
        let supInput = $('#evaluationSuperieur_' + indice).val();

        // Si les deux champs sont vides, on vide la synthèse et l'appréciation
        if (!autoInput && !supInput) {
            $('#synthese_' + indice).val('');
            $('#appreciation_' + indice).val('');
            return;
        }

        // Conversion en nombre décimal (défaut à 0 si non valide)
        let autoEval = parseFloat(autoInput.replace(/\s/g, '').replace(',', '.')) || 0;
        let evalSup = parseFloat(supInput.replace(/\s/g, '').replace(',', '.')) || 0;

        // 2. Calculer la moyenne (AVG)
        let synthese = (autoEval + evalSup) / 2;

        // 3. Mettre à jour le champ Synthèse (arrondi à 2 décimales)
        $('#synthese_' + indice).val(synthese.toFixed(2));

        // 4. Déterminer l'Appréciation en fonction des conditions
        let appreciation = "";

        if (synthese <= 1.5) {
            appreciation = "Point d'amélioration prioritaire";
        } else if (synthese <= 2.5) {
            appreciation = "Effort encore à soutenir";
        } else if (synthese <= 3.5) {
            appreciation = "Atteinte du niveau";
        } else {
            // Optionnel : Pour les valeurs > 3.5
            appreciation = "Dépassement du niveau";
        }

        // 5. Mettre à jour le champ Appréciation
        $('#appreciation_' + indice).val(appreciation);
    }
</script>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

