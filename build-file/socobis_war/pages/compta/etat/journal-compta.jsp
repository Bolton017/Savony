<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="bean.CGenUtil"%>
<%@page import="utilitaire.Utilitaire" %>
<%@page import="java.sql.Date" %>
<%@page import="java.util.*" %>
<%@page import="affichage.PageInsert" %>
<%@page import="bean.AdminGen"%>
<%@ page import="mg.cnaps.compta.*" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.apache.commons.lang3.StringEscapeUtils" %>

<%
    String lang = String.valueOf(session.getAttribute("lang"));
    String[] ret = {"Balance des comptes", "au", "Compte", "Intitule du compte", "Cumul DB", "Cumul CR", "Mouvement DB", "Mouvement CR", "Solde DB", "Solde CR", "exporter"};

    String journal = request.getParameter("journal");
    String mois = request.getParameter("mois");
    String annee = request.getParameter("annee");

    JournalLib temp = new JournalLib(journal, Integer.parseInt(mois),Integer.parseInt(annee));

    ComptaSousEcritureLibJournal [] detail = temp.getDetail();
    detail = temp.formaterData(detail);
    String moislib = Utilitaire.nbToMois(Integer.parseInt(mois));
    String nomTable = "COMPTA_SOUSECRITURE_LIB_J";
    String awhere = " AND idjournal= '"+journal+"' AND mois="+mois+" AND annee="+annee;
    String requete = "select * from (select id,numero,compte,journal,idJournal,ecriture,daty,credit,debit,dateComptable,exercice,remarque,etat,idMere,horsExercice,od,origine,libellePiece,compte_aux,folio,lettrage,analytique,designationmere,jour,annee,rowNum as r from (select * from "+nomTable+" where 1<2 "+awhere+" order by IDMERE))";
    Gson gson = new Gson();
    String[] libEntete = {"idMere","jour","designationmere","daty", "compte", "debit","credit"};
    String[] libEnteteAffiche = {"N&deg; &Eacute;criture", "Jour", "D&eacute;signation", "Date" ,"Compte","D&eacute;bit","Cr&eacute;dit"};
    String[] libEnteteExcel = {"N\u00b0 \u00c9criture", "Jour", "D\u00e9signation", "Date", "Compte", "D\u00e9bit", "Cr\u00e9dit"};

%>

