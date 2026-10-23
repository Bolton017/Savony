<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="mg.cnaps.compta.*" %>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="utilitaire.Utilitaire" %>
<%@page import="java.sql.Date" %>
<%@page import="mg.cnaps.compta.*" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="utilitaire.UtilDB" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%
    try{
        ComptaCompte compte = new ComptaCompte();
        compte.setNomTable("COMPTA_COMPTE_LIBELLE");
        String[] libelleCompteFiche = {"Id", "Compte", "Libell&eacute;", "Type Compte","Classe","Journal"};
        PageConsulte pc = new PageConsulte(compte, request, (user.UserEJB) session.getValue("u"));
        pc.setLibAffichage(libelleCompteFiche);
        pc.getChampByName("idtypecompte").setVisible(false);
        pc.getChampByName("classe").setVisible(false);
        pc.setTitre("Fiche Compte");
        String lien = (String) session.getValue("lien");
        ComptaCompte base=(ComptaCompte)pc.getBase();
%>

<div class="content-wrapper apj-compta-list">
    <section class="content-header">
        <h1>
            <a href="<%= lien + "?but=compta/compte/compte-liste.jsp" %>" aria-label="Retour à la liste des comptes"><i class="material-symbols-rounded">arrow_back</i></a>
            <%=pc.getTitre()%>
        </h1>
    </section>
    <div class="row m-0">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%= pc.getHtml() %>
                    </div>
                     <div class="box-footer">
                        <a  href="<%=(String) session.getValue("lien") + "?but=compta/compte/compte-saisie.jsp&acte=update&id=" +  request.getParameter("id")%>" class="btn btn-secondary pull-right">Modifier</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

<%
    String lang = session.getAttribute("lang") != null ? session.getAttribute("lang").toString() : "fr";
    // Clés pour les filtres
    String[] mots = {"Generer etats", "Exercice", "Type de compte", "Type etat", "Mois debut", "Mois fin", "Compte", "Au compte", "Balance comparative", "Afficher"};
    String[] ret = Utilitaire.transformerLangue(mots, lang);
    if (ret == null) ret = mots;
    // Clés pour le tableau Grand Livre
    String[] motsGL = {"Grand livre du compte", "au", "Compte", "Libelle du compte", "Journal", "Date", "Libelle", "Lettrage", "Mouvement", "Debit", "Credit", "Solde", "exporter"};
    String[] retGL = Utilitaire.transformerLangue(motsGL, lang);
    if (retGL == null) retGL = motsGL;
    String date1 = request.getParameter("dateDebut");
    String date2 = request.getParameter("dateFin");
    String compteParam = base.getCompte();
    ComptaCompte cmc =(ComptaCompte) new ComptaCompte().getById(base.getTuppleID(),"COMPTA_COMPTE",null);
    String typeCompteParam = cmc.getTypeCompte();
    ComptaEtatGrandLivreGenerator grandLivre = null;
    String dateJour= Utilitaire.dateDuJour();
    String moisMaxGl = Utilitaire.getMois(dateJour);
    Connection c = null;
    String errorMsg = null;
    // On ne charge les données QUE si les paramètres de date sont présents
    if (date1 != null && !date1.isEmpty() && date2 != null && !date2.isEmpty()) {
        try {
            grandLivre = new ComptaEtatGrandLivreGenerator();
            grandLivre.setNomTable("v_compta_etat_balance");

            PageInsert pi = new PageInsert();
            pi.setBase(grandLivre);
            pi.setReq(request);
            grandLivre = (ComptaEtatGrandLivreGenerator) pi.getObjectAvecValeur();

            if (grandLivre != null) {
                grandLivre.normalizeComptes();
                grandLivre.fillComptesWithMouvementAndReport(null);
                c = new UtilDB().GetConn();
            }
        } catch (Exception e) {
            errorMsg = "Erreur lors du chargement des données : " + e.getMessage();
            e.printStackTrace();
        }
    } else {
        
        try {
            String exerciceDef = request.getParameter("exercice");
            if (exerciceDef == null || exerciceDef.isEmpty()) exerciceDef = "" + Utilitaire.getAnneeEnCours();
            int anneeDef = Integer.parseInt(exerciceDef);
            int moisDef = Integer.parseInt(moisMaxGl);
            String mmDef = (moisDef < 10) ? "0" + moisDef : String.valueOf(moisDef);
            java.util.Calendar calDef = java.util.Calendar.getInstance();
            calDef.set(anneeDef, moisDef - 1, 1);
            int lastDayDef = calDef.getActualMaximum(java.util.Calendar.DAY_OF_MONTH);
            String ddDef = (lastDayDef < 10) ? "0" + lastDayDef : String.valueOf(lastDayDef);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            date1 = sdf.format(Utilitaire.dateDuJourSql());
            date2 = sdf.format(Utilitaire.dateDuJourSql());

            grandLivre = new ComptaEtatGrandLivreGenerator();
            grandLivre.setNomTable("v_compta_etat_balance");
            grandLivre.setExercice(anneeDef);
            grandLivre.setTypeCompte(typeCompteParam);
            grandLivre.setDateDebut(date1);
            grandLivre.setDateFin(date2);
            grandLivre.setCompteDebut(compteParam);
            grandLivre.setCompteFin(compteParam);
            grandLivre.setEtat(0);
            grandLivre.normalizeComptes();
            grandLivre.fillComptesWithMouvementAndReport(null);
            c = new UtilDB().GetConn();
        } catch (Exception e) {
            errorMsg = "Erreur lors du chargement des données : " + e.getMessage();
            e.printStackTrace();
        }
    }
%>
    <div class="row m-0">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <jsp:include page='../../elements/css.jsp'/>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/apj-compta-list.css">
    <% if (errorMsg != null) { %>
    <style>
        .error-box { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 15px; margin: 20px; border-radius: 5px; font-family: monospace; }
    </style>
    <% } %>
    <script>
        function getLastDayOfMonth(year, month) {
            return new Date(year, month, 0).getDate();
        }
        function afficherGrandLivre() {
            var exercice = $('#exercice').val();
            var typecompte = $('#typecompte').val();
            var compte = $('#compte').val();
            var moisMin = $('#moisMin').val();
            var moisMax = $('#moisMax').val();
            if (!exercice || !typecompte || !compte || !moisMin || !moisMax) {
                alert('Veuillez remplir tous les champs.');
                return;
            }
            if (parseInt(moisMin) > parseInt(moisMax)) {
                alert('Le mois de début doit être inférieur ou égal au mois de fin.');
                return;
            }
            var mMin = (moisMin.length === 1) ? '0' + moisMin : moisMin;
            var mMax = (moisMax.length === 1) ? '0' + moisMax : moisMax;
            var dateDebut = exercice + "-" + mMin + "-01";
            var lastDay = getLastDayOfMonth(parseInt(exercice), parseInt(moisMax));
            var dFin = (lastDay < 10) ? '0' + lastDay : lastDay;
            var dateFin = exercice + "-" + mMax + "-" + dFin;
            var url = "module.jsp?but=compta/compte/compte-fiche.jsp&&compte=" + encodeURIComponent(compte) +
                               "&id=" + encodeURIComponent('<%=base.getTuppleID()%>') +
                               "&compteDebut=" + encodeURIComponent(compte) +
                               "&compteFin=" + encodeURIComponent(compte) +
                               "&dateDebut=" + dateDebut +
                               "&dateFin=" + dateFin +
                               "&exercice=" + exercice +
                               "&typeCompte=" + typecompte +
                               "&moisMin=" + moisMin +
                               "&moisMax=" + moisMax;

            window.location.href = url;
        }
    </script>
    <% if (grandLivre != null) { %>
    <div class="row m-0">
    <div class="row">
        <div class="col-md-12">
            <div class="box box-solid">
                <div class="content">
                    <div class="apj-compta-toolbar">
                        <h3 class="h520pxSemibold title m-0" id="titre-export"><%= retGL[0] %> <%= compteParam %></h3>
                        <div class="apj-compta-actions">
                            <div class="form-group">
                                <label for="ext">Format</label>
                                <select name="ext" id="ext" class="form-control"><option value="xls">Excel</option><option value="pdf">PDF</option></select>
                            </div>
                            <button type="button" class="btn btn-secondary btn-bg-white btn-small filtre-btn" onclick="exporter()"><i class="material-symbols-rounded">file_export</i> <%= retGL[12] %></button>
                        </div>
                    </div>
                    <div id="table-container" class="box table-box" data-apj-account-root="">
                        <div class="box-body table-responsive no-padding">
                            <table id="export" class="table table-hover table-striped" data-apj-account-table="">
                                <thead><tr class="head">
                                    <th data-apj-filter-column="" data-apj-filter-label="<%= retGL[2] %>"><%= retGL[2] %></th>
                                    <th data-apj-filter-column="" data-apj-filter-label="ID Mouvement">ID Mouvement</th>
                                    <th data-apj-filter-column="" data-apj-filter-label="<%= retGL[5] %>"><%= retGL[5] %></th>
                                    <th data-apj-filter-column="" data-apj-filter-label="<%= retGL[4] %>/Folio"><%= retGL[4] %>/Folio</th>
                                    <th data-apj-filter-column="" data-apj-filter-label="Contrep.">Contrep.</th>
                                    <th data-apj-filter-column="" data-apj-filter-label="<%= retGL[6] %> Oper."><%= retGL[6] %> Oper.</th>
                                    <th data-apj-filter-column="" data-apj-filter-label="<%= retGL[9] %>"><%= retGL[9] %></th>
                                    <th data-apj-filter-column="" data-apj-filter-label="<%= retGL[10] %>"><%= retGL[10] %></th>
                                    <th data-apj-filter-column="" data-apj-filter-label="<%= retGL[7] %>"><%= retGL[7] %></th>
                                    <% if (grandLivre.getTypeCompte().compareToIgnoreCase("1") == 0) { %>
                                    <th data-apj-filter-column="" data-apj-filter-label="Compte analytique">Compte analytique</th>
                                    <% } else { %>
                                    <th data-apj-filter-column="" data-apj-filter-label="Compte général">Compte g&eacute;n&eacute;ral</th>
                                    <% } %>
                                    <th data-apj-filter-column="" data-apj-filter-label="État">&Eacute;tat</th>
                                </tr></thead>
                                <tbody>
                                <%
                                    for (Map.Entry<String,ComptaCompte> listeComptes : grandLivre.getComptes().entrySet()) {
                                        ComptaCompte cc = listeComptes.getValue();
                                        List<ComptaSousEcriture> mouvements = cc.getMouvements();

                                        if (cc.getReportDebit() != 0 || cc.getReportCredit() != 0 || (mouvements != null && mouvements.size() > 0)) {
                                %>
                                <tr class="head apj-account-heading">
                                    <th colspan="11"><%= retGL[2] %> : <%= cc.getCompte()%> </th>
                                </tr>
                                <tr>
                                    <td colspan="5"></td>
                                    <td>Ancien cumul...</td>
                                    <td><%= (cc.getReportDebit() == 0) ? "" : Utilitaire.formaterAr(cc.getReportDebit()) %></td>
                                    <td><%= (cc.getReportCredit() == 0) ? "" : Utilitaire.formaterAr(cc.getReportCredit()) %></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <%
                                    if (mouvements != null) {
                                        for (ComptaSousEcriture comptaEcriture : mouvements) {
                                            if (comptaEcriture != null) {
                                                String color = (comptaEcriture.getEtat() == 1) ? "red" : "black";
                                %>
                                <tr data-apj-row="movement">
                                    <td><%= cc.getCompte()%></td>
                                    <td>
                                        <a href="<%=(String) session.getAttribute("lien")%>?but=compta/ecriture/ecriture-fiche.jsp&id=<%=comptaEcriture.getIdMere()%>" target="_blank">
                                            <%=comptaEcriture.getIdMere()%>
                                        </a>
                                    </td>
                                    <td><%= Utilitaire.formatterDaty(comptaEcriture.getDaty())%></td>
                                    <td><%= comptaEcriture.getJournal()%>/<%= comptaEcriture.getFolio()%></td>
                                    <td><%= comptaEcriture.getContrePartie(c)%></td>
                                    <td><%= comptaEcriture.getRemarque()%></td>
                                    <td style="text-align: right"><%= (comptaEcriture.getDebit() == 0) ? "" : Utilitaire.formaterAr(comptaEcriture.getDebit()) %></td>
                                    <td style="text-align: right"><%= (comptaEcriture.getCredit() == 0) ? "" : Utilitaire.formaterAr(comptaEcriture.getCredit()) %></td>
                                    <td><%= comptaEcriture.getLettrage()%></td>
                                    <td><%= comptaEcriture.getReference_engagement()%></td>
                                    <td>
                                        <% if (comptaEcriture.getEtat() == 1) { out.print("NON VISE"); }
                                           else if (comptaEcriture.getEtat() >= 11) { out.print("VISE"); } %>
                                    </td>
                                </tr>
                                <%
                                            }
                                        }
                                    }
                                %>
                                <tr>
                                    <td colspan="5"></td><td><b>TOTAL</b></td>
                                    <td style="text-align: right"><b><%= Utilitaire.formaterAr(cc.getTotalDebit())%></b></td>
                                    <td style="text-align: right"><b><%= Utilitaire.formaterAr(cc.getTotalCredit())%></b></td>
                                    <td></td><td></td>
                                </tr>
                                <tr>
                                    <td colspan="5"></td>
                                    <td><b>CUMUL</b></td>
                                    <td style="text-align: right"><b><%= Utilitaire.formaterAr(cc.getReportDebit())%></b></td>
                                    <td style="text-align: right"><b><%= Utilitaire.formaterAr(cc.getReportCredit())%></b></td>
                                    <td></td><td></td>
                                </tr>
                                <tr class="table-apj-footer">
                                    <td colspan="5"></td>
                                    <td><b><%= retGL[11] %></b></td>
                                    <td style="text-align: right"><b><%= (cc.getSoldeDebit() == 0) ? "" : Utilitaire.formaterAr(cc.getSoldeDebit()) %></b></td>
                                    <td style="text-align: right"><b><%= (cc.getSoldeCredit() == 0) ? "" : Utilitaire.formaterAr(cc.getSoldeCredit()) %></b></td>
                                    <td colspan="3"></td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                                <tr class="apj-grand-total">
                                    <th colspan="5"></th>
                                    <th>Total</th>
                                    <th style="text-align: right"> <%= Utilitaire.formaterAr(grandLivre.getTotalDebit()) %></th>
                                    <th style="text-align: right"> <%= Utilitaire.formaterAr(grandLivre.getTotalCredit()) %></th>
                                    <th colspan="3"></th>
                                </tr>
                                <tr class="apj-grand-total"><td colspan="11"></td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Champs cachés pour l'export -->
                    <input id="date1" type="hidden" value="<%= date1 %>" />
                    <input id="date2" type="hidden" value="<%= date2 %>" />
                    <input id="plage1" type="hidden" value="<%= grandLivre.getCompteDebut() %>" />
                    <input id="plage2" type="hidden" value="<%= grandLivre.getCompteFin() %>" />
                    <input id="exercice" type="hidden" value="<%= grandLivre.getExercice() %>" />
                    <input id="typecompte" type="hidden" value="<%= grandLivre.getTypeCompte() %>" />
                    <input id="etat" type="hidden" value="<%= grandLivre.getEtat() %>" />
                    <div class="box box-primary box-solid apj-export-forms">
                        <div id="export-body" class="box-body" style="display: block;">
                            <form id="form-export" action="../../../download" method="post">
                                <input type="hidden" name="ext" value="xls" checked="checked">
                                <input type="hidden" name="donnee" value="0" checked="checked">
                                <input type="hidden" name="specific_xls" value="true"/>
                                <input id="excel-input" type="hidden" name="table">
                            </form>
                            <form id="form-export-pdf" action="../../../EtatComptable?action=exportGrandLivrePDF&date1=<%=grandLivre.getDateDebut()%>&date2=<%=grandLivre.getDateFin()%>&plage1=<%=grandLivre.getCompteDebut()%>&plage2=<%=grandLivre.getCompteFin()%>&typecompte=<%=grandLivre.getTypeCompte()%>&exercice=<%=grandLivre.getExercice()%>&etat=<%=grandLivre.getEtat()%>" method="post">
                                <input id="excel-input-pdf" type="hidden" name="table" value="">
                                <input type="hidden" name="ext" value="pdf" checked="checked">
                                <input type="hidden" name="donnee" value="0" checked="checked">
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
    <% } // Fin du if (grandLivre != null) %>
</div>
<%
    // Fermeture propre de la connexion
    if (c != null) {
        try { c.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
<script>
    function exporter(){
        let exp = $('#ext').val();
        if(exp === 'xls'){
            document.location.replace("${pageContext.request.contextPath}/ExportExcel?action=grand_livre&date1=<%=date1%>&date2=<%=date2%>&plage1=<%=grandLivre.getCompteDebut()%>&plage2=<%=grandLivre.getCompteFin()%>&typecompte=<%=grandLivre.getTypeCompte()%>&exercice=<%=grandLivre.getExercice()%>&etat=<%=grandLivre.getEtat()%>&type=xls");
        }
        if(exp === 'pdf'){
            document.location.replace("${pageContext.request.contextPath}/EtatComptable?action=exportGrandLivrePDF&date1=<%=date1%>&date2=<%=date2%>&plage1=<%=compteParam%>&plage2=<%=compteParam%>&typecompte=<%=typeCompteParam%>&exercice=<%=grandLivre.getExercice()%>&etat=<%=grandLivre.getEtat()%>");
        }
    }
    function chargerExport() {
        var titre = "<h1>" + $('#titre-export').html() + "</h1>";
        var table = window.ApjAccountTable.prepareExport(document.getElementById('export'));
        var excel = titre + $('<div>').append(table).html();
        var excelInput = document.getElementById("excel-input");
        excelInput.value = excel;
    }
    function exporterCsv() {
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
<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>
