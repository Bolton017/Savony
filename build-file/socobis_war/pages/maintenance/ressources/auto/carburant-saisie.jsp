<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.Liste"%>
<%@ page import="maintenance.planning.DemandeTravaux" %>
<%@ page import="maintenance.configuration.Entite" %>
<%@ page import="maintenance.configuration.Situation" %>
<%@ page import="maintenance.ressources.Autocarburant" %>
<%@ page import="bean.TypeObjet" %>

<%
  try{
    String idAuto = request.getParameter("id");
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "maintenance.ressources.Autocarburant",
            nomtable = "AUTOCARBURANT",
            apres = "maintenance/ressources/auto/auto-fiche.jsp&id="+idAuto,
            titre = "Saisie carburant";
    Autocarburant categorie = new Autocarburant();
    PageInsert pi = new PageInsert(categorie, request, u);
    pi.setLien((String) session.getValue("lien"));
    Liste[] liste = new Liste[1];
    TypeObjet auto = new TypeObjet();
    auto.setNomTable("autoMaintenance");
    liste[0] = new Liste("idAuto",auto,"val","id");
    //pi.getFormu().changerEnChamp(liste);
    
    if (idAuto != null && !idAuto.trim().isEmpty()) {
        pi.getFormu().getChamp("idAuto").setDefaut(idAuto);
    } 
    
    pi.getFormu().getChamp("idAuto").setVisible(false);
    pi.getFormu().getChamp("montant").setLibelle("Montant");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("odometre").setLibelle("Odom&egrave;tre");
    pi.getFormu().getChamp("volume").setLibelle("volume en (Litres)");

    //pi.getFormu().setOrdre(new String[]{"daty","dateBesoin","entite","idDepartement"});
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

<%
} catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>
