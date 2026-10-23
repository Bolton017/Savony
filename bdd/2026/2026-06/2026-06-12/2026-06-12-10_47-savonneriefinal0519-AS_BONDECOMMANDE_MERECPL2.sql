create or replace view AS_BONDECOMMANDE_MERECPL2 as
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
    CAST(nvl(((abf.montantHT + abf.montantTVA)-
              -
                  CASE
                      WHEN NVL(ab.REMISE, 0) > 0 THEN (abf.montantHT + abf.montantTVA) * (NVL(ab.REMISE, 0) / 100)
                      WHEN NVL(ab.REMISEMONTANT, 0) > 0 THEN NVL(ab.REMISEMONTANT, 0)
                      ELSE 0
                      END)
        ,0) AS NUMBER(30,2)) AS montantTTC ,
    CAST(nvl(((abf.montantHT + abf.montantTVA)
        -
              CASE
                  WHEN NVL(ab.REMISE, 0) > 0 THEN (abf.montantHT + abf.montantTVA) * (NVL(ab.REMISE, 0) / 100)
                  WHEN NVL(ab.REMISEMONTANT, 0) > 0 THEN NVL(ab.REMISEMONTANT, 0)
                  ELSE 0
                  END)
                 * abf.TAUXDECHANGE,0) AS NUMBER(30,2)) AS montantTTCAriary,
    d.val AS idDeviselib,
    d.id AS IDDEVISE,
    AB.idOrigine,
    AB.IDMAGASIN,
    m.VAL AS idMagasinlib,
    AB.service,
    S.LIBELLE AS serviceLib,
    CASE
        WHEN ab.ETAT = 1 THEN 'CREEE'
        WHEN ab.ETAT = 11 THEN 'VISEE'
        WHEN ab.ETAT = 0 THEN 'ANNULEE'
        END
        AS ETATLIB
from  AS_BONDECOMMANDE AB
    left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
    left join FOURNISSEUR F on AB.FOURNISSEUR = F.id
    LEFT JOIN AS_BONDECOMMANDEFILLE_CPL abf ON abf.IDBC = ab.ID
    LEFT JOIN DEVISE d ON d.id = ab.IDDEVISE
    LEFT JOIN MAGASINPOINT m ON m.id =  AB.IDMAGASIN
    LEFT JOIN SERVICE s ON s.COMPTE = AB.SERVICE;