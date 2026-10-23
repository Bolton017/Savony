<%-- 
    Document   : pointage_visee_liste
    Created on : 8 mars 2019, 10:18:51
    Author     : EBI
--%>

<%@page import="paie.employe.ConstantePaie"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="paie.pointage.Pointage"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.demande.EmployeComplet" %>
<%@ page import="historique.MapUtilisateur" %>

<% try {
    UserEJB ue = (UserEJB) session.getValue("u");
    EmployeComplet employeComplet = new EmployeComplet();
    MapUtilisateur mapUser = ue.getUser();

    Pointage lv = new Pointage();
    lv.setNomTable("POINTAGE_LIB");
    String listeCrt[] = {"id", "idpersonnel","NOMPERSONNEL", "matricule", "moisLib", "annee", "directionLib", "heurenormal", "heuresupnormal", "heuresupnuit", "heuresupferie", "heuresupweekend", "absence"};
    String listeInt[] = {};
    String libEntete[] = {"id", "NOMPERSONNEL", "matricule", "moisLib", "annee", "directionLib", "heurenormal", "heuresupnormal", "heuresupnuit", "heuresupferie", "heuresupweekend", "absence"};
    PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    if(mapUser.getIdrole().compareToIgnoreCase("agent") == 0) {
        EmployeComplet emp = employeComplet.getEmployeByRefUser(mapUser.getTuppleID());
        pr.getFormu().getChamp("idpersonnel").setDefaut(emp.getId());
    }
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.getFormu().getChamp("NOMPERSONNEL").setLibelle("Personnel");
    pr.getFormu().getChamp("idpersonnel").setLibelle("ID Personnel");
    pr.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.setApres("paie/pointage/pointage-liste.jsp");
    String[] colSomme = { "heuresupnormal", "heuresupnuit", "heuresupferie","heuresupweekend","absence" };
    
    TypeObjet crt = new TypeObjet();
    crt.setNomTable("LOG_DIRECTION");
    TypeObjet[] dr = (TypeObjet[]) CGenUtil.rechercher(crt, null, null, null, "");
    TypeObjet[] mois = ConstantePaie.getMoisTous();
    affichage.Champ[] liste = new affichage.Champ[2];
    liste[0] = new Liste("directionLib", dr, "val", "val");
    liste[1] = new Liste("moisLib", mois, "val", "val");
    pr.getFormu().getChamp("heuresupnormal").setVisible(false);
    pr.getFormu().getChamp("heurenormal").setVisible(false);
    pr.getFormu().getChamp("heuresupnuit").setVisible(false);
    pr.getFormu().getChamp("heuresupferie").setVisible(false);
    pr.getFormu().getChamp("heuresupweekend").setVisible(false);
    pr.getFormu().getChamp("absence").setVisible(false);

    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("directionLib").setLibelle("Direction");
    pr.getFormu().getChamp("moisLib").setLibelle("Mois");
    pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");

    pr.creerObjetPage(libEntete, colSomme);

    String enteteRecap[] = {"", "Nombre","Somme des Heures Supll&eacute;mentaires normales","Somme des heures major&eacute;es de Nuit", "Somme des Heures major&eacute;es F&eacute;ri&eacute;e", "Somme des Heure major&eacute;es Week-End", "Somme des heures d'absences"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=paie/pointage/pointage-saisie.jsp&currentMenu=MENDYN00001\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir un pointage" +
            "                </a>"
    );

%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des pointages</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/pointage/pointage-liste.jsp" method="post" name="incident" id="incident">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%  
            String lienTableau[] = {pr.getLien() + "?but=paie/pointage/pointage-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            String libEnteteAffiche[] = {"ID", "Personnel", "Matricule", "Mois", "Ann&eacute;e", "Direction", "Heure normal", "Heure suppl&eacute;mentaire normal", "Heure Major&eacute;e  Nuit", "Heure Major&eacute;e F&eacute;ri&eacute;", "Heure Major&eacute;e Week-end", "Heure d'absence"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());

        %>
    </section>
</div>
<% }catch(Exception e){
    e.printStackTrace();
}%>

