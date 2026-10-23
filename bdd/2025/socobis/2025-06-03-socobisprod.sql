-----2025-06-03
------------Tiavina
--Table As_ingredient
--ajouter colonne refPost varchar: foreignKey id (table Poste)
--Table Poste
--id, val, desce
--Table CATEGORIE_QUALIFICATION (dans RH)
--ajouter colonne idPoste (foreign key Id Table Poste)

create table Poste (
    id varchar(100) constraint Poste_pk primary key,
    val varchar(200),
    desce varchar(200)
);

create sequence seqPoste
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getseqPoste
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqPoste.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 


ALTER TABLE AS_INGREDIENTS ADD refPost varchar(100) CONSTRAINT ingredient_poste_fk REFERENCES Poste(id);

CREATE TABLE CATEGORIE_PAIE 
   (	ID VARCHAR2(100) NOT NULL , 
	VAL VARCHAR2(500), 
	DESCE VARCHAR2(500), 
	MONTANT NUMBER(30,2), 
	REMARQUE VARCHAR2(500), 
	DROIT_HEURE_SUP VARCHAR2(500), 
	ESSAIE NUMBER(30,2), 
	 CONSTRAINT CATEGORIE_PAIE_PK PRIMARY KEY (ID)
   );
  
  CREATE SEQUENCE SEQ_CATEGORIE_PAIE INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999 NOCYCLE CACHE 20 NOORDER ;
 
 CREATE OR REPLACE FUNCTION get_seq_categorie_paie
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seq_categorie_paie.NEXTVAL INTO retour FROM DUAL;
   RETURN retour;
END;

CREATE TABLE QUALIFICATION_PAIE 
   (	ID VARCHAR2(100) NOT NULL , 
	VAL VARCHAR2(500), 
	DESCE VARCHAR2(500), 
	 CONSTRAINT QUALIFICATION_PAIE_PK PRIMARY KEY (ID)
   );
  
  CREATE SEQUENCE SEQ_QUALIFICATION_PAIE INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999 NOCYCLE CACHE 20 NOORDER ;
 
 CREATE OR REPLACE FUNCTION get_seq_qualification_paie
 RETURN NUMBER
IS
  retour NUMBER;
BEGIN
  SELECT seq_qualification_paie.NEXTVAL into retour from dual;
RETURN retour;
END;

CREATE TABLE CATEGORIE_QUALIFICATION 
   (	ID VARCHAR2(100) NOT NULL , 
	IDCATEGORIE VARCHAR2(500), 
	IDQUALIFICATION VARCHAR2(500), 
	REMARQUE VARCHAR2(500), 
	ETAT NUMBER(*,0), 
	MONTANT NUMBER(30,2), 
	DATE_DEBUT DATE, 
	DATE_FIN DATE, 
	AVENANT NUMBER(*,0), 
	idPoste varchar(100),
	 CONSTRAINT CATEGORIE_QUALIFICATION_PK PRIMARY KEY (ID) , 
	 CONSTRAINT CATEGORIE_FK FOREIGN KEY (IDCATEGORIE)
	  REFERENCES CATEGORIE_PAIE (ID) , 
	 CONSTRAINT QUALIFICATION_FK FOREIGN KEY (IDQUALIFICATION)
	  REFERENCES QUALIFICATION_PAIE (ID),
	  CONSTRAINT categQuali_poste_FK FOREIGN KEY (idPoste)
	  REFERENCES Poste (ID)
   );
   
  create sequence seqCATEGORIE_QUALIFICATION
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getseqCATEGORIE_QUALIFICATION
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqCATEGORIE_QUALIFICATION.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 

  
--Table heureSupFabrication
--id vachar
--idRessParFab varchar
--HS number
--MN number
--JF number
--HD number
--IF number

create table heureSupFabrication (
    id varchar(100) constraint heureSupFabrication_pk primary key,
    idRessParFab varchar(100),
    HS NUMBER(30,2),
    MN NUMBER(30,2),
    JF NUMBER(30,2),
    HD NUMBER(30,2),
    IF NUMBER(30,2)
);

