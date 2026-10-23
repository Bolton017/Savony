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
            <img src="${pageContext.request.contextPath}/assets/img/logo-mobile-savonnerie.png" alt="mobile-logo" class="mobile__header-logo" />
            <h1 class="mobile__header-title">Savonnerie Tropicale</h1>
        </div>
    </div>
    <div class="mobile__search-container mb-5">
        <div class="input-with-addons with-btn-left">
            <div class="btn btn-left">
                <i class="material-symbols-rounded">search</i>
            </div>
            <input type="text" class="form-control mobile__search-box" />
        </div>
    </div>
    <div class="search-result-container">
        <div class="search-result__box client-box">
            <img src="${pageContext.request.contextPath}/assets/img/Frame%20268.png" alt="client" class="search-result__image" />
            <div class="search-result__details">
                <h3 class="h617pxSemibold search-result__title m-0">23001 - Chapiteau</h3>
                <p class="Body14pxRegular m-0">Savonnerie Tropicale</p>
                <p class="Body14pxRegular m-0">031 23 456 78</p>
            </div>
            <a href="${pageContext.request.contextPath}/pages/module.jsp?but=mobile/menu-client.jsp" class="search-result__link">
                <i class="material-symbols-rounded">arrow_forward_ios</i>
            </a>
        </div>
    </div>
    <div class="fab-wrapper">
        <div class="menu" id="menu">
            <a href="${pageContext.request.contextPath}/pages/module.jsp?but=mobile/saisie-client.jsp" class="menu-item">
                <i class="material-symbols-rounded">person_add</i>
                <span>Nouvelle client</span>
            </a>
            <a href="${pageContext.request.contextPath}/pages/module.jsp?but=mobile/liste-prospection.jsp" class="menu-item">
                <i class="material-symbols-rounded">person_search</i>
                <span>Prospection</span>
            </a>
            <a href="${pageContext.request.contextPath}/pages/module.jsp?but=mobile/liste-historique.jsp" class="menu-item">
                <i class="material-symbols-rounded">history</i>
                <span>Historique</span>
            </a>
        </div>

        <button class="fab-button" id="fabButton" aria-expanded="false" aria-label="Ouvrir le menu">
            <i class="material-symbols-rounded">add</i>
        </button>
    </div>


</div>
<script src="${pageContext.request.contextPath}/assets/js/mobile-js/mobile-utils.js"></script>
