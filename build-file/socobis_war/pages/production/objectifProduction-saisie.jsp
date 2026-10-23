<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="production.ObjectifProduction" %>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "production.ObjectifProduction";
    String nomTable = "objectifproduction";
    String apres = "production/objectifProduction-fiche.jsp";
    String idCritereProduit = request.getParameter("id");
    ObjectifProduction o = new ObjectifProduction();
    o.setNomTable("objectifproduction");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie objectif du production");
    
    pi.getFormu().getChamp("idProduit").setLibelle("Produit");
    pi.getFormu().getChamp("idProduit").setPageAppelComplete("produits.Ingredients","id","AS_INGREDIENTS","id","libelle");
    Liste[] liste = new Liste[1];
    TypeObjet unite = new TypeObjet();
    unite.setNomTable("as_unite");
    liste[0] = new Liste("unite", unite, "val", "id");
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
    pi.getFormu().getChamp("qte").setLibelle("Quantit&eacute;");
 
    //String[] ordre = {"idcritere","idTypeProduit"};
    //pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification objectif du production");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

