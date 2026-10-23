<%@page import="paie.contrat.VueContrat"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="utilitaire.Utilitaire"%>
<%@ page import="paie.conge.EtatConge" %>
<%
    try{
        EtatConge base = new EtatConge();
        base.setNomTable("SOLDECONGEPRIS_PERS");

        String libEntete[] = { "id", "nomPersonnel", "matricule", "congePris" };
        String listeCrt[] = { "id", "nomPersonnel", "matricule"};
        String listeInt[] = { };

        PageRecherche pr = new PageRecherche(base, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        pr.getFormu().getChamp("id").setLibelle("ID Personnel");
        pr.getFormu().getChamp("nomPersonnel").setLibelle("Nom Personnel");
        pr.getFormu().getChamp("matricule").setLibelle("Matricule");

        pr.setNpp(100);
        pr.setApres("paie/conge/conge-pris.jsp");
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
%>
<script>
    function changerDesignation() {
        document.liste.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste cong&eacute; pris</h1>
    </section>
    <section class="content">
        <form action='<%=pr.getLien() + "?but=" + pr.getApres() %>' method="post" name="liste" id="liste">
            <% out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            String libEnteteAffiche[] = { "ID Personnel", "Nom Personnel", "Matricule", "Cong&eacute; Pris"};
            String lienTableau[] = { pr.getLien() + "?but=paie/employe/personnel-fiche.jsp" };
            String colonneLien[] = { "id" };

            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception ex){
        ex.printStackTrace();
    }
%>