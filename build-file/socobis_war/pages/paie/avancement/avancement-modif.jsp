<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.avancement.PaieAvancement" %>
<%@ page import="affichage.PageUpdate" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="utilitaire.Utilitaire" %>

<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (UserEJB) session.getValue("u");

        String mapping = "paie.avancement.PaieAvancement";
        String nomTable = "PAIE_AVANCEMENT";
        String apres = "paie/avancement/avancement-fiche.jsp";
        String titre = "Modification de changement de contrat";

        PaieAvancement paieAvancement = new PaieAvancement();
        paieAvancement.setNomTable(nomTable);
        paieAvancement.setId(request.getParameter("id"));

        PageUpdate pu = new PageUpdate(paieAvancement, request, u);
        pu.setLien((String) session.getValue("lien"));
        pu.setTitre(titre);

        // Define fields for the form
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
        modePaiementObjet.setNomTable("paie_modepaiement");
        liste[3] = new Liste("mode_paiement", modePaiementObjet, "val", "id");

        TypeObjet typePersonnel = new TypeObjet();
        typePersonnel.setNomTable("PERSONNEL_CLASSE");
        liste[4] = new Liste("typePersonnel", typePersonnel, "val", "id");

        TypeObjet modePaiement = new TypeObjet();
        modePaiement.setNomTable("MODEPAIEMENT");
        liste[5] = new Liste("modePaiement", modePaiement, "val", "id");

        pu.getFormu().changerEnChamp(liste);

        // Personnel
        pu.getFormu().getChamp("id_logpers").setPageAppelComplete("paie.log.LogPersonnel", "id", "log_personnel");
        pu.getFormu().getChamp("id_logpers").setLibelle("Personnel");

        // Service
        pu.getFormu().getChamp("service").setPageAppelComplete("bean.TypeObjet", "id", "service");
        pu.getFormu().getChamp("service").setLibelle("Rattachement");

        // Fonction
        pu.getFormu().getChamp("idfonction").setPageAppelComplete("paie.PaieFonction", "id", "paie_fonction");
        pu.getFormu().getChamp("idfonction").setLibelle("Fonction");

        pu.getFormu().getChamp("datedecision").setLibelle("Date de décision");
        pu.getFormu().getChamp("refdecision").setLibelle("Référence de décision");
        pu.getFormu().getChamp("date_application").setLibelle("Date d'application");
        pu.getFormu().getChamp("indicegrade").setLibelle("Indice");
        pu.getFormu().getChamp("remarque").setLibelle("Remarque");
        pu.getFormu().getChamp("code_banque").setLibelle("Code Banque");
        pu.getFormu().getChamp("region").setLibelle("Région");

        pu.getFormu().getChamp("typePersonnel").setLibelle("Cadre Professionnel");
        pu.getFormu().getChamp("dureecontrat").setLibelle("Durée de Contrat (en Jours)");
        pu.getFormu().getChamp("modePaiement").setLibelle("Mode de paiement");

        pu.getFormu().getChamp("id").setVisible(false);
        pu.getFormu().getChamp("idcategorie").setVisible(false);
        pu.getFormu().getChamp("ctg").setVisible(false);
        pu.getFormu().getChamp("echelon").setVisible(false);
        pu.getFormu().getChamp("indice_fonctionnel").setVisible(false);
        pu.getFormu().getChamp("indice_ct").setVisible(false);
        pu.getFormu().getChamp("classee").setVisible(false);
        pu.getFormu().getChamp("matricule_patron").setVisible(false);
        pu.getFormu().getChamp("statut").setVisible(false);
        pu.getFormu().getChamp("droit_hs").setVisible(false);
        pu.getFormu().getChamp("vehiculee").setVisible(false);
        pu.getFormu().getChamp("etat").setVisible(false);

        pu.preparerDataFormu();
%>


<div class="content-wrapper">
    <h1 class="box-title"><a href="<%=pu.getLien()%>?but=<%=apres%>&id=<%=request.getParameter("id")%>"><i class="fa fa-angle-left"></i></a><%=titre%></h1>
    <div class="row m-0">
        <form action="<%=pu.getLien()%>?but=paie/avancement/apresmouvement.jsp&id=<%=request.getParameter("id")%>" method="post" name="<%=nomTable%>" id="<%=nomTable%>" data-parsley-validate>
            <%
                pu.getFormu().makeHtmlInsertTabIndex();
                out.println(pu.getFormu().getHtmlInsert());
            %>

            <input name="acte" type="hidden" id="acte" value="update">
            <input name="bute" type="hidden" id="bute" value="<%=apres%>">
            <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
            <input name="rajoutLien" type="hidden" id="rajoutLien" value="id-<%=request.getParameter("id")%>">
            <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
        </form>
    </div>
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