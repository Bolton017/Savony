<%@page import="annexe.Categorie"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="produits.CategorieIngredient" %>
<%@ page import="rapprochement.Relever" %>
<%@ page import="caisse.Caisse" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="affichage.Onglet" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "",
                nomtable = "Relever",
                apres = "rapprochement/fiche-relever.jsp",
                titre = "Importation d'un relev&eacute;";

        Relever categorie = new Relever ();
        categorie.setNomTable("Relever");
        PageInsert pi = new PageInsert(categorie, request, u);
        pi.setLien((String) session.getValue("lien"));
        affichage.Champ[] liste = new affichage.Champ[1];
        Caisse c = new Caisse();
        c.setNomTable("CAISSEBANQUE");
        liste[0] = new Liste("idCaisse",c,"val","id");
        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("idCaisse").setLibelle("Banque");
        pi.getFormu().getChamp("etat").setLibelle("Fichier (.csv)");
        pi.getFormu().getChamp("etat").setType("file");
        pi.getFormu().getChamp("etat").setAutre("accept=\".csv\" required");
        pi.getFormu().getChamp("datyDebut").setVisible(false);
        pi.getFormu().getChamp("datyFin").setVisible(false);
        pi.preparerDataFormu();

         String lien = (String) session.getValue("lien");
         String pageActuel = "rapprochement/import-relever.jsp";

        Onglet onglet = new Onglet("page1");
        onglet.setDossier("inc");
        Map<String, String> map = new HashMap<String, String>();
        map.put("relever-non-declarer", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "relever-non-declarer";
        }
        map.put(tab, "active");
        tab = "inc/" + tab + ".jsp"; 
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=request.getContextPath()%>/uploadCSV" method="post" name="<%=nomtable%>" id="<%=nomtable%>" enctype="multipart/form-data">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="retour" type="hidden" id="retour" value="rapprochement/import-relever.jsp">
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
    <script type="text/javascript">
        $(function () {
            $('#<%=nomtable%> .box-footer').append(
                "<a href='<%=request.getContextPath()%>/assets/fichier/modele_releve_exporte.csv' download='modele_releve_exporte.csv' class='btn btn-success pull-right' style='margin-right: 15px;margin-top: 0rem;'>Exporter le mod&egrave;le</a>"
            );
        });
    </script>
    <br>

    <div class="row">
        <div class="col-md-12" style="margin-top: 20px;">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="<%=map.get("relever-non-declarer")%>"><a href="<%= lien%>?but=<%= pageActuel%>&tab=relever-non-declarer">Liste des relev&eacute;s non rapproch&eacute;s</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>">
                        <jsp:param name="tab" value="<%= tab %>" />
                    </jsp:include>
                </div>
            </div>
        </div>
    </div>
</div>


<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>
<% }%>


<%
    String erreur = (String) session.getAttribute("erreur");
    if (erreur != null) {
        session.removeAttribute("erreur");
%>
<script type="text/javascript">
    alert('<%= erreur.replace("'", "\\'") %>');
</script>
<%
    }
%>
