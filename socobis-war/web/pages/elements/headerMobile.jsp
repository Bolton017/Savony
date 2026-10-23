<%@ page import="user.UserEJB" %><%
    UserEJB u = (UserEJB) session.getAttribute("u");
    String lien = (String) session.getAttribute("lien");
    String home_page = u.getHome_page();
%>
<div class="mobile__header-container mb-5">
    <div class="mobile__title">
        <a href="javascript:history.back()" class="mobile__back-link" aria-label="Retour">
            <i class="material-symbols-rounded">arrow_back</i>
        </a>
        <a href="<%=lien%>?but=<%=home_page%>" class="mobile__header-logo-link" aria-label="Accueil">
            <img src="${pageContext.request.contextPath}/assets/img/logo-mobile-savonnerie.png" alt="Accueil" class="mobile__header-logo" />
        </a>
        <h1 class="mobile__header-title">${param.titre}</h1>
    </div>
</div>