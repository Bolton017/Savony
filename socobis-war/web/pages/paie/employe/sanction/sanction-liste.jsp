<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.*"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@ page import="paie.employe.sanction.Sanction"%>
<%@ page import="paie.employe.sanction.SanctionCPL" %>
<%@ page import="paie.employe.sanction.RegleInterieur" %>

<%
    try {
        UserEJB u = (user.UserEJB) session.getValue("u");

        String nomTable = "SANCTION_CPL";
        String lien = (String) session.getAttribute("lien");
        String apres = "paie/employe/sanction/sanction-liste.jsp";
        String lienFiche = "paie/employe/sanction/sanction-fiche.jsp";

        SanctionCPL sanctionCPL = new SanctionCPL();
        sanctionCPL.setNomTable(nomTable);

        String[] listeCritere = { "id", "NOMPERSONNEL" , "DATEDEBUT", "DATY", "DUREE", "NIVEAUSANCTION", "LIBELLEFAUTE", "SANCTION", "REGLEMENTLIB", "NUMEROREGLE" };
        String[] libEntete = { "id", "NOMPERSONNEL" , "DATEDEBUT", "DATY", "DUREE", "NIVEAUSANCTION", "LIBELLEFAUTE", "SANCTION", "REGLEMENTLIB", "NUMEROREGLE" };
        String[] listeIntervalle = { "DATEDEBUT", "DATY" };
        String[] colSomme = null;

        PageRecherche pr = new PageRecherche(sanctionCPL, request, listeCritere, listeIntervalle, 3, libEntete, libEntete.length);

        pr.setTitre("Liste des sanctions");
        pr.setUtilisateur(u);
        pr.setLien(lien);

        pr.getFormu().getChamp("NOMPERSONNEL").setLibelle("Nom Personnel");
        Liste[] liste = new Liste[1];
        RegleInterieur reglement = new RegleInterieur();
        reglement.setNomTable("REGLEMENTINTERIEUR");
        liste[0] = new Liste("REGLEMENTLIB",reglement,"DESCRIPTIONREGLE","id");
        pr.getFormu().changerEnChamp(liste);
        pr.getFormu().getChamp("REGLEMENTLIB").setLibelle("Sanction appliquée");
        pr.getFormu().getChamp("LIBELLEFAUTE").setLibelle("Description de la faute");
        pr.getFormu().getChamp("SANCTION").setLibelle("Sanction");
        pr.getFormu().getChamp("DATY1").setLibelle("Date d'enregistrement Min");
        pr.getFormu().getChamp("DATY2").setLibelle("Date d'enregistrement Max");
        pr.getFormu().getChamp("DATEDEBUT1").setLibelle("Date de d&eacute;but de la sanction Min");
        pr.getFormu().getChamp("DATEDEBUT2").setLibelle("Date de d&eacute;but de la sanction Max");
        pr.getFormu().getChamp("DUREE").setLibelle("Dur&eacute;e");
        pr.getFormu().getChamp("NIVEAUSANCTION").setLibelle("Niveau de la sanction");
        pr.getFormu().getChamp("NUMEROREGLE").setLibelle("Num&eacute;ro de la r&egrave;gle");

        pr.setApres(apres);
        pr.creerObjetPage(libEntete, colSomme);
        pr.getFormu().setAnotherButton(
        "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=paie/employe/sanction/sanction-saisie.jsp&currentMenu=ELM0006587\">\n" +
        "                    <i class=\"material-symbols-rounded\">add</i> Saisir une sanction" +
        "                </a>"
    );
%>


<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= apres %>" method="post" name="listeSanction" id="listeSanction">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>

        <%
            String lienTableauStr = pr.getLien() + "?but=";
            String lienTableau[] = { lienTableauStr + lienFiche };
            String colonneLien[] = { "id" };
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());
        %>

        </br>

        <%
            String libEnteteAffiche[] =  { "ID","Nom Personnel", "Date de d&eacute;but", "Date d'enregistrement", "Dur&eacute;e", "Niveau de la sanction", "Description de la faute", "Sanction appliquée" ,"Sanction", "Num&eacute;ro de la R&egrave;gle"};
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
