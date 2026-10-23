
<%@page import="paie.edition.PaieEditionmoisanneeLib"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Liste" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@page import="bean.TypeObjet"%>
<%
    try{
        String nomProjet = "Fer",
                nomVue = "paie_editionmoisannee_lib",
                titre = "Liste de paie",
                nomPage = "paie/editionmoisannee/editionmoisannee-liste.jsp"
                ;
        String listeCrt[] = {"id","mois","annee","montant","iddirection"};
        String listeInt[] = {"montant"};
        String libEntete[] = {"id","mois_string","annee","montant","iddirection"};
        PaieEditionmoisanneeLib objet = new PaieEditionmoisanneeLib();
        objet.setNomTable(nomVue);
        PageRecherche pr = new PageRecherche(objet, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres(nomPage);


        Liste[] liste = new Liste[2];
        liste[0] = new Liste("mois");
        liste[0].makeListeMois();

        TypeObjet direction= new TypeObjet();
        direction.setNomTable("log_direction");
        liste[1]=new Liste("iddirection", direction, "val", "val");
        pr.getFormu().changerEnChamp(liste);


        pr.getFormu().getChamp("annee").setLibelleAffiche("Ann&eacute;e");
        pr.getFormu().getChamp("montant1").setLibelleAffiche("Montant min");
        pr.getFormu().getChamp("montant2").setLibelleAffiche("Montant max");
        pr.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        String lienTableau[] = {pr.getLien() + "?but=paie/editionmoisannee/editionmoisannee-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        String libEnteteAffiche[] = {"Id","Mois","Ann&eacute;e","Montant","Direction"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        pr.getFormu().getChamp("iddirection").setLibelleAffiche("Direction");
        pr.getFormu().getChamp("mois").setLibelleAffiche("Mois");
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%=titre%></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%=nomPage%>" method="post" name="<%=nomProjet%>" id="<%=nomProjet%>">
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


<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
	alert('<%=e.getMessage()%>');
    history.back();</script>
<% }%>
