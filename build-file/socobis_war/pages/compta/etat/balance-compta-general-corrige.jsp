<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="mg.cnaps.compta.ComptaEtatBalanceGenerator"%>
<%@page import="mg.cnaps.compta.ComptaEtatBalanceChiffre2"%>
<%@page import="mg.cnaps.compta.ComptaEtatBalanceChiffre3"%>
<%@page import="bean.CGenUtil"%>
<%@page import="utilitaire.Utilitaire" %>
<%@page import="java.sql.Date" %>
<%@page import="java.util.*" %>
<%@page import="affichage.PageInsert" %>
<%@page import="bean.AdminGen"%>
<%@page import="mg.cnaps.compta.Balance"%>
<%@page import="mg.cnaps.compta.BalanceDetails"%>

<%
    String lang = String.valueOf(session.getAttribute("lang"));
    String[] ret = {"Balance des comptes", "au", "Compte", "Intitul&eacute; du compte", "Cumul D&eacute;bit", "Cumul Cr&eacute;dit", "Mouvement D&eacute;bit", "Mouvement Cr&eacute;dit", "Solde D&eacute;bit", "Solde Cr&eacute;dit", "exporter"};

    String moisDebut = request.getParameter("moisDebut");
    String moisFin = request.getParameter("moisFin");
    String compteDebut = request.getParameter("debutCompte");
    String compteFin = request.getParameter("finCompte");
    String exercice = request.getParameter("exercice");
    String typeCompte = request.getParameter("typeCompte");
    String etat = request.getParameter("etat");

    Balance balance = new Balance(exercice, typeCompte, moisDebut, moisFin, compteDebut, compteFin);
    BalanceDetails[] balanceDetails = balance.getBalanceDetails();

    session.setAttribute("balanceDetails", balanceDetails);

    String date1 = balance.getDateDebut();
    String date2 = balance.getDateFin();
    String cptDebut = balance.getDebutCompte();
    String cptFin = balance.getFinCompte();
    String plageCompte = "";
    if (cptDebut != null && !cptDebut.trim().isEmpty() && !"null".equals(cptDebut)) plageCompte += " du compte " + cptDebut;
    if (cptFin != null && !cptFin.trim().isEmpty() && !"null".equals(cptFin)) plageCompte += " au compte " + cptFin;
%>

<meta charset="UTF-8">
<title>Balance des comptes g&eacute;n&eacute;raux du <%= date1 %> au <%= date2 %><%= plageCompte %></title>
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
<jsp:include page='../../elements/css.jsp'/>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/apj-compta-list.css">

<div class="apj-compta-list apj-balance-page" style="padding: 20px">
    <section class="content-header">
        <h1 class="title" id="titre-export">Balance des comptes généraux du <%= date1 %> au <%= date2 %><%= plageCompte %></h1>
    </section>
    <section class="content">
        <div class="apj-compta-toolbar apj-balance-toolbar">
            <div class="apj-compta-actions">
                <div class="form-group">
                    <label for="ext">Format</label>
                    <select name="ext" id="ext" class="form-control">
                        <option value="xls">Excel</option>
                        <option value="pdf">PDF</option>
                    </select>
                </div>
                <button type="button" class="btn btn-secondary btn-bg-white btn-small filtre-btn" onclick="exporter()"><i class="material-symbols-rounded">file_export</i> Exporter</button>
            </div>
        </div>
        <div id="table-container" class="box table-box" data-apj-balance-root="">
            <div class="box-body table-responsive no-padding">
                <table id="balance-table" class="table table-hover table-striped" data-apj-balance-table="">
                    <thead><tr class="head">
                            <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="<%= ret[2] %>"><%= ret[2] %></th>
                            <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="<%= ret[3] %>"><%= ret[3] %></th>
                            <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="<%= ret[4] %>"><%= ret[4] %></th>
                            <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="<%= ret[5] %>"><%= ret[5] %></th>
                            <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="<%= ret[6] %>"><%= ret[6] %></th>
                            <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="<%= ret[7] %>"><%= ret[7] %></th>
                            <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="<%= ret[8] %>"><%= ret[8] %></th>
                            <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="<%= ret[9] %>"><%= ret[9] %></th>
                    </tr></thead>
                    <tbody>
                    <%
                        for (int i = 0; i < balanceDetails.length; i++) {
                            try {
                                if (balanceDetails[i].estValide()) {
                                    out.println(balanceDetails[i].makeLigne().replaceFirst("<tr>", "<tr data-apj-row=\"balance\">"));
                                }
                            } catch (Exception e) {
                                throw new RuntimeException(e);
                            }
                        }
                    %>
                    </tbody>
                    <tfoot>
                        <tr class="apj-balance-total">
                            <td></td>
                            <td>Totaux</td>
                            <td><%= Utilitaire.formaterAr(Utilitaire.arrondir(balance.getTotal().getCumulDebit(), 2), 2) %></td>
                            <td><%= Utilitaire.formaterAr(Utilitaire.arrondir(balance.getTotal().getCumulCredit(), 2), 2) %></td>
                            <td><%= Utilitaire.formaterAr(Utilitaire.arrondir(balance.getTotal().getDebit(), 2), 2) %></td>
                            <td><%= Utilitaire.formaterAr(Utilitaire.arrondir(balance.getTotal().getCredit(), 2), 2) %></td>
                            <td><%= Utilitaire.formaterAr(Utilitaire.arrondir(balance.getTotal().getSoldeDebit(), 2), 2) %></td>
                            <td><%= Utilitaire.formaterAr(Utilitaire.arrondir(balance.getTotal().getSoldeCredit(), 2), 2) %></td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
        <div class="apj-export-forms">
            <input id="date1" type="hidden" value="<%= date1 %>" />
            <input id="date2" type="hidden" value="<%= date2 %>" />
            <input id="plage1" type="hidden" value="<%= balance.getDebutCompte() %>" />
            <input id="plage2" type="hidden" value="<%= balance.getFinCompte() %>" />
            <input id="exercice" type="hidden" value="<%= balance.getExercice() %>" />
            <input id="typeCompte" type="hidden" value="<%= balance.getTypeCompte() %>" />

            <form id="form-export" action="../../../download" method="post">
                <input id="excel-input" type="hidden" name="table" value="">
                <input type="hidden" name="ext" value="xls" checked="checked">
                <input type="hidden" name="donnee" value="0" checked="checked">
                <input type="hidden" name="specific_xls" value="true"/>
            </form>

            <form id="form-export-pdf" action="<%= (String) session.getValue("lien") %>/../../EtatComptable?action=etatComptablePDF" method="post">
                <input id="excel-input-pdf" type="hidden" name="table" value="">
                <input type="hidden" name="ext" value="pdf" checked="checked">
                <input type="hidden" name="donnee" value="0" checked="checked">
                <input type="hidden" value="Exporter" class="btn btn-default">
            </form>
        </div>
    </section>
