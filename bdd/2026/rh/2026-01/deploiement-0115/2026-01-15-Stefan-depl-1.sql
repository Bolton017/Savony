create sequence SEQ_HISTORIQUEDEMANDE
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;


CREATE OR REPLACE FUNCTION GET_SEQ_HISTORIQUEDEMANDE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_HISTORIQUEDEMANDE.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;


CREATE OR REPLACE FUNCTION GET_SEQ_MVTABSENCE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_MVTABSENCE.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE TABLE HSMOIS
(	 ID VARCHAR2(50),
     IDCATEGORIE VARCHAR2(50),
     MOIS NUMBER(2,0),
     ANNEE NUMBER(4,0),
     DATY DATE,
     IDDEPARTEMENT VARCHAR2(50),
     ETAT NUMBER(2,0),
     PRIMARY KEY (ID)
);

create sequence SEQHSMOIS
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

CREATE OR REPLACE FUNCTION GETSEQHSMOIS
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQHSMOIS.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;


CREATE OR REPLACE FORCE VIEW HSMOIS_CPL ("ID", "IDCATEGORIE", "MOIS", "ANNEE", "MOISLIB", "DATY", "IDDEPARTEMENT", "ETAT", "IDCATEGORIELIB", "IDDEPARTEMENTLIB", "ETATLIB") AS
SELECT
    hs."ID",hs."IDCATEGORIE",hs."MOIS",hs."ANNEE",
    TO_CHAR(

            TO_DATE(TO_CHAR(hs.mois, 'FM00'), 'MM'),

            'FMMonth',

            'NLS_DATE_LANGUAGE=FRENCH'

    ) AS moisLib,
    hs."DATY",hs."IDDEPARTEMENT",hs."ETAT",
    c.val AS idCategorieLib,
    d.val AS idDepartementLib,
    CASE
        WHEN hs.etat = 1 THEN 'CRÉÉ'
        WHEN hs.etat = 11 THEN 'VISÉE'
        ELSE 'INCONNU'
        END AS etatLib
FROM
    HSMOIS hs
        LEFT JOIN CATEGORIE_PAIE c ON hs.idCategorie = c.id
        LEFT JOIN departement d ON hs.idDepartement = d.id;


ALTER TABLE HEURESUPFABRICATION
    ADD (
        MONTANTJF   NUMBER(30,2),
        MONTANTIF   NUMBER(30,2),
        MONTANTHD   NUMBER(30,2),
        MONTANTMN   NUMBER(30,2),
        MONTANTTMP  NUMBER(30,2),
        MONTANTHN   NUMBER(30,2)
        );

CREATE OR REPLACE FORCE VIEW HEURESUPFABRICATION_CPL ("ID", "IDRESSPARFAB", "HEURENORMALE", "HS", "MN", "JF", "HD", "IF", "ETAT", "REMARQUE", "IDPERSONNE", "IDFABRICATION", "DATEFABRICATION", "ETATLIB", "IDPERSONNELIB", "MATRICULE", "TAUXHORAIRE", "TAUXHORAIREEFFECTIVE", "TEMPORAIRE", "MONTANT", "IDQUALIFICATION", "MONTANTJF", "MONTANTHD", "MONTANTIF", "MONTANTMN", "MONTANTHN") AS
SELECT
    h.ID,h.IDRESSPARFAB,h.HEURENORMALE ,h.HS,h.MN,h.JF,h.HD,h.IF,h.ETAT,h.REMARQUE,
    p.id AS  idPersonne,
    h.idFabrication,
    fab.daty as dateFabrication,
    CASE
        WHEN h.etat=0
            THEN 'ANNULEE'
        WHEN h.etat=1
            THEN 'CREE'
        WHEN h.etat=11
            THEN 'VISEE'
        END AS etatlib,
    pm.NOM || ' ' || pm.PRENOM AS idPersonnelib,
    p.MATRICULE,
    r.TAUXHORAIRE,
    CAST(nvl(c.montant,0)/((40*52)/12) AS NUMBER(30,2) ) AS TAUXHORAIREEFFECTIVE,
    p.temporaire,
    h.MONTANT,
    r.IDQUALIFICATION,
    NVL(h.montantJF, 0) as montantJF,
    NVL(h.montantHD, 0) as montantHD,
    NVL(h.montantIF,0) as montantIF,
    NVL(h.montantMN, 0) as montantMN,
    NVL(h.MONTANTHN, 0) as montantHN
FROM HEURESUPFABRICATION h
         LEFT JOIN RESSOURCEPARFABRICATIONCOMPLET r ON r.id = h.IDRESSPARFAB
         LEFT JOIN PAIE_INFO_PERSONNEL p ON p.id = r.idRessource
         LEFT JOIN CATEGORIE_QUALIFICATION c
                   ON c.IDQUALIFICATION = r.IDQUALIFICATION
                       AND c.IDCATEGORIE = r.IDCATEGORIE
                       AND (
                          (c.REMARQUE IS NULL)
                              OR (c.REMARQUE = r.IDRESSOURCE)
                          )
         LEFT JOIN LOG_PERSONNEL pm ON pm.id = r.IDRESSOURCE
         LEFT JOIN FABRICATION fab ON fab.ID = h.IDFABRICATION;


