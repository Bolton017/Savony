CREATE OR REPLACE VIEW PAIE_PERS_ELTPAIE_LIB2 ("ID", "MATRICULE", "ID_CODE_RUBRIQUE", "CODE_RUBRIQUE", "DATE_DEBUT", "DATE_FIN", "GAIN", "RETENUE", "REMARQUE", "IDPERSONNEL", "ETAT", "ID_OBJET", "IDUSER", "MOISREGULARISATION", "ANNEEREGULARISATION", "IDCATEGORIE_QUALIFICATION", "IDFONCTION", "POURCENTAGE", "MOISLIB") AS 
  SELECT
    ppe.id,
    pip2.matricule,
    pr.id as id_code_rubrique,
    pr.val AS code_rubrique,
    ppe.date_debut,
    ppe.date_fin,
    ppe.gain,
    ppe.retenue,
    ppe.remarque,
    pip.nom || ' ' || pip.prenom AS idpersonnel,
    ppe.etat,
    ppe.id_objet,
    ppe.iduser,
    ppe.moisregularisation,
    ppe.anneeregularisation,
    cq.idcategorielib || ' ' || cq.categorie_qualificationlib AS idcategorie_qualification,
    pf.desce AS idfonction,
    ppe.pourcentage,
    TO_CHAR(
            TO_DATE(TO_CHAR(ppe.moisregularisation, 'FM00'), 'MM'),
            'FMMonth',
            'NLS_DATE_LANGUAGE=FRENCH'
    ) AS moisLib
FROM paie_personnel_elementpaie ppe
         LEFT JOIN log_personnel pip ON TO_CHAR(pip.id) = TO_CHAR(ppe.idpersonnel)
         LEFT JOIN categorie_qualification_libc cq ON TO_CHAR(ppe.idcategorie_qualification) = TO_CHAR(cq.id)
         LEFT JOIN paie_fonction pf ON TO_CHAR(ppe.idfonction) = TO_CHAR(pf.id)
         LEFT JOIN paie_rubrique pr ON TO_CHAR(pr.id) = TO_CHAR(ppe.code_rubrique)
         JOIN paie_info_personnel pip2 ON TO_CHAR(pip.id) = TO_CHAR(pip2.id);


INSERT INTO CATEGORIE_PAIE (ID, VAL, DESCE, MONTANT, REMARQUE, DROIT_HEURE_SUP, ESSAIE) VALUES ('CPSAISIE0001','AUTRE', 'AUTRE', 0, 'aucun', 'o', 3);
DELETE FROM LOG_DIRECTION WHERE VAL = 'ANDOHARONOFOTSY';


CREATE OR REPLACE VIEW EMPLOYE_COMPLET_LIBELLE2 ("ID", "NOM", "PRENOM", "ID_PERS", "INITIALE", "MATRICULE", "SEXE", "DATE_NAISSANCE", "LIEU_NAISSANCE_COMMUNE", "SITUATION_MATRIMONIAL", "ACTE_NAISSANCE", "NBENFANT", "NUMERO_CIN", "DATE_CIN", "DATE_DUPL_CIN", "LIEU_DELIVRANCE_CIN", "ADRESSE", "TELEPHONE", "MAIL", "REGION", "DIRECTION", "SERVICE",  "IDFONCTION", "IDCATEGORIE",  "CATEGORIEPAIELIB", "DATEEMBAUCHE", "NUMERO_CNAPS", "NUMERO_OSTIE", "MODE_PAIEMENT", "BANQUE_NUMERO_COMPTE", "FORMATION", "DISCIPLINE", "ANNEEEXPERIENCE", "ETAT", "FOKOTANY", "NATIONALITE", "IDCONJOINT", "CTG", "CLASSEE", "INDICEGRADE", "INDICE_FONCTIONNEL", "MATRICULE_PATRON", "STATUT", "CODE_AGENCE_BANQUE", "BANQUE_COMPTE_CLE", "PERMIS_CONDUIRE", "REMARQUE", "CHEMIN_PERMIS", "CTURGENCE_NOM_PRENOM", "CTURGENCE_TELEPHONE1", "CTURGENCE_TELEPHONE2", "CTURGENCE_TELEPHONE3", "DATESAISIE", "CODE_DR", "BANQUE_CODE", "ECHELON", "VEHICULEE", "VEHICULEE_STR", "DATE_DERNIERPROMO", "HEUREJOURNALIER", "HEUREHEBDOMADAIRE", "HEUREMENSUEL", "TEMPORAIRE", "TEMPORAIRE_LIB", "MOTIF_DEBAUCHE", "TYPE_DEBAUCHE", "ADRESSE_LIGNE1", "ADRESSE_LIGNE2", "CODE_POSTAL") AS 
  SELECT logp.id,
       logp.nom,
       logp.prenom,
       logp.id_pers,
       paie.initiale,
       paie.matricule AS matricule,
       s.desce AS sexe,
       logp.date_naissance,
       paie.lieu_naissance_commune,
       sitmat.desce AS situation_matrimonial,
       logp.acte_naissance,
       paie.nbenfant,
       logp.numero_cin,
       logp.date_cin,
       logp.date_dupl_cin,
       paie.lieu_delivrance_cin,
       logp.adresse,
       paie.telephone,
       paie.mail,
       reg.val AS region,
       ld.val AS direction,
       serv.libelle AS service,
       pf.desce AS idfonction,
       pc.val AS idcategorie,
       cp.DESCE AS categoriePaieLib,
       paie.dateembauche,
       paie.numero_cnaps,
       paie.numero_ostie,
       pm.val AS mode_paiement,
       paie.banque_numero_compte,
       fd.val AS formation,
       paie.discipline,
       paie.anneeexperience,
       paie.etat,
       sf.val AS fokotany,
       p.val AS nationalite,
       paie.idconjoint,
       paie.ctg,
       paie.classee,
       paie.indicegrade,
       paie.indice_fonctionnel,
       paie.matricule_patron,
       paie.statut,
       paie.code_agence_banque,
       paie.banque_compte_cle,
       logp.permis_conduire,
       logp.remarque,
       logp.chemin_permis,
       paie.cturgence_nom_prenom,
       paie.cturgence_telephone1,
       paie.cturgence_telephone2,
       paie.cturgence_telephone3,
       paie.datesaisie,
       serv.code_dr,
       trs.val AS banque_code,
       paie.echelon,
       paie.vehiculee,
       CASE paie.vehiculee
           WHEN 0 THEN 'non'
           WHEN 1 THEN 'oui'
           ELSE NULL
           END AS vehiculee_str,
       tab.date_dernierpromo,
       paie.heurejournalier,
       paie.heurehebdomadaire,
       paie.heuremensuel,
       paie.temporaire,
       CASE
           WHEN paie.temporaire = '-1' THEN 'Temporaire'
           WHEN paie.temporaire = 0 THEN 'Permanent'
           WHEN paie.temporaire = 1 THEN 'Cadre'
           ELSE NULL
           END AS temporaire_lib,
       lpnv.motif AS motif_debauche,
       ddt.val AS type_debauche,
       paie.adresse_ligne1,
       paie.adresse_ligne2,
       paie.code_postal
