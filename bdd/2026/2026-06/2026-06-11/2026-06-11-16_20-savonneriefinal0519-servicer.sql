-- SAVONNERIEFINAL0519.AS_BONDECOMMANDE_MERECPL source

CREATE OR REPLACE  VIEW "AS_BONDECOMMANDE_MERECPL" ("ID", "DATY", "ETAT", "REMARQUE", "DESIGNATION", "MODEPAIEMENT", "FOURNISSEUR", "REFERENCE", "DATELIMITE", "MODEPAIEMENTLIB", "FOURNISSEURLIB", "MONTANTTVA", "MONTANTHT", "MONTANTTTC", "MONTANTTTCARIARY", "IDDEVISELIB", "IDDEVISE", "IDORIGINE", "IDMAGASIN", "IDMAGASINLIB", "ETATLIB", "MOTSCLESSS","SERVICE") AS 
  SELECT
    ab.ID,
    ab.DATY,
    ab.ETAT,
    ab.REMARQUE,
    ab.DESIGNATION,
    ab.MODEPAIEMENT,
    ab.FOURNISSEUR,
    ab.REFERENCE,
    ab.dateLimite,
    mp.VAL AS MODEPAIEMENTLIB,
    F.NOM AS FOURNISSEURLIB,
    abf.montantTVA,
    abf.montantHT,
    CAST(nvl((abf.montantHT + abf.montantTVA),0) AS NUMBER(30,2)) AS montantTTC ,
    CAST(nvl((abf.montantHT + abf.montantTVA) * abf.TAUXDECHANGE,0) AS NUMBER(30,2)) AS montantTTCAriary,
    d.val AS idDeviselib,
    d.id AS IDDEVISE,
    AB.idOrigine,
    AB.IDMAGASIN,
    m.VAL AS idMagasinlib,
    CASE
        WHEN ab.ETAT = 1 THEN 'CR&Eacute;&Eacute;'
        WHEN ab.ETAT = 11 THEN 'VIS&Eacute;&Eacute;'
        WHEN ab.ETAT = 0 THEN 'ANNUL&Eacute;&Eacute;'
        END
        AS ETATLIB,
          UPPER(
        NVL(ab.DESIGNATION, '') || ' ' ||
        NVL(ab.REFERENCE, '') || ' ' ||
        NVL(ab.REMARQUE, '') || ' ' ||
        NVL(F.NOM, '') || ' ' ||
        NVL(mp.VAL, '') || ' ' ||
        NVL(m.VAL, '') || ' ' ||
        NVL(d.val, '') || ' ' ||
        NVL(ab.IDORIGINE, '') || ' ' ||
        TO_CHAR(ab.DATY, 'DD/MM/YYYY') || ' ' ||
        TO_CHAR(ab.dateLimite, 'DD/MM/YYYY') || ' ' ||
        NVL(
            CASE
                WHEN ab.ETAT = 1 THEN 'CREE'
                WHEN ab.ETAT = 11 THEN 'VISEE'
                WHEN ab.ETAT = 0 THEN 'ANNULEE'
            END
        , '')
    ) AS MOTSCLESSS,
    ab.service

from  AS_BONDECOMMANDE AB
          left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
          left join FOURNISSEUR F on AB.FOURNISSEUR = F.id
          LEFT JOIN AS_BONDECOMMANDEFILLE_CPL abf ON abf.IDBC = ab.ID
          LEFT JOIN DEVISE d ON d.id = ab.IDDEVISE
          LEFT JOIN MAGASINPOINT m ON m.id =  AB.IDMAGASIN  
 
 
 ;
 


-- SAVONNERIEFINAL0519.DMDACHATLIB source

CREATE OR REPLACE  VIEW "DMDACHATLIB" ("ID", "DATY", "FOURNISSEUR", "FOURNISSEURLIB", "REMARQUE", "DATELIMITE", "IDMAGASINLIB", "IDCATEGORIELIB", "ETAT", "ETATLIB", "IDOBJET","SERVICE") AS 
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
    da.service
FROM DMDACHAT da
    LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur
    LEFT JOIN MAGASIN2 m ON da.idMagasin = m.ID
    LEFT JOIN categorieIngredient ci ON da.idCategorie = ci.id;