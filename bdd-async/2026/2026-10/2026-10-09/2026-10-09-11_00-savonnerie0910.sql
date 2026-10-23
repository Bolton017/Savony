--creer view et sequence :( reference any @ base axelle ) 
--
--Table (1)
--
--MATERNITE, avec la colonne DPA DATE ajoutée ensuite

CREATE TABLE MATERNITE 
   (	ID VARCHAR2(50) NOT NULL , 
	IDPERSONNEL VARCHAR2(50), 
	DATEDEPARTTHEORIQUE DATE, 
	DATEDEPARTREEL DATE, 
	DATEACCOUCHEMENT DATE, 
	DATERETOURTHEORIQUE DATE, 
	DATERETOURAJUSTE DATE, 
	DATEFINALLAITEMENT DATE, 
	REMARQUE VARCHAR2(500), 
	DPA DATE, 
	 PRIMARY KEY (ID)
   );

--
--Séquence (1)
--
--SEQ_MATERNITE
--

CREATE SEQUENCE SEQ_MATERNITE INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

--Fonction (1)
--
--GETSEQMATERNITE
--

CREATE OR REPLACE FUNCTION getSeqMaternite
     RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT SEQ_MATERNITE.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END;

--Vues (3) => alaina avy any @ axelle daholo
--
--V_MATERNITE_LIB
--
--V_PERSONNEL_MATERNITE
--
--V_INFO_MATERNITE_TRAVAIL
--

CREATE OR REPLACE  VIEW V_MATERNITE_LIB (ID, IDPERSONNEL, DATEDEPARTTHEORIQUE, DATEDEPARTREEL, DATEACCOUCHEMENT, DATERETOURTHEORIQUE, DATERETOURAJUSTE, DATEFINALLAITEMENT, REMARQUE, IDPERSONNELLIB, MATRICULE, IDFONCTION, IDFONCTIONLIB, DPA) AS 
  SELECT
    m.ID,m.IDPERSONNEL,m.DATEDEPARTTHEORIQUE,m.DATEDEPARTREEL,m.DATEACCOUCHEMENT,m.DATERETOURTHEORIQUE,
    NVL(m.DATERETOURAJUSTE, m.DATERETOURTHEORIQUE) AS DATERETOURAJUSTE,
    m.DATEFINALLAITEMENT,m.REMARQUE,
    (lp.nom || ' ') || lp.prenom AS IDPERSONNELlib,
    pip.MATRICULE AS matricule,
    pf.ID AS idfonction,
    pf.VAL AS idfonctionlib,
    m.DPA
FROM maternite m
         LEFT JOIN log_personnel lp
                   ON m.idPersonnel = lp.id
         LEFT JOIN paie_info_personnel pip
                   ON m.idPersonnel = pip.id
         LEFT JOIN paie_fonction pf
                   ON pip.idFonction = pf.id;


CREATE OR REPLACE  VIEW LOG_PERSONNEL_FIN (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, CODE_DR, MATRICULE, IDCATEGORIE, CTG, INDICEGRADE, INDICE_FONCTIONNEL, STATUT, CATEGORIEVAL, CTGVAL, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, DROIT, PRIE, RESTECONGE, ETAT, IDPERSONNEL, IDDIRECTION, DEPARTEMENTLIB, IDDEPARTEMENT,idsexe) AS 
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
       paie.IDDEPARTEMENT,
       sex.id AS idsexe
FROM log_personnel l
         LEFT JOIN log_service s ON l.service = s.id
         LEFT JOIN paie_info_personnel paie ON paie.id = l.id
         LEFT JOIN sexe sex ON l.sexe = sex.id
         LEFT JOIN log_direction d ON d.id = l.direction
         LEFT JOIN paie_categorie c ON c.id = paie.idcategorie
         LEFT JOIN droitdeconge_parpersonne dr ON dr.idpersonnel = l.id
         LEFT JOIN congeprisgroupbypers cg ON cg.idpersonnel = l.id
         LEFT JOIN DEPARTEMENT dp ON dp.id = paie.IDDEPARTEMENT
 
 
 
 
 ;
 
 CREATE OR REPLACE  VIEW LOG_PERSONNEL_V (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, CODE_DR, MATRICULE, IDCATEGORIE, CTG, INDICEGRADE, INDICE_FONCTIONNEL, STATUT, CATEGORIEVAL, CTGVAL, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, RESTECONGE, IDDIRECTION,idsexe) AS 
  SELECT log_personnel_fin.id,
       log_personnel_fin.permis_conduire,
       log_personnel_fin.chemin_permis,
       log_personnel_fin.remarque,
       log_personnel_fin.id_pers,
       log_personnel_fin.nom,
       log_personnel_fin.prenom,
       log_personnel_fin.date_naissance,
       log_personnel_fin.sexe,
       log_personnel_fin.numero_cin,
       log_personnel_fin.date_cin,
       log_personnel_fin.date_dupl_cin,
       log_personnel_fin.nationalite,
       log_personnel_fin.adresse,
       log_personnel_fin.fokotany,
       log_personnel_fin.acte_naissance,
       log_personnel_fin.direction,
       log_personnel_fin.service,
       log_personnel_fin.code_dr,
       log_personnel_fin.matricule,
       log_personnel_fin.idcategorie,
       log_personnel_fin.ctg,
       log_personnel_fin.indicegrade,
       log_personnel_fin.indice_fonctionnel,
       log_personnel_fin.statut,
       log_personnel_fin.categorieval,
       log_personnel_fin.ctgval,
       log_personnel_fin.numero_cnaps,
       log_personnel_fin.numero_ostie,
       log_personnel_fin.temporaire,
       log_personnel_fin.resteconge,
       log_personnel_fin.idDIRECTION,
       log_personnel_fin.idsexe
