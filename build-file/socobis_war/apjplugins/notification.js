var mesnotifs = [];
var limit = 5;
var titre = document.title;
var check = false;
var lien = window.location.origin + "/savonnerie";

$(document).ready(function() {
    // Lancer la récupération des notifications toutes les 10 secondes
    getNotification();
    setInterval(getNotification, 30000);
});

function getNotification() {
    $.ajax({
        type: "GET",
        url: lien + "/Notification",
        dataType: "json",
        data: { nb: mesnotifs.length },
        success: function(data) {
            console.log("Notifications reçues:", data);
            mesnotifs = data || [];
            buildHTMLNotif();
        },
        error: function(err) {
            console.error("Erreur AJAX Notification:", err);
        }
    });
}

function buildHTMLNotif() {
    // Créer le style une seule fois
    if (!document.getElementById("notif-styles")) {
        var styles = `
        <style id="notif-styles">
            .dropdown-menu-notif { background-color: white !important; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); width: 350px !important; padding:0; right:0 !important; left:auto !important; }
            .dropdown-menu-notif-header { display:flex; justify-content:space-between; align-items:center; padding:10px 15px; border-bottom:1px solid #eaeaea; background-color:#f8f9fa; border-radius:8px 8px 0 0; }
            .dropdown-menu-notif-header h4 { margin:0; color:black; font-weight:bold; }
            .dropdown-menu-notif li { background-color:white; padding:10px 15px; margin:0; cursor:pointer; list-style:none; border-bottom:1px solid #eaeaea; display:flex; justify-content:space-between; align-items:center; }
            .dropdown-menu-notif li:hover { background-color:#f5f5f5; }
            .dropdown-menu-notif li:last-child { border-bottom:none; }
            .dropdown-menu-notif a { color:black; text-decoration:none; display:block; }
            .dropdown-menu-pagenotif { background-color:#dc3545; color:white !important; text-align:center; padding:10px; display:block; border-radius:0 0 8px 8px; text-decoration:none; }
            .dropdown-menu-pagenotif:hover { background-color:#bd2130; }
            .mark-all-read { display: inherit }
            .mark-all-read:hover { background-color:inherit; }
            .notif-time { font-size:0.8rem; color:gray; margin-left:5px; }
        </style>
        `;
        document.head.insertAdjacentHTML('beforeend', styles);
    }

    // Limite des notifications affichées
    limit = Math.min(5, mesnotifs.length);

    var html = `<div class='btn-group js-btn-notif' style='position:relative;'>
                    <a class='dropdown-toggle' data-toggle='dropdown' aria-expanded='false'>
                        <i class='material-symbols-rounded' style='color:var(--Text-primary); font-size:1.5rem;'>notifications</i>`;
    if (mesnotifs.length > 0) {
        html += `<span class='badge badge-ketrika js-badge-notif' id='nbnonlu' style='background-color: rgb(204,0,0);'>${mesnotifs.length}</span>`;
    }
    html += `</a>
            <ul class='dropdown-menu with-caret dropdown-menu-notif' role='menu'>
                <div class='dropdown-menu-notif-header'>
                    <h4 class="h520pxSemibold m-o" >Notifications <i class='fa fa-exclamation-circle'></i></h4>
                    <a class='mark-all-read btn btn-tertiary btn-small' href='${lien}/pages/module.jsp?but=notification/apresnotif.jsp&acte=toutvu&bute=${window.location.href.split('?but=')[1]}'>Tout marquer comme Lu</a>
                </div>`;

    if (mesnotifs.length === 0) {
        html += `<li style='text-align:center;color:grey;'>Aucune notification</li>`;
    }

    for (var i = 0; i < limit; i++) {
        html += `<li onclick="location.href='${lien}/pages/module.jsp?but=notification/apresnotif.jsp&acte=vu&id=${mesnotifs[i].id}&bute=notification/notification-fiche.jsp&classe=utils.Notification&ref=${mesnotifs[i].id}'" 
                    style='background-color: rgb(240,240,240); color:black;'>
                    ${mesnotifs[i].message} <span class='notif-time'>${mesnotifs[i].ecartdate}</span>
                 </li>`;
    }

    html += `<a class='dropdown-menu-pagenotif btn btn-primary btn-small ' href='${lien}/pages/module.jsp?but=notification/notification-liste.jsp'>Voir tout</a></ul></div>`;

    var notifElement = document.getElementById("notifrefresh");
    if (notifElement) {
        notifElement.innerHTML = html;
    } else {
        console.error("Élément avec l'ID 'notifrefresh' introuvable dans le DOM.");
    }
}
