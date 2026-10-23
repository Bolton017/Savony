<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 3/5/25
  Time: 2:28 PM
  To change this template use File | Settings | File Templates.
--%>

<%@page import="affichage.PageRecherche"%>
<%@page import="personnel.Personnel"%>

<% try{
    Personnel t = new Personnel();
    t.setNomTable("Personnel");
    String listeCrt[] = {"id","nom","telephone","adresse","remarque","compte"};
    String listeInt[] = {};
    String libEntete[] = {"id","nom","telephone","adresse","remarque","compte"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste Personnel");
    pr.getFormu().getChamp("telephone").setLibelle("T&eacute;l&eacute;phone");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("personnel/personnel-liste.jsp");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=personnel/personnel-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"ID","nom","t&eacute;l&eacute;phone","adresse","remarque","compte"};
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