<meta charset="UTF-8">
<title>Journaux du <%= moislib %> <%= annee %></title>
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
<jsp:include page='../../elements/css.jsp'/>
<style>
    .journal-compta-page.content-wrapper {
        margin: 0 !important;
        min-height: 100vh;
        padding: 20px;
    }
    .journal-compta-page .content-header { margin-bottom: 20px; }
    .journal-compta-page .journal-toolbar {
        display: flex;
        align-items: center;
        justify-content: space-between;
        flex-wrap: wrap;
        gap: 8px;
        margin-bottom: 16px;
    }
    .journal-compta-page .journal-actions { display: flex; flex-wrap: wrap; gap: 8px; }
    .journal-compta-page .box.table-box { margin-bottom: 0; }
    .journal-compta-page .journal-table-scroll { overflow-x: auto; }
    .journal-compta-page #journal-table { margin-bottom: 0; min-width: 700px; }
    .journal-compta-page #journal-table th,
    .journal-compta-page #journal-table td { padding: 10px 12px; }
    .journal-compta-page #journal-table th:nth-child(6),
    .journal-compta-page #journal-table th:nth-child(7),
    .journal-compta-page #journal-table td:nth-child(6),
    .journal-compta-page #journal-table td:nth-child(7) { text-align: right !important; white-space: nowrap; }
    .journal-compta-page #journal-table tfoot td { font-weight: 600; background: var(--Background-tertiaire); }
    .journal-compta-page #journal-table tfoot td:nth-last-child(-n+2) { text-align: right !important; }
    .journal-compta-page #journal-table .idmere { cursor: pointer; color: var(--Primaire-blue-main-color); }
    .journal-compta-page #journal-table .journal-page-hidden { display: none; }
    .journal-compta-page .apj-table-column-filter-summary { display: flex; align-items: center; gap: 6px; min-height: 30px; }
    .journal-compta-page .apj-table-column-filter-label { flex: 1; min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; font-size: 12px; }
    .journal-compta-page .apj-table-column-filter-toggle {
        display: inline-grid; place-items: center; flex: 0 0 auto;
        width: 28px; height: 28px; padding: 0; border: 0; border-radius: 7px;
        background: transparent; color: var(--Text-secondary); cursor: pointer;
    }
    .journal-compta-page .apj-table-column-filter-toggle:hover,
    .journal-compta-page .apj-table-column-filter-toggle:focus-visible { background: var(--Background-tertiaire); color: var(--Text-primary); }
    .journal-compta-page .apj-table-column-filter-toggle i { font-size: 15px; }
    .journal-compta-page .apj-table-column-filter.is-active .apj-table-column-filter-toggle { background: var(--Primaire-blue-main-color); color: #fff; }
    .journal-compta-page .apj-table-column-filter.is-active .apj-table-column-filter-toggle::after {
        content: ''; position: absolute; top: 3px; right: 3px;
        width: 5px; height: 5px; border-radius: 50%; background: #fff;
    }
    .journal-compta-page .apj-table-column-filter-toggle { position: relative; }
    .journal-compta-page .apj-table-column-filter-editor { display: none; position: relative; }
    .journal-compta-page .apj-table-column-filter.is-editing .apj-table-column-filter-summary { display: none; }
    .journal-compta-page .apj-table-column-filter.is-editing .apj-table-column-filter-editor { display: flex; }
    .journal-compta-page .apj-table-column-filter-input {
        width: 100%; min-width: 76px; height: 30px; padding: 0 28px 0 8px;
        border: 1px solid var(--Border); border-radius: 7px;
        background: var(--Background-primaire); color: var(--Text-primary); font: inherit;
    }
    .journal-compta-page .apj-table-column-filter-cancel {
        position: absolute; right: 3px; top: 2px; width: 25px; height: 25px;
        padding: 0; border: 0; border-radius: 50%; background: transparent;
        color: var(--Text-secondary); font-size: 18px; cursor: pointer;
    }
    .journal-compta-page .pagination-bas-page { flex-wrap: wrap; }
    .journal-compta-page .pagination-bas-page .pagination-title { white-space: normal; }
    @media (max-width: 600px) {
        .journal-compta-page .journal-actions { width: 100%; }
        .journal-compta-page .journal-actions .btn { flex: 1; }
    }
</style>
<div class="content-wrapper journal-compta-page">
    <section class="content-header">
        <h1 class="title">Journaux du <%= moislib %> <%= annee %></h1>
    </section>
    <section class="content">
        <div class="journal-toolbar">
            <div class="journal-actions">
                <a class="btn btn-secondary btn-bg-white btn-small"
                   href="?journal=<%= java.net.URLEncoder.encode(journal, "UTF-8") %>&amp;mois=<%= (Integer.parseInt(mois) == 1 ? 12 : Integer.parseInt(mois) - 1) %>&amp;annee=<%= (Integer.parseInt(mois) == 1 ? Integer.parseInt(annee) - 1 : Integer.parseInt(annee)) %>">
                    <i class="material-symbols-rounded">chevron_left</i> Précédent
                </a>
                <a class="btn btn-secondary btn-bg-white btn-small"
                   href="?journal=<%= java.net.URLEncoder.encode(journal, "UTF-8") %>&amp;mois=<%= (Integer.parseInt(mois) == 12 ? 1 : Integer.parseInt(mois) + 1) %>&amp;annee=<%= (Integer.parseInt(mois) == 12 ? Integer.parseInt(annee) + 1 : Integer.parseInt(annee)) %>">
                    Suivant <i class="material-symbols-rounded">chevron_right</i>
                </a>
            </div>
            <button type="button" class="btn btn-secondary btn-bg-white btn-small filtre-btn" onclick="exporterCsv()">
                <i class="material-symbols-rounded">file_export</i> Exporter en Excel
            </button>
        </div>

        <div id="table-container" class="box table-box" data-apj-filter-root="">
            <div class="box-body table-responsive no-padding">
                <div id="selectnonee" class="journal-table-scroll">
                    <table id="journal-table" class="table table-hover table-striped" data-apj-filter-table="">
                        <thead><tr class="head">
                            <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="N° écriture">N° écriture</th>
                            <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Jour">Jour</th>
                            <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Libellé">Libell&eacute;</th>
                            <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Date">Date</th>
                            <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Compte">Compte</th>
                            <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Débit">D&eacute;bit</th>
                            <th class="contenuetable" data-apj-filter-column="" data-apj-filter-label="Crédit">Cr&eacute;dit</th>
                        </tr></thead>
                        <tbody>
                        <%
                            if (detail.length == 0) {
                                out.println("<tr><td colspan=\"7\">Aucune donnée disponible</td></tr>");
                            }
                            int journalEntryIndex = 0;
                            for (int i = 0; i < detail.length; i++) {
                                if (detail[i].getIdMere() != null && !detail[i].getIdMere().isEmpty()) {
                                    journalEntryIndex++;
                                }
                                String ligne = detail[i].makeLigne();
                                out.println(ligne.replaceFirst("<tr>", "<tr data-journal-entry=\"" + journalEntryIndex + "\">"));
                            }
                        %>
                        <tr id="journal-filter-empty" style="display:none"><td colspan="7">Aucun résultat pour ces filtres</td></tr>
                        </tbody>
                        <tfoot><tr>
                            <td colspan="3"><%= temp.getTotal() %> &eacute;critures</td>
                            <td colspan="2">Totaux journal <%= mois %>/<%= annee %></td>
                            <td><%= Utilitaire.formaterAr(AdminGen.calculSommeDouble(detail,"debit")) %></td>
                            <td><%= Utilitaire.formaterAr(AdminGen.calculSommeDouble(detail,"credit")) %></td>
                        </tr></tfoot>
                    </table>
                </div>
            </div>
        </div>
        <div class="pagination-bas-page" id="journal-pagination" data-total-entries="<%= temp.getTotal() %>">
            <label class="apj-npp-control">
                <span class="apj-npp-label" multi-lang="">Résultats par page</span>
                <select class="apj-npp-select" id="journal-npp" aria-label="Nombre de résultats par page">
                    <option value="0" selected="selected">0</option>
                    <option value="25">25</option>
                    <option value="50">50</option>
                    <option value="100">100</option>
                    <option value="200">200</option>
                </select>
            </label>
            <h3 class="Body12pxRegular pagination-title m-0" id="journal-pagination-count" aria-live="polite"></h3>
            <nav aria-label="Pagination du journal"><ul class="pagination">
                <li><span class="page-link btn btn-secondary btn-small" id="journal-page-state"></span></li>
                <li class="page-item" id="journal-prev-item"><button type="button" class="page-link btn btn-secondary btn-small" id="journal-prev" aria-label="Page précédente"><i class="material-symbols-rounded">chevron_left</i></button></li>
                <li class="page-item" id="journal-next-item"><button type="button" class="page-link btn btn-secondary btn-small" id="journal-next" aria-label="Page suivante"><i class="material-symbols-rounded">chevron_right</i></button></li>
                <li class="apj-expand-page-item"><button type="button" class="page-link btn btn-secondary btn-small" id="journal-expand" aria-label="Agrandir le tableau"><i class="expand-icon material-symbols-rounded">unfold_more</i></button></li>
            </ul></nav>
        </div>

        <form id="form-export" action="<%= request.getContextPath() %>/download" method="post" target="_blank">
                        <input id="excel-input" type="hidden" name="table" value="">
                            <input type="hidden" name="ext" value="xls" checked="checked">
                            <input type="hidden" name="donnee" value="0" checked="checked">
                            <input type="hidden" name="specific_xls" value="true"/>
                            <input type="hidden" name="className" value="mg.cnaps.compta.ComptaSousEcritureLibJournal"/>
                            <input type="hidden" name="nomTable" value="<%=nomTable%>"/>
                            <input type="hidden" name="requete" value="<%=requete%>"/>
                            <input type="hidden" name="colonneExcel" value="<%= StringEscapeUtils.escapeHtml4(gson.toJson(libEntete)) %>"/>
                            <input type="hidden" name="libColonneExcel" value="<%= StringEscapeUtils.escapeHtml4(gson.toJson(libEnteteExcel)) %>"/>
                            <input type="hidden" name="titre" value="Journaux du <%= moislib %> <%= annee %>"/>
        </form>

        <form id="form-export-pdf" action="<%= (String) session.getValue("lien") %>/../../EtatComptable?action=etatComptablePDF" method="post">
                            <input id="excel-input-pdf" type="hidden" name="table" value="">
                            <input type="hidden" name="ext" value="pdf" checked="checked">
                            <input type="hidden" name="donnee" value="0" checked="checked">
                            <input type="hidden" name="className" value="mg.cnaps.compta.ComptaSousEcritureLibJournal"/>

                            <input type="hidden" value="Exporter" class="btn btn-default">
        </form>

    </section>
</div>
<script>
    (function () {
        var pagination = document.getElementById('journal-pagination');
        var table = document.getElementById('journal-table');
        var select = document.getElementById('journal-npp');
        var count = document.getElementById('journal-pagination-count');
        var state = document.getElementById('journal-page-state');
        var previous = document.getElementById('journal-prev');
        var next = document.getElementById('journal-next');
        var expand = document.getElementById('journal-expand');
        var rows = table.querySelectorAll('tbody tr[data-journal-entry]');
        var emptyFilterRow = document.getElementById('journal-filter-empty');
        var total = parseInt(pagination.getAttribute('data-total-entries'), 10) || 0;
        var page = 1;
        var filters = {};
        var groupRows = {};
        var entryOrder = [];
        var filterControls = [];

        for (var r = 0; r < rows.length; r++) {
            var entryId = rows[r].getAttribute('data-journal-entry');
            if (!groupRows[entryId]) {
                groupRows[entryId] = [];
                entryOrder.push(entryId);
            }
            groupRows[entryId].push(rows[r]);
        }

        function normalize(value) {
            return String(value || '').normalize('NFD').replace(/[\u0300-\u036f]/g, '')
                .toLocaleLowerCase('fr').replace(/\s+/g, ' ').trim();
        }

        function closeFilter(control) {
            control.classList.remove('is-editing');
            control.querySelector('.apj-table-column-filter-toggle').setAttribute('aria-expanded', 'false');
        }

        var headers = table.querySelectorAll('thead th[data-apj-filter-column]');
        for (var h = 0; h < headers.length; h++) {
            (function (header, index) {
                var label = header.getAttribute('data-apj-filter-label');
                var inputId = 'journal-column-filter-' + index;
                var control = document.createElement('div');
                control.className = 'apj-table-column-filter';
                control.innerHTML = '<div class="apj-table-column-filter-summary">' +
                    '<span class="apj-table-column-filter-label"></span>' +
                    '<button type="button" class="apj-table-column-filter-toggle" aria-label="Filtrer ' + label + '" aria-controls="' + inputId + '" aria-expanded="false" aria-pressed="false"><i class="material-symbols-rounded">search</i></button></div>' +
                    '<div class="apj-table-column-filter-editor"><input type="text" class="apj-table-column-filter-input" id="' + inputId + '" autocomplete="off" aria-label="Filtrer ' + label + '"><button type="button" class="apj-table-column-filter-cancel" aria-label="Effacer le filtre ' + label + '">&times;</button></div>';
                control.querySelector('.apj-table-column-filter-label').textContent = header.textContent;
                header.textContent = '';
                header.appendChild(control);

                var toggle = control.querySelector('.apj-table-column-filter-toggle');
                var input = control.querySelector('.apj-table-column-filter-input');
                var cancel = control.querySelector('.apj-table-column-filter-cancel');
                filterControls.push(control);

                toggle.addEventListener('click', function () {
                    var opening = !control.classList.contains('is-editing');
                    for (var c = 0; c < filterControls.length; c++) { closeFilter(filterControls[c]); }
                    if (opening) {
                        control.classList.add('is-editing');
                        toggle.setAttribute('aria-expanded', 'true');
                        input.focus();
                        input.select();
                    }
                });
                input.addEventListener('input', function () {
                    var value = normalize(input.value);
                    if (value) { filters[index] = value; } else { delete filters[index]; }
                    control.classList.toggle('is-active', !!value);
                    toggle.setAttribute('aria-pressed', value ? 'true' : 'false');
                    page = 1;
                    renderPage();
                });
                input.addEventListener('keydown', function (event) {
                    if (event.key === 'Escape') { closeFilter(control); toggle.focus(); }
                });
                cancel.addEventListener('click', function () {
                    if (input.value) {
                        input.value = '';
                        input.dispatchEvent(new Event('input'));
                        input.focus();
                    } else {
                        closeFilter(control);
                        toggle.focus();
                    }
                });
            })(headers[h], h);
        }

        document.addEventListener('click', function (event) {
            for (var c = 0; c < filterControls.length; c++) {
                if (!filterControls[c].contains(event.target)) { closeFilter(filterControls[c]); }
            }
        });

        function renderPage() {
            var pageSize = parseInt(select.value, 10) || 0;
            var matchingEntries = entryOrder.filter(function (entry) {
                return Object.keys(filters).every(function (column) {
                    return groupRows[entry].some(function (row) {
                        return normalize(row.cells[Number(column)].textContent).indexOf(filters[column]) !== -1;
                    });
                });
            });
            var pageCount = pageSize === 0 ? 1 : Math.max(1, Math.ceil(matchingEntries.length / pageSize));
            page = Math.min(page, pageCount);
            var first = pageSize === 0 ? 0 : (page - 1) * pageSize;
            var visibleEntries = pageSize === 0 ? matchingEntries : matchingEntries.slice(first, first + pageSize);
            var visible = {};
            for (var e = 0; e < visibleEntries.length; e++) { visible[visibleEntries[e]] = true; }

            for (var i = 0; i < rows.length; i++) {
                rows[i].classList.toggle('journal-page-hidden', !visible[rows[i].getAttribute('data-journal-entry')]);
            }
            emptyFilterRow.style.display = total > 0 && matchingEntries.length === 0 ? '' : 'none';

            count.textContent = visibleEntries.length + ' résultats sur ' + matchingEntries.length;
            state.textContent = 'Page: ' + page + ' sur ' + pageCount;
            previous.disabled = page === 1;
            next.disabled = page === pageCount;
            previous.parentNode.classList.toggle('disabled', previous.disabled);
            next.parentNode.classList.toggle('disabled', next.disabled);
        }

        select.addEventListener('change', function () { page = 1; renderPage(); });
        previous.addEventListener('click', function () { if (page > 1) { page--; renderPage(); } });
        next.addEventListener('click', function () { page++; renderPage(); });
        expand.addEventListener('click', function () {
            var expanded = document.getElementById('table-container').classList.toggle('expand');
            expand.querySelector('.expand-icon').textContent = expanded ? 'unfold_less' : 'unfold_more';
            expand.setAttribute('aria-label', expanded ? 'Réduire le tableau' : 'Agrandir le tableau');
            expand.setAttribute('aria-expanded', expanded ? 'true' : 'false');
        });
        renderPage();
    })();
</script>
<script>

    function openEcriture(content) {
        var url = '<%= request.getContextPath() %>/pages/module.jsp?but=compta/ecriture/ecriture-fiche.jsp&id=' + encodeURIComponent(content);
        window.open(url, "", "titulaireresizable=no,scrollbars=yes,location=no,width=1009,height=532,top=0,left=0");
    }
</script>


<script>
    function chargerExportPDF() {
        var titre = "<h1>" + $('.journal-compta-page .title').first().text() + "</h1>";
        var $table = $('#journal-table').clone();
        $table.find('.journal-page-hidden').removeClass('journal-page-hidden');
        $table.find('#journal-filter-empty').remove();
        $table.find('thead th[data-apj-filter-label]').each(function () {
            $(this).text($(this).attr('data-apj-filter-label'));
        });
        var excel = titre + $('<div>').append($table).html();
        var excelInput = document.getElementById("excel-input-pdf");
        excelInput.value = excel;
    }

        function chargerExport() {
        var titreTexte = $('.journal-compta-page .title').first().text() || 'Export';
        var $table = $('#table-container table').first().clone();
        $table.find('.journal-page-hidden').removeClass('journal-page-hidden');
        $table.find('#journal-filter-empty').remove();
        $table.find('thead th[data-apj-filter-label]').each(function () {
            $(this).text($(this).attr('data-apj-filter-label'));
        });

        $table.find('tr').each(function () {
        $(this).find('td:eq(5), td:eq(6), th:eq(5), th:eq(6)').addClass('right');
        $(this).find('td:eq(1), th:eq(1), td:eq(3), th:eq(3)').addClass('center');
    });


        var excelHtml = `
<!DOCTYPE html>
<html xmlns:o="urn:schemas-microsoft-com:office:office"
      xmlns:x="urn:schemas-microsoft-com:office:excel"
      xmlns="http://www.w3.org/TR/REC-html40">
<head>
<meta charset="UTF-8">
<!--[if gte mso 9]>
<xml>
<x:ExcelWorkbook>
  <x:ExcelWorksheets>
    <x:ExcelWorksheet>
      <x:Name>Journal</x:Name>
      <x:WorksheetOptions>
        <x:Selected/>
        <x:ProtectContents>False</x:ProtectContents>
        <x:ProtectObjects>False</x:ProtectObjects>
        <x:ProtectScenarios>False</x:ProtectScenarios>
      </x:WorksheetOptions>
    </x:ExcelWorksheet>
  </x:ExcelWorksheets>
</x:ExcelWorkbook>
</xml>
<![endif]-->
<style>
  table { border-collapse: collapse; table-layout: fixed; width: 100%; }
  th, td { border: 1px solid #444; padding: 4px; vertical-align: top; }
  thead th { background: #f2f2f2; font-weight: bold; }
  .right { text-align: right; mso-number-format:"\\#\\,\\#\\#0.00"; }
  .center { text-align: center; }
  col.col-idx   { width: 60px;  }
  col.col-jour  { width: 50px;  }
  col.col-lib   { width: 400px; }
  col.col-date  { width: 90px;  }
  col.col-cpte  { width: 120px; }
  col.col-mont  { width: 120px; }
</style>
</head>
<body>
  <h2>` + titreTexte + `</h2>
  ` + (function () {
        var $t = $table;
        if ($t.find('colgroup').length === 0) {
        var colgroup = `
              <colgroup>
                <col class="col-idx">
                <col class="col-jour">
                <col class="col-lib">
                <col class="col-date">
                <col class="col-cpte">
                <col class="col-mont">
                <col class="col-mont">
              </colgroup>`;
        $t.prepend(colgroup);
    }
        return $('<div>').append($t).html();
    })() + `
</body>
</html>`;
        var excelInput = document.getElementById("excel-input");
        excelInput.value = excelHtml;
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


    function prePrint() {
        if (window.print) {
            window.print();
        } else {
            alert('Votre navigateur ne supporte pas cette action');
        }
    }
</script>
