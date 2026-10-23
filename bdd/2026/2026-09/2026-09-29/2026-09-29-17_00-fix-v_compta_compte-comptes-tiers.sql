CREATE
OR REPLACE VIEW v_compta_compte AS
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
WHERE TRIM(compte) IS NOT NULL;

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
    CAST(COURSDEVISE AS NUMBER(20,2)) AS COURSDEVISE,
    CAST(MONTANTDEVISE AS NUMBER(20,2)) AS MONTANTDEVISE,
    TO_NUMBER(REGEXP_SUBSTR(TRIM(compte), '^[0-9]+')) AS compteInt
FROM
    COMPTA_MOUVEMENT_DETAILAUX
WHERE TRIM(compte) IS NOT NULL;
