<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="affichage.Champ" %>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.elementpaie.PaiePersonnelElementpaie" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="affichage.Liste" %>
<%@ page import="java.util.List" %>

<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    int taille = 10;

    PaiePersonnelElementpaie fille = new PaiePersonnelElementpaie();
    fille.setNomTable("PAIE_PERSONNEL_ELEMENTPAIE");

    PageInsertMultiple pi = new PageInsertMultiple(fille, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));
//    pi.setTitre("Enregistrement des &eacute;l&eacute;ments de paie par personnel en lot");

    // Configuration de la liste mois pour éviter la création automatique de champs auto
//  affichage.Champ[] listes = new Champ[1];
//  Liste moisregularisation = new Liste("moisregularisation");
//  moisregularisation.makeListeMois();
//  listes[0] = moisregularisation;
//  pi.getFormufle().changerEnChamp(listes);

    // Configuration des page appel complete
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idpersonnel"), "paie.log.LogPersonnel", "id", "LOG_PERSONNEL_INFOCOMPLET");
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("code_rubrique"), "paie.employe.PaieRubrique", "id", "paie_rubrique");

    pi.getFormu().getChamp("pourcentage").setVisible(false);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("unite").setVisible(false);
    pi.getFormu().getChamp("anneeregularisation").setVisible(false);
    pi.getFormu().getChamp("anneeregularisation").setDefaut(Utilitaire.getAnneeEnCours());
    pi.getFormu().getChamp("date_fin").setVisible(false);
    pi.getFormu().getChamp("date_debut").setVisible(false);
    pi.getFormu().getChamp("code_rubrique").setVisible(false);
    pi.getFormu().getChamp("idpersonnel").setVisible(false);
//        pi.getFormu().getChamp("id_objet").setAutre("hidden");
    pi.getFormu().getChamp("id_objet").setVisible(false);
    pi.getFormu().getChamp("quantite").setVisible(false);
//        pi.getFormu().getChamp("idfonction").setDefaut("");
    pi.getFormu().getChamp("idcategorie_qualification").setVisible(false);
    pi.getFormu().getChamp("idfonction").setVisible(false);

    pi.getFormu().getChamp("id_objet").setVisible(false);
    pi.getFormu().getChamp("quantite").setVisible(false);
    //...existing code...
    pi.getFormu().getChamp("gain").setVisible(false);
    pi.getFormu().getChamp("remarque").setVisible(false);
    pi.getFormu().getChamp("retenue").setVisible(false);

    // Champs invisibles (même configuration que paiepersonnelelementpaie-saisie.jsp)
    pi.getFormufle().getChampMulitple("pourcentage").setVisible(false);
    pi.getFormufle().getChampMulitple("etat").setVisible(false);
    pi.getFormufle().getChampMulitple("unite").setVisible(false);
    pi.getFormufle().getChampMulitple("date_fin").setVisible(false);
    pi.getFormufle().getChampMulitple("date_debut").setVisible(false);
    pi.getFormufle().getChampMulitple("id_objet").setVisible(false);
    pi.getFormufle().getChampMulitple("quantite").setVisible(false);
    pi.getFormufle().getChampMulitple("idcategorie_qualification").setVisible(false);
    pi.getFormufle().getChampMulitple("idfonction").setVisible(false);
    pi.getFormufle().getChampMulitple("remarque").setVisible(false);
    pi.getFormufle().getChampMulitple("retenue").setVisible(false);


    // Libellés
    pi.getFormufle().getChamp("idpersonnel_0").setLibelle("Matricule");
    pi.getFormufle().getChamp("anneeregularisation_0").setLibelle("Ann&eacute;e de r&eacute;gularisation");
    pi.getFormufle().getChamp("anneeregularisation_0").setVisible(false);
    pi.getFormufle().getChamp("moisregularisation_0").setLibelle("Mois");
    pi.getFormufle().getChamp("code_rubrique_0").setLibelle("Rubrique");
    pi.getFormufle().getChamp("gain_0").setLibelle("Montant");

    //pi.getFormufle().getChamp("modeCalcul_0").setLibelle("Mode de calcul");


    // Valeurs par défaut pour toutes les lignes
    for(int i = 0; i < taille; i++){
        pi.getFormufle().getChamp("anneeregularisation_"+i).setDefaut(Utilitaire.getAnneeEnCours());
        pi.getFormufle().getChamp("anneeregularisation_"+i).setVisible(false);
        int currentMonth = Utilitaire.getMoisEnCours()+1;
        //pi.getFormufle().getChamp("modeCalcul_"+i).setDefaut("0");
        pi.getFormufle().getChamp("moisregularisation_"+i).setDefaut(""+currentMonth);
        pi.getFormufle().getChamp("gain_"+i).setDefaut("0");
    }

    // Ordre des colonnes (même que paiepersonnelelementpaie-saisie.jsp)
    pi.getFormufle().setColOrdre(new String[]{
            "idpersonnel",
            "anneeregularisation",
            "moisregularisation",
            "code_rubrique",
            "gain"
    });

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<script>
    function changerDesignation() {
        document.incident.submit();
    }

    // JavaScript COMMENTÉ : La Liste génère déjà les selects, pas besoin de les créer
    <%--
      document.addEventListener('DOMContentLoaded', function () {
        const valeurs = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
        const affichages = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"];

        // Parcourir tous les champs input qui ont un name commençant par "mois_"
        const moisInputs = document.querySelectorAll('input[name^="moisregularisation_"]');

        moisInputs.forEach(function (input) {
          // Créer un select
          const select = document.createElement('select');
          select.name = input.name;
          select.id = input.id;
          select.className = input.className;

          // Ajouter les options
          for (let i = 0; i < valeurs.length; i++) {
            const option = document.createElement('option');
            option.value = valeurs[i];
            option.textContent = affichages[i];

            // Sélectionner l'option si la valeur correspond
            if (input.value === valeurs[i]) {
              option.selected = true;
            }

            select.appendChild(option);
          }

          // Remplacer l'input par le select
          input.parentNode.replaceChild(select, input);
        });
      });
    --%>
</script>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pi.getTitre() %></h1>
<%--        <h1><%= pi.getTitre() %></h1>--%>
        <%
            List<String> importErrors = (List<String>) session.getAttribute("importErrors");
            if (importErrors != null && !importErrors.isEmpty()) {
        %>

        <div style="
    background-color:#ffe6e6;
    border:2px solid #cc0000;
    color:#990000;
    padding:20px;
    margin:20px 0;
    font-size:16px;
    border-radius:8px;
">

            <h3 style="margin-top:0;">Erreurs lors de l'import</h3>

            <ul style="margin-top:10px;">
                <% for(String err : importErrors){ %>
                <li style="margin-bottom:8px;"><%= err %></li>
                <% } %>
            </ul>

        </div>

        <%
                session.removeAttribute("importErrors");
            }
        %>
    </section>
    <section class="content">
        <form id="formId" class='container' action="<%=pi.getLien()%>?but=paie/fonction/apresMultiple.jsp" method="post" >
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
            <input name="acte" type="hidden" id="nature" value="insertFilleSeul">
            <input name="bute" type="hidden" id="bute" value="paie/fonction/paiepersonnelelementpaie-saisie.jsp">
            <input name="classe" type="hidden" id="classe" value="paie.elementpaie.PaiePersonnelElementpaie">
            <input name="classefille" type="hidden" id="classefille" value="paie.elementpaie.PaiePersonnelElementpaie">
            <input name="nomtable" type="hidden" id="nomtable" value="paie_personnel_elementpaie">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        </form>
    </section>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>

