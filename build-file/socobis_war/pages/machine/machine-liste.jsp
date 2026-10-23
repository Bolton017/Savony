<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 20/08/2025
  Time: 10:32
  To change this template use File | Settings | File Templates.
--%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="bean.TypeObjet" %>
<%@ page import="machine.Machine" %>

<% try{
    Machine t = new Machine();
    t.setNomTable("MACHINE");
    String listeCrt[] = {"id","val","desce"};
    String listeInt[] = {};
    String libEntete[] = {"id","val","desce"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des Machines");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("machine/machine-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("val").setLibelle("Nom");
    pr.getFormu().getChamp("desce").setLibelle("Description");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=machine/machine-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID", "Nom", "Description"};
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
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>
