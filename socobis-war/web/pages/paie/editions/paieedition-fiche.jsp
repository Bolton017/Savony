<%@ page import="paie.edition.FichePaie"%>
<%@ page import="paie.edition.PaieEditionEltpaie" %>
<%@ page import="java.util.List" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="paie.edition.MappingElementPaie" %>
<%@ page import="utils.ConstantePaie" %>

<%
    try {
        FichePaie fp = new FichePaie();
        String idedition = null;
        String idPers = null;
        if (request.getParameter("id") != null) {
            String concat = request.getParameter("id");
            String[] parts = concat.split("\\/\\/");
            idPers = parts[0];
            idedition = parts[1];
        }

        // all fiche de paie for all employee for a given idEdition
        List<FichePaie> allFichePaies = fp.getListFichePaieEdition(idedition);

        // months and year is retrieved form idedition
        FichePaie fiche = fp.getListFichePaieEditionPersonnel(idedition, idPers);
        List<PaieEditionEltpaie> lsElmtPaie = fiche.getListeElementPaie();

        if (lsElmtPaie == null || lsElmtPaie.size() == 0) {
            throw new Exception("Pas de fiche de paie a consulter");
        }

        MappingElementPaie mapping = MappingElementPaie.getValeurElementDePaie(lsElmtPaie);
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Fiche de Paie - ASSURANCE ARO</title>
    <style>

        * {
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #fff;
            padding: 0;
            margin: 0;
        }

        .payslip-container {
            max-width: 750px;
            margin: 0 auto;
            background: #fff;
            padding: 50px;
            border: 1px solid #000000;
        }

        .clearfix:after {
            content: "";
            display: table;
            clear: both;
        }

        .header {
            margin-bottom: 15px;
        }

        .header:after {
            content: "";
            display: table;
            clear: both;
        }

        .company-logo {
            float: left;
            width: 60%;
            display: flex;
            align-items: center;
        }

        .company-logo img {
            max-height: 50px;
            max-width: 200px;
            height: auto;
            width: auto;
            object-fit: contain;
        }

        .company-logo .fallback-text {
            font-size: 18px;
            font-weight: bold;
            display: none; /* Hidden by default, shown if image fails to load */
        }

        .company-logo .fallback-text span {
            font-style: italic;
            font-weight: normal;
            font-size: 11px;
            display: block;
        }

        .company-address {
            float: right;
            width: 40%;
            text-align: right;
            font-size: 10px;
        }

        .title {
            text-align: center;
            font-size: 16px;
            font-weight: bold;
            text-decoration: underline;
            margin: 20px 0;
            clear: both;
        }

        .info-section {
            padding: 10px;
            border: 1px solid #c3c3c3;
        }

        .info-section:after {
            content: "";
            display: table;
            clear: both;
        }

        .employee-info {
            float: left;
            width: 60%;
            padding-right: 20px;
        }

        .employee-info-grid {
            font-size: 14px;
        }

        .employee-info-grid table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 5px 5px;
        }

        .employee-info-grid td {
            vertical-align: top;
            padding: 2px 0;
        }

        .employee-info-grid label {
            font-weight: bold;
            width: 95%;
        }

        .conges-table {
            float: right;
            width: 40%;
        }

        .conges-table table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
        }

        .conges-table th, .conges-table td {
            border: 1px solid #000;
            padding: 4px;
            text-align: center;
        }

        .conges-table th {
            background-color: #e0e0e0;
        }

        .conges-table td:first-child {
            text-align: left;
            font-weight: bold;
        }

        .paie-details {
            width: 100%;
            margin-top: 15px;
            border-collapse: collapse;
            font-size: 11px;
            clear: both;
        }

        .paie-details th, .paie-details td {
            padding: 4px 6px;
            border: 1px solid #ccc;
        }

        .paie-details .section-header th {
            background-color: #e0e0e0;
            text-align: left;
            font-weight: bold;
        }

        .paie-details .section-header .amount {
            text-align: right;
        }

        .paie-details td {
            word-wrap: break-word;
        }

        .paie-details .data-row td:nth-child(2),
        .paie-details .data-row td:nth-child(3) {
            text-align: right;
        }

        .paie-details .net-salary-row th,
        .paie-details .net-salary-row td {
            background-color: #58a618;
            font-weight: bold;
            border: 1px solid #000;
            padding: 6px;
        }

        .final-total {
            text-align: right;
            margin-top: 4px;
            font-size: 10px;
        }

        .footer {
            margin-top: 20px;
            font-size: 11px;
            overflow: auto; /* Ensure content is contained */
        }

        .footer .label {
            font-weight: bold;
            color: #000; /* Explicit text color */
            display: block; /* Ensure labels are block-level for visibility */
        }

        .footer-left, .footer-center, .footer-right {
            width: 33.33%;
            float: left;
            box-sizing: border-box;
        }

        .footer-left {
            padding-right: 10px;
        }

        .footer-center {
            text-align: center;
            font-size: 8px;
        }

        .footer-center .logo {
            font-size: 14px;
            font-weight: bold;
        }

        .footer-center .footer-logo {
            max-height: 30px;
            max-width: 100px;
            height: auto;
            width: auto;
            object-fit: contain;
            margin-bottom: 5px;
        }

        .footer-right {
            text-align: center;
        }

        .footer .signature-line {
            border-bottom: 1px solid #000;
            height: 30px;
            margin: 8px 0;
        }

        .company-stamp {
            text-align: center;
            font-size: 8px;
        }

        .manager-signature {
            text-align: center;
        }

        .manager-signature .signature {
            font-family: 'Brush Script MT', cursive;
            font-size: 24px;
        }

        /* CSS for centered export button */
        .export-btn-container {
            text-align: center;
            margin: 20px 0;
            padding: 20px;
        }

        /* Responsive logo adjustments */
        @media print {
            .company-logo img {
                max-height: 40px;
            }
            .footer-center .footer-logo {
                max-height: 25px;
            }
        }

        /* Hidden containers for all payslips */
        .hidden-payslip {
            position: absolute;
            left: -9999px;
            top: -9999px;
            width: 750px;
        }
    </style>
