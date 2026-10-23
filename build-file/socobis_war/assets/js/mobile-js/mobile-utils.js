// fab buttons
const fabButton = document.getElementById('fabButton');
const menu = document.getElementById('menu');

if (fabButton && menu) {
    fabButton.addEventListener('click', () => {
        const isOpen = menu.classList.toggle('open');
        fabButton.classList.toggle('open', isOpen);
        fabButton.setAttribute('aria-expanded', isOpen);
        fabButton.setAttribute('aria-label', isOpen ? 'Fermer le menu' : 'Ouvrir le menu');
    });
}

const localisationMap = document.getElementById('localisationMap');
const localisationCoordinates = document.getElementById('localisationCoordinates');
const localisationSelectedCoordinates = document.getElementById('localisationSelectedCoordinates');

if (localisationMap && window.L) {
    const localisationPage = localisationMap.closest('.localisation-page');
    const localisationHeader = localisationPage ? localisationPage.querySelector('.mobile__page-header') : null;
    const localisationMapWrapper = localisationPage ? localisationPage.querySelector('.localisation__map-wrapper') : null;
    const latitude = Number(localisationMap.dataset.lat);
    const longitude = Number(localisationMap.dataset.lng);
    const zoom = Number(localisationMap.dataset.zoom) || 16;
    const defaultPosition = [latitude, longitude];
    const localisationIcon = L.divIcon({
        className: 'localisation__marker',
        iconSize: [34, 44],
        iconAnchor: [17, 42]
    });

    const setCoordinatesText = (coordinatesValue) => {
        if (localisationCoordinates) {
            localisationCoordinates.value = coordinatesValue;
        }

        if (localisationSelectedCoordinates) {
            localisationSelectedCoordinates.textContent = coordinatesValue;
        }
    };
    const updateCoordinates = (position) => {
        setCoordinatesText(`${position[0].toFixed(6)}, ${position[1].toFixed(6)}`);
    };
    const updateMapHeight = () => {
        if (!localisationPage || !localisationMapWrapper) {
            return;
        }

        const pageStyle = window.getComputedStyle(localisationPage);
        const pagePaddingTop = parseFloat(pageStyle.paddingTop) || 0;
        const pagePaddingBottom = parseFloat(pageStyle.paddingBottom) || 0;
        const headerHeight = localisationHeader ? localisationHeader.offsetHeight : 0;
        const availableHeight = window.innerHeight - pagePaddingTop - pagePaddingBottom - headerHeight;

        localisationMapWrapper.style.height = `${Math.max(240, availableHeight)}px`;
    };
    const refreshMapSize = () => {
        window.requestAnimationFrame(() => {
            updateMapHeight();
            map.invalidateSize({
                pan: false
            });
        });
    };

    const map = L.map(localisationMap, {
        zoomControl: false,
        attributionControl: false
    }).setView(defaultPosition, zoom);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        updateWhenIdle: false,
        updateWhenZooming: false,
        keepBuffer: 6,
        crossOrigin: true
    }).addTo(map);

    const marker = L.marker(defaultPosition, {
        icon: localisationIcon
    }).addTo(map);

    if (localisationCoordinates && localisationCoordinates.value) {
        setCoordinatesText(localisationCoordinates.value);
    } else {
        updateCoordinates(defaultPosition);
    }

    map.on('click', (event) => {
        const selectedPosition = [
            event.latlng.lat,
            event.latlng.lng
        ];

        marker.setLatLng(selectedPosition);
        updateCoordinates(selectedPosition);
    });

    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition((position) => {
            const currentPosition = [
                position.coords.latitude,
                position.coords.longitude
            ];

            map.setView(currentPosition, zoom);
            marker.setLatLng(currentPosition);
            updateCoordinates(currentPosition);
            refreshMapSize();
        }, refreshMapSize, {
            enableHighAccuracy: true,
            maximumAge: 0,
            timeout: 10000
        });
    }

    updateMapHeight();
    map.whenReady(refreshMapSize);
    window.addEventListener('resize', refreshMapSize);
    window.addEventListener('orientationchange', refreshMapSize);
    window.setTimeout(refreshMapSize, 0);
    window.setTimeout(refreshMapSize, 250);
    window.setTimeout(refreshMapSize, 800);

    if (window.ResizeObserver) {
        const mapObserver = new ResizeObserver(refreshMapSize);
        mapObserver.observe(localisationMap);
    }
}

