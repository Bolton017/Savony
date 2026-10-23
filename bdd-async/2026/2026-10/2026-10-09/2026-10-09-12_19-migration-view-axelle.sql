CREATE VIEW V_REPARTITION_EFF_CONTRAT AS 
  SELECT
    tc.id                          AS id_type_contrat,
    tc.val                         AS type_contrat,
    COUNT(pip.id)                  AS nb_employes,
    COUNT(CASE WHEN logp.sexe = 1 THEN 1 END) AS nb_hommes,
    COUNT(CASE WHEN logp.sexe != 1 THEN 1 END) AS nb_femmes,
    ROUND(
            COUNT(pip.id) * 100 /
            SUM(COUNT(pip.id)) OVER (), 2
    )                              AS pct_effectif
FROM type_contrat tc
         LEFT JOIN paie_info_personnel pip ON pip.typeContrat = tc.id
         LEFT JOIN log_personnel logp      ON pip.id = logp.id
GROUP BY
    tc.id,
    tc.val
ORDER BY
    nb_employes DESC;


CREATE VIEW V_EFFECTIFS_CDI_HF_CATEGORIE AS 
  SELECT
    cp.id                                          AS id_categorie,
    cp.val                                         AS categorie,
    COUNT(pip.id)                                  AS nb_total,
    COUNT(CASE WHEN logp.sexe = 1 THEN 1 END)      AS nb_hommes,
    COUNT(CASE WHEN logp.sexe != 1 THEN 1 END)     AS nb_femmes,
    ROUND(
            COUNT(CASE WHEN logp.sexe = 1 THEN 1 END) * 100
                / NULLIF(COUNT(pip.id), 0), 2
    )                                              AS pct_hommes,
    ROUND(
            COUNT(CASE WHEN logp.sexe != 1 THEN 1 END) * 100
                / NULLIF(COUNT(pip.id), 0), 2
    )                                              AS pct_femmes
FROM categorie_paie cp
         LEFT JOIN paie_info_personnel pip  ON pip.idcategorie_paie = cp.id
         LEFT JOIN log_personnel logp       ON pip.id = logp.id
         LEFT JOIN type_contrat tc          ON pip.typeContrat = tc.id
WHERE tc.val = 'CDI'
   OR pip.id IS NULL
GROUP BY
    cp.id,
    cp.val
ORDER BY
    nb_total DESC;

CREATE VIEW V_DASH_PYRAMIDE_AGE_CDI (TRANCHE_AGE, EFFECTIF, NB_HOMMES, NB_FEMMES) AS 
  WITH ages AS (
    SELECT
        FLOOR(MONTHS_BETWEEN(SYSDATE, logp.date_naissance)/12) AS age_annees,
        CASE WHEN logp.sexe = 1 THEN 'H' ELSE 'F' END AS genre
    FROM paie_info_personnel pip
    JOIN log_personnel logp ON pip.id = logp.id
    JOIN type_contrat tc ON pip.typeContrat = tc.id
    WHERE tc.val = 'CDI'
)
SELECT
    CASE
        WHEN age_annees BETWEEN 18 AND 24 THEN '18 à 24 ans'
        WHEN age_annees BETWEEN 25 AND 29 THEN '25 à 29 ans'
        WHEN age_annees BETWEEN 30 AND 34 THEN '30 à 34 ans'
        WHEN age_annees BETWEEN 35 AND 39 THEN '35 à 39 ans'
        WHEN age_annees BETWEEN 40 AND 44 THEN '40 à 44 ans'
        WHEN age_annees BETWEEN 45 AND 49 THEN '45 à 49 ans'
        WHEN age_annees BETWEEN 50 AND 54 THEN '50 à 54 ans'
        WHEN age_annees BETWEEN 55 AND 59 THEN '55 à 59 ans'
        WHEN age_annees BETWEEN 60 AND 64 THEN '60 à 64 ans'
        ELSE 'Total Result'
        END AS tranche_age,
    COUNT(*) AS effectif,
    SUM(CASE WHEN genre = 'H' THEN 1 ELSE 0 END) AS nb_hommes,
    SUM(CASE WHEN genre = 'F' THEN 1 ELSE 0 END) AS nb_femmes
