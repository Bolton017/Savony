<%@ page import="paie.edition.TraitementPaie" %>
<%@ page import="paie.edition.PaieEditionmoisannee" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Champ" %>

<%

    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");

        int nombreLigne = 10;

        String id = request.getParameter("id");
        String lien = (String) session.getValue("lien");

        PaieEditionmoisannee mere = new PaieEditionmoisannee();
        mere.setNomTable("paie_editionmoisannee");
        TraitementPaie fille = new TraitementPaie();
        fille.setNomTable("TRAITEMENT_PAIE_LIB");

        TraitementPaie[] listeFilles = null;

        if (id != null && !id.isEmpty()) {
            PaieEditionmoisannee edition = new PaieEditionmoisannee();
            edition.setId(id);
            listeFilles = edition.genererTraitementPaie();
        }

        if(listeFilles != null && listeFilles.length > 0) nombreLigne = listeFilles.length;

        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, listeFilles.length, u);
        pi.setTitre("Saisie Traitement de Paie");
        pi.setLien(lien);
        pi.getFormu().setNbColonne(2);

        if(listeFilles != null && listeFilles.length > 0) {
            pi.setDefautFille(listeFilles);
        }

        // champs dropdown
        affichage.Liste[] liste = new Liste[1];
        TypeObjet modePaiementObjet = new TypeObjet();
        modePaiementObjet.setNomTable("modepaiement");
        liste[0] = new Liste("modepaiement", modePaiementObjet, "val", "id");
        pi.getFormufle().changerEnChamp(liste);

        // libelle
        pi.getFormufle().getChamp("IDPERSONNEL_0").setLibelle("ID Personnel");
        pi.getFormufle().getChamp("NOMPERSONNEL_0").setLibelle("Nom Personnel");
        pi.getFormufle().getChamp("NETAPAYER_0").setLibelle("Net A Payer");
        pi.getFormufle().getChamp("NUMEROCOMPTE_0").setLibelle("Num&eacute;ro de compte");
        pi.getFormufle().getChamp("MODEPAIEMENT_0").setLibelle("Mode de paiement");

        // hidden fields
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("matricule").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("IDEDITION").getListeChamp(),false);

        // readonly fields
        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("NETAPAYER").getListeChamp(),"readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("IDPERSONNEL").getListeChamp(),"readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("NOMPERSONNEL").getListeChamp(),"readonly");


        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

        String classeMere = "paie.edition.PaieEditionmoisannee";
        String classeFille = "paie.edition.TraitementPaie";
        String butApresPost = "paie/employe/traitementpaie-liste.jsp";
        String colonneMere = "idEdition";
        String nomTable = "TRAITEMENT_PAIE";
%>


<div class="content-wrapper">
    <!-- A modifier -->
    <h1><%= pi.getTitre() %></h1>

    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>

        <input name="acte" type="hidden" id="nature" value="insertFille">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
        <input name="idMere" type="hidden" id="idMere" value="<%= id %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>

</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>