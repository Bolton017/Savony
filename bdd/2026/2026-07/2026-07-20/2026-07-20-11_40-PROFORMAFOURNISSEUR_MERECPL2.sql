
create or replace view PROFORMAFOURNISSEUR_MERECPL2 as
SELECT
    ab.ID,
    ab.DATY,
    ab.ETAT,
    ab.REMARQUE,
    ab.DESIGNATION,
    ab.MODEPAIEMENT,
    ab.FOURNISSEUR,
    ab.REFERENCE,
    mp.VAL AS MODEPAIEMENTLIB,
    F.NOM AS FOURNISSEURLIB,
    CAST( NVL(abf.MONTANTTVA, 0)
    AS NUMBER(30,2)) AS MONTANTTVA,
    CAST(
        NVL(abf.MONTANTHT, 0) -
        CASE
            WHEN NVL(ab.REMISE, 0) > 0 THEN NVL(abf.MONTANTHT, 0) * (NVL(ab.REMISE, 0) / 100.0)
            WHEN NVL(ab.REMISEMONTANT, 0) > 0 THEN NVL(ab.REMISEMONTANT, 0)
            ELSE 0
        END
    AS NUMBER(30,2)) AS MONTANTHT,
    CAST(
        CASE
            WHEN NVL(abf.MONTANTTTC, 0) = 0 THEN
                NVL(abf.MONTANTTTC, 0) -
                CASE
                    WHEN NVL(ab.REMISE, 0) > 0 THEN NVL(abf.MONTANTHT, 0) * (NVL(ab.REMISE, 0) / 100.0)
                    WHEN NVL(ab.REMISEMONTANT, 0) > 0 THEN NVL(ab.REMISEMONTANT, 0)
                    ELSE 0
                END
            ELSE
                NVL(abf.MONTANTTTC, 0) -
                CASE
                    WHEN NVL(ab.REMISE, 0) > 0 THEN NVL(abf.MONTANTTTC, 0) * (NVL(ab.REMISE, 0) / 100.0)
                    WHEN NVL(ab.REMISEMONTANT, 0) > 0 THEN NVL(ab.REMISEMONTANT, 0)
                    ELSE 0
                END
        END
    AS  NUMBER(30,2)) MONTANTTTC,
    CAST(nvl(abf.MONTANTTTCAR,0) AS NUMBER(30,2)) AS montantTTCAriary,
    d.val AS idDeviselib,
    d.id AS IDDEVISE,
    CASE
        WHEN ab.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN ab.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN ab.ETAT = 11
            THEN 'VIS&Eacute;(E)'
        WHEN ab.ETAT = 3
            THEN 'VIS&Eacute;(E) par Responsable achat'
        WHEN ab.ETAT = 4
            THEN 'VIS&Eacute;(E) par Chef hierarchique'
        END AS etatlib,
    ab.IDORIGINE,
    AB.REMISE,
    AB.REMISEMONTANT
from  proformafournisseur AB
    left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
    left join FOURNISSEUR F on AB.FOURNISSEUR = F.id
    LEFT JOIN proformafournisseurdetailsgrp2 abf ON abf.IDMERE = ab.ID
    LEFT JOIN DEVISE d ON d.id = ab.IDDEVISE;
