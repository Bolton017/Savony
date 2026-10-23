<%-- 
    Document   : ecriture-liste
    Created on : 19-Sep-2024, 17:31:54
    Author     : Kanto
--%>

<%@page import="mg.cnaps.compta.ecriture.ComptaEcritureLib"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="java.sql.Date" %>
<%@ page import="affichage.Liste" %>
<%@ page import="mg.cnaps.compta.JournalCompte" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
    String etat = request.getParameter("etat");
    if(etat == null || etat.isEmpty()) etat = "";

    String type = request.getParameter("type");
    if (type == null || type.trim().isEmpty()) {
        type = "COMPTA_ECRITURE_LIB";
    }
    switch (type.toUpperCase()) {
        case "COMPTA_ECRITURE_LIB":
        case "COMPTA_ECRITURE_LIB_VENTE":
        case "COMPTA_ECRITURE_LIB_STOCK":
        case "COMPTA_ECRITURE_LIB_AVOIRFC":
        case "COMPTA_ECRITURE_LIB_ACHAT":
        case "COMPTA_ECRITURE_LIB_MANUELLE":
        case "COMPTA_ECRITURE_LIB_MVTCAISSE":
            type = type.toUpperCase();
            break;

        default:
            type = "COMPTA_ECRITURE_LIB";
            break;
    }


