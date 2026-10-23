-- SOCOBISPROD2411.TRAVAUXCPL source

CREATE OR REPLACE FORCE VIEW "SOCOBISPROD2411"."TRAVAUXCPL" ("ID", "LANCEPAR", "CIBLE", "REMARQUE", "LIBELLE", "BESOIN", "DATY", "IDOFFILLE", "IDOF", "LANCEPARLIB", "CIBLELIB", "ETAT", "ETATLIB", "FABRICATIONPREC", "FABRICATIONSUIV", "IDINGREDIENTMAINTENANCE", "INGREDIENTMAINTENANCELIB") AS 
  SELECT
    f.ID,f.LANCEPAR,f.CIBLE,f.REMARQUE,f.LIBELLE,f.BESOIN,f.DATY,f.idOffille,nvl(f.idof, off.idmere) AS idof,
    p.val AS lanceparLib,
    p2.val AS cibleLib,
    f.etat AS etat,
    CASE
        WHEN f.ETAT=1
            THEN 'CR&Eacute;E'
        WHEN f.ETAT=11
            THEN 'VALID&Eacute;E'
        WHEN f.ETAT=0
            THEN 'ANNUL&Eacute;E'
        WHEN f.ETAT=21
            THEN 'ENTAM&Eacute;E'
        WHEN f.ETAT=31
            THEN 'BLOQU&Eacute;E'
        WHEN f.ETAT=41
            THEN 'TERMIN&Eacute;E'
        END AS ETATLIB,
    f.FABRICATIONPREC,
    f.FABRICATIONSUIV,
    off.idIngredients AS idIngredientMaintenance,
    off.remarque AS ingredientMaintenanceLib
FROM TRAVAUX f
         LEFT JOIN ENTITE p ON p.id = f.lancepar
         LEFT JOIN MAGASIN p2 ON p2.id = f.cible
         LEFT JOIN ORDRETRAVAUXFILLE off ON f.idoffille = off.id;