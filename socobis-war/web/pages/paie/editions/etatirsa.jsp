<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="paie.irsa.EtatIrsa" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="affichage.Liste" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="user.UserEJB" %>
<%@ page import="bean.*" %>
<%
    try {
        UserEJB u = (UserEJB) session.getValue("u");
        String lien = (String) session.getValue("lien");

        EtatIrsa irsa = new EtatIrsa();

        String[] listeCrt = {"mois", "annee","matricule","nom","poste"};
        String[] listeInt = {""};
        String[] libEntete = { "id", "matricule", "mois_lib", "annee", "numero_cnaps", "nom", "poste",
                "salaire_de_base", "indemnite", "avantages_en_nature", "montant_brut",
                "cnaps", "net_a_payer", "imposable", "irsa", "reductionpourpersonnesacharge", "irsanet"};
        String[] libEnteteAffiche = { "Id", "Matricule", "Mois", "Ann&eacute;e", "Num&eacute;ro CNAPS", "Nom et pr&eacute;noms",
                "Fonction", "Salaire de base", "Indemnit&eacute;s", "Avantages en nature",
                "Salaire brut", "CNAPS", "Salaire net", "Montant imposable",
                "Impôt correspondant", "R&eacute;duction charge de famille", "Impôt dû"};

        PageRecherche pr = new PageRecherche(irsa, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur(u);
        pr.setLien(lien);
        pr.setApres("paie/editions/etatirsa.jsp");

        affichage.Champ[] liste = new affichage.Champ[2];

        Liste moisListe = new Liste("mois");
        moisListe.makeListeMois();
        moisListe.setDefaut(request.getParameter("mois_infrap") != null ? request.getParameter("mois_infrap") : String.valueOf(Utilitaire.getMoisEnCours()));
        liste[0] = moisListe;
        TypeObjet poste = new TypeObjet();
        poste.setNomTable("PAIE_FONCTION");
        liste[1] = new Liste("poste",poste,"val","val");
        // Configure form fields
        pr.getFormu().changerEnChamp(liste);
        pr.getFormu().getChamp("mois").setLibelle("Mois");
        pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
        pr.getFormu().getChamp("matricule").setLibelle("Matricule");
        pr.getFormu().getChamp("poste").setLibelle("Fonction");
        pr.getFormu().getChamp("nom").setLibelle("Nom et pr&eacute;noms");
        pr.getFormu().getChamp("annee").setDefaut(request.getParameter("annee_infrap") != null ? request.getParameter("annee_infrap") : String.valueOf(Utilitaire.getAnneeEnCours()));

        String[] colSomme = { "net_a_payer", "imposable", "irsanet" };

        pr.creerObjetPage(libEntete, colSomme);

        // lien tableau
        String lienTableau[] = { pr.getLien() + "?but=paie/employe/personnel-fiche-portrait.jsp" };
        String colonneLien[] = { "id" };
        String libelles[] = {" ","Nombre", "Somme des Nets &agrave; Payer", "Somme des Montants Imposables", "Somme des imp&ocirc;ts d&ucirc;s"};

        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableauRecap().setLibeEntete(libelles);
%>
<div class="content-wrapper">
    <section class="content-header">
        <h1>État IRSA</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/editions/etatirsa.jsp" method="post" name="retrait" id="retrait" data-parsley-validate>
            <% out.println(pr.getFormu().getHtmlEnsemble()); %>
        </form>

        <br>

        <%
            out.println(pr.getTableauRecap().getHtml());
        %>

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
