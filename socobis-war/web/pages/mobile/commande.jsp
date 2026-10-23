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
            <h1 class="mobile__header-title">Prise de commande</h1>
        </div>
        <div class="mobile__header-actions">
            <a href="${pageContext.request.contextPath}/pages/module.jsp?but=mobile/valider-panier.jsp" class=""><i class="material-symbols-rounded">shopping_cart</i> </a>
            <span class="mobile__panier-badge">0</span>
        </div>
    </div>
    <div class="mobile__search-container mb-5">
        <div class="input-with-addons with-btn-left">
            <div class="btn btn-left">
                <i class="material-symbols-rounded">search</i>
            </div>
            <input type="text" class="form-control mobile__search-box" placeholder="Rechercher un produit" />
        </div>
    </div>
    <div class="search-result-container">
        <div class="search-result__box commande-box">
            <div class="search-result__details">
                <h3 class="Body14pxSemiBold search-result__title m-0">27050092 - SAVON DE MENAGE MINOSY (50Gr x 48Mx)</h3>
                <p class="Body14pxRegular m-0 price-tag">38 000.0 MGA / Carton</p>
            </div>
            <div class="d-flex w-100">
                <div class="input-with-addons with-btn-right with-btn-left">
                    <button class="btn btn-secondary btn-left"><i class="material-symbols-rounded">remove</i> </button>
                    <input type="text" name="qte" class="form-control" value="0">
                    <button class="btn btn-secondary btn-right"><i class="material-symbols-rounded">add</i> </button>
                </div>
                <button class="btn btn-primary"><i class="material-symbols-rounded">shopping_cart</i> Ajouter </button>
            </div>
        </div>
    </div>


</div>
<script src="${pageContext.request.contextPath}/assets/js/mobile-js/mobile-utils.js"></script>
