CREATE OR REPLACE VIEW v_compta_compte AS
SELECT
    id,
    TO_NUMBER(REGEXP_SUBSTR(TRIM(compte), '^[0-9]+')) AS compte,
    compte AS true_compte,
    libelle,
    typecompte,
    classy,
    analytique_obli,
    idjournal,
    codeimpot
FROM compta_compte
WHERE REGEXP_LIKE(TRIM(compte), '^[0-9]+');