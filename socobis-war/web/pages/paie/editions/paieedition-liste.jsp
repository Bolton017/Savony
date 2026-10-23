<%@page import="user.UserEJB"%>
<%@page import="bean.*"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="paie.edition.PaieRecap" %>
<%@ page import="affichage.Liste" %>

<%
    try {
        PaieRecap recap = new PaieRecap();
        recap.setNomTable("SITUATION_SALAIRE_COMPLET");

        String listeCrt[] = {"id", "nom", "matricule", "mois", "annee","salaire"};
        String listeInt[] = {"salaire"};

        String libEntete[] = {
                "id", "matricule", "nom", "moislib", "annee",
                "salaire", "heuresupp30ni", "heuresupp30i", "heuresupp50ni", "heuresupp50i",
                "majnuit", "majferie", "majweekend", "abbatement",
                "cnaps", "ostie", "irsa_e", "irsa_s", "a_payer"
        };

        PageRecherche pr = new PageRecherche(recap, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setTitre("R&eacute;capitulatif des salaires");
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("paie/editions/paieedition-liste.jsp");
         pr.getFormu().getChamp("salaire1").setLibelle("Salaire min");
          pr.getFormu().getChamp("salaire2").setLibelle("Salaire max");
        pr.getFormu().getChamp("mois").setLibelle("Mois");
        pr.getFormu().getChamp("annee").setDefaut(utilitaire.Utilitaire.getAnneeEnCours() + "");
        pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);

        String lienTableau[] = {pr.getLien() + "?but=paie/editions/paieedition-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);

        // Libell�s plus lisibles pour l?affichage
        String libEnteteAffiche[] = {
                "ID", "Matricule", "Nom", "Mois", "Ann&eacute;e",
                "Salaire de base",
                "Heure supp 30% Non Imposable", "Heure supp 30% Imposable",
                "Heure supp 50% Non Imposable", "Heure supp 50% Imposable",
                "Majoration Nuit", "Majoration F&eacute;ri&eacute;", "Majoration Week-end",
                "Abattement", "CNAPS", "OSTIE", "IRSA Employ&eacute;", "IRSA Soci&eacute;t&eacute;", "Net &agrave; Payer"
        };
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">

    <div class="row">
        <section class="content-header">
            <h1><%= pr.getTitre() %></h1>
        </section>
    </div>

    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <form action="<%= pr.getLien() %>?but=<%= pr.getApres() %>" method="post" name="recap" id="recap">
                    <%= pr.getFormu().getHtmlEnsemble() %>
                </form>

                <%= pr.getTableauRecap().getHtml() %>
                <br>

                <%= pr.getTableau().getHtml() %>
                <%= pr.getBasPage() %>
            </div>
        </div>
    </section>

</div>

<script>
    function changerDesignation() {
        document.recap.submit();
    }
</script>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
