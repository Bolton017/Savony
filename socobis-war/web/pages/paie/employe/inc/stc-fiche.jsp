<%@page import="utilitaire.Utilitaire"%>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="paie.log.LogPersonnelNonValide" %>
<%@ page import="paie.employe.EmployeEltPaie" %>
<%@ page import="bean.AdminGen" %>

<%
try {
    String id = request.getParameter("id");
    String baselien = (String) session.getValue("lien");

    if (id == null || id.trim().equals("")) {
%>
        <div style="text-align:center">
            <h4>Aucun identifiant fourni</h4>
        </div>
<%
        return;
    }

    LogPersonnelNonValide log = LogPersonnelNonValide.getLogPersNonValideById(id);

    if (log == null || log.getDateapplication() == null || log.getIdlogpers() == null) {
%>
        <div style="text-align:center">
            <h4>Aucune donnée STC valide pour ce personnel</h4>
        </div>
<%
        return;
    }

    EmployeEltPaie mapping = new EmployeEltPaie();
    mapping.setNomTable("DETAILS_ELT_PAIE");

    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = { "desceRubrique", "gain", "retenue" };
    String[] colSomme = null;

    PageRecherche pr = new PageRecherche(
        mapping,
        request,
        listeCrt,
        listeInt,
        3,
        libEntete,
        libEntete.length
    );

    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien(baselien);

    pr.setAWhere(
        " and mois=" + Utilitaire.getMois(log.getDateapplication()) +
        " and annee=" + Utilitaire.getAnnee(log.getDateapplication()) +
        " and id='" + log.getIdlogpers() + "'"
    );

    pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">

<%
    if (pr.getListe() == null || pr.getListe().length == 0) {
%>
        <div style="text-align:center">
            <h4>Aucune donnée trouvée</h4>
        </div>
<%
    } else {
        String[] libEnteteAffiche = { "Rubrique", "Gain", "Retenue" };
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        out.println(pr.getTableau().getHtml());

        double gain = AdminGen.calculSommeDouble(pr.getListe(), "gain");
        double retenue = AdminGen.calculSommeDouble(pr.getListe(), "retenue");
        double net = gain - retenue;
%>

    <div class="w-100" style="display:flex;flex-direction:row-reverse;">
        <table style="width:20%" class="table">
            <tr>
                <td><b>Somme Gains</b></td>
                <td><b><%= Utilitaire.formaterAr(gain) %> Ar</b></td>
            </tr>
            <tr>
                <td><b>Somme Retenues</b></td>
                <td><b><%= Utilitaire.formaterAr(retenue) %> Ar</b></td>
            </tr>
            <tr>
                <td><b>Salaire Net</b></td>
                <td><b><%= Utilitaire.formaterAr(net) %> Ar</b></td>
            </tr>
        </table>
    </div>

    <form action="<%= baselien %>?but=apresSpecifique.jsp" method="post">
        <input type="hidden" name="idpersonnel" value="<%= log.getIdlogpers() %>">
        <input type="hidden" name="acte" value="valider_stc">
        <button class="btn btn-primary pull-right">Valider STC</button>
    </form>

<%
    }
%>

</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
    <div style="text-align:center;color:red">
        <h4>Erreur lors du chargement du STC</h4>
    </div>
<%
}
%>
