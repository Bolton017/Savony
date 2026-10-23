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
            <h1 class="mobile__header-title">Commandes</h1>
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
    <div class="search-result-container panier">
        <div class="search-result__box commande-box" data-product-id="27050092">
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
                <button class="btn btn-tertiary btn-danger"><i class="material-symbols-rounded">close</i></button>
            </div>
        </div>
    </div>
    <div class="mobile--total__container">
        <div class="mobile--total d-flex mb-5">
            <span class="Body14pxSemiBold">Total</span>
            <span class="h617pxSemibold">230 000 MGA</span>
        </div>
        <div class="mobile--total__footer d-flex gap-2">
            <button class="btn btn-secondary w-50">Annuler</button>
            <button class="btn btn-primary w-50" data-toggle="modal" data-target="#panierModal">Valider</button>
        </div>
    </div>
    <div class="modal fade" id="panierModal" tabindex="-1" role="dialog" aria-labelledby="panierModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header nopadding borderless">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="font-size: 40px;color: var(--Text-primary);text-shadow: none;position: absolute;top: 6px;right: 16px;z-index: 9999;">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <h5 class="modal-title h520pxSemibold" id="panierModalLabel">Confirmation</h5>
                    <p>Êtes-vous prêt à valider ces commandes ?</p>
                    <div class="mobile--total d-flex">
                        <span class="h617pxSemibold">Total</span>
                        <span class="h617pxSemibold">230 000 MGA</span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" style="display: initial;text-align: center" class="btn btn-primary w-100">Confirmer</button>
                </div>
            </div>
        </div>
    </div>


</div>
<script src="${pageContext.request.contextPath}/assets/js/mobile-js/mobile-utils.js"></script>
