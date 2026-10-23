SELECT
    c2.IDPERSONNEL,
    c2.MATRICULE,
    c2.PERSONNEL,
    c2.NUMERO_CNAPS,
    c2.DIRECTION,
    c2.ANNEE,
    c2.MOIS1,
    c2.CNAPS_TRAVAILLEUR1,
    c2.CNAPS_EMPLOYEUR1,
    -- Total heure pour mois = 4
    NVL(SUM(CASE WHEN p.MOIS = 4 THEN
                     NVL(p.HEURENORMAL, 0) + NVL(p.HEURESUPNUIT, 0) + NVL(p.HEURESUPFERIE, 0) +
                     NVL(p.HEURESUPNORMAL, 0) + NVL(p.HEURESUPWEEKEND, 0) + NVL(p.ABSENCE, 0)
                 ELSE 0 END), 0) AS total_heure_mois_1,

    c2.MOIS2,
    c2.CNAPS_TRAVAILLEUR2,
    c2.CNAPS_EMPLOYEUR2,

    -- Total heure pour mois = 5
    NVL(SUM(CASE WHEN p.MOIS = 5 THEN
                     NVL(p.HEURENORMAL, 0) + NVL(p.HEURESUPNUIT, 0) + NVL(p.HEURESUPFERIE, 0) +
                     NVL(p.HEURESUPNORMAL, 0) + NVL(p.HEURESUPWEEKEND, 0) + NVL(p.ABSENCE, 0)
                 ELSE 0 END), 0) AS total_heure_mois_2,

    c2.MOIS3,
    c2.CNAPS_TRAVAILLEUR3,
    c2.CNAPS_EMPLOYEUR3,

    -- Total heure pour mois = 6
    NVL(SUM(CASE WHEN p.MOIS = 6 THEN
                     NVL(p.HEURENORMAL, 0) + NVL(p.HEURESUPNUIT, 0) + NVL(p.HEURESUPFERIE, 0) +
                     NVL(p.HEURESUPNORMAL, 0) + NVL(p.HEURESUPWEEKEND, 0) + NVL(p.ABSENCE, 0)
                 ELSE 0 END), 0) AS total_heure_mois_3,

    pip.DATEEMBAUCHE AS dateembauche,
    pip.DATE_DEPART AS datedebauche

FROM CNAPS_T2 c2
         LEFT JOIN PAIE_INFO_PERSONNEL pip ON pip.ID = c2.IDPERSONNEL
         LEFT JOIN POINTAGE p ON p.IDPERSONNEL = c2.IDPERSONNEL AND p.ANNEE = c2.ANNEE

GROUP BY
    c2.IDPERSONNEL,
    c2.MATRICULE,
    c2.PERSONNEL,
    c2.NUMERO_CNAPS,
    c2.DIRECTION,
    c2.ANNEE,
    c2.MOIS1,
    c2.CNAPS_TRAVAILLEUR1,
    c2.CNAPS_EMPLOYEUR1,
    c2.MOIS2,
    c2.CNAPS_TRAVAILLEUR2,
    c2.CNAPS_EMPLOYEUR2,
    c2.MOIS3,
    c2.CNAPS_TRAVAILLEUR3,
    c2.CNAPS_EMPLOYEUR3,
    pip.DATEEMBAUCHE,
    pip.DATE_DEPART;



SELECT * FROM LOG_SERVICE ls

CREATE OR REPLACE VIEW LOG_SERVICE_LIB AS
SELECT
    ls.ID ,
    ls.CODE_DR ,
    ls.DR_RATTACHE ,
    ls.LIBELLE ,
    ls.CODE_SERVICE ,
    ld.val AS libelleDirection

FROM LOG_SERVICE ls
         LEFT JOIN LOG_DIRECTION ld ON ld.id = ls.DR_RATTACHE


UPDATE ASYNCRH.USERMENU
SET REFUSER='', IDMENU='MNDN000000001', IDROLE=NULL, CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=NULL
WHERE ID='USRMEN06';

UPDATE ASYNCRH.USERMENU
SET REFUSER='', IDMENU='ELM00T3004001', IDROLE=NULL, CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=NULL
WHERE ID='USRMEN3004001';

