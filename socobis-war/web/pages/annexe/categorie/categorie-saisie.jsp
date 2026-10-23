

<%@page import="annexe.TypeProduit"%>
<%-- 
    Document   : produit-fiche
    Created on : 21 mars 2024, 09:44:57
    Author     : Angela
--%>

<%@page import="annexe.Categorie"%>
<%@page import="affichage.PageInsert"%> 
<%@page import="user.UserEJB"%> 
<%@page import="bean.TypeObjet"%> 
<%@page import="affichage.Liste"%>
<%@ page import="produits.CategorieIngredient" %>

<%
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "produits.CategorieIngredient",
            nomtable = "CATEGORIEINGREDIENT",
            apres = "annexe/categorie/categorie-fiche.jsp",
            titre = "Insertion d'une cat&eacute;gorie de produit";
    
    CategorieIngredient categorie = new CategorieIngredient();
    categorie.setNomTable("CATEGORIEINGREDIENT");
    PageInsert pi = new PageInsert(categorie, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.getFormu().getChamp("val").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("desce").setLibelle("Description");
    pi.getFormu().getChamp("iddepartement").setLibelle("D&eacute;partement");
    pi.getFormu().getChamp("iddepartement").setPageAppelComplete("bean.TypeObjet", "id", "departement");
    pi.preparerDataFormu();
            if(request.getParameter("acte")!=null){
            titre = "Modification d'une cat&eacute;gorie de produit";
        }
%>
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