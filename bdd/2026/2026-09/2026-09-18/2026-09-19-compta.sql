
-- SAVONNERIE1809.V_BALANCE_DETAILS source

CREATE OR REPLACE  VIEW "V_BALANCE_DETAILS" ("ANNEE", "MOIS", "COMPTE", "LIBELLECOMPTE", "DEBIT", "CREDIT", "COMPTE3", "COMPTE2", "CUMULDEBIT", "CUMULCREDIT") AS 
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
        AND cse.etat >= 11
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
    TO_NUMBER(SUBSTR(compte, 1, 3)) AS compte3,
    TO_NUMBER(SUBSTR(compte, 1, 2)) AS compte2,
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


-- SAVONNERIE1809.V_BALANCE_DETAILS_ANALYTIQUE source

CREATE OR REPLACE  VIEW "V_BALANCE_DETAILS_ANALYTIQUE" ("ANNEE", "MOIS", "COMPTE", "LIBELLECOMPTE", "DEBIT", "CREDIT", "COMPTE3", "COMPTE2", "CUMULDEBIT", "CUMULCREDIT") AS 
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
        WHERE
        c.typecompte = '3'
        ),
        ecritures_mensuelles AS (
    -- For monthly values: EXCLUDE journal = 'COMP000015'
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
        AND ce.journal != 'COMP000015'
        GROUP BY
        cse.compte, TRUNC(cse.daty, 'MM')
        ),
        ecritures_mensuelles_cumuls AS (
    -- For cumulative values: INCLUDE everything
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
        AND cse.etat >= 11
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
    TO_NUMBER(SUBSTR(compte, 1, 3)) AS compte3,
    TO_NUMBER(SUBSTR(compte, 1, 2)) AS compte2,
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


 -- SAVONNERIE1809.V_BALANCE_DETAILS_AUX source

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
        AND cse.etat >= 11
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
    ROUND(soldeDebit, 2) AS debit,
    ROUND(soldeCredit, 2) AS credit,
    TO_NUMBER(SUBSTR(compte, 1, 3)) AS compte3,
    TO_NUMBER(SUBSTR(compte, 1, 2)) AS compte2,
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


CREATE OR REPLACE VIEW COMPTA_MOUVEMENT_DETAILAUX AS

SELECT

    cse.id,

    (

        SELECT MIN(csec.compte) KEEP (DENSE_RANK FIRST ORDER BY GREATEST(csec.debit, csec.credit) DESC)

        FROM compta_sous_ecriture csec

        WHERE csec.idmere = cse.idmere

          AND csec.id <> cse.id

          AND (

            (cse.debit > 0 AND csec.credit > 0) OR

            (cse.credit > 0 AND csec.debit > 0)

            )

    ) AS contrep,

    t.nom AS compte_auxlib,

    t.compteauxiliaire AS compte,

    cse.debit,

    cse.credit,

    cse.libellepiece,

    cse.remarque,

    cse.idmere,

    cse.analytique AS REFERENCE_ENGAGEMENT,

    cse.compte_aux,

    lettre.lettre AS lettrage,

    cj.val AS journal,

    EXTRACT(YEAR FROM cse.daty) AS exercice,

    cem.etat,

    cse.daty,

    cse.folio,

    CAST(0 AS NUMBER(20, 2)) AS coursdevise,

    CAST(0 AS NUMBER(20, 2)) AS montantdevise

FROM

    COMPTA_SOUS_ECRITURE cse

        LEFT JOIN COMPTA_ECRITURE cem ON

        cem.id = cse.idmere

        LEFT JOIN TIERS t ON

        cse.COMPTE_AUX = t.id

        LEFT JOIN COMPTA_JOURNAL_VIEW cj ON

        cj.id = cse.journal

        LEFT JOIN compta_compte cc ON

        cse.compte = cc.compte

        LEFT JOIN compta_type_compte ctc ON

        cc.typecompte = ctc.id

        LEFT JOIN COMPTA_LETTRAGE lettre ON

        lettre.id = cse.lettrage

WHERE

    1<2

  AND cj.id <> 'COMP000015'

  AND ((cse.DEBIT>0

    AND cse.credit = 0)

    OR (cse.DEBIT = 0

        AND cse.credit>0));









CREATE OR REPLACE  VIEW COMPTA_MOUVEMENT_DETAILS_AUX_2  AS

SELECT

    ID,

    CONTREP,

    COMPTE,

    DEBIT,

    CREDIT,

    LIBELLEPIECE,

    REMARQUE,

    idmere AS IDMERE,

    REFERENCE_ENGAGEMENT,

    COMPTE_AUX,

    LETTRAGE,

    JOURNAL,

    EXERCICE,

    ETAT,

    DATY,

    FOLIO,

    compte_auxlib,

    CAST(COURSDEVISE AS NUMBER(20,

        2)) AS COURSDEVISE,

    CAST(MONTANTDEVISE AS NUMBER(20,

        2)) AS MONTANTDEVISE,

    TO_NUMBER(REGEXP_SUBSTR(TRIM(compte), '^[0-9]+')) AS compteInt

FROM

    COMPTA_MOUVEMENT_DETAILAUX

where REGEXP_LIKE(TRIM(compte), '^[0-9]+');


CREATE OR REPLACE VIEW  COMPTA_MOUVEMENT_AUX_2_C AS
SELECT
    ID,
    CONTREP,
    COMPTE,
    DEBIT,
    CREDIT,
    LIBELLEPIECE,
    REMARQUE,
    IDMERE,
    REFERENCE_ENGAGEMENT,
    COMPTE_AUX,
    LETTRAGE,
    JOURNAL,
    EXERCICE,
    ETAT,
    DATY,
    FOLIO,
    COMPTE_AUXLIB,
    COURSDEVISE,
    MONTANTDEVISE,
    COMPTEINT
FROM COMPTA_MOUVEMENT_DETAILS_AUX_2
WHERE etat = 1;

-- ============ 4) COMPTA_MOUVEMENT_AUX_2_V (dépend de #2) ============
CREATE OR REPLACE VIEW  COMPTA_MOUVEMENT_AUX_2_V AS
SELECT
    ID,
    CONTREP,
    COMPTE,
    DEBIT,
    CREDIT,
    LIBELLEPIECE,
    REMARQUE,
    IDMERE,
    REFERENCE_ENGAGEMENT,
    COMPTE_AUX,
    LETTRAGE,
    JOURNAL,
    EXERCICE,
    ETAT,
    DATY,
    FOLIO,
    COMPTE_AUXLIB,
    COURSDEVISE,
    MONTANTDEVISE,
    COMPTEINT
FROM COMPTA_MOUVEMENT_DETAILS_AUX_2
WHERE etat = 11;

-- ============ 5) COMPTA_MOUVEMENT_DETAILS_ANAL2 (tables de base) ============
CREATE OR REPLACE VIEW COMPTA_MOUVEMENT_DETAILS_ANAL2 ("ID", "CONTREP", "COMPTE", "DEBIT", "CREDIT", "LIBELLEPIECE", "REMARQUE", "IDMERE", "REFERENCE_ENGAGEMENT", "COMPTE_AUX", "LETTRAGE", "JOURNAL", "EXERCICE", "ETAT", "DATY", "FOLIO") AS