const saisieClientPage = document.querySelector('.saisie-client-page');
const clientLocalisationInput = document.querySelector(
    'input[data-localisation-input="true"], #clientLocalisation'
);

if (clientLocalisationInput && !clientLocalisationInput.closest('.mobile__localisation-field')) {
    const localisationField = document.createElement('div');
    localisationField.className = 'mobile__localisation-field';

    clientLocalisationInput.parentNode.insertBefore(localisationField, clientLocalisationInput);
    localisationField.appendChild(clientLocalisationInput);
    clientLocalisationInput.classList.add('mobile__localisation-input');

    const localisationButton = document.createElement('button');
    localisationButton.type = 'button';
    localisationButton.className = 'mobile__localisation-action';
    localisationButton.setAttribute('aria-label', 'Choisir une localisation');
    localisationButton.innerHTML = '<i class="material-symbols-rounded">location_on</i>';
    localisationField.appendChild(localisationButton);
}

const clientLocalisationAction = document.querySelector('.mobile__localisation-action');
const clientDraftKey = 'savonnerie.mobile.clientDraft';
const selectedLocationKey = 'savonnerie.mobile.selectedLocation';

const saveClientDraft = () => {
    if (!saisieClientPage) {
        return;
    }

    const draft = {};
    saisieClientPage.querySelectorAll('input[name], select[name], textarea[name]').forEach((field) => {
        if (field.type === 'checkbox') {
            draft[field.name] = field.checked;
            return;
        }

        draft[field.name] = field.value;
    });

    sessionStorage.setItem(clientDraftKey, JSON.stringify(draft));
};

if (saisieClientPage) {
    const savedDraft = sessionStorage.getItem(clientDraftKey);
    const currentUrl = new URL(window.location.href);
    const locationFromUrl = currentUrl.searchParams.get('localisation');
    const selectedLocation = locationFromUrl || sessionStorage.getItem(selectedLocationKey);

    if (savedDraft) {
        try {
            const draft = JSON.parse(savedDraft);

            Object.keys(draft).forEach((name) => {
                const field = saisieClientPage.querySelector(`[name="${name}"]`);

                if (!field) {
                    return;
                }

                if (field.type === 'checkbox') {
                    field.checked = Boolean(draft[name]);
                    return;
                }

                field.value = draft[name];
            });
        } catch (error) {
            sessionStorage.removeItem(clientDraftKey);
        }
    }

    if (selectedLocation && clientLocalisationInput) {
        clientLocalisationInput.value = selectedLocation;
        sessionStorage.removeItem(selectedLocationKey);
        saveClientDraft();

        if (locationFromUrl) {
            currentUrl.searchParams.delete('localisation');
            window.history.replaceState({}, document.title, currentUrl.toString());
        }
    }

    const openLocalisationPage = () => {
        if (saisieClientPage.dataset.localisationUrl) {
            saveClientDraft();
            window.location.href = saisieClientPage.dataset.localisationUrl;
        }
    };

    if (clientLocalisationInput) {
        clientLocalisationInput.addEventListener('click', openLocalisationPage);
    }

    if (clientLocalisationAction) {
        clientLocalisationAction.addEventListener('click', openLocalisationPage);
    }
}

if (localisationCoordinates) {
    const validateLocationButton = document.querySelector('.localisation__validate-button');

    if (validateLocationButton) {
        validateLocationButton.addEventListener('click', () => {
            const selectedLocation = localisationCoordinates.value;
            const returnUrl = new URL(validateLocationButton.dataset.returnUrl, window.location.origin);

            sessionStorage.setItem(selectedLocationKey, selectedLocation);
            returnUrl.searchParams.set('localisation', selectedLocation);
            window.location.href = returnUrl.toString();
        });
    }
}

