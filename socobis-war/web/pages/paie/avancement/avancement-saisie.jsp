<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="user.UserEJB" %>
<%@ page import="paie.avancement.PaieAvancement" %>
<%@ page import="affichage.PageInsert" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="paie.employe.EmployeComplet" %>

<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (UserEJB) session.getValue("u");

        String mapping = "paie.avancement.PaieAvancement";
        String nomTable = "PAIE_AVANCEMENT";
        String apres = "paie/avancement/avancement-fiche.jsp";
        String titre = "Saisie d'un mouvement";
        String idPersonnel = request.getParameter("id");

        PaieAvancement paieAvancement = new PaieAvancement();
        paieAvancement.setNomTable(nomTable);

        PageInsert pi = new PageInsert(paieAvancement, request, u);
        pi.setLien((String) session.getValue("lien"));

        affichage.Champ[] liste = new Champ[6];

        // Motif
        TypeObjet objetMotif = new TypeObjet();
        objetMotif.setNomTable("DEC_DECISION_TYPE");
        liste[0] = new Liste("motif", objetMotif, "val", "id");

        // Direction
        TypeObjet directionObjet = new TypeObjet();
        directionObjet.setNomTable("log_direction");
        liste[1] = new Liste("direction", directionObjet, "val", "id");

        // Region
        TypeObjet regionObjet = new TypeObjet();
        regionObjet.setNomTable("region");
        liste[2] = new Liste("region", regionObjet, "val", "id");

        // Mode de paiement
        TypeObjet modePaiementObjet = new TypeObjet();
        modePaiementObjet.setNomTable("MODEPAIEMENT");
        liste[3] = new Liste("MODEPAIEMENT", modePaiementObjet, "val", "id");


        // Personnel
        pi.getFormu().getChamp("id_logpers").setPageAppelComplete("paie.log.LogPersonnel", "id", "LOG_PERSONNEL_INFOCOMPLET");
        pi.getFormu().getChamp("id_logpers").setLibelle("Personnel");

        // Service
        pi.getFormu().getChamp("service").setPageAppelComplete("paie.log.LogService", "id", "log_service");
        pi.getFormu().getChamp("service").setLibelle("Rattachement");

        // Fonction
        pi.getFormu().getChamp("idfonction").setPageAppelComplete("paie.edition.PaieFonction", "id", "paie_fonction");
        pi.getFormu().getChamp("idfonction").setLibelle("Fonction");

        // Type Contrat
        TypeObjet typeContrat = new TypeObjet();
        typeContrat.setNomTable("type_contrat");
        liste[4] = new Liste("CONTRAT", typeContrat, "val", "id");

        // Type Personnel
        TypeObjet typePersonnel = new TypeObjet();
        typePersonnel.setNomTable("categorie_paie");
        liste[5] = new Liste("TYPEPERSONNEL", typePersonnel, "val", "id");

        pi.getFormu().changerEnChamp(liste);

        // Other fields
        pi.getFormu().getChamp("MODEPAIEMENT").setLibelle("Mode de paiement");
        pi.getFormu().getChamp("TYPEPERSONNEL").setLibelle("Cadre professionnel");
        pi.getFormu().getChamp("dureecontrat").setLibelle("Dur&eacute;e de contrat (en jours)");
        pi.getFormu().getChamp("contrat").setLibelle("Contrat");
        pi.getFormu().getChamp("datedecision").setLibelle("Date de d&eacute;cision");
        pi.getFormu().getChamp("datedecision").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("refdecision").setLibelle("R&eacute;f&eacute;rence de d&eacute;cision");
        pi.getFormu().getChamp("date_application").setLibelle("Date d'application");
        pi.getFormu().getChamp("date_application").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("indicegrade").setLibelle("Indice");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("code_banque").setLibelle("Code Banque");
        pi.getFormu().getChamp("region").setLibelle("R&eacute;gion d’affectation");

        pi.getFormu().getChamp("idcategorie").setVisible(false);
        pi.getFormu().getChamp("ctg").setVisible(false);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("echelon").setVisible(false);
        pi.getFormu().getChamp("indice_fonctionnel").setVisible(false);
        pi.getFormu().getChamp("indice_ct").setVisible(false);
        pi.getFormu().getChamp("classee").setVisible(false);
        pi.getFormu().getChamp("matricule_patron").setVisible(false);
        pi.getFormu().getChamp("statut").setVisible(false);
        pi.getFormu().getChamp("droit_hs").setVisible(false);
        pi.getFormu().getChamp("vehiculee").setVisible(false);

        if (idPersonnel != null && !idPersonnel.isEmpty()) {
            EmployeComplet emp = new EmployeComplet();
            emp.setId(idPersonnel);

            PaieAvancement avancement = emp.genererPaieAvancement();
            pi.getFormu().getChamp("id_logpers").setDefaut(avancement.getId_logpers());
            pi.getFormu().getChamp("service").setDefaut(avancement.getService());
            pi.getFormu().getChamp("idfonction").setDefaut(avancement.getIdfonction());
        }

        pi.preparerDataFormu();
%>

<div class="content-wrapper">
    <h1><%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=paie/avancement/apresmouvement.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>" data-parsley-validate>
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>

        <input name="acte" type="hidden" id="acte" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>

<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% } %>
