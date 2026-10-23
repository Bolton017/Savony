create or replace view AS_BONDECOMMANDE_CPL as
select bcf.ID,bcf.PRODUIT,bcf.IDBC,bcf.QUANTITE,bcf.QUANTITE*bcf.PU AS montant,bcf.PU,bcf.TVA,bcf.UNITE,bcf.REMISE,
       ab.DATY,
       ab.ETAT,
       ab.REMARQUE,
       ab.DESIGNATION,
       ab.MODEPAIEMENT,
       ab.FOURNISSEUR,
       ab.REFERENCE,
       p.LIBELLE  as produitlib,
       u.VAL  as unitelib,
       mp.VAL as MODEPAIEMENTLIB,
       F.nom  AS FOURNISSEURLIB,
       CAST(bcf.quantite * bcf.pu * (bcf.remise/100) AS NUMBER(30,2)) AS remiseMontant,
       CAST(bcf.quantite * bcf.pu - (bcf.quantite * bcf.pu * (bcf.remise/100)) AS NUMBER(30,2)) AS montantht,
       CAST((bcf.quantite * bcf.pu - (bcf.quantite * bcf.pu * (bcf.remise/100))) * (bcf.tva/100) AS NUMBER(30,2)) AS montanttva,
       CAST((bcf.quantite * bcf.pu - (bcf.quantite * bcf.pu * (bcf.remise/100)))
            + (bcf.quantite * bcf.pu - (bcf.quantite * bcf.pu * (bcf.remise/100))) * (bcf.tva/100)
           AS NUMBER(30,2)) AS montantttc,
       bcf.iddevise,
       CAST((
           (bcf.quantite * bcf.pu - (bcf.quantite * bcf.pu * (bcf.remise/100)))
               + (bcf.quantite * bcf.pu - (bcf.quantite * bcf.pu * (bcf.remise/100))) * (bcf.tva/100)
           ) * bcf.TAUXDECHANGE
       AS NUMBER(30,2)) AS montantttcar,
       bcf.TAUXDECHANGE
from AS_BONDECOMMANDE_FILLE bcf
         left outer join AS_BONDECOMMANDE AB on AB.ID = bcf.IDBC
         left join AS_INGREDIENTS P on bcf.PRODUIT = P.ID
         left join AS_UNITE u on bcf.UNITE = u.id
         left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
         left join fournisseur F on AB.fournisseur = F.id;


create OR REPLACE view AS_BONDECOMMANDE_MERECPL2 as
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
    abf.REMISEMONTANT,
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
          LEFT JOIN AS_BONDECOMMANDE_CPL abf ON abf.IDBC = ab.ID
          LEFT JOIN DEVISE d ON d.id = ab.IDDEVISE
          LEFT JOIN MAGASINPOINT m ON m.id =  AB.IDMAGASIN
          LEFT JOIN SERVICE s ON s.COMPTE = AB.SERVICE;
