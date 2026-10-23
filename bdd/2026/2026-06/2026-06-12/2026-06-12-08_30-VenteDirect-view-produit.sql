
create or replace view ST_INGREDIENTSAUTOVENTE_CPL as
SELECT
    ai.ID,
    ai.LIBELLE as libelle,
    ai.SEUIL,
    ai.UNITE,
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
    ai.TVA,
    1 AS taux,
    ai.COMPTE_VENTE AS compte,
    ai.LIBELLE|| ' '||ai.COULEUR|| ' '||ai.TAILLE||'  '||
    LISTAGG(
            cps.LIBELLE
    ) WITHIN GROUP (ORDER BY cps.LIBELLE) AS libellecomposant,
    ai.COULEUR,
    ai.TAILLE,
    ai.codebarre,
    ai.REFERENCE,
    ai.codegros,
    ai.pvgros,
    u.VAL AS UNITELIB,
    CONCAT(concat(ai.libelle,' - '),u.val) AS designation
FROM
    AS_INGREDIENTS ai
    LEFT JOIN AS_RECETTE ar ON ar.IDPRODUITS = ai.ID
    LEFT JOIN AS_INGREDIENTS cps ON cps.ID  = ar.IDINGREDIENTS
    LEFT JOIN AS_UNITE u ON ai.unite=u.id
WHERE ai.ACTIF=1
GROUP BY
    ai.ID,
    ai.LIBELLE,
    ai.SEUIL,
    ai.UNITE,
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
    ai.TVA,
    ai.COULEUR,
    ai.TAILLE,
    ai.REFERENCE,
    ai.codebarre,
    u.val,
    ai.codegros,
    ai.pvgros;



create or replace view ST_INGREDIENTSAUTOVENTE_MGA as
select sic.ID,
       sic.LIBELLE,
       sic.SEUIL,
       sic.UNITE,
       sic.QUANTITEPARPACK,
       sic.PU,
       sic.ACTIF,
       sic.PHOTO,
       sic.CALORIE,
       sic.DURRE,
       sic.COMPOSE,
       sic.CATEGORIEINGREDIENT,
       sic.IDFOURNISSEUR,
       sic.DATY,
       sic.QTELIMITE,
       sic.PV,
       sic.LIBELLEVENTE,
       sic.SEUILMIN,
       sic.SEUILMAX,
       sic.PUACHATUSD,
       sic.PUACHATEURO,
       sic.PUACHATAUTREDEVISE,
       sic.PUVENTEUSD,
       sic.PUVENTEEURO,
       sic.PUVENTEAUTREDEVISE,
       sic.ISVENTE,
       sic.ISACHAT,
       sic.COMPTE_VENTE,
       sic.COMPTE_ACHAT,
       sic.TVA,
       t.TAUX,
       sic.COMPTE,
       sic.LIBELLECOMPOSANT,
       sic.COULEUR,
       sic.TAILLE,
       sic.CODEBARRE,
       sic.reference,
       sic.unitelib AS unitelib,
       sic.CODEGROS
from ST_INGREDIENTSAUTOVENTE_CPL sic,
     TAUXDECHANGE_MAXDATY t
WHERE t.IDDEVISE = 'AR';



create or replace view ST_INGREDIENTSVENTEPOS as
SELECT
    ai.ID,
    ai.LIBELLE || ' - ' || c.val || ' - ' ||
    CASE
        WHEN ai.POINTURE IS NOT NULL AND ai.POINTURE <> 0
            THEN CAST(ai.POINTURE AS VARCHAR2(255))
        WHEN ai.TAILLE IS NOT NULL
            THEN tl.val
        ELSE ''
        END AS libelle,
    ai.SEUIL,
    ai.UNITE,
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
    ai.PV2 as pv,
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
    ai.TVA,
    1 AS taux,
    ai.COMPTE_VENTE AS compte,
    ai.LIBELLE|| ' '||ai.COULEUR|| ' '||ai.TAILLE||'  '||
    LISTAGG(
            cps.LIBELLE || ' - ' || c.val ||
            CASE
                WHEN cps.POINTURE IS NOT NULL AND cps.POINTURE <> 0 THEN CAST(cps.POINTURE AS VARCHAR2(255))
                WHEN cps.TAILLE IS NOT NULL THEN tl.val
                ELSE ''
                END
    ) WITHIN GROUP (ORDER BY cps.LIBELLE) AS libellecomposant,
    ai.TAILLE,
    ai.codebarre,
    ai.REFERENCE,
    ai.codegros,
    ai.pvgros,
    u.VAL AS UNITELIB,
    CONCAT(concat(ai.libelle,' - '),u.val) AS designation,
    CASE
        WHEN ai.POINTURE IS NOT NULL AND ai.pointure <> 0 THEN CAST(ai.pointure AS VARCHAR2(255))
        WHEN ai.taille   IS NOT NULL THEN tl.val
END AS tailleLib,
    c.val as couleur
FROM
    AS_INGREDIENTS ai
        LEFT JOIN AS_RECETTE ar ON ar.IDPRODUITS = ai.ID
        LEFT JOIN AS_INGREDIENTS cps ON cps.ID  = ar.IDINGREDIENTS
        LEFT JOIN AS_UNITE u ON ai.unite=u.id
        LEFT JOIN TAILLE tl ON tl.id = ai.TAILLE
        LEFT JOIN COULEUR c ON c.id = ai.IDCOULEUR
where ai.PV2>0 AND ai.ACTIF = 1
GROUP BY
    ai.ID,
    ai.LIBELLE,
    ai.SEUIL,
    ai.UNITE,
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
    ai.PV2,
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
    ai.TVA,
    ai.COULEUR,
    ai.TAILLE,
    ai.REFERENCE,
    ai.codebarre,
    u.val,
    ai.codegros,
    ai.pvgros, ai.POINTURE, tl.val, c.VAL, ai.COULEUR;