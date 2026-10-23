<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="machine.ElementInspection" %>
<%@ page import="affichage.Liste"%>
<%@ page import="maintenance.ressources.IngredientMaintenance" %>

<% try{ 
    ElementInspection o = new ElementInspection();
    o.setNomTable("ELEMENTINSPECTION");
    String[] listeCrt = {"id","val","desce"};
    String[] listeInt = {};
    String[] libEntete = {"id","val","desce"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des &eacutel&eacutements &agrave; verifier");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("elementInspection-liste.jsp");
    
    Liste[] liste = new Liste[0];
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("val").setLibelle("Nom");
    pr.getFormu().getChamp("desce").setLibelle("Description");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=machine/elementInspection-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"ID","Nom","Description"};
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

