--créer table “seuilperteachat” Tiavina
--colonnes
--id
--idingredient references as_ingredients
--seuilperte number(5, 2)


create table seuilperteachat(
    id varchar(255) constraint seuilperteachat_pk primary key ,
    idingredient varchar(50) CONSTRAINT seuilperteachat_ingredient_fk REFERENCES AS_INGREDIENTS(id),
    seuilperte NUMBER(5,2) 
);


create sequence seqseuilperteachat
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getseqseuilperteachat
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqseuilperteachat.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 

--créer vue “st_ingredientsauto_seuil” Tiavina
--vue principale = ST_INGREDIENTSAUTO
--join seuilperteachat
--colonnes
--ST_INGREDIENTSAUTO
--izy rehetra
--seuilperteachat
--seuilperte

CREATE VIEW st_ingredientsauto_seuil 
AS 
SELECT 
s.*,
sp.seuilperte
FROM ST_INGREDIENTSAUTO s 
JOIN  seuilperteachat sp ON sp.idingredient = s.ID;


--créer table “referencefacture” Tiavina
--colonnes
--id
--idfacture
--reference

create table referencefacture(
    id varchar(255) constraint referencefacture_pk primary key ,
    idfacture varchar(255) ,
    reference varchar(255)
);


create sequence seqreferencefacture
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getseqreferencefacture
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqreferencefacture.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 


--créer table “ristourne” Tiavina
--colonnes
--id
--designation
--idclient
--daty
--datedebutristourne date
--datefinristourne date
--idorigine
--etat

create table ristourne(
    id varchar(255) constraint ristourne_pk primary key ,
    designation varchar(200) ,
    idclient varchar(255),
    daty DATE ,
    datedebutristourne DATE ,
    datefinristourne DATE ,
    idorigine varchar(255),
    etat int 
);


create sequence seqristourne
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getseqristourne
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqristourne.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 


--créer table ristournedetails Tiavina
--colonnes
--id
--idristourne references ristourne
--idproduit references as_ingredient
--taux1 number(5,2)
--taux2 number(5,2)
--idorigine


create table ristournedetails(
    id varchar(255) constraint ristournedetails_pk primary key ,
    idristourne varchar(255) CONSTRAINT ristourne_merefille_fk REFERENCES ristourne(id) ,
    idproduit varchar(50) CONSTRAINT ristournedetails_ingre_fk REFERENCES AS_INGREDIENTS(id),
    taux1 NUMBER(5,2),
    taux2 NUMBER(5,2),
    idorigine varchar(255)
);


create sequence seqristournedetails
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getseqristournedetails
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqristournedetails.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 



--créer table ristournefacture Tiavina
--colonnes
--id
--idfacture
--idristourne references ristourne
--montant
--daty
--etat


create table ristournefacture(
    id varchar(255) constraint ristournefacture_pk primary key ,
    idfacture varchar(255) ,
    idristourne varchar(255) CONSTRAINT ristournefacture_ristourne_fk REFERENCES ristourne(id) ,
    montant NUMBER(30,2),
    daty DATE ,
    etat int 
);


create sequence seqristournefacture
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getseqristournefacture
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqristournefacture.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 


CREATE TABLE DMDACHAT 
   (	ID VARCHAR2(50), 
	DATY DATE, 
	FOURNISSEUR VARCHAR2(50), 
	REMARQUE VARCHAR2(255), 
	ETAT NUMBER(*,0), 
	 PRIMARY KEY (ID), 
	 CONSTRAINT dmdachat_frns_fk FOREIGN KEY (FOURNISSEUR)
	  REFERENCES FOURNISSEUR (ID) 
   );


CREATE SEQUENCE SEQ_DMDACHAT INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION GETSEQDMDACHAT
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
    SELECT SEQ_DMDACHAT.nextval INTO retour FROM dual;
    return retour;
END;


CREATE TABLE DMDACHATFILLE 
   (	ID VARCHAR2(50), 
	IDMERE VARCHAR2(50), 
	IDPRODUIT VARCHAR2(50), 
	DESIGNATION VARCHAR2(255), 
	QUANTITE NUMBER(20,2), 
	PU NUMBER(20,2), 
	TVA NUMBER(20,2),
	qtestock number(30, 3),
	 PRIMARY KEY (ID), 
	 CONSTRAINT dmdachat_merefille_fk FOREIGN KEY (IDMERE)
	  REFERENCES DMDACHAT (ID) , 
	 CONSTRAINT dmdachatfille_prod_fk FOREIGN KEY (IDPRODUIT)
	  REFERENCES AS_INGREDIENTS (ID) 
   );

