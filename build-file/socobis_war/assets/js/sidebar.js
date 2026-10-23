(function () {
    "use strict";

    function closeSidebarFallback() {
        document.body.classList.add('sidebar-collapse');
        document.body.classList.add('submenu-closed');

        var panel = document.getElementById('sidebarSubmenuPanel');
        if (panel) {
            panel.classList.add('hidden');
            panel.setAttribute('data-was-visible', 'false');
            panel.innerHTML = '';
        }

        document.querySelectorAll('.sidebar-icon-item, .submenu-item').forEach(function (el) {
            el.classList.remove('active');
        });
    }

    // Variable globale (dans la portée de la fonction anonyme) pour le tooltip
    var globalTooltip;

    // =====================================================
    // 1. INIT ET ÉCOUTEURS GLOBAUX
    // =====================================================
    document.addEventListener("DOMContentLoaded", function () {

        buildIconsPanel();

        // On attend 50ms pour laisser AdminLTE faire son initialisation
        setTimeout(function() {
            if (typeof CURRENT_MENU === 'undefined' || !CURRENT_MENU || CURRENT_MENU === "") {
                // S'il n'y a aucun menu actif, on ferme tout
                closeSidebarFallback();
            } else {
                // Sinon on restaure l'état du menu actif
                restoreActiveMenu();
            }

            // On lance la synchronisation du Toggle après avoir défini l'état initial
            syncWithToggle();
        }, 50);

        // --- NOUVEAU : Fermer le sous-menu mobile en cliquant sur l'overlay sombre ---
        document.addEventListener('click', function(e) {
            // Si on est sur un petit écran ET que le menu n'est PAS fermé
            if (window.innerWidth <= 768 && !document.body.classList.contains('sidebar-collapse')) {

                // Si le clic ne provient NI du panneau de sous-menus, NI du panneau d'icônes, NI du bouton hamburger
                if (!e.target.closest('.sidebar-submenu-panel') &&
                    !e.target.closest('.sidebar-icons-panel') &&
                    !e.target.closest('.sidebar-toggle')) {

                    // On referme le menu
                    document.body.classList.add('sidebar-collapse');
                    document.body.classList.add('submenu-closed');

                    var panel = document.getElementById('sidebarSubmenuPanel');
                    if (panel) {
                        panel.classList.add('hidden');
                        panel.setAttribute('data-was-visible', 'false');
                    }

                    // On désélectionne visuellement l'icône active pour que ça fasse propre
                    document.querySelectorAll(".sidebar-icon-item").forEach(function (el) {
                        el.classList.remove("active");
                    });
                }
            }
        });
    });

    // =====================================================
    // 2. CONSTRUCTION DU PANNEAU GAUCHE (icônes niveau 1)
    // =====================================================
    function buildIconsPanel() {
        var panel = document.querySelector(".sidebar-icons-panel");
        if (!panel) return;

        // Initialisation de l'unique Tooltip global rattaché au body
        globalTooltip = document.createElement("div");
        globalTooltip.className = "global-sidebar-tooltip";
        document.body.appendChild(globalTooltip);

        var groupSize = 5;

        // Sécurité si MENU_DATA n'est pas encore chargé
        if (typeof MENU_DATA === 'undefined' || !Array.isArray(MENU_DATA) || MENU_DATA.length === 0) {
            closeSidebarFallback();
            return;
        }

        MENU_DATA.forEach(function (menu, index) {
            if (index > 0 && index % groupSize === 0) {
                var sep = document.createElement("div");
                sep.className = "sidebar-icon-separator";
                panel.insertBefore(sep, panel.querySelector(".sidebar-logo-bottom"));
            }

            var item = document.createElement("div");
            item.className = "sidebar-icon-item";
            item.setAttribute("data-id", menu.id);

            item.innerHTML =
                '<span class="material-symbols-rounded">' + (menu.icone || "circle") + '</span>' +
                '<span class="icon-label">' + truncate(menu.libelle, 10) + '</span>';

            // Écouteur pour le Clic
            item.addEventListener("click", function () {
                globalTooltip.classList.remove("visible"); // Cache le tooltip
                onIconClick(menu, false);
            });

            // Écouteurs pour le Survol (Affichage dynamique du Tooltip)
            item.addEventListener("mouseenter", function () {
                var rect = item.getBoundingClientRect();
                globalTooltip.textContent = menu.libelle;
                globalTooltip.style.top = (rect.top + (rect.height / 2)) + "px";
                globalTooltip.style.left = (rect.right + 12) + "px";
                globalTooltip.classList.add("visible");
            });

            item.addEventListener("mouseleave", function () {
                globalTooltip.classList.remove("visible");
            });

            panel.insertBefore(item, panel.querySelector(".sidebar-logo-bottom"));
        });
    }

    // =====================================================
    // 3. CLIC OU ACTIVATION D'UNE ICÔNE
    // =====================================================
    function onIconClick(menu, isInit) {
        var panel = document.getElementById('sidebarSubmenuPanel');
        var hasFils = menu.fils && menu.fils.length > 0;

        // Marquer l'icône comme "active"
        document.querySelectorAll(".sidebar-icon-item").forEach(function (el) {
            el.classList.remove("active");
        });
        var activeIcon = document.querySelector('.sidebar-icon-item[data-id="' + menu.id + '"]');
        if (activeIcon) activeIcon.classList.add("active");

        // Gestion de l'affichage selon la présence de sous-menus
        if (hasFils) {
            // ---> Le menu A des sous-menus (niveau 2+)
            document.body.classList.remove('sidebar-collapse');
            document.body.classList.remove('submenu-closed');

            if (panel) {
                panel.setAttribute('data-was-visible', 'true');
                panel.classList.remove('hidden');
                buildSubmenuPanel(menu);
            }

        } else {
            // ---> Le menu N'A PAS de sous-menus (Niveau 1 uniquement)
            document.body.classList.add('sidebar-collapse');
            document.body.classList.add('submenu-closed');

            if (panel) {
                panel.setAttribute('data-was-visible', 'false');
                panel.classList.add('hidden');
                panel.innerHTML = ""; // On vide le panneau
            }

            // Navigation
            if (!isInit && menu.href && menu.href !== "#") {
                window.location.href = menu.href;
            }
        }
    }

    // =====================================================
    // 4. CONSTRUCTION DU PANNEAU DROIT (sous-menus)
    // =====================================================
    function buildSubmenuPanel(menu) {
        var panel = document.getElementById("sidebarSubmenuPanel");
        if (!panel) return;

        panel.innerHTML = "";

        // En-tête : titre + description
        var header = document.createElement("div");
        header.className = "submenu-header";
        header.innerHTML =
            '<h2>' + menu.libelle + '</h2>' +
            (menu.description ? '<p>' + menu.description + '</p>' : '');
        panel.appendChild(header);

        // Label de section
        var sectionLabel = document.createElement("div");
        sectionLabel.className = "submenu-section-label";
        sectionLabel.textContent = menu.libelle.toUpperCase();
        panel.appendChild(sectionLabel);

        // Items enfants
        if (menu.fils && menu.fils.length > 0) {
            menu.fils.forEach(function (fils) {
                panel.appendChild(buildSubmenuItem(fils));
            });
        }
    }

    // =====================================================
    // 5. CONSTRUCTION RÉCURSIVE D'UN ITEM DE SOUS-MENU
    // =====================================================
    function buildSubmenuItem(item) {
        var wrapper = document.createElement("div");
        var hasFils = item.fils && item.fils.length > 0;

        var link = document.createElement("a");
        link.className = "submenu-item";
        link.setAttribute("href", hasFils ? "#" : item.href);
        link.setAttribute("data-id", item.id);

        link.innerHTML =
            '<span class="material-symbols-rounded">' + (item.icone || "chevron_right") + '</span>' +
            '<span>' + item.libelle + '</span>' +
            (hasFils ? '<span class="material-symbols-rounded submenu-arrow">chevron_right</span>' : '');

        if (typeof CURRENT_MENU !== 'undefined' && String(item.id) === String(CURRENT_MENU)) {
            link.classList.add("active");
        }

        // Si ce n'est pas un sous-dossier, on gère la navigation
        if (!hasFils) {
            link.addEventListener("click", function (e) {
                e.preventDefault();

                var panel = document.getElementById('sidebarSubmenuPanel');
                var href = link.getAttribute("href");

                // Masquage visuel et transition
                if (panel) {
                    panel.classList.add('hidden');
                    panel.setAttribute('data-was-visible', 'false');
                }
                document.body.classList.add('sidebar-collapse');
                document.body.classList.add('submenu-closed');

                // Désactiver les icônes gauche
                document.querySelectorAll(".sidebar-icon-item").forEach(function (el) {
                    el.classList.remove("active");
                });

                // Attendre la fin de la transition pour vider le DOM et naviguer
                setTimeout(function () {
                    if (panel) panel.innerHTML = "";
                    if (href && href !== "#") {
                        window.location.href = href;
                    }
                }, 310);
            });
        }

        wrapper.appendChild(link);

        // Gestion de l'accordéon si c'est un dossier (niveau 3+)
        if (hasFils) {
            var children = document.createElement("div");
            children.className = "submenu-children";

            item.fils.forEach(function (petit) {
                children.appendChild(buildSubmenuItem(petit));
            });

            wrapper.appendChild(children);

            link.addEventListener("click", function (e) {
                e.preventDefault();
                var isOpen = children.classList.contains("open");
                children.classList.toggle("open", !isOpen);
                link.classList.toggle("open", !isOpen);
            });
        }

        return wrapper;
    }

    // =====================================================
    // 6. UTILITAIRES DE RESTAURATION DU MENU
    // =====================================================
    function restoreActiveMenu() {
        if (typeof CURRENT_MENU === 'undefined' || !CURRENT_MENU || CURRENT_MENU === "") {
            closeSidebarFallback();
            return;
        }

        if (typeof MENU_DATA === 'undefined' || !Array.isArray(MENU_DATA)) {
            closeSidebarFallback();
            return;
        }
        var parentMenu = findParentMenu(MENU_DATA, CURRENT_MENU);
        if (!parentMenu) {
            closeSidebarFallback();
            return;
        }

        // true = C'est une initialisation
        onIconClick(parentMenu, true);

        setTimeout(function () {
            openParentAccordions(CURRENT_MENU);
            scrollToActive();
        }, 50);
    }

    function findParentMenu(menus, targetId) {
        for (var i = 0; i < menus.length; i++) {
            if (containsId(menus[i], targetId)) return menus[i];
        }
        return null;
    }

    function containsId(menu, targetId) {
        if (String(menu.id) === String(targetId)) return true;
        if (menu.fils) {
            for (var i = 0; i < menu.fils.length; i++) {
                if (containsId(menu.fils[i], targetId)) return true;
            }
        }
        return false;
    }

    function openParentAccordions(targetId) {
        var activeEl = document.querySelector('.submenu-item[data-id="' + targetId + '"]');
        if (!activeEl) return;

        var parent = activeEl.parentElement;
        while (parent) {
            if (parent.classList.contains("submenu-children")) {
                parent.classList.add("open");
                var siblingLink = parent.previousElementSibling;
                if (siblingLink) siblingLink.classList.add("open");
            }
            parent = parent.parentElement;
            if (parent && parent.id === "sidebarSubmenuPanel") break;
        }
    }

    function scrollToActive() {
        var activeEl = document.querySelector(".submenu-item.active");
        if (activeEl) {
            activeEl.scrollIntoView({ behavior: "smooth", block: "center" });
        }
    }

    function truncate(str, maxLen) {
        if (!str) return "";
        return str.length > maxLen ? str.substring(0, maxLen) + "…" : str;
    }

    // =====================================================
    // 7. SYNCHRONISATION AVEC LE TOGGLE ADMINLTE
    // =====================================================
    function syncWithToggle() {
        var lastCollapsedState = document.body.classList.contains('sidebar-collapse');

        var observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
                if (mutation.attributeName === 'class') {
                    var isNowCollapsed = document.body.classList.contains('sidebar-collapse');

                    // Sécurité anti-boucle infinie
                    if (isNowCollapsed !== lastCollapsedState) {
                        lastCollapsedState = isNowCollapsed;

                        var panel = document.getElementById('sidebarSubmenuPanel');
                        if (!panel) return;

                        if (isNowCollapsed) {
                            panel.setAttribute('data-was-visible', panel.classList.contains('hidden') ? 'false' : 'true');
                        } else {
                            var wasVisible = panel.getAttribute('data-was-visible');
                            if (wasVisible === 'true' || !wasVisible) {
                                panel.classList.remove('hidden');
                                document.body.classList.remove('submenu-closed');
                            } else {
                                panel.classList.add('hidden');
                                document.body.classList.add('submenu-closed');
                            }
                        }
                    }
                }
            });
        });

        observer.observe(document.body, { attributes: true, attributeFilter: ['class'] });
    }

})();