// input add-on
document.addEventListener('DOMContentLoaded', () => {
    const MIN_QTE = 0;
    const STEP = 1;

    document.addEventListener('click', (e) => {
        const btn = e.target.closest('.btn-left, .btn-right');
        if (!btn) return;

        // On récupère le parent commun aux boutons et à l'input
        const wrapper = btn.closest('.input-with-addons');
        if (!wrapper) return;

        const input = wrapper.querySelector('.form-control:not(.mobile__search-box)');
        if (!input) return;

        let qte = parseInt(input.value, 10) || 0;

        if (btn.classList.contains('btn-left')) {
            qte = Math.max(MIN_QTE, qte - STEP);
        } else if (btn.classList.contains('btn-right')) {
            qte = qte + STEP;
        }

        input.value = qte;
        input.dispatchEvent(new Event('change', { bubbles: true }));
    });

    // N'autorise que les chiffres dans l'input
    document.addEventListener('input', (e) => {
        if (e.target instanceof Element && e.target.matches('.input-with-addons .form-control:not(.mobile__search-box)')) {
            let val = e.target.value.replace(/\D/g, '');
            e.target.value = val === '' ? '' : parseInt(val, 10);
        }
    });

// Corrige la valeur au blur si vide ou invalide
    document.addEventListener('blur', (e) => {
        if (e.target instanceof Element && e.target.matches('.input-with-addons .form-control:not(.mobile__search-box)')) {
            let qte = parseInt(e.target.value, 10);
            if (isNaN(qte) || qte < MIN_QTE) qte = MIN_QTE;
            e.target.value = qte;
        }
    }, true);
});
document.addEventListener('DOMContentLoaded', () => {
    /* =========================================================
    SELECTEUR D'IMAGE AVEC PREVIEW + COMPRESSION
    ========================================================= */
    const MAX_WIDTH = 1280;
    const JPEG_QUALITY = 0.7;

    document.querySelectorAll('[data-image-picker]').forEach((picker) => {
        const fileInput = picker.querySelector('[data-image-input]');
        const label = picker.querySelector('.mobile__label-placeholder');

        // Clic sur la zone => ouvre le sélecteur natif
        picker.addEventListener('click', () => {
            fileInput.click();
        });

        // Une image est choisie
        fileInput.addEventListener('change', async (e) => {
            const file = e.target.files[0];
            if (!file) return;

            if (!file.type.startsWith('image/')) {
                alert('Merci de sélectionner un fichier image.');
                return;
            }

            try {
                const compressedDataUrl = await compressImage(file, MAX_WIDTH, JPEG_QUALITY);

                // L'image devient le fond du placeholder, avec le masque noir géré en CSS
                picker.style.backgroundImage = `url(${compressedDataUrl})`;
                picker.classList.add('has-image');
                if (label) label.textContent = 'Changer la photo';

                // On stocke le résultat compressé pour l'envoi au backend
                picker.dataset.imageData = compressedDataUrl;

                // Exemple pour activer le bouton "Envoyer" une fois l'image prête
                document.dispatchEvent(new CustomEvent('image:selected', {
                    detail: { dataUrl: compressedDataUrl, fileName: file.name }
                }));
            } catch (err) {
                console.error('Erreur de compression image :', err);
                alert("Une erreur est survenue lors du traitement de l'image.");
            }
        });
    });

    /**
     * Redimensionne et compresse une image via canvas.
     * @param {File} file
     * @param {number} maxWidth
     * @param {number} quality
     * @returns {Promise<string>} dataURL de l'image compressée
     */
    function compressImage(file, maxWidth, quality) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();

            reader.onload = (e) => {
                const img = new Image();

                img.onload = () => {
                    let { width, height } = img;

                    if (width > maxWidth) {
                        height = Math.round((height * maxWidth) / width);
                        width = maxWidth;
                    }

                    const canvas = document.createElement('canvas');
                    canvas.width = width;
                    canvas.height = height;

                    const ctx = canvas.getContext('2d');
                    ctx.drawImage(img, 0, 0, width, height);

                    const dataUrl = canvas.toDataURL('image/jpeg', quality);
                    resolve(dataUrl);
                };

                img.onerror = reject;
                img.src = e.target.result;
            };

            reader.onerror = reject;
            reader.readAsDataURL(file);
        });
    }

});
// Validation générique de formulaire (plusieurs pages partagent ce script)
document.addEventListener('DOMContentLoaded', () => {
    const submitButtons = document.querySelectorAll('.btn-primary[type="submit"]:not([data-no-validate])');
    if (!submitButtons.length) return;

    const isFieldVisible = (field) => !field.hidden && field.offsetParent !== null;

    // Remonte depuis le bouton submit jusqu'au premier ancêtre qui contient au moins un .form-control
    // => c'est le plus proche ancêtre commun entre le bouton et les champs
    const findFormContainer = (submitBtn) => {
        let el = submitBtn.parentElement;
        while (el && el !== document.body) {
            if (el.querySelector('.form-control')) return el;
            el = el.parentElement;
        }
        return submitBtn.parentElement; // fallback si rien trouvé
    };

    const formEntries = Array.from(submitButtons).map((submitBtn) => ({
        submitBtn,
        container: findFormContainer(submitBtn)
    }));

    const checkAllForms = () => {
        formEntries.forEach(({ submitBtn, container }) => {
            const fields = Array.from(container.querySelectorAll('.form-control')).filter(isFieldVisible);
            const allFieldsFilled = fields.every((field) => field.value.trim() !== '');

            // Si un sélecteur d'image est présent dans le même conteneur, il devient une condition
            const imagePicker = container.querySelector('[data-image-picker]');
            const hasImage = imagePicker ? Boolean(imagePicker.dataset.imageData) : true;

            submitBtn.disabled = !(allFieldsFilled && hasImage);
        });
    };

    document.addEventListener('input', checkAllForms);
    document.addEventListener('change', checkAllForms);
    document.addEventListener('image:selected', checkAllForms);

    checkAllForms();
});
//////////////////////////////////////////////
// Panier
// Suppression d'un produit du panier (bouton close sur commande-box)
document.addEventListener('DOMContentLoaded', () => {
    document.addEventListener('click', (e) => {
        const removeBtn = e.target.closest('.commande-box .btn-danger');
        if (!removeBtn || removeBtn.closest('form')) return;

        const box = removeBtn.closest('.commande-box');
        if (!box) return;

        const productId = box.dataset.productId || null;

        // Petite animation de disparition avant suppression du DOM
        box.classList.add('is-removing');

        box.addEventListener('transitionend', () => {
            box.remove();
            enleverPanier(productId, box);
        }, { once: true });

        // Fallback si transitionend ne se déclenche pas (ex: pas de transition CSS définie)
        setTimeout(() => {
            if (box.isConnected) {
                box.remove();
                enleverPanier(productId, box);
            }
        }, 300);
    });
});

