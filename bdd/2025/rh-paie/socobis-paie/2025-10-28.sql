--Periode de paie
--Creer table
--PERIODEPAIE
--id
--mois
--datedebut
--datefin
--etat
--creer sequence : getseqperiodepaie

create table PERIODEPAIE(
                            id varchar(255) constraint PERIODEPAIE_pk primary key ,
                            mois int,
                            datedebut DATE ,
                            datefin  DATE  ,
                            etat int
);


create sequence seqPERIODEPAIE
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;



CREATE OR REPLACE FUNCTION getseqPERIODEPAIE
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT seqPERIODEPAIE.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;