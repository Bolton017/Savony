<%--
    Created by IntelliJ IDEA.
  User: DIVA
  Date: 01/12/2025
  Time: 22:28
  To change this template use File | Settings | File Templates.
--%>

<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="maintenance.configuration.Entite" %>
<%@ page import="maintenance.ressources.IngredientMaintenance" %>
<%@ page import="utils.ConstanteLewis" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="maintenance.configuration.AttributionElement" %>

<%
  try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "maintenance.configuration.AttributionElement",
            nomtable = "attributionElement",
            apres = "maintenance/ressources/outils/attribution/attribution-fiche.jsp",
            titre = "Saisie d'une attribution d'&eacute;l&eacute;ment";
    if (request.getParameter("acte")!=null && request.getParameter("acte").equals("update")){
      titre = "Modification d'une attribution d'&eacute;l&eacute;ment";
    }
    AttributionElement outils = new AttributionElement();
    PageInsert pi = new PageInsert(outils, request, u);
    pi.setLien((String) session.getValue("lien"));

    Liste[] liste = new Liste[2];

    TypeObjet qlt = new TypeObjet();
    qlt.setNomTable("QUALITESOBJETMAINTENANCE");
    liste[0] = new Liste("etatElement", qlt, "val", "id");

    String [] val = new String[]{"0","1"};
    String [] aff = new String[]{"Sortie","Retour"};
    liste[1] = new Liste("typeAttribution",aff,val);

    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("idIngredientMaintenance").setLibelle("&Eacute;l&eacute;ment");
    pi.getFormu().getChamp("idIngredientMaintenance").setPageAppelComplete("maintenance.ressources.IngredientMaintenance","id","AS_INGREDIENT_MAINTENANCE");
    pi.getFormu().getChamp("idPersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("idPersonnel").setPageAppelComplete("maintenance.ressources.PersonnelMaintenance","id","PERSONNEL");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("etatElement").setLibelle("Etat de l'&eacute;l&eacute;ment");
    pi.getFormu().getChamp("typeAttribution").setLibelle("Mouvement");
    pi.getFormu().getChamp("qte").setLibelle("Quantit&eacute;");
    pi.getFormu().getChamp("qte").setDefaut("1");
    pi.getFormu().getChamp("etat").setVisible(false);


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
