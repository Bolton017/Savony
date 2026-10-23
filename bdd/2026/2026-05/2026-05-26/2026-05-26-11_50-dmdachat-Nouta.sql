-- SAVONNERIEFINAL0519.DMDACHATLIB source
 
CREATE OR REPLACE  VIEW "DMDACHATLIB" ("ID", "DATY", "FOURNISSEUR", "FOURNISSEURLIB", "REMARQUE", "DATELIMITE", "IDMAGASINLIB", "IDCATEGORIELIB", "ETAT", "ETATLIB", "IDOBJET", "MOTSCLESSS") AS 

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

        UPPER(

        NVL(f.nom, '') || ' ' ||

        NVL(da.remarque, '') || ' ' ||

        NVL(m.val, '') || ' ' ||

        NVL(ci.val, '') || ' ' ||

        NVL(da.idObjet, '') || ' ' ||

        TO_CHAR(da.daty, 'DD/MM/YYYY') || ' ' ||

        TO_CHAR(da.dateLimite, 'DD/MM/YYYY') || ' ' ||

        NVL(

            CASE

                WHEN da.ETAT = 0 THEN 'ANNULEE'

                WHEN da.ETAT = 1 THEN 'CREE'

                WHEN da.ETAT = 11 THEN 'VISEE DIRECTEUR'

                WHEN da.ETAT = 3 THEN 'VISEE DMT'

                WHEN da.ETAT = 4 THEN 'VISEE CI'
                
                WHEN da.ETAT = 9 THEN 'VISEE CG'

            END

        , '')

    ) AS MOTSCLESSS

FROM DMDACHAT da

         LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur

         LEFT JOIN MAGASIN2 m ON da.idMagasin = m.ID

         LEFT JOIN categorieIngredient ci ON da.idCategorie = ci.id

;
 