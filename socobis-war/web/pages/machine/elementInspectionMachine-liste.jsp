<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="machine.ElementInspectionMachineLib" %>
<%@ page import="affichage.Liste"%>
<%@ page import="maintenance.ressources.IngredientMaintenance" %>
<%@ page import="machine.ElementInspection" %>
<%@ page import="machine.Machine" %>

<% try{ 
    ElementInspectionMachineLib o = new ElementInspectionMachineLib();
    o.setNomTable("ELEMENTINSPECTIONMACHINELIB");
    String[] listeCrt = {"id","idelementinspection","idmachine"};
    String[] listeInt = {};
    String[] libEntete = {"id","idElementInspectionLib","idMachineLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des &eacute;l&eacute;ments &agrave; v&eacute;rifier dans une machine");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("machine/elementInspectionMachine-liste.jsp");
    
    Liste[] liste = new Liste[2];
    ElementInspection liste0 = new ElementInspection();
    liste0.setNomTable("ELEMENTINSPECTION");
    liste[0] = new Liste("idelementinspection",liste0,"val","id");
    Machine liste1 = new Machine();
    liste1.setNomTable("MACHINE");
    liste[1] = new Liste("idmachine",liste1,"val","id");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("idelementinspection").setLibelle("Idelementinspection");
    pr.getFormu().getChamp("idmachine").setLibelle("Idmachine");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=machine/elementInspectionMachine-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"ID","&Eacutel&eacute;ment insp&eacute;cter","Machine"};
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

