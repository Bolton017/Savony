<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="prevision.Prevision" %>
<%@page import="affichage.*" %>
<%@page import="user.*" %>
<%@page import="utils.*" %>
<%@ page import="annexe.Point" %>
<%@ page import="utilitaire.*" %>
<%@ page import="caisse.*" %>
<%@ page import="java.net.URLEncoder" %>

<%
    try{
        String lien = (String) session.getValue("lien");

//        String point = session.getAttribute("idPoint").toString();
        String point = null;

        UserEJB user = (UserEJB) session.getValue("u");
        String daty = Utilitaire.dateDuJour();
        String idCloture = request.getParameter("id");

%>
<link href="${pageContext.request.contextPath}/assets/css/vente-directe.css" rel="stylesheet" type="text/css" />
<!--
Modal "Fermeture de session"
Design Figma : node-id 1316:53833

Intégration :
- Placer ce fragment dans ta JSP, à l'intérieur d'un conteneur modal existant
(ou utiliser le wrapper .modal-overlay ci-dessous si tu n'en as pas déjà un).
- Le modal ne doit PAS pouvoir être fermé par clic extérieur ou Echap
(annotation Figma) : aucun handler de fermeture n'est câblé ici, seuls
les 3 boutons d'action agissent.
- Les 3 actions (déconnexion / envoi mail / impression Z) sont des points
d'intégration à brancher sur tes appels serveur réels (AJAX, submit, etc.)
— voir les fonctions JS en bas, marquées TODO.
-->

<style>
    .modal-overlay {
        position: fixed;
        inset: 0;
        background: rgba(28, 31, 33, 0.45);
        display: flex;
        justify-content: center;
        z-index: 100000;
        padding-top: 90px;
    }

    .session-close-card {
        background: #ffffff;
        border: 1px solid var(--Border, #f3f4f4);
        border-radius: var(--radius-r3, 16px);
        padding: var(--Bases-4-space-6, 24px);
        display: flex;
        flex-direction: column;
        gap: var(--Bases-4-space-6, 24px);
        width: 100%;
        max-width: 522px;
        box-sizing: border-box;
        font-family: 'DM Sans', sans-serif;
    }

    .session-close-card .scc-header {
        display: flex;
        flex-direction: column;
        gap: 16px;
    }

    .session-close-card .scc-title {
        margin: 0;
        font-family: 'DM Sans', sans-serif;
        font-weight: 600;
        font-size: 20px;
        line-height: 30px;
        color: var(--Text-text-primary, #1c1f21);
    }

    .session-close-card .scc-description {
        margin: 0;
        font-family: 'DM Sans', sans-serif;
        font-weight: 400;
        font-size: 14px;
        line-height: normal;
        color: var(--Text-text-primary, #1c1f21);
    }

    .session-close-card .scc-description strong {
        font-weight: 600;
    }

    .session-close-card .scc-actions {
        display: flex;
        align-items: center;
        justify-content: space-between;
        width: 100%;
        flex-wrap: wrap;
        gap: 12px;
    }

    .session-close-card .scc-actions-right {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    /* Boutons — classes réutilisées : btn btn-danger btn-tertiary / btn btn-secondary / btn btn-primary
       Le style ci-dessous ne définit que ce qui est spécifique à ce composant
       (icône + libellé alignés) ; le look du bouton lui-même vient de tes
       classes .btn existantes. */
    .session-close-card .btn {
        display: inline-flex;
        align-items: center;
        gap: var(--Bases-4-space-2, 8px);
        min-height: 40px;
        padding: var(--Bases-4-space-2, 8px) var(--Bases-4-space-3, 12px);
        font-family: 'DM Sans', sans-serif;
        font-weight: 600;
        font-size: 14px;
        cursor: pointer;
        border-radius: var(--radius-r1, 4px);
    }

    .session-close-card .btn .material-symbols-rounded {
        font-size: 24px;
        line-height: 1;
    }

    .session-close-card .btn:disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }

    /* Inline | http://localhost:8080/aigledor/pages/module.jsp?but=caisse/mvt/fermeture-session.jsp */

    .box-body {
        padding: 20px;
    }

    .box {
        max-width: 730px;
        border-radius: 16px !important;
        height: fit-content;
    }

    #btnSeDeconnecter {
        border: none;
        color: var(--Error-base);
    }

</style>

<div class="modal-overlay" id="modalFermetureSession">
    <div class="box">

        <div class="box-body">
            <div class="scc-header">
                <h2 class="scc-title h329pxBold">Fermeture de votre session</h2>
                <p class="scc-description h617pxRegular">
                    N'oubliez pas d'<strong>imprimer votre ticket Z</strong> et d'<strong>envoyer votre rapport par mail</strong>
                    avant de fermer la session, sans cela vos données de caisse ne seront pas archivées.
                </p>
            </div>

            <div class="scc-actions box-footer borderless">
                <a href="deconnexion.jsp"
                   class="btn btn-danger btn-tertiary"
                   id="btnSeDeconnecter">
                    <span class="material-symbols-rounded">logout</span>
                    Se déconnecter
                </a>

                <%
                    String pdfUrl = request.getContextPath() + "/ExportPDF?action=cloturecaisse&id="
                            + URLEncoder.encode(idCloture, "UTF-8");
                %>
                <button type="button" class="btn btn-primary pull-right" id="btnImprimerRapportZ"
                        onclick="window.open('<%= pdfUrl %>')">
                    <span class="material-symbols-rounded">confirmation_number</span>
                    Imprimer le rapport Z.
                </button>

                <a href="${pageContext.request.contextPath}/pages/module.jsp?but=accueil.jsp" class="btn btn-secondary pull-right" style="margin-right: 8px"  id="btnEnvoyerRapportMail" onclick="envoyerRapportMail()">
                    <span class="material-symbols-rounded">home</span>
                    <span id="btnEnvoyerRapportMailLabel">Revenir à l'acceuil</span>
                </a>

            </div>
        </div>

    </div>
</div>

<script>
    (function () {
        // Empêche toute fermeture par clic sur l'overlay ou par Echap :
        // seuls les boutons d'action du modal peuvent agir.
        var overlay = document.getElementById('modalFermetureSession');
        overlay.addEventListener('click', function (e) {
            e.stopPropagation();
        });
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && overlay.style.display !== 'none') {
                e.preventDefault();
                e.stopPropagation();
            }
        }, true);
    })();

    function seDeconnecter() {
        // TODO : brancher sur ta logique réelle de déconnexion (submit form / redirect / appel serveur)
        console.log('Déconnexion demandée');
    }

    function envoyerRapportMail() {
        var btn = document.getElementById('btnEnvoyerRapportMail');
        var label = document.getElementById('btnEnvoyerRapportMailLabel');

        // TODO : remplacer par ton appel réel (fetch/AJAX) d'envoi du rapport par mail.
        // Exemple d'intégration :
        // fetch('/rapport/envoyerMail', { method: 'POST' })
        //   .then(function (res) {
        //     if (res.ok) { marquerMailEnvoye(); }
        //   });

        // Ici : simulation immédiate du passage en état "envoyé" côté client.
        marquerMailEnvoye();
    }

    function marquerMailEnvoye() {
        var btn = document.getElementById('btnEnvoyerRapportMail');
        var label = document.getElementById('btnEnvoyerRapportMailLabel');
        btn.disabled = true;
        label.textContent = 'Rapport mail envoyé';
    }

    function imprimerRapportZ() {
        var daty = "<%= daty %>";
        var point = "<%= point %>";

        window.open(
            "<%=request.getContextPath()%>/ExportPDF?action=cloturecaisse&daty="
            + encodeURIComponent(daty)
            + "&point="
            + encodeURIComponent(point)

        );
    }
</script>
<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>
