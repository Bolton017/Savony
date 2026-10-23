// --- breadcrumb-utils.js ---
import { dictionnaire } from './breadcrumb-dico.js';

/**
 * Récupère un paramètre d'URL
 */
export function getParam(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
}

/**
 * Récupère le titre depuis le H1 de la page
 */
export function getTitleFromPage() {
    const titleEl = document.querySelector(".content-wrapper > h1, .content-wrapper > h3, .box-title, .content-header > h1");
    return titleEl ? titleEl.textContent.trim() : "";
}

/**
 * Génère un titre lisible depuis le param "but"
 * Détection automatique des actions (fiche, saisie, liste, creation, etc.)
 * @param {string} butValue - La valeur du paramètre "but"
 * @param {boolean} useDictionary - Si false, ignore le dictionnaire et retourne le titre de la page
 */
export function getReadableTitle(butValue, useDictionary = true) {
    if (!butValue) return "";

    // 🆕 Si on ignore le dictionnaire, retourner le titre de la page
    if (!useDictionary) {
        const pageTitle = getTitleFromPage();
        if (pageTitle) {
            const id = getParam("id");
            return id ? `${pageTitle} No ${id}` : pageTitle;
        }
        // Fallback si pas de titre trouvé
        return butValue.split("/").pop().replace(".jsp", "");
    }

    // Ex: "produits/as-ingredients-fiche.jsp" ou "vente/vente-analyse-categorie.jsp"
    const parts = butValue.split("/");

    // Fichier final: "as-ingredients-fiche.jsp" ou "vente-analyse-categorie.jsp"
    const file = parts[parts.length - 1].replace(".jsp", "");

    // Segments: ["as", "ingredients", "fiche"] ou ["vente", "analyse", "categorie"]
    const segments = file.split("-");

    // Le dernier segment (potentielle action)
    const action = segments[segments.length - 1];

    // Base complète sans l'action
    const baseComplete = segments.slice(0, -1).join("-");

    console.log(`File: ${file}, BaseComplete: ${baseComplete}, Action: ${action}`);

    let dictEntry;
    let finalAction = action;

    // 🔵 ÉTAPE 1: Vérifier d'abord si le nom complet (sans action) existe dans le dico
    // Ex: "vente-analyse-categorie" → trouve l'entrée directement
    if (dictionnaire[baseComplete]) {
        dictEntry = dictionnaire[baseComplete];
    }
        // 🔵 ÉTAPE 2: Vérifier si le nom complet (avec action) existe dans le dico
    // Ex: "graphe-ca-annuel" → trouve l'entrée directement, pas d'action séparée
    else if (dictionnaire[file]) {
        dictEntry = dictionnaire[file];
        finalAction = null; // Pas d'action séparée dans ce cas
    }
        // 🔵 ÉTAPE 3: Logique originale - utiliser le premier segment comme base
    // Ex: "as-ingredients" → base = "as", action = "ingredients"
    else {
        const base = segments.slice(0, -1).join("-");
        dictEntry = dictionnaire[base] || { default: file };
    }

    // Si toujours pas trouvé, utiliser le nom complet comme défaut
    if (!dictEntry) {
        dictEntry = { default: file };
    }

    // Récupérer le titre selon l'action
    let title = finalAction && dictEntry[finalAction]
        ? dictEntry[finalAction]
        : dictEntry.default;

    // Ajoute l'ID pour les fiches
    const id = getParam("id");
    const acte = getParam("acte");

    if ((acte === "update" || finalAction==="modif") && id) {
        let modifTitle;

        if (dictEntry["modif"]) {
            // Si "modif" existe, on l'utilise
            modifTitle = dictEntry["modif"];
        } else if (dictEntry["fiche"]) {
            // Si "modif" n'existe pas mais "fiche" existe, on remplace "fiche" par "modification"
            modifTitle = dictEntry["fiche"].replace(/Fiche/gi, "Modification");
        } else {
            // Fallback par défaut
            modifTitle = dictEntry["default"];
        }

        title = `Modification ${modifTitle} No ${id}`;

        // 🟢 ÉVITER LES DOUBLONS : enlever "Modification" en double
        title = title.replace(/Modification\s+Modification/gi, "Modification");
    } else if (id) {
        title += ` No ${id}`;
    }

    return title;
}