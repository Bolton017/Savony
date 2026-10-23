<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.accident.Accident" %>
<%@ page import="affichage.Liste"%>
<%@ page import="magasin.TypeMagasin" %>
<%@ page import="mg.cnaps.compta.TypeCompte" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="paie.log.LogPersonnel" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.accident.Accident";
    String nomTable = "ACCIDENT";
    String apres = "paie/accident/accident-saisie.jsp";

    Accident o = new Accident();
    o.setNomTable("ACCIDENT");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'un accident de travail");

    Liste[] liste = new Liste[4];
    TypeObjet liste0 = new TypeObjet();
    liste0.setNomTable("TYPE_ACCIDENT");
    liste[0] = new Liste("id_Type_Accident",liste0,"val","id");
    TypeObjet liste1 = new TypeObjet();
    liste1.setNomTable("GRAVITE_ACCIDENT");
    liste[1] = new Liste("id_Gravite",liste1,"val","id");
    String[] affType = {"Incident", "Accident"};
    String[] valType = {"0","1"};
    liste[2] = new Liste("type", affType, valType);
    TypeObjet societe = new TypeObjet();
    societe.setNomTable("SOCIETE");
    liste[3] = new Liste("idsociete",societe,"val","id");

    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("daty").setLibelle("Date de l'accident");
    pi.getFormu().getChamp("date_Declaration").setVisible(false);
    pi.getFormu().getChamp("date_Declaration").setDefaut(Utilitaire.dateDuJour());
    pi.getFormu().getChamp("id_Personnel").setLibelle("Personnel");
    pi.getFormu().getChamp("id_Lieu").setLibelle("Lieu");
    pi.getFormu().getChamp("id_Type_Accident").setLibelle("Type Accident");
    pi.getFormu().getChamp("id_Gravite").setLibelle("Gravit&eacute;");
    pi.getFormu().getChamp("id_Machine").setLibelle("Machine");
    pi.getFormu().getChamp("cause").setLibelle("Cause");
    pi.getFormu().getChamp("idSociete").setLibelle("Soci&eacute;t&eacute;");
    pi.getFormu().getChamp("auteurRapport").setLibelle("Auteur du rapport ");
    pi.getFormu().getChamp("auteurRapport").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","","");
    pi.getFormu().getChamp("descriptionAccident").setLibelle("Description de l'accident");
    pi.getFormu().getChamp("descriptionAccident").setType("textarea");
    pi.getFormu().getChamp("descriptionBlessure").setLibelle("Description de la blessure");
    pi.getFormu().getChamp("descriptionBlessure").setType("textarea");
    pi.getFormu().getChamp("descriptionDommageMateriel").setLibelle("Description du dommage mat&eacute;riel");
    pi.getFormu().getChamp("descriptionDommageMateriel").setType("textarea");
    pi.getFormu().getChamp("representantCSST").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","","");
    pi.getFormu().getChamp("representantCSST").setLibelle("Repr&eacute;sentant CSST");
    pi.getFormu().getChamp("responsableLieu").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","","");
    pi.getFormu().getChamp("responsableLieu").setLibelle("Responsable du lieu de l'incident / accident");
    pi.getFormu().getChamp("Compliance").setType("textarea");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("faitAccident").setLibelle("Fait de l'accident");
    pi.getFormu().getChamp("type").setLibelle("Type");
    pi.getFormu().getChamp("numeroRapport").setLibelle("Numéro de rapport");
    pi.getFormu().getChamp("actionImmediate").setLibelle("Action immédiate");
    pi.getFormu().getChamp("analyseCause").setLibelle("Analyse des causes");
    pi.getFormu().getChamp("actionCorrective").setLibelle("Action corrective");
    pi.getFormu().getChamp("responsable").setLibelle("Responsable de l'action corrective");
    pi.getFormu().getChamp("heureAccident").setLibelle("Heure de l'accident");
     pi.getFormu().getChamp("centreSoin").setLibelle("Centre de soins");
//    pi.getFormu().getChamp("heureAccident").setAutre("type=\"time\" placeholder=\"HH:MM:SS\" onchange=\"formatAsTimestampString(this)\"");
    pi.getFormu().getChamp("heureAccident").setType("time");

    pi.getFormu().getChamp("horaireDebut").setLibelle("Heure début du service entre 08:00 &agrave; 12:00");
//    pi.getFormu().getChamp("horaireDebut").setAutre("type=\"time\" placeholder=\"HH:MM\" onchange=\"formatAsTimestampString(this)\"");
    pi.getFormu().getChamp("horaireDebut").setType("time");

    pi.getFormu().getChamp("horaireFin").setLibelle("Heure fin du service entre 13:00 &agrave; 17:00");
//    pi.getFormu().getChamp("horaireFin").setAutre("type=\"time\" placeholder=\"HH:MM\" onchange=\"formatAsTimestampString(this)\"");
    pi.getFormu().getChamp("horaireFin").setType("time");
     pi.getFormu().getChamp("faitAccident").setType("textarea");
     pi.getFormu().getChamp("actionImmediate").setType("textarea");
     pi.getFormu().getChamp("analyseCause").setType("textarea");
     pi.getFormu().getChamp("actionCorrective").setType("textarea");


    pi.getFormu().getChamp("activite").setLibelle("Activit&eacute; au moment de l'accident");
    pi.getFormu().getChamp("lesions").setLibelle("L&eacute;sions subies");
    pi.getFormu().getChamp("detailsTemoin1").setLibelle("Témoins (1)");
    pi.getFormu().getChamp("detailsTemoin2").setLibelle("Témoins (2)");
    pi.getFormu().getChamp("detailsTemoin1").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","","");
    pi.getFormu().getChamp("detailsTemoin2").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","","");
    pi.getFormu().getChamp("id_Personnel").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","","");
    pi.getFormu().getChamp("responsable").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","","");
    pi.getFormu().getChamp("id_Lieu").setPageAppelComplete("bean.TypeObjet","id","LIEU_ACCIDENT_TRAVAIL","","");
    pi.getFormu().getChamp("id_Machine").setPageAppelComplete("bean.TypeObjet","id","machine","","");

    // --- DÉFINITION DE L'ORDRE LOGIQUE D'AFFICHAGE ---
    String[] ordre = {
            // 1. Informations Générales (Quand ?)
            "daty",
            "numeroRapport",
            "heureAccident",
            "horaireDebut",
            "horaireFin",

            // 2. Identification de la Victime et de la Société (Qui ?)
            "idSociete",
            "id_Personnel",

            // 3. Localisation et Contexte (Où et Dans quel contexte ?)
            "id_Lieu",
            "responsableLieu",
            "type", // Incident ou Accident
            "id_Type_Accident",
            "id_Gravite",
            "activite",
            "id_Machine",

            // 4. Description détaillée (Que s'est-il passé ?)
            "faitAccident",
            "descriptionAccident",
            "cause",

            // 5. Conséquences (Bilan)
            "lesions",
            "descriptionBlessure",
            "centreSoin",
            "descriptionDommageMateriel",

            // 6. Témoins et Intervenants
            "detailsTemoin1",
            "detailsTemoin2",
            "representantCSST",

            // 7. Analyses et Actions HSE (Mesures prises)
            "actionImmediate",
            "analyseCause",
            "actionCorrective",
            "responsable", // Responsable de l'action corrective

            // 8. Suivi / Clôture
            "Compliance",
            "auteurRapport"
    };

    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un accident de travail");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

