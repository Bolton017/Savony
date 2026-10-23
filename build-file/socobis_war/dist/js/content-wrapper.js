/**
 * Content Wrapper Height Calculator
 *
 * This script automatically calculates and sets the min-height of elements with class 'content-wrapper'
 * to ensure proper layout and footer positioning across all pages.
 *
 * How it works:
 * 1. Finds all elements with class 'content-wrapper' on the page
 * 2. Skips elements with data-skip-height-calc attribute (opt-out)
 * 3. Gets the navbar height dynamically (element with class 'navbar')
 * 4. Calculates min-height using the formula:
 *    min-height = body height - (navbar height + 51px footer height)
 * 5. Sets the calculated height as min-height with !important
 * 6. Stores the calculated value in data-calculated-height attribute
 *
 * When it runs:
 * - On page load (after all resources including images and CSS are fully loaded)
 * - When dynamic content is loaded (via custom 'dynamicContentLoaded' event)
 * - On window resize (debounced by 250ms)
 *
 * Usage:
 * Just include this script in your HTML:
 * <script src="${pageContext.request.contextPath}/dist/js/content-wrapper.js"></script>
 *
 * To skip height calculation for specific pages, add the data attribute:
 * <div class="content-wrapper" data-skip-height-calc="true">
 */

(function () {
    'use strict';

    const FOOTER_HEIGHT = 51;

    function getNavbarHeight() {
        const navbar = document.querySelector('.navbar');
        return navbar ? navbar.offsetHeight : 0;
    }

    function applyMinHeight(wrapper) {
        if (wrapper.getAttribute('data-skip-height-calc') !== null) {
            console.log('✓ Skipping height calculation');
            return;
        }

        const minHeight = window.innerHeight - (getNavbarHeight() + FOOTER_HEIGHT) + 20;
        wrapper.style.setProperty('min-height', minHeight + 'px', 'important');
        wrapper.setAttribute('data-calculated-height', minHeight);
        console.log('→ Min-height applied:', minHeight + 'px');
    }

    function init() {
        const wrapper = document.querySelector('.content-wrapper');
        if (!wrapper) return;

        // Calcul initial
        applyMinHeight(wrapper);

        // Observer le contenu : recalcule si le wrapper grandit
        const resizeObserver = new ResizeObserver(function () {
            const currentMin = parseInt(wrapper.getAttribute('data-calculated-height') || '0');
            const needed = window.innerHeight - (getNavbarHeight() + FOOTER_HEIGHT) + 20; // Ajouter +20 ici aussi

            if (wrapper.scrollHeight > currentMin) {
                const newMin = Math.max(needed, wrapper.scrollHeight + 20); // Et ici aussi
                wrapper.style.setProperty('min-height', newMin + 'px', 'important');
                wrapper.setAttribute('data-calculated-height', newMin);
                console.log('→ ResizeObserver adjusted min-height:', newMin + 'px');
            }
        });

        resizeObserver.observe(wrapper);

        // Recalcul sur resize fenêtre
        let resizeTimeout;
        window.addEventListener('resize', function () {
            clearTimeout(resizeTimeout);
            resizeTimeout = setTimeout(function () {
                applyMinHeight(wrapper);
            }, 250);
        });

        // Recalcul sur contenu dynamique (AJAX, onglets)
        document.addEventListener('dynamicContentLoaded', function () {
            console.log('Dynamic content loaded - recalculating');
            // Petit délai pour laisser les scripts injectés s'exécuter
            setTimeout(function () {
                applyMinHeight(wrapper);
            }, 100);
        });
    }

    // Lancer après le DOM
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    // Lancer aussi après load complet (images, fonts)
    window.addEventListener('load', function () {
        const wrapper = document.querySelector('.content-wrapper');
        if (wrapper) applyMinHeight(wrapper);
    });

})();

// ============================================================================
// Synchronisation de hauteur pour les éléments .sync-height
// ============================================================================

// Fonction pour synchroniser la hauteur des éléments .sync-height
function syncHeights() {
    const elements = document.querySelectorAll('.sync-height');

    if (elements.length === 0) {
        return;
    }

    // Réinitialiser les hauteurs pour obtenir les hauteurs naturelles
    elements.forEach(function(el) {
        el.style.height = 'auto';
    });

    // Trouver la hauteur maximale
    let maxHeight = 0;
    elements.forEach(function(el) {
        const height = el.offsetHeight;
        if (height > maxHeight) {
            maxHeight = height;
        }
    });

    // Appliquer la hauteur maximale à tous les éléments
    elements.forEach(function(el) {
        el.style.height = maxHeight + 'px';
    });

    console.log('✓ Hauteurs synchronisées à:', maxHeight + 'px');
}

// Initialiser syncHeights au chargement de la page
window.addEventListener('load', function() {
    setTimeout(syncHeights, 100);
});