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
        UserEJB u = (UserEJB) session.getValue("u");

        String mapping = "paie.avancement.PaieAvancement";
        String nomTable = "PAIE_AVANCEMENT";
        String apres = "paie/avancement/avancement-fiche.jsp";

        // --- TITLE CHANGE ---
        String titre = "Changement de Contrat";
        String idPersonnel = request.getParameter("id");

        PaieAvancement paieAvancement = new PaieAvancement();
        paieAvancement.setNomTable(nomTable);

        PageInsert pi = new PageInsert(paieAvancement, request, u);
        pi.setLien((String) session.getValue("lien"));

        affichage.Champ[] liste = new Champ[2];

        TypeObjet objetMotif = new TypeObjet();
        objetMotif.setNomTable("DEC_DECISION_TYPE");
        liste[0] = new Liste("motif", objetMotif, "val", "id");
        liste[0].setDefaut("TYD000006");

        TypeObjet typePersonnel = new TypeObjet();
        typePersonnel.setNomTable("categorie_paie");
        liste[1] = new Liste("TYPEPERSONNEL", typePersonnel, "val", "id");

        // Object Linkages
        pi.getFormu().getChamp("id_logpers").setPageAppelComplete("paie.log.LogPersonnel", "id", "LOG_PERSONNEL_INFOCOMPLET");
        pi.getFormu().getChamp("id_logpers").setLibelle("Personnel");

        pi.getFormu().getChamp("service").setPageAppelComplete("paie.log.LogService", "id", "log_service");
        pi.getFormu().getChamp("service").setLibelle("Rattachement");

        pi.getFormu().getChamp("idfonction").setPageAppelComplete("paie.edition.PaieFonction", "id", "paie_fonction");
        pi.getFormu().getChamp("idfonction").setLibelle("Fonction");

        pi.getFormu().changerEnChamp(liste);

        // Labels
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

        // --- DEFAULT VALUE ---
        pi.getFormu().getChamp("indicegrade").setDefaut("0");

        // --- VISIBILITY CONFIGURATION FOR CONTRAT ---

        // 1. Hide irrelevant functional/geo fields
        pi.getFormu().getChamp("direction").setVisible(false);
        pi.getFormu().getChamp("region").setVisible(false);
        pi.getFormu().getChamp("service").setVisible(false);
        pi.getFormu().getChamp("idfonction").setVisible(false);

        // 2. Hide standard unused fields (from original code)
        pi.getFormu().getChamp("contrat").setVisible(false);
        pi.getFormu().getChamp("dureecontrat").setVisible(false);
//        pi.getFormu().getChamp("typePersonnel").setVisible(false);
        pi.getFormu().getChamp("code_banque").setVisible(false);
        pi.getFormu().getChamp("code_banque").setVisible(false);
        pi.getFormu().getChamp("modepaiement").setVisible(false);
        pi.getFormu().getChamp("indicegrade").setVisible(false);
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