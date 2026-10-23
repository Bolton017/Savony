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
    String[] ret = {"Balance des comptes", "au", "Compte", "Intitul&eacute; du compte", "Cumul DB","Cumul DB N-{ecart}","Différence Cumul DB", "Cumul CR","Cumul CR N-{ecart}","Différence Cumul CR", "Mouvement DB","Mouvement DB N-{ecart}","Différence Mouvement DB", "Mouvement CR","Mouvement CR N-{ecart}","Différence Mouvement CR", "Solde DB","Solde DB N-{ecart}","Différence Solde DB", "Solde CR","Solde CR N-{ecart}","Différence Solde CR", "exporter"};

    String moisDebut = request.getParameter("moisDebut");
    String moisFin = request.getParameter("moisFin");
    String compteDebut = request.getParameter("debutCompte");
    String compteFin = request.getParameter("finCompte");
    String exercice = request.getParameter("exercice");
    String typeCompte = request.getParameter("typeCompte");
    String etat = request.getParameter("etat");
    String balanceCompa = request.getParameter("balanceCompa");

    System.out.println("exercice = " + exercice + "=> Integer exercice = " + Integer.parseInt(exercice));
    System.out.println("balanceCompa = " + balanceCompa + "=> Integer balanceCompa = " + Integer.parseInt(balanceCompa));
    System.out.println("ecart = " + (Integer.parseInt(exercice) - Integer.parseInt(balanceCompa)));
    int ecart = Integer.parseInt(exercice) - Integer.parseInt(balanceCompa);
    ret[5] = ret[5].replace("{ecart}", String.valueOf(ecart));
    ret[8] = ret[8].replace("{ecart}", String.valueOf(ecart));
    ret[11] = ret[11].replace("{ecart}", String.valueOf(ecart));
    ret[14] = ret[14].replace("{ecart}", String.valueOf(ecart));
    ret[17] = ret[17].replace("{ecart}", String.valueOf(ecart));
    ret[20] = ret[20].replace("{ecart}", String.valueOf(ecart));

    Balance balance = new Balance(exercice, typeCompte, moisDebut, moisFin, compteDebut, compteFin);
    Balance balanceComparative = new Balance(balanceCompa, typeCompte, moisDebut, moisFin, compteDebut, compteFin);
    BalanceDetails[] balanceDetails = balance.getBalanceDetails();
    BalanceDetails[] detailsCompa = balanceComparative.getBalanceDetails();


    String date1 = balance.getDateDebut();
    String date2 = balance.getDateFin();
%>

<meta charset="UTF-8">
<title>Balance comparative de <%= exercice %> et <%= balanceCompa %></title>
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
<jsp:include page='../../elements/css.jsp'/>