FROM ages
GROUP BY
    CASE
        WHEN age_annees BETWEEN 18 AND 24 THEN '18 à 24 ans'
        WHEN age_annees BETWEEN 25 AND 29 THEN '25 à 29 ans'
        WHEN age_annees BETWEEN 30 AND 34 THEN '30 à 34 ans'
        WHEN age_annees BETWEEN 35 AND 39 THEN '35 à 39 ans'
        WHEN age_annees BETWEEN 40 AND 44 THEN '40 à 44 ans'
        WHEN age_annees BETWEEN 45 AND 49 THEN '45 à 49 ans'
        WHEN age_annees BETWEEN 50 AND 54 THEN '50 à 54 ans'
        WHEN age_annees BETWEEN 55 AND 59 THEN '55 à 59 ans'
        WHEN age_annees BETWEEN 60 AND 64 THEN '60 à 64 ans'
        ELSE 'Total Result'
        END
ORDER BY tranche_age;

CREATE VIEW V_DASH_PYRAMIDE_AGE_JRN (TRANCHE_AGE, EFFECTIF, NB_HOMMES, NB_FEMMES) AS 
  WITH ages AS (
    SELECT
        FLOOR(MONTHS_BETWEEN(SYSDATE, logp.date_naissance)/12) AS age_annees,
        CASE WHEN logp.sexe = 1 THEN 'H' ELSE 'F' END AS genre
    FROM paie_info_personnel pip
    JOIN log_personnel logp ON pip.id = logp.id
    JOIN type_contrat tc ON pip.typeContrat = tc.id
    WHERE tc.val = 'JOURNALIER'
)
SELECT
    CASE
        WHEN age_annees BETWEEN 18 AND 24 THEN '18 à 24 ans'
        WHEN age_annees BETWEEN 25 AND 29 THEN '25 à 29 ans'
        WHEN age_annees BETWEEN 30 AND 34 THEN '30 à 34 ans'
        WHEN age_annees BETWEEN 35 AND 39 THEN '35 à 39 ans'
        WHEN age_annees BETWEEN 40 AND 44 THEN '40 à 44 ans'
        WHEN age_annees BETWEEN 45 AND 49 THEN '45 à 49 ans'
        WHEN age_annees BETWEEN 50 AND 54 THEN '50 à 54 ans'
        WHEN age_annees BETWEEN 55 AND 59 THEN '55 à 59 ans'
        WHEN age_annees BETWEEN 60 AND 64 THEN '60 à 64 ans'
        ELSE 'Total Result'
        END AS tranche_age,
    COUNT(*) AS effectif,
    SUM(CASE WHEN genre = 'H' THEN 1 ELSE 0 END) AS nb_hommes,
    SUM(CASE WHEN genre = 'F' THEN 1 ELSE 0 END) AS nb_femmes
FROM ages
GROUP BY
    CASE
        WHEN age_annees BETWEEN 18 AND 24 THEN '18 à 24 ans'
        WHEN age_annees BETWEEN 25 AND 29 THEN '25 à 29 ans'
        WHEN age_annees BETWEEN 30 AND 34 THEN '30 à 34 ans'
        WHEN age_annees BETWEEN 35 AND 39 THEN '35 à 39 ans'
        WHEN age_annees BETWEEN 40 AND 44 THEN '40 à 44 ans'
        WHEN age_annees BETWEEN 45 AND 49 THEN '45 à 49 ans'
        WHEN age_annees BETWEEN 50 AND 54 THEN '50 à 54 ans'
        WHEN age_annees BETWEEN 55 AND 59 THEN '55 à 59 ans'
        WHEN age_annees BETWEEN 60 AND 64 THEN '60 à 64 ans'
        ELSE 'Total Result'
        END
ORDER BY tranche_age;

