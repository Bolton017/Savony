-- SAVONNERIEFINAL0519.DMDACHATLIB source

CREATE OR REPLACE  VIEW "DMDACHATLIB" ("ID", "DATY", "FOURNISSEUR", "FOURNISSEURLIB", "REMARQUE", "DATELIMITE", "IDMAGASINLIB", "IDCATEGORIELIB", "ETAT", "ETATLIB", "IDOBJET", "SERVICE","SERVICELIB") AS 
  SELECT
    da.id,
    da.daty,
    da.fournisseur,
    f.nom AS fournisseurlib,
    da.remarque,
    da.dateLimite,
    m.val AS idMagasinLib,
    ci.val AS idCategorieLib,
    da.etat,
    CASE
        WHEN da.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN da.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN da.ETAT = 2
            THEN 'VIS&Eacute;E par Chef de D&eacute;partement'
        WHEN da.ETAT = 11
            THEN 'VIS&Eacute;E par Directeur'
        WHEN da.ETAT = 3
            THEN 'VIS&Eacute;E par DMT'
        WHEN da.ETAT = 4
            THEN 'VIS&Eacute;E par CI'
        WHEN da.ETAT = 9
            THEN 'VIS&Eacute;E par CG'
        END AS etatlib,
    da.idObjet,
    da.service,
    s.libelle AS servicelib
FROM DMDACHAT da
    LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur
    LEFT JOIN MAGASIN2 m ON da.idMagasin = m.ID
    LEFT JOIN categorieIngredient ci ON da.idCategorie = ci.id
    LEFT JOIN service s ON s.compte = da.SERVICE ;