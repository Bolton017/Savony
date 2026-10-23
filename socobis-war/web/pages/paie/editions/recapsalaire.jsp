<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="mg.cnaps.paie.EtatRecapitulatif" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="affichage.Liste" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="user.UserEJB" %>

<%
    try {
        UserEJB u = (UserEJB) session.getValue("u");
        String lien = (String) session.getValue("lien");

        EtatRecapitulatif recap = new EtatRecapitulatif();
        recap.setNomTable("RECAPITULATIF_ALL_FINAL");
        String[] listeCrt = {"mois", "annee"};
        String[] listeInt = {""};
        String[] libEntete = {"id","moislib", "annee", "salaire", "indemnite","heuresup","avantage_en_nature",
                "salaire_brut", "irsa", "cnaps_travailleur", "montant_net_payer", "total_frm"};
        String[] libEnteteAffiche = {"ID","Mois", "Ann&eacute;e", "Salaire", "Indemnit&eacute;", "Heures suppl&eacute;mentaires", "Avantages en nature",
                "Salaire brut", "IRSA", "CNAPS Travailleur", "Montant net à payer", "Total Frais m&eacute;dicaux"};

        PageRecherche pr = new PageRecherche(recap, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur(u);
        pr.setLien(lien);
        pr.setApres("paie/recapsalaire/recapsalaire.jsp");

        affichage.Champ[] liste = new affichage.Champ[1];

        Liste moisListe = new Liste("mois");
        moisListe.makeListeMois();
        moisListe.setDefaut(request.getParameter("mois_infrap") != null ? request.getParameter("mois_infrap") : String.valueOf(Utilitaire.getMoisEnCours()));
        liste[0] = moisListe;

        pr.getFormu().changerEnChamp(liste);
        pr.getFormu().getChamp("mois").setLibelle("Mois");
        pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
        pr.getFormu().getChamp("annee").setDefaut(request.getParameter("annee_infrap") != null ? request.getParameter("annee_infrap") : String.valueOf(Utilitaire.getAnneeEnCours()));

        pr.creerObjetPage(libEntete, null);


        String lienTableau[] = {pr.getLien() + "?but=paie/editionmoisannee/editionmoisannee-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);


        String mois_infrap = request.getParameter("mois_infrap") != null ? request.getParameter("mois_infrap") : String.valueOf(Utilitaire.getMoisEnCours());
        String annee_infrap = request.getParameter("annee_infrap") != null ? request.getParameter("annee_infrap") : String.valueOf(Utilitaire.getAnneeEnCours());
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>État R&eacute;capitulatif des Salaires</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/editions/recapsalaire.jsp" method="post" name="retrait" id="retrait" data-parsley-validate>
            <% out.println(pr.getFormu().getHtmlEnsemble()); %>
        </form>

        <%
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
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