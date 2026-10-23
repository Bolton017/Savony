CREATE OR REPLACE VIEW ENFANTPERSONNEL_CPL AS
SELECT
    e.ID,
    e.IDPERSONNEL,
    e.NOM,
    e.DATENAISSANCE,
    CASE
        WHEN e.GENRE = 1 THEN 'Masculin'
        ELSE 'F&eacute;minin'
    END AS GENRELIB,
    log.nom || ' ' || log.prenom AS nomPersonnel,
    log.matricule,
    FLOOR(MONTHS_BETWEEN(SYSDATE, e.dateNaissance) / 12) AS age
FROM ENFANTPERSONNEL e
LEFT JOIN LOG_PERSONNEL_V2 log
    ON e.idpersonnel = log.id;
