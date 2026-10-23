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
            <h1 class="mobile__header-title">Bon de livraison</h1>
        </div>
    </div>
    <div class="mobile__search-container mb-5">
        <div class="input-with-addons with-btn-left">
            <div class="btn btn-left">
                <i class="material-symbols-rounded">search</i>
            </div>
            <input type="text" class="form-control mobile__search-box" placeholder="Recherche d'une commande" />
        </div>
    </div>
    <div class="search-result-container">
        <div class="search-result__box facture-box">
            <div class="search-result__details">
                <h3 class="h617pxSemibold search-result__title m-0">23001 - Chapiteau</h3>
                <p class="Body14pxRegular m-0">Du: <span> 26-02-2025</span></p>
                <p class="Body14pxRegular m-0">Montant: <span>1.000.000,00 MGA</span></p>
                <span class="tag red">NON TRAITÉ</span>
            </div>
            <a href="${pageContext.request.contextPath}/pages/module.jsp?but=mobile/details-bondelivraison.jsp" class="search-result__link">
                <i class="material-symbols-rounded">arrow_forward_ios</i>
            </a>
        </div>
        <div class="search-result__box facture-box">
            <div class="search-result__details">
                <h3 class="Body14pxSemiBold search-result__title m-0">23001 - Chapiteau</h3>
                <p class="Body14pxRegular m-0">Du: <span> 26-02-2025</span></p>
                <p class="Body14pxRegular m-0">Montant: <span>1.000.000,00 MGA</span></p>
                <span class="tag orange">EN COURS DE TRAITEMENT</span>
            </div>
            <a href="${pageContext.request.contextPath}/pages/module.jsp?but=mobile/details-bondelivraison.jsp" class="search-result__link">
                <i class="material-symbols-rounded">arrow_forward_ios</i>
            </a>
        </div>
        <div class="search-result__box facture-box">
            <div class="search-result__details">
                <h3 class="Body14pxSemiBold search-result__title m-0">23001 - Chapiteau</h3>
                <p class="Body14pxRegular m-0">Du: <span> 26-02-2025</span></p>
                <p class="Body14pxRegular m-0">Montant: <span>1.000.000,00 MGA</span></p>
                <span class="tag green">EXPÉDIÉ</span>
            </div>
            <a href="${pageContext.request.contextPath}/pages/module.jsp?but=mobile/details-bondelivraison.jsp" class="search-result__link">
                <i class="material-symbols-rounded">arrow_forward_ios</i>
            </a>
        </div>
    </div>


</div>
<script src="${pageContext.request.contextPath}/assets/js/mobile-js/mobile-utils.js"></script>
