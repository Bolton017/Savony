<%--
  Created by IntelliJ IDEA.
  User: apple
  Date: 2026/7/10
  Time: 10:17
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" rel="stylesheet" />
<link href="${pageContext.request.contextPath}/assets/css/savonnerie-mobile.css?v=20260710-localisation-3" rel="stylesheet" type="text/css" />

<div class="content-wrapper localisation-page">
    <div class="mobile__page-header">
        <a href="javascript:history.back()" class="mobile__back-link" aria-label="Retour">
            <i class="material-symbols-rounded">arrow_back</i>
        </a>
        <img src="${pageContext.request.contextPath}/assets/img/logo-mobile-savonnerie.png" alt="Savonnerie Tropicale" class="mobile__page-logo" />
        <h1 class="mobile__page-title">Localisation</h1>
    </div>

    <div class="localisation__search">
        <input id="localisationCoordinates"
               class="form-control localisation__input"
               type="text"
               value="18°53'42.0&quot;S 47°33'38.5&quot;E"
               aria-label="Coordonnées GPS" />
        <button type="button" class="localisation__search-button" aria-label="Rechercher">
            <i class="material-symbols-rounded">search</i>
        </button>
    </div>

    <div class="localisation__map-wrapper">
        <div id="localisationMap"
             class="localisation__map"
             data-lat="-18.895"
             data-lng="47.560694"
             data-zoom="17"></div>
    </div>

    <div class="localisation__bottom-panel">
        <div class="localisation__selected-point">
            <i class="material-symbols-rounded">location_on</i>
            <span id="localisationSelectedCoordinates">18°53'42.0&quot;S 47°33'38.5&quot;E</span>
        </div>
        <button type="button"
                class="btn btn-primary localisation__validate-button"
                data-return-url="${pageContext.request.contextPath}/pages/module.jsp?but=mobile/saisie-client.jsp">
            Valider la localisation
        </button>
    </div>
</div>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
        integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
<script src="${pageContext.request.contextPath}/assets/js/mobile-js/mobile-utils.js?v=20260710-localisation-4"></script>
