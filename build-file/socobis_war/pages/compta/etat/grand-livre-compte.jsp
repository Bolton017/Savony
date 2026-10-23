<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="bean.CGenUtil"%>
<%@page import="utilitaire.Utilitaire" %>
<%@page import="java.sql.Date" %>
<%@page import="mg.cnaps.compta.*" %>
<%@page import="affichage.PageInsert" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="utilitaire.UtilDB" %>
<%@ page import="utilitaire.ConstanteEtat" %>
<%
    ComptaEtatGrandLivreGenerator grandLivre = null;
    String date1 = null;
    String date2 = null;
    try{
        String lang = String.valueOf(session.getAttribute("lang"));
        String[] mots = {"Grand livre du compte", "au", "Compte", "Libelle du compte", "Journal", "Date", "Libelle", "Lettrage", "Mouvement", "Debit", "Credit", "Solde", "exporter"};
        String[] ret = Utilitaire.transformerLangue(mots, lang);

        ComptaEtatGrandLivreGenerator gl = new ComptaEtatGrandLivreGenerator();
        gl.setNomTable("v_compta_etat_balance");
        PageInsert pi=new PageInsert();
        pi.setBase(gl);
        pi.setReq(request);
        grandLivre = (ComptaEtatGrandLivreGenerator)pi.getObjectAvecValeur();
        grandLivre.normalizeComptes();
        grandLivre.fillComptesWithMouvementAndReport(null);
        date1 = request.getParameter("dateDebut");
        date2 = request.getParameter("dateFin");

        Connection c = new UtilDB().GetConn();

%>

<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
<jsp:include page='../../elements/css.jsp'/>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/apj-compta-list.css">
<div class="apj-compta-list" style="margin: 0;padding: 20px">
    <div class="row">
        <div class="row col-md-12">
            <div class="">
                <div class="content">
                    <div class="apj-compta-toolbar">
                            <div class="content-header">
                                <h1 class="title" id="titre-export">
                                    <%
                                        String compteDebut = grandLivre.getCompteDebut();
                                        String compteFin = grandLivre.getCompteFin();
                                        if (compteDebut != null && compteFin != null && compteDebut.equals(compteFin)) {
                                    %>
                                    Grand livre du compte <%=compteDebut%>
                                    <%
                                        } else {
                                    %>
                                    Grand livre du compte du <%=compteDebut%> au <%=compteFin%>
                                    <%
                                        }
                                    %>
                                </h1>
                            </div>

                            <div class="apj-compta-actions">
                                <div style="display: flex; align-items: center;">
                                    <span style="margin-right: 20px;">Somme d&eacute;bit s&eacute;lection : <span id="somme-debit-globale">0</span></span>
                                    <span>Somme cr&eacute;dit s&eacute;lection : <span id="somme-credit-globale">0</span></span>
                                </div>
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
                    <div id="table-container" class="box table-box" data-apj-account-root="">
                        <div class="box-body table-responsive no-padding">
                            <table id="export" class="table table-hover table-striped" data-apj-account-table="">
                                <thead><tr class="head">
                                    <th class="contenuetable" ></th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Compte">Compte</th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Réf. Mouvement">R&eacute;f. Mouvement</th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Date">Date</th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Journal / Folio">Journal / Folio</th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Contrep.">Contrep.</th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Libellé Oper.">Libell&eacute; Oper.</th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Débit">D&eacute;bit</th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Crédit">Cr&eacute;dit</th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Lettre">Lettre</th>
                                    <% if (grandLivre.getTypeCompte().compareToIgnoreCase("1") == 0) { %>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Compte analytique">Compte analytique</th>
                                    <% } else { %>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Compte général">Compte g&eacute;n&eacute;ral</th>
                                    <% } %>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="État">&Eacute;tat</th>
                                </tr></thead>
                                <tbody>
                                <%  //String v = "<table><thead><tr><td>Grand livre du compte " + grandLivre.getCompteDebut() + " au " + grandLivre.getCompteFin() + "</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr></thead><tbody>";
                                    for (Map.Entry<String,ComptaCompte> listeComptes : grandLivre.getComptes().entrySet()) {
                                        ComptaCompte cc = listeComptes.getValue();
                                        List<ComptaSousEcriture> mouvements = cc.getMouvements();
                                %>
                                <%
                                    if (cc.getReportDebit() != 0 ||  cc.getReportCredit() != 0||(mouvements != null && mouvements.size() > 0)) {
                                %>



                                <tr class="head apj-account-heading">
                                    <th colspan="12"><input type="checkbox" class="select-all-compte" data-compte="<%= cc.getCompte() %>" checked onclick="toggleSelectCompte(this)" aria-label="Tout sélectionner pour le compte <%= cc.getCompte() %>"> COMPTE : <%= cc.getCompte()%></th>
                                </tr>
                                <tr>
                                    <td colspan="6"></td>
<%--                                    <td>Report à nouveau...</td>--%>
                                    <td>Ancien cumul ...</td>
                                    <td>
                                        <%if (cc.getReportDebit() == 0) {
                                            out.print("");
                                        } else {
                                            out.print(Utilitaire.formaterAr(cc.getReportDebit()));
                                        }
                                        %>
                                    </td>
                                    <td>
                                        <% if (cc.getReportCredit() == 0) {
                                            out.print("");
                                        } else {
                                            out.print(Utilitaire.formaterAr(cc.getReportCredit()));
                                        }
                                        %>
                                    </td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <%

                                    if (mouvements != null) {
                                        String color = "black";
                                        for (ComptaSousEcriture comptaEcriture : mouvements) {
                                            if (comptaEcriture != null) {
                                                if (comptaEcriture.getEtat() == 1) {
                                                    color = "red";
                                                } else if (comptaEcriture.getEtat() >= 11) {
                                                    color = "black";
                                                }
                                %>
                                <tr data-apj-row="movement">
                                    <td><input type="checkbox" class="select-mouvement" data-compte="<%= cc.getCompte() %>" data-debit="<%= comptaEcriture.getDebit() %>" data-credit="<%= comptaEcriture.getCredit() %>" value="<%= comptaEcriture.getIdMere() %>" checked onclick="updateSommeGlobale()"></td>
                                    <td>
                                        <%= cc.getCompte()%>
                                    </td>
                                    <td>
                                        <a href="<%=(String) session.getAttribute("lien")%>/../../../module.jsp?but=compta/ecriture/ecriture-fiche.jsp&id=<%=comptaEcriture.getIdMere()%>" target="_blank"><%=comptaEcriture.getIdMere()%></a>
                                    </td>
                                    <td>
                                        <%= Utilitaire.formatterDaty(comptaEcriture.getDaty())%>
                                    </td>
                                    <td>
                                        <%= comptaEcriture.getJournal()%>/<%= comptaEcriture.getFolio()%>
                                    </td>
                                    <td>
                                        <%= comptaEcriture.getContrep()%>
                                    </td>
                                    <td>
                                        <%= comptaEcriture.getRemarque()%>
                                    </td>
                                    <td style="text-align: right">
                                        <%if (comptaEcriture.getDebit() == 0) {
                                            out.print("");
                                        } else {
                                            out.print(Utilitaire.formaterAr(comptaEcriture.getDebit()));
                                        }%>
                                    </td>
                                    <td style="text-align: right">
                                        <%if (comptaEcriture.getCredit() == 0) {
                                            out.print("");
                                        } else {
                                            out.print(Utilitaire.formaterAr(comptaEcriture.getCredit()));
                                        }%>
                                    </td>
                                    <td>
                                        <%= comptaEcriture.getLettrage()%>
                                    </td>
                                    <td><%= comptaEcriture.getReference_engagement()%></td>
                                    <td>
                                        <%
                                            if (comptaEcriture.getEtat() == ConstanteEtat.getEtatCreer()) {
                                                out.print("<font color='#ffc107'>CR&Eacute;&Eacute;E</font>");
                                            } else if (comptaEcriture.getEtat() == ConstanteEtat.getEtatValider()) {
                                                out.print("<font color='#28a745'>VIS&Eacute;E</font>");
                                            }
                                        %>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                                <% }
                                }
                                %>

                                <tr>
                                    <td colspan="6"></td><td><b>TOTAL</b></td>
                                    <td style="text-align: right">
                                        <b><%= Utilitaire.formaterAr(Utilitaire.arrondir((double) cc.getTotalDebit(), 2), 2)%></b>
                                    </td>
                                    <td style="text-align: right">
                                        <b><%= Utilitaire.formaterAr(Utilitaire.arrondir((double) cc.getTotalCredit(), 2), 2)%></b>
                                    </td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>

                                <tr>
                                    <td colspan="6"></td>
                                    <td><b>CUMUL</b></td>
                                    <td style="text-align: right">
                                        <b><%= Utilitaire.formaterAr(Utilitaire.arrondir((double) cc.getReportDebit(), 2), 2)%></b>
                                    </td>
                                    <td style="text-align: right">
                                        <b><%= Utilitaire.formaterAr(Utilitaire.arrondir((double) cc.getReportCredit(), 2), 2)%></b>
                                    </td><td></td><td></td><td></td>
                                </tr>

                                <tr class="table-apj-footer">
                                    <td colspan="6"></td>
                                    <td><b>SOLDE</b></td>
                                    <td style="text-align: right">
                                        <b > <%if (cc.getSoldeDebit() == 0) {
                                            out.print("");
                                        } else {
                                            out.print(Utilitaire.formaterAr(Utilitaire.arrondir((double) cc.getSoldeDebit(), 2), 2));
                                        }%></b>
                                    </td>
                                    <td  style="text-align: right">
                                        <b><%if (cc.getSoldeCredit() == 0) {
                                            out.print("");
                                        } else {
                                            out.print(Utilitaire.formaterAr(Utilitaire.arrondir((double) cc.getSoldeCredit(), 2), 2));
                                        }%></b>
                                    </td>
                                    <td colspan="3"></td>
                                </tr>



                                <% } %>
                                <% }%>

                                <tr class="apj-grand-total">
                                    <th colspan="6"></th>
                                    <th>Total</th>
                                    <th style="text-align: right"> <%= Utilitaire.formaterAr(Utilitaire.arrondir(grandLivre.getTotalCredit(), 2), 2) %></th>
                                    <th style="text-align: right"> <%= Utilitaire.formaterAr(Utilitaire.arrondir(grandLivre.getTotalDebit(), 2), 2)%></th>
                                    <th colspan="3"></th>
                                </tr>
                                <tr class="apj-grand-total">
                                    <td colspan="12"></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <input id="date1" type="hidden" value="<%= date1%>" />
                    <input id="date2" type="hidden" value="<%= date2%>" />
                    <input id="plage1" type="hidden" value="<%= grandLivre.getCompteDebut()%>" />
                    <input id="plage2" type="hidden" value="<%= grandLivre.getCompteFin()%>" />
                    <input id="exercice" type="hidden" value="<%= grandLivre.getExercice()%>" />
                    <input id="typecompte" type="hidden" value="<%= grandLivre.getTypeCompte()%>" />
                    <input id="etat" type="hidden" value="<%= grandLivre.getEtat()%>" />


                    <div class="box box-primary box-solid apj-export-forms">
                        <div id="export-body" class="box-body" style="display: block;">
                            <form id="form-export" action="../../../download" method="post">
                                <input type="hidden" name="ext"  value="xls"  checked="checked">
                                <input type="hidden" name="donnee" value="0" checked="checked">
                                <input type="hidden" name="specific_xls" value="true"/>
                                <input id="excel-input"  type="hidden" name="table">
                            </form>

                            <form id="form-export-pdf" action="../../../balanceExport?action=exportGrandLivrePDF&date1=<%=grandLivre.getDateDebut()%>&date2=<%=grandLivre.getDateFin()%>&plage1=<%=grandLivre.getCompteDebut()%>&plage2=<%=grandLivre.getCompteDebut()%>&typecompte=<%=grandLivre.getTypeCompte()%>&exercice=<%=grandLivre.getExercice()%>&etat=<%=grandLivre.getEtat()%>" method="post">
                                <input id="excel-input-pdf"  type="hidden" name="table" value="">
                                <input type="hidden" name="ext"  value="pdf"  checked="checked">
                                <input type="hidden" name="donnee" value="0" checked="checked">
                                <input type="hidden" value="Exporter" class="btn btn-default">
                            </form>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%
    if(c!=null){
        c.close();
    }
    } catch (Exception e) {
    e.printStackTrace();
}%>

<script>
    $(".btn-export").click(function() {
        $(".export-block").toggleClass("inactive");
    });

    $(document).ready(function () {
        updateSommeGlobale();
    });

    function toggleSelectCompte(checkbox) {
        var compte = checkbox.getAttribute('data-compte');
        var checked = checkbox.checked;
        document.querySelectorAll('.select-mouvement[data-compte="' + compte + '"]').forEach(function (cb) {
            cb.checked = checked;
        });
        updateSommeGlobale();
    }

    function updateSommeGlobale() {
        var sommeDebit = 0;
        var sommeCredit = 0;
        document.querySelectorAll('.select-mouvement:checked').forEach(function (cb) {
            sommeDebit += parseFloat(cb.getAttribute('data-debit')) || 0;
            sommeCredit += parseFloat(cb.getAttribute('data-credit')) || 0;
        });
        document.getElementById('somme-debit-globale').textContent = sommeDebit.toLocaleString('fr-FR', {minimumFractionDigits: 2, maximumFractionDigits: 2});
        document.getElementById('somme-credit-globale').textContent = sommeCredit.toLocaleString('fr-FR', {minimumFractionDigits: 2, maximumFractionDigits: 2});
    }

    function exporter(){
        let exp = $('#ext').val();
        if(exp === 'xls'){
            document.location.replace("${pageContext.request.contextPath}/ExportExcel?action=grand_livre&date1=<%=date1%>&date2=<%=date2%>&plage1=<%=grandLivre.getCompteDebut()%>&plage2=<%=grandLivre.getCompteFin()%>&typecompte=<%=grandLivre.getTypeCompte()%>&exercice=<%=grandLivre.getExercice()%>&etat=<%=grandLivre.getEtat()%>&type=xls")
        }
        if(exp === 'pdf'){
          document.location.replace("${pageContext.request.contextPath}/EtatComptable?action=exportGrandLivrePDF&date1=<%=date1%>&date2=<%=date2%>&plage1=<%=grandLivre.getCompteDebut()%>&plage2=<%=grandLivre.getCompteFin()%>&typecompte=<%=grandLivre.getTypeCompte()%>&exercice=<%=grandLivre.getExercice()%>&etat=<%=grandLivre.getEtat()%>");
        }
    }

    function chargerExportPDF()
    {
        var titre = "<h1>" + $('#titre-export').html() + "</h1>";
        var table = window.ApjAccountTable.prepareExport(document.getElementById('export'));
        var excel = titre + $('<div>').append(table).html();

        var excelInput = document.getElementById("excel-input");
        excelInput.value = excel;
        document.location.replace('../../../ExportServlet?titre=' + titre + "&htmlcontent=" + excel);
    }
    function chargerExport()
    {
        var titre = "<h1>" + $('#titre-export').html() + "</h1>";
        var table = window.ApjAccountTable.prepareExport(document.getElementById('export'));
        var excel = titre + $('<div>').append(table).html();


        var excelInput = document.getElementById("excel-input");
        excelInput.value = excel;
        console.log("valeur de l'excel" + excelInput.value);
    }
    function changerExportExcel()
    {
        var titre = "<h1>" + $('#titre-export').html() + "</h1>";
        var table = window.ApjAccountTable.prepareExport(document.getElementById('export'));
        var excel = titre + $('<div>').append(table).html();


        var excelInput = document.getElementById("donnee");
        excelInput.value = excel;
        //console.log("valeur de l'excel" + excelInput.value);
    }



    function exporterCsv()
    {
        chargerExport();
        var form = $("#form-export");
        form.submit();
    }

    function ecranEcritureComptable(id) {
        url = 'compta/etat/ecritureComptable-etat.jsp?id=' + id;
        window.open(url, "", "titulaireresizable=no,scrollbars=yes,location=no,width=1009,height=532,top=0,left=0");
    }
</script>
<script src="<%= request.getContextPath() %>/assets/js/apj-compta-list.js"></script>
