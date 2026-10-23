
CREATE OR REPLACE  VIEW COMPTA_MOUVEMENT_DETAILGEN (ID, CONTREP, COMPTE, DEBIT, CREDIT, LIBELLEPIECE, REMARQUE, MERE, REFERENCE_ENGAGEMENT, COMPTE_AUX, LETTRAGE, JOURNAL, EXERCICE, ETAT, DATY, FOLIO, COURSDEVISE, MONTANTDEVISE) AS 
  SELECT

    cse.id,

    (

        SELECT MIN(csec.compte) KEEP (DENSE_RANK FIRST ORDER BY GREATEST(csec.debit, csec.credit) DESC)

        FROM compta_sous_ecriture csec, COMPTA_JOURNAL_VIEW cjv

        WHERE csec.idmere = cse.idmere

          AND csec.id <> cse.id

          AND cjv.id = csec.journal

          AND (

            (cse.debit > 0 AND csec.credit > 0) OR

            (cse.credit > 0 AND csec.debit > 0)

            )

          AND cjv.id <> 'COMP000015'

    )  AS contrep,

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

    cse.etat,

    cse.daty,

    cse.folio,

    CAST(0 AS NUMBER(20, 2)) AS coursdevise,

    CAST(0 AS NUMBER(20, 2)) AS montantdevise

FROM

    COMPTA_SOUS_ECRITURE cse

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

        AND cse.credit>0))
 ;