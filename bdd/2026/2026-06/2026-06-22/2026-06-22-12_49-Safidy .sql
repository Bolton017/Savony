CREATE OR REPLACE  VIEW ST_INGREDIENTSVENTEPOS_PRIX ("ID", "LIBELLE", "SEUIL", "UNITE", "QUANTITEPARPACK", "PU", "ACTIF", "PHOTO", "CALORIE", "DURRE", "COMPOSE", "CATEGORIEINGREDIENT", "IDFOURNISSEUR", "DATY", "QTELIMITE", "PV", "LIBELLEVENTE", "SEUILMIN", "SEUILMAX", "PUACHATUSD", "PUACHATEURO", "PUACHATAUTREDEVISE", "PUVENTEEURO", "PUVENTEUSD", "PUVENTEAUTREDEVISE", "ISVENTE", "ISACHAT", "COMPTE_VENTE", "COMPTE_ACHAT", "TVA", "TAUX", "COMPTE", "LIBELLECOMPOSANT", "TAILLE", "CODEBARRE", "REFERENCE", "CODEGROS", "PVGROS", "UNITELIB", "DESIGNATION", "COULEUR","RN") AS
SELECT *
FROM (
         SELECT
             t.id,
             t.LIBELLE,
             t.SEUIL,
             t.UNITE,
             t.QUANTITEPARPACK,
             t.pu,
             t.ACTIF,
             t.photo,
             t.CALORIE,
             t.DURRE,
             t.COMPOSE,
             t.CATEGORIEINGREDIENT,
             t.IDFOURNISSEUR,
             t.daty,
             t.QTELIMITE,
             CAST(t.PRIXUNITAIRE AS NUMBER(32, 2)) AS pv,
             t.LIBELLEVENTE,
             t.SEUILMIN,
             t.SEUILMAX,
             t.PUACHATUSD,
             t.PUACHATEURO,
             t.PUACHATAUTREDEVISE,
             t.PUVENTEEURO,
             t.PUVENTEUSD,
             t.PUVENTEAUTREDEVISE,
             t.ISVENTE,
             t.ISACHAT,
             t.COMPTE_VENTE,
             t.COMPTE_ACHAT,
             t.TVA,
             1 AS taux,
             t.COMPTE_VENTE AS compte,
             t.LIBELLE AS libellecomposant,
             '' AS taille,
             '' AS codebarre,
             '' AS reference,
             '' AS codegros,
             1.5 AS pvgros,
             t.UNITE AS unitelib,
             t.LIBELLE AS designation,
             '' AS couleur,

             ROW_NUMBER() OVER (
            PARTITION BY t.id
            ORDER BY t.daty DESC
        ) rn

         FROM AS_INGREDIENT_VENTE_LIB_PRX t
         WHERE t.IDTYPECLIENT = 'TYPE001'
           AND t.daty <= SYSDATE
     )
WHERE rn = 1
ORDER BY daty DESC;