CREATE VIEW V_DASH_PYRAMIDE_ANCIENNETE_CDI (TRANCHE_ANCIENNETE, EFFECTIF, NB_HOMMES, NB_FEMMES) AS 
  WITH anciennetes AS (
    SELECT
        FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche)/12) AS anc_annees,
        CASE WHEN logp.sexe = 1 THEN 'H' ELSE 'F' END AS genre
    FROM paie_info_personnel pip
    JOIN log_personnel logp ON pip.id = logp.id
    JOIN type_contrat tc ON pip.typeContrat = tc.id
    WHERE tc.val = 'CDI'
)
SELECT
    CASE
        WHEN anc_annees BETWEEN 0 AND 3 THEN '0 à 3 ans'
        WHEN anc_annees BETWEEN 4 AND 6 THEN '4 à 6 ans'
        WHEN anc_annees BETWEEN 7 AND 10 THEN '7 à 10 ans'
        WHEN anc_annees BETWEEN 11 AND 14 THEN '11 à 14 ans'
        WHEN anc_annees BETWEEN 15 AND 19 THEN '15 à 19 ans'
        WHEN anc_annees BETWEEN 20 AND 24 THEN '20 à 24 ans'
        WHEN anc_annees BETWEEN 25 AND 29 THEN '25 à 29 ans'
        WHEN anc_annees BETWEEN 30 AND 34 THEN '30 à 34 ans'
        ELSE 'Autre'
        END AS tranche_anciennete,
    COUNT(*) AS effectif,
    SUM(CASE WHEN genre = 'H' THEN 1 ELSE 0 END) AS nb_hommes,
    SUM(CASE WHEN genre = 'F' THEN 1 ELSE 0 END) AS nb_femmes
FROM anciennetes
GROUP BY
    CASE
        WHEN anc_annees BETWEEN 0 AND 3 THEN '0 à 3 ans'
        WHEN anc_annees BETWEEN 4 AND 6 THEN '4 à 6 ans'
        WHEN anc_annees BETWEEN 7 AND 10 THEN '7 à 10 ans'
        WHEN anc_annees BETWEEN 11 AND 14 THEN '11 à 14 ans'
        WHEN anc_annees BETWEEN 15 AND 19 THEN '15 à 19 ans'
        WHEN anc_annees BETWEEN 20 AND 24 THEN '20 à 24 ans'
        WHEN anc_annees BETWEEN 25 AND 29 THEN '25 à 29 ans'
        WHEN anc_annees BETWEEN 30 AND 34 THEN '30 à 34 ans'
        ELSE 'Autre'
        END
ORDER BY tranche_anciennete;

CREATE VIEW V_DASH_SALAIRE_CATEGORIE_CDI (CATEGORIE, SALAIRE_MOYEN_HOMME, SALAIRE_MOYEN_FEMME, SALAIRE_MOYEN_TOTAL) AS 
  SELECT
    cp.val AS categorie,
    ROUND(AVG(CASE WHEN logp.sexe = 1 THEN pip.SALAIREBASE END), 0) AS salaire_moyen_homme,
    ROUND(AVG(CASE WHEN logp.sexe != 1 THEN pip.SALAIREBASE END), 0) AS salaire_moyen_femme,
    ROUND(AVG(pip.SALAIREBASE), 0) AS salaire_moyen_total
FROM PAIE_INFO_PERSONNEL pip
         JOIN LOG_PERSONNEL logp ON pip.id = logp.id
         JOIN CATEGORIE_PAIE cp ON pip.idcategorie_paie = cp.id
         JOIN TYPE_CONTRAT tc ON pip.typeContrat = tc.id
WHERE tc.id = 'TYC00001'
  AND cp.id IN ('CP00001','CP00003', 'CP00002')
GROUP BY cp.val
ORDER BY categorie;

CREATE VIEW V_DASH_SALAIRE_ANC_CDI_REF (CATEGORIE, TRANCHE_ANCIENNETE, ORDRE, SALAIRE_MOYEN_HOMME, SALAIRE_MOYEN_FEMME, SALAIRE_MOYEN_TOTAL) AS 
  SELECT
    categorie,
    tranche_anciennete,
    ordre,
    ROUND(AVG(CASE WHEN sexe = 1 THEN salairebase END), 0) AS salaire_moyen_homme,
    ROUND(AVG(CASE WHEN sexe <> 1 THEN salairebase END), 0) AS salaire_moyen_femme,
    ROUND(AVG(salairebase), 0) AS salaire_moyen_total
