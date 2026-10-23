<%@page import="paie.log.LogPersonnelFin"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="user.UserEJB" %>
<%@ page import="historique.MapUtilisateur" %>
<%@ page import="paie.demande.EmployeComplet" %>
<%@ page import="rh.QualificationPaie" %>

<%
    try{
        LogPersonnelFin dr = new LogPersonnelFin();
        String nomTable = "EMPLOYE_RETRAITE";
        if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
            nomTable = request.getParameter("etat");
        }
        UserEJB ue = (UserEJB) session.getValue("u");
        EmployeComplet pers = new EmployeComplet();

        MapUtilisateur map = ue.getUser();

        dr.setNomTable(nomTable);
        String listeCrt[] = { "id","matricule","nom", "prenom","sexe","date_naissance", "dateembauche","date_depart","idQualification","direction","idDepartement", "service", "age","temporaire"};
        //String listeCrt[] = { "id","matricule", "numero_cin","nom", "prenom", "idDepartement","idQualification","direction", "service", "temporaire"};
//    String listeCrt[] = { "id","matricule", "numero_cin","nom", "prenom","idDepartement", "idQualification", "direction", "service", "temporaire"};
        String listeInt[] = {"dateembauche","date_naissance","date_depart","age"};
        //String libEntete[] = {"id", "matricule", "nom", "prenom", "sexe", "numero_cin", "direction", "service", "qualificationLib","departementLib","temporaire","etatLib"};
        String libEntete[] = {"id", "matricule", "nom", "prenom","date_naissance", "age", "dateembauche","date_depart", "departementLib","anciennete"};
        PageRecherche pr = new PageRecherche(dr, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setNpp(100);
        
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
        TypeObjet m0 = new TypeObjet();
        m0.setNomTable("log_direction");
        liste[0] = new Liste("direction", m0, "val", "val");


        TypeObjet m1 = new TypeObjet();
        m1.setNomTable("log_service_crt");
        liste[1] = new Liste("service", m1, "desce", "desce");

        QualificationPaie qual = new QualificationPaie();
        qual.setNomTable("QUALIFICATION_PAIE");
        liste[2] = new Liste("idQualification", qual, "val", "id");

        TypeObjet dep = new TypeObjet();
        dep.setNomTable("DEPARTEMENT");
        liste[3] = new Liste("idDepartement", dep, "val", "id");

        Liste tem = new Liste("temporaire");
        String[] aff = {"Tous", "Cadre", "Permanent", "Temporaire"};
        String[] val = {"%", "Cadre", "Permanent", "Temporaire"};
        tem.ajouterValeur(val, aff);
        liste[4] = tem;

        TypeObjet genre = new TypeObjet();
        genre.setNomTable("SEXE");
        liste[5] = new Liste("sexe", genre, "val", "val");

        pr.getFormu().changerEnChamp(liste);

        pr.setApres("paie/employe/personnel-retraite.jsp");
        String[] colSomme = null;
        pr.getFormu().getChamp("id").setLibelle("ID");
        pr.getFormu().getChamp("id").setVisible(false);
//    manager sy admin ihany no mahita ny liste employes rehetra sinon raha agent izy dia ny tenany ihany no hitany
        if(map.getIdrole().compareToIgnoreCase("agent")==0) {
            EmployeComplet e = pers.getEmployeByRefUser(map.getTuppleID());
            pr.getFormu().getChamp("id").setDefaut(e.getId());
        }
        pr.getFormu().getChamp("nom").setLibelle("Nom");
        pr.getFormu().getChamp("prenom").setLibelle("Pr&eacute;nom(s)");
        pr.getFormu().getChamp("sexe").setLibelle("Genre");

        pr.getFormu().getChamp("dateembauche1").setLibelle("Date d'embauche min");
        pr.getFormu().getChamp("dateembauche2").setLibelle("Date d'embauche max");

        pr.getFormu().getChamp("date_naissance1").setLibelle("Date de naissance min");
        pr.getFormu().getChamp("date_naissance2").setLibelle("Date de naissance max");

        pr.getFormu().getChamp("date_depart1").setLibelle("Date de d&eacute;part min");
        pr.getFormu().getChamp("date_depart2").setLibelle("Date de d&eacute;part max");

        pr.getFormu().getChamp("age1").setLibelle("Age min");
        pr.getFormu().getChamp("age2").setLibelle("Age max");

//    pr.getFormu().getChamp("numero_cin").setLibelle("Carte d'identit&eacute; (CIN)");
//    pr.getFormu().getChamp("numero_cin").setVisible(false);
        pr.getFormu().getChamp("matricule").setLibelle("Matricule");
        pr.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement");
        pr.getFormu().getChamp("idQualification").setLibelle("Classification");
        pr.getFormu().getChamp("temporaire").setLibelle("Type de Contrat");
        pr.getFormu().getChamp("direction").setLibelle("Lieu d'affectation");
        pr.getFormu().getChamp("service").setLibelle("Service");

        pr.creerObjetPage(libEntete, colSomme);
//    String enteteRecap[] = {"","Nombre","Somme de droit de cong&eacute;"};
//    pr.getTableauRecap().setLibeEntete(enteteRecap);
        String lienTableau[] = {pr.getLien() + "?but=paie/employe/personnel-fiche-portrait.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        //String libEnteteAffiche[] = {"ID", "Matricule", "Nom", "Pr&eacute;nom(s)", "Genre", "CIN", "Lieu d'affectation", "Rattachement","Classification","D&eacute;partement","Type de contrat", "&Eacute;tat"};
        String libEnteteAffiche[] = {"ID", "Matricule", "Nom", "Pr&eacute;nom(s)","Date de naissance" ,"Age", "Date d'embauche","Date de d&eacute;part","D&eacute;partement","Anciennet&eacute;"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
//        String[] etatVal = {"LOG_PERSONNEL_AVECCONGE","log_personnel_fin_valide", "LOG_PERSONNEL_FIN_A_VALIDER", "log_personne_non_valide_vue"};
//        String[] etatAff = {"Tous","Valid&eacute;s","A Valider","D&eacute;bauch&eacute;s"};
%>

<script>
    function changerDesignation() {
        document.getElementById("personnel").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des employ&eacute;s retrait&eacute;s</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/employe/personnel-retraite.jsp" method="post" name="personnel" id="personnel">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>

        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
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
