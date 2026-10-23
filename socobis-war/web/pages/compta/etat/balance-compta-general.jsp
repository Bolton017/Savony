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
    String[] ret = {"Balance des comptes", "au", "Compte", "Intitule du compte", "Cumul DB", "Cumul CR", "Mouvement DB", "Mouvement CR", "Solde DB", "Solde CR", "exporter"};

    String moisDebut = request.getParameter("moisDebut");
    String moisFin = request.getParameter("moisFin");
    String compteDebut = request.getParameter("debutCompte");
    String compteFin = request.getParameter("finCompte");
    String exercice = request.getParameter("exercice");
    String typeCompte = request.getParameter("typeCompte");
    String etat = request.getParameter("etat");

    Balance balance = new Balance(exercice, typeCompte, moisDebut, moisFin, compteDebut, compteFin);
    BalanceDetails[] balanceDetails = balance.getBalanceDetails();

    String date1 = balance.getDateDebut();
    String date2 = balance.getDateFin();
%>

<meta charset="UTF-8">
<title>Balance des comptes g&eacute;n&eacute;raux du <%= date1 %> au <%= date2 %></title>
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
                                    Balance des comptes généraux du <%= date1 %> au <%= date2 %>
                                </h3>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group me-3">
                                                <label>Format</label>
                                                <select name="ext" id="ext" class="form-control">
                                                    <option value="xls">Excel</option>
                                                    <option value="pdf">PDF</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            </br>
                                            <div class="form-group">
                                                <input type="button" class="btn btn-info" value="Exporter" onclick="exporter()"/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6"></div>
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
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                    for (int i = 0; i < balanceDetails.length; i++) {
                                        try {
                                            if (balanceDetails[i].estValide()) {
                                                out.println(balanceDetails[i].makeLigne());
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
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getCumulCredit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getDebit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getCredit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getSoldeDebit()) %></td>
                                    <td><%= Utilitaire.formaterAr(balance.getTotal().getSoldeCredit()) %></td>
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
