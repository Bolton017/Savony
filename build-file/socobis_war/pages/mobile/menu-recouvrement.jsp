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
            <h1 class="mobile__header-title">Recouvrement</h1>
        </div>
    </div>
    <div class="search-result-container recouvrement--container">
        <a href="${pageContext.request.contextPath}/pages/module.jsp?but=mobile/liste-bondelivraison.jsp" class="search-result__box recouvrement__box">
            <i class="material-symbols-rounded">checkbook</i>
            <div class="search-result__details">
                <h3 class="h520pxSemibold search-result__title m-0">Bon de livraison</h3>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/pages/module.jsp?but=mobile/liste-facture.jsp" class="search-result__box recouvrement__box">
            <i class="material-symbols-rounded">receipt_long</i>
            <div class="search-result__details">
                <h3 class="h520pxSemibold search-result__title m-0">Facture</h3>
            </div>
        </a>
    </div>


</div>
<script src="${pageContext.request.contextPath}/assets/js/mobile-js/mobile-utils.js"></script>