<div class="content-wrapper" style="margin: 0;padding: 20px">
    <div class="row">
        <div class="row col-md-12">
            <div class="box box-solid">
                <div class="content">
                    <div id="table-container">
                        <div class="d-flex align-items-center col-12">
                            <div class="box-header with-border">
                                <h3 class="title">
                                    Balance comparative de <%= exercice %> et <%= balanceCompa %>
                                </h3>
                            </div>
                            <div style="display: flex; gap: 30px; margin-left: auto; margin-right: 20px;">
                                <div style="display: flex; align-items: center;">
                                    <div class="form-group mb-0">
                                        <label style="margin-right: 10px; margin-bottom: 0;">Format</label>
                                        <select name="ext" id="ext" class="form-control" style="width: 150px;">
                                            <option value="xls">Excel</option>
                                            <option value="pdf">PDF</option>
                                        </select>
                                    </div>
                                </div>
                                <div style="border-left: 2px solid #ddd; padding-left: 30px; padding: 15px; padding-top: 25px;">
                                    <input type="button" class="btn btn-info" value="Exporter" onclick="exporter()"/>
                                </div>
                            </div>
                        </div>

                        <div class="box-body table-responsive no-padding">
                            <table class="table table-hover table-bordered">
                                <thead>
                                <tr class="head">
                                    <th><%= ret[2] %></th>
                                    <th><%= ret[3] %></th>
                                    <th><%= ret[4] %></th>
                                    <th><%= ret[5] %></th>
                                    <th><%= ret[6] %></th>
                                    <th><%= ret[7] %></th>
                                    <th><%= ret[8] %></th>
                                    <th><%= ret[9] %></th>
                                    <th><%= ret[10] %></th>
                                    <th><%= ret[11] %></th>
                                    <th><%= ret[12] %></th>
                                    <th><%= ret[13] %></th>
                                    <th><%= ret[14] %></th>
                                    <th><%= ret[15] %></th>
                                    <th><%= ret[16] %></th>
                                    <th><%= ret[17] %></th>
                                    <th><%= ret[18] %></th>
                                    <th><%= ret[19] %></th>
                                    <th><%= ret[20] %></th>
                                    <th><%= ret[21] %></th>

                                </tr>
                                </thead>
                                <tbody>
                                <%
                                    for (int i = 0; i < balanceDetails.length; i++) {
                                        try {
                                            if (balanceDetails[i].estValide()) {
                                                out.println(balanceDetails[i].makeLigneComparative(detailsCompa[i]));
                                            }
                                        } catch (Exception e) {
                                            throw new RuntimeException(e);
                                        }
                                    }
                                %>
                                <tr>
                                    <td></td>
                                    <td>Totaux</td>
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getCumulDebit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balanceComparative.getTotal().getCumulDebit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getCumulDebit() - balanceComparative.getTotal().getCumulDebit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getCumulCredit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balanceComparative.getTotal().getCumulCredit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getCumulCredit() - balanceComparative.getTotal().getCumulCredit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getDebit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balanceComparative.getTotal().getDebit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getDebit() - balanceComparative.getTotal().getDebit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getCredit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balanceComparative.getTotal().getCredit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getCredit() - balanceComparative.getTotal().getCredit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getSoldeDebit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balanceComparative.getTotal().getSoldeDebit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getSoldeDebit() - balanceComparative.getTotal().getSoldeDebit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getSoldeCredit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balanceComparative.getTotal().getSoldeCredit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getSoldeCredit() - balanceComparative.getTotal().getSoldeCredit()) %></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

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
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(".btn-export").click(function() {
        $(".export-block").toggleClass("inactive");
    });

    function exporter() {
        let exp = $('#ext').val();
        if (exp === 'xls') {
            exporterCsv();
        }
        if (exp === 'pdf') {
            chargerExportPDF();
            document.location.replace("../../../BalanceCompta?action=balanceCompta&typeCompte=<%=balance.getTypeCompte()%>&exercice=<%=balance.getExercice()%>&debutCompte=<%=balance.getDebutCompte()%>&finCompte=<%=balance.getFinCompte()%>&moisDebut=<%=balance.getMoisDebut()%>&moisFin=<%=balance.getMoisFin()%>&etat=11&daty1=<%=date1%>&daty2=<%=date2%>");
        }
    }

    function chargerExportPDF() {
        var titre = "<h1>" + $('#titre-export').html() + "</h1>";
        var excel = titre + $('#table-container').html();
        var excelInput = document.getElementById("excel-input-pdf");
        excelInput.value = excel;
        console.log("valeur de l'excel" + excelInput.value);
    }

    function chargerExport() {
        var titre = "<h1>" + $('#titre-export').html() + "</h1>";
        var excel = titre + $('#table-container').html();
        var excelInput = document.getElementById("excel-input");
        excelInput.value = excel;
        console.log("valeur de l'excel" + excelInput.value);
    }

    function exporterCsv() {
        chargerExport();
        var form = $("#form-export");
        form.submit();
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
        var typecompte = $('#typecompte').val();
        var url = '../../popup.jsp?but=compta/etat/grandLivreCompte-etat.jsp&compte=' + compte + '&libelle_compte=' + libelle_compte + '&date1=' + date1 + '&date2=' + date2 + '&plage1=' + plage1 + '&plage2=' + plage2 + '&exercice=' + exercice + '&typecompte=' + typecompte;
        window.open(url, "", "titulaireresizable=no,scrollbars=yes,location=no,width=1009,height=532,top=0,left=0");
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
