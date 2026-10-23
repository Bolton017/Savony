<%@page import="annexe.Categorie"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="produits.CategorieIngredient" %>
<%@ page import="rapprochement.Relever" %>
<%@ page import="caisse.Caisse" %>
<%@ page import="utilitaire.Utilitaire" %>

<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "",
                nomtable = "Relever",
                apres = "rapprochement/liste-relever.jsp",
                titre = "Importation de relever";

        Relever categorie = new Relever ();
        categorie.setNomTable("Relever");
        PageInsert pi = new PageInsert(categorie, request, u);
        pi.setLien((String) session.getValue("lien"));
        affichage.Champ[] liste = new affichage.Champ[1];
        Caisse c = new Caisse();
        liste[0] = new Liste("idCaisse",c,"val","id");
        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("idCaisse").setLibelle("Caisse");
        pi.getFormu().getChamp("etat").setLibelle("Fichier (.csv)");
        pi.getFormu().getChamp("etat").setType("file");
        pi.getFormu().getChamp("etat").setAutre("accept=\".csv\" required");
        pi.preparerDataFormu();
%>
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=request.getContextPath()%>/uploadCSV" method="post" name="<%=nomtable%>" id="<%=nomtable%>" enctype="multipart/form-data">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
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
