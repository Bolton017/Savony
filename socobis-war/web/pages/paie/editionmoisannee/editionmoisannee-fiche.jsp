<%@page import="mg.spat.AttacherFichier"%>
<%@page import="affichage.PageConsulte"%>
<%@page import="user.UserEJB"%>
<%@page import="service.UploadService"%>
<%@page import="paie.edition.PaieEditionmoisanneeLib"%>
<%@page import="utilitaire.ConstanteEtat"%>
<%@ page import="paie.edition.FichePaie"%>
<%@ page import="paie.edition.PaieEditionEltpaie" %>
<%@ page import="java.util.List" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="paie.edition.MappingElementPaie" %>
<%@ page import="utils.ConstantePaie" %>
<%@ page import="utilitaire.ChiffreLettre" %>

<%
    PaieEditionmoisanneeLib paie;
    String id = request.getParameter("id");
%>

<%
    try {
        String table = request.getParameter("tab");
        String classe = "paie.edition.PaieEditionmoisannee";
        String butefiche = "paie/editionmoisannee/editionmoisannee-fiche.jsp";
        String butTraitement = "paie/employe/traitement-saisie.jsp&id=" + id;

        String lien = (String) session.getValue("lien");

        UserEJB u = (UserEJB) session.getAttribute("u");

        paie = new PaieEditionmoisanneeLib();
        paie.setNomTable("PAIE_EDITIONMOISANNEE_LIB_3");

        PageConsulte pc = new PageConsulte(paie, request, u);
        pc.setTitre("Fiche de paie &eacute;dition mois ann&eacute;e ");
        pc.getChampByName("idpersonnel").setLibelle("Personnel");
        pc.getChampByName("idpersonnel").setVisible(false);
        pc.getChampByName("iddirection").setLibelle("Direction");
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("iduser").setLibelle("Utilisateur");
        pc.getChampByName("iduser").setVisible(false);
        pc.getChampByName("annee").setLibelle("Ann&eacute;e");
        pc.getChampByName("gain").setVisible(false);
        pc.getChampByName("retenue").setVisible(false);

        pc.getChampByName("daty").setVisible(false);
        pc.getChampByName("idperiodepaie").setVisible(false);
        pc.getChampByName("mois").setVisible(false);
        pc.getChampByName("idpersonnel").setVisible(false);
        pc.getChampByName("iduser").setVisible(false);
        pc.getChampByName("mois_string").setLibelle("Mois");
        pc.getChampByName("datedebut").setLibelle("Date de d&eacute;but");
        pc.getChampByName("datefin").setLibelle("Date de fin");
        pc.getChampByName("categorie").setLibelle("Cat&eacute;gorie");
        pc.getChampByName("etat").setLibelle("&Eacute;tat");
        paie = (PaieEditionmoisanneeLib) pc.getBase();
        configuration.CynthiaConf.load();
%>
<div class="content-wrapper">
    <h1><%= pc.getTitre() %></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <%
                        out.println(pc.getHtml());
                    %>

                    <div class="row">
                        <div class="col-md-12 box-footer">
                            <%
                                if(paie.getEtat() <= ConstanteEtat.getEtatCreer()) {
                            %>
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute="+butefiche+"&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                            <% } %>

                            <%
                                if(paie.getEtat() >= ConstanteEtat.getEtatValider()) {
                            %>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ butTraitement%> " style="margin-right: 10px">Traitement de paiement</a>
                            <% } %>

                            <a class="btn btn-secondary pull-right" style="margin-right: 10px"
                               href="<%= (String) session.getValue("lien") %>?but=paie/editions/etat-paie.jsp&mois=<%= paie.getMois() %>&annee=<%= paie.getAnnee() %>"
                               aria-label="G&eacute;n&eacute;rer l'&eacute;tat de paie en PDF"
                               title="&Eacute;tat">&Eacute;tat de Paie</a>

                            <button style="margin-right: 10px" class="btn btn-tertiary pull-right" id="exportAllBtn">Les bulletins de paies (Paysage)</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%=pc.getHtmlAttacherFichier()%>
</div>
<div id="hidden-payslips-container"></div>

<script>
    $('#fiche .row .col-md-6').removeClass('col-md-6').removeClass('col-md-center').addClass('col-md-8').addClass('col-md-offset-2');
</script>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();

</script>
<% }%>

