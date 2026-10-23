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
	
	INSERT INTO SOCOBISPROD2411.DETFORMU
(ID, MIN, MAX, FORMULE, UNITE, REMARQUE, MERE, FORMULECONDITION, ETAT, CREATION)
VALUES('DETCNAPS2', 0, -1, 'Math.min (0.01*[++imposable==I..gain], [conf::CONF0001])', 1, NULL, 'PR000101', '1>0 && [pers::temporaire]==-1', 11, NULL);
	
	
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

-------------




CREATE OR REPLACE VIEW PAIE_PERSONNEL_ELEMENTPAIE_HS as
SELECT * FROM PAIEINFOPERSELTPAIECOMPLET2 ppe WHERE ppe.CODE_RUBRIQUE IN ('PR0000130I','PR0000150I','PR0000130','PR0000150') 


CREATE OR REPLACE VIEW PAIE_PERSONNEL_ELEMENTPAIE_NHS AS 
SELECT * FROM PAIEINFOPERSELTPAIECOMPLET2 ppe WHERE ppe.CODE_RUBRIQUE NOT IN ('PR0000130I','PR0000150I','PR0000130','PR0000150') 


CREATE OR REPLACE VIEW PAIE_PERS_ELP_HS_GP AS
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
FROM PAIE_PERSONNEL_ELEMENTPAIE_HS p
GROUP BY
    p.idpersonnel,
    p.code_rubrique,
    p.date_debut,
    p.date_fin,
    p.typerubrique;


CREATE OR REPLACE VIEW PAIE_PERS_ELP_NHS_GP AS
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
FROM PAIE_PERSONNEL_ELEMENTPAIE_NHS p
GROUP BY
    p.idpersonnel,
    p.code_rubrique,
    p.date_debut,
    p.date_fin,
    p.typerubrique;



CREATE OR REPLACE VIEW PAIEINFOPERSELTPAIECOMPLET3 AS 
SELECT * FROM PAIE_PERS_ELP_HS_GP 
UNION ALL 
SELECT * FROM PAIE_PERS_ELP_NHS_GP;


CREATE OR REPLACE VIEW PAIEINFOPERSELTPAIECOMPLET4 AS 
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
    p.typerubrique;

