INSERT INTO DEPARTEMENT (ID, VAL, DESCE) VALUES ('DEPT001', 'BISCUITERIE', 'BISCUITERIE');
INSERT INTO DEPARTEMENT (ID, VAL, DESCE) VALUES ('DEPT002', 'CONFISERIE', 'CONFISERIE');
 
INSERT INTO FORMATION_DIPLOME(ID, VAL, DESCE) VALUES ('FD001', 'BAC GENERAL', 'BAC GENERAL');
INSERT INTO FORMATION_DIPLOME(ID, VAL, DESCE) VALUES ('FD002', 'LICENSE', 'LICENSE');

create sequence seqsocobis
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

CREATE OR REPLACE FUNCTION GET_SEQSOCOBIS
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seqsocobis.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

UPDATE Sexe
SET id = '0'
WHERE id = '00';

UPDATE Sexe
SET id = '1'
WHERE id = '11';

CREATE OR REPLACE VIEW LOG_PERSONNEL_AVECCONGE ("ID", "PERMIS_CONDUIRE", "CHEMIN_PERMIS", "REMARQUE", "ID_PERS", "NOM", "PRENOM", "DATE_NAISSANCE", "SEXE", "NUMERO_CIN", "DATE_CIN", "DATE_DUPL_CIN", "NATIONALITE", "ADRESSE", "FOKOTANY", "ACTE_NAISSANCE", "DIRECTION", "SERVICE", "CODE_DR", "MATRICULE", "IDCATEGORIE", "CTG", "INDICEGRADE", "INDICE_FONCTIONNEL", "STATUT", "CATEGORIEVAL", "CTGVAL", "NUMERO_CNAPS", "NUMERO_OSTIE", "TEMPORAIRE", "DROIT", "PRIE", "RESTECONGE", "ETAT", "IDPERSONNEL", "IDDIRECTION", "DEPARTEMENTLIB") AS 
  SELECT l.id,
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
           WHEN paie.temporaire = 0 THEN 'Permanent'
           WHEN paie.temporaire = 1 THEN 'Cadre'
           ELSE NULL
           END AS temporaire,
       CAST(NVL(sc.PLUS , 0) AS NUMBER(30, 2)) AS droit ,
       CAST(NVL(sp.CONGEPRIS , 0) AS NUMBER(30, 2)) AS prie,
       CAST(NVL(sc.SOLDE, 0) AS NUMBER(30, 2)) AS resteconge,
       paie.etat,
       l.id AS idpersonnel,
       l.direction AS iddirection,
       dp.val AS departementlib
FROM log_personnel l
         LEFT JOIN log_service s ON l.service = s.id
         LEFT JOIN paie_info_personnel paie ON paie.id = l.id
         LEFT JOIN sexe sex ON l.sexe = sex.id
         LEFT JOIN log_direction d ON d.id = l.direction
         LEFT JOIN paie_categorie c ON c.id = paie.idcategorie
         LEFT JOIN SOLDECONGEPRIS_PERS sp ON l.id = sp.id
         LEFT JOIN SOLDECONGE_PERS sc ON l.id = sc.idPersonnel
         LEFT JOIN departement dp ON paie.idDepartement = dp.id;


CREATE TABLE PERIODEPAIE(
    id VARCHAR(255) PRIMARY KEY,
    mois VARCHAR(255),
    moislib VARCHAR(255),
    datedebut DATE,
    datefin DATE,
    idcategoriepaie VARCHAR(255),
    etat NUMBER(38,0)
);