create sequence seqheureSupFabrication
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getseqheureSupFabrication
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqheureSupFabrication.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 



--Table ressourceParFabrication
--id
--idFabrication
--idPoste
--idRessource  (foreign key id PAIE_INFO_PERSONNE) (dans RH)

CREATE TABLE PAIE_INFO_PERSONNEL 
   (	ID VARCHAR2(50) NOT NULL , 
	DATESAISIE DATE, 
	MATRICULE VARCHAR2(50), 
	LIEU_NAISSANCE_COMMUNE VARCHAR2(50), 
	LIEU_DELIVRANCE_CIN VARCHAR2(50), 
	SITUATION_MATRIMONIAL VARCHAR2(50), 
	INITIALE VARCHAR2(50), 
	CTURGENCE_NOM_PRENOM VARCHAR2(255), 
	CTURGENCE_TELEPHONE1 VARCHAR2(50), 
	CTURGENCE_TELEPHONE2 VARCHAR2(50), 
	CTURGENCE_TELEPHONE3 VARCHAR2(50), 
	IDCONJOINT VARCHAR2(50), 
	CODE_AGENCE_BANQUE VARCHAR2(50), 
	BANQUE_NUMERO_COMPTE VARCHAR2(50), 
	BANQUE_COMPTE_CLE VARCHAR2(50), 
	DATEEMBAUCHE DATE, 
	IDFONCTION VARCHAR2(50), 
	IDCATEGORIE VARCHAR2(50), 
	MODE_PAIEMENT VARCHAR2(50), 
	CLASSEE VARCHAR2(50), 
	INDICEGRADE NUMBER(*,0), 
	INDICE_FONCTIONNEL NUMBER(*,0), 
	MATRICULE_PATRON VARCHAR2(50), 
	STATUT VARCHAR2(50), 
	DROIT_HS VARCHAR2(1), 
	VEHICULEE NUMBER(*,0) DEFAULT 0, 
	ECHELON NUMBER(*,0), 
	ETAT NUMBER(*,0), 
	CTG VARCHAR2(50), 
	IDUSER VARCHAR2(50), 
	INDICE_CT NUMBER(*,0), 
	DATEPROMOTION DATE, 
	NUMERO_CNAPS VARCHAR2(50), 
	NUMERO_OSTIE VARCHAR2(50), 
	TEMPORAIRE NUMBER(*,0), 
	N_EMBAUCHE VARCHAR2(50), 
	DATE_DEPART DATE, 
	N_DEPART VARCHAR2(50), 
	NBENFANT NUMBER(*,0), 
	HEUREJOURNALIER NUMBER(30,2), 
	HEUREHEBDOMADAIRE NUMBER(30,2), 
	HEUREMENSUEL NUMBER(30,2), 
	INDESIRABLE NUMBER(*,0), 
	DUREE NUMBER(30,2), 
	TELEPHONE VARCHAR2(100), 
	MAIL VARCHAR2(500), 
	ADRESSE_LIGNE1 VARCHAR2(100), 
	ADRESSE_LIGNE2 VARCHAR2(100), 
	CODE_POSTAL VARCHAR2(100), 
	REGION VARCHAR2(100), 
	IDCATEGORIE_PAIE VARCHAR2(500), 
	IDQUALIFICATION VARCHAR2(500), 
	FORMATION VARCHAR2(1000), 
	DISCIPLINE VARCHAR2(1000), 
	ANNEEEXPERIENCE VARCHAR2(1000), 
	PERSONNEL_ETAT NUMBER(*,0), 
	PERIODE_ESSAI NUMBER(*,0), 
	DEBUTCONTRAT DATE, 
	FINCONTRAT DATE, 
	REFUSER NUMBER(*,0), 
	 CONSTRAINT PAIE_INFO_PERSONNEL_PK PRIMARY KEY (ID) , 
	 CONSTRAINT CATEGORIE_PAIE_FK FOREIGN KEY (IDCATEGORIE_PAIE)
	  REFERENCES CATEGORIE_PAIE (ID) , 
	 CONSTRAINT QUALIFICATION_PAIE_FK FOREIGN KEY (IDQUALIFICATION)
	  REFERENCES QUALIFICATION_PAIE (ID) 
   );

