CREATE OR REPLACE VIEW v_compta_compte AS
SELECT
    id,
    TO_NUMBER(REGEXP_SUBSTR(TRIM(compte), '^[0-9]+')) AS compteInt,
    compte,
    libelle,
    typecompte,
    classy,
    analytique_obli,
    idjournal,
    codeimpot
FROM compta_compte
WHERE REGEXP_LIKE(TRIM(compte), '^[0-9]+');

create or replace view COMPTA_MOUVEMENT_DETAILGEN
            (ID, CONTREP, COMPTE, DEBIT, CREDIT, LIBELLEPIECE, REMARQUE, MERE, REFERENCE_ENGAGEMENT, COMPTE_AUX,
             LETTRAGE, JOURNAL, EXERCICE, ETAT, DATY, FOLIO, COURSDEVISE, MONTANTDEVISE)
as
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
        AND cse.credit>0));


create or replace view COMPTA_MOUVEMENT_ANAL_C as
SELECT
    cma.DEBIT,cma.CREDIT,cma.COMPTE,cma.ETAT,cma.LIBELLE_COMPTE,cma.TYPECOMPTE,cma.MOIS,cma.ANNEE,cma.CHIFFRE3,cma.CHIFFRE2,TO_NUMBER(REGEXP_SUBSTR(TRIM(compte), '^[0-9]+')) AS compteInt
FROM COMPTA_MOUVEMENT_ANALYTIQUE cma
WHERE cma.ETAT = 1 and REGEXP_LIKE(TRIM(compte), '^[0-9]+');

create or replace view COMPTA_MOUVEMENT_DETAILS_GEN_2 as
SELECT
    ID,
    CONTREP,
    COMPTE,
    DEBIT,
    CREDIT,
    LIBELLEPIECE,
    REMARQUE,
    MERE AS IDMERE,
    REFERENCE_ENGAGEMENT,
    COMPTE_AUX,
    LETTRAGE,
    JOURNAL,
    EXERCICE,
    ETAT,
    DATY,
    FOLIO,
    CAST(COURSDEVISE AS NUMBER(20,
                               2)) AS COURSDEVISE,
    CAST(MONTANTDEVISE AS NUMBER(20,
                                 2)) AS MONTANTDEVISE,
    TO_NUMBER(REGEXP_SUBSTR(TRIM(compte), '^[0-9]+')) AS compteInt
FROM
    COMPTA_MOUVEMENT_DETAILGEN
where REGEXP_LIKE(TRIM(compte), '^[0-9]+');


create or replace view COMPTAMOUVEMENTDETAILS_GEN_2_C as
SELECT "ID","CONTREP","COMPTE","DEBIT","CREDIT","LIBELLEPIECE","REMARQUE","IDMERE","REFERENCE_ENGAGEMENT","COMPTE_AUX","LETTRAGE","JOURNAL","EXERCICE","ETAT","DATY","FOLIO","COURSDEVISE","MONTANTDEVISE",TO_NUMBER(REGEXP_SUBSTR(TRIM(compte), '^[0-9]+')) AS compteInt FROM COMPTA_MOUVEMENT_DETAILS_GEN_2 where etat =1 and REGEXP_LIKE(TRIM(compte), '^[0-9]+');

create or replace view COMPTAMOUVEMENTDETAILS_GEN_2_V as
SELECT "ID","CONTREP","COMPTE","DEBIT","CREDIT","LIBELLEPIECE","REMARQUE","IDMERE","REFERENCE_ENGAGEMENT","COMPTE_AUX","LETTRAGE","JOURNAL","EXERCICE","ETAT","DATY","FOLIO","COURSDEVISE","MONTANTDEVISE",TO_NUMBER(REGEXP_SUBSTR(TRIM(compte), '^[0-9]+')) AS compteInt FROM COMPTA_MOUVEMENT_DETAILS_GEN_2 where etat =11 and REGEXP_LIKE(TRIM(compte), '^[0-9]+');


create or replace view COMPTA_MOUVEMENT_ANAL_V as
SELECT
    cma.DEBIT,cma.CREDIT,cma.COMPTE,cma.ETAT,cma.LIBELLE_COMPTE,cma.TYPECOMPTE,cma.MOIS,cma.ANNEE,cma.CHIFFRE3,cma.CHIFFRE2,TO_NUMBER(REGEXP_SUBSTR(TRIM(compte), '^[0-9]+')) AS compteInt
FROM COMPTA_MOUVEMENT_ANALYTIQUE cma
WHERE cma.ETAT = 11 and REGEXP_LIKE(TRIM(compte), '^[0-9]+');
