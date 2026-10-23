<%--
  Created by IntelliJ IDEA.
  User: safid
  Date: 10/12/2025
  Time: 22:54
  To change this template use File | Settings | File Templates.
--%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageRechercheGroupe"%>
<%@ page import="maintenance.planning.FrequencePanneMachine" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="maintenance.planning.DemandeTravauxCpl" %>
<%
  try {
    UserEJB u = (user.UserEJB) session.getValue("u");
    DemandeTravauxCpl frequenceDemandeDepartement = new DemandeTravauxCpl();
    frequenceDemandeDepartement.setNomTable("DEMANDETRAVAUX_CPL_NOMBRE");

    String listeCrt[] = {"daty", "idDepartementLib"};
    String listeInt[] = {"daty"};

    String[] pourcentage = {};
    String somDefaut[] = {"qte"};
    String colGrCol[] = {"idDepartementLib"};
    String[] colDefaut = {"daty"};

    PageRechercheGroupe pr = new PageRechercheGroupe(frequenceDemandeDepartement, request, listeCrt, listeInt, 3, colGrCol, somDefaut, pourcentage, 4, 0);

    pr.setUtilisateur(u);
    pr.setLien((String) session.getValue("lien"));

    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idDepartementLib").setLibelle("Libell&eacute; du d&eacute;partement");


    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.soustraireJourDate(7));
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());

//    pr.getFormu().getChamp("idDepartementMaintenance").setLibelle("Service");

    pr.setApres("maintenance/analyse/frequence-demande-departement.jsp");
    pr.setNpp(2000);

    pr.creerObjetPageCroise(colDefaut, pr.getLien() + "?but=maintenance/analyse/frequence-demande-departement.jsp");

    String lib[] = {" ","nombre","somme des quantit&eacute;"};
    pr.getTableauRecap().setLibeEntete(lib);

%>

<div class="content-wrapper">
  <section class="content-header">
    <h1>Fr&eacute;quence des demandes par departement</h1>
  </section>
  <section class="content">
    <form action="<%=pr.getLien()%>?but=<%= pr.getApres()%>" method="post" name="formulaire" id="analyse">
      <%out.println(pr.getFormu().getHtmlEnsemble());%>
    </form>
    <%
      out.println(pr.getTableauRecap().getHtml());%>
    <br>
    <%
      out.println(pr.getTableau().getHtml());
    %>
  </section>
  <% //out.println(pr.getBasPage()); %>
</div>
<%
  } catch (Exception e) {
    e.printStackTrace();
  }
%>