</head>
<body>

<div class="content-wrapper">
    <div class="payslip-container" id="payslip-content">
        <div class="header clearfix">
            <div class="company-logo">

                <img src="${pageContext.request.contextPath}/assets/img/LOGO-512.png" alt="ASSURANCE ARO Logo" onerror="this.style.display='none'; this.nextElementSibling.style.display='block'; width='75px;'; height='75px;'">
                <div class="fallback-text">
                    ASSURANCE ARO
                </div>
            </div>
            <div class="company-address">
                T&eacute;l.: 034 42 276 10<br>
                Assurance Aro Ampefiloha <br>
                101 - ANTANANARIVO
            </div>
        </div>

        <div class="title">FICHE DE PAIE</div>

        <div class="info-section clearfix">
            <div class="employee-info">
                <div class="employee-info-grid">
                    <table>
                        <tr><td><label>Mois de :</label></td><td><%= Utilitaire.convertDebutMajuscule(fiche.getMois()) %> - <%= fiche.getAnnee() %></td></tr>
                        <tr><td><label>Noms et pr&eacute;noms :</label></td><td><%= fiche.getNom() %></td></tr>
                        <tr><td><label>Fonction :</label></td><td><%= fiche.getFonction() %></td></tr>
                        <tr><td><label>Num Matricule :</label></td><td><%= fiche.getMatricule() %></td></tr>
                        <tr><td><label>Cat&eacute;gorie professionnelle :</label></td><td><%= MappingElementPaie.getCategorieQualif(fiche.getFonction()) %></td></tr>
                    </table>
                </div>
            </div>
            <div class="conges-table">
                <table>
                    <thead><tr><th colspan="2">CONGES</th></tr></thead>
                    <tbody>
                    <tr><td>Acquis :</td><td>2,5</td></tr>
                    <tr><td>Pris :</td><td><%= fiche.getConger() %></td></tr>
                    <tr><td>Pay&eacute; :</td><td>0,0</td></tr>
                    <tr><td>Solde :</td><td>2,5</td></tr>
                    <tr><td>Cong&eacute; Mat. :</td><td>0,0</td></tr>
                    <tr><td>Anciennet&eacute; :</td><td>0,0</td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <table class="paie-details">
            <tr class="section-header">
                <th colspan="2">El&eacute;ments positifs</th>
                <th class="amount"><%= Utilitaire.formaterAr(mapping.getTotalGains())%></th>
            </tr>
            <tr class="data-row"><td>Salaire de base</td><td><%= ConstantePaie.heureLegale %></td><td><%= Utilitaire.formaterAr(mapping.getSalaireDeBase())%></td></tr>
            <tr class="data-row"><td>Salaire du mois arrondi pour calcul net</td><td><%= mapping.getHeureReels() %></td><td><%= Utilitaire.formaterAr(mapping.getSalaierDuMoisArrondi())%></td></tr>
            <tr class="data-row"><td>Retenu sur absences</td><td></td><td>-</td></tr>
            <tr class="data-row"><td>Rappel :</td><td></td><td>-</td></tr>
            <tr class="data-row"><td>Cong&eacute;s pay&eacute; :</td><td></td><td><%= mapping.getCongePaye() %></td></tr>
            <tr class="data-row"><td>Pr&eacute;avis</td><td></td><td>-</td></tr>
            <tr class="data-row"><td>Allocation familiales; :</td><td></td><td><%= Utilitaire.formaterAr(mapping.getAllocation())%></td></tr>
            <tr class="data-row"><td>Indemnit&eacute;s diverses</td><td></td><td><%= Utilitaire.formaterAr(mapping.getIndemnite())%></td></tr>
            <tr class="data-row"><td>Heures Suppl&eacute;mentaires : <span>+jours f&eacute;ri&eacute;s</span></td><td></td><td><%= Utilitaire.formaterAr(mapping.getTotalHS())%></td></tr>
            <tr class="data-row"><td>Primes :</td><td></td><td><%= Utilitaire.formaterAr(mapping.getPrime()) %></td></tr>

            <tr class="section-header">
                <th colspan="2">D&eacute;ductions r&eacute;glementaires</th>
                <th class="amount"><%= Utilitaire.formaterAr(mapping.getTotalRetenues())%></th>
            </tr>

            <tr class="data-row"><td>Avance : <span>(Quinzaine & Sp&eacute;ciale)</span></td><td></td><td><%= Utilitaire.formaterAr(mapping.getAvanceTotale())%></td></tr>
            <tr class="data-row"><td>Retenue CNaPS :</td><td></td><td><%= Utilitaire.formaterAr(mapping.getCnaps()) %></td></tr>
            <tr class="data-row"><td>Retenue OSTIE :</td><td></td><td><%= Utilitaire.formaterAr(mapping.getOstie()) %></td></tr>
            <tr class="data-row"><td>IRSA : <span>(Apr&egrave;s abattement et r&eacute;duction enfants &agrave; charge)</span></td><td></td><td><%= Utilitaire.formaterAr(mapping.getIrsa())%></td></tr>
            <tr class="data-row"><td>Autres d&eacute;ductions :</td><td></td><td>-</td></tr>

            <tr class="data-row"><td>Allocations familiales</td><td></td><td>-</td></tr>
            <tr class="data-row"><td>Pensions</td><td></td><td>-</td></tr>

            <tr class="net-salary-row">
                <th colspan="2">Salaire NET en ARIARY - arrondi</th>
                <td class="amount"><%= Utilitaire.formaterAr(mapping.getNetAPayerArrondi())%></td>
            </tr>

            <tr class="data-row"><td>Avantages en nature</td><td></td><td>-</td></tr>
        </table>
        <div class="final-total"><%= Utilitaire.formaterAr(mapping.getNetAPayerArrondi() * 5) %> FMG</div>

        <footer class="footer clearfix">
            <div class="footer-left">
                <span class="label">Mode de paiement :</span>
                <div class="signature-line"></div>
                <span class="label">Emargement du salari&eacute;</span>
            </div>
            <div class="footer-center company-stamp">
                <img src="${pageContext.request.contextPath}/assets/img/LOGO-512.png" alt="ASSURANCE ARO Logo" onerror="this.style.display='none'; this.nextElementSibling.style.display='block';" style="width: 75px; height: 75px">
                <div class="logo" style="display: none; ">ASSURANCE ARO</div>
            </div>
            <div class="footer-right manager-signature">
                <span class="label">La G&eacute;rante</span>
                <div class="signature-line"></div>
                <span class="signature">Signature</span>
            </div>
        </footer>
    </div>

    <div id="hidden-payslips-container"></div>

    <div class="export-btn-container">
        <button class="btn btn-secondary" id="exportBtn">Exporter fiche de Paie de l'employ&eacute;</button>
        <button class="btn btn-primary" id="exportAllBtn">Exporter tous les fiches de paies des employ&eacute;s</button>
    </div>
