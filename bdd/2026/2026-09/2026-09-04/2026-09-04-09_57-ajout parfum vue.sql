create or replace view ST_INGREDIENTSAUTO as
SELECT
    ai.ID,
    ai.LIBELLE,
    ai.SEUIL,
    au.val AS UNITE,
    au.id AS idUNITE,
    ai.QUANTITEPARPACK,
    ai.PU,
    ai.ACTIF,
    ai.PHOTO,
    ai.CALORIE,
    ai.DURRE,
    ai.COMPOSE,
    ai.CATEGORIEINGREDIENT,
    ai.IDFOURNISSEUR,
    ai.DATY,
    ai.QTELIMITE,
    ai.PV,
    ai.LIBELLEVENTE,
    ai.SEUILMIN,
    ai.SEUILMAX,
    ai.PUACHATUSD,
    ai.PUACHATEURO,
    ai.PUACHATAUTREDEVISE,
    ai.PUVENTEUSD,
    ai.PUVENTEEURO,
    ai.PUVENTEAUTREDEVISE,
    ai.ISVENTE,
    ai.ISACHAT,
    ai.COMPTE_VENTE,
    ai.COMPTE_ACHAT,
    CASE
        WHEN ai.COMPTE_VENTE IS NOT NULL THEN ai.COMPTE_VENTE
        ELSE ai.COMPTE_ACHAT
        END AS compte,
    au.VAL AS UNITELIB,
    ca.IDDEPARTEMENT,
    ai.parfums
FROM AS_INGREDIENTS ai
         LEFT JOIN AS_UNITE au ON au.id = ai.UNITE
         LEFT JOIN CATEGORIEINGREDIENT ca ON ca.id = ai.CATEGORIEINGREDIENT
WHERE ai.actif = 1;

    /

