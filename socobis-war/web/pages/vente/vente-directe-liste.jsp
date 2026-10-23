<%@page import="vente.VenteLib"%>
<%@page import="vente.Vente"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="vente.Vente" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="utils.ConstanteSavonnerie" %>

<% try{
    VenteLib bc = new VenteLib();
    bc.setNomTable("VENTE_CPL");

    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));





    if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("") != 0) {
        bc.setNomTable(request.getParameter("devise"));
    } else {
        bc.setNomTable("VENTE_CPL");
    }
    String[] listeCrt = {"id", "designation","idClientLib","commerciallib","daty","datyprevu", "provincelib", "modelivraison","idMagasin","referencefacture"};
    String[] listeInt = {"daty","datyprevu"};
    String[] libEntete = {"id", "daty","designation","idClientLib","commerciallib","idDevise","referencefacture","numerofacture","montantttc","montantpaye", "montantreste", "provincelib","idMagasinLib","etatlib","modelivraisonlib"};
    String[] libEnteteAffiche = {"id", "Date", "D&eacute;signation","Client","Commercial","devise","R&eacute;f&eacute;rence de la facture","Num&eacute;ro de la facture","Montant TTC","Montant Pay&eacute;","Montant restant", "Province","Magasin","&Eacute;tat", "Mode de livraison"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setAWhere(" and IDMAGASIN='" + ConstanteSavonnerie.MAGASIN_APPRO+"'");

    pr.setTitre("Liste des Ventes Chapiteau");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/vente-directe-liste.jsp");
    String[] colSomme = { "montantttc", "montantpaye", "montantreste" };
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");
    pr.getFormu().getChamp("commerciallib").setLibelle("Commercial");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("referencefacture").setLibelle("R&eacute;f&eacute;rence de la facture");
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));
    pr.getFormu().getChamp("modelivraison").setLibelle("Mode de livraison");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("datyprevu1").setLibelle("&Eacute;ch&eacute;ance Min");
    pr.getFormu().getChamp("datyprevu2").setLibelle("&Eacute;ch&eacute;ance Max");


    TypeObjet prov = new TypeObjet();
    prov.setNomTable("province");

    Liste[] liste = new Liste[3];
    liste[0] = new Liste("provincelib",prov,"val","val");
    liste[0].setLibelle("Province");

    Liste listemode = new Liste("modelivraison");

    String [] affVal = new String[2];
    String [] aff = new String[2];
    aff = new String[]{"Tous", "LIVRAISON","RECUPERATION"};
    affVal = new String[]{"%", "1","2"};

    listemode.ajouterValeur(affVal,aff);
    liste[1] = listemode;

    Magasin m = new Magasin();
    m.setNomTable("MAGASINVENTE");
    liste[2] = new Liste("idMagasin",m,"val","id");
    liste[2].setLibelle("Magasin");

    //pr.getFormu().getChamp("provincelib").setLibelle("Province");
    pr.getFormu().changerEnChamp(liste);
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=vente/vente-modif.jsp");
    lienTab.put("Valider",pr.getLien() + "?&classe=vente.Vente&but=apresTarif.jsp&bute=vente/vente-fiche.jsp&acte=valider"+pr.getFormu().getChamp("id").getValeur()+"");
    lienTab.put("Livrer",pr.getLien() + "?but=bondelivraison-client/apresLivraisonFacture.jsp&bute=vente/encaissement-modif.jsp" + pr.getFormu().getChamp("id").getValeur()+"");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String[] lienTableau = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] enteteRecap = {"","Somme des nombres","Somme des montants TTC","Somme des montants pay&eacute;s","Somme des montants restants"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("vente/inc/vente-details.jsp&id=");
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

        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>

        <%
            out.println(pr.getTableau().getHtml());
        %>
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
        // var idModePaiementValue = document.getElementById("idmodepaiement").value;

        var exportUrl = "${pageContext.request.contextPath}/ExportPDF?action=reporting_journalier"
            + "&daty1=" + encodeURIComponent(daty1Value)
            + "&daty2=" + encodeURIComponent(daty2Value)
            + "&id=" + encodeURIComponent(idValue)
            + "&designation=" + encodeURIComponent(designationValue)
            + "&idClientLib=" + encodeURIComponent(idClientLibValue);
            // + "&idmodepaiement=" + encodeURIComponent(idModePaiementValue);


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




