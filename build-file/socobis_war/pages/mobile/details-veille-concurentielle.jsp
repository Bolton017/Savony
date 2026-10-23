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
            <h1 class="mobile__header-title">Détails de la veille concurentielle</h1>
        </div>
    </div>

    <h2 class="h617pxSemibold" >Détails de la veille concurentielle Numéro FCT0001</h2>
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
            <div class="details--bloc__details Body14pxSemiBold">26-02-2025</div>
        </div>
    </div>

    <h2 class="h617pxSemibold" >Image associé :</h2>
    <div class="search-result-container">
        <img src="" alt="veille image" class="veille__image">
    </div>


</div>

<script src="${pageContext.request.contextPath}/assets/js/mobile-js/mobile-utils.js"></script>
