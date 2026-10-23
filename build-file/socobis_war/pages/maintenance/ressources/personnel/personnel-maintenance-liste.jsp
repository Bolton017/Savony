<%@ page import="affichage.PageRecherche"%>
<%@ page import="maintenance.ressources.PersonnelMaintenanceLib" %>
<%@ page import="affichage.Liste" %>
<%@ page import="maintenance.ressources.DepartementMaintenance" %>

<% try{ 
    PersonnelMaintenanceLib o = new PersonnelMaintenanceLib();
    String[] listeCrt = {"id", "nom", "mail", "idDepartement"};
    String[] listeInt = {};
    String[] libEntete = {"id" , "nom", "telephone", "mail", "adresse", "idDepartementLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des personnels");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("personnel-maintenance-liste");

    Liste[] liste = new Liste[1];
    DepartementMaintenance dep = new DepartementMaintenance();
    liste[0] = new Liste("idDepartement",dep,"val","id");

    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("nom").setLibelle("Nom");
//    pr.getFormu().getChamp("adresse").setLibelle("Adresse");
    pr.getFormu().getChamp("mail").setLibelle("Adresse e-mail");
    pr.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=maintenance/ressources/personnel/personnel-maintenance-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=maintenance/ressources/personnel/personnel-maintenance-saisie.jsp&currentMenu=MENDYN1764572158773208\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir un personnel de maintenance" +
            "                </a>"
    );


    String[] libEnteteAffiche = {"Id" , "Nom", "T&eacute;l&eacute;phone", "Adresse e-mail", "Adresse","D&eacute;partement"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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

