<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="affichage.Champ" %>
<%@ page import="user.UserEJB" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="affichage.Liste" %>
<%@ page import="java.util.List" %>
<%@ page import="paie.employe.PaieInfoPersonnel" %>
<%@ page import="paie.log.LogPersonnel" %>

<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    int taille = 10;

    LogPersonnel fille = new LogPersonnel();
    fille.setNomTable("PERSONNEL_BU_FIN_VALIDE");

    PageInsertMultiple pi = new PageInsertMultiple(fille, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Import service");


    // Configuration des page appel complete
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("id"), "paie.log.LogPersonnel", "id", "PERSONNEL_BU_FIN_VALIDE",
            "matricule;nom;prenom;service;serviceLib",
            "matricule;nom;prenom;service;serviceLib");

    pi.getFormufle().getChampMulitple("matricule").setAutre("readonly");
    pi.getFormufle().getChampMulitple("nom").setAutre("readonly");
    pi.getFormufle().getChampMulitple("prenom").setAutre("readonly");

    // Libellés
    pi.getFormufle().getChamp("id_0").setLibelle("ID Personnel");
    pi.getFormufle().getChamp("matricule_0").setLibelle("Matricule");
    pi.getFormufle().getChamp("nom_0").setLibelle("Nom");
    pi.getFormufle().getChamp("prenom_0").setLibelle("Pr&eacute;nom(s)");
    pi.getFormufle().getChamp("service_0").setLibelle("ID Service");
    pi.getFormufle().getChamp("serviceLib_0").setLibelle("Service");

    // Valeurs par défaut pour toutes les lignes
//    for(int i = 0; i < taille; i++){
//        pi.getFormufle().getChamp("anneeregularisation_"+i).setDefaut(Utilitaire.getAnneeEnCours());
//    }

    pi.getFormufle().setColOrdre(new String[]{
            "id",
            "matricule",
            "nom",
            "prenom",
            "service",
            "serviceLib"
    });

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<script>
    function changerDesignation() {
        document.incident.submit();
    }


</script>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pi.getTitre() %></h1>
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
        <form id="formId" class='container' action="<%=pi.getLien()%>?but=paie/employe/apresMultiple-modePaiement.jsp" method="post" >
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
            <input name="acte" type="hidden" id="nature" value="update">
            <input name="bute" type="hidden" id="bute" value="paie/employe/infopersonnel-service-liste.jsp">
            <input name="classe" type="hidden" id="classe" value="paie.log.LogPersonnel">
            <input name="classefille" type="hidden" id="classefille" value="paie.log.LogPersonnel">
            <input name="nomtable" type="hidden" id="nomtable" value="log_personnel">
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