CREATE SEQUENCE SEQ_DMDACHATFILLE INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION GETSEQDMDACHATFILLE
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
    SELECT SEQ_DMDACHATFILLE.nextval INTO retour FROM dual;
    return retour;
END;

-- Tiavina
--Vente
--Avoir
--Saisie
--avoir/avoirFC-saisie.jsp
--Liste
--avoir/avoirFC-liste.jsp

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0001109001', 'Avoir', 'fa fa-truck', NULL, 3, 2, 'MNDN000000001');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0001109002', 'Saisie', 'fa fa-plus', 'module.jsp?but=avoir/avoirFC-saisie.jsp', 1, 3, 'MNDN0001109001');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0001109003', 'Liste', 'fa fa-list', 'module.jsp?but=avoir/avoirFC-liste.jsp', 2, 3, 'MNDN0001109001');

--menu 
--ao amin ACHAT
--Mere : Demande d'Achat
--saisie : facturefournisseur/dmdachat/dmdachat-saisie.jsp
-- 
--liste : facturefournisseur/dmdachat/dmdachat-liste.jsp
-- 

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN00110901146001', 'Demande d`Achat', 'fa fa-line-chart', NULL, 5, 2, 'MNDN000000002');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN00110901146002', 'Saisie', 'fa fa-plus', 'module.jsp?but=facturefournisseur/dmdachat/dmdachat-saisie.jsp', 1, 3, 'MNDN00110901146001');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN00110901146003', 'Liste', 'fa fa-list', 'module.jsp?but=facturefournisseur/dmdachat/dmdachat-liste.jsp', 2, 3, 'MNDN00110901146001');

--modifier vue “ST_INGREDIENTSAUTO” (Tiavina)
--atao jointure am etat de stock en cours de ampiakarina ny colonne quantité reste

CREATE OR REPLACE  VIEW ST_INGREDIENTSAUTO (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT, IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO, PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE, COMPTE_ACHAT, COMPTE, UNITELIB,QUANTITE,RESTE) AS 
  SELECT
    ai.ID,ai.LIBELLE,ai.SEUIL,au.val AS UNITE,ai.QUANTITEPARPACK,ai.PU,ai.ACTIF,ai.PHOTO,ai.CALORIE,ai.DURRE,ai.COMPOSE,ai.CATEGORIEINGREDIENT,ai.IDFOURNISSEUR,ai.DATY,ai.QTELIMITE,ai.PV,ai.LIBELLEVENTE,ai.SEUILMIN,ai.SEUILMAX,ai.PUACHATUSD,ai.PUACHATEURO,ai.PUACHATAUTREDEVISE,ai.PUVENTEUSD,ai.PUVENTEEURO,ai.PUVENTEAUTREDEVISE,ai.ISVENTE,ai.ISACHAT,ai.COMPTE_VENTE,ai.COMPTE_ACHAT,
    CASE
        WHEN ai.COMPTE_VENTE IS NOT NULL THEN ai.COMPTE_VENTE
        ELSE ai.COMPTE_ACHAT
    END AS compte,
    au.VAL AS UNITELIB,
    nvl(v.QUANTITE,0) AS QUANTITE ,
    nvl(v.RESTE,0) AS RESTE
FROM AS_INGREDIENTS ai
LEFT JOIN AS_UNITE au  ON au.id = ai.UNITE 
LEFT JOIN V_ETATSTOCK_ING v ON v.ID = ai.ID AND v.UNITE = ai.UNITE ;

CREATE VIEW ristournelib 
AS
SELECT 
r.*,
c.nom AS idclientlib,
CASE 
	WHEN r.etat = 0 
	THEN 'ANNULÉE'
	WHEN r.etat = 1 
	THEN 'CRÉE'
	WHEN r.etat = 11 
	THEN 'VISÉE'
END AS etatlib
FROM RISTOURNE r 
LEFT JOIN CLIENT c ON r.idclient = c.id ;