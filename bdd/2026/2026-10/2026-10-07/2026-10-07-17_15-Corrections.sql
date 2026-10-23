create or replace view FOURNISSEURCPL as
SELECT f."ID",
       f."NOM",
       f."NIF",
       f."STAT",
       f."ADRESSE",
       f."CONTACT",
       f."CODEPOSTAL",
       f."COMPTE",
       f."IDTYPEFOURNISSEUR",
       f."COMPTEAUXILIAIRE",
       f."ESTACTIF",
       1 as nb
FROM FOURNISSEUR f;


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
    ab.REMISE,
    mp.VAL AS MODEPAIEMENTLIB,
    F.NOM AS FOURNISSEURLIB,
    CAST(abf.montantTVA*(1-(ab.REMISE/100)) as number(30,2)) as montantTVA,
    cast((abf.montantHT - abf.remiseMontant) * (1 - ab.REMISE/100) as number(30,2)) as montantHT,
    CAST(nvl(((abf.montantHT - abf.remiseMontant) + abf.montantTVA) * (1 - ab.REMISE/100), 0) AS NUMBER(30,2)) AS montantTTC,
    CAST(nvl((abf.montantHT + abf.montantTVA- abf.remiseMontant) * abf.TAUXDECHANGE*(1-(ab.REMISE/100)),0) AS NUMBER(30,2)) AS montantTTCAriary,
    d.val AS idDeviselib,
    d.id AS IDDEVISE,
    AB.idOrigine,
    AB.IDMAGASIN,
    m.VAL AS idMagasinlib,
    CASE
        WHEN ab.ETAT = 0 THEN 'ANNUL&Eacute;'
        WHEN ab.ETAT = 1 THEN 'CR&Eacute;&Eacute;'
        WHEN ab.ETAT = 4 THEN 'VIS&Eacute; PAR CI'
        WHEN ab.ETAT = 9 THEN 'VIS&Eacute; PAR CG'
        WHEN ab.ETAT = 11 THEN 'VIS&Eacute; PAR PDG'
        END AS ETATLIB,
    ab.service,ab.REMISEMONTANT,s.LIBELLE as servicelib,
    ab.echeance,
    ab.dateecheance,
    1 as Nb
from  AS_BONDECOMMANDE AB
          left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
          left join FOURNISSEUR F on AB.FOURNISSEUR = F.id
          LEFT JOIN AS_BONDECOMMANDEFILLE_CPL_GRP abf ON abf.IDBC = ab.ID
          LEFT JOIN DEVISE d ON d.id = ab.IDDEVISE
          LEFT JOIN MAGASINPOINT m ON m.id =  AB.IDMAGASIN
          LEFT JOIN SERVICE s ON s.COMPTE = AB.SERVICE;
