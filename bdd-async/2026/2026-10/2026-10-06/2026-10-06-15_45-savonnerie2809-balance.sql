-- SAVONNERIE2809.V_BALANCE_DETAILS source

CREATE OR REPLACE  VIEW V_BALANCE_DETAILS (ANNEE, MOIS, COMPTE, LIBELLECOMPTE, DEBIT, CREDIT, COMPTE3, COMPTE2, CUMULDEBIT, CUMULCREDIT) AS 
  WITH mois_annees AS (
    SELECT
        ADD_MONTHS(TRUNC(SYSDATE, 'MM'), LEVEL - 25) AS mois
    FROM DUAL
        CONNECT BY LEVEL <= 49
        ),
        base_comptes_periode AS (
        SELECT
        CAST(c.compte AS VARCHAR2(100)) AS compte,
        c.libelle AS libelleCompte,
        m.mois,
        EXTRACT(YEAR FROM m.mois) AS annee,
        EXTRACT(MONTH FROM m.mois) AS mois_num
        FROM
        compta_compte c
        CROSS JOIN mois_annees m
        ),
        ecritures_mensuelles AS (
    -- Excludes journal = 'COMP000015'
        SELECT
        CAST(cse.compte AS VARCHAR2(100)) AS compte,
        TRUNC(cse.daty, 'MM') AS mois,
        SUM(cse.debit) AS soldeDebit,
        SUM(cse.credit) AS soldeCredit
        FROM
        compta_sous_ecriture cse
        JOIN compta_ecriture ce ON ce.id = cse.idmere
        WHERE
        cse.daty IS NOT NULL
        AND ce.etat >= 11
        AND cse.journal != 'COMP000015'
        GROUP BY
        cse.compte, TRUNC(cse.daty, 'MM')
        ),
        ecritures_mensuelles_cumuls AS (
    -- Includes all journals, including 'COMP000015'
        SELECT
        CAST(cse.compte AS VARCHAR2(100)) AS compte,
        TRUNC(cse.daty, 'MM') AS mois,
        SUM(cse.debit) AS cumulDebit,
        SUM(cse.credit) AS cumulCredit
        FROM
        compta_sous_ecriture cse
        JOIN compta_ecriture ce ON ce.id = cse.idmere
        WHERE
        cse.daty IS NOT NULL
        AND ce.etat >= 11
        GROUP BY
        cse.compte, TRUNC(cse.daty, 'MM')
        ),
        fusion_comptes_mois AS (
        SELECT
        b.annee,
        b.mois_num AS mois,
        b.compte,
        b.libelleCompte,
        b.mois AS date_mois,
        NVL(em.soldeDebit, 0) AS soldeDebit,
        NVL(em.soldeCredit, 0) AS soldeCredit,
        NVL(ec.cumulDebit, 0) AS cumulDebit,
        NVL(ec.cumulCredit, 0) AS cumulCredit
        FROM
        base_comptes_periode b
        LEFT JOIN ecritures_mensuelles em ON b.compte = em.compte AND b.mois = em.mois
        LEFT JOIN ecritures_mensuelles_cumuls ec ON b.compte = ec.compte AND b.mois = ec.mois
        )
SELECT
    annee,
    mois,
    compte,
    libelleCompte,
    ROUND(soldeDebit, 2) AS debit,
    ROUND(soldeCredit, 2) AS credit,
    CASE
	    WHEN REGEXP_LIKE(compte, '^[0-9]{3}')
	    THEN TO_NUMBER(SUBSTR(compte, 1, 3))
	    ELSE NULL
	END AS compte3,
	CASE
	    WHEN REGEXP_LIKE(compte, '^[0-9]{2}')
	    THEN TO_NUMBER(SUBSTR(compte, 1, 2))
	    ELSE NULL
	END AS compte2,
    ROUND(
            SUM(cumulDebit) OVER (
            PARTITION BY compte ORDER BY date_mois
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ), 2
    ) AS cumulDebit,
    ROUND(
            SUM(cumulCredit) OVER (
            PARTITION BY compte ORDER BY date_mois
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ), 2
    ) AS cumulCredit
FROM
    fusion_comptes_mois
ORDER BY
    compte, annee, mois

 
 ;

 CREATE OR REPLACE VIEW "COMPTA_MOUVEMENT_ANAL_C" ("ID", "CONTREP", "COMPTE", "DEBIT", "CREDIT", "LIBELLEPIECE", "REMARQUE", "IDMERE", "REFERENCE_ENGAGEMENT", "COMPTE_AUX", "LETTRAGE", "JOURNAL", "EXERCICE", "ETAT", "DATY", "FOLIO") AS
  SELECT
    "ID","CONTREP","COMPTE","DEBIT","CREDIT","LIBELLEPIECE","REMARQUE","IDMERE","REFERENCE_ENGAGEMENT","COMPTE_AUX","LETTRAGE","JOURNAL","EXERCICE","ETAT","DATY","FOLIO"
FROM
    COMPTA_MOUVEMENT_DETAILS_ANAL2 cmda
