
-- delete sexe 00 et 11
delete from sexe where id in('00', '11');



-- Liste des departs
CREATE OR REPLACE VIEW LOG_PERS_NON_VALIDE_LIB AS
SELECT
    lpnv.id,
    lp.nom || ' ' || lp.prenom AS idlogpers,
    lp.sexe,
    lpnv.dateapplication,
    td.val AS idtypedebauche,
    lpnv.etat,
    lpnv.iduser,
    pif.matricule,
    lpnv.date_decision,
    lpnv.refdecision,
    CASE
        WHEN lpnv.etat = 1 THEN
            '<span style="color: blue; font-weight: bold;">Créé</span>'
        WHEN lpnv.etat = 11 THEN
            '<span style="color: green; font-weight: bold;">Validé</span>'
        WHEN lpnv.etat = 0 THEN
            '<span style="color: red; font-weight: bold;">Annulé</span>'
        ELSE
            '<span style="color: gray; font-style: italic;">Inconnu</span>'
        END AS etatLib
FROM log_personnel_non_valide lpnv
         LEFT JOIN type_depart td
                   ON td.id = lpnv.idtypedebauche
         LEFT JOIN paie_info_personnel pif
                   ON pif.id = lpnv.idlogpers
         LEFT JOIN log_personnel lp
                   ON lp.id = lpnv.idlogpers
WHERE lpnv.date_reintegration IS NULL;


-- donnees dans la table  type_depart
INSERT INTO TYPE_DEPART (ID, VAL, DESCE) VALUES ('TYP0010', 'Licenciement ', 'Licenciement ');
INSERT INTO TYPE_DEPART (ID, VAL, DESCE) VALUES ('TD002', 'Demission', 'Demission');
INSERT INTO TYPE_DEPART (ID, VAL, DESCE) VALUES ('TYP001', 'Fin de contrat', 'Fin de contrat');

-- Liste des employes
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


CREATE OR REPLACE PROCEDURE DELETEEDITIONWITHPERIODE(periode VARCHAR) AS
BEGIN
DELETE FROM PAIE_EDITION WHERE idperiodepaie = periode;
DELETE FROM PAIE_EDITIONMOISANNEE where idperiodepaie = periode;
END;


-- SOCOBISPROD2411.CATEGORIE_PAIE_SALAIRE source

CREATE OR REPLACE VIEW CATEGORIE_PAIE_SALAIRE  AS
SELECT ID,VAL,DESCE,MONTANT,REMARQUE,DROIT_HEURE_SUP,ESSAIE FROM CATEGORIE_PAIE cp WHERE id in('CP0000010','CP0000011')
;

-- SOCOBISPROD2411.PERIODEPAIE definition

CREATE TABLE PERIODEPAIE
(	ID VARCHAR2(255),
     MOIS VARCHAR2(255),
     MOISLIB VARCHAR2(255),
     DATEDEBUT DATE,
     DATEFIN DATE,
     IDCATEGORIEPAIE VARCHAR2(255),
     ANNEE NUMBER(10,0),
     ETAT NUMBER(38,0),
     PRIMARY KEY (ID)
) ;

-- SOCOBISPROD2411.PERIODEPAIELIB source

CREATE OR REPLACE VIEW PERIODEPAIELIB  AS
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


CREATE SEQUENCE SEQ_PERIODEPAIE INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION getseqperiodepaie
 RETURN NUMBER
IS
  retour NUMBER;
BEGIN
SELECT SEQ_PERIODEPAIE.NEXTVAL into retour from dual;
RETURN retour;
END;


alter table paie_editionmoisannee add idperiodepaie varchar(255);
alter table paie_edition add idperiodepaie varchar(255);



CREATE SEQUENCE SEQ_PAIEEDITIONMOISANNEE INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION GETSEQPAIEEDITIONMOISANNEE
 RETURN NUMBER
IS
  retour NUMBER;
BEGIN
SELECT SEQ_PAIEEDITIONMOISANNEE.NEXTVAL into retour from dual;
RETURN retour;
END;


-- SOCOBISPROD2411.PAIEINFOPERSELTPAIECOMPLET4 source

CREATE OR REPLACE VIEW PAIEINFOPERSELTPAIECOMPLET4  AS
SELECT
    MIN(p.id) AS id,
    p.code_rubrique,
    p.date_debut,
    p.date_fin,
    MAX(p.moisregularisation) AS moisregularisation,
    MAX(p.anneeregularisation) AS anneeregularisation,
    SUM(p.gain) AS gain,
    SUM(p.retenue) AS retenue,
    SUM(p.quantite) AS quantite,
    MAX(p.unite) AS unite,
    MAX(p.remarque) AS remarque,
    p.idpersonnel,
    MAX(p.val) AS val,
    MAX(p.desce) AS desce,
    MAX(p.rang) AS rang,
    MAX(p.comptepcg) AS comptepcg,
    MAX(p.code) AS code,
    p.typerubrique,
    MAX(p.bcs) AS bcs,
    MAX(p.bg) AS bg,
    MAX(p.imposable) AS imposable,
    MAX(p.nature) AS nature,
    MAX(p.avantage) AS avantage,
    MAX(p.cpt_gen_db) AS cpt_gen_db,
    MAX(p.cpt_gen_cr) AS cpt_gen_cr,
    MAX(p.cpt_ana_db) AS cpt_ana_db,
    MAX(p.cpt_ana_cr) AS cpt_ana_cr,
    MAX(p.israppel) AS israppel,
    MAX(p.isconfeltfixe) AS isconfeltfixe,
    MAX(p.mois) AS mois,
    MAX(p.annee) AS annee,
    MAX(p.datesaisie) AS datesaisie,
    MAX(p.matricule) AS matricule,
    MAX(p.lieu_naissance_commune) AS lieu_naissance_commune,
    MAX(p.lieu_delivrance_cin) AS lieu_delivrance_cin,
    MAX(p.situation_matrimonial) AS situation_matrimonial,
    MAX(p.initiale) AS initiale,
    MAX(p.cturgence_nom_prenom) AS cturgence_nom_prenom,
    MAX(p.cturgence_telephone1) AS cturgence_telephone1,
    MAX(p.cturgence_telephone2) AS cturgence_telephone2,
    MAX(p.cturgence_telephone3) AS cturgence_telephone3,
    MAX(p.idconjoint) AS idconjoint,
    MAX(p.code_agence_banque) AS code_agence_banque,
    MAX(p.banque_numero_compte) AS banque_numero_compte,
    MAX(p.banque_compte_cle) AS banque_compte_cle,
    MAX(p.dateembauche) AS dateembauche,
    MAX(p.idfonction) AS idfonction,
    MAX(p.idgroupefonction) AS idgroupefonction,
    MAX(p.idcategorie) AS idcategorie,
    MAX(p.mode_paiement) AS mode_paiement,
    MAX(p.classee) AS classee,
    MAX(p.indicegrade) AS indicegrade,
    MAX(p.indice_fonctionnel) AS indice_fonctionnel,
    MAX(p.matricule_patron) AS matricule_patron,
    MAX(p.statut) AS statut,
    MAX(p.droit_hs) AS droit_hs,
    MAX(p.etat_element) AS etat_element,
    MAX(p.nationalite) AS nationalite,
    MAX(p.service) AS service,
    MAX(p.direction) AS direction,
    MAX(p.dateapplication) AS dateapplication,
    MAX(p.datefininvalid) AS datefininvalid,
    MAX(p.date_decision) AS date_decision,
    MAX(p.idtypedebauche) AS idtypedebauche,
    MAX(p.nbenfant) AS nbenfant,
    MAX(p.id_objet) AS id_objet,
    MAX(p.etat) AS etat,
    MAX(p.temporaire) AS temporaire,
    MAX(p.periode_essai) AS periode_essai,
    MAX(p.pointindice) AS pointindice,
    MAX(p.remarque_element) AS remarque_element,
    MAX(p.formu) AS formu,
    MAX(p.regroupement) AS regroupement,
    MAX(p.arrondi) AS arrondi,
    MAX(p.inserted) AS inserted,
    MAX(p.sommable) AS sommable,
    MAX(p.beneficiaire) AS beneficiaire,
    MAX(p.remarqueformule) AS remarqueformule,
    MAX(p.uniteformule) AS uniteformule,
    MAX(p.qteformule) AS qteformule,
    MAX(p.idcategorie_paie) AS idcategorie_paie,
    MAX(p.idqualification) AS idqualification
FROM PAIEINFOPERSELTPAIECOMPLET2 p
GROUP BY
    p.idpersonnel,
    p.code_rubrique,
    p.date_debut,
    p.date_fin,
    p.typerubrique
;


-- SOCOBISPROD2411.PAIE_EDITIONMOISANNEE_LIB_3 source

CREATE OR REPLACE VIEW PAIE_EDITIONMOISANNEE_LIB_3  AS
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



drop sequence SEQ_POINTAGE;
CREATE SEQUENCE SEQ_POINTAGE INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION GET_SEQ_POINTAGE
 RETURN NUMBER
IS
  retour NUMBER;
BEGIN
SELECT SEQ_POINTAGE.NEXTVAL into retour from dual;
RETURN retour;
END;



drop sequence SEQPAIE_PRS_ELTPAIE;
CREATE SEQUENCE SEQPAIE_PRS_ELTPAIE INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION GETSEQPAIE_PRS_ELTPAIE
 RETURN NUMBER
IS
  retour NUMBER;
BEGIN
SELECT SEQPAIE_PRS_ELTPAIE.NEXTVAL into retour from dual;
RETURN retour;
END;