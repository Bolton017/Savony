<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.evaluation.EvaluationAnnuelleLib" %>

<% try{ 
    EvaluationAnnuelleLib o = new EvaluationAnnuelleLib();
    o.setNomTable("EVALUATION_ANNUELLE_LIB");
    String[] listeCrt = {"id","idpersonnel","idpersonnellib","annee"};
    String[] listeInt = {};
    String[] libEntete = {"id","idpersonnel","idpersonnellib", "matricule", "idFonctionLib", "annee","etatlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des &eacute;valuations annuelles");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/evaluation/evaluationannuelle-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
    pr.getFormu().getChamp("idpersonnellib").setLibelle("Nom & pr&eacute;nom");
    pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=paie/evaluation/evaluationannuelle-fiche.jsp",pr.getLien() + "?but=paie/employe/personnel-fiche-portrait.jsp"};
    String[] colonneLien = {"id","idpersonnel"};
    String[] attributLien = {"id","id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Personnel","Nom & pr&eacute;nom","Matricule","Fonction","Ann&eacute;e","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=paie/evaluation/evaluationannuelle-saisie.jsp\">\n" +
                    "                    <i class=\"material-symbols-rounded\">add</i> Saisir une évaluation annuelle\n" +
                    "                </a>"
    );
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
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

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