SELECT

    cse.id,

    (

        SELECT

            csec.analytique

        FROM

            compta_sous_ecriture csec,

            COMPTA_JOURNAL_VIEW cjv,

            compta_compte cco,

            compta_type_compte ctcp

        WHERE

            csec.idmere = cse.idmere

          AND csec.credit>0

          AND cjv.id = csec.journal

          AND csec.analytique = cco.compte

          AND cco.typecompte = ctcp.id

          AND cjv.val <> 'COMP000015'

          AND rownum = 1) AS contrep,

    cse.analytique,

    cse.debit,

    cse.credit,

    cse.libellepiece,

    cse.remarque,

    cse.idmere,

    cse.reference_engagement,

    cse.compte_aux,

    lettre.lettre AS lettrage,

    cj.val AS journal,

    EXTRACT(YEAR FROM cse.daty),

    ce.etat,

    cse.daty,

    cse.folio

FROM

    COMPTA_SOUS_ECRITURE cse

        JOIN compta_ecriture ce ON

        ce.id = cse.idmere

        JOIN COMPTA_JOURNAL_VIEW cj ON

        cj.id = cse.journal

        JOIN compta_compte cc ON

        cse.analytique = cc.compte

        JOIN compta_type_compte ctc ON

        cc.typecompte = ctc.id

        LEFT JOIN COMPTA_LETTRAGE lettre ON

        lettre.id = cse.lettrage

WHERE 1<2

  AND cj.id <> 'COMP000015'

  AND cse.DEBIT>0

UNION

SELECT

    cse.id,

    (

        SELECT

            csec.analytique

        FROM

            compta_sous_ecriture csec,

            COMPTA_JOURNAL_VIEW cjv,

            compta_compte cco,

            compta_type_compte ctcp

        WHERE

            csec.idmere = cse.idmere

          AND csec.debit>0

          AND cjv.id = csec.journal

          AND csec.analytique = cco.compte

          AND cco.typecompte = ctcp.id

          AND cjv.id <> 'COMP000015'

          AND rownum = 1) AS contrep,

    cse.analytique,

    cse.debit,

    cse.credit,

    cse.libellepiece,

    cse.remarque,

    cse.idmere,

    cse.reference_engagement,

    cse.compte_aux,

    lettre.lettre AS lettrage,

    cj.val AS journal,

    EXTRACT(YEAR FROM cse.daty),

    ce.etat,

    cse.daty,

    cse.folio