</div>

<script>
    $(".btn-export").click(function() {
        $(".export-block").toggleClass("inactive");
    });

    function exporter() {
        let exp = $('#ext').val();
        if (exp === 'xls') {
            document.location.href = "<%=request.getContextPath()%>/EtatComptableExcelServlet?typeCompte=<%=balance.getTypeCompte()%>&exercice=<%=balance.getExercice()%>&debutCompte=<%=balance.getDebutCompte()%>&finCompte=<%=balance.getFinCompte()%>&moisDebut=<%=balance.getMoisDebut()%>&moisFin=<%=balance.getMoisFin()%>&etat=11&daty1=<%=date1%>&daty2=<%=date2%>";
        }
        if (exp === 'pdf') {
            document.location.href = "<%=request.getContextPath()%>/EtatComptable?action=balanceCompta&type=pdf&typeCompte=<%=balance.getTypeCompte()%>&exercice=<%=balance.getExercice()%>&debutCompte=<%=balance.getDebutCompte()%>&finCompte=<%=balance.getFinCompte()%>&moisDebut=<%=balance.getMoisDebut()%>&moisFin=<%=balance.getMoisFin()%>&etat=11&daty1=<%=date1%>&daty2=<%=date2%>";
        }
    }

    function exporterPDF() {
        chargerExportPDF();
        var form = $("#form-export-pdf");
        form.submit();
    }

    function ecranGrandLivreCompte(compte, libelle_compte) {
        var date1 = $('#date1').val();
        var date2 = $('#date2').val();
        var plage1 = $('#plage1').val();
        var plage2 = $('#plage2').val();
        var exercice = $('#exercice').val();
        var typecompte = $('#typeCompte').val();
        var url = '../../popup.jsp?but=compta/etat/grandLivreCompte-etat.jsp&compte=' + compte + '&libelle_compte=' + libelle_compte + '&date1=' + date1 + '&date2=' + date2 + '&plage1=' + plage1 + '&plage2=' + plage2 + '&exercice=' + exercice + '&typecompte=' + typecompte;
        window.open(url, "", "resizable=no,scrollbars=yes,location=no,width=1009,height=532,top=0,left=0");
    }

    function ecranBalanceAuxiliaire(compte) {
        var date1 = $('#date1').val();
        var date2 = $('#date2').val();
        var plage1 = $('#plage1').val();
        var plage2 = $('#plage2').val();
        var exercice = $('#exercice').val();
        var typecompte = $('#typecompte').val();
        var url = '../../popup.jsp?but=compta/etat/balanceCompteAuxiliaire.jsp&compte_mere=' + compte + '&date1=' + date1 + '&date2=' + date2 + '&exercice=' + exercice + '&typecompte=' + typecompte;
        window.open(url, "", "titulaireresizable=no,scrollbars=yes,location=no,width=1009,height=532,top=0,left=0");
    }

    function prePrint() {
        if (window.print) {
            window.print();
        } else {
            alert('Votre navigateur ne supporte pas cette action');
        }
    }
</script>

<script src="<%= request.getContextPath() %>/assets/js/apj-balance-list.js"></script>
