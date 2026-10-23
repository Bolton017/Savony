<%@ page import="paie.edition.EtatPaie" %>
<%@ page import="caisse.EtatCaisse" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    try {
      EtatPaie[] etatPaies = new EtatPaie().getAllEtatPaies();

      int mois = etatPaies[0].getMois();
      int annee = etatPaies[0].getAnnee();
%>


<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Etat de Paie</title>
  <style>
    * {
      box-sizing: border-box;
    }

    body {
      font-family: Arial, sans-serif;
      background-color: #f8f9fa;
      padding: 0;
      margin: 0;
      font-size: 12px;
    }

    .payslip-container {
      width: 100%;
      max-width: 1130px;
      margin: 20px auto;
      background: #fff;
      padding: 65px;
      margin-left: 325px;
      margin-top: 100px;
    }

    .clearfix:after {
      content: "";
      display: table;
      clear: both;
    }

    .header {
      margin-bottom: 20px;
      padding: 15px 20px;
      border-radius: 6px;
      color: white;
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
      max-height: 60px;
      max-width: 200px;
      height: auto;
      width: auto;
      object-fit: contain;
    }

    .company-address {
      float: right;
      width: 40%;
      text-align: right;
      font-size: 12px;
      color: white;
      opacity: 0.9;
    }

    .title {
      text-align: center;
      font-size: 20px;
      font-weight: bold;
      margin: 20px 0;
      clear: both;
      color: #0c0c0c;
      text-transform: uppercase;
      letter-spacing: 1px;
    }

    .info-section {
      padding: 15px;
      border: 2px solid #2d7a7b;
      background: #f8fffe;
      border-radius: 6px;
      margin-bottom: 20px;
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
      padding: 8px 0;
      border-radius: 4px;
      padding-left: 10px;
    }

    /* Enhanced table for many columns */
    .paie-details-wrapper {
      width: 100%;
      overflow-x: auto;
      overflow-y: auto;
      margin-top: 20px;
      border: 2px solid #2d7a7b;
      border-radius: 6px;
      background: white;
      max-height: 600px; /* Set a max height to enable vertical scrolling */
    }

    .paie-details {
      width: 100%;
      min-width: 1600px; /* Minimum width to accommodate all columns */
      border-collapse: collapse;
      font-size: 10px;
      margin: 0;
    }

    .paie-details th, .paie-details td {
      padding: 8px 6px;
      border: 1px solid #2d7a7b;
      white-space: nowrap;
      vertical-align: middle;
    }

    .paie-details .section-header th {
      background: linear-gradient(135deg, #2d7a7b 0%, #4a9b9c 100%);
      color: white;
      text-align: center;
      font-weight: bold;
      font-size: 9px;
      padding: 10px 6px;
      position: sticky;
      top: 0;
      z-index: 10;
    }

    /* Color-coded column groups */
    .paie-details th:nth-child(1),
    .paie-details td:nth-child(1) {
      background-color: #e6f3f3;
      position: sticky;
      left: 0;
      z-index: 5;
      font-weight: bold;
    }

    /* Make the first column header sticky both horizontally and vertically */
    .paie-details .section-header th:nth-child(1) {
      position: sticky;
      left: 0;
      top: 0;
      z-index: 15; /* Higher z-index to appear above other sticky elements */
      background: linear-gradient(135deg, #2d7a7b 0%, #4a9b9c 100%);
      color: white;
    }

    .paie-details .data-row td {
      word-wrap: break-word;
      text-align: center;
    }

    .paie-details .net-salary-row th,
    .paie-details .net-salary-row td {
      background: linear-gradient(135deg, #2d7a7b 0%, #4a9b9c 100%) !important;
      color: white !important;
      font-weight: bold;
      border: 2px solid #1a5a5b;
      padding: 10px 6px;
    }

    /* Responsive design */
    @media screen and (max-width: 1200px) {
      .payslip-container {
        margin: 10px;
        padding: 15px;
      }

      .paie-details {
        font-size: 9px;
      }

      .paie-details th, .paie-details td {
        padding: 6px 4px;
      }
    }

    @media print {
      body {
        background-color: white;
      }

      .payslip-container {
        box-shadow: none;
        border: 1px solid #2d7a7b;
        margin: 0;
        max-width: none;
        width: 100%;
      }

      .paie-details-wrapper {
        overflow-x: visible;
        overflow-y: visible;
        max-height: none;
      }

      .paie-details {
        min-width: auto;
        font-size: 8px;
      }

      .paie-details th {
        position: static !important;
      }

      .btn {
        display: none;
      }
    }
  </style>
</head>
<body>
<div class="payslip-container">
  <div class="header clearfix">
    <div class="company-logo">
      <img src="${pageContext.request.contextPath}/assets/img/xc-factory-logo.jpeg" alt="Company Logo" onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
    </div>
    <div class="company-address">
    </div>
  </div>

  <div class="title">ETAT DE PAIE</div>

  <div class="info-section clearfix">
    <div class="employee-info">
      <div class="employee-info-grid">
        <table>
          <tr><td>Mois de: <b><%= mois %> <%= annee %></b></td></tr>
        </table>
      </div>
    </div>
  </div>

  <div class="paie-details-wrapper">
    <table class="paie-details">
      <thead>
      <tr class="section-header">
        <th>Personnel</th>
        <th>Fonction</th>
        <th>Matricule</th>
        <th>Heures du mois</th>
        <th>Heures legales</th>
        <th>Heure de presence</th>
        <th>Taux horaire</th>
        <th>Salaire</th>
        <th>Salaire du mois</th>
        <th>Heures supplementaires</th>
        <th>Rappel</th>
        <th>Retenue absence</th>
        <th>Prime</th>
        <th>Conge paye</th>
        <th>Preavis</th>
        <th>Indemnite diverse fixe</th>
        <th>Salaire brut</th>
        <th>CNAPS</th>
        <th>OSTIE</th>
        <th>Net imposable</th>
        <th>Net imposable arrondi</th>
        <th>IRSA</th>
        <th>Nombre d'enfants</th>
        <th>IRSA net</th>
        <th>Avance sur salaire</th>
        <th>Avance exceptionnelle</th>
        <th>Allocation</th>
        <th>Net à payer</th>
        <th>Net à payer arrondi</th>
        <th>Mois</th>
        <th>Annee</th>
      </tr>
      </thead>

      <tbody>
      <tr class="data-row">
        <td>RABEMANA NTSOA Louis</td> <!-- Personnel -->
        <td>suffeur</td> <!-- Fonction -->
        <td>01-XC</td> <!-- Matricule -->
        <td>173,33</td> <!-- Heures du mois -->
        <td>173,33</td> <!-- Heures legales -->
        <td>173,33</td> <!-- Heure de presence -->
        <td>2019</td> <!-- Taux horaire -->
        <td>350 000,00</td> <!-- Salaire -->
        <td>350 000,00</td> <!-- Salaire du mois -->
        <td></td> <!-- Heures supplementaires -->
        <td></td> <!-- Rappel -->
        <td></td> <!-- Retenue absence -->
        <td>50 000,00</td> <!-- Prime -->
        <td></td> <!-- Conge paye -->
        <td></td> <!-- Preavis -->
        <td>50 000,00</td> <!-- Indemnite diverse fixe -->
        <td>450 000,00</td> <!-- Salaire brut -->
        <td>4 500,00</td> <!-- CNAPS -->
        <td>4 500,00</td> <!-- OSTIE -->
        <td></td> <!-- Net imposable -->
        <td></td> <!-- Net imposable arrondi -->
        <td></td> <!-- IRSA -->
        <td></td> <!-- Nombre d'enfants -->
        <td></td> <!-- IRSA net -->
        <td></td> <!-- Avance sur salaire -->
        <td></td> <!-- Avance exceptionnelle -->
        <td></td> <!-- Allocation -->
        <td></td> <!-- Net à payer -->
        <td></td> <!-- Net à payer arrondi -->
        <td></td> <!-- Mois -->
        <td></td> <!-- Annee -->
      </tr>

      <tr class="data-row">
        <td>NIRINA Lily Eliane</td>
        <td>financière de face</td>
        <td>22-XC</td>
        <td>173,33</td>
        <td>173,33</td>
        <td>173,33</td>
        <td>1515</td>
        <td>262 680,00</td>
        <td>262 680,00</td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td>262 680,00</td>
        <td>2 626,80</td>
        <td>2 626,80</td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>

      <tr class="data-row">
        <td>SANTATRININ AINA Olivia Laurencia</td>
        <td>chargée Admin & financier</td>
        <td>27-XC</td>
        <td>173,33</td>
        <td>173,33</td>
        <td>173,33</td>
        <td>6 390</td>
        <td>1 107 600,00</td>
        <td>1 107 600,00</td>
        <td></td>
        <td></td>
        <td></td>
        <td>50 000,00</td>
        <td></td>
        <td></td>
        <td></td>
        <td>1 157 600,00</td>
        <td>11 576,00</td>
        <td>11 576,00</td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>

      <tr class="data-row">
        <td>RANDRIAN ALIVELO Hajamala</td>
        <td>manager Qualité</td>
        <td>31-XC</td>
        <td>173,33</td>
        <td>173,33</td>
        <td>173,33</td>
        <td>6 390</td>
        <td>1 107 600,00</td>
        <td>1 107 600,00</td>
        <td></td>
        <td></td>
        <td></td>
        <td>50 000,00</td>
        <td></td>
        <td></td>
        <td></td>
        <td>1 157 600,00</td>
        <td>11 576,00</td>
        <td>11 576,00</td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>
      </tr>
      </tbody>
    </table>
  </div>
</div>

</body>
</html>

<%
  } catch (Exception e) {
    e.printStackTrace();
  }
%>