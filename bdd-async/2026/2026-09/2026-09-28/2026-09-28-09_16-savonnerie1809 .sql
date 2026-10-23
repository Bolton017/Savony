-- SAVONNERIE1809.COMPTA_MOUVEMENT_DETAILAUX source

CREATE OR REPLACE  VIEW COMPTA_MOUVEMENT_DETAILAUX (ID, CONTREP, COMPTE_AUXLIB, COMPTE, DEBIT, CREDIT, LIBELLEPIECE, REMARQUE, IDMERE, REFERENCE_ENGAGEMENT, COMPTE_AUX, LETTRAGE, JOURNAL, EXERCICE, ETAT, DATY, FOLIO, COURSDEVISE, MONTANTDEVISE) AS 
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

    cse.compte AS REFERENCE_ENGAGEMENT,

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
        
CREATE OR REPLACE  VIEW COMPTA_MOUVEMENT_DETAILS_AUX_2 (ID, CONTREP, COMPTE, DEBIT, CREDIT, LIBELLEPIECE, REMARQUE, IDMERE, REFERENCE_ENGAGEMENT, COMPTE_AUX, LETTRAGE, JOURNAL, EXERCICE, ETAT, DATY, FOLIO, COMPTE_AUXLIB, COURSDEVISE, MONTANTDEVISE, COMPTEINT) AS 
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
--WHERE REGEXP_LIKE(TRIM(compte), '^[0-9]+')
;

-- SAVONNERIE1809.V_COMPTA_COMPTE source

CREATE OR REPLACE  VIEW V_COMPTA_COMPTE ("ID", "COMPTEINT", "COMPTE", "LIBELLE", "TYPECOMPTE", "CLASSY", "ANALYTIQUE_OBLI", "IDJOURNAL", "CODEIMPOT") AS 
  SELECT id,
       TO_NUMBER(REGEXP_SUBSTR(TRIM(compte), '^[0-9]+')) AS compteInt,
       compte,
       libelle,
       typecompte,
       classy,
       analytique_obli,
       idjournal,
       codeimpot
FROM compta_compte
--WHERE REGEXP_LIKE(TRIM(compte), '^[0-9]+')
 ;

INSERT INTO COMPTA_COMPTE
(ID, COMPTE, LIBELLE, TYPECOMPTE, CLASSY, ANALYTIQUE_OBLI, IDJOURNAL, CODEIMPOT)
VALUES('COMCSOC0003914P', '44551', 'TVA à décaisser', '1', '4', NULL, 'COMP000035', NULL);

INSERT INTO COMPTA_COMPTE
(ID, COMPTE, LIBELLE, TYPECOMPTE, CLASSY, ANALYTIQUE_OBLI, IDJOURNAL, CODEIMPOT)
VALUES('COMCSOC0003914CR', '44567', 'Crédit de TVA à reporter', '1', '4', NULL, 'COMP000035', NULL);