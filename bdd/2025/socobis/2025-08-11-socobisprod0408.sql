--Gestion de gaz et de gazoil 
--base (TIAVINA)
--magasin2
--ampiana colonne
--capacite double
--compteur double
--idMagasinMere String  (FK am tenn ian)

ALTER TABLE MAGASIN2 ADD capacite NUMBER(30,2);

ALTER TABLE MAGASIN2 ADD compteur NUMBER(30,2);

ALTER TABLE MAGASIN2 ADD idMagasinMere varchar(255) CONSTRAINT magasin2_mere_fk REFERENCES MAGASIN2(id) ;

--machine
--id val desce

create table MACHINE(
    id varchar(255) constraint MACHINE_pk primary key ,
    val varchar(255) ,
    desce varchar(255)
);


create sequence seqMACHINE
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getseqMACHINE
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqMACHINE.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 

--table compteur
--id
--nombre
--idFabrication
--idMachine
--daty
--heure string
--debut

create table COMPTEUR(
    id varchar(255) constraint COMPTEUR_pk primary key ,
    nombre NUMBER(30,2),
    idFabrication varchar(255) ,
    idMachine varchar(255),
    daty DATE ,
    heure varchar(50),
    debut NUMBER(30,2)  
);


create sequence seqCOMPTEUR
      minvalue 1
      maxvalue 999999999999
      start with 1
      increment by 1
      cache 20;
      
      

CREATE OR REPLACE FUNCTION getseqCOMPTEUR
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT seqCOMPTEUR.NEXTVAL INTO retour FROM DUAL;

   RETURN retour;
END; 

--table FABRICATIONFILLE
--ampina idMachine (FK machine)

ALTER TABLE FABRICATIONFILLE ADD idMachine varchar(255) CONSTRAINT fabfille_machine_fk REFERENCES MACHINE(id);

--base (Tiavina)
--demandetransfert
--asiana idFabrication fk fabrication

ALTER TABLE DEMANDETRANSFERT ADD idFabrication varchar(255) CONSTRAINT demtrans_fab_fk REFERENCES FABRICATION(id);