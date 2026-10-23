<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.Liste"%>
<%@ page import="maintenance.planning.DemandeTravaux" %>
<%@ page import="maintenance.configuration.Entite" %>
<%@ page import="maintenance.configuration.Situation" %>
<%@ page import="maintenance.ressources.DepartementMaintenance" %>
<%@ page import="bean.TypeObjet" %>

<%
  try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "maintenance.planning.DemandeTravaux",
            nomtable = "DemandeTravaux",
            apres = "maintenance/demandetravaux/demandetravaux-fiche.jsp",
            titre = "Saisie d'une demande de travaux";
    if (request.getParameter("acte")!=null && request.getParameter("acte").equals("update")){
      titre = "Modification d'une demande de travaux";
    }
    DemandeTravaux categorie = new DemandeTravaux();
    PageInsert pi = new PageInsert(categorie, request, u);
    pi.setLien((String) session.getValue("lien"));
    Liste[] liste = new Liste[6];
    Entite c = new Entite();
    liste[0] = new Liste("idEntite",c,"val","id");
    Situation c2 = new Situation();
    liste[1] = new Liste("idSituation",c2,"val","id");
    liste[2] = new Liste("estExistant");
    liste[2].makeListeOuiNon();
    TypeObjet departementMaintenance = new TypeObjet();
    departementMaintenance.setNomTable("departementMaintenance");
    liste[3] = new Liste("idDepartementMaintenance",departementMaintenance,"val","id");
    TypeObjet prio = new TypeObjet();
    prio.setNomTable("PRIORITE");
    liste[4] = new Liste("priorite",prio,"val","id");
    TypeObjet depar = new TypeObjet();
    depar.setNomTable("departement");
    liste[5] = new Liste("idDepartement",depar,"val","id");
    pi.getFormu().changerEnChamp(liste);

    if (request.getParameter("entite")!=null && !request.getParameter("entite").equalsIgnoreCase("")){
      pi.getFormu().getChamp("idEntite").setDefaut(request.getParameter("entite"));
    }if (request.getParameter("idMachine")!=null && !request.getParameter("idMachine").equalsIgnoreCase("")){
      pi.getFormu().getChamp("idMachine").setDefaut(request.getParameter("idMachine"));
    }if (request.getParameter("description")!=null && !request.getParameter("description").equalsIgnoreCase("")){
      pi.getFormu().getChamp("description").setDefaut(request.getParameter("description"));
    }if (request.getParameter("idplanning")!=null && !request.getParameter("idplanning").equalsIgnoreCase("")){
      pi.getFormu().getChamp("idPlanning").setDefaut(request.getParameter("idplanning"));
    }

    String idDepartement = request.getParameter("idDepartement");
    if (idDepartement == null || idDepartement.equals("")){
        idDepartement = "";
    } else {
      pi.getFormu().getChamp("idDepartement").setDefaut(idDepartement);
    }
    pi.getFormu().getChamp("idEntite").setLibelle("Entit&eacute;");
    pi.getFormu().getChamp("idMachine").setLibelle("&Eacute;l&eacute;ment");
    pi.getFormu().getChamp("demandeur").setPageAppelCompleteAWhere("maintenance.ressources.PersonnelMaintenance","id","PERSONNEL","","","");

    pi.getFormu().getChamp("idSituation").setLibelle("Situation");
//    pi.getFormu().getChamp("iddepartement").setAutre("onchange='demandeurDependante(this.value)'");
    pi.getFormu().getChamp("idMachine").setPageAppelComplete("maintenance.ressources.IngredientMaintenanceLib","id","AS_INGREDIENT_MAINTENANCE_LIB","","");
    pi.getFormu().getChamp("idSituation").setLibelle("Situation");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("dateBesoin").setLibelle("Date de besoin");
    pi.getFormu().getChamp("priorite").setLibelle("Priorit&eacute;");
    pi.getFormu().getChamp("estExistant").setLibelle(" Probl&egrave;me d&eacute;ja rencontr&eacute;");
    pi.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement de demande");
    pi.getFormu().getChamp("idDepartementMaintenance").setLibelle("D&eacute;partement de maintenance");
    pi.getFormu().getChamp("description").setType("textarea");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("cause").setVisible(false);
    pi.getFormu().getChamp("type").setVisible(false);
    pi.getFormu().getChamp("idPlanning").setVisible(false);

    pi.getFormu().setOrdre(new String[]{"id","daty","dateBesoin","entite","idDepartement"});
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
  <h1> <%=titre%></h1>

  <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
    <%
      pi.getFormu().makeHtmlInsertTabIndex();
      out.println(pi.getFormu().getHtmlInsert());
      out.println(pi.getHtmlAddOnPopup());
    %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="<%=apres%>">
    <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
    <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
  </form>
</div>
<script>
  function demandeurDependante(value) {
    const url = new URL(window.location.href);
    url.searchParams.set("idDepartement", value);
    window.location.href = url.toString();
  }
</script>
<%
} catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>
