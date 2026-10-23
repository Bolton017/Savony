create or replace view PROFORMAFRNSDETAILSCPL_2  as
(
select bcf.ID,bcf.PRODUIT,bcf.IDMERE,bcf.QUANTITE,bcf.QUANTITE*bcf.PU AS montant,bcf.PU,bcf.TVA,bcf.TAUXDECHANGE,bcf.UNITE,bcf.REMISE,
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
       CAST (bcf.quantite * bcf.pu * (bcf.tva/100) AS NUMBER(30,2)) AS montanttva,
       CAST( bcf.quantite * bcf.pu + (bcf.quantite * bcf.pu * (bcf.tva/100)) AS NUMBER(30,2)) AS montantttc,
       CAST (bcf.quantite * bcf.pu + (bcf.quantite * bcf.pu  * (bcf.tva/100)) - bcf.quantite * bcf.pu * (bcf.tva/100) AS NUMBER(30,2)) AS montantht,
       bcf.iddevise,
       bcf.REMISEMONTANT,
       ab.IDORIGINE as idoriginemere
from proformafournisseurdetails bcf
         left outer join proformafournisseur AB on AB.ID = bcf.IDMERE
         left join AS_INGREDIENTS P on bcf.PRODUIT = P.ID
         left join AS_UNITE u on p.UNITE = u.id
         left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
         left join fournisseur F on AB.fournisseur = F.id
);

create or replace view proformafournisseurlibfrns as
(
SELECT ab.ID,
       ab.DATY,
       ab.REMARQUE,
       ab.DESIGNATION,
       ab.MODEPAIEMENT,
       ab.FOURNISSEUR || '---' || f.NOM as FOURNISSEUR,
       ab.REFERENCE,
       ab.IDDEVISE,
       ab.IDMAGASIN,
       ab.ETAT,
       ab.IDORIGINE,
       ab.REMISEMONTANT,
       ab.REMISE,
       ab.ECHEANCE,
       ab.DATEECHEANCE
from proformafournisseur ab
         left join fournisseur f on f.id = ab.FOURNISSEUR);

CREATE OR REPLACE VIEW RAPPROCHEMENT_BF_FOURNISSEUR  AS 
SELECT
    abcc.ID,
    abcc.PRODUIT,
    abcc.NUMBL,
    abcc.QUANTITE,
    abcc.IDDETAILSFACTUREFOURNISSEUR,
    abcc.UNITE,
    abcc.IDBC_FILLE,
    abcc.REMARQUE,
    abcc.IDBC,
    abcc.DATY,
    abcc.ETAT,
    abcc.MAGASIN,
    abcc.PRODUITLIB,
    abcc.UNITELIB,
    abcc.MAGASINLIB,
    abcc.LIBELLEEXTACTE AS LIBELLEEXACTE,
    NVL(m.qteEntree, 0) AS qteEntree,
    CASE WHEN (abcc.QUANTITE - NVL(m.qteEntree, 0)) < 0 THEN 0 ELSE (abcc.QUANTITE - NVL(m.qteEntree, 0)) END AS resteAEntrer,
    CASE WHEN (abcc.QUANTITE - NVL(m.qteEntree, 0)) < 0 THEN 0 ELSE (abcc.QUANTITE - NVL(m.qteEntree, 0)) END AS resteASortir,
    abcc.pu
FROM AS_BONDELIVRAISON_LIBCPL abcc
LEFT JOIN (
    SELECT mp.idobjet, mf.idproduit, CAST(SUM(NVL(mf.entree, 0)) AS NUMBER(15,2)) AS qteEntree
    FROM MVTSTOCKFILLE mf
    JOIN MVTSTOCK mp ON mp.id = mf.idmvtstock
    WHERE mp.etat >= 11
    GROUP BY mp.idobjet, mf.idproduit
) m ON m.idproduit = abcc.produit AND m.idobjet = abcc.numbl;


CREATE OR REPLACE VIEW PROFORMAFOURNISSEUR_MERECPL2 AS 
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
    AB.REMISEMONTANT,
    ab.ECHEANCE,
    ab.DATEECHEANCE AS DATEECHEANCE
