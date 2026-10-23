-- Tonny

alter table PROFORMAFOURNISSEUR add (idOrigine varchar(255));
alter table AS_BONDECOMMANDE add (idOrigine varchar(255));


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
    abf.montantTVA,
    abf.montantHT,
    CAST(nvl((abf.montantHT + abf.montantTVA),0) AS NUMBER(30,2)) AS montantTTC ,
    CAST(nvl((abf.montantHT + abf.montantTVA) * abf.TAUXDECHANGE,0) AS NUMBER(30,2)) AS montantTTCAriary,
    d.val AS idDeviselib,
    d.id AS IDDEVISE,
    AB.idOrigine,
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


/

CREATE OR REPLACE VIEW proformafournisseur_non_genere AS
SELECT pro.*
FROM proformafournisseur pro
         LEFT JOIN as_bondecommande bc
                   ON bc.idOrigine = pro.id
WHERE pro.etat = 11
  AND bc.id IS NULL;