/**
 * À implémenter : logique métier de suppression du panier (API, state, etc.)
 * @param {string|null} productId - identifiant du produit (data-product-id)
 * @param {HTMLElement} boxElement - référence à l'élément DOM déjà retiré (utile si tu as besoin du titre/prix avant suppression complète)
 */
function enleverPanier(productId, boxElement) {
    console.log('À implémenter : enleverPanier', productId);
}

// Filtre de recherche sur les cartes mobiles (search-result__box) via data-search-value
document.addEventListener('DOMContentLoaded', () => {
    const STYLE_ID = 'mobile-search-filter-styles';
    if (!document.getElementById(STYLE_ID)) {
        const style = document.createElement('style');
        style.id = STYLE_ID;
        style.textContent =
            '.search-result__box.mobile-search-hidden { display: none !important; }\n' +
            '.mobile-search-empty { display: none; padding: 20px 12px; text-align: center; color: var(--Text-secondary, #64748b); font-size: 13px; }\n' +
            '.mobile-search-empty.is-visible { display: block; }';
        document.head.appendChild(style);
    }

    const normalize = (value) => String(value || '')
        .normalize('NFD')
        .replace(/[\u0300-\u036f]/g, '')
        .toLocaleLowerCase('fr')
        .replace(/\s+/g, ' ')
        .trim();

    const applyFilter = (container, emptyState, rawValue) => {
        const query = normalize(rawValue);
        const boxes = container.querySelectorAll('.search-result__box');
        let visibleCount = 0;

        boxes.forEach((box) => {
            const searchValue = normalize(box.getAttribute('data-search-value'));
            const match = query === '' || searchValue.includes(query);
            box.classList.toggle('mobile-search-hidden', !match);
            if (match) visibleCount++;
        });

        if (emptyState) {
            emptyState.classList.toggle('is-visible', visibleCount === 0 && boxes.length > 0);
        }
    };

    document.querySelectorAll('.mobile__search-box').forEach((input) => {
        const wrapper = input.closest('.content-wrapper');
        const container = wrapper ? wrapper.querySelector('.search-result-container') : null;
        if (!container) return;

        let emptyState = container.parentElement.querySelector('.mobile-search-empty');
        if (!emptyState) {
            emptyState = document.createElement('p');
            emptyState.className = 'mobile-search-empty';
            emptyState.textContent = 'Aucun résultat trouvé.';
            container.insertAdjacentElement('afterend', emptyState);
        }

        let debounceTimer = null;
        input.addEventListener('input', () => {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(() => {
                applyFilter(container, emptyState, input.value);
            }, 120);
        });
    });
});