
-- Liste periode de paie
create or replace view PERIODEPAIELIB as
SELECT
    p.id,
    p.mois,
    p.datedebut,
    p.datefin,
    p.idcategoriepaie,
    p.annee,
    p.etat,
    TO_CHAR(
            TO_DATE(TO_CHAR(p.mois, 'FM00'), 'MM'),
            'FMMonth',
            'NLS_DATE_LANGUAGE=FRENCH'
    ) AS moisLib,
    categ.VAL as categorieLib
FROM PERIODEPAIE p
         LEFT JOIN CATEGORIE_PAIE categ on categ.id = p.IDCATEGORIEPAIE;



create or replace view SOLDECONGE_PERS as
SELECT
    CAST(sum(nvl(m.PLUS,0)) AS NUMBER(30, 2)) AS plus ,
    CAST(sum(nvl(m.MOINS ,0)) AS NUMBER(30, 2)) AS moins ,
    CAST(sum(nvl(m.PLUS,0)) - sum(nvl(m.MOINS ,0)) AS NUMBER(30, 2)) AS solde ,
    lp.NOM ,
    lp.PRENOM ,
    lp.ID AS IDPERSONNEL
FROM MOUVEMENTABSENCE m
         LEFT JOIN LOG_PERSONNEL lp ON lp.ID = m.IDPERSONNEL
where m.IDSOURCE='TYP000004'
GROUP BY lp.NOM ,
         lp.PRENOM , lp.ID;


create view SOLDEPERMISSION_PERS as
SELECT
    pip.id as idPersonnel ,
    m.ANNEE ,
    CAST(SUM(NVL(m.MOINS,0)) AS NUMBER(30, 2)) AS permissionPris
FROM
    MOUVEMENTABSENCE m
        left join PAIE_INFO_PERSONNEL pip on pip.id = m.IDPERSONNEL
where m.IDSOURCE='TYP000006'
GROUP BY pip.id , m.ANNEE;


delete from detformu;
delete from PAIE_RUBRIQUE;

INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000130', 'HEURE SUPP 30% NI', 'Heure supp 30% NI', 221, null, null, '130', 'G', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 1, 2, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000150', 'HEURE SUPP 50% NI', 'Heure supp 50% NI', 224, null, null, '150', 'G', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 1, 2, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000150I', 'HEURE SUPP 50% I', 'Heure supp 50% I', 225, null, null, '151', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 2, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000130I', 'HEURE SUPP 30% I', 'Heure supp 30% I', 222, null, null, '131', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 2, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000255G', 'APPOINT GAIN', 'APPOINT GAIN', 10005, null, null, '160', 'G', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 1, 7, 2, 1, 1, '%', null, null, null, null, null, null, 8);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000228', 'INDEMNITE DE FONCTION', 'INDEMNITE DE FONCTION', 225, null, null, '111', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 2, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR000021', 'INDEMNITÃ‰S DIVERSES FIXES', 'INDEMNITÃ‰S DIVERSES FIXES', 210, null, null, '103', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 3, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR000061', 'ALLOCATION DE CONGE', 'ALLOCATION DE CONGE', 300, null, null, '104', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 6, 2, 1, 1, '%', null, null, null, null, null, null, 4);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PRUNIARD', 'net imposable arrondi', 'net imposable arondi', 8810, null, null, 'NIA', 'R', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 0, null, 2, 1, 1, '%', null, null, null, null, null, null, 13);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR000081', 'AUTRES INDEMNITES', 'GAUTRES', 220, null, null, '105', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 6, 2, 1, 1, '%', null, null, null, null, null, null, 5);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR000121', 'DIVERSES RETENUES', 'RRETENU', 9500, null, null, '202', 'R', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 1, null, 2, 1, 1, '%', null, null, null, null, null, null, 7);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR000141', 'IRSA', 'IRSA', 9300, null, null, '299', 'R', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 1, 14, 2, 1, 1, '%', null, null, null, null, null, null, 9);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR000181', 'ABATTEMENT', 'GABBT', 9000, null, null, '106', 'G', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 0, null, 2, 1, 1, '%', null, null, null, null, null, null, 8);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR000041', 'SALAIRE DE BASE', 'SBASE', 100, null, null, '101', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 1, 2, 1, 1, '%', null, null, null, null, null, null, 1);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR000001', 'PRIME', 'PRIME', 200, null, null, '102', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 5, 2, 1, 1, '%', null, null, null, null, null, null, 3);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR000101', 'CNAPS', 'CNAPS', 1000, null, null, '201', 'R', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 8, 2, 1, 1, '%', null, null, null, null, null, null, 6);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR000141NET', 'IRSA NET', 'IRSA NET', 9350, null, null, '300', 'R', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 10, 2, 1, 1, '%', null, null, null, null, null, null, 9);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PRU000I710', 'OSTIE', 'OSTIE', 1100, null, null, '205', 'R', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 9, 2, 1, 1, '%', null, null, null, null, null, null, 8);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PRUNI', 'net imposable', 'net imposable', 8800, null, null, 'NI', 'R', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 1, null, 2, 1, 1, '%', null, null, null, null, null, null, 13);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR000210A', 'NET A PAYER', 'NET A PAYER', 10000, null, null, '199', 'G', null, null, null, 'variable', null, null, 1, 1, null, null, null, null, 1, 18, 2, 1, 1, '%', null, null, null, null, null, null, 15);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000224', 'RAPPEL', 'RAPPEL', 100, null, null, '107', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 3, 2, 1, 1, '%', null, null, null, null, null, null, 1);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PRU0453', 'Avance exceptionnelle', 'Avance exceptionnelle', 9800, null, null, '810', 'R', null, null, 'I', 'variable', null, null, 0, 11, null, null, null, null, 1, 17, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PRU0447', 'Avance sur salaire', 'Avance sur salaire', 9800, null, null, '800', 'R', null, null, 'I', 'variable', null, null, 0, 11, null, null, null, null, 1, 16, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PRU01000', 'Solde de tout compte', 'Solde de tout compte', 150, null, null, '108', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, null, 2, 1, 1, '%', null, null, null, null, null, null, null);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000225', 'RETENUE SUR ABSENCE', 'RETENUE SUR ABSENCE', 9100, null, null, '203', 'R', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 1, 4, 2, 1, 1, '%', null, null, null, null, null, null, 8);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR000FRM', 'Frais mÃ©dicaux', 'Frais mÃ©dicaux', 1001, null, null, 'FRM', 'G', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 0, null, 2, 1, 1, '%', null, null, null, null, null, null, 6);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR000210Z', 'NET A PAYER ARRONDI', 'NET A PAYER ARRONDI', 11000, null, null, '219', 'G', null, null, null, 'variable', null, null, 1, 11, null, null, null, null, 1, 14, 2, 1, 0, '%', null, null, null, 0, null, 0.00, 15);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PRUSIS014', 'Total gain', 'Total gain', 500, null, null, 'SUMG', 'G', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 1, 7, 2, 1, 1, '%', null, null, null, null, null, null, 0);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR000042', 'ALLOCATION FAMILIALE', 'ALLOCATION FAMILIALE', 100, null, null, '102', 'G', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 1, 20, 2, 1, 1, '%', null, null, null, null, null, null, 1);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PRUSIS015', 'Total retenu', 'Total retenu', 9900, null, null, 'SUMR', 'R', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 1, null, 2, 1, 1, '%', null, null, null, null, null, null, 0);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000221', 'HEURE SUPP NUIT', 'Heure supp nuit', 221, null, null, '110', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 2, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000222', 'HEURE SUPP FERIE', 'Heure supp ferie', 222, null, null, '111', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 2, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000223', 'HEURE SUPP WEEK-END', 'Heure supp week-end', 223, null, null, '112', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 2, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000229', 'HEURE SUPP NORMAL', 'Heure supp normal', 221, null, null, '113', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 2, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000232', 'PREAVIS', 'PREAVIS', 221, null, null, '206', 'R', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 7, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000220', 'HEURE NORMAL', 'Heure normal', 220, null, null, '109', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 1, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000233', 'INDEMNITE DE PREAVIS', 'INDEMNITE DE PREAVIS', 221, null, null, '114', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 7, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000130A', 'Conge de maternite', 'Conge de maternite', 171, null, null, '171', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, null, 2, 1, 1, '%', null, null, null, null, null, null, 2);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PRO000ANC', 'ANCIENNETE', 'ANCIENNETE', 230, null, null, '900', 'G', null, null, 'I', 'variable', null, null, 0, 1, null, null, null, null, 1, 4, 2, 1, 1, '%', null, null, null, null, null, null, null);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR000081R', 'AUTRES RETENUES', 'AUTRES RETENUES', 230, null, null, '207', 'R', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 1, 13, 2, 1, 1, '%', null, null, null, null, null, null, 5);
INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN) VALUES ('PR0000255A', 'APPOINT RETENUE', 'APPOINT RETENUE', 231, null, null, '231', 'R', null, null, null, 'variable', null, null, 0, 1, null, null, null, null, 1, null, 2, 1, 1, '%', null, null, null, null, null, null, 8);


INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DET6_1', 0.00, -1.00, 'if(([299]-[106])<3000){3000}else{[299]-[106]}', 1.00, null, 'PR000141NET', '[NI]>0 ', -1, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DET_PREAVIS', 0.00, -1.00, '[pers::salaire_Base]/30*[pers::nbjpreavis]', 1.00, null, 'PR0000232', '1>0', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DETOSTI', 0.00, -1.00, 'Math.min (0.01*[++imposable==I..gain], [conf::CONF0001])', 1.00, null, 'PRU000I710', '1>0', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DET5', 600000.00, -1.00, 'Math.max(([NIA]-600000),0)*0.2', 1.00, null, 'PR000141', '[NI]>600000', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DETNI', 0.00, 1.00, 'Math.max([++imposable==I],0)', 1.00, null, 'PRUNI', '1>0', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DETNIARD', 0.00, 1.00, '[NI]-([NI]%100)', 1.00, null, 'PRUNIARD', '1>0', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DET2', 350000.00, 400000.00, 'Math.max((Math.min([NIA],400000)-350000),0)*0.05', 1.00, null, 'PR000141', '[NI]>350000', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DET3', 400000.00, 500000.00, 'Math.max((Math.min([NIA],500000)-400000),0)*0.1', 1.00, null, 'PR000141', '[NI]>400000', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DET4', 500000.00, 600000.00, 'Math.max((Math.min([NIA],600000)-500000),0)*0.15', 1.00, null, 'PR000141', '[NI]>500000', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DETNAP2', 0.00, -1.00, '[199]+[160]', 1.00, null, 'PR000210Z', '1>0', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DETSUMG', 0.00, -1.00, '[101]+[102]+[103]+[104]+[105]+[106]+[107]+[108]+[109]+[110]+[111]+[112]+[113]+[114]+[900]+[150]+[130]+[151]+[131]+[171]', 1.00, null, 'PRUSIS014', '1>0', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DETNAP3', 0.00, -1.00, '[SUMG]-[SUMR]', 1.00, null, 'PR000210A', '1>0', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DETFRAISM', 0.00, -1.00, '0.06*[++imposable==I..gain]', 1.00, null, 'PR000FRM', '1>0', -1, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DETNAP', 0.00, -1.00, 'Math.round(([NI]-[204]-[300])*10)/10', 1.00, null, 'PR000210A', '1>0', -1, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DETSUMR', 0.00, -1.00, '[201]+[202]+[203]+[205]+[206]+[207]+[230]+[231]+[300]+[800]+[810]+[170]', 1.00, null, 'PRUSIS015', '1>0', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DET6', 0.00, -1.00, 'Math.max(3000,[299]-[106])', 1.00, null, 'PR000141NET', '[NI]>0 ', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DETATM', 0.00, -1.00, 'Math.max([pers::nbenfant]*[conf::CONF0009],0)', 1.00, null, 'PR000181', '1>0 ', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DET_LIECNSIEMENT', 0.00, -1.00, 'Math.min ( ([pers::salaire_Base]/30)*10*[pers::anciennete] ,([pers::salaire_Base]*6) )', 1.00, null, 'PR0000233', '1>0', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DETCNAPS', 0.00, -1.00, '(Math.round(Math.min (0.01*[++imposable==I..gain], [conf::CONF0001])* 100.0)/100.0)*2', 1.00, null, 'PR000101', '1>0 && [pers::temporaire]==0', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DETSAL', 0.00, -1.00, '([pers::salaire_Base]*[pers::nbpro])/[pers::nbjmois]', 1.00, '--', 'PR000041', '1>0', -1, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DET1', 0.00, 350000.00, '3000', -1.00, null, 'PR000141', '[NI]<=350000', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DET_HN', 0.00, -1.00, '[pers::salaire_Base]', 1.00, null, 'PR000041', '1>0', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DET_HS_NORM', 0.00, -1.00, '[pers::salaire_Base]/[conf::CONF000252]*[pers::heuresupnormal]*1', 1.00, null, 'PR0000229', '1>0', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DET_HS_NUIT', 0.00, -1.00, '[pers::salaire_Base]/[conf::CONF000252]*[pers::heuresupnuit]*1.3', 1.00, null, 'PR0000221', '1>0', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DET_HS_FERIE', 0.00, -1.00, '[pers::salaire_Base]/[conf::CONF000252]*[pers::heuresupferie]*2', 1.00, null, 'PR0000222', '1>0', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DET_HS_WEEK', 0.00, -1.00, '[pers::salaire_Base]/[conf::CONF000252]*[pers::heuresupweekend]*2', 1.00, null, 'PR0000223', '1>0', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DET_CONGE2', 0.00, -1.00, '[pers::imposable12]/12/30*[pers::nbconge]', 1.00, '--', 'PR000061', '[pers::stc]>=1', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DETCNAPS2', 0.00, -1.00, 'Math.min (0.01*[++imposable==I..gain], [conf::CONF0001])', 1.00, null, 'PR000101', '1>0 && [pers::temporaire]==-1', 11, null);
INSERT INTO DETFORMU (ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION) VALUES ('DETNAP33', 0.00, -1.00, '100-([199]%100)', 1.00, null, 'PR0000255G', '1>0', 11, null);


-- update PAIE_INFO_PERSONNEL set etat=1;
-- update PAIE_INFO_PERSONNEL set etat=11 where id='PRS001059';

-- update PAIE_INFO_PERSONNEL set etat=11;

-- FICHE AVANCEMENT PERSONNEL
create or replace view PAIE_AVANCEMENT_LIBELLE4 as
SELECT pav.id,
       dt.val AS motif,
       dt.id AS idmotif,
       (lp.nom || ' ') || lp.prenom AS id_logpers,
       lpad(pip.matricule, 5, '0') AS matricule,
       pip.id AS idpers,
       pav.datedecision,
       pav.refdecision,
       pav.date_application,
       ld.val AS direction,
       ls.libelle AS service,
       pf.val AS idfonction,
       pav.ctg,
       pg.val AS idcategorie,
       pav.echelon,
       pav.classee,
       pav.indicegrade,
       pav.indice_fonctionnel,
       pav.statut,
       pav.vehiculee,
       pav.remarque,
       lp.sexe,
       pav.etat,
       pav.matricule_patron,
       pav.droit_hs,
       pav.indice_ct,
       pav.region,
       rg.val AS regionlib,
       CASE pav.vehiculee
           WHEN 0 THEN 'non'
           WHEN 1 THEN 'oui'
           ELSE NULL
           END AS vehiculee_str,
       pav.code_banque,
       pf.desce AS fonctionLib
FROM paie_avancement pav
         LEFT JOIN dec_decision_type dt ON dt.id = pav.motif
         LEFT JOIN log_personnel lp ON lp.id = pav.id_logpers
         LEFT JOIN paie_info_personnel pip ON pip.id = pav.id_logpers
         LEFT JOIN log_direction ld ON ld.id = pav.direction
         LEFT JOIN log_service ls ON ls.id = pav.service
         LEFT JOIN paie_fonction pf ON pf.id = pav.idfonction
         LEFT JOIN region rg ON rg.id = pav.region
         LEFT JOIN paie_categorie pg ON pg.id = pav.idcategorie;


-- SAISIE AVANCEMENT
CREATE OR REPLACE FUNCTION getSeqPaie_avancement
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
SELECT seqpaie_avancement.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;


delete from HEURESUPFABRICATION;
delete from CHARGEPERSONNELTEMP;

-- update PAIE_INFO_PERSONNEL set etat=1;
--
-- update PAIE_INFO_PERSONNEL set etat=11 where id='PRS001055';


create OR REPLACE view LOG_PERSONNEL_FIN as
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
       s.code_service AS service,
       s.code_dr,
       TO_CHAR(paie.matricule) AS matricule,
       paie.idcategorie,
       paie.ctg,
       paie.indicegrade,
       paie.indice_fonctionnel,
       paie.statut,
       c.taux AS categorieval,
       '''' AS ctgval,
       paie.numero_cnaps,
       paie.numero_ostie,
       CASE
           WHEN paie.temporaire = -1 THEN 'Temporaire'
           WHEN paie.temporaire = 0 THEN 'Permanent'
           WHEN paie.temporaire = 1 THEN 'Cadre'
           ELSE NULL
           END AS temporaire,
       NVL(dr.conge, 0) AS droit,
       NVL(cg.conge, 0) AS prie,
       NVL(dr.conge, 0) - NVL(cg.conge, 0) AS resteconge,
       paie.etat,
       l.id AS idpersonnel,
       l.direction AS iddirection,
       dp.val as departementLib,
       paie.IDDEPARTEMENT
FROM log_personnel l
         LEFT JOIN log_service s ON l.service = s.id
         LEFT JOIN paie_info_personnel paie ON paie.id = l.id
         LEFT JOIN sexe sex ON l.sexe = sex.id
         LEFT JOIN log_direction d ON d.id = l.direction
         LEFT JOIN paie_categorie c ON c.id = paie.idcategorie
         LEFT JOIN droitdeconge_parpersonne dr ON dr.idpersonnel = l.id
         LEFT JOIN congeprisgroupbypers cg ON cg.idpersonnel = l.id
         LEFT JOIN DEPARTEMENT dp ON dp.id = paie.IDDEPARTEMENT;


create OR REPLACE view LOG_PERSONNEL_GRAPHE as
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
       s.code_service AS service,
       s.code_dr,
       TO_CHAR(paie.matricule) AS matricule,
       paie.IDCATEGORIE_PAIE as idCategorie,
       ctp.val as idCategorieLib,
       paie.indicegrade,
       paie.indice_fonctionnel,
       paie.statut,
       c.taux AS categorieval,
       '''' AS ctgval,
       paie.numero_cnaps,
       paie.numero_ostie,
       CASE
           WHEN paie.temporaire = -1 THEN 'Temporaire'
           WHEN paie.temporaire = 0 THEN 'Permanent'
           WHEN paie.temporaire = 1 THEN 'Cadre'
           ELSE NULL
           END AS temporaire,
       NVL(dr.conge, 0) AS droit,
       NVL(cg.conge, 0) AS prie,
       NVL(dr.conge, 0) - NVL(cg.conge, 0) AS resteconge,
       paie.etat,
       l.id AS idpersonnel,
       l.direction AS iddirection,
       dp.val as departementLib,
       paie.IDDEPARTEMENT
FROM log_personnel l
         LEFT JOIN log_service s ON l.service = s.id
         LEFT JOIN paie_info_personnel paie ON paie.id = l.id
         LEFT JOIN sexe sex ON l.sexe = sex.id
         LEFT JOIN log_direction d ON d.id = l.direction
         LEFT JOIN paie_categorie c ON c.id = paie.idcategorie
         LEFT JOIN droitdeconge_parpersonne dr ON dr.idpersonnel = l.id
         LEFT JOIN congeprisgroupbypers cg ON cg.idpersonnel = l.id
         LEFT JOIN DEPARTEMENT dp ON dp.id = paie.IDDEPARTEMENT
         LEFT JOIN CATEGORIE_PAIE ctp ON ctp.id = paie.IDCATEGORIE_PAIE;

delete from PAIE_PERSONNEL_ELEMENTPAIE;
--CALCUL HS
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

CREATE OR REPLACE VIEW HS_GROUPE AS
SELECT *
FROM (
         SELECT
             p.id,
             p.matricule,
             p.id_code_rubrique,
             p.nomRubrique,
             p.date_debut,
             p.date_fin,
             p.gain,
             p.retenue,
             p.remarque,
             p.nomPersonnel,
             p.etat,
             p.id_objet,
             p.iduser,
             p.moisregularisation,
             p.anneeregularisation,
             p.idcategorie_qualification,
             p.idfonction,
             p.pourcentage,
             p.etatLib
         FROM PAIEPERS_ELP_CPL p
     )
         PIVOT (
                SUM(gain)
    FOR id_code_rubrique IN (
        'PR0000130'  AS "HS_30_NI",
        'PR0000130I' AS "HS_30_I",
        'PR0000150'  AS "HS_50_NI",
        'PR0000150I' AS "HS_50_I"
        )
        ) ORDER BY matricule ASC;

