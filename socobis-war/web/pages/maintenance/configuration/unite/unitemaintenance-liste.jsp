<%@ page import="affichage.PageRecherche"%>
<%@ page import="maintenance.configuration.UniteMaintenance" %>

<% try{ 
    UniteMaintenance o = new UniteMaintenance();
    o.setNomTable("");
    String[] listeCrt = {"id", "val", "desce", "echelle"};
    String[] listeInt = {"echelle"};
    String[] libEntete = {"id", "val", "desce", "echelle"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des unit&eacute;s de maintenance");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("maintenance/configuration/unite/unitemaintenance-liste");

    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("val").setLibelle("Libell&eacute;");
    pr.getFormu().getChamp("desce").setLibelle("Description");
    pr.getFormu().getChamp("echelle1").setLibelle("&Eacute;chelle min");
    pr.getFormu().getChamp("echelle2").setLibelle("&Eacute;chelle max");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=maintenance/configuration/unite/unitemaintenance-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String[] libEnteteAffiche = {"Id", "Libell&eacute;", "Description", "&Eacute;chelle"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=maintenance/configuration/unite/unitemaintenance-saisie.jsp&currentMenu=MENDYN1764601606147423\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir une unit&eacute; de maintenance" +
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

