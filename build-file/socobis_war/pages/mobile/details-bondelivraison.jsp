<%--
  Created by IntelliJ IDEA.
  User: apple
  Date: 2026/7/8
  Time: 10:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="${pageContext.request.contextPath}/assets/css/savonnerie-mobile.css" rel="stylesheet" type="text/css" />

<div class="content-wrapper">
    <div class="mobile__header-container mb-5">
        <div class="mobile__title">
            <a href="javascript:history.back()" class="mobile__back-link" aria-label="Retour">
                <i class="material-symbols-rounded">arrow_back</i>
            </a>
            <img src="${pageContext.request.contextPath}/assets/img/logo-mobile-savonnerie.png" alt="mobile-logo" class="mobile__header-logo" />
            <h1 class="mobile__header-title">Détails de la commande</h1>
        </div>
    </div>

    <h2 class="h617pxSemibold" >Détails de la commande Numéro FCT0001</h2>
    <div class="details--container">
        <div class="details--bloc">
            <div class="details--bloc__title Body14pxRegular">Client</div>
            <div class="details--bloc__details Body14pxSemiBold">Chapiteau</div>
        </div>
        <div class="details--bloc">
            <div class="details--bloc__title Body14pxRegular">Code Magasin</div>
            <div class="details--bloc__details Body14pxSemiBold">Chapiteau</div>
        </div>
        <div class="details--bloc">
            <div class="details--bloc__title Body14pxRegular">Date</div>
            <div class="details--bloc__details Body14pxSemiBold">Chapiteau</div>
        </div>
        <div class="details--bloc">
            <div class="details--bloc__title Body14pxRegular">Agent</div>
            <div class="details--bloc__details Body14pxSemiBold">Jean Doe</div>
        </div>
        <div class="details--bloc">
            <div class="details--bloc__title Body14pxRegular">Statut</div>
            <span class="tag red">NON TRAITÉ</span>
        </div>
        <div class="details--bloc">
            <div class="details--bloc__title Body14pxRegular">Montant total à payer</div>
            <div class="details--bloc__details Body14pxSemiBold">2 160 000,00 MGA</div>
        </div>
    </div>

    <h2 class="h617pxSemibold" >Produit :</h2>
    <div class="search-result-container">
        <div class="search-result__box facture-box">
            <div class="search-result__details">
                <h3 class="h617pxSemibold search-result__title m-0">Savon de ménage Minosy(50Gr x 48Mx) </h3>
                <p class="Body14pxRegular m-0">Prix unitaire: <span>20.000,00 MGA</span></p>
                <p class="Body14pxRegular m-0">Quantité: <span>10 cartons</span></p>
                <p class="Body14pxRegular m-0">Montant: <span>200.000,00 MGA</span></p>
            </div>
        </div>

    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/mobile-js/mobile-utils.js"></script>
