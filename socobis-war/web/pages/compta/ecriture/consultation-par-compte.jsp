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

<% 
    try {
    
    String lang = session.getAttribute("lang") != null ? session.getAttribute("lang").toString() : "fr";
    String lien = (String) session.getValue("lien");
    // Clés pour les filtres
    String[] mots = {"Generer etats", "Exercice", "Type de compte", "Type etat", "Mois debut", "Mois fin", "Compte", "Au compte", "Balance comparative", "Afficher"};
    String[] ret = Utilitaire.transformerLangue(mots, lang);
    if (ret == null) ret = mots;

    // Clés pour le tableau Grand Livre
    String[] motsGL = {"Consultation du compte", "au", "Compte", "Libelle du compte", "Journal", "Date", "Libelle", "Lettrage", "Mouvement", "Debit", "Credit", "Solde", "exporter"};
    String[] retGL = Utilitaire.transformerLangue(motsGL, lang);
    if (retGL == null) retGL = motsGL;

    String date1 = request.getParameter("dateDebut");
    String date2 = request.getParameter("dateFin");
    String compteParam = request.getParameter("compte");
    String typeCompteParam = request.getParameter("typeCompte");
    String lettrageParam = request.getParameter("lettrage");
    
    ComptaEtatGrandLivreGenerator grandLivre = null;
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
    }
%>

    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <jsp:include page='../../elements/css.jsp'/>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/apj-compta-list.css">
    
    <% if (errorMsg != null) { %>
    <style>
        .error-box { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 15px; margin: 20px; border-radius: 5px; font-family: monospace; }
    </style>
    <% } %>
    
    <script>

    var dataComptes = [];

    function chargerListeComptes() {
        $.ajax({
            url: '<%= request.getContextPath() %>/CompteServlet?action=getComptes',
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                dataComptes = data;
                initAutocompleteCompte('compte');
            },
            error: function(xhr, status, error) {
                console.error("Erreur lors du chargement des comptes: ", error);
            }
        });
    }
    function normaliserTexte(txt) {
        return txt.toUpperCase().normalize('NFD').replace(/[̀-ͯ]/g, '');
    }
    function initAutocompleteCompte(idinput) {
        $('#' + idinput).autocomplete({
            source: function (request, response) {
                var term = normaliserTexte(request.term);
                var matches = $.map(dataComptes, function (acItem) {
                    if (normaliserTexte(acItem.label).indexOf(term) !== -1 ||
                        normaliserTexte(acItem.value).indexOf(term) !== -1) {
                        return acItem;
                    }
                });
                response(matches.slice(0, 10));
            },
            minLength: 0,
            select: function (e, ui) {
                $('#' + idinput).val(ui.item.value); 
                $($('#page1')).val(ui.item.value); 
                $($('#page2')).val(ui.item.value); 
                return false;
            },
            change: function (e, ui) {
                var currentVal = $('#' + idinput).val();
                $('#' + idinput).val(currentVal.trim());
                $('#page1').val($('#' + idinput).val());
                $('#page2').val($('#' + idinput).val());
            }
        });
    }


        function getLastDayOfMonth(year, month) {
            return new Date(year, month, 0).getDate();
        }

        function toggleSelectCompte(checkbox) {
            var compte = checkbox.getAttribute('data-compte');
            var checked = checkbox.checked;
            document.querySelectorAll('.select-mouvement[data-compte="' + compte + '"]').forEach(function (cb) {
                cb.checked = checked;
            });
            updateSommeCompte(compte);
        }

        function updateSommeCompte() {
            var sommeDebit = 0;
            var sommeCredit = 0;
            document.querySelectorAll('.select-mouvement:checked').forEach(function (cb) {
                sommeDebit += parseFloat(cb.getAttribute('data-debit')) || 0;
                sommeCredit += parseFloat(cb.getAttribute('data-credit')) || 0;
            });
            var format = {minimumFractionDigits: 2, maximumFractionDigits: 2};
            document.getElementById('somme-debit-selection').textContent = sommeDebit.toLocaleString('fr-FR', format);
            document.getElementById('somme-credit-selection').textContent = sommeCredit.toLocaleString('fr-FR', format);
        }

        function afficherGrandLivre() {
            var exercice = $('#exercice').val();
            var typecompte = $('#typecompte').val();
            var compte = $('#compte').val();
            var moisMin = $('#moisMin').val();
            var moisMax = $('#moisMax').val();
            var lettrage = $('#lettrage').val();

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

            var url = "module.jsp?but=compta/ecriture/consultation-par-compte.jsp&&compte=" + encodeURIComponent(compte) +
                               "&compteDebut=" + encodeURIComponent(compte) +
                               "&compteFin=" + encodeURIComponent(compte) +
                               "&dateDebut=" + dateDebut +
                               "&dateFin=" + dateFin +
                               "&exercice=" + exercice +
                               "&typeCompte=" + typecompte + 
                               "&moisMin=" + moisMin +
                               "&moisMax=" + moisMax +
                               "&lettrage=" + lettrage;
            
            window.location.href = url;
        }

        $(document).ready(function () {
            chargerListeComptes();
            updateSommeCompte();
        });
    </script>



