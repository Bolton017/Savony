<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.accident.AccidentStats" %>

<% try{ 
    AccidentStats o = new AccidentStats();
    o.setNomTable("V_ACCIDENT_STATS");
    String[] listeCrt = {"datedernieraccident"};
    String[] listeInt = {"datedernieraccident"};
    String[] libEntete = {"datecomptage","datedernieraccident","joursansaccident","recordjoursansaccident"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Statistique des accidents / incidents de travail  ");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/accident/nombre-jours-sans-accident-travail.jsp");
    pr.getFormu().getChamp("datedernieraccident1").setLibelle("Date du dernier accident min");
    pr.getFormu().getChamp("datedernieraccident2").setLibelle("Date du dernier accident max");
    
    String[] colSomme = {"joursansaccident"};
    pr.creerObjetPage(libEntete, colSomme);
    
    String[] enteteRecap = {"","Nombre","Somme des jours sans accident"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] libEnteteAffiche = {"Date de comptage","Date du dernier accident","Jours sans accident","Record de jours sans accident"};
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

