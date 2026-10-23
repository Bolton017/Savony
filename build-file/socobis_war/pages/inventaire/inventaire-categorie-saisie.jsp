<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="inventaire.Inventaire" %>
<%@ page import="affichage.Liste" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="bean.TypeObjet" %>

<%
    try{
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "inventaire.Inventaire",
                nomtable = "inventaire",
                apres = "inventaire/inventaire-categorie-saisie2.jsp",
                titre = "Insertion par cat&eacute;gorie";

        Inventaire inventaire = new Inventaire();
        PageInsert pi = new PageInsert(inventaire, request, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("daty").setLibelle("Date de l'inventaire");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("etat").setVisible(false);

        Liste[] liste = new Liste[2];
        Magasin m = new Magasin();
        m.setNomTable("magasinpoint");
        liste[0] = new Liste("idMagasin", m, "val", "id");

        TypeObjet to = new TypeObjet();
        to.setNomTable("categorieingredient");
        liste[1] = new Liste("idCategorie", to, "val", "id");

        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pi.getFormu().getChamp("idCategorie").setLibelle("Cat&eacute;gorie");

        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
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