//    LocalDate today = LocalDate.now();
//    LocalDate monday = today.with(previousOrSame(MONDAY));
//    LocalDate sunday = today.with(nextOrSame(SUNDAY));
    ComptaEcritureLib c = new ComptaEcritureLib();
    c.setNomTable(type);
    String listeCrt[] = {"id","daty","tierslib","piece","reference","idObjet","designation","journalcode","montant"};
    String listeInt[] = {"daty","montant"};
    String libEntete[] = {"id","daty","tierslib","designation", "piece","reference","idObjet","source","montant","journallib","etatlib"};
    PageRecherche pr = new PageRecherche(c, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des &eacute;critures");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("compta/ecriture/ecriture-liste.jsp");

    Liste [] listes = new Liste[1];
    JournalCompte j = new JournalCompte();
    j.setNomTable("COMPTA_JOURNAL_VIEW");
    listes[0] = new Liste("journalcode",j,"desce","val");
    pr.getFormu().changerEnChamp(listes);

    pr.getFormu().getChamp("id").setLibelle("Ref.");
    pr.getFormu().getChamp("montant1").setLibelle("Montant min");
    pr.getFormu().getChamp("montant2").setLibelle("Montant max");
    pr.getFormu().getChamp("idObjet").setLibelle("Ref. source");
    pr.getFormu().getChamp("journalcode").setLibelle("Journal");
    pr.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
     pr.getFormu().getChamp("tierslib").setLibelle("Tiers");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("piece").setLibelle("Num&eacute;ro de la facture");
    pr.getFormu().getChamp("designation").setLibelle("Libell&eacute;");
    if(!etat.isEmpty()){
        pr.setAWhere(" and etat = '"+ etat +"'");
    }
    boolean etatCree = "1".equalsIgnoreCase(etat);
    String[] colSomme = null;
    pr.setNpp(20);
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien

    String origineLien =  pr.getLien() + "?but=compta/ecriture/apresOrigine.jsp";

    String lienTableau[] = {pr.getLien() + "?but=compta/ecriture/ecriture-fiche.jsp", origineLien};
    String colonneLien[] = {"id","idObjet"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(new String[]{"id","id"});
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Ref.", "Date", "Tiers", "Libell&eacute;", "Num&eacute;ro de la facture","R&eacute;f&eacute;rence", "Ref. source", "Source", "Montant", "Journal", "&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("compta/ecriture/inc/sous-ecriture-detail.jsp&id=");
    String[] etatAffiche = { "Tous","Cr&eacute;(e)", "Valid&eacute;(e)" };
    String[] etatPasse = { "","1","11" };
    String formAction = pr.getLien() + "?but=apresValiderCompta.jsp";

    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=compta/ecriture/saisie-ecriture-multiple.jsp&currentMenu=MNDSN286\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'une &eacute;criture comptable</a>"
    );

    String[] idAttributsLienTab = {"daty1"};
    String[] valAttributsLienTab = {pr.getFormu().getChamp("daty1").getValeur()};

    Map<String,String> lienTab=new HashMap();
    lienTab.put("viser", pr.getLien() +"?but=apresTarif.jsp&acte=valider&bute=compta/ecriture/ecriture-liste.jsp&classe=mg.cnaps.compta.ComptaEcriture&rajoutLien="+ Utilitaire.ajouterParam(idAttributsLienTab, valAttributsLienTab));
    lienTab.put("modifier",pr.getLien() + "?but=compta/ecriture/saisie-ecriture-multiple.jsp&acte=update");
    lienTab.put("dupliquer", pr.getLien() + "?but=compta/ecriture/saisie-ecriture-multiple.jsp&acte=dupliquer");
    pr.getTableau().setLienClicDroite(lienTab);

    pr.setApjSplitEnabled(false);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">

        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="formRecherche" id="formRecherche">

            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>

            <div class="row col-md-12 nopadding" style="margin-top: 12px">
                <div class="row">
                    <!-- Champ État -->
                    <div class="col-md-2 nopadding">
                        <label class="input-label" for="etat">&Eacute;tat :</label>
                        <select name="etat" class="champ form-control" id="etat" onchange="changerEtat()">
                            <% for (int i = 0; i < etatAffiche.length; i++) {
                                String selected = (etat != null && etat.equals(etatPasse[i])) ? "selected" : "";
                            %>
                            <option value="<%= etatPasse[i] %>" <%= selected %>><%= etatAffiche[i] %></option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Champ Origine -->
                    <div class="col-md-2 nopadding">
                        <label class="input-label" for="type">Source :</label>
                        <select name="type" class="champ form-control" id="type" onchange="changerDesignation()">
                            <%
                                String currentType = request.getParameter("type");
                                String[] values = {
                                        "COMPTA_ECRITURE_LIB",
                                        "COMPTA_ECRITURE_LIB_VENTE",
                                        "COMPTA_ECRITURE_LIB_STOCK",
                                        "COMPTA_ECRITURE_LIB_AVOIRFC",
                                        "COMPTA_ECRITURE_LIB_ACHAT",
                                        "COMPTA_ECRITURE_LIB_MANUELLE",
                                        "COMPTA_ECRITURE_LIB_MVTCAISSE"
                                };
                                String[] labels = {"Tous", "Vente", "Stock", "Avoir", "Achat", "Manuelle","Tr&eacute;sorerie"};

                                for (int i = 0; i < values.length; i++) {
                                    String selected = (currentType != null && currentType.equalsIgnoreCase(values[i])) ? "selected" : "";
                            %>
                            <option value="<%= values[i] %>" <%= selected %>><%= labels[i] %></option>
                            <% } %>
                        </select>
                    </div>
                </div>
            </div>

        </form>
        <form action="<%= formAction %>" method="post" name="ecriture" id="ecriture">

            <input type="hidden" name="bute" value="compta/ecriture/ecriture-liste.jsp">

            <%
                out.println(pr.getTableauRecap().getHtml());
            %>
            <br>

            <div id="sousTotal" style="margin-bottom: 15px; padding: 10px; border-radius: 4px; font-weight: bold;">
                Sous-total: <span id="totalMontant">0.00</span>
            </div>
            <br>

            <%
                if(etatCree){
                    pr.getTableau().setNameBoutton("Valider");
                    out.println(pr.getTableau().getHtmlWithCheckbox());
                } else {
                    out.println(pr.getTableau().getHtml());
                }

                out.println(pr.getBasPage());
            %>

        </form>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>

<script>
        function changerDesignation() {
        document.formRecherche.submit();
    }
    function changerEtat(){
        document.formRecherche.submit();
    }

    function lireMontant(texte) {
        var t = texte.replace(/[\s\u00a0]/g, '');
        if (t.indexOf(',') >= 0 && t.indexOf('.') < 0) {
            t = t.replace(',', '.');
        } else {
            t = t.replace(/,/g, '');
        }
        var m = parseFloat(t.replace(/[^0-9.-]/g, ''));
        return isNaN(m) ? 0 : m;
    }

    function calculerSousTotal() {
        var totalMontant = 0;
        var tables = document.querySelectorAll('#ecriture table');
        tables.forEach(function(table) {
            var rows = table.querySelectorAll('tr');
            var idxMontant = -1;
            rows.forEach(function(row) {
                var entetes = row.querySelectorAll('th');
                if (idxMontant < 0 && entetes.length > 0) {
                    var cellsEntete = row.querySelectorAll('th, td');
                    for (var i = 0; i < cellsEntete.length; i++) {
                        if (cellsEntete[i].textContent.trim().toLowerCase().indexOf('montant') === 0) {
                            idxMontant = i;
                            break;
                        }
                    }
                    return;
                }
                if (idxMontant < 0) return;
                var cells = row.querySelectorAll('th, td');
                if (cells.length <= idxMontant) return;
                var checkbox = row.querySelector('input[type="checkbox"]');
                if (checkbox && !checkbox.checked) return;
                totalMontant += lireMontant(cells[idxMontant].textContent);
            });
        });
        document.getElementById('totalMontant').textContent = totalMontant.toFixed(2);
    }

    document.addEventListener('DOMContentLoaded', function() {
        calculerSousTotal();

        document.addEventListener('click', function(e) {
            if (e.target && e.target.type === 'checkbox') {
                setTimeout(calculerSousTotal, 0);
            }
        });
    });
</script>
