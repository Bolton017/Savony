<%@page import="vente.VenteLib"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<% try{
    VenteLib bc = new VenteLib();
    bc.setNomTable("VENTE_CPL");

    LocalDate today = LocalDate.now();
    if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("") != 0) {
        bc.setNomTable(request.getParameter("devise"));
    } else {
        bc.setNomTable("VENTE_CPL");
    }
    String[] listeCrt = {"id", "designation","idClientLib","referencefacture","daty","datyprevu","montantttc","montantpaye","montantreste"};
    String[] listeInt = {"daty","datyprevu","montantttc","montantpaye","montantreste"};
    String[] libEntete = {"id", "designation","idClientLib","idDevise","referencefacture","daty","montantttc","montantpaye", "montantreste","etatlib","datyprevu"};
    String[] libEnteteAffiche = {"id", "D&eacute;signation","Client","devise","R&eacute;f&eacute;rence de la facture","Date","Montant TTC","Montant Pay&eacute;","Montant restant","&Eacute;tat","&Eacute;ch&eacute;ance"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setAWhere(" and etat=11 and montantreste>0");

    pr.setTitre("Liste des ventes avec reste &agrave; payer");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/vente-apayer-liste.jsp");
    String[] colSomme = { "montantttc", "montantpaye", "montantreste","margeBrute" };
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("referencefacture").setLibelle("R&eacute;f&eacute;rence de la facture");
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("montantttc1").setLibelle("Montant TTC Min");
    pr.getFormu().getChamp("montantttc2").setLibelle("Montant TTC Max");
    pr.getFormu().getChamp("montantpaye1").setLibelle("Montant pay&eacute; Min");
    pr.getFormu().getChamp("montantpaye2").setLibelle("Montant pay&eacute; Max");
    pr.getFormu().getChamp("montantreste1").setLibelle("Montant Restant Min");
    pr.getFormu().getChamp("montantreste2").setLibelle("Montant Restant Max");
    pr.creerObjetPage(libEntete, colSomme);


    pr.getFormu().getChamp("datyprevu1").setLibelle("&Eacute;ch&eacute;ance Min");
    pr.getFormu().getChamp("datyprevu2").setLibelle("&Eacute;ch&eacute;ance Max");
    pr.getFormu().getChamp("datyprevu1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("datyprevu2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    //Definition des lienTableau et des colonnes de lien
    String[] lienTableau = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] enteteRecap = {"","Somme des nombres","Somme des montants TTC","Somme des montants pay&eacute;s","Somme des montants restants","Somme des marges brutes"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("vente/inc/vente-details.jsp&id=");
    pr.getFormu().setAnotherButton(
            "                <a id='export-btn-details' class='btn btn-secondary  btn-bg-white btn-small' href='#' onclick='exportPDFAvecDetails()'>\n" +
            "                    <i class='material-symbols-rounded'>download</i> Exporter en pdf avec d&eacute;tails\n" +
            "                </a>\n" +
            "                <a id='export-btn-excel' class='btn btn-secondary  btn-small btn-bg-white' href='#' onclick='exportExcel()'>\n" +
            "                    <i class='material-symbols-rounded'>download</i> Exporter en excel\n" +
            "                </a>\n" +
            "                <a id='export-btn' class='btn btn-secondary  btn-small btn-bg-white' href='#' onclick='exportPDF()'>\n" +
            "                    <i class='material-symbols-rounded'>download</i> Exporter en pdf\n" +
            "                </a>\n" +
            "                <a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=facture/traite-saisie.jsp&currentMenu=MEN000690\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir une vente\n" +
            "                </a>"
        );
%>
<script>
    function changerDesignation() {
        document.vente.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="vente" id="vente">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 nopadding">
                    <div class="col-md-2 nopadding">
                        Devise :
                        <select name="devise" class="champ form-control" id="devise" onchange="changerDesignation()" >
                            <% if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("vente_cpl_avec_montant") == 0) {%>
                            <option value="vente_cpl" selected>Tous</option>
                            <% } else { %>
                            <option value="vente_cpl">Tous</option>
                            <% } %>
                            <% if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("vente_cpl_avec_montant_mga") == 0) {%>
                            <option value="VENTE_CPL_mga" selected>AR</option>
                            <% } else { %>
                            <option value="VENTE_CPL_mga">AR</option>
                            <% } %>
                            <% if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("vente_cpl_avec_montant_eur") == 0) {%>
                            <option value="VENTE_CPL_eur" selected>EUR</option>
                            <% } else { %>
                            <option value="VENTE_CPL_eur">EUR</option>
                            <% } %>
                            <% if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("vente_cpl_avec_montant_usd") == 0) {%>
                            <option value="VENTE_CPL_usd" selected>USD</option>
                            <% } else { %>
                            <option value="VENTE_CPL_usd">USD</option>
                            <% } %>
                        </select>
                    </div>
                
                </br>
            </div>

        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <form action="<%=pr.getLien()%>?but=vente/paiement-facture-par-traite.jsp" method="post" name="vente" id="vente">
            <input type="hidden" value="<%=pr.getLien()%>" name="lien">
            <%
                out.println(pr.getTableau().getHtmlWithCheckbox());
            %>
        </form>
        <div class="row justify-content-center d-none">
            <div class="col-md-12 d-flex justify-content-right">
                <div class="box box-primary">
                    <div class="box-body text-center">
                        <a id="export-btn" class="btn btn-warning pull-right" href="#">
                            Exporter en pdf <i class="fa fa-download"></i>
                        </a>
                        <a style="margin-right:10px" id="export-btn-excel" class="btn btn-success pull-right" href="#">
                            Exporter en excel <i class="fa fa-download"></i>
                        </a>
                        <a id="export-btn-details" class="btn btn-warning pull-left" href="#">
                            Exporter en pdf avec d&eacute;tails <i class="fa fa-download"></i>
                        </a>

                    </div>
                </div>
            </div>
        </div>
        <%
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<script>
    function exportPDF() {
        // Récupération des champs
        var daty1Value = document.getElementById("daty1").value;
        var daty2Value = document.getElementById("daty2").value;
        var idValue = document.getElementById("id").value;
        var designationValue = document.getElementById("designation").value;
        var idClientLibValue = document.getElementById("idClientLib").value;

        var exportUrl = "${pageContext.request.contextPath}/ExportPDF?action=vente_liste"
            + "&daty1=" + encodeURIComponent(daty1Value)
            + "&daty2=" + encodeURIComponent(daty2Value)
            + "&id=" + encodeURIComponent(idValue)
            + "&designation=" + encodeURIComponent(designationValue)
            + "&idClientLib=" + encodeURIComponent(idClientLibValue)


        var exportButton = document.getElementById("export-btn");
        exportButton.href = exportUrl;
    }
    function exportPDFAvecDetails() {
        // Récupération des champs
        var daty1Value = document.getElementById("daty1").value;
        var daty2Value = document.getElementById("daty2").value;
        var idValue = document.getElementById("id").value;
        var designationValue = document.getElementById("designation").value;
        var idClientLibValue = document.getElementById("idClientLib").value;


        var exportUrl = "${pageContext.request.contextPath}/ExportPDF?action=vente_liste_mere_fille"
            + "&daty1=" + encodeURIComponent(daty1Value)
            + "&daty2=" + encodeURIComponent(daty2Value)
            + "&id=" + encodeURIComponent(idValue)
            + "&designation=" + encodeURIComponent(designationValue)
            + "&idClientLib=" + encodeURIComponent(idClientLibValue)


        var exportButton = document.getElementById("export-btn-details");
        exportButton.href = exportUrl;
    }
    function exportExcel() {
        // Récupération des champs
        var daty1Value = document.getElementById("daty1").value;
        var daty2Value = document.getElementById("daty2").value;
        var idValue = document.getElementById("id").value;
        var designationValue = document.getElementById("designation").value;
        var idClientLibValue = document.getElementById("idClientLib").value;

        var exportUrl = "${pageContext.request.contextPath}/ExportExcel?action=vente_liste"
            + "&daty1=" + encodeURIComponent(daty1Value)
            + "&daty2=" + encodeURIComponent(daty2Value)
            + "&id=" + encodeURIComponent(idValue)
            + "&designation=" + encodeURIComponent(designationValue)
            + "&idClientLib=" + encodeURIComponent(idClientLibValue)


        var exportButton = document.getElementById("export-btn-excel");
        exportButton.href = exportUrl;
    }
    function exportReportingJournalier() {
        // Récupération des champs
        var daty1Value = document.getElementById("daty1").value;
        var daty2Value = document.getElementById("daty2").value;
        var idValue = document.getElementById("id").value;
        var designationValue = document.getElementById("designation").value;
        var idClientLibValue = document.getElementById("idClientLib").value;
        var idModePaiementValue = document.getElementById("idmodepaiement").value;

        var exportUrl = "${pageContext.request.contextPath}/ExportPDF?action=reporting_journalier"
            + "&daty1=" + encodeURIComponent(daty1Value)
            + "&daty2=" + encodeURIComponent(daty2Value)
            + "&id=" + encodeURIComponent(idValue)
            + "&designation=" + encodeURIComponent(designationValue)
            + "&idClientLib=" + encodeURIComponent(idClientLibValue)
            + "&idmodepaiement=" + encodeURIComponent(idModePaiementValue);


        var exportButton = document.getElementById("reporting-journalier");
        exportButton.href = exportUrl;
    }

    document.getElementById("export-btn").addEventListener("click", exportPDF);
    document.getElementById("export-btn-details").addEventListener("click", exportPDFAvecDetails);
    document.getElementById("export-btn-excel").addEventListener("click", exportExcel);
    document.getElementById("reporting-journalier").addEventListener("click", exportReportingJournalier);
</script>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>




