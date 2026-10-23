<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@page import="mg.cnaps.compta.ComptaLettrageLib"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="bean.TypeObjet"%>
<%@ page import="mg.cnaps.compta.Journal" %>
<%@ page import="affichage.Liste" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.sql.Date" %>
<%
    UserEJB u = null;
    String lien = null;

    u = (UserEJB) session.getValue("u");
    lien = (String) session.getValue("lien");

    ComptaLettrageLib lv = new ComptaLettrageLib();

    String listeCrt[] = {"id", "lettre", "date_lettrage",  "compte"};
    String listeInt[] = {"date_lettrage"};
    String libEntete[] = {"id", "lettre","date_lettrage", "compte"};
    PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    //affichage.Liste[] listeJournalDebit = new affichage.Liste[1];
    //Journal jDebit = new Journal();
    //jDebit.setNomTable("COMPTA_JOURNAL_ECRITURE_VIEW");
    //pr.setAWhere(" and lettre = UPPER(lettre)");
    //listeJournalDebit[0] = new Liste("journal", jDebit, "val", "id");
    //pr.getFormu().changerEnChamp(listeJournalDebit);
     LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));
    pr.getFormu().getChamp("date_lettrage1").setLibelle(" date lettrage min");
    pr.getFormu().getChamp("date_lettrage1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("date_lettrage2").setLibelle(" date lettrage max");
    pr.getFormu().getChamp("date_lettrage2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("compta/lettrage/lettrage-liste.jsp");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=compta/lettrage/lettrage-saisie.jsp&currentMenu=MNDNT2205003\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisir un lettrage</a>"
    );

%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste Lettrage</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=compta/lettrage/lettrage-liste.jsp" method="post" name="incident" id="incident">
            <%

                // pr.getFormu().makeHtmlNew();
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <br/><br/>
        </form>
        <%  String lienTableau[] = {pr.getLien() + "?but=compta/lettrage/lettrage-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            pr.getTableau().setLienFille("compta/lettrage/inc/sousecriture-liste.jsp&lettrage=");
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>

        <%
            String libEnteteAffiche[] = {"ID", "Lettre", "Date lettrage", "Compte"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
