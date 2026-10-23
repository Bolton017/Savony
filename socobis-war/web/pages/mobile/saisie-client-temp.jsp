<%--
  Created by IntelliJ IDEA.
  User: tokiniainarakotoarisedy
  Date: 16/09/2026
  Time: 15:14
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
      <h1 class="mobile__header-title">Ajouter un client</h1>
    </div>
  </div>
  <div class="mobile__input-container">
    <div class="form-input w-100">
      <label for="magasin" class="input-label">Magasin</label>
      <input class="form-control" name="magasin" type="text" />
    </div>
    <div class="form-input w-100">
      <label for="proprio" class="input-label">Nom propriétaire</label>
      <input class="form-control" name="proprio" type="text" />
    </div>
    <div class="form-input w-100">
      <label for="contact" class="input-label">Contact</label>
      <input class="form-control" name="contact" type="text" />
    </div>
    <div class="form-input w-100">
      <label for="localisation" class="input-label">Localisation</label>
      <div class="mobile__localisation-field">
        <input id="clientLocalisation"
               class="form-control mobile__localisation-input"
               name="localisation"
               type="text"
               readonly />
        <button type="button" class="mobile__localisation-action" aria-label="Choisir une localisation">
          <i class="material-symbols-rounded">location_on</i>
        </button>
      </div>
    </div>
    <div class="form-input w-100">
      <label for="categorie" class="input-label">Catégorie</label>
      <select class="form-control" name="categorie">
        <option value="">Sélectionner une catégorie</option>
        <option value="1">Catégorie 1</option>
        <option value="2">Catégorie 2</option>
        <option value="3">Catégorie 3</option>
      </select>
    </div>

    <div class="mobile__image-placeholder" data-image-picker>
      <div class="mobile__image-placeholder-content">
        <i class="material-symbols-rounded">add_photo_alternate</i>
        <span class="mobile__label-placeholder">Ajouter une photo</span>
      </div>
      <input type="file" accept="image/*" data-image-input hidden />
    </div>
    <button type="submit" style="display: initial;text-align: center" disabled class="btn btn-primary">Envoyer</button>
  </div>


</div>
<script src="${pageContext.request.contextPath}/assets/js/mobile-js/mobile-utils.js?v=20260710-saisie-localisation-2"></script>