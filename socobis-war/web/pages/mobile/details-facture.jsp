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
            <h1 class="mobile__header-title">Détails de la facture</h1>
        </div>
    </div>

    <h2 class="h617pxSemibold" >Détails de la facture Numéro FCT0001</h2>
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
            <div class="details--bloc__title Body14pxRegular">Statut</div>
            <span class="tag orange">PARTIELLEMENT PAYÉ</span>
        </div>
        <div class="details--bloc">
            <div class="details--bloc__title Body14pxRegular">Bon de livraison</div>
            <a href="#" class="details--bloc__link">BL00001</a>
        </div>
        <div class="details--separator"></div>
        <div class="details--bloc w-100">
            <div class="details--bloc__title Body14pxRegular">Montant total à payer</div>
            <div class="details--bloc__details Body14pxSemiBold">2 160 000,00 MGA</div>
        </div>
        <div class="details--bloc w-100">
            <div class="details--bloc__title Body14pxRegular">Reste à payer</div>
            <div class="details--bloc__details Body14pxSemiBold red">2 160 000,00 MGA</div>
        </div>
        <div class="details--separator"></div>
        <div class="details--footer">
            <button type="button" class="btn btn-secondary">
                <i class="material-symbols-rounded">print</i>
                Imprimer
            </button>
            <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#factureModal">
                Ajouter un paiement
            </button>
        </div>
    </div>

    <h2 class="h617pxSemibold" >Paiement reçu :</h2>
    <div class="search-result-container">
        <div class="search-result__box facture-box">
            <div class="search-result__details">
                <h3 class="h617pxSemibold search-result__title m-0">23001 - Chapiteau</h3>
                <p class="Body14pxRegular m-0">Du: <span> 26-02-2025</span></p>
                <p class="Body14pxRegular m-0">Montant: <span>1.000.000,00 MGA</span></p>
                <p class="Body14pxRegular m-0">Remarque: <span>Amin'ny 15 ny ambony</span></p>
            </div>
        </div>

    </div>

    <div class="modal fade" id="factureModal" tabindex="-1" role="dialog" aria-labelledby="factureModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-body">
                    <h5 class="modal-title h520pxSemibold mb-6" id="factureModalLabel">Ajouter un paiement pour la facture</h5>
                    <label class="input-label">Montant</label>
                    <input class="form-control w-100" type="text" placeholder="MGA" name="montant">
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