FROM log_personnel logp
         LEFT JOIN ( SELECT paie_avancement.id_logpers,
                            max(paie_avancement.datedecision) AS date_dernierpromo
                     FROM paie_avancement
                     GROUP BY paie_avancement.id_logpers) tab ON logp.id = tab.id_logpers
         LEFT JOIN paie_info_personnel paie ON logp.id = paie.id
         LEFT JOIN log_service serv ON serv.id = logp.service
         LEFT JOIN trs_banques_agences trs ON paie.code_agence_banque = trs.id
         LEFT JOIN sexe s ON logp.sexe = s.id
         LEFT JOIN sig_fokontany sf ON logp.fokotany = sf.id
         LEFT JOIN pays p ON logp.nationalite = p.id
         LEFT JOIN log_direction ld ON logp.direction = ld.id
         LEFT JOIN paie_fonction pf ON paie.idfonction = pf.id
         LEFT JOIN paie_categorie pc ON paie.idcategorie = pc.id
         LEFT JOIN modepaiement pm ON paie.mode_paiement = pm.id
         LEFT JOIN situation_matrimoniale sitmat ON paie.situation_matrimonial = sitmat.id
         LEFT JOIN log_personnel_non_valide lpnv ON logp.id = lpnv.idlogpers
         LEFT JOIN dec_decision_type ddt ON lpnv.idtypedebauche = ddt.id
         LEFT JOIN region reg ON reg.id = paie.region
         LEFT JOIN formation_diplome fd ON fd.id = paie.formation
         LEFT JOIN categorie_paie cp ON paie.IDCATEGORIE_PAIE = cp.id
WHERE logp.id <> '1002067';


INSERT INTO TYPE_DEPART (ID, VAL, DESCE) VALUES ('TYP0010', 'Licenciement ', 'Licenciement ');

INSERT INTO TYPE_DEPART (ID, VAL, DESCE) VALUES ('TD002', 'Demission', 'Demission');

INSERT INTO TYPE_DEPART (ID, VAL, DESCE) VALUES ('TYP001', 'Fin de contrat', 'Fin de contrat');

UPDATE situation_matrimoniale SET VAL = 'Marié', DESCE = 'Marié' WHERE VAL = 'MariÃ©';
UPDATE situation_matrimoniale SET VAL = 'Célibatire', DESCE = 'Célibataire' WHERE VAL = 'CÃ©libataire';
UPDATE situation_matrimoniale SET VAL = 'Divorcé(e)', DESCE = 'Divorcé(e)' WHERE VAL = 'DivorcÃ©(e)';



CREATE SEQUENCE SEQPERIODEPAIE
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 999999999999
    NOCYCLE
    CACHE 20;


CREATE OR REPLACE FUNCTION GETSEQPERIODEPAIE
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT SEQPERIODEPAIE.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;


CREATE OR REPLACE VIEW HSMOIS_CPL ("ID", "IDCATEGORIE", "MOIS", "MOISLIB", "ANNEE", "DATY", "IDDEPARTEMENT", "ETAT", "IDCATEGORIELIB", "IDDEPARTEMENTLIB", "ETATLIB") AS 
  SELECT
    hs."ID", hs."IDCATEGORIE",hs."MOIS",
    TO_CHAR(
            TO_DATE(TO_CHAR(hs.mois, 'FM00'), 'MM'),
            'FMMonth',
            'NLS_DATE_LANGUAGE=FRENCH'
    ) AS moisLib,
    hs."ANNEE",hs."DATY",hs."IDDEPARTEMENT",hs."ETAT",
    c.val AS idCategorieLib,
    d.val AS idDepartementLib,
    CASE
        WHEN hs.etat = 1 THEN 'CREE'
        WHEN hs.etat = 11 THEN 'VISEE'
        ELSE 'INCONNU'
        END AS etatLib
FROM
    HSMOIS hs
        LEFT JOIN categorie c ON hs.idCategorie = c.id
        LEFT JOIN departement d ON hs.idDepartement = d.id;
