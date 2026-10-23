<%--
  Created by IntelliJ IDEA.
  User: apple
  Date: 2026/7/8
  Time: 10:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="${pageContext.request.contextPath}/assets/css/savonnerie-mobile.css?v=20260713-1" rel="stylesheet" type="text/css" />

<div class="content-wrapper saisie-client-page"
     data-localisation-url="${pageContext.request.contextPath}/pages/module.jsp?but=mobile/localisation.jsp">
    <div class="mobile__header-container mb-5">
        <div class="mobile__title">
            <a href="javascript:history.back()" class="mobile__back-link" aria-label="Retour">
                <i class="material-symbols-rounded">arrow_back</i>
            </a>
            <img src="${pageContext.request.contextPath}/assets/img/logo-mobile-savonnerie.png" alt="mobile-logo" class="mobile__header-logo" />
            <h1 class="mobile__header-title">Ajouter veille concurentielle</h1>
        </div>
    </div>
    <div class="mobile__input-container">
        <div class="form-input w-100">
            <label for="magasin" class="input-label">Commentaire</label>
            <input class="form-control" name="commentaire" type="text" />
        </div>
        <div class="mobile__image-placeholder" data-image-picker>
            <div class="mobile__image-placeholder-content">
                <i class="material-symbols-rounded">add_photo_alternate</i>
                <span class="mobile__label-placeholder">Ajouter une photo</span>
            </div>
            <input type="file" accept="image/*" data-image-input hidden />
        </div>
        <button type="submit" style="display: initial;text-align: center;margin-top: 25vh" disabled class="btn btn-primary">Envoyer</button>
    </div>


</div>
<script src="${pageContext.request.contextPath}/assets/js/mobile-js/mobile-utils.js?v=20260710-saisie-localisation-2"></script>
