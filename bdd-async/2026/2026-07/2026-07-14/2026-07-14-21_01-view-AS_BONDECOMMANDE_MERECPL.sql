create or replace view AS_BONDECOMMANDE_MERECPL as
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
    CAST(abf.montantTVA*(1-(ab.REMISE/100)) as number(30,2)) as montantTVA,
    cast(abf.montantHT*(1-(ab.REMISE/100)) as number(30,2)) as montantHT,
    CAST(nvl((abf.montantHT + abf.montantTVA)*(1-(ab.REMISE/100)),0) AS NUMBER(30,2)) AS montantTTC ,
    CAST(nvl((abf.montantHT + abf.montantTVA) * abf.TAUXDECHANGE*(1-(ab.REMISE/100)),0) AS NUMBER(30,2)) AS montantTTCAriary,
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
    ab.service,ab.REMISEMONTANT,s.LIBELLE as servicelib

from  AS_BONDECOMMANDE AB
          left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
          left join FOURNISSEUR F on AB.FOURNISSEUR = F.id
          LEFT JOIN AS_BONDECOMMANDEFILLE_CPL abf ON abf.IDBC = ab.ID
          LEFT JOIN DEVISE d ON d.id = ab.IDDEVISE
          LEFT JOIN MAGASINPOINT m ON m.id =  AB.IDMAGASIN
            LEFT JOIN SERVICE s ON s.COMPTE = AB.SERVICE

;

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
       CAST(bcf.quantite * bcf.pu * ((bcf.remise/100)+(ab.REMISE/100)) AS NUMBER(30,2)) AS remiseMontant,
       CAST(bcf.quantite * bcf.pu*(1-bcf.remise/100) AS NUMBER(30,2)) AS montantht,
       CAST((bcf.quantite * bcf.pu - (bcf.quantite * bcf.pu * (bcf.remise/100))) * (bcf.tva/100)*(1-(ab.REMISE/100)) AS NUMBER(30,2)) AS montanttva,
       CAST((bcf.quantite * bcf.pu - (bcf.quantite * bcf.pu * (bcf.remise/100)))*(1-(ab.REMISE/100))
            + (bcf.quantite * bcf.pu - (bcf.quantite * bcf.pu * (bcf.remise/100))) * (bcf.tva/100)*(1-(ab.REMISE/100))
           AS NUMBER(30,2)) AS montantttc,
       bcf.iddevise,
       CAST((
           (bcf.quantite * bcf.pu - (bcf.quantite * bcf.pu * (bcf.remise/100)))
               + (bcf.quantite * bcf.pu - (bcf.quantite * bcf.pu * (bcf.remise/100))) * (bcf.tva/100)
           ) * bcf.TAUXDECHANGE*(1-(ab.REMISE/100))
       AS NUMBER(30,2)) AS montantttcar,
       bcf.TAUXDECHANGE
from AS_BONDECOMMANDE_FILLE bcf
         left outer join AS_BONDECOMMANDE AB on AB.ID = bcf.IDBC
         left join AS_INGREDIENTS P on bcf.PRODUIT = P.ID
         left join AS_UNITE u on bcf.UNITE = u.id
         left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
         left join fournisseur F on AB.fournisseur = F.id
/