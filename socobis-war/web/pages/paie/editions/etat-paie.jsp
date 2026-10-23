<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="paie.edition.EtatPaie"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageRecherche"%>

<%
    try {
        EtatPaie dr = new EtatPaie();
        String nomTable = "SITUATION_SALAIRE_EDITION";
        dr.setNomTable(nomTable);

        String listeCrt[] = { "matricule", "nom", "annee", "mois" };
        String listeInt[] = {};

        String libEntete[] = {
                "id", "matricule", "nom", "salaire", "hs_m", "indem", "ancien", "prime",
                "autres", "total", "cnaps", "ostie", "irsa_e", "av_spe",
                "autres2", "a_payer"
        };

        PageRecherche pr = new PageRecherche(dr, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        affichage.Champ[] liste = new affichage.Champ[1];
        Liste mois = new Liste("mois");
        mois.makeListeMois();
        liste[0] = mois;

        pr.setApres("paie/editions/etat-paie.jsp");

        String[] colSomme = { "salaire", "a_payer" };
        pr.creerObjetPage(libEntete, colSomme);

        String lienTableau[] = { pr.getLien() + "?but=paie/employe/personnel-fiche-portrait.jsp" };
        String colonneLien[] = { "id" };
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);

        String libEnteteAffiche[] = {
                "ID", "Matricule", "Nom",
                "Salaire", "HS + M", "Indemnit&eacute;", "Anciennet&eacute;", "Prime",
                "Autres Gain", "Total", "CNAPS", "OSTIE",
                "IRSA","Avance Sp&eacute;ciale", "Autres Retenue", "A Payer"
        };
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);

        String enteteRecap[] = { "", "Nombre", "Somme des Salaires", "Somme des A Payer" };
        pr.getTableauRecap().setLibeEntete(enteteRecap);
%>

<script>
    function changerDesignation() {
        document.getElementById("etatpaie").submit();
    }
</script>

<div class="content-wrapper">
    <section class="content-header">
        <h1>&Eacute;tat de Paie</h1>
    </section>

    <section class="content">
        <form action="<%= pr.getLien() %>?but=paie/editions/etat-paie.jsp" method="post" name="etatpaie" id="etatpaie">
            <%= pr.getFormu().getHtmlEnsemble() %>
        </form>

        <%= pr.getTableauRecap().getHtml() %>
        <br>
        <%= pr.getTableau().getHtml() %>
        <%= pr.getBasPage() %>
    </section>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