CREATE OR REPLACE FORCE VIEW HS_FABRICATION_SEMAINE ("IDPERSONNE", "ANNEE", "MOIS", "SEMAINE", "HS_TOTAL", "HS30", "HS50") AS
SELECT
    hp.idPersonne,
    p.annee,
    p.mois,
    TO_CHAR(f.daty, 'IYYY-IW') AS semaine,
    SUM(hp.HS) AS hs_total,
    LEAST(SUM(hp.HS), 8) AS hs30,
    GREATEST(SUM(hp.HS) - 8, 0) AS hs50
FROM HEURESUPFABRICATION_CPL hp
         LEFT JOIN FABRICATION f ON f.id = hp.IDFABRICATION
         LEFT JOIN PERIODEPAIE p ON f.daty BETWEEN p.datedebut AND p.datefin
GROUP BY hp.idPersonne, p.annee, p.mois, TO_CHAR(f.daty, 'IYYY-IW');


CREATE OR REPLACE FORCE VIEW HS_FABRICATION_SEMAINE_TMP ("IDPERSONNE", "ANNEE", "MOIS", "SEMAINE", "HS_TOTAL", "HS30", "HS50") AS
SELECT
    t.idPersonne,
    t.annee,
    t.mois,
    t.semaine,

    -- Total HS déclenchées (au-delà de 40h)
    SUM(t.hs_declenchees) AS hs_total,

    -- Répartition
    LEAST(SUM(t.hs_declenchees), 8)        AS hs30,
    GREATEST(SUM(t.hs_declenchees) - 8, 0) AS hs50

FROM (
         SELECT
             p.id                         AS idPersonne,
             per.annee,
             per.mois,
             TO_CHAR(f.daty, 'IYYY-IW')   AS semaine,
             f.daty,
             h.HEURENORMALE,
             -- HS déclenchées pour le jour
             CASE
                 WHEN
                     SUM(h.HEURENORMALE) OVER (
                         PARTITION BY p.id, TO_CHAR(f.daty, 'IYYY-IW')
                         ORDER BY f.daty
                         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                         ) > 40
                     THEN
                     LEAST(
                             h.HEURENORMALE,
                             SUM(h.HEURENORMALE) OVER (
                                 PARTITION BY p.id, TO_CHAR(f.daty, 'IYYY-IW')
                                 ORDER BY f.daty
                                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                                 ) - 40
                     )
                 ELSE 0
                 END AS hs_declenchees

         FROM HEURESUPFABRICATION h
                  LEFT JOIN RESSOURCEPARFABRICATIONCOMPLET r ON r.id = h.IDRESSPARFAB
                  LEFT JOIN PAIE_INFO_PERSONNEL p ON p.id = r.idRessource
                  LEFT JOIN FABRICATION f ON f.id = h.IDFABRICATION
                  LEFT JOIN PERIODEPAIE per ON f.daty BETWEEN per.datedebut AND per.datefin
     ) t
GROUP BY
    t.idPersonne,
    t.annee,
    t.mois,
    t.semaine;

CREATE OR REPLACE FORCE VIEW HS_MOIS ("IDPERSONNEL", "ANNEE", "MOIS", "HS30_MOIS", "HS50_MOIS", "IDDEPARTEMENT", "IDCATEGORIE") AS
SELECT
    IDPERSONNE as idPersonnel,
    annee,
    mois,
    SUM(hs30) AS hs30_mois,
    SUM(hs50) AS hs50_mois,
    pip.IDDEPARTEMENT,
    pip.IDCATEGORIE_PAIE as idCategorie
FROM HS_FABRICATION_SEMAINE hs
         LEFT JOIN PAIE_INFO_PERSONNEL pip on pip.id = hs.idPersonne
GROUP BY idPersonne, annee, mois, pip.IDDEPARTEMENT, pip.IDCATEGORIE_PAIE;


DELETE FROM MENUDYNAMIQUE m WHERE ID = 'MENDYN176548226245570';

CREATE OR REPLACE FORCE VIEW LOG_PERSONNEL_AVECCONGE
            (
             ID,
             PERMIS_CONDUIRE,
             CHEMIN_PERMIS,
             REMARQUE,
             ID_PERS,
             NOM,
             PRENOM,
             DATE_NAISSANCE,
             SEXE,
             NUMERO_CIN,
             DATE_CIN,
             DATE_DUPL_CIN,
             NATIONALITE,
             ADRESSE,
             FOKOTANY,
             ACTE_NAISSANCE,
             DIRECTION,
             SERVICE,
             CODE_DR,
             MATRICULE,
             IDCATEGORIE,
             CTG,
             INDICEGRADE,
             INDICE_FONCTIONNEL,
             STATUT,
             CATEGORIEVAL,
             CTGVAL,
             NUMERO_CNAPS,
             NUMERO_OSTIE,
             TEMPORAIRE,
             DROIT,
             PRIE,
             RESTECONGE,
             ETAT,
             IDPERSONNEL,
             IDDIRECTION
                ) AS