from  proformafournisseur AB
    left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
    left join FOURNISSEUR F on AB.FOURNISSEUR = F.id
    LEFT JOIN proformafournisseurdetailsgrp2 abf ON abf.IDMERE = ab.ID
    LEFT JOIN DEVISE d ON d.id = ab.IDDEVISE
;
 
CREATE OR REPLACE VIEW PROFORMAFOURNISSEURDETAILSCPL2 AS
SELECT
    src.ID,
    src.PRODUIT,
    src.IDMERE,
    src.QUANTITE,
    src.PU,
    src.TVA,
    src.TAUXDECHANGE,
    src.UNITE,
    src.REMISE,
    src.REMISEMONTANT,
    src.DATY,
    src.ETAT,
    src.REMARQUE,
    src.DESIGNATION,
    src.MODEPAIEMENT,
    src.FOURNISSEUR,
    src.REFERENCE,
    src.produitlib,
    src.unitelib,
    src.MODEPAIEMENTLIB,
    src.FOURNISSEURLIB,
    src.iddevise,
    src.idoriginemere,

    CAST(src.MONTANT_BRUT AS NUMBER(30, 2)) AS MONTANT_BRUT,

    CAST(src.MONTANT_NET_HT AS NUMBER(30, 2)) AS MONTANT,

    CAST(src.MONTANT_NET_HT AS NUMBER(30, 2)) AS MONTANTHT,

    CAST(
        CASE
            WHEN NVL(src.TVA, 0) = 0 THEN 0
            ELSE src.MONTANT_NET_HT * (NVL(src.TVA, 0) / 100)
        END
        AS NUMBER(30, 2)
    ) AS MONTANTTVA,

    CAST(
        CASE
            WHEN NVL(src.TVA, 0) = 0 THEN src.MONTANT_NET_HT
            ELSE src.MONTANT_NET_HT
                 + (src.MONTANT_NET_HT * (NVL(src.TVA, 0) / 100))
        END
        AS NUMBER(30, 2)
    ) AS MONTANTTTC

FROM
(
    SELECT
        bcf.ID,
        bcf.PRODUIT,
        bcf.IDMERE,
        bcf.QUANTITE,
        bcf.PU,
        bcf.TVA,
        bcf.TAUXDECHANGE,
        NVL(bcf.UNITE, p.UNITE) AS UNITE,
        bcf.REMISE,
        bcf.REMISEMONTANT,
        bcf.iddevise,

        ab.DATY,
        ab.ETAT,
        ab.REMARQUE,
        ab.DESIGNATION,
        ab.MODEPAIEMENT,
        ab.FOURNISSEUR,
        ab.REFERENCE,
        ab.IDORIGINE AS idoriginemere,

        p.LIBELLE AS produitlib,

        NVL(u.VAL, u2.VAL) AS unitelib,

        mp.VAL AS MODEPAIEMENTLIB,

        F.nom AS FOURNISSEURLIB,

        -- Calcul du brut
        NVL(bcf.QUANTITE, 0) * NVL(bcf.PU, 0) AS MONTANT_BRUT,

        -- Calcul du Net HT avec logique de remise priorisée
        (
            NVL(bcf.QUANTITE, 0) * NVL(bcf.PU, 0)
        )
        -
        CASE
            WHEN NVL(bcf.REMISE, 0) > 0 THEN
                (
                    NVL(bcf.QUANTITE, 0) * NVL(bcf.PU, 0)
                ) * (NVL(bcf.REMISE, 0) / 100)

            WHEN NVL(bcf.REMISEMONTANT, 0) > 0 THEN
                NVL(bcf.REMISEMONTANT, 0)

            ELSE 0
        END AS MONTANT_NET_HT

    FROM PROFORMAFOURNISSEURDETAILS bcf

    LEFT OUTER JOIN PROFORMAFOURNISSEUR ab
        ON ab.ID = bcf.IDMERE

    LEFT JOIN AS_INGREDIENTS p
        ON bcf.PRODUIT = p.ID

    LEFT JOIN AS_UNITE u
        ON bcf.UNITE = u.ID

    LEFT JOIN AS_UNITE u2
        ON p.UNITE = u2.ID

    LEFT JOIN MODEPAIEMENT mp
        ON ab.MODEPAIEMENT = mp.ID

    LEFT JOIN FOURNISSEUR F
        ON ab.FOURNISSEUR = F.ID

) src;