</div>

<script>
    const allEmployeesData = [
        <%
        for (int i = 0; i < allFichePaies.size(); i++) {
            FichePaie empFiche = allFichePaies.get(i);
            List<PaieEditionEltpaie> empElements = empFiche.getListeElementPaie();
            MappingElementPaie mapEmp = MappingElementPaie.getValeurElementDePaie(empElements);
        %>
        {
            nom: '<%= empFiche.getNom().replaceAll("'", "\\'") %>',
            fonction: '<%= empFiche.getFonction() != null ? empFiche.getFonction().replaceAll("'", "\\'") : "" %>',
            matricule: '<%= empFiche.getMatricule() != null ? empFiche.getMatricule() : "" %>',
            mois: '<%= empFiche.getMois() != null ? Utilitaire.convertDebutMajuscule(empFiche.getMois()) : "" %>',
            annee: '<%= empFiche.getAnnee() %>',
            conger: '<%= empFiche.getConger() %>',
            salaireDeBase: '<%= Utilitaire.formaterAr(mapEmp.getSalaireDeBase()) %>',
            totalGains: '<%= Utilitaire.formaterAr(mapEmp.getTotalGains()) %>',
            montant: '<%= Utilitaire.formaterAr(mapEmp.getSalaierDuMoisArrondi()) %>',
            heuresReels: '<%= mapEmp.getHeureReels() %>',
            allocation: '<%= Utilitaire.formaterAr(mapEmp.getAllocation()) %>',
            indemnite: '<%= Utilitaire.formaterAr(mapEmp.getIndemnite()) %>',
            prime: '<%= Utilitaire.formaterAr(mapEmp.getPrime()) %>',
            totalRetenues: '<%= Utilitaire.formaterAr(mapEmp.getTotalRetenues()) %>',
            cnaps: '<%= Utilitaire.formaterAr(mapEmp.getCnaps()) %>',
            ostie: '<%= Utilitaire.formaterAr(mapEmp.getOstie()) %>',
            irsa: '<%= Utilitaire.formaterAr(mapEmp.getIrsa()) %>',
            netAPayerArrondi: '<%= Utilitaire.formaterAr(mapEmp.getNetAPayerArrondi()) %>',
            netAPayerArrondiValue: <%= mapEmp.getNetAPayerArrondi() %>,
            heuresLegal: <%= ConstantePaie.heureLegale %>,
            categorieQualif: '<%= MappingElementPaie.getCategorieQualif(empFiche.getFonction()) != null ? MappingElementPaie.getCategorieQualif(empFiche.getFonction()).replaceAll("'", "\\\\'").replaceAll("\\r\\n|\\r|\\n", " ") : "" %>',
            congePaye: <%= mapEmp.getCongePaye() %>,
            totalHS: <%= mapEmp.getTotalHS() %>,
            avanceTotale: <%= mapEmp.getAvanceTotale() %>
        }<%= i < allFichePaies.size() - 1 ? "," : "" %>
        <%
        }
        %>
    ];

    // Function to create payslip HTML for an employee
    function createPayslipHTML(employee) {
        const contextPath = '<%= request.getContextPath() %>';
        return '' +
            '<div class="payslip-container">' +
            '<div class="header clearfix">' +
            '<div class="company-logo">' +
            '<img src="' + contextPath + '/assets/img/LOGO-512.png" alt="ASSURANCE Logo" onerror="this.style.display=\'none\'; this.nextElementSibling.style.display=\'block\';">' +
            '<div class="fallback-text">ASSURANCE ARO</div>' +
            '</div>' +
            '<div class="company-address">' +
            'T&eacute;l.: 034 42 276 10<br>' +
            'Assurance Aro Ampefiloha' +
            '101 - ANTANANARIVO' +
            '</div>' +
            '</div>' +

            '<div class="title">FICHE DE PAIE</div>' +

            '<div class="info-section clearfix">' +
            '<div class="employee-info">' +
            '<div class="employee-info-grid">' +
            '<table>' +
            '<tr><td><label>Mois de :</label></td><td>' + employee.mois + ' - ' + employee.annee + '</td></tr>' +
            '<tr><td><label>Noms et pr&eacute;noms :</label></td><td>' + employee.nom + '</td></tr>' +
            '<tr><td><label>Fonction :</label></td><td>' + employee.fonction + '</td></tr>' +
            '<tr><td><label>Num Matricule :</label></td><td>' + employee.matricule + '</td></tr>' +
            '<tr><td><label>Cat&eacute;gorie professionnelle :</label></td><td>' + employee.categorieQualif + '</td></tr>' +
            '</table>' +
            '</div>' +
            '</div>' +
            '<div class="conges-table">' +
            '<table>' +
            '<thead><tr><th colspan="2">CONGES</th></tr></thead>' +
            '<tbody>' +
            '<tr><td>Acquis :</td><td>2,5</td></tr>' +
            '<tr><td>Pris :</td><td>' + employee.conger + '</td></tr>' +
            '<tr><td>Pay&eacute; :</td><td>0,0</td></tr>' +
            '<tr><td>Solde :</td><td>2,5</td></tr>' +
            '<tr><td>Cong&eacute; Mat. :</td><td>0,0</td></tr>' +
            '<tr><td>Anciennet&eacute; :</td><td>0,0</td></tr>' +
            '</tbody>' +
            '</table>' +
            '</div>' +
            '</div>' +

            '<table class="paie-details">' +
            '<tr class="section-header">' +
            '<th colspan="2">El&eacute;ments positifs</th>' +
            '<th class="amount">' + employee.totalGains + '</th>' +
            '</tr>' +
            '<tr class="data-row"><td>Salaire de base</td><td>' + employee.heuresLegal + '</td><td>' + employee.montant + '</td></tr>' +
            '<tr class="data-row"><td>Salaire du mois arrondi pour calcul net</td><td>' + employee.heuresReels + '</td><td>' + employee.salaireDeBase + '</td></tr>' +
            '<tr class="data-row"><td>Retenu sur absences</td><td></td><td>-</td></tr>' +
            '<tr class="data-row"><td>Rappel :</td><td></td><td>-</td></tr>' +
            '<tr class="data-row"><td>Cong&eacute;s pay&eacute; :</td><td></td><td>' + employee.congePaye + '</td></tr>' +
            '<tr class="data-row"><td>Pr&eacute;avis</td><td></td><td>-</td></tr>' +
            '<tr class="data-row"><td>Allocation familiales; :</td><td></td><td>' + employee.allocation + '</td></tr>' +
            '<tr class="data-row"><td>Indemnit&eacute;s diverses</td><td></td><td>' + employee.indemnite + '</td></tr>' +
            '<tr class="data-row"><td>Heures Suppl&eacute;mentaires : <span>+jours f&eacute;ri&eacute;s</span></td><td></td><td>' + employee.totalHS+'</td></tr>' +
            '<tr class="data-row"><td>Primes :</td><td></td><td>' + employee.prime + '</td></tr>' +

            '<tr class="section-header">' +
            '<th colspan="2">D&eacute;ductions r&eacute;glementaires</th>' +
            '<th class="amount">' + employee.totalRetenues + '</th>' +
            '</tr>' +
            '<tr class="data-row"><td>Avance : <span>(Quinzaine & Sp&eacute;ciale)</span></td><td></td><td><%= Utilitaire.formaterAr(mapping.getAvanceTotale())%></td></tr>' +
            '<tr class="data-row"><td>Retenue CNaPS :</td><td></td><td>' + employee.cnaps + '</td></tr>' +
            '<tr class="data-row"><td>Retenue OSTIE :</td><td></td><td>' + employee.ostie + '</td></tr>' +
            '<tr class="data-row"><td>IRSA : <span>(Apr&egrave;s abattement et r&eacute;duction enfants &agrave; charge)</span></td><td></td><td>' + employee.irsa + '</td></tr>' +
            '<tr class="data-row"><td>Autres d&eacute;ductions :</td><td></td><td>-</td></tr>' +
            '<tr class="data-row"><td>Allocations familiales</td><td></td><td>-</td></tr>' +
            '<tr class="data-row"><td>Pensions</td><td></td><td>-</td></tr>' +

            '<tr class="net-salary-row">' +
            '<th colspan="2">Salaire NET en ARIARY - arrondi</th>' +
            '<td class="amount">' + employee.netAPayerArrondi + '</td>' +
            '</tr>' +

            '<tr class="data-row"><td>Avantages en nature</td><td></td><td>-</td></tr>' +
            '</table>' +
            '<div class="final-total">' + (employee.netAPayerArrondiValue * 5) + ' FMG</div>' +

            '<footer class="footer clearfix">' +
            '<div class="footer-left">' +
            '<span class="label">Mode de paiement :</span>' +
            '<div class="signature-line"></div>' +
            '<span class="label">Emargement du salari&eacute;</span>' +
            '</div>' +
            '<div class="footer-center company-stamp">' +
            '<img style="width: 75px; height: 45px" src="' + contextPath + '/assets/img/LOGO-512.png.jpeg" alt="ASSURANCE ARO Logo" class="footer-logo" onerror="this.style.display=\'none\'; this.nextElementSibling.style.display=\'block\';">' +
            '<div class="logo" style="display: none;">ASSURANCE ARO</div>' +
            '</div>' +
            '<div class="footer-right manager-signature">' +
            '<span class="label">La G&eacute;rante</span>' +
            '<div class="signature-line"></div>' +
            '<span class="signature">Signature</span>' +
            '</div>' +
            '</footer>' +
            '</div>';
    }


    // Single export functionality
    document.getElementById('exportBtn').addEventListener('click', function() {
        const button = this;
        const originalText = button.textContent;

        button.disabled = true;
        button.textContent = 'Generation en cours...';

        const element = document.getElementById('payslip-content');

        const options = {
            scale: 2,
            useCORS: true,
            allowTaint: true,
            backgroundColor: '#ffffff',
            width: element.scrollWidth,
            height: element.scrollHeight,
            scrollX: 0,
            scrollY: 0
        };

        html2canvas(element, options).then(function(canvas) {
            const imgWidth = 210;
            const imgHeight = (canvas.height * imgWidth) / canvas.width;

            const { jsPDF } = window.jspdf;
            const pdf = new jsPDF('p', 'mm', 'a4');

            const imgData = canvas.toDataURL('image/jpeg', 1);
            pdf.addImage(imgData, 'JPEG', 0, 0, imgWidth, imgHeight, undefined, 'FAST');

            const employeeName = '<%= fiche.getNom().replaceAll(" ", "_") %>';
            const month = '<%= fiche.getMois() %>';
            const year = '<%= fiche.getAnnee() %>';
            const filename = 'Fiche_de_Paie_' + employeeName + '_' + month + '_' + year + '.pdf';

            pdf.save(filename);

            button.disabled = false;
            button.textContent = originalText;

        }).catch(function(error) {
            console.error('Erreur lors de la generation du PDF:', error);
            alert('Erreur lors de la generation du PDF. Veuillez reessayer.');
            button.disabled = false;
            button.textContent = originalText;
        });
    });


    // Export All functionality
    document.getElementById('exportAllBtn').addEventListener('click', async function() {
        const button = this;
        const originalText = button.textContent;
        const hiddenContainer = document.getElementById('hidden-payslips-container');

        if (allEmployeesData.length === 0) {
            alert('Aucune fiche de paie a exporter.');
            return;
        }

        button.disabled = true;
        button.textContent = 'Generation en cours...';

        try {
            const { jsPDF } = window.jspdf;
            const pdf = new jsPDF('p', 'mm', 'a4');
            const imgWidth = 210;

            hiddenContainer.innerHTML = '';

            for (let i = 0; i < allEmployeesData.length; i++) {
                const employee = allEmployeesData[i];

                const payslipDiv = document.createElement('div');
                payslipDiv.className = 'hidden-payslip';
                payslipDiv.innerHTML = createPayslipHTML(employee);
                hiddenContainer.appendChild(payslipDiv);

                await new Promise(resolve => setTimeout(resolve, 100));

                const options = {
                    scale: 2,
                    useCORS: true,
                    allowTaint: true,
                    backgroundColor: '#ffffff',
                    width: 750,
                    height: payslipDiv.querySelector('.payslip-container').scrollHeight,
                    scrollX: 0,
                    scrollY: 0,
                    logging: false,
                    removeContainer: true
                };

                try {
                    const canvas = await html2canvas(payslipDiv.querySelector('.payslip-container'), options);
                    const imgHeight = (canvas.height * imgWidth) / canvas.width;

                    const imgData = canvas.toDataURL('image/jpeg', 1);

                    if (i > 0) {
                        pdf.addPage();
                    }

                    pdf.addImage(imgData, 'JPEG', 0, 0, imgWidth, imgHeight, undefined, 'FAST');
                    canvas.width = 0;
                    canvas.height = 0;

                } catch (canvasError) {
                    console.error(`Erreur lors de la capture de la fiche ${employee.nom}:`, canvasError);
                }

                hiddenContainer.removeChild(payslipDiv);

                if (i % 3 === 0) {
                    await new Promise(resolve => setTimeout(resolve, 100));
                }
            }

            pdf.compress = true;

            const month = allEmployeesData.length > 0 ? allEmployeesData[0].mois : 'Inconnu';
            const year = allEmployeesData.length > 0 ? allEmployeesData[0].annee : new Date().getFullYear();
            const filename = 'Fiches_de_Paie_Tous_Employes_'+ month + '_' + year + '.pdf';

            pdf.save(filename);

        } catch (error) {
            console.error('Erreur lors de la génération du PDF:', error);
            alert('Erreur lors de la génération du PDF. Veuillez réessayer.');
        } finally {
            button.disabled = false;
            button.textContent = originalText;
            hiddenContainer.innerHTML = '';
        }
    });
</script>

<!-- Include jsPDF and html2canvas libraries -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
</body>

</html>


<%} catch(Exception e) {
    e.printStackTrace();
}%>