CREATE TABLE PERIODEPAIE(
                            id VARCHAR(255) PRIMARY KEY,
                            mois VARCHAR(255),
                            moislib VARCHAR(255),
                            datedebut DATE,
                            datefin DATE,
                            idcategoriepaie VARCHAR(255),
                            ANNEE number(10),
                            etat NUMBER(38,0)
);

CREATE OR REPLACE VIEW HS_FABRICATION_SEMAINE AS
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


CREATE OR REPLACE VIEW HS_MOIS AS
SELECT
    idPersonne,
    annee,
    mois,
    SUM(hs30) AS hs30_mois,
    SUM(hs50) AS hs50_mois,
    pip.IDDEPARTEMENT,
    pip.IDCATEGORIE_PAIE as idCategorie
FROM HS_FABRICATION_SEMAINE hs
         LEFT JOIN PAIE_INFO_PERSONNEL pip on pip.id = hs.idPersonne
GROUP BY idPersonne, annee, mois, pip.IDDEPARTEMENT, pip.IDCATEGORIE_PAIE;




create or replace view HEURESUPFABRICATION_CPL as
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
    h.MONTANT
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



create or replace view RESSOURCEPARFABRICATIONCOMPLET as
SELECT
    r.id,
    r.idFabrication,
    r.idPoste AS idPosteDefaut,
    r.idRessource,
    p.matricule,
    f.IDOF,
    r.etat,
    p.TEMPORAIRE,
    p.IDQUALIFICATION AS IdQualification,
    c.IDCATEGORIE,
    c.idPoste,
    po.VAL AS idPostelib,
    p.IDQUALIFICATION AS IdQualificationEffective,
    CAST(c.montant / ((40 * 52) / 12) AS NUMBER(30,2)) AS tauxhoraire,
    h.HS,
    h.MN,
    h.JF,
    h.HD,
    h.IF,
    CASE
        WHEN r.etat = 0  THEN 'ANNULEE'
        WHEN r.etat = 1  THEN 'CREE'
        WHEN r.etat = 11 THEN 'VISEE'
        END AS etatlib,
    p.MATRICULE AS idRessourcelib
FROM ressourceParFabrication r
         LEFT JOIN PAIE_INFO_PERSONNEL p
                   ON p.id = r.idRessource
         LEFT JOIN CATEGORIE_QUALIFICATION c
                   ON c.IDQUALIFICATION = r.IDQUALIFICATION AND c.IDCATEGORIE = p.IDCATEGORIE_PAIE
                       AND (
                          (c.REMARQUE IS NULL)
                              OR (c.REMARQUE = r.IDRESSOURCE)
                          )
         LEFT JOIN FABRICATION f
                   ON f.id = r.idFabrication
         LEFT JOIN heureSupFabrication h
                   ON h.idRessParFab = r.id
         LEFT JOIN POSTE po
                   ON po.id = c.idPoste;




INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000130', 'HEURE SUPP 30% NI', 'Heure supp 30% NI', 221, null, null, '130', 'G', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 1, 2, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000150', 'HEURE SUPP 50% NI', 'Heure supp 50% NI', 224, null, null, '150', 'G', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 1, 2, 2, 1, 1, '%', null, null, null, null, null, null, 2);

INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000150I', 'HEURE SUPP 50% I', 'Heure supp 50% I', 225, null, null, '151', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 2, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000130I', 'HEURE SUPP 30% I', 'Heure supp 30% I', 222, null, null, '131', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 2, 2, 1, 1, '%', null, null, null, null, null, null, 2);


update DETFORMU set FORMULE='Math.min (0.02*[++imposable==I..gain], [conf::CONF0001])' where id='DETCNAPS';




-- 21:23
-- UPDATE DEPARTEMENT PERSONNEL
UPDATE paie_info_personnel
SET iddepartement = 'DEPT001'
WHERE id IN (
             'PRS000754', 'PRS000755', 'PRS000757', 'PRS000758', 'PRS000760',
             'PRS000762', 'PRS000764', 'PRS000777', 'PRS000785', 'PRS000799',
             'PRS000802', 'PRS000803', 'PRS000806', 'PRS000811', 'PRS000812',
             'PRS000829', 'PRS000850', 'PRS000800', 'PRS000801', 'PRS000851',
             'PRS000852', 'PRS000865', 'PRS000914', 'PRS000918', 'PRS000919',
             'PRS000920', 'PRS000998', 'PRS001002', 'PRS001015', 'PRS000964',
             'PRS000932', 'PRS000933', 'PRS000937', 'PRS000942', 'PRS000926',
             'PRS000944', 'PRS000945', 'PRS000953', 'PRS000954', 'PRS001082',
             'PRS001084', 'PRS000739', 'PRS000742', 'PRS000743', 'PRS000750',
             'PRS001018', 'PRS001019', 'PRS001022', 'PRS001034', 'PRS001042',
             'PRS001045', 'PRS001047', 'PRS001048', 'PRS001052', 'PRS001055',
             'PRS001058'
    );


UPDATE paie_info_personnel
SET iddepartement = 'DEPT002'
WHERE id IN (
             'PRS000828', 'PRS000832', 'PRS000833', 'PRS000837', 'PRS000838',
             'PRS000921', 'PRS000967', 'PRS000968', 'PRS000969', 'PRS000970',
             'PRS000971', 'PRS000973', 'PRS000997', 'PRS000999', 'PRS001001',
             'PRS001005', 'PRS001016', 'PRS000934', 'PRS000936', 'PRS000939',
             'PRS000940', 'PRS000941', 'PRS000925', 'PRS000946', 'PRS000951',
             'PRS000955', 'PRS000957', 'PRS000958', 'PRS000959', 'PRS000960',
             'PRS000643', 'PRS000716', 'PRS000733', 'PRS001017', 'PRS001020',
             'PRS001021', 'PRS001023', 'PRS001024', 'PRS001025', 'PRS001030',
             'PRS001031', 'PRS001032', 'PRS001037', 'PRS001039', 'PRS001040',
             'PRS001041', 'PRS001043', 'PRS001044', 'PRS001046'
    );


