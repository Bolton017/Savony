<%@page import="paie.elementpaie.PaiePersonnelElementpaie"%>
<%@page import="affichage.Liste"%>
<%@page import="utilitaire.ConstanteEtat"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Champ" %>

<%
    try{
        PaiePersonnelElementpaie dr = new PaiePersonnelElementpaie();
        String nomTable = "PAIE_PERS_ELTPAIE_LIB_AV";

        if (request.getParameter("table") != null && request.getParameter("table").compareToIgnoreCase("") != 0) {
            nomTable = request.getParameter("table");
        }
        dr.setNomTable(nomTable);

        String listeCrt[] = { "idpersonnel", "matricule", "moisregularisation" };
        String listeInt[] = { "moisregularisation" };
        String libEntete[] = { "id", "matricule", "idpersonnel", "MOISREGULARISATIONLIB", "anneeregularisation", "retenue" };
        PageRecherche pr = new PageRecherche(dr, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("paie/avance/paieperseltpaie-avance-liste.jsp");

        affichage.Champ[] liste = new Champ[2];
        Liste mois1 = new Liste("moisregularisation1");
        mois1.makeListeMois();
        liste[0] = mois1;
        Liste mois2 = new Liste("moisregularisation2");
        mois2.makeListeMois();
        liste[1] = mois2;
        pr.getFormu().changerEnChamp(liste);
        pr.getFormu().getChamp("idpersonnel").setLibelle("ID Personnel");
        pr.getFormu().getChamp("moisregularisation1").setLibelle("Mois de r&eacute;gularisation (min)");
        pr.getFormu().getChamp("moisregularisation2").setLibelle("Mois de r&eacute;gularisation (max)");

        pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=paie/avance/paieperseltpaie-avance-liste.jsp&currentMenu=MD00021110004\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir un &eacute;l&eacute;ments de paie pour l'avance du 15" +
            "                </a>"
        );
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des &eacute;l&eacute;ments de paie avance</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/avance/paieperseltpaie-avance-liste.jsp" method="post" name="incident" id="incident">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>

        <%  String lienTableau[] = {pr.getLien() + "?but=paie/avance/paieperseltpaie-avance-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            String libEnteteAffiche[] = {"id", "Matricule", "Personnel", "Mois de r&eacute;gularisation", "Ann&eacute;e de r&eacute;gularisation", "Retenue"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<% } catch(Exception e) { e.printStackTrace();}%>
