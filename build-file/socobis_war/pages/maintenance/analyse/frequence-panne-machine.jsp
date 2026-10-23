<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 08/12/2025
  Time: 16:19
  To change this template use File | Settings | File Templates.
--%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageRechercheGroupe"%>
<%@ page import="maintenance.planning.FrequencePanneMachine" %>
<%@ page import="utilitaire.Utilitaire" %>
<%
    try {
        UserEJB u = (user.UserEJB) session.getValue("u");
        FrequencePanneMachine frequencePanneMachine = new FrequencePanneMachine();

        String listeCrt[] = {"daty", "idDepartementMaintenance"};
        String listeInt[] = {"daty"};

        String[] pourcentage = {};
        String somDefaut[] = {"qte"};
        String colGrCol[] = {"idMachineLib"};
        String[] colDefaut = {"daty"};

        PageRechercheGroupe pr = new PageRechercheGroupe(frequencePanneMachine, request, listeCrt, listeInt, 3, colGrCol, somDefaut, pourcentage, 4, 0);

        pr.setUtilisateur(u);
        pr.setLien((String) session.getValue("lien"));

        pr.getFormu().getChamp("daty1").setLibelle("Date d&eacute;but");
        pr.getFormu().getChamp("daty2").setLibelle("Date fin");

        pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.soustraireJourDate(7));
        pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());

        pr.getFormu().getChamp("idDepartementMaintenance").setLibelle("Service");

        pr.setApres("maintenance/analyse/frequence-panne-machine.jsp");
        pr.setNpp(2000);

        pr.creerObjetPageCroise(colDefaut, pr.getLien() + "?but=maintenance/analyse/frequence-panne-machine.jsp");

        String lib[] = {" ","nombre","somme des quantit&eacute;s"};
        pr.getTableauRecap().setLibeEntete(lib);

%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Fr&eacute;quence des pannes par machine</h1>
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