create or replace view V_MOYENNE_SALAIRE_PARFONCTION as
SELECT
    pip.idfonction,
    pf.desce as fonctionlib,
    pem.annee,
    pem.mois,
    ROUND(AVG(pe.GAIN), 2) AS moyenne_salaire_base
FROM PAIE_EDITION pe
         LEFT JOIN PAIE_EDITIONMOISANNEE pem ON pem.ID = pe.IDEDITION
         LEFT JOIN PAIE_INFO_PERSONNEL pip ON pip.ID = pe.IDPERSONNEL
         left join PAIE_FONCTION pf ON pf.id = pip.IDFONCTION
WHERE pe.IDELEMENTPAIE = 'PR000041'
GROUP BY pip.idfonction, pf.desce, pem.annee, pem.mois;


create or replace view TAUXABSENTEISME as
SELECT
    CAST(nb.NBPERSONNELVALIDE * 173.33 AS NUMBER(30, 2)) AS heuretheorique,
    CAST(NVL(SUM(p.ABSENCE), 0) AS NUMBER(30, 2)) AS heureabsence,
    p.mois,
    p.ANNEE,
    CAST(
            ROUND(
                    (NVL(SUM(p.ABSENCE), 0) / (nb.NBPERSONNELVALIDE * 173.33)) * 100,
                    2
            ) AS NUMBER(30, 2)
    ) AS tauxAbsence,
    TO_CHAR(
            TO_DATE(TO_CHAR(p.mois, 'FM00'), 'MM'),
            'FMMonth',
            'NLS_DATE_LANGUAGE=FRENCH'
    ) AS moisLib,
    p.DIRECTION AS iddirection
FROM
    POINTAGE p,
    NB_PERS_VALIDE nb
GROUP BY
    nb.NBPERSONNELVALIDE, p.mois, p.ANNEE, p.DIRECTION;


create or replace view HS_MOIS as
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


INSERT INTO RESSOURCEPARFABRICATION (ID, IDFABRICATION, IDPOSTE, IDRESSOURCE, ETAT, IDQUALIFICATION,
                                     REMARQUE)
VALUES ('RPF000143', 'FAB003777', null, 'PRS001048', 1, 'QUAL0001', null);

INSERT INTO HEURESUPFABRICATION (ID, IDRESSPARFAB, HS, MN, JF, HD, IF, ETAT, REMARQUE, TEMPORAIRE,
                                 HEURENORMALE, POSTE, EQUIPE, MONTANT, IDFABRICATION)
VALUES ('HSF184', 'RPF000143', 8.00, 0.00, 0.00, 0.00, 0.00, 1, null, 0, 0.00, null, null, 0.0000000000,
        'FAB003777');


UPDATE HEURESUPFABRICATION SET IDRESSPARFAB = 'RPFAB000205', HS = 10.00, MN = 0.00, JF = 0.00, HD = 0.00, IF = 0.00, ETAT = 1, REMARQUE = null, TEMPORAIRE = 0, HEURENORMALE = 0.00, POSTE = null, EQUIPE = null, MONTANT = 0.0000000000, IDFABRICATION = 'FAB003195' WHERE ID = 'HSFab000184';


create or replace view HSMOIS_CPL as
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
        WHEN hs.etat = 1 THEN 'CREE'
        WHEN hs.etat = 11 THEN 'VISEE'
        ELSE 'INCONNU'
        END AS etatLib
FROM
    HSMOIS hs
        LEFT JOIN CATEGORIE_PAIE c ON hs.idCategorie = c.id
        LEFT JOIN departement d ON hs.idDepartement = d.id;


-- 22:07
-- Details elt de paie dans hs mois
create or replace view PAIEPERS_ELP_CPL as
SELECT
    ppe.id,
    pip2.matricule,
    pr.id as id_code_rubrique,
    pr.val AS nomRubrique,
    ppe.date_debut,
    ppe.date_fin,
    ppe.gain,
    ppe.retenue,
    ppe.remarque,
    pip.nom || ' ' || pip.prenom AS nomPersonnel,
    ppe.etat,
    ppe.id_objet,
    ppe.iduser,
    ppe.moisregularisation,
    ppe.anneeregularisation,
    cq.idcategorielib || ' ' || cq.categorie_qualificationlib AS idcategorie_qualification,
    pf.desce AS idfonction,
    ppe.pourcentage,
    CASE
        WHEN ppe.etat = 1 THEN 'CRÉÉ'
        WHEN ppe.etat = 11 THEN 'VISÉE'
        ELSE 'INCONNU'
        END AS etatLib
FROM paie_personnel_elementpaie ppe
         LEFT JOIN log_personnel pip ON TO_CHAR(pip.id) = TO_CHAR(ppe.idpersonnel)
         LEFT JOIN categorie_qualification_libc cq ON TO_CHAR(ppe.idcategorie_qualification) = TO_CHAR(cq.id)
         LEFT JOIN paie_fonction pf ON TO_CHAR(ppe.idfonction) = TO_CHAR(pf.id)
         LEFT JOIN paie_rubrique pr ON TO_CHAR(pr.id) = TO_CHAR(ppe.code_rubrique)
         JOIN paie_info_personnel pip2 ON TO_CHAR(pip.id) = TO_CHAR(pip2.id);


-- 22:16
create or replace view HSMOIS_CPL as
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