FROM

    COMPTA_SOUS_ECRITURE cse

        JOIN compta_ecriture ce ON

        ce.id = cse.idmere

        JOIN COMPTA_JOURNAL_VIEW cj ON

        cj.id = cse.journal

        JOIN compta_compte cc ON

        cse.analytique = cc.compte

        JOIN compta_type_compte ctc ON

        cc.typecompte = ctc.id

        LEFT JOIN COMPTA_LETTRAGE lettre ON

        lettre.id = cse.lettrage

WHERE

    1<2

  AND cj.id <> 'COMP000015'

  AND cse.CREDIT>0;



CREATE OR REPLACE VIEW COMPTA_MOUVEMENT_DETAILGEN
 ("ID","CONTREP","COMPTE","DEBIT","CREDIT","LIBELLEPIECE","REMARQUE","MERE","REFERENCE_ENGAGEMENT","COMPTE_AUX","LETTRAGE","JOURNAL","EXERCICE","ETAT","DATY","FOLIO","COURSDEVISE","MONTANTDEVISE") AS
SELECT
    cse.id,
    NULL AS contrep,
    cse.compte,
    cse.debit,
    cse.credit,
    cse.libellepiece,
    cse.remarque,
    cse.idmere,
    cse.analytique AS REFERENCE_ENGAGEMENT,
    cse.compte_aux,
    lettre.lettre AS lettrage,
    cj.val AS journal,
    EXTRACT(YEAR FROM cse.daty) AS exercice,
    cem.etat,
    cse.daty,
    cse.folio,
    CAST(0 AS NUMBER(20, 2)) AS coursdevise,
    CAST(0 AS NUMBER(20, 2)) AS montantdevise
FROM
    COMPTA_SOUS_ECRITURE cse
        LEFT JOIN COMPTA_ECRITURE cem ON
        cem.id = cse.idmere
        LEFT JOIN COMPTA_JOURNAL_VIEW cj ON
        cj.id = cse.journal
        LEFT JOIN compta_compte cc ON
        cse.compte = cc.compte
        LEFT JOIN compta_type_compte ctc ON
        cc.typecompte = ctc.id
        LEFT JOIN COMPTA_LETTRAGE lettre ON
        lettre.id = cse.lettrage
WHERE
    1<2
  AND cj.id <> 'COMP000015'
  AND ((cse.DEBIT>0
    AND cse.credit = 0)
    OR (cse.DEBIT = 0
        AND cse.credit>0));


        CREATE OR REPLACE VIEW COMPTA_MOUVEMENT_ANALYTIQUE AS
SELECT
    CAST(sum(debit) AS NUMBER(30, 2)) AS debit,
    CAST(sum(credit) AS NUMBER(30, 2)) AS credit,
    compte, etat, libelle_compte, typecompte, mois, annee, chiffre3, chiffre2
FROM (
    SELECT
        cse.id,
        cse.debit AS debit,
        cse.credit AS credit,
        cse.analytique AS compte,
        cc.LIBELLE AS libelle_compte,
        cse.daty AS daty,
        ce.etat,
        cc.typecompte AS typecompte,
        EXTRACT(MONTH FROM cse.daty) AS mois,
        EXTRACT(YEAR FROM cse.daty) AS annee,
        substr(analytique, 1, 3)|| substr(analytique, 5, 1) AS chiffre3,
        substr(analytique, 1, 2) AS chiffre2
    FROM compta_sous_ecriture cse
        JOIN compta_ecriture ce ON ce.id = cse.idmere
        JOIN compta_compte cc ON cc.compte = cse.analytique
    WHERE cse.journal!='COMP000015'
      AND (cse.debit + cse.credit)>0
      AND ce.etat >= 1
      AND NOT EXISTS (SELECT rs.id FROM reportsolde rs WHERE rs.id = cse.id)
)
GROUP BY compte, etat, libelle_compte, typecompte, mois, annee, chiffre3, chiffre2
ORDER BY chiffre3 ASC;




CREATE OR REPLACE VIEW REPORTSOLDE_ANALYTIQUE AS
SELECT
    COMPTE,
    LIBELLE,
    CAST(DEBIT AS NUMBER(30, 2))  AS DEBIT,
    CAST(CREDIT AS NUMBER(30, 2)) AS CREDIT,
    TYPECOMPTE,
    DATY,
    CHIFFRE3,
    CHIFFRE2
FROM (
    SELECT
        cse.ANALYTIQUE AS COMPTE,
        cc.libelle AS LIBELLE,
        SUM(cse.debit) AS DEBIT,
        SUM(cse.credit) AS CREDIT,
        cc.typecompte AS TYPECOMPTE,
        cse.daty AS DATY,
        substr(cse.analytique, 1, 3) || substr(cse.analytique, 5, 1) AS CHIFFRE3,
        substr(cse.ANALYTIQUE, 1, 2) AS CHIFFRE2
    FROM compta_sous_ecriture cse, compta_compte cc, compta_journal jrn
    WHERE cc.COMPTE = cse.ANALYTIQUE AND cse.etat = 11 AND cse.JOURNAL = jrn.id
    GROUP BY cse.ANALYTIQUE, cc.libelle, cc.typecompte, cse.daty
);