create table ressourceParFabrication (
    id varchar(100) constraint ressourceParFabrication_pk primary key,
    idFabrication varchar(255) CONSTRAINT resparfab_fab_fk REFERENCES FABRICATION(id),
    idPoste varchar(100) CONSTRAINT resparfab_poste_fk REFERENCES Poste(id),
    idRessource varchar(50) CONSTRAINT resparfab_ressource_fk REFERENCES PAIE_INFO_PERSONNEL(id)
);

create sequence seqressourceParFabrication
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getseqressourceParFabrication
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqressourceParFabrication.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 



--Vue
--ressourceParFabricationComplet
--ressourceParFabrication
--left join (matricule) PAIE_INFO_PERSONNE
--left join (idPoste) CATEGORIE_QUALIFICATION
--left join (idFabrication) FABRICATION
--taux horaire= montant/((40*52)/12)
--ressourceParFabricationCompletVise


ALTER TABLE RESSOURCEPARFABRICATION ADD etat int ;

ALTER TABLE HEURESUPFABRICATION ADD etat int;



CREATE OR REPLACE  VIEW ressourceParFabricationComplet 
AS 
SELECT 
r.id,
r.idFabrication,
r.idPoste AS idPosteEffective,
r.idRessource,
p.matricule,
f.IDOF,
r.etat ,
p.TEMPORAIRE,
p.IDQUALIFICATION AS IdQualificationEffective,
c.IDCATEGORIE,
c.idPoste AS idPosteDefaut,
c.IDQUALIFICATION AS IdQualificationDefaut,
CAST(c.montant/((40*52)/12) AS NUMBER(30,2) ) AS tauxhoraire,
h.HS ,
h.MN ,
h.JF ,
h.HD ,
h.IF ,
CASE 
	WHEN r.etat = 0 
	THEN 'ANNULEE'
	WHEN r.etat = 1 
	THEN 'CREE'
	WHEN r.etat = 11 
	THEN 'VISEE'
END AS etatlib
FROM ressourceParFabrication r 
LEFT JOIN PAIE_INFO_PERSONNEL p ON p.id = r.idRessource
LEFT JOIN CATEGORIE_QUALIFICATION c ON c.idposte = r.idposte
LEFT JOIN FABRICATION f ON f.id = r.idFabrication
LEFT JOIN heureSupFabrication h ON h.idRessParFab = r.id;


CREATE VIEW ressourceParFabComplet_Visee 
AS 
SELECT 
r.*
FROM  ressourceParFabricationComplet r 
WHERE r.etat = 11;


--ressourceparfabrication sy ny heuresupp



CREATE OR REPLACE VIEW heureSupFabrication_cpl
AS
SELECT 
h.*,
p.id AS  idPersonne,
r.idFabrication,
CASE 
	WHEN h.etat=0
	THEN 'ANNULEE'
	WHEN h.etat=1
	THEN 'CREE'
	WHEN h.etat=11
	THEN 'VISEE'
END AS etatlib,
p.CTURGENCE_NOM_PRENOM AS idPersonnelib
FROM HEURESUPFABRICATION h 
LEFT JOIN RESSOURCEPARFABRICATION r ON r.id = h.IDRESSPARFAB 
LEFT JOIN PAIE_INFO_PERSONNEL p ON p.id = r.idRessource;

CREATE OR REPLACE VIEW heureSupFabrication_cpl_visee
AS 
SELECT 
*
FROM heureSupFabrication_cpl WHERE etat = 11 ;