<%-- 
    Document   : as-tarifproduits-modif
    Created on : 2 oct. 2019, 10:13:38
    Author     : Notiavina
--%>

<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="mg.allosakafo.produits.TarifProduits"%>

<%
    TarifProduits a = new TarifProduits();
    //a.setNomTable("as_prixproduit_libelle");
    
    PageUpdate pi = new PageUpdate(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));
    UserEJB u = (UserEJB) session.getAttribute("u");
    
    pi.getFormu().getChamp("produit").setAutre("readonly");
    
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1 class="box-title">Modification tarif produits</h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="appro" id="appro">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="acte" value="update">
        <input name="bute" type="hidden" id="bute" value="produits/as-tarifproduits-fiche.jsp">
        <input name="classe" type="hidden" id="classe" value="mg.allosakafo.produits.TarifProduits">
    </form>
</div>