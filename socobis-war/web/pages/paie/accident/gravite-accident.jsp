<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.accident.GravitesAccidentStats" %>

<% try{ 
    GravitesAccidentStats o = new GravitesAccidentStats();
    o.setNomTable("V_TAUX_GRAVITE");
    String[] listeCrt = {"daty"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"daty","totaljourperdue","tauxgravite"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Gravit&eacute; des accidents ");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/accident/gravite-accident.jsp");
    pr.getFormu().getChamp("daty1").setLibelle("Mois min");
    pr.getFormu().getChamp("daty2").setLibelle("Mois max");

    String[] colSomme = {"totaljourperdue"};
    pr.creerObjetPage(libEntete, colSomme);
    
    String[] enteteRecap = {"","Nombre","Somme de totaljourperdue"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] libEnteteAffiche = {"Mois","Total des jours perdus","Taux de gravit&eacute; en %"};
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
            String[] libelles = {" ", "Nombre", "Somme des jours perdus", "Somme des taux de gravit&eacute;"};
            pr.getTableauRecap().setLibeEntete(libelles);
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

