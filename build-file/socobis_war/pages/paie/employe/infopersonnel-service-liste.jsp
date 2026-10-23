<%@page import="paie.log.LogPersonnelFin"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="user.UserEJB" %>
<%@ page import="historique.MapUtilisateur" %>
<%@ page import="paie.demande.EmployeComplet" %>
<%@ page import="paie.log.LogService" %>

<%
    try{
    LogPersonnelFin dr = new LogPersonnelFin();
    String nomTable = "PERSONNEL_BU_FIN_VALIDE";
    UserEJB ue = (UserEJB) session.getValue("u");


    dr.setNomTable(nomTable);
    String listeCrt[] = {"id","idSocieteLib", "matricule", "nom", "prenom", "typeContratLib", "directionLib",  "idSectionLib", "uniteLib"};
    String listeInt[] = {};
    String libEntete[] = {"id", "matricule", "nom", "prenom", "service","serviceLib"};
    PageRecherche pr = new PageRecherche(dr, request, listeCrt, listeInt, 3, libEntete, libEntete.length);

    String colonneTri = request.getParameter("colonne");
    String ordreTri = request.getParameter("ordre");
    boolean triUtilisateur = request.getParameter("triCol") != null
            || (colonneTri != null && !colonneTri.isEmpty() && ordreTri != null && !ordreTri.equals("-"));
    if (!triUtilisateur) {
        pr.setAWhere(" ORDER BY TO_NUMBER(REGEXP_SUBSTR(matricule, '^[0-9]+')) ASC");
    }
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    Liste[] liste = new Liste[6];
    TypeObjet buLib = new TypeObjet();
    buLib.setNomTable("BUSINESS_UNITE");
    liste[0] = new Liste("buLib", buLib, "val", "val");

    TypeObjet typeContratLib = new TypeObjet();
    typeContratLib.setNomTable("TYPE_CONTRAT");
    liste[1] = new Liste("typeContratLib", typeContratLib, "val", "val");

    TypeObjet directionLib = new TypeObjet();
    directionLib.setNomTable("log_direction");
    liste[2] = new Liste("directionLib", directionLib, "val", "val");

    LogService idSectionLib = new LogService();
    idSectionLib.setNomTable("LOG_SERVICE");
    liste[3] = new Liste("idSectionLib", idSectionLib, "libelle", "libelle");

    TypeObjet uniteLib = new TypeObjet();
    uniteLib.setNomTable("LOG_UNITE");
    liste[4] = new Liste("uniteLib", uniteLib, "val", "val");

    TypeObjet idSocieteLib = new TypeObjet();
    idSocieteLib.setNomTable("societe");
    liste[5] = new Liste("idSocieteLib", idSocieteLib, "val", "val");

    pr.getFormu().changerEnChamp(liste);

    pr.setApres("paie/employe/infopersonnel-service-liste.jsp");
    String[] colSomme = null;

    pr.getFormu().getChamp("nom").setLibelle("Nom");
    pr.getFormu().getChamp("prenom").setLibelle("Pr&eacute;nom(s)");
    pr.getFormu().getChamp("matricule").setLibelle("Matricule");
    pr.getFormu().getChamp("typeContratLib").setLibelle("Type de contrat");
    pr.getFormu().getChamp("directionLib").setLibelle("Direction");
    pr.getFormu().getChamp("uniteLib").setLibelle("Unit&eacute;");
    pr.getFormu().getChamp("idSectionLib").setLibelle("Section/Service");
    pr.getFormu().getChamp("idSocieteLib").setLibelle("Soci&eacute;t&eacute;");
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=paie/employe/personnel-fiche-portrait.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

//    String libEnteteAffiche[] = {"ID", "Matricule", "Nom", "Pr&eacute;nom(s)", "ID Mode de paiement", "Mode de paiement","Banque","Agence","Num&eacutero de compte","Cl&eacute RIB"};
//    pr.getTableau().setLibelleAffiche(libEnteteAffiche);


        pr.getFormu().setAnotherButton(
                "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=paie/employe/infopersonnel-service-saisie.jsp&currentMenu=MENDYN1765357238059192\">\n" +
                        "                    <i class=\"material-symbols-rounded\">add</i>Import" +
                        "                </a>"
        );

%>

<script>
    function changerDesignation() {
        document.getElementById("personnel").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des employ&eacute;s</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/employe/infopersonnel-service-liste.jsp" method="post" name="personnel" id="personnel">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>

        </form>
        <ul>
            <li>service correspond &agrave; l'identification du service</li>
            <li>serviceLib correspond au libell&eacute; du service</li>
        </ul>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%}catch(Exception e){
    e.printStackTrace();
}%>