<style>
    /* Global Styles */
    * { box-sizing: border-box; }
    body { font-family: Arial, sans-serif; background-color: #fff; padding: 0; margin: 0; }
    .button-group .btn { margin-bottom: 10px; }
    .button-group { display: flex; flex-wrap: wrap; gap: 10px; justify-content: flex-end; }
    .btn:hover { background-color: #138496; }
    .btn:disabled { background-color: #6c757d; cursor: not-allowed; }

    /* Single Payslip Container */
    .payslip-container {
        max-width: 750px;
        margin: 0 auto;
        background: #fff;
        padding: 50px;
        border: 1px solid #000000;
    }

    .clearfix:after { content: ""; display: table; clear: both; }
    .header { margin-bottom: 15px; }
    .header:after { content: ""; display: table; clear: both; }

    .company-logo { float: left; width: 60%; display: flex; align-items: center; }
    .company-logo img { max-height: 100px; max-width: 200px; height: auto; width: auto; object-fit: contain; }
    .company-logo .fallback-text { font-size: 18px; font-weight: bold; display: none; }
    .company-logo .fallback-text span { font-style: italic; font-weight: normal; font-size: 11px; display: block; }

    .company-address { float: right; width: 40%; text-align: right; font-size: 10px; }

    .title { text-align: center; font-size: 16px; font-weight: bold; text-decoration: underline; margin: 20px 0; clear: both; }

    .info-section { padding: 10px; border: 1px solid #c3c3c3; }
    .info-section:after { content: ""; display: table; clear: both; }

    .employee-info {
        float: left;
        width: 100%;
        padding-right: 0;
    }

    /* Column style for split info */
    .info-column {
        float: left;
        width: 50%;
        box-sizing: border-box;
    }

    /* Add slight padding to separate columns if needed, though labels usually handle it */
    .info-column:first-child { padding-right: 5px; }
    .info-column:last-child { padding-left: 5px; }

    .employee-info-grid { font-size: 14px; }
    .employee-info-grid table { width: 100%; border-collapse: separate; border-spacing: 2px 2px; }
    .employee-info-grid td { vertical-align: top; padding: 2px 0; }
    .employee-info-grid label { font-weight: bold; width: 95%; display: block;}

    .paie-details { width: 100%; margin-top: 15px; border-collapse: collapse; font-size: 11px; clear: both; }
    .paie-details th, .paie-details td { padding: 4px 6px; border: 1px solid #ccc; }
    .paie-details .section-header th { background-color: #e0e0e0; text-align: left; font-weight: bold; }
    .paie-details .section-header .amount { text-align: right; }
    .paie-details td { word-wrap: break-word; }
    .paie-details .data-row td:nth-child(2), .paie-details .data-row td:nth-child(3) { text-align: right; }
    .paie-details .net-salary-row th, .paie-details .net-salary-row td { background-color: #e87777; font-weight: bold; border: 1px solid #000; padding: 6px; }

    .final-total { text-align: right; margin-top: 4px; font-size: 10px; }

    .footer { margin-top: 20px; font-size: 11px; overflow: auto; }
    .footer .label { font-weight: bold; color: #000; display: block; }
    .footer-left, .footer-center, .footer-right { width: 33.33%; float: left; box-sizing: border-box; }
    .footer-left { padding-right: 10px; }

    .footer-center { text-align: center; font-size: 8px; }
    .footer-center .logo { font-size: 14px; font-weight: bold; }
    .footer-center .footer-logo { max-height: 30px; max-width: 100px; height: auto; width: auto; object-fit: contain; margin-bottom: 5px; }

    .footer-right { text-align: center; }
    .footer .signature-line { border-bottom: 1px solid #000; height: 30px; margin: 8px 0; }

    .company-stamp { text-align: center; font-size: 8px; }
    .manager-signature { text-align: center; }
    .manager-signature .signature { font-family: 'Brush Script MT', cursive; font-size: 24px; }

    /* Hidden wrapper to generate canvas */
    .hidden-payslip-wrapper {
        position: absolute;
        left: -9999px;
        top: -9999px;
        width: 1700px;
    }

    /* Landscape Double Printing Styles */
    .payslip-double-wrapper {
        display: flex;
        flex-direction: row;
        justify-content: center;
        align-items: flex-start;
        width: 100%;
        background-color: white;
        padding: 0;
        gap: 10px;
    }

    .payslip-double-wrapper .payslip-container {
        width: 49%;
        max-width: none;
        margin: 0;
        padding: 30px;
        box-shadow: none;
        border: 1px solid #000;
    }

    .separator-line {
        border-left: 1px dashed #999;
        height: 100%;
        width: 1px;
        margin-top: 10px;
    }
</style>

<%
    try {
        FichePaie fp = new FichePaie();
        List<FichePaie> allFichePaies = fp.getListFichePaieEdition(id);
%>
<script>
    const allEmployeesData = [
        <%
        for (int i = 0; i < allFichePaies.size(); i++) {
            FichePaie empFiche = allFichePaies.get(i);
            List<PaieEditionEltpaie> empElements = empFiche.getListeElementPaie();
            MappingElementPaie mapEmp = MappingElementPaie.getValeurElementDePaie(empElements);

            String enString = ChiffreLettre.convertRealToStringDevise(mapEmp.getNetAPayerArrondi() * 5, "FMG");
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
            avance: '<%= Utilitaire.formaterAr(mapEmp.getAvanceTotale())%>',
            valHeureSup: '<%= Utilitaire.formaterAr(mapEmp.getValHeureSup())%>',
            totalHS: '<%= Utilitaire.formaterAr(mapEmp.getTotalHS())%>',

            <%-- HEURE SUPP DETAILS --%>
            hs30Ni: '<%= Utilitaire.formaterAr(mapEmp.getHeureSupp30Ni()) %>',
            hs30I: '<%= Utilitaire.formaterAr(mapEmp.getHeureSupp30I()) %>',
            hs50Ni: '<%= Utilitaire.formaterAr(mapEmp.getHeureSupp50Ni()) %>',
            hs50I: '<%= Utilitaire.formaterAr(mapEmp.getHeureSupp50I()) %>',

            <%-- NEW FIELDS FOR INFO GRID --%>
            indice: '<%= empFiche.getIndice() != null ? empFiche.getIndice() : "" %>',
            datePaiement: '<%= Utilitaire.dateDuJour() %>',
            catPersonnel: '<%= empFiche.getCategoriePersonnel() != null ? empFiche.getCategoriePersonnel() : "" %>',
            sitFamiliale: '<%= empFiche.getSituationMLib() != null ? empFiche.getSituationMLib() : "" %>',
            departement: '<%= empFiche.getDepartementLib() != null ? empFiche.getDepartementLib() : "" %>',
            cnapsId: '<%= empFiche.getMatricule_cnaps() != null ? empFiche.getMatricule_cnaps() : "" %>',
            modePaiement: '<%= empFiche.getModePaiementLib() != null ? empFiche.getModePaiementLib() : "" %>',

            <%
                double valeurEnFMG = mapEmp.getNetAPayerArrondi() * 5;
            %>
            netAPayerArrondiValue: '<%= Utilitaire.formaterAr(valeurEnFMG) %>',
            heuresLegal: <%= ConstantePaie.heureLegale %>,
            categorieQualif: '<%= MappingElementPaie.getCategorieQualif(empFiche.getFonction()) %>',
            congePaye: '<%= Utilitaire.formaterAr(mapEmp.getCongePaye()) %>',
            netAPayerEnLettre: '<%= enString %>',
            totalHeureSup: <%= mapEmp.getTotalHeureSup() %>,
            congeDroit: <%= mapEmp.getCongeDroit() %>,
            avanceGain: '<%= Utilitaire.formaterAr(mapEmp.getAvanceGain())%>'
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
            '<img src="' + contextPath + '/assets/img/LOGO-512.png" alt="Socobis Logo" onerror="this.style.display=\'none\'; this.nextElementSibling.style.display=\'block\';">' +
            '<div class="fallback-text">SOCOBIS</div>' +
            '</div>' +
            '<div class="company-address">' +
            'T&eacute;l.: 034 42 276 10<br>' +
            'SOCOBIS Tanjombato ' +
            '101 - ANTANANARIVO' +
            '</div>' +
            '</div>' +

            '<div class="title">FICHE DE PAIE</div>' +

            '<div class="info-section clearfix">' +
            '<div class="employee-info">' +
            '<div class="employee-info-grid">' +

            // --- SPLIT INTO 2 COLUMNS ---
            '<div class="info-column">' +
            '<table>' +
            '<tr><td><label>Mois de:</label></td><td>' + employee.mois + ' - ' + employee.annee + '</td></tr>' +
            '<tr><td><label>Matricule:</label></td><td>' + employee.matricule + '</td></tr>' +
            '<tr><td><label>Nom & Pr&eacute;noms:</label></td><td>' + employee.nom + '</td></tr>' +
            '<tr><td><label>D&eacute;partement:</label></td><td>' + employee.departement + '</td></tr>' +
            '<tr><td><label>Fonction:</label></td><td>' + employee.fonction + '</td></tr>' +
            '<tr><td><label>Cat&eacute;gorie prof:</label></td><td>' + employee.categorieQualif + '</td></tr>' +
            '</table>' +
            '</div>' +

            '<div class="info-column">' +
            '<table>' +
            '<tr><td><label>Date de paiement:</label></td><td>' + employee.datePaiement + '</td></tr>' +
            '<tr><td><label>Sit. Familiale:</label></td><td>' + employee.sitFamiliale + '</td></tr>' +
            '<tr><td><label>Cat. Personnel:</label></td><td>' + employee.catPersonnel + '</td></tr>' +
            '<tr><td><label>Indice:</label></td><td>' + employee.indice + '</td></tr>' +
            '<tr><td><label>N&deg; CNAPS:</label></td><td>' + employee.cnapsId + '</td></tr>' +
            '<tr><td><label>Mode de paiement:</label></td><td>' + employee.modePaiement + '</td></tr>' +
            '</table>' +
            '</div>' +

            '</div>' + // End employee-info-grid
            '</div>' + // End employee-info
            '</div>' + // End info-section

            '<table class="paie-details">' +
            '<tr class="section-header">' +
            '<th colspan="2">El&eacute;ments positifs</th>' +
            '<th class="amount">' + employee.totalGains + '</th>' +
            '</tr>' +
            '<tr class="data-row"><td>Salaire du mois arrondi pour calcul net</td><td>' + employee.heuresReels + '</td><td>' + employee.salaireDeBase + '</td></tr>' +
            '<tr class="data-row"><td>Retenu sur absences</td><td></td><td>-</td></tr>' +
            '<tr class="data-row"><td>Rappel :</td><td></td><td>-</td></tr>' +
            '<tr class="data-row"><td>Cong&eacute;s pay&eacute; :</td><td></td><td>' + employee.congePaye + '</td></tr>' +
            '<tr class="data-row"><td>Pr&eacute;avis</td><td></td><td>-</td></tr>' +
            '<tr class="data-row"><td>Allocation familiales; :</td><td></td><td>' + employee.allocation + '</td></tr>' +
            '<tr class="data-row"><td>Indemnit&eacute;s diverses</td><td></td><td>' + employee.indemnite + '</td></tr>' +

            // --- HEURE SUPP DETAILS ---
            '<tr class="data-row"><td>HS 30% NI</td><td></td><td>' + employee.hs30Ni + '</td></tr>' +
            '<tr class="data-row"><td>HS 30% I</td><td></td><td>' + employee.hs30I + '</td></tr>' +
            '<tr class="data-row"><td>HS 50% NI</td><td></td><td>' + employee.hs50Ni + '</td></tr>' +
            '<tr class="data-row"><td>HS 50% I</td><td></td><td>' + employee.hs50I + '</td></tr>' +
            // --------------------------

            '<tr class="data-row"><td>Total Heures Supp <span>(+f&eacute;ri&eacute;s, etc)</span></td><td></td><td>'+ employee.totalHS +'</td></tr>' +

            '<tr class="data-row"><td>Primes :</td><td></td><td>' + employee.prime + '</td></tr>' +
            '<tr class="data-row"><td>Avance : <span>(Quinzaine & Sp&eacute;ciale)</span></td><td></td><td>' + employee.avanceGain + '</td></tr>' +

            '<tr class="section-header">' +
            '<th colspan="2">D&eacute;ductions r&eacute;glementaires</th>' +
            '<th class="amount">' + employee.totalRetenues + '</th>' +
            '</tr>' +
            '<tr class="data-row"><td>Avance : <span>(Quinzaine & Sp&eacute;ciale)</span></td><td></td><td>' + employee.avance + '</td></tr>' +
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
            '<div class="final-total"><h6>' + employee.netAPayerArrondiValue + ' FMG</h6></div>' +
            '<div class="final-total"><h6><b>' + employee.netAPayerEnLettre + '</b> </h6></div>' +

            '<footer class="footer clearfix">' +
            '<div class="footer-left">' +
            '<span class="label">Mode de paiement :</span>' +
            '<div class="signature-line"></div>' +
            '<span class="label">Emargement du salari&eacute;</span>' +
            '</div>' +
            '<div class="footer-center company-stamp">' +
            '<img style="width: 75px; height: 45px" src="' + contextPath + '/assets/img/LOGO-512.png" alt="Socobis Logo" class="footer-logo" onerror="this.style.display=\'none\'; this.nextElementSibling.style.display=\'block\';">' +
            '<div class="logo" style="display: none;">SOCOBIS</div>' +
            '</div>' +
            '<div class="footer-right manager-signature">' +
            '<span class="label">La G&eacute;rante</span>' +
            '<div class="signature-line"></div>' +
            '<span class="signature">Signature</span>' +
            '</div>' +
            '</footer>' +
            '</div>';
    }


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
            const pdf = new jsPDF('l', 'mm', 'a4');
            const pageWidth = 297;
            const pageHeight = 210;

            const paddingPt = 16;
            const ptToMm = 0.3528;
            const padding = paddingPt * ptToMm;
            const contentWidth = pageWidth - (padding * 2);

            hiddenContainer.innerHTML = '';

            for (let i = 0; i < allEmployeesData.length; i++) {
                const employee = allEmployeesData[i];

                const wrapperDiv = document.createElement('div');
                wrapperDiv.className = 'hidden-payslip-wrapper';

                const singlePayslipHtml = createPayslipHTML(employee);

                wrapperDiv.innerHTML =
                    '<div class="payslip-double-wrapper">' +
                    singlePayslipHtml +
                    '<div class="separator-line"></div>' +
                    singlePayslipHtml +
                    '</div>';

                hiddenContainer.appendChild(wrapperDiv);

                await new Promise(resolve => setTimeout(resolve, 100));

                const options = {
                    scale: 2,
                    useCORS: true,
                    allowTaint: true,
                    backgroundColor: '#ffffff',
                    windowWidth: 1600,
                    logging: false,
                    removeContainer: true
                };

                try {
                    const canvas = await html2canvas(wrapperDiv.querySelector('.payslip-double-wrapper'), options);
                    const imgHeight = (canvas.height * contentWidth) / canvas.width;
                    const imgData = canvas.toDataURL('image/jpeg', 0.95);

                    if (i > 0) pdf.addPage();

                    pdf.addImage(imgData, 'JPEG', padding, padding, contentWidth, imgHeight, undefined, 'FAST');

                    canvas.width = 0;
                    canvas.height = 0;

                } catch (canvasError) {
                    console.error(`Erreur lors de la capture de la fiche ${employee.nom}:`, canvasError);
                }

                hiddenContainer.removeChild(wrapperDiv);

                if (i % 3 === 0) await new Promise(resolve => setTimeout(resolve, 100));
            }

            pdf.compress = true;
            const month = allEmployeesData.length > 0 ? allEmployeesData[0].mois : 'Inconnu';
            const year = allEmployeesData.length > 0 ? allEmployeesData[0].annee : new Date().getFullYear();
            const filename = 'Fiches_de_Paie_Paysage_'+ month + '_' + year + '.pdf';

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

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

<% } catch (Exception e) {
    throw new RuntimeException(e);
}%>