WHERE cmda.etat = 1;

CREATE OR REPLACE VIEW "COMPTA_MOUVEMENT_ANAL_V" ("ID", "CONTREP", "COMPTE", "DEBIT", "CREDIT", "LIBELLEPIECE", "REMARQUE", "IDMERE", "REFERENCE_ENGAGEMENT", "COMPTE_AUX", "LETTRAGE", "JOURNAL", "EXERCICE", "ETAT", "DATY", "FOLIO") AS
  SELECT
    "ID","CONTREP","COMPTE","DEBIT","CREDIT","LIBELLEPIECE","REMARQUE","IDMERE","REFERENCE_ENGAGEMENT","COMPTE_AUX","LETTRAGE","JOURNAL","EXERCICE","ETAT","DATY","FOLIO"
FROM
    COMPTA_MOUVEMENT_DETAILS_ANAL2 cmda
WHERE cmda.etat = 11;


-- V_BALANCE_DETAILS_AUX : montants types NUMBER(30,2) pour que apj-core les lise en double (sinon getInt => decimales perdues)
CREATE OR REPLACE  VIEW "V_BALANCE_DETAILS_AUX" ("ANNEE", "MOIS", "COMPTE", "LIBELLECOMPTE", "DEBIT", "CREDIT", "COMPTE3", "COMPTE2", "CUMULDEBIT", "CUMULCREDIT") AS 
  WITH mois_annees AS (
    SELECT
        ADD_MONTHS(TRUNC(SYSDATE, 'MM'), LEVEL - 25) AS mois
    FROM DUAL
        CONNECT BY LEVEL <= 49
        ),
        base_comptes_periode AS (
        SELECT
        CAST(c.compte AS VARCHAR2(100)) AS compte,
        c.libelle AS libelleCompte,
        m.mois,
        EXTRACT(YEAR FROM m.mois) AS annee,
        EXTRACT(MONTH FROM m.mois) AS mois_num
        FROM
        compte_aux c
        CROSS JOIN mois_annees m
        ),
        ecritures_mensuelles AS (
    -- Excludes journal = 'COMP000015'
        SELECT
        CAST(cse.COMPTE_AUX AS VARCHAR2(100)) AS compte,
        TRUNC(cse.daty, 'MM') AS mois,
        SUM(cse.debit) AS soldeDebit,
        SUM(cse.credit) AS soldeCredit
        FROM
        compta_sous_ecriture cse
        JOIN compta_ecriture ce ON ce.id = cse.idmere
        WHERE
        cse.daty IS NOT NULL
        AND ce.etat >= 11
        AND cse.journal != 'COMP000015'
        GROUP BY
        cse.COMPTE_AUX, TRUNC(cse.daty, 'MM')
        ),
        ecritures_mensuelles_cumuls AS (
    -- Includes all journals, including 'COMP000015'
        SELECT
        CAST(cse.COMPTE_AUX AS VARCHAR2(100)) AS compte,
        TRUNC(cse.daty, 'MM') AS mois,
        SUM(cse.debit) AS cumulDebit,
        SUM(cse.credit) AS cumulCredit
        FROM
        compta_sous_ecriture cse
        JOIN compta_ecriture ce ON ce.id = cse.idmere
        WHERE
        cse.daty IS NOT NULL
        AND ce.etat >= 11
        GROUP BY
        cse.COMPTE_AUX, TRUNC(cse.daty, 'MM')
        ),
        fusion_comptes_mois AS (
        SELECT
        b.annee,
        b.mois_num AS mois,
        b.compte,
        b.libelleCompte,
        b.mois AS date_mois,
        NVL(em.soldeDebit, 0) AS soldeDebit,
        NVL(em.soldeCredit, 0) AS soldeCredit,
        NVL(ec.cumulDebit, 0) AS cumulDebit,
        NVL(ec.cumulCredit, 0) AS cumulCredit
        FROM
        base_comptes_periode b
        LEFT JOIN ecritures_mensuelles em ON b.compte = em.compte AND b.mois = em.mois
        LEFT JOIN ecritures_mensuelles_cumuls ec ON b.compte = ec.compte AND b.mois = ec.mois
        )
SELECT
    annee,
    mois,
    compte,
    libelleCompte,
    CAST(ROUND(soldeDebit, 2) AS NUMBER(30,2)) AS debit,
    CAST(ROUND(soldeCredit, 2) AS NUMBER(30,2)) AS credit,
    TO_NUMBER(SUBSTR(compte, 1, 3)) AS compte3,
    TO_NUMBER(SUBSTR(compte, 1, 2)) AS compte2,
    CAST(ROUND(
            SUM(cumulDebit) OVER (
            PARTITION BY compte ORDER BY date_mois
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ), 2
    ) AS NUMBER(30,2)) AS cumulDebit,
    CAST(ROUND(
            SUM(cumulCredit) OVER (
            PARTITION BY compte ORDER BY date_mois
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ), 2
    ) AS NUMBER(30,2)) AS cumulCredit
FROM
    fusion_comptes_mois
ORDER BY
    compte, annee, mois;