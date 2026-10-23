-- Stefan

-- SOCOBISRECTIFDONNEE.AS_INGREDIENT_MAINTENANCE_LIB source

CREATE TABLE LOG_DEPARTEMENT (
    ID VARCHAR2(255) PRIMARY KEY,
    VAL VARCHAR2(255),
    DESCE VARCHAR2(255)
);

CREATE OR REPLACE VIEW AS_INGREDIENT_MAINTENANCE_LIB  AS
SELECT
    am.ID,
    am.IDINGREDIENT,
    am.IDENTITE,
    am.REFERENCEOBJET,
    am.MARQUEOBJET,
    am.MODELEOBJET,
    am.NUMEROSERIEOBJET,
    am.DESCRIPTIONOBJET,
    am.QUALITEOBJET,
    am.ETATOBJET,
    am.LOCALISATIONOBJET,
    am.PUISSANCEOBJET,
    am.OBSERVATIONOBJET,
    am.TYPERATTACHEMENT,
    am.ESTENGIN,
    am.LIBELLE,
    am.DATEAQUISITION,

    ai.libelle AS INGREDIENTLIB,
    am.IDENTITE AS IDENTITELIB,
    qo.VAL AS QUALITEOBJETLIB,
    eo.VAL AS ETATOBJETLIB,
    ld.val AS localisationObjetLib,

    CASE
        WHEN am.ESTENGIN = 1 THEN 'Oui'
        ELSE 'Non'
        END AS ESTENGINLIB,

    l.id AS idligne,
    l.val AS idlignelib,
    am.pu AS PU,

    (
        NVL(am.ID, '') || ' | ' ||
        NVL(ai.libelle, '') || ' | ' ||
        NVL(am.IDENTITE, '') || ' | ' ||
        NVL(qo.val, '') || ' | ' ||
        NVL(eo.val, '') || ' | ' ||
        NVL(ld.val, '') || ' | ' ||
        NVL(l.val, '') || ' | ' ||
        NVL(am.LIBELLE, '')
        ) AS MOTSCLESSS

FROM AS_INGREDIENTS ai
         JOIN AS_INGREDIENT_MAINTENANCE am ON ai.ID = am.IDINGREDIENT
         LEFT JOIN QUALITESOBJETMAINTENANCE qo ON am.QUALITEOBJET = qo.ID
         LEFT JOIN ETATOBJETMAINTENANCE eo ON am.ETATOBJET = eo.ID
         LEFT JOIN LOG_DEPARTEMENT ld ON am.LOCALISATIONOBJET = ld.ID
         LEFT JOIN LIGNE l ON l.ID = am.IDLIGNE
;