UPDATE ASYNCRH.USERMENU
SET REFUSER='', IDMENU='MNDN000000002', IDROLE=NULL, CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=NULL
WHERE ID='USRMEN07';

UPDATE ASYNCRH.USERMENU
SET REFUSER='', IDMENU='MNDN000000003', IDROLE=NULL, CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=NULL
WHERE ID='USRMEN09';

UPDATE ASYNCRH.USERMENU
SET REFUSER='', IDMENU='MENUDYN001', IDROLE=NULL, CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=NULL
WHERE ID='USRMEN01';

UPDATE ASYNCRH.USERMENU
SET REFUSER='', IDMENU='MNDN00002', IDROLE=NULL, CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=NULL
WHERE ID='USRMEN7623';

UPDATE ASYNCRH.USERMENU
SET REFUSER='', IDMENU='MDT021030017', IDROLE=NULL, CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=NULL
WHERE ID='USRMEN12';

UPDATE ASYNCRH.USERMENU
SET REFUSER='', IDMENU='MNDN00001', IDROLE=NULL, CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=NULL
WHERE ID='USRMEN7622';

UPDATE ASYNCRH.USERMENU
SET REFUSER='', IDMENU='MNDN274', IDROLE=NULL, CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=NULL
WHERE ID='USRMEN7621';

UPDATE ASYNCRH.USERMENU
SET REFUSER='', IDMENU='MENUDYN002', IDROLE=NULL, CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=NULL
WHERE ID='USRMEN7624';

UPDATE ASYNCRH.USERMENU
SET REFUSER='', IDMENU='MENUDYN00304001', IDROLE=NULL, CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=NULL
WHERE ID='USRMEN0304001';

UPDATE ASYNCRH.USERMENU
SET REFUSER='', IDMENU='ELM000011', IDROLE=NULL, CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=NULL
WHERE ID='USRMEN0704001';



CREATE OR REPLACE VIEW "DET_PAIE_EDIT_FINAL_PDF_CONID" AS
SELECT (d.idpersonnel || '//') || d.idedition AS id,
       o.cturgence_nom_prenom AS nom,
       pf.desce AS poste,
       sum(d.salaire_de_base) AS salaire_de_base,
       sum(d.taux) AS taux,
       sum(d.juillet) AS juillet,
       sum(d.indemnitedepresentationbrut) AS indemnitedepresentationbrut,
       sum(d.indemnite_de_transport) AS indemnite_de_transport,
       sum(d.avantages_en_nature) AS avantages_en_nature,
       sum(d.juillet) + sum(d.indemnitedepresentationbrut) + sum(d.indemnite_de_transport) + sum(d.avantages_en_nature) AS montant_brut,
       sum(d.cnaps_travailleur) AS cnaps,
       sum(d.juillet) + sum(d.indemnitedepresentationbrut) + sum(d.indemnite_de_transport) + sum(d.avantages_en_nature) - sum(d.cnaps_travailleur) AS brutcnaps,
       100 * trunc((sum(d.juillet) + sum(d.indemnitedepresentationbrut) + sum(d.indemnite_de_transport) + sum(d.avantages_en_nature) - sum(d.cnaps_travailleur)) / 100) AS imposable,
       sum(d.irsa) AS irsa,
       round((sum(d.juillet) + sum(d.indemnitedepresentationbrut) + sum(d.indemnite_de_transport) + sum(d.avantages_en_nature) - sum(d.cnaps_travailleur) - sum(d.irsa)), 1) AS netaprescalcul,
       sum(d.reductionpourpersonnesacharge) AS reductionpourpersonnesacharge,
       sum(d.irsanet) AS irsanet,
       sum(d.net_a_payer) AS net_a_payer,
       d.mois,
       d.annee,
       o.dateembauche,
       o.numero_cnaps,
       o.matricule,
       d.idedition,
       TO_CHAR(
               TO_DATE(TO_CHAR(d.mois, 'FM00'), 'MM'),
               'FMMonth',
               'NLS_DATE_LANGUAGE=FRENCH'
       ) AS moisLib
FROM details_paie_edition_pdf d
         LEFT JOIN paie_info_personnel_libcomplet o ON o.id = d.idpersonnel
         LEFT JOIN paie_info_personnel pip ON pip.id = d.idpersonnel
         LEFT JOIN paie_fonction pf ON pf.id = pip.idfonction
GROUP BY d.idpersonnel, o.cturgence_nom_prenom, pf.desce, d.mois, d.annee, o.dateembauche, o.numero_cnaps, o.matricule, d.idedition;

DROP SEQUENCE SEQ_XC

CREATE SEQUENCE seq_XC
    START WITH 100
    INCREMENT BY 1
    NOCACHE
NOCYCLE;


CREATE OR REPLACE VIEW SOLDECONGE_PERS_CPL AS
SELECT
    CAST(sum(nvl(m.PLUS,0)) AS NUMBER(30, 2)) AS droit ,
    CAST(sum(nvl(m.MOINS ,0)) AS NUMBER(30, 2)) AS congePris ,
    CAST(sum(nvl(m.PLUS,0)) - sum(nvl(m.MOINS ,0)) AS NUMBER(30, 2)) AS solde ,
    lp.NOM ,
    lp.PRENOM ,
    lp.ID AS IDPERSONNEL
FROM MOUVEMENTABSENCE m
         LEFT JOIN LOG_PERSONNEL lp ON lp.ID = m.IDPERSONNEL
GROUP BY lp.NOM ,
         lp.PRENOM , lp.ID
;


CREATE OR REPLACE VIEW "PAIE_AVANCEMENT_LIBELLE2" AS
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
       ls.code_service AS service,
       pf.val AS idfonction,
       pav.ctg,
       pg.val AS idcategorie,
       pav.echelon,
       pav.classee,
       pav.indicegrade,
       pav.indice_fonctionnel,
       CASE
           WHEN pip.temporaire = -1 THEN 'Temporaire'
           WHEN pip.temporaire = 0 THEN 'Permanent'
           WHEN pip.temporaire = 1 THEN 'Cadre'
           ELSE NULL
           END AS statut,
       pav.vehiculee,
       pav.remarque,
       lp.sexe,
       pav.etat,
       pav.matricule_patron,
       pav.droit_hs,
       pav.indice_ct,
       pav.code_banque,
       pf.desce AS fonctionLib
FROM paie_avancement pav
         LEFT JOIN dec_decision_type dt ON dt.id = pav.motif
         JOIN log_personnel lp ON lp.id = pav.id_logpers
         LEFT JOIN paie_info_personnel pip ON pip.id = pav.id_logpers
         LEFT JOIN log_direction ld ON ld.id = pav.direction
         LEFT JOIN log_service ls ON ls.id = pav.service
         LEFT JOIN paie_fonction pf ON pf.id = pav.idfonction
         LEFT JOIN paie_categorie pg ON pg.id = pav.idcategorie;



CREATE OR REPLACE VIEW SOLDECONGE_PERS_CPL AS
SELECT
    CAST(sum(nvl(m.PLUS,0)) AS NUMBER(30, 2)) AS droit ,
    CAST(sum(nvl(m.MOINS ,0)) AS NUMBER(30, 2)) AS congePris ,
    CAST(sum(nvl(m.PLUS,0)) - sum(nvl(m.MOINS ,0)) AS NUMBER(30, 2)) AS solde ,
    lp.NOM || ' ' || lp.PRENOM AS nomPersonnel,
    lp.ID ,
    pip.MATRICULE
FROM MOUVEMENTABSENCE m
         LEFT JOIN LOG_PERSONNEL lp ON lp.ID = m.IDPERSONNEL
         LEFT JOIN PAIE_INFO_PERSONNEL pip ON pip.id = lp.ID
GROUP BY lp.NOM ,
         lp.PRENOM , lp.ID, pip.MATRICULE
;

ALTER TABLE PAIE_AVANCEMENT ADD contrat VARCHAR(255)

ALTER TABLE PAIE_AVANCEMENT ADD typePersonnel VARCHAR(255)

ALTER TABLE PAIE_AVANCEMENT ADD dureeContrat NUMBER

--ALTER TABLE PAIE_AVANCEMENT DROP COLUMN dureeContart

ALTER TABLE PAIE_AVANCEMENT ADD modePaiement VARCHAR(255)


CREATE OR REPLACE VIEW "PAIE_AVANCEMENT_LIBELLE4"  AS
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


