--bdd
--dans PAIE_INFO_PERSONNEL
--ajouter colonne departement

ALTER TABLE PAIE_INFO_PERSONNEL ADD iddepartement varchar(255);

--creer classe DEPARTEMENT
--id
--val
--desce
--getseqdepartement

create table DEPARTEMENT(
    id varchar(255) constraint DEPARTEMENT_pk primary key ,
    val varchar(255) ,
    desce varchar(255) 
);


create sequence seqDEPARTEMENT
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getseqDEPARTEMENT
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqDEPARTEMENT.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 


--creer table
--PAIEPERSELTMERE
--id
--idRattachement
--idDepartement
--moisRegularisation string
--anneeRegularisation string
--dateDebut
--dateFin
--idElementPaie


create table PAIEPERSELTMERE(
    id varchar(255) constraint PAIEPERSELTMERE_pk primary key ,
    idRattachement varchar(255) ,
    idDepartement varchar(255) ,
    moisRegularisation varchar(10),
    anneeRegularisation varchar(10),
    dateDebut DATE,
    dateFin DATE,
    idElementPaie varchar(255)
);


create sequence seqPAIEPERSELTMERE
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getseqPAIEPERSELTMERE
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqPAIEPERSELTMERE.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 


--vue : LOG_PERSONNEL_V2
--ampiana idDepartement


CREATE OR REPLACE  VIEW LOG_PERSONNEL_V2 (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, CODE_DR, MATRICULE, IDCATEGORIE, CTG, INDICEGRADE, INDICE_FONCTIONNEL, STATUT, CATEGORIEVAL, CTGVAL, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, RESTECONGE, CATEGORIE, QUALIFICATION, IDDIRECTION,iddepartement) AS 
  SELECT lpv.id,
       lpv.permis_conduire,
       lpv.chemin_permis,
       lpv.remarque,
       lpv.id_pers,
       lpv.nom,
       lpv.prenom,
       lpv.date_naissance,
       lpv.sexe,
       lpv.numero_cin,
       lpv.date_cin,
       lpv.date_dupl_cin,
       lpv.nationalite,
       lpv.adresse,
       lpv.fokotany,
       lpv.acte_naissance,
       lpv.direction,
       lpv.service,
       lpv.code_dr,
       lpv.matricule,
       lpv.idcategorie,
       lpv.ctg,
       lpv.indicegrade,
       lpv.indice_fonctionnel,
       lpv.statut,
       lpv.categorieval,
       lpv.ctgval,
       lpv.numero_cnaps,
       lpv.numero_ostie,
       lpv.temporaire,
       lpv.resteconge,
       cpl.val AS categorie,
       qp.val AS qualification,
       lpv.idDIRECTION,
       pinfo.iddepartement
FROM log_personnel_v lpv
         LEFT JOIN paie_info_personnel pinfo ON pinfo.id = lpv.id
         LEFT JOIN categorie_paie_lib cpl ON cpl.id = pinfo.idcategorie_paie
         LEFT JOIN qualification_paie qp ON qp.id = pinfo.idqualification;


--vue : EMPLOYE_COMPLET
--ampiana idDepartement de meme ny vue EMPLOYE_COMPLET2

CREATE OR REPLACE  VIEW EMPLOYE_COMPLET (ID, NOM, PRENOM, ID_PERS, INITIALE, MATRICULE, DATE_NAISSANCE, LIEU_NAISSANCE_COMMUNE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, LIEU_DELIVRANCE_CIN, ADRESSE, FOKOTANY, NATIONALITE, ACTE_NAISSANCE, SITUATION_MATRIMONIAL, IDCONJOINT, DIRECTION, SERVICE, IDFONCTION, CTG, IDCATEGORIE, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, MODE_PAIEMENT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, PERMIS_CONDUIRE, REMARQUE, CHEMIN_PERMIS, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, DATEEMBAUCHE, DATESAISIE, CODE_DR, BANQUE_CODE, ECHELON, ETAT, VEHICULEE, DATE_DERNIERPROMO, DROIT_HS, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, NBENFANT, INDESIRABLE, DUREE, TELEPHONE, MAIL, IDCATEGORIE_PAIE, IDQUALIFICATION, DISCIPLINE, FORMATION, ANNEEEXPERIENCE, PERSONNEL_ETAT, DEBUTCONTRAT, FINCONTRAT, REFUSER, IDETATHIERARCHIE, ETATVISA, ETATANNULE, TYPECONTRAT, CHEMINIMAGE,iddepartement) AS 
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
       paie.iddepartement
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


CREATE OR REPLACE  VIEW EMPLOYE_COMPLET2 (ID, NOM, PRENOM, ID_PERS, INITIALE, MATRICULE, DATE_NAISSANCE, LIEU_NAISSANCE_COMMUNE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, LIEU_DELIVRANCE_CIN, ADRESSE, FOKOTANY, NATIONALITE, ACTE_NAISSANCE, SITUATION_MATRIMONIAL, IDCONJOINT, DIRECTION, SERVICE, IDFONCTION, CTG, IDCATEGORIE, CLASSEE, INDICEGRADE, INDICE_FONCTIONNEL, MATRICULE_PATRON, STATUT, MODE_PAIEMENT, CODE_AGENCE_BANQUE, BANQUE_NUMERO_COMPTE, BANQUE_COMPTE_CLE, PERMIS_CONDUIRE, REMARQUE, CHEMIN_PERMIS, CTURGENCE_NOM_PRENOM, CTURGENCE_TELEPHONE1, CTURGENCE_TELEPHONE2, CTURGENCE_TELEPHONE3, DATEEMBAUCHE, DATESAISIE, CODE_DR, BANQUE_CODE, ECHELON, ETAT, VEHICULEE, DATE_DERNIERPROMO, DROIT_HS, HEUREJOURNALIER, HEUREHEBDOMADAIRE, HEUREMENSUEL, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, NBENFANT, INDESIRABLE, DUREE, TELEPHONE, MAIL, IDCATEGORIE_PAIE, IDQUALIFICATION, DISCIPLINE, FORMATION, ANNEEEXPERIENCE, PERSONNEL_ETAT, REFUSER, IDETATHIERARCHIE, ETATVISA, ETATANNULE, IDROLE, RANG,iddepartement) AS 
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
       logp.refuser,
       logp.idhierarchie AS idetathierarchie,
       et.etatvisa,
       et.etatannule,
       r.idrole,
       r.rang,
       paie.iddepartement
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
         LEFT JOIN categorie_qualification cq ON cq.idcategorie = paie.idcategorie_paie AND cq.idqualification = paie.idqualification
         LEFT JOIN etathierarchie et ON et.id = logp.idhierarchie
         LEFT JOIN utilisateur u ON logp.refuser = u.refuser
         LEFT JOIN roles r ON r.idrole = u.idrole;

-- Creation vue paiepers fille misy ny emp rehetra 
CREATE OR REPLACE VIEW PAIEPERS_ELTFILLE AS
SELECT
    '' as ID,
    v.ID as idPersonnel,
    v.NOM || ' ' || v.PRENOM as personnelLib,
    v.MATRICULE,
    0 as montant,
    null as remarque,
    v.IDDEPARTEMENT,
    v.IDDIRECTION
FROM LOG_PERSONNEL_V2 v;