SELECT *
FROM (
         SELECT
             l.id,
             l.permis_conduire,
             l.chemin_permis,
             l.remarque,
             l.id_pers,
             l.nom,
             l.prenom,
             l.date_naissance,
             sex.desce AS sexe,
             l.numero_cin,
             l.date_cin,
             l.date_dupl_cin,
             l.nationalite,
             l.adresse,
             l.fokotany,
             l.acte_naissance,
             d.val AS direction,
             s.libelle AS service,
             s.code_dr,
             TO_CHAR(paie.matricule) AS matricule,
             paie.idcategorie,
             paie.ctg,
             paie.indicegrade,
             paie.indice_fonctionnel,
             paie.statut,
             c.taux AS categorieval,
             '' AS ctgval,
             paie.numero_cnaps,
             paie.numero_ostie,
             CASE
                 WHEN paie.temporaire = -1 THEN 'Temporaire'
                 WHEN paie.temporaire = 0  THEN 'Permanent'
                 WHEN paie.temporaire = 1  THEN 'Cadre'
                 ELSE NULL
                 END AS temporaire,
             CAST(NVL(sc.plus, 0) AS NUMBER(30,2)) AS droit,
             CAST(NVL(sp.congepris, 0) AS NUMBER(30,2)) AS prie,
             CAST(NVL(sc.solde, 0) AS NUMBER(30,2)) AS resteconge,
             paie.etat,
             l.id AS idpersonnel,
             l.direction AS iddirection
         FROM log_personnel l
                  LEFT JOIN log_service s ON l.service = s.id
                  LEFT JOIN paie_info_personnel paie ON paie.id = l.id
                  LEFT JOIN sexe sex ON l.sexe = sex.id
                  LEFT JOIN log_direction d ON d.id = l.direction
                  LEFT JOIN paie_categorie c ON c.id = paie.idcategorie
                  LEFT JOIN soldecongepris_pers sp ON l.id = sp.id
                  LEFT JOIN soldeconge_pers sc ON l.id = sc.idpersonnel
         ORDER BY paie.matricule ASC
     )
WHERE ROWNUM >= 1;


CREATE OR REPLACE FUNCTION GETSEQSIGPERSONNES
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQSIGPERSONNES.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;


CREATE OR REPLACE FUNCTION GET_SEQ_LOGPERSONNEL
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_LOGPERSONNEL.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETavancement
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQavancement.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETSEQDEPARTEMENT
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQDEPARTEMENT.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETSEQENFANTPERS
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQENFANTPERS.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETSEQFORMATIONDIPLOME
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQFORMATIONDIPLOME.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETSEQLOGPERSONNELNONVALIDE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQLOGPERSONNELNONVALIDE.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETSEQLOGSERVICE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQLOGSERVICE.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETSEQMODEPAIEMENT
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQMODEPAIEMENT.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETSEQPAIEEDITION
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQPAIEEDITION.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETSEQPAIEMENTHS
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQPAIEMENTHS.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETSEQPAIEPERSELTMERE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQPAIEPERSELTMERE.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETSEQPAIE_GROUPEFONCTION
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQPAIE_GROUPEFONCTION.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETSEQPAIE_RUBRIQUE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQPAIE_RUBRIQUE.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETSEQPOSTE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQPOSTE.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETSEQ_CHARGEPERSONNELTEMP
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_CHARGEPERSONNELTEMP.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETSEQ_TRAITEMENTPAIE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_TRAITEMENTPAIE.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION get_seqBilanSection
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seqBilanSection.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GET_SEQFORMATION_DIPLOME
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQFORMATION_DIPLOME.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GET_SEQPOSTE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQPOSTE.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GET_SEQRUBRIQUEMANUEL
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQRUBRIQUEMANUEL.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GET_SEQXC
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQXC.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GET_SEQ_AVANCE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_AVANCE.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GET_SEQ_CATEGORIE_QUALIF
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_CATEGORIE_QUALIF.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GET_SEQ_LOG_SERVICE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_LOG_SERVICE.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GET_SEQ_PAIE_AVANCEMENT
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_PAIE_AVANCEMENT.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GET_SEQ_PAIE_EDITION
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_PAIE_EDITION.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GET_SEQ_PAIE_FONCTION
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_PAIE_FONCTION.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GET_SEQ_PAIE_INFO_PERSONNEL
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_PAIE_INFO_PERSONNEL.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GET_SEQ_REMBOURSEMENT
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_REMBOURSEMENT.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GET_SEQ_SANCTION
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_SANCTION.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GET_SEQ_TYPEABSENCE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_TYPEABSENCE.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GET_SEQ_TYPE_CONTRAT
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_TYPE_CONTRAT.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GETSEQLOGSERVICE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_LOGSERVICE.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

CREATE OR REPLACE FUNCTION GET_SEQXC
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_XC.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

ALTER TABLE CHARGEPERSONNELTEMP
    ADD (
        heurenormal   NUMBER(10,2)
);

UPDATE PAIE_INFO_PERSONNEL
SET MATRICULE = LTRIM(MATRICULE, '0')
WHERE MATRICULE LIKE '0%';