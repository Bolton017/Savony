-- delete from RESSOURCEPARFABRICATION;
-- delete from HEURESUPFABRICATION;

UPDATE PAIE_INFO_PERSONNEL
SET MATRICULE = SUBSTR(MATRICULE, 2)
WHERE MATRICULE LIKE '0%';

-- UPDATE DATA
UPDATE SITUATION_MATRIMONIALE SET ID = 'SIT02', VAL = 'Marié', DESCE = 'Marié';
UPDATE SITUATION_MATRIMONIALE SET ID = 'SIT01', VAL = 'Célibataire', DESCE = 'Célibataire';
UPDATE SITUATION_MATRIMONIALE SET ID = 'SIT03', VAL = 'Divorcé', DESCE = 'Divorcé';
UPDATE SITUATION_MATRIMONIALE SET ID = 'SIT04', VAL = 'Veuf/Veuve', DESCE = 'Veuf/Veuve';


UPDATE MENUDYNAMIQUE SET LIBELLE = 'Liste des hs calcul&eacute;s' where ID = 'MENDYN1765437929624908';

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
    categ.VAL
FROM PERIODEPAIE p
         LEFT JOIN CATEGORIE_PAIE categ on categ.id = p.IDCATEGORIEPAIE;


create or replace view PAIE_EDITIONMOISANNEE_LIB_3 as
SELECT pae.id,
       (log.nom || ' ') || log.prenom AS idpersonnel,
       pae.mois,
       pae.annee,
       pae.gain,
       pae.retenue,
       u.nomuser AS iduser,
       dir.val AS iddirection,
       pae.daty,
       TO_CHAR(

               TO_DATE(TO_CHAR(pae.mois, 'FM00'), 'MM'),

               'FMMonth',

               'NLS_DATE_LANGUAGE=FRENCH'

       ) AS mois_string,
       pae.etat,
       pae.idperiodepaie,
       pp.datedebut,
       pp.datefin,
       CAST(ROUND(net.montant, 0) AS NUMBER(15, 0)) AS montant,
       cps.val AS categorie

FROM paie_editionmoisannee pae
         LEFT JOIN log_personnel log ON log.id_pers = pae.idpersonnel
         LEFT JOIN log_direction dir ON dir.id = pae.iddirection
         LEFT JOIN utilisateur u ON u.refuser = pae.iduser
         LEFT JOIN net_moisannee net ON pae.mois = net.mois AND pae.annee = net.annee
         LEFT JOIN periodepaie pp ON pp.id = pae.id
         LEFT JOIN categorie_paie_salaire cps ON cps.id = pp.idcategoriepaie
ORDER BY pae.annee DESC, pae.mois DESC;


UPDATE PAIE_INFO_PERSONNEL SET ETAT=11 WHERE ID IN ('PRS000670', 'PRS000739', 'PRS000742',
                                                    'PRS000743', 'PRS000750', 'PRS000754',
                                                    'PRS000755', 'PRS000757', 'PRS000758',
                                                    'PRS000760', 'PRS000762', 'PRS000764',
                                                    'PRS000777', 'PRS000785', 'PRS000795',
                                                    'PRS000799', 'PRS000800', 'PRS000801')



create OR REPLACE view HEURESUPFABRICATION_CPL_VISEE as
SELECT hs."ID",
       hs."IDRESSPARFAB",
       hs."HEURENORMALE",
       hs."HS",
       hs."MN",
       hs."JF",
       hs."HD",
       hs."IF",
       hs."ETAT",
       hs."REMARQUE",
       hs."IDPERSONNE",
       hs."IDFABRICATION",
       hs."DATEFABRICATION",
       hs."ETATLIB",
       hs."IDPERSONNELIB",
       hs."MATRICULE",
       CAST(ROUND(hs."TAUXHORAIRE",2) as number(30, 2)) as th,
       hs."TAUXHORAIREEFFECTIVE",
       hs."TEMPORAIRE",
       ROUND(hs."MONTANT",2) as valeurHS,
       hs."IDQUALIFICATION",
       hs."MONTANTJF" as valeurJF,
       hs."MONTANTHD" as valeurHD,
       hs."MONTANTIF" as valeurIF,
       hs."MONTANTMN" as valeurMN,
       ROUND(montantMN + montantJF + montantHD + montantIF + MONTANT, 2) as montantTotal

FROM heureSupFabrication_cpl hs
WHERE etat = 11;

-- SCRIPT 10/12
UPDATE DETFORMU
SET MIN=0, MAX=-1, FORMULE='Math.min (0.01*[++imposable==I..gain], [conf::CONF0001])', UNITE=1, REMARQUE=NULL, MERE='PRU000I710', FORMULECONDITION='1>0', ETAT=11, CREATION=NULL
WHERE ID='DETOSTI';

SELECT
    p.*,
    'PEM000007' AS mere
FROM
    PAIEINFOPERSELTPAIECOMPLET2 p
WHERE

    (
        p.date_debut <= TO_DATE('2025-11-16', 'YYYY/MM/DD')
            AND
        (p.date_fin >= TO_DATE('2025-10-20', 'YYYY/MM/DD') )
        )
ORDER BY
    p.IDPERSONNEL ASC

    INSERT INTO DETFORMU
(ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION)
VALUES('DETCNAPS2', 0, -1, 'Math.min (0.01*[++imposable==I..gain], [conf::CONF0001])', 1, NULL, 'PR000101', '1>0 && [pers::temporaire]==-1', 11, NULL);


-- p.rang ASC,
-- 	p.imposable ASC,
-- 	p.typerubrique ASC



	INSERT INTO PAIE_RUBRIQUE
(ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN)
VALUES('PRO000ANC', 'ANCIENNETE', 'ANCIENNETE', 230, NULL, NULL, '900', 'G', NULL, NULL, 'I', 'variable', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, 1, 4, 2, 1, 1, '%', NULL, NULL, NULL, NULL, NULL, NULL, NULL);


INSERT INTO PAIE_PERSONNEL_ELEMENTPAIE
(ID, CODE_RUBRIQUE, DATE_DEBUT, DATE_FIN, GAIN, RETENUE, REMARQUE, IDPERSONNEL, ETAT, ID_OBJET, IDUSER, MOISREGULARISATION, ANNEEREGULARISATION, IDCATEGORIE_QUALIFICATION, IDFONCTION, POURCENTAGE, QUANTITE, UNITE)
VALUES('PELT000000', 'PR000081', TIMESTAMP '2025-10-20 00:00:00.000000', TIMESTAMP '2025-11-16 00:00:00.000000', 485303.98, 0, NULL, 'PRS000670', 11, NULL, '1060', '11', '2025', NULL, NULL, 0, 0, NULL);

INSERT INTO PAIE_PERSONNEL_ELEMENTPAIE
(ID, CODE_RUBRIQUE, DATE_DEBUT, DATE_FIN, GAIN, RETENUE, REMARQUE, IDPERSONNEL, ETAT, ID_OBJET, IDUSER, MOISREGULARISATION, ANNEEREGULARISATION, IDCATEGORIE_QUALIFICATION, IDFONCTION, POURCENTAGE, QUANTITE, UNITE)
VALUES('PELT0000002', 'PR000021', TIMESTAMP '2025-10-20 00:00:00.000000', TIMESTAMP '2025-11-16 00:00:00.000000', 3400, 0, NULL, 'PRS000670', 11, NULL, '1060', '11', '2025', NULL, NULL, 0, 0, NULL);


INSERT INTO PAIE_PERSONNEL_ELEMENTPAIE
(ID, CODE_RUBRIQUE, DATE_DEBUT, DATE_FIN, GAIN, RETENUE, REMARQUE, IDPERSONNEL, ETAT, ID_OBJET, IDUSER, MOISREGULARISATION, ANNEEREGULARISATION, IDCATEGORIE_QUALIFICATION, IDFONCTION, POURCENTAGE, QUANTITE, UNITE)
VALUES('PELT0000003', 'PR000081R', TIMESTAMP '2025-10-20 00:00:00.000000', TIMESTAMP '2025-11-16 00:00:00.000000', 0, 151260.47, NULL, 'PRS000670', 11, NULL, '1060', '11', '2025', NULL, NULL, 0, 0, NULL);



INSERT INTO PAIE_RUBRIQUE
(ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN)
VALUES('PR000081R', 'AUTRES RETENUES', 'AUTRES RETENUES', 230, NULL, NULL, '207', 'R', NULL, NULL, NULL, 'variable', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, 1, 13, 2, 1, 1, '%', NULL, NULL, NULL, NULL, NULL, NULL, 5);


INSERT INTO PAIE_RUBRIQUE
(ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN)
VALUES('PR0000255A', 'APPOINT RETENUE', 'APPOINT RETENUE', 231, NULL, NULL, '231', 'R', NULL, NULL, NULL, 'variable', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, 1, 13, 2, 1, 1, '%', NULL, NULL, NULL, NULL, NULL, NULL, 8);


INSERT INTO PAIE_PERSONNEL_ELEMENTPAIE
(ID, CODE_RUBRIQUE, DATE_DEBUT, DATE_FIN, GAIN, RETENUE, REMARQUE, IDPERSONNEL, ETAT, ID_OBJET, IDUSER, MOISREGULARISATION, ANNEEREGULARISATION, IDCATEGORIE_QUALIFICATION, IDFONCTION, POURCENTAGE, QUANTITE, UNITE)
VALUES('PELT0000003_1', 'PR0000255A', TIMESTAMP '2025-10-20 00:00:00.000000', TIMESTAMP '2025-11-16 00:00:00.000000', 0, 80.47, NULL, 'PRS000670', 11, NULL, '1060', '11', '2025', NULL, NULL, 0, 0, NULL);


CREATE SEQUENCE seq_historiquedemande
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999
    NOCYCLE
    CACHE 20;



CREATE OR REPLACE FUNCTION get_seq_historiquedemande
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seq_historiquedemande.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;



INSERT INTO PAIE_RUBRIQUE
(ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE, AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER, REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE, QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN)
VALUES('PR0000130A', 'Conge de maternite', 'Conge de maternite', 171, NULL, NULL, '171', 'G', NULL, NULL, 'I', 'variable', NULL, NULL, 0, 1, NULL, NULL, NULL, NULL, 1,NULL, 2, 1, 1, '%', NULL, NULL, NULL, NULL, NULL, NULL, 2);

UPDATE DETFORMU
SET  FORMULE='[101]+[102]+[103]+[104]+[105]+[106]+[107]+[108]+[109]+[110]+[111]+[112]+[113]+[114]+[900]+[150]+[130]+[151]+[131]+[171]'
WHERE ID='DETSUMG';



UPDATE MENUDYNAMIQUE SET LIBELLE = 'Analyse paie addition', ICONE = 'stacked_line_chart', HREF = 'module.jsp?but=paie/editions/paieedition-analyse2.jsp', RANG = 2, NIVEAU = 4, ID_PERE = 'MD00000000101' where ID = 'MENDYN002';
UPDATE MENUDYNAMIQUE SET LIBELLE = 'Analyse addition', ICONE = 'insights', HREF = 'module.jsp?but=paie/editions/paieedition-analyse3.jsp', RANG = 1, NIVEAU = 4, ID_PERE = 'MD00000000101' where ID = 'MENDYN003';



-- auto-generated definition
create or replace view PAIE_EDITION_LIBCOMPLET as
SELECT pe.id,
       pe.idpersonnel,
       pe.idelementpaie,
       pe.mois,
       pe.annee,
       pe.gain,
       pe.retenue,
       pe.datedebut,
       pe.datefin,
       pe.idedition,
       pe.remarque,
       (lp.nom || ' ') || lp.prenom AS idpersonnellib,
       (pr.code || '-') || pr.val AS idelementpaielib,
       lp.matricule,
       pr.code AS coderubrique,
       TO_CHAR(
               TO_DATE(TO_CHAR(pe.mois, 'FM00'), 'MM'),
               'FMMonth',
               'NLS_DATE_LANGUAGE=FRENCH'
       ) AS moisLib
FROM paie_edition pe
         LEFT JOIN log_personnel_infocomplet lp ON lp.id = pe.idpersonnel
         LEFT JOIN paie_rubrique pr ON pr.id = pe.idelementpaie
         LEFT JOIN paie_editionmoisannee p ON pe.idedition = p.id;

create view PERSONNELENFANT_CPL as
SELECT
    pers."ID",
    pers."IDPERSONNEL",
    log.NOM || ' ' || log.PRENOM AS PERSONNELLIB,
    pers.NOM  AS ELEVELIB,
    pers.DATENAISSANCE AS DATENAISSANCE,
    FLOOR(MONTHS_BETWEEN(SYSDATE, pers.DATENAISSANCE) / 12) AS AGE
FROM ENFANTPERSONNEL pers
         LEFT JOIN LOG_PERSONNEL log       ON log.ID = pers.IDPERSONNEL;



create or replace view PAIEPERS_ENFANTCPL as
SELECT idpersonnel, COUNT(*) AS nbenfant
FROM PERSONNELENFANT_CPL
WHERE age < 21
GROUP BY idpersonnel;



create or replace view PAIE_INFO_PERSONNELDIRECT as
SELECT p.id,
       l.nationalite,
       p.datesaisie,
       p.matricule,
       p.lieu_naissance_commune,
       p.lieu_delivrance_cin,
       p.situation_matrimonial,
       p.initiale,
       p.cturgence_nom_prenom,
       p.cturgence_telephone1,
       p.cturgence_telephone2,
       p.cturgence_telephone3,
       p.idconjoint,
       p.code_agence_banque,
       p.banque_numero_compte,
       p.banque_compte_cle,
       p.dateembauche,
       p.idfonction,
       p.idcategorie,
       p.mode_paiement,
       p.classee,
       p.indicegrade,
       p.indice_fonctionnel,
       p.matricule_patron,
       p.statut,
       p.droit_hs,
       p.vehiculee,
       p.echelon,
       p.etat,
       p.ctg,
       p.iduser,
       p.indice_ct,
       p.datepromotion,
       p.numero_cnaps,
       p.numero_ostie,
       p.temporaire,
       p.n_embauche,
       p.date_depart,
       p.n_depart,
       nvl(pe.nbenfant,0) AS nbenfant,
       p.heurejournalier,
       p.heurehebdomadaire,
       p.heuremensuel,
       l.direction,
       l.service,
       p.periode_essai,
       l.sexe,
       l.date_naissance,
       p.idcategorie_paie,
       p.idqualification,
       CAST(COALESCE(pips.montant, 0) AS NUMBER(30,2)) AS salaire_base
FROM paie_info_personnel p
         LEFT JOIN log_personnel l ON l.id = p.id
         LEFT JOIN paie_info_personnel_sb pips ON l.id = p.id AND p.id = pips.id
         LEFT JOIN PAIEPERS_ENFANTCPL pe ON pe.idpersonnel = p.id;



-- auto-generated definition
create or replace view EMPLOYE_COMPLET as
SELECT logp.id,
       logp.nom,
       logp.prenom,
       logp.id_pers,
       paie.initiale,
       paie.matricule,
       logp.date_naissance,
       paie.lieu_naissance_commune,
       logp.sexe,
       logp.numero_cin,
       logp.date_cin,
       logp.date_dupl_cin,
       paie.lieu_delivrance_cin,
       logp.adresse,
       logp.fokotany,
       logp.nationalite,
       logp.acte_naissance,
       paie.situation_matrimonial,
       paie.idconjoint,
       logp.direction,
       logp.service,
       paie.idfonction,
       paie.ctg,
       paie.idcategorie,
       paie.classee,
       paie.indicegrade,
       paie.indice_fonctionnel,
       paie.matricule_patron,
       paie.statut,
       paie.mode_paiement,
       paie.code_agence_banque,
       paie.banque_numero_compte,
       paie.banque_compte_cle,
       logp.permis_conduire,
       logp.remarque,
       logp.chemin_permis,
       paie.cturgence_nom_prenom,
       paie.cturgence_telephone1,
       paie.cturgence_telephone2,
       paie.cturgence_telephone3,
       paie.dateembauche,
       paie.datesaisie,
       serv.code_dr,
       trs.val AS banque_code,
       paie.echelon,
       paie.etat,
       paie.vehiculee,
       tab.date_dernierpromo,
       paie.droit_hs,
       paie.heurejournalier,
       paie.heurehebdomadaire,
       paie.heuremensuel,
       paie.numero_cnaps,
       paie.numero_ostie,
       paie.temporaire,
       paie.nbenfant,
       paie.indesirable,
       paie.duree,
       paie.telephone,
       paie.mail,
       paie.idcategorie_paie,
       paie.idqualification,
       paie.discipline,
       paie.formation,
       paie.anneeexperience,
       paie.personnel_etat,
       paie.debutcontrat,
       paie.fincontrat,
       logp.refuser,
       logp.idhierarchie AS idetathierarchie,
       et.etatvisa,
       et.etatannule,
       paie.typecontrat,
       logp.cheminImage,
       paie.code_postal,
       paie.IDDEPARTEMENT
FROM log_personnel logp
         LEFT JOIN ( SELECT paie_avancement.id_logpers,
                            max(paie_avancement.datedecision) AS date_dernierpromo
                     FROM paie_avancement
                     GROUP BY paie_avancement.id_logpers) tab ON logp.id = tab.id_logpers
         LEFT JOIN paie_info_personnel paie ON logp.id = paie.id
         LEFT JOIN log_service serv ON serv.id = logp.service
         LEFT JOIN trs_banques_agences trs ON paie.code_agence_banque = trs.id
         LEFT JOIN categorie_paie cp ON cp.id = paie.idcategorie_paie
         LEFT JOIN qualification_paie qp ON qp.id = paie.idqualification
         LEFT JOIN categorie_qualification cq ON cq.idcategorie = paie.idcategorie_paie AND cq.idqualification = paie.idqualification AND cq.REMARQUE = logp.id
         LEFT JOIN etathierarchie et ON et.id = logp.idhierarchie;



INSERT INTO PAIE_RUBRIQUE (ID, VAL, DESCE, RANG, REMARQUE, COMPTEPCG, CODE, TYPERUBRIQUE, BCS, BG, IMPOSABLE, NATURE,
                           AVANTAGE, FORMULE, ISINFINI, ETAT, CPT_GEN_DB, CPT_GEN_CR, CPT_ANA_DB, CPT_ANA_CR, AFFICHER,
                           REGROUPEMENT, ARRONDI, INSERTED, SOMMABLE, BENEFICIAIRE, REMARQUEFORMULE, UNITEFORMULE,
                           QTEFORMULE, MAJORATION, QTE, PU, RANGBULLETIN)
VALUES ('PR0000228', 'INDEMNITE DE FONCTION', 'INDEMNITE DE FONCTION', 225, null, null, '111', 'G', null, null, 'I', 'variable',
        null, null, 0, 1, null, null, null, null, 1, 2, 2, 1, 1, '%', null, null, null, null, null, null, 2);