FROM (
         SELECT
             cp.val AS categorie,
             logp.sexe,
             pip.salairebase,
             FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) AS anciennete,

             CASE
                 WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) BETWEEN 0 AND 3 THEN '0 à 3 ans'
                 WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) BETWEEN 4 AND 6 THEN '4 à 6 ans'
                 WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) BETWEEN 7 AND 10 THEN '7 à 10 ans'
                 WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) BETWEEN 11 AND 14 THEN '11 à 14 ans'
                 WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) BETWEEN 15 AND 19 THEN '15 à 19 ans'
                 WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) BETWEEN 20 AND 24 THEN '20 à 24 ans'
                 WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) BETWEEN 25 AND 29 THEN '25 à 29 ans'
                 WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) BETWEEN 30 AND 34 THEN '30 à 34 ans'
                 ELSE 'Plus de 35 ans'
                 END AS tranche_anciennete,

             CASE
                 WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) BETWEEN 0 AND 3 THEN 1
                 WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) BETWEEN 4 AND 6 THEN 2
                 WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) BETWEEN 7 AND 10 THEN 3
                 WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) BETWEEN 11 AND 14 THEN 4
                 WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) BETWEEN 15 AND 19 THEN 5
                 WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) BETWEEN 20 AND 24 THEN 6
                 WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) BETWEEN 25 AND 29 THEN 7
                 WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, pip.dateEmbauche) / 12) BETWEEN 30 AND 34 THEN 8
                 ELSE 9
                 END AS ordre

         FROM PAIE_INFO_PERSONNEL pip
                  JOIN LOG_PERSONNEL logp
                       ON pip.id = logp.id
                  JOIN CATEGORIE_PAIE cp
                       ON pip.idcategorie_paie = cp.id
                  JOIN TYPE_CONTRAT tc
                       ON pip.typeContrat = tc.id
         WHERE tc.val = 'CDI'
     )
GROUP BY
    categorie,
    tranche_anciennete,
    ordre;
         
CREATE VIEW V_DASH_SALAIRE_ANC_CDI (CATEGORIE, TRANCHE_ANCIENNETE, ORDRE, SALAIRE_MOYEN_HOMME, SALAIRE_MOYEN_FEMME, SALAIRE_MOYEN_TOTAL) AS 
  SELECT CATEGORIE,TRANCHE_ANCIENNETE,ORDRE,SALAIRE_MOYEN_HOMME,SALAIRE_MOYEN_FEMME,SALAIRE_MOYEN_TOTAL
FROM V_DASH_SALAIRE_ANC_CDI_REF
ORDER BY categorie, ordre;

CREATE VIEW V_DASH_HSUP_MOIS_CDI (MOIS_NUM, MOIS, MONTANT_HSUP_HOMME, MONTANT_HSUP_FEMME, MONTANT_HSUP_TOTAL) AS 
  SELECT
	ppe.moisregularisation AS mois_num,
	TO_CHAR(
            TO_DATE(ppe.moisregularisation, 'MM'),
            'MONTH',
            'NLS_DATE_LANGUAGE=FRENCH'
    ) AS mois,
	ROUND(SUM(CASE WHEN logp.sexe = 1 THEN ppe.gain ELSE 0 END), 0) AS montant_hsup_homme,
	ROUND(SUM(CASE WHEN logp.sexe <> 1 THEN ppe.gain ELSE 0 END), 0) AS montant_hsup_femme,
	ROUND(SUM(ppe.gain), 0) AS montant_hsup_total
FROM
	PAIE_PERSONNEL_ELEMENTPAIE ppe
JOIN paie_rubrique pr
              ON
	ppe.code_rubrique = pr.id
JOIN paie_info_personnel pip
              ON
	ppe.idPersonnel = pip.id
JOIN log_personnel logp
              ON
	pip.id = logp.id
JOIN type_contrat tc
              ON
	pip.typeContrat = tc.id
WHERE
	tc.id = 'TYC00001'
	AND pr.id IN (
                'PR0000220', 'PR0000130I', 'PR0000130',
                'PR0000150I', 'PR0000150',
                'PR0000222', 'PR0000229',
                'PR0000221', 'PR0000223'
    )
GROUP BY
	ppe.moisregularisation
ORDER BY
	mois_num;


 
