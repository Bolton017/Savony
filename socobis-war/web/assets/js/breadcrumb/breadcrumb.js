
// --- breadcrumb.js ---
import { getReadableTitle, getParam } from './breadcrumb-utils.js';

document.addEventListener("DOMContentLoaded", () => {
    const BREAD_KEY = "breadcrumb";
    let isExpanded = false; // État du breadcrumb (réduit ou étendu)

    // --- 1️⃣ Ajout du lien de retour ---
    function addBackLink() {
        const titleEl = document.querySelector(".content-wrapper > h1, .content-wrapper > h3, .box-title,.content-header > h1");
        if (!titleEl) return;

        let backContainer = document.querySelector(".back-link-container");
        if (!backContainer) {
            backContainer = document.createElement("nav");
            backContainer.classList.add("back-link-container");
            titleEl.insertAdjacentElement("beforebegin", backContainer);
        }

        const stored = JSON.parse(localStorage.getItem(BREAD_KEY) || "[]");
        const previousUrl = stored.length > 1 ? stored[stored.length - 2].value : (document.referrer || "#");
        const isDirectAccess = stored.length <= 1 && (previousUrl === "" || previousUrl === window.location.href);

        backContainer.innerHTML = `
      <a onclick='history.back()' class="back-link"${isDirectAccess ? ' style="pointer-events:none;opacity:0.5;"' : ''}>
        <span class="material-symbols-rounded">chevron_left</span> Retour
      </a>`;

        // Gestion du clic sur le back-link
        if (!isDirectAccess) {
            const backLink = backContainer.querySelector(".back-link");
            backLink.addEventListener("click", (event) => {
                event.preventDefault();

                // Coupe le breadcrumb (enlève le dernier élément)
                if (stored.length > 1) {
                    const newStored = stored.slice(0, -1);
                    localStorage.setItem(BREAD_KEY, JSON.stringify(newStored));
                }

                // Navigation vers la page précédente
                window.location.href = previousUrl;
            });
        }
    }

    // --- 2️⃣ Sélecteurs de menu ---
    const menuLinks = document.querySelectorAll(
        ".skin-yellow-light .sidebar a, .sidebar-menu .treeview-menu > li > a,.logo,.logo-mini,.vd-header>a,.sidebar-submenu-panel .submenu-item"
    );

    // --- 3️⃣ Création du conteneur breadcrumb ---
    function getBreadcrumbContainer() {
        let container = document.querySelector(".breadcrumb-container");

        if (!container) {
            container = document.createElement("nav");
            container.classList.add("breadcrumb-container");

            // Injection sous le titre
            const titleEl = document.querySelector(".content-wrapper > h1, .content-wrapper > h3, .box-title,.content-header>h1");
            if (titleEl && titleEl.parentNode) {
                titleEl.insertAdjacentElement("afterend", container);
            } else {
                document.querySelector(".content-wrapper")?.prepend(container);
            }
        }
        return container;
    }

    const breadcrumbContainer = getBreadcrumbContainer();

    function changeTitleAndMeta(title) {
        // Titre onglet et meta
        document.title = title;
        let meta = document.querySelector('meta[name="page-key"]');
        if (!meta) {
            meta = document.createElement("meta");
            meta.setAttribute("name", "page-key");
            document.head.appendChild(meta);
        }
        meta.setAttribute("content", but);

        // Titre visible
        const titleEl = document.querySelector(".content-wrapper > h1, .content-wrapper > h3, .box-title,.content-header > h1");
        if (titleEl) titleEl.textContent = title;
    }

    // --- 🆕 4️⃣ Rendu du breadcrumb avec système de collapse ---
    function renderBreadcrumb() {
        const stored = JSON.parse(localStorage.getItem(BREAD_KEY) || "[]");

        // 🆕 Cacher le breadcrumb s'il n'y a qu'un seul élément
        if (stored.length <= 1) {
            breadcrumbContainer.innerHTML = "";
            breadcrumbContainer.style.display = "none";
            return;
        }

        // Afficher le breadcrumb s'il y a 2 éléments ou plus
        breadcrumbContainer.style.display = "";
        breadcrumbContainer.innerHTML = "";

        const shouldCollapse = stored.length > 3 && !isExpanded;

        // --- 🔹 LOGIQUE DE COLLAPSE ---
        if (shouldCollapse) {
            // Afficher uniquement les 3 derniers éléments + bouton "..."

            // 1️⃣ Créer le bouton "..." (ellipsis) avec style inline
            const ellipsisBtn = document.createElement("a");
            ellipsisBtn.href = "#";
            ellipsisBtn.innerHTML = `<span class="material-symbols-rounded" style="padding: 2px;background-color: var(--Onyx-050);border-radius: 4px;">more_horiz</span> <span class="material-symbols-rounded">arrow_forward_ios</span>`;
            ellipsisBtn.setAttribute("aria-label", "Voir le reste du chemin");
            ellipsisBtn.setAttribute("aria-expanded", "false");
            ellipsisBtn.setAttribute("title", "Voir le reste du chemin");

            // Style inline pour s'intégrer avec ton breadcrumb existant
            ellipsisBtn.style.cssText = `
                display: inline-flex;
                align-items: center;
                color: #666;
                text-decoration: none;
                cursor: pointer;
                transition: color 0.2s ease;
            `;

            // Event click pour expand
            ellipsisBtn.addEventListener("click", (e) => {
                e.preventDefault();
                isExpanded = true;
                ellipsisBtn.setAttribute("aria-expanded", "true");
                renderBreadcrumb(); // Re-render avec tous les éléments
            });

            // Hover effect
            ellipsisBtn.addEventListener("mouseenter", () => {
                ellipsisBtn.style.color = "#3498db";
            });
            ellipsisBtn.addEventListener("mouseleave", () => {
                ellipsisBtn.style.color = "#666";
            });

            breadcrumbContainer.appendChild(ellipsisBtn);

            // 2️⃣ Afficher les 3 derniers éléments
            const lastThree = stored.slice(-3);
            lastThree.forEach((item, index) => {
                const link = createBreadcrumbLink(item, stored.length - 3 + index, stored);
                breadcrumbContainer.appendChild(link);
            });

        } else {
            // --- 🔹 AFFICHAGE NORMAL (tous les éléments) ---
            stored.forEach((item, index) => {
                const link = createBreadcrumbLink(item, index, stored);
                breadcrumbContainer.appendChild(link);
            });
        }
    }

    // --- 🆕 Fonction utilitaire pour créer un lien breadcrumb ---
    function createBreadcrumbLink(item, index, stored) {
        const link = document.createElement("a");
        link.href = item.value;

        // Séparateur dans le lien (ton style original)
        if (index < stored.length - 1) {
            link.innerHTML = `${item.key} <span class="material-symbols-rounded">arrow_forward_ios</span>`;
        } else {
            link.textContent = item.key;
            link.classList.add("active");
        }

        // === 🟦🟦 Logique : couper le breadcrumb sur clic ===
        link.addEventListener("click", (event) => {
            event.preventDefault();
            const cutIndex = index;

            let newStored = stored.slice(0, cutIndex + 1);
            localStorage.setItem(BREAD_KEY, JSON.stringify(newStored));

            // Reset l'état expanded
            isExpanded = false;

            // Navigation vers la page
            window.location.href = item.value;
        });

        return link;
    }

    // --- 5️⃣ Reset sur clic de menu ---
    menuLinks.forEach(link => {
        link.addEventListener("click", () => {
            localStorage.removeItem(BREAD_KEY);
            isExpanded = false; // Reset l'état
        });
    });

    // --- 6️⃣ Gestion de la page actuelle ---
    const but = getParam("but");
    if (but) {
        // 🆕 MODIFICATION ICI : Décider si on ignore le dictionnaire
        const forbidden = ["idvaldesce", "bondecommande"];

        const useDictionary = !forbidden.some(value => but.includes(value));
        const title = getReadableTitle(but, useDictionary);
        console.log("Page Title:", title);

        const url = window.location.href;

        // Check if on Page list without clicking on menu
        if (title.includes("Liste")) {
            localStorage.removeItem(BREAD_KEY);
            isExpanded = false; // Reset l'état
        }else if(title.includes("Saisie") || title.includes("Modification")){
            addBackLink();
            changeTitleAndMeta(title);
            renderBreadcrumb();
            return;
        }


        let stored = JSON.parse(localStorage.getItem(BREAD_KEY) || "[]");

        // Remove only the 'd','valeur','inc' parameter for comparison
        const removeParams = (url) => {
            try {
                const urlObj = new URL(url);
                urlObj.searchParams.delete('d');
                urlObj.searchParams.delete('valeur');
                urlObj.searchParams.delete('tab');
                urlObj.searchParams.delete('currentMenu');
                return urlObj.toString();
            } catch (e) {
                return url.replace(/[?&]d=[^&]*/g, '').replace(/\?$/, '');
            }
        };

        var urlWithoutD = removeParams(url);
        const normalizedUrl = normalizeUrl(urlWithoutD);
        const alreadyIn = stored.find(item => removeParams(item.value) === normalizedUrl);

        if (!alreadyIn) {
            stored.push({ key: title, value: normalizedUrl });
            localStorage.setItem(BREAD_KEY, JSON.stringify(stored));
        }
        changeTitleAndMeta(title);

        // Affiche le breadcrumb
        renderBreadcrumb();
    }

    // --- 🆕 Fonction de normalisation des URLs ---
    /**
     * Normalise une URL en retirant les paramètres vides et en triant les paramètres
     * pour permettre une comparaison correcte
     */
    function normalizeUrl(url) {
        try {
            const urlObj = new URL(url);
            const params = new URLSearchParams(urlObj.search);

            // Créer un nouveau URLSearchParams sans les paramètres vides
            const cleanParams = new URLSearchParams();

            for (const [key, value] of params.entries()) {
                // Ne garder que les paramètres non vides
                if (value && value.trim() !== '') {
                    cleanParams.set(key, value);
                }
            }

            // Trier les paramètres pour avoir toujours le même ordre
            cleanParams.sort();

            // Reconstruire l'URL normalisée
            urlObj.search = cleanParams.toString();

            return urlObj.toString();
        } catch (e) {
            // Si l'URL n'est pas valide, retourner l'URL originale
            console.warn("URL invalide, impossible de normaliser:", url);
            return url;
        }
    }
});