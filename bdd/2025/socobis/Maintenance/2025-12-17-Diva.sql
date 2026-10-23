CREATE TABLE MOTRAVAUX(
    ID VARCHAR2(50) NOT NULL PRIMARY KEY,
    IDPERSONNEL VARCHAR2(255),
    IDTRAVAUX VARCHAR2(255),
    DUREEESTIMATIF VARCHAR2(50),
    TAUXHORAIRE NUMBER
);

CREATE SEQUENCE seq_motravaux
    START WITH 1
    INCREMENT BY 1
    NOCACHE
NOCYCLE;

CREATE OR REPLACE FUNCTION getSeqmotravaux
RETURN NUMBER
IS
    retour NUMBER;
BEGIN
SELECT seq_motravaux.NEXTVAL into retour from dual;
RETURN retour;
END;

CREATE OR REPLACE VIEW MoTravauxLib AS
    SELECT
        mo.*,
        LPAD(FLOOR(TO_NUMBER(mo.DUREEESTIMATIF) / 3600), 2, '0') || ':' ||
        LPAD(FLOOR(MOD(TO_NUMBER(mo.DUREEESTIMATIF), 3600) / 60), 2, '0') || ':' ||
        LPAD(MOD(TO_NUMBER(mo.DUREEESTIMATIF), 60), 2, '0')
            AS dureeEstimatifLib,
        ((mo.DUREEESTIMATIF/60)/60)*mo.TAUXHORAIRE AS montant,
        p.NOM AS idPersonnelLib
    FROM MOTRAVAUX mo
    LEFT JOIN PERSONNEL p ON p.ID = mo.IDPERSONNEL;

ALTER TABLE TRAVAUX ADD dureeEstimatif VARCHAR2(50);

CREATE TABLE ProcessMaintenance (
    ID VARCHAR2(50) NOT NULL PRIMARY KEY,
    IDPERSONNEL VARCHAR2(255),
    IDTRAVAUX VARCHAR2(255),
    DATEDEBUT DATE,
    DATEFIN DATE,
    HEUREDEBUT VARCHAR2(50),
    HEUREFIN VARCHAR2(50)
);

CREATE SEQUENCE seq_processmaintenance
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE FUNCTION getSeqprocessmaintenance
    RETURN NUMBER
    IS
    retour NUMBER;
BEGIN
    SELECT seq_processmaintenance.NEXTVAL into retour from dual;
    RETURN retour;
END;

ALTER TABLE ProcessMaintenance ADD DATEFIN DATE;

alter table MOTRAVAUX rename column LOGPERSONNEL to IDPERSONNEL;


CREATE OR REPLACE VIEW ProcessMaintenanceLib AS
SELECT
    prc.*,
    /* Écart en secondes */
    ROUND((prc.datetime_fin - prc.datetime_debut) * 86400) AS ecart_seconde,
    /* Écart format HH:MM:SS */
    LPAD(FLOOR(ROUND((prc.datetime_fin - prc.datetime_debut) * 86400) / 3600), 2, '0')
        || ':' ||
    LPAD(FLOOR(MOD(ROUND((prc.datetime_fin - prc.datetime_debut) * 86400), 3600) / 60), 2, '0')
        || ':' ||
    LPAD(MOD(ROUND((prc.datetime_fin - prc.datetime_debut) * 86400), 60), 2, '0')
                                                           AS ecart_hms,
    p.NOM AS idPersonnelLib
FROM (
         SELECT
             prc.*,

             /* Date + Heure début */
             prc.DATEDEBUT
                 + (TO_DATE(prc.HEUREDEBUT, 'HH24:MI:SS')
                 - TRUNC(TO_DATE(prc.HEUREDEBUT, 'HH24:MI:SS')))
                 AS datetime_debut,

             /* Date + Heure fin */
             prc.DATEFIN
                 + (TO_DATE(prc.HEUREFIN, 'HH24:MI:SS')
                 - TRUNC(TO_DATE(prc.HEUREFIN, 'HH24:MI:SS')))
                 AS datetime_fin

         FROM ProcessMaintenance prc
     ) prc
    LEFT JOIN PERSONNEL p ON p.ID = prc.IDPERSONNEL;

CREATE OR REPLACE VIEW ProcessMaintenanceGlobal AS
SELECT
    pr.IDTRAVAUX,
    pr.IDPERSONNEL,
    sum(pr.ecart_seconde) as dureeReel,
    LPAD(FLOOR(TO_NUMBER(sum(pr.ecart_seconde)) / 3600), 2, '0') || ':' ||
    LPAD(FLOOR(MOD(TO_NUMBER(sum(pr.ecart_seconde)), 3600) / 60), 2, '0') || ':' ||
    LPAD(MOD(TO_NUMBER(sum(pr.ecart_seconde)), 60), 2, '0')
        AS dureeReelHMS
FROM PROCESSMAINTENANCELIB pr
group by pr.IDTRAVAUX, pr.IDPERSONNEL;

CREATE OR REPLACE VIEW RapprochementTravaux AS
    SELECT
        '' AS ID,
        mo.IDTRAVAUX,
        mo.IDPERSONNEL,
        mo.idPersonnelLib,
        mo.dureeEstimatifLib AS dureeEstimatif_hms,
        pr.dureeReelHMS AS dureeReel_hms,
        LPAD(FLOOR(TO_NUMBER(mo.DUREEESTIMATIF - pr.dureeReel) / 3600), 2, '0') || ':' ||
        LPAD(FLOOR(MOD(TO_NUMBER(mo.DUREEESTIMATIF - pr.dureeReel), 3600) / 60), 2, '0') || ':' ||
        LPAD(MOD(TO_NUMBER(mo.DUREEESTIMATIF - pr.dureeReel), 60), 2, '0')
            AS ecart_hms,
        mo.DUREEESTIMATIF AS dureeEstimatif_seconde,
        pr.dureeReel AS dureeReel_seconde,
        mo.DUREEESTIMATIF - pr.dureeReel AS ecart_seconde,
        mo.montant AS montantEstimatif,
        ((pr.dureeReel/60)/60)*mo.TAUXHORAIRE AS montantReel,
        mo.montant - (((pr.dureeReel/60)/60)*mo.TAUXHORAIRE) AS montantEcart
    FROM MOTRAVAUXLIB mo
    LEFT JOIN ProcessMaintenanceGlobal pr ON pr.IDPERSONNEL = mo.IDPERSONNEL AND pr.IDTRAVAUX = mo.IDTRAVAUX;


CREATE OR REPLACE VIEW RapprochementTravaux AS
SELECT
    CAST(NULL AS VARCHAR2(50)) AS id,
    mo.IDTRAVAUX,
    mo.IDPERSONNEL,
    mo.idPersonnelLib,

    mo.dureeEstimatifLib AS dureeEstimatif_hms,
    pr.dureeReelHMS AS dureeReel_hms,

    LPAD(FLOOR((mo.DUREEESTIMATIF - NVL(pr.dureeReel,0)) / 3600), 2, '0') || ':' ||
    LPAD(FLOOR(MOD((mo.DUREEESTIMATIF - NVL(pr.dureeReel,0)), 3600) / 60), 2, '0') || ':' ||
    LPAD(MOD((mo.DUREEESTIMATIF - NVL(pr.dureeReel,0)), 60), 2, '0')
                               AS ecart_hms,

    mo.DUREEESTIMATIF AS dureeEstimatif_seconde,
    pr.dureeReel AS dureeReel_seconde,
    mo.DUREEESTIMATIF - NVL(pr.dureeReel,0) AS ecart_seconde,

    mo.montant AS montantEstimatif,
    (NVL(pr.dureeReel,0) / 3600.0) * mo.TAUXHORAIRE AS montantReel,
    mo.montant - ((NVL(pr.dureeReel,0) / 3600.0) * mo.TAUXHORAIRE) AS montantEcart

FROM MOTRAVAUXLIB mo
         LEFT JOIN ProcessMaintenanceGlobal pr
                   ON pr.IDPERSONNEL = mo.IDPERSONNEL
                       AND pr.IDTRAVAUX = mo.IDTRAVAUX;