<div class="content-wrapper apj-compta-list">
 <section class="content-header"><h1><%=ret[0]%></h1></section>
    <div class="row m-0">
        <div class="col-md-12 cardradius mb-5">
            <div class="input-container">
                
                 <!-- Compte -->
                <div class="form-input">
                    <label class="input-label" for="compte"><%= ret[6] %></label>
                    <span class="d-flex gap-2">
                        <input type="text" id="compte" name="compte" class="form-control" placeholder="Ex: 411000"
                               value="<%= compteParam != null ? compteParam : "" %>"/>
                    </span>
                </div>
                <!-- Exercice -->
                <div class="form-input">
                    <label class="input-label" for="exercice"><%= ret[1] %></label>
                    <span class="d-flex gap-2">
                        <input type="text" id="exercice" name="exercice" class="form-control" 
                               value="<%= request.getParameter("exercice") != null ? request.getParameter("exercice") : Utilitaire.getAnneeEnCours() %>">
                    </span>
                </div>

              
               

                <!-- Mois min -->
                <div class="form-input">
                    <label class="input-label" for="moisMin"><%= ret[4] %></label>
                    <span class="d-flex gap-2">
                        <select name="moisMin" id="moisMin" class="form-control">
                            <% 
                                String selectedMin = request.getParameter("moisMin");
                                String[] moisNoms = {"", "Janvier", "Février", "Mars", "Avril", "Mai", "Juin", 
                                                     "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"};
                                for (int i = 1; i <= 12; i++) {
                                    String val = String.valueOf(i);
                                    String isSelected = (val.equals(selectedMin)) ? "selected" : "";
                            %>
                                <option value="<%=val%>" <%=isSelected%>><%=moisNoms[i]%></option>
                            <% } %>
                        </select>
                    </span>
                </div>

                <!-- Mois max -->
                <div class="form-input">
                    <label class="input-label" for="moisMax"><%= ret[5] %></label>
                    <span class="d-flex gap-2">
                        <select name="moisMax" id="moisMax" class="form-control">
                            <% 
                                String selectedMax = request.getParameter("moisMax");
                                if (selectedMax == null) selectedMax = "12";
                                for (int i = 1; i <= 12; i++) {
                                    String val = String.valueOf(i);
                                    String isSelected = (val.equals(selectedMax)) ? "selected" : "";
                            %>
                                <option value="<%=val%>" <%=isSelected%>><%=moisNoms[i]%></option>
                            <% } %>
                        </select>
                    </span>
                </div>

                <div class="form-input">
                    <label class="input-label" for="typecompte"><%= ret[2] %></label>
                    <span class="d-flex gap-2">
                        <select name="typecompte" id="typecompte" class="form-control">
                            <option value="1" <%= "1".equals(typeCompteParam) ? "selected" : "" %>>Général</option>
                            <option value="3" <%= "3".equals(typeCompteParam) ? "selected" : "" %>>Analytique</option>
                            <option value="2" <%= "2".equals(typeCompteParam) ? "selected" : "" %>>Auxilliaire</option>
                        </select>
                    </span>
                </div>

                <!-- Lettrage -->
                <div class="form-input">
                    <label class="input-label" for="lettrage">Lettrage</label>
                    <span class="d-flex gap-2">
                        <select name="lettrage" id="lettrage" class="form-control">
                            <option value="0" <%= "0".equals(lettrageParam) || lettrageParam == null ? "selected" : "" %>>Tous</option>
                            <option value="1" <%= "1".equals(lettrageParam) ? "selected" : "" %>>Lettr&eacute;</option>
                            <option value="2" <%= "2".equals(lettrageParam) ? "selected" : "" %>>Non lettr&eacute;</option>
                        </select>
                    </span>
                </div>

            </div>
            
            <div class="box-footer borderless nopadding" style="margin-top: 1rem;">
                <button type="button" class="btn btn-primary pull-right" style="margin-right: 0;" onclick="afficherGrandLivre()">
                    <%= ret[9] %>
                </button>
            </div>
        </div>
    </div>

    <% if (grandLivre != null) { %>
    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="">
                <div class="content">
                    <div class="apj-compta-toolbar">
                        <h3 class="h520pxSemibold title m-0" id="titre-export"><%= retGL[0] %> <%= grandLivre.getCompteDebut() %></h3>
                        <span style="margin-left: 30px;">Somme d&eacute;bit s&eacute;lection : <span id="somme-debit-selection">0</span></span>
                        <span style="margin-left: 30px;">Somme cr&eacute;dit s&eacute;lection : <span id="somme-credit-selection">0</span></span>
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
                                    <th class="contenuetable" ></th>
                                    <th class="contenuetable"></th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="<%= retGL[2] %>"><%= retGL[2] %></th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="ID Mouvement">R&eacute;f. Mouvement</th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="<%= retGL[5] %>"><%= retGL[5] %></th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="<%= retGL[4] %>/Folio"><%= retGL[4] %>/Folio</th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Contrep.">Contrep.</th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="<%= retGL[6] %> Oper."><%= retGL[6] %> Oper.</th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="<%= retGL[9] %>"><%= retGL[9] %></th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="<%= retGL[10] %>"><%= retGL[10] %></th>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="<%= retGL[7] %>"><%= retGL[7] %></th>
                                    <% if (grandLivre.getTypeCompte().compareToIgnoreCase("1") == 0) { %>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Compte analytique">Compte analytique</th>
                                    <% } else { %>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Compte général">Compte g&eacute;n&eacute;ral</th>
                                    <% } %>
                                    <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="État">&Eacute;tat</th>
                                </tr></thead>
                                <tbody>
                                <%  
                                    for (Map.Entry<String,ComptaCompte> listeComptes : grandLivre.getComptes().entrySet()) {
                                        ComptaCompte cc = listeComptes.getValue();
                                        List<ComptaSousEcriture> mouvements = cc.getMouvements();
                                        
                                        if (cc.getReportDebit() != 0 || cc.getReportCredit() != 0 || (mouvements != null && mouvements.size() > 0)) {
                                %>
                                <tr class="head apj-account-heading">
                                    <th colspan="13">
                                        <input type="checkbox" class="select-all-compte" data-compte="<%= cc.getCompte() %>" checked onclick="toggleSelectCompte(this)" aria-label="Tout sélectionner pour le compte <%= cc.getCompte() %>">
                                        <%= retGL[2] %> : <%= cc.getCompte()%>
                                        
                                    </th>
                                </tr>
                                <tr>
                                    <td colspan="6"></td>
                                    <td>Ancien cumul...</td>
                                    <td></td>
                                    <td><%= (cc.getReportDebit() == 0) ? "" : Utilitaire.formaterAr(cc.getReportDebit()) %></td>
                                    <td><%= (cc.getReportCredit() == 0) ? "" : Utilitaire.formaterAr(cc.getReportCredit()) %></td>
                                    <td></td>
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
                                    <td><input type="checkbox" class="select-mouvement" data-compte="<%= cc.getCompte() %>" data-debit="<%= comptaEcriture.getDebit() %>" data-credit="<%= comptaEcriture.getCredit() %>" value="<%= comptaEcriture.getIdMere() %>" checked onclick="updateSommeCompte(this.getAttribute('data-compte'))"></td>
                                    <td></td>
                                    <td><%= cc.getCompte()%></td>
                                    <td>
                                        <a href="<%= lien + "?but=compta/ecriture/ecriture-fiche.jsp&id=" + comptaEcriture.getIdMere() %>" target="_blank">
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
                                        <% if (comptaEcriture.getEtat() == 1) { out.print("Cr&eacute;&eacute;"); } 
                                           else if (comptaEcriture.getEtat() >= 11) { out.print("Vis&eacute;"); } %>
                                    </td>
                                </tr>
                                <% 
                                            } 
                                        } 
                                    }
                                %>
                                <tr>
                                    <td colspan="6"></td><td><b>TOTAL</b></td>
                                    <td></td>
                                    <td style="text-align: right"><b><%= Utilitaire.formaterAr(Utilitaire.arrondir((double) cc.getTotalDebit(), 2))%></b></td>
                                    <td style="text-align: right"><b><%= Utilitaire.formaterAr(Utilitaire.arrondir((double) cc.getTotalCredit(), 2))%></b></td>
                                    <td></td><td></td><td></td>
                                </tr>
                                <tr>
                                    <td colspan="6"></td>
                                    <td><b>CUMUL</b></td>
                                    <td></td>
                                    <td style="text-align: right"><b><%= Utilitaire.formaterAr(Utilitaire.arrondir((double) cc.getReportDebit(), 2))%></b></td>
                                    <td style="text-align: right"><b><%= Utilitaire.formaterAr(Utilitaire.arrondir((double) cc.getReportCredit(), 2))%></b></td>
                                    <td></td><td></td><td></td>
                                </tr>
                                <tr class="table-apj-footer">
                                    <td colspan="6"></td>
                                    <td><b><%= retGL[11] %></b></td>
                                    <td></td>
                                    <td style="text-align: right"><b><%= (cc.getSoldeDebit() == 0) ? "" : Utilitaire.formaterAr(Utilitaire.arrondir((double) cc.getSoldeDebit(), 2)) %></b></td>
                                    <td style="text-align: right"><b><%= (cc.getSoldeCredit() == 0) ? "" : Utilitaire.formaterAr(Utilitaire.arrondir((double) cc.getSoldeCredit(), 2)) %></b></td>
                                    <td colspan="3"></td>
                                </tr>
                                <% 
                                        } 
                                    } 
                                %>
                                <tr class="apj-grand-total">
                                    <th colspan="6"></th>
                                    <th>Total</th>
                                    <th></th>
                                    <th style="text-align: right"> <%= Utilitaire.formaterAr(Utilitaire.arrondir((double) grandLivre.getTotalDebit(), 2)) %></th>
                                    <th style="text-align: right"> <%= Utilitaire.formaterAr(Utilitaire.arrondir((double) grandLivre.getTotalCredit(), 2)) %></th>
                                    <th colspan="3"></th>
                                </tr>
                                <tr class="apj-grand-total"><td colspan="13"></td></tr>
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
        out.println("<div class='error-box'>Erreur fatale: " + e.getMessage() + "</div>");
    }
%>
