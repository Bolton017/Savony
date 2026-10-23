<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<%@page import="affichage.PageRecherche"%>
<%@ page import="maintenance.planning.PlanningCpl" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
  PlanningCpl t = new PlanningCpl();
  String listeCrt[] = {"datedebut"};
  String listeInt[] = {"datedebut"};
  String libEntete[] = {"id","etatTravaux","etatTravauxLib"};
  PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
  pr.setTitre("Rapprochement de r&eacute;alisation");
  pr.setUtilisateur((user.UserEJB) session.getValue("u"));
  pr.setLien((String) session.getValue("lien"));
  pr.setApres("maintenance/analyse/rapprochement-realisation.jsp");
  pr.getFormu().getChamp("datedebut1").setLibelle("Date min");
  pr.getFormu().getChamp("datedebut2").setLibelle("Date max");
  pr.getFormu().getChamp("datedebut1").setDefaut(Utilitaire.soustraireJourDate(7));
  pr.getFormu().getChamp("datedebut2").setDefaut(Utilitaire.dateDuJour());

  String[] colSomme = null;
  pr.creerObjetPage(libEntete, colSomme);
  pr.setNpp(2000);

  PlanningCpl[] data = (PlanningCpl[]) pr.getTableau().getData();
  int[] dataResume = t.getDataRssume(data);

  int nombreDemande = dataResume[0];
  int nombreRealise = dataResume[1];
  double pourcentage = nombreDemande == 0 ? 0 : ( (double) nombreRealise / nombreDemande ) * 100;


//  String libEnteteAffiche[] = {"ID", "etatTravaux", "etatTravauxLib"};
//  pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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
    <div id="resume" style="
    display:flex;
    gap:20px;
    margin-top:25px;
    flex-wrap:wrap;
">
      <div style="
        flex:1;
        min-width:220px;
        background:#ffffff;
        padding:20px;
        border-radius:12px;
        box-shadow:0 4px 12px rgba(0,0,0,0.08);
    ">
        <h3 style="margin:0; font-size:18px; color:#666;">Demandes</h3>
        <p style="font-size:32px; margin:10px 0; font-weight:600;"><%= nombreDemande %></p>
      </div>

      <div style="
        flex:1;
        min-width:220px;
        background:#ffffff;
        padding:20px;
        border-radius:12px;
        box-shadow:0 4px 12px rgba(0,0,0,0.08);
    ">
        <h3 style="margin:0; font-size:18px; color:#666;">Réalisées</h3>
        <p style="font-size:32px; margin:10px 0; font-weight:600; color:#28a745;"><%= nombreRealise %></p>
      </div>

      <div style="
        flex:1;
        min-width:220px;
        background:#ffffff;
        padding:20px;
        border-radius:12px;
        box-shadow:0 4px 12px rgba(0,0,0,0.08);
    ">
        <h3 style="margin:0; font-size:18px; color:#666;">% Réalisation</h3>
        <p style="font-size:32px; margin:10px 0; font-weight:600; color:#007bff;">
          <%= String.format("%.2f", pourcentage) %>%
        </p>
      </div>
    </div>

  </section>
</div>
<%
  }catch(Exception e){

    e.printStackTrace();
  }
%>