FROM log_personnel_fin
WHERE NOT (log_personnel_fin.id IN ( SELECT log_personnel_non_valide.idlogpers
                                     FROM log_personnel_non_valide
                                     WHERE log_personnel_non_valide.etat >= 11))
 
 
 
 
 ;
 
 CREATE OR REPLACE  VIEW LOG_PERSONNEL_V2 (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, CODE_DR, MATRICULE, IDCATEGORIE, CTG, INDICEGRADE, INDICE_FONCTIONNEL, STATUT, CATEGORIEVAL, CTGVAL, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, RESTECONGE, CATEGORIE, QUALIFICATION, IDDIRECTION, IDDEPARTEMENT,idsexe,bu) AS 
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
       pinfo.iddepartement,
       lpv.idsexe,
       pinfo.UNITE as bu
FROM log_personnel_v lpv
         LEFT JOIN paie_info_personnel pinfo ON pinfo.id = lpv.id
         LEFT JOIN categorie_paie_lib cpl ON cpl.id = pinfo.idcategorie_paie
         LEFT JOIN qualification_paie qp ON qp.id = pinfo.idqualification
 
 
 
 
 ;

CREATE OR REPLACE VIEW V_PERSONNEL_MATERNITE (ID, PERMIS_CONDUIRE, CHEMIN_PERMIS, REMARQUE, ID_PERS, NOM, PRENOM, DATE_NAISSANCE, SEXE, NUMERO_CIN, DATE_CIN, DATE_DUPL_CIN, NATIONALITE, ADRESSE, FOKOTANY, ACTE_NAISSANCE, DIRECTION, SERVICE, CODE_DR, MATRICULE, IDCATEGORIE, CTG, INDICEGRADE, INDICE_FONCTIONNEL, STATUT, CATEGORIEVAL, CTGVAL, NUMERO_CNAPS, NUMERO_OSTIE, TEMPORAIRE, RESTECONGE, CATEGORIE, QUALIFICATION, IDDIRECTION, IDDEPARTEMENT, BU) AS 
  SELECT ID,PERMIS_CONDUIRE,CHEMIN_PERMIS,REMARQUE,ID_PERS,NOM,PRENOM,DATE_NAISSANCE,SEXE,NUMERO_CIN,DATE_CIN,DATE_DUPL_CIN,NATIONALITE,ADRESSE,FOKOTANY,ACTE_NAISSANCE,DIRECTION,SERVICE,CODE_DR,MATRICULE,IDCATEGORIE,CTG,INDICEGRADE,INDICE_FONCTIONNEL,STATUT,CATEGORIEVAL,CTGVAL,NUMERO_CNAPS,NUMERO_OSTIE,TEMPORAIRE,RESTECONGE,CATEGORIE,QUALIFICATION,IDDIRECTION,IDDEPARTEMENT,BU FROM log_personnel_v2
WHERE idsexe = 0

 ;

 
 CREATE OR REPLACE  VIEW V_INFO_MATERNITE_TRAVAIL (IDPERSONNEL, MOIS, ANNEE, HEUREABSENCE, HEURETRAVAILLER, DATY, DATEDUJOUR, MATRICULETRAVAILLEUR, DATEEMBAUCHE, NUMERO_CIN, NOM, PRENOM, NOMPRENOM, DATENAISSANCE, ADRESSE, NATIONALITE, FONCTIONLIB) AS 
  SELECT
    lp.id AS idPersonnel,
    TO_CHAR(SYSDATE, 'MM') AS mois,
    TO_CHAR(SYSDATE, 'YYYY') AS annee,
    NVL(ptg.heureAbsence, 0) AS heureAbsence,
    NVL(ptg.heureTravailler, 0) AS heureTravailler,
    SYSDATE AS daty,
    SYSDATE AS dateDuJour,
    pip.matricule AS matriculeTravailleur,
    pip.dateembauche AS dateEmbauche,
    lp.numero_cin AS numero_cin,
    lp.nom,
    lp.prenom,
    (lp.nom || ' ' || lp.prenom) AS nomPrenom,
    lp.date_naissance AS dateNaissance,
    lp.adresse AS adresse,
    'Malagasy' AS nationalite,
    pf.val AS fonctionLib
FROM LOG_PERSONNEL lp
-- Ajustez la condition de jointure (lp.id = pip.id ou lp.id = pip.id_logpers selon votre modèle)
         LEFT JOIN PAIE_INFO_PERSONNEL pip ON lp.id = pip.id
         LEFT JOIN PAIE_FONCTION pf ON pip.idfonction = pf.id
         LEFT JOIN (
    -- Sous-requête pour sommer les heures travaillées et les absences du mois en cours
    SELECT
        IDPERSONNEL,
        SUM(ABSENCE) AS heureAbsence,       -- Vrai nom de la colonne d'absence
        SUM(HEURENORMAL) AS heureTravailler -- Vrai nom de la colonne d'heures travaillées
    FROM POINTAGE
    WHERE TO_CHAR(DATY, 'MM-YYYY') = TO_CHAR(SYSDATE, 'MM-YYYY')
    GROUP BY IDPERSONNEL
) ptg ON lp.id = ptg.IDPERSONNEL
 
 
 
 ;
 
 
 

