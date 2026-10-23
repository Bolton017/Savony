-- script ana recap salaire : IRSA marina + heure sup
CREATE OR REPLACE VIEW "RECAP_SAL_ALL" AS
SELECT
    pe.mois,
    pe.annee,

    ROUND(SUM(CASE
                  WHEN pe.idelementpaie = 'PR000041' THEN NVL(pe.gain, 0)
                  ELSE 0
        END), 2) AS salaire,

    ROUND(SUM(CASE
                  WHEN pe.idelementpaie IN ('PR000021', 'PR000061', 'PR000081', 'PR000001') THEN NVL(pe.gain, 0)
                  ELSE 0
        END), 2) AS indemnite,

    ROUND(SUM(CASE
                  WHEN pe.idelementpaie = 'PR000201' THEN NVL(pe.gain, 0)
                  ELSE 0
        END), 2) AS avantage_en_nature,

    ROUND(SUM(CASE
                  WHEN pe.IDELEMENTPAIE IN ('PR0000229', 'PR0000223', 'PR0000222', 'PR0000221') THEN NVL(pe.gain, 0)
        END), 2) AS heuresup,

    ROUND(SUM(CASE
                  WHEN pe.idelementpaie = 'PRUNI' THEN NVL(pegi.imposable, 0)
                  ELSE 0
        END), 2) AS salaire_brut,

    ROUND(SUM(CASE
                  WHEN pe.idelementpaie = 'PR000141NET' THEN NVL(pe.retenue, 0)
                  ELSE 0
        END), 2) AS irsa,

    ROUND(SUM(CASE
                  WHEN pe.idelementpaie = 'PR000101' THEN NVL(pe.retenue, 0)
                  ELSE 0
        END), 2) AS cnaps_travailleur,

    CAST(ROUND(SUM(CASE
                       WHEN pe.idelementpaie = 'PR000210A' THEN NVL(pe.gain, 0)
                       ELSE 0
        END), 2) AS NUMBER(30, 2))  AS montant_net_payer,

    ROUND(SUM(CASE
                  WHEN pe.idelementpaie = 'PR000101' THEN NVL(pe.retenue, 0)
                  ELSE 0
        END) * 13, 2) AS cnaps_employeur,

    ROUND(SUM(CASE
                  WHEN pe.idelementpaie = 'PR000101' THEN NVL(pe.retenue, 0)
                  ELSE 0
        END) * 14, 2) AS cnaps_a_payer,
    pe.idedition AS id

FROM paie_edition pe
         LEFT JOIN paie_edition_gain_imp pegi
                   ON pe.idpersonnel = pegi.idpersonnel
                       AND pe.mois = pegi.mois
                       AND pe.annee = pegi.annee
                       AND pe.idelementpaie IN (
                                                'PR000041', 'PR000021', 'PR000061', 'PR000081', 'PR000001',
                                                'PR000201', 'PRUNI', 'PR000141', 'PR000101', 'PR000210A'
                           )
GROUP BY pe.annee, pe.mois, pe.IDEDITION ;


CREATE OR REPLACE VIEW "RECAPITULATIF_SALAIRE_ALL" AS
SELECT recap_sal_all.mois,
       recap_sal_all.annee,
       recap_sal_all.salaire AS salaire,
       recap_sal_all.indemnite AS indemnite,
       recap_sal_all.heuresup AS heuresup,
       recap_sal_all.avantage_en_nature AS avantage_en_nature,
       recap_sal_all.salaire_brut AS salaire_brut,
       recap_sal_all.irsa AS irsa,
       recap_sal_all.cnaps_travailleur AS cnaps_travailleur,
       CAST(recap_sal_all.montant_net_payer AS NUMBER(30, 2)) AS montant_net_payer,
       recap_sal_all.cnaps_employeur AS cnaps_employeur,
       recap_sal_all.cnaps_a_payer AS cnaps_a_payer,
       recap_sal_all.id
FROM recap_sal_all;



CREATE OR REPLACE VIEW "RECAPITULATIF_ALL_FINAL" AS
SELECT rs.mois,
       rs.annee,
       rs.salaire,
       rs.indemnite,
       rs.heuresup,
       rs.avantage_en_nature,
       rs.salaire_brut,
       rs.irsa,
       rs.cnaps_travailleur,
       CAST(rs.montant_net_payer AS NUMBER(30, 2)) AS MONTANT_NET_PAYER,
       rs.cnaps_employeur,
       rs.cnaps_a_payer,
       frm.total_frm,
       rs.id
FROM recapitulatif_salaire_all rs
         LEFT JOIN frm_mois_annee frm ON rs.mois = frm.mois AND rs.annee = frm.annee;

