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
            <h1 class="mobile__header-title">Visites</h1>
        </div>
    </div>
    <div class="mobile__search-container mb-5">
        <div class="input-with-addons with-btn-left">
            <div class="btn btn-left">
                <i class="material-symbols-rounded">search</i>
            </div>
            <input type="text" class="form-control mobile__search-box" placeholder="Recherche d'une visite" />
        </div>
    </div>
    <div class="search-result-container">
        <div class="search-result__box facture-box">
            <div class="search-result__details">
                <h3 class="h617pxSemibold search-result__title m-0">Visite Numéro VST00001</h3>
                <p class="Body14pxRegular m-0">Du: <span> 26-02-2025</span></p>
                <p class="Body14pxRegular m-0">Agent: <span> Jean Doe</span></p>
                <p class="Body14pxRegular m-0">Remarque: <span>Miandry ny tompony amin'ny 15</span></p>
            </div>
        </div>
    </div>
    <div class="fab-wrapper">
        <button class="fab-button" id="fabButton" aria-expanded="false" aria-label="Ouvrir le menu" data-toggle="modal" data-target="#visiteModal">
            <i class="material-symbols-rounded">add</i>
        </button>
    </div>
    <div class="modal fade" id="visiteModal" tabindex="-1" role="dialog" aria-labelledby="visiteModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-body">
                    <h5 class="modal-title h520pxSemibold mb-6" id="visiteModalLabel">Ajouter un commentaire pour la visite</h5>
                    <label class="input-label">Remarque</label>
                    <input class="form-control w-100 mb-6" type="text" placeholder="Remarque" name="remarque">
                    <div class="d-flex gap-2">
                        <button type="button" style="display: initial;text-align: center" class="btn btn-secondary w-50" data-dismiss="modal" aria-label="Close">Annuler</button>
                        <button type="button" style="display: initial;text-align: center" class="btn btn-primary w-50">Confirmer</button>
                    </div>
                </div>
            </div>
        </div>
    </div>


</div>
<script src="${pageContext.request.contextPath}/assets/js/mobile-js/mobile-utils.js"></script>
