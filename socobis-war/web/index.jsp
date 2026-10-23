<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.util.Locale" %>
<%@page import="java.util.ResourceBundle" %>
<%@page import="bean.CGenUtil" %>
<%@page import="utilitaire.Utilitaire" %>
<%@ page import="java.io.*" %>

<% String but="" ; String queryString="" ; try { queryString=request.getQueryString();
    but="pages/testLogin.jsp" ; if (queryString !=null && !queryString.equals("")) { but +="?" +
            queryString; } } catch (Exception ex) { %>
<script language="JavaScript">
    alert("<%=ex.getMessage()%>");
    document.location.replace("../index.jsp");
</script>
<% } %>

<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Connexion</title>

    <link href="${pageContext.request.contextPath}/assets/css/refontlogin.css"
          rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/apj-global-style.css"
          rel="stylesheet">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/favicon.png">
</head>

<body>
<div class="page">
    <div class="frame">
        <!-- Left / Form -->
        <section class="panel-left">
            <!-- miova icon de projet -->
            <header class="brand">
                <img class="logo"
                     src="${pageContext.request.contextPath}/assets/img/logo_sav.png"
                     alt="Logo">
            </header>
            <!-- <img class="logo" src="${pageContext.request.contextPath}/assets/img/Logo-Async-Footer.png" alt="Logo Async"> -->
            <main class="card">
                <h1>Connexion</h1>
                <p class="subtitle">Accédez à vos outils de gestion</p>

                <form class="form" action="<%=but%>" method="post">
                    <label class="field">
                        <span class="label">Identifiant</span>
                        <span class="input-wrap">
                                <span class="icon" aria-hidden="true">
                                    <!-- user icon -->
                                    <svg viewBox="0 0 24 24" width="18" height="18"
                                         fill="currentColor">
                                        <path
                                                d="M12 12a5 5 0 1 0-5-5 5 5 0 0 0 5 5zm0 2c-5.33 0-8 2.67-8 6a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1c0-3.33-2.67-6-8-6z" />
                                    </svg>
                                </span>
                                <input type="text" name="identifiant"
                                       placeholder="Entrer vos identifiant" required />
                            </span>
                    </label>

                    <label class="field">
                        <span class="label">Mot de passe</span>
                        <span class="input-wrap">
                                <span class="icon" aria-hidden="true">
                                    <!-- lock icon -->
                                    <svg viewBox="0 0 24 24" width="18" height="18"
                                         fill="currentColor">
                                        <path
                                                d="M17 10h-1V7a4 4 0 0 0-8 0v3H7a2 2 0 0 0-2 2v7a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-7a2 2 0 0 0-2-2zm-6 0V7a3 3 0 0 1 6 0v3z" />
                                    </svg>
                                </span>
                                <input id="password-input" type="password" name="passe"
                                       placeholder="Entrer votre mot de passe" required />
                                <button id="toggle-password" class="toggle-eye" type="button"
                                        aria-label="Afficher le mot de passe" aria-pressed="false"
                                        title="Afficher le mot de passe">
                                    <svg viewBox="0 0 24 24" width="18" height="18"
                                         fill="currentColor">
                                        <path
                                                d="M12 5C7 5 2.73 8.11 1 12c1.73 3.89 6 7 11 7s9.27-3.11 11-7c-1.73-3.89-6-7-11-7zm0 12a5 5 0 1 1 5-5 5 5 0 0 1-5 5zm0-8a3 3 0 1 0 3 3 3 3 0 0 0-3-3z" />
                                    </svg>
                                </button>
                            </span>
                    </label>

                    <!-- <button class="btn-primary" type="submit">Se connecter</button> -->
                    <button class="btn-primary" id="login-btn" type="submit">
                        <span id="login-btn-text">Se connecter</span>
                        <!-- <span id="login-btn-loader"
                            style="display:none;vertical-align:middle;margin-left:8px;">
                            <svg width="22" height="22" viewBox="0 0 50 50">
                                <circle cx="25" cy="25" r="20" fill="none"
                                    stroke="#fff" stroke-width="5"
                                    stroke-linecap="round"
                                    stroke-dasharray="31.4 31.4"
                                    stroke-dashoffset="0">
                                    <animateTransform attributeName="transform"
                                        type="rotate" from="0 25 25" to="360 25 25"
                                        dur="0.8s" repeatCount="indefinite" />
                                </circle>
                            </svg>
                        </span> -->
                    </button>
                </form>
            </main>

            <footer class="footer">
                <img class="logo"
                     src="${pageContext.request.contextPath}/assets/img/Logo-Async-Footer.png"
                     alt="Logo Async">
                <span class="by">by BICI</span>
            </footer>
        </section>

        <!-- Right / Illustration -->
        <aside class="panel-right" aria-hidden="true">
            <div class="image">
            </div>
        </aside>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/js/password-toggle.js"></script>
</body>

</html>
<!-- script loader -->
<!-- <script>
document.addEventListener('DOMContentLoaded', function () {
var form = document.querySelector('.form');
var btn = document.getElementById('login-btn');
var btnText = document.getElementById('login-btn-text');
var btnLoader = document.getElementById('login-btn-loader');
if (form && btn) {
form.addEventListener('submit', function (e) {
btn.disabled = true;
btn.style.background = '#bdbdbd';
btnText.style.opacity = '0.6';
btnLoader.style.display = 'inline-block';
});
}
});
</script> -->