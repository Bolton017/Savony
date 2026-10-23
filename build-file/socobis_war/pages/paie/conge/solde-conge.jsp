<%@page import="paie.contrat.VueContrat"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="utilitaire.Utilitaire"%>
<%@ page import="paie.conge.EtatConge" %>
<%@ page import="user.UserEJB" %>
<%@ page import="historique.MapUtilisateur" %>
<%@ page import="paie.demande.EmployeComplet" %>
<%
    try{
        EtatConge base = new EtatConge();
        base.setNomTable("SOLDECONGE_PERS_CPL");

        String libEntete[] = { "id", "nomPersonnel", "matricule", "droit", "congePris", "solde" };
        String listeCrt[] = { "id", "nomPersonnel", "matricule"};
        String listeInt[] = { };

        PageRecherche pr = new PageRecherche(base, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        pr.getFormu().getChamp("id").setLibelle("ID");
        pr.getFormu().getChamp("nomPersonnel").setLibelle("Nom Personnel");
        pr.getFormu().getChamp("matricule").setLibelle("Matricule");

        UserEJB ue = (UserEJB) session.getValue("u");
        EmployeComplet employeComplet = new EmployeComplet();
        MapUtilisateur mapUser = ue.getUser();

        if(mapUser.getIdrole().compareToIgnoreCase("agent")==0) {
            EmployeComplet emp = employeComplet.getEmployeByRefUser(mapUser.getTuppleID());
            pr.getFormu().getChamp("id").setDefaut(emp.getId());
        }


        pr.setNpp(100);
        pr.setApres("paie/conge/solde-conge.jsp");
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
        <h1>Solde de cong&eacute; des personnels</h1>
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
            String libEnteteAffiche[] = {"ID", "Nom Personnel", "Matricule", "Droit de cong&eacute;", "Cong&eacute; pris", "Cong&eacute; restant" };
            String lienTableau[] = { pr.getLien() + "?but=paie/employe/personnel-fiche-portrait.jsp" };
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