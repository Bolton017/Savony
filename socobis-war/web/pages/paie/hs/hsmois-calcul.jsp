<%@page import="annexe.TypeProduit"%>
<%@page import="annexe.Categorie"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="paie.hs.HsMois" %>
<%@ page import="affichage.Champ" %>
<%@ page import="utilitaire.Utilitaire" %>

<%
    try{
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "paie.hs.HsMois",
                nomtable = "HSMOIS",
                apres = "paie/hs/hsmois-fiche.jsp",
                titre = "Calcul Heure suppl&eacute;mentaire du mois";

        HsMois hsMois = new HsMois();
        hsMois.setNomTable("HsMois");

        PageInsert pi = new PageInsert(hsMois, request, u);

        pi.setLien((String) session.getValue("lien"));

        affichage.Champ[] liste = new Champ[3];
        Liste mois = new Liste("mois");
        mois.makeListeMois();
        liste[0] = mois;
        TypeObjet m1 = new TypeObjet();
        m1.setNomTable("departement");
        liste[1] = new Liste("idDepartement", m1, "val", "id");
        TypeObjet m2 = new TypeObjet();
        m2.setNomTable("CATEGORIE_PAIE");
        liste[2] = new Liste("idCategorie", m2, "val", "id");
        pi.getFormu().changerEnChamp(liste);
        int currentYear = utilitaire.Utilitaire.getAneeEnCours();
        pi.getFormu().getChamp("mois").setLibelle("Mois");
        pi.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement");
        pi.getFormu().getChamp("idCategorie").setLibelle("Cat&eacute;gorie");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
        pi.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());
        pi.getFormu().getChamp("etat").setVisible(false);

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


<script>
    document.getElementsByName("Submit2")[0].textContent = "Calculer";
</script>

<%
} catch (Exception e) {
    e.printStackTrace();
%>

<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>

<% } %>