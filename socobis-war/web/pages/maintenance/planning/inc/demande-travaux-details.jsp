
<%@page import="affichage.PageRecherche"%>
<%@ page import="maintenance.planning.DemandeTravauxCpl" %>

<% try{
  DemandeTravauxCpl bc = new DemandeTravauxCpl();
  String listeCrt[] = {};
  String listeInt[] = {};
  String libEntete[] = {"id","description","daty","dateBesoin","idEntiteLib","idMachineLib","idSituationLib","priorite","estExistantLib","etatLib"};
  String libEnteteAffiche[] = {"ID","Description","Date","Date de besoin","Entit&eacute;","Machine","Situation","Priorit&eacute;","Est existant","&Eacute;tat"};

  PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
  pr.setUtilisateur((user.UserEJB) session.getValue("u"));
  pr.setLien((String) session.getValue("lien"));
  pr.setApres("maintenance/planning/inc/demande-travaux-details.jsp");
  String[] colSomme =null;

  String daty = request.getParameter("daty");

  String awhere = "";
  String titre = "Liste des demandes de travaux";
  if (daty!=null){
    awhere = " and DATEBESOIN = TO_DATE('"+daty+"','DD/MM/YYYY')";
    titre+= " du "+daty;
  }

  pr.setAWhere(awhere);
  pr.setTitre(titre);
  pr.creerObjetPage(libEntete, colSomme);

//  Map<String,String> lienTab=new HashMap();
//  lienTab.put("modifier",pr.getLien() + "?but=reservation/reservation-modif.jsp");
//  lienTab.put("Voir fiche",pr.getLien() + "?but=reservation/reservation-fiche.jsp");
//  pr.getTableau().setLienClicDroite(lienTab);

  //Definition des lienTableau et des colonnes de lien
  String lienTableau[] = {pr.getLien() + "?but=maintenance/demandetravaux/demandetravaux-fiche.jsp"};
  String colonneLien[] = {"id"};
  pr.getTableau().setLien(lienTableau);
  pr.getTableau().setColonneLien(colonneLien);
  pr.getTableau().setLibelleAffiche(libEnteteAffiche);
//  pr.getTableau().setLienFille("reservation/inc/reservation-details.jsp&id=");
  //pr.getTableau().setModalOnClick(true);
%>
<div class="content-wrapper">
  <section class="content-header">
    <h1><%= pr.getTitre() %></h1>
  </section>
  <section class="content">
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
