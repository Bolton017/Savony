-- RECTIF DETFORMU AVEC APPOINT
--INSERT rubrique Appoint indemnites
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN)
VALUES('PR0000921', 'Appoint indemnites', 'Appoint indemnites', 250, NULL, NULL, '250', 'G', NULL, NULL, NULL, 'variable', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, 1, NULL, 2, 0, 1, '%', NULL, NULL, NULL, NULL, NULL, NULL, 2);


-- Insert formule Appoint indemnités diverse
INSERT INTO DETFORMU
(ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION)
VALUES('DET22', null, null, '[210]-([210]% 100)', 1, NULL, 'PR0000921', '1>0', 11, NULL);

-- Update formule total imposable
UPDATE
    DETFORMU
SET
    MIN = 0,
    MAX = 1,
    FORMULE = 'Math.max([++imposable==I],0)-[250]',
    UNITE = 1,
    REMARQUE = NULL,
    MERE = 'PRUNI',
    FORMULECONDITION = '1>0',
    ETAT = 11,
    CREATION = NULL
WHERE
    ID = 'DETNI';

UPDATE DETFORMU
SET MIN              = 0.00,
    MAX              = -1.00,
    FORMULE          = 'Math.min (0.02*[++imposable==I..gain], [conf::CONF0001])',
    UNITE            = 1.00,
    REMARQUE         = null,
    MERE             = 'PR000101',
    FORMULECONDITION = '[pers::temporaire]!=-1',
    ETAT             = 11,
    CREATION         = null
WHERE ID = 'DETCNAPS';


INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION)
VALUES ('DETCNAPS_TEMP', 0.00, -1.00, 'Math.min (0.01*[++imposable==I..gain], [conf::CONF0001])', 1.00, null, 'PR000101',
        '[pers::temporaire]==-1', 11, null);


SELECT * FROM PAIE_INFO_PERSONNEL WHERE MATRICULE='0670';

update PAIE_INFO_PERSONNEL set etat=1 where MATRICULE!='0670';

UPDATE DETFORMU
SET MIN              = 0.00,
    MAX              = -1.00,
    FORMULE          = 'Math.min (0.01*[NI], [conf::CONF0001])',
    UNITE            = 1.00,
    REMARQUE         = null,
    MERE             = 'PR000101',
    FORMULECONDITION = '[pers::temporaire]==-1',
    ETAT             = 11,
    CREATION         = null
WHERE ID = 'DETCNAPS_TEMP';

UPDATE DETFORMU
SET MIN              = 0.00,
    MAX              = -1.00,
    FORMULE          = 'Math.min (0.02*[NI], [conf::CONF0001])',
    UNITE            = 1.00,
    REMARQUE         = null,
    MERE             = 'PR000101',
    FORMULECONDITION = '[pers::temporaire]!=-1',
    ETAT             = 11,
    CREATION         = null
WHERE ID = 'DETCNAPS';

UPDATE DETFORMU
SET MIN              = 0.00,
    MAX              = -1.00,
    FORMULE          = 'Math.min (0.01*[NI], [conf::CONF0001])',
    UNITE            = 1.00,
    REMARQUE         = null,
    MERE             = 'PRU000I710',
    FORMULECONDITION = '1>0',
    ETAT             = 11,
    CREATION         = null
WHERE ID = 'DETOSTI';

UPDATE DETFORMU
SET MIN              = null,
    MAX              = null,
    FORMULE          = '[105]%100',
    UNITE            = 1.00,
    REMARQUE         = null,
    MERE             = 'PR0000921',
    FORMULECONDITION = '1>0',
    ETAT             = 11,
    CREATION         = null
WHERE ID = 'DET22';