-- GRAPHE : ajout departement
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
    h.MONTANT,
    r.IDQUALIFICATION,
    NVL(h.montantJF, 0) as montantJF,
    NVL(h.montantHD, 0) as montantHD,
    NVL(h.montantIF,0) as montantIF,
    NVL(h.montantMN, 0) as montantMN,
    NVL(h.MONTANTHN, 0) as montantHN,
    p.IDDEPARTEMENT,
    d.val as departementLib
FROM HEURESUPFABRICATION h
         LEFT JOIN RESSOURCEPARFABRICATIONCOMPLET r ON r.id = h.IDRESSPARFAB
         LEFT JOIN PAIE_INFO_PERSONNEL p ON p.id = r.idRessource
         LEFT JOIN CATEGORIE_QUALIFICATION c
                   ON c.IDQUALIFICATION = r.IDQUALIFICATION
                       AND c.IDCATEGORIE = r.IDCATEGORIE
                       AND (
                          (c.REMARQUE IS NULL)
                              OR (c.REMARQUE = r.IDRESSOURCE)
                          ) and c.etat = 1
         LEFT JOIN LOG_PERSONNEL pm ON pm.id = r.IDRESSOURCE
         LEFT JOIN FABRICATION fab ON fab.ID = h.IDFABRICATION
         LEFT JOIN DEPARTEMENT d on d.id = p.IDDEPARTEMENT ;



-- GRAPH PER DAY
CREATE OR REPLACE VIEW SUM_HS_DAY AS
SELECT
    dateFabrication AS jour,
    SUM(HS) AS avg_hs_per_day,
    IDDEPARTEMENT,
    departementLib
FROM HEURESUPFABRICATION_CPL
GROUP BY dateFabrication, IDDEPARTEMENT, departementLib
ORDER BY dateFabrication;

-- PER MONTH
CREATE OR REPLACE VIEW SUM_HS_MONTH AS
SELECT
    EXTRACT(YEAR FROM dateFabrication) AS annee,
    EXTRACT(MONTH FROM dateFabrication) AS mois,
    SUM(HS) AS avg_hs_per_month,
    IDDEPARTEMENT,
    departementLib
FROM HEURESUPFABRICATION_CPL
GROUP BY
    EXTRACT(YEAR FROM dateFabrication),
    EXTRACT(MONTH FROM dateFabrication),
    IDDEPARTEMENT,
    departementLib
ORDER BY annee, mois;

-- PER YEAR
create or replace view SUM_HS_YEAR AS
SELECT
    EXTRACT(YEAR FROM dateFabrication) AS annee,
    SUM(HS) AS avg_hs_per_year,
    IDDEPARTEMENT,
    departementLib
FROM HEURESUPFABRICATION_CPL
GROUP BY EXTRACT(YEAR FROM dateFabrication),IDDEPARTEMENT,
         departementLib
ORDER BY annee;



create or replace view LOG_PERSONNEL_AVECCONGE as
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
       paie.matricule AS matricule,
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
         LEFT JOIN departement dp ON paie.idDepartement = dp.id
order by paie.MATRICULE ASC;



create or replace view LOG_PERSONNEL_FIN_CONGE as
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
       l.direction AS iddirection
FROM log_personnel l
         LEFT JOIN log_service s ON l.service = s.id
         LEFT JOIN paie_info_personnel paie ON paie.id = l.id
         LEFT JOIN sexe sex ON l.sexe = sex.id
         LEFT JOIN log_direction d ON d.id = l.direction
         LEFT JOIN paie_categorie c ON c.id = paie.idcategorie
         LEFT JOIN SOLDECONGEPRIS_PERS sp ON l.id = sp.id
         LEFT JOIN SOLDECONGE_PERS sc ON l.id = sc.idPersonnel
order by paie.MATRICULE ASC;


