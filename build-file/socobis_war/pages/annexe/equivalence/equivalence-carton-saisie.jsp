

<%@page import="annexe.*"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>

<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "annexe.EquivalenceCarton",
                nomtable = "equivalencecarton",
                apres = "annexe/equivalence/equivalence-carton-fiche.jsp",
                titre = "Cr&eacute;ation d'une &eacute;quivalence en carton";

        String id = request.getParameter("id");
        if(id!= null && !id.isEmpty()){
            titre = "Modification d'une &eacute;quivalence en carton";
        }
        EquivalenceCarton crt = new EquivalenceCarton();
        crt.setNomTable(nomtable);
        PageInsert pi = new PageInsert(crt, request, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("nbcarton").setLibelle("Nombre de Carton");
        pi.getFormu().getChamp("idCarton").setLibelle("ID Carton");
        pi.getFormu().getChamp("idPetris").setLibelle("ID P&eacute;tris");
        pi.getFormu().getChamp("idCarton").setPageAppelComplete("produits.Ingredients","id","as_ingredients","id","idCarton");
        pi.getFormu().getChamp("idPetris").setPageAppelComplete("produits.Ingredients","id","as_ingredients","id","idPetris");
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
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>