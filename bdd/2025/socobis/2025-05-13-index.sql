-- creation table classeEtFiche avec view

create table CLASSEETFICHE (
    id varchar(255),
    classe varchar(255),
    fiche varchar(255),
    libelle varchar(255)
);

create sequence SEQ_v_ClassEtFiche
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

CREATE OR REPLACE FUNCTION GETSEQ_v_ClassEtFiche
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
SELECT SEQ_v_ClassEtFiche.NEXTVAL INTO retour FROM DUAL;
RETURN retour;
END;

create or replace view v_classeetfiche as
select
    id, classe, fiche,
    nvl(libelle, REGEXP_SUBSTR(classe, '[^\.]+', 1, REGEXP_COUNT(classe, '\.') + 1)) as libelle
from CLASSEETFICHE;


-- creation table histoInsert avec view

CREATE TABLE HistoInsert 
   (	IDHISTORIQUE VARCHAR2(20) NOT NULL , 
	DATEHISTORIQUE DATE, 
	HEURE VARCHAR2(25), 
	OBJET VARCHAR2(100), 
	ACTION VARCHAR2(50), 
	IDUTILISATEUR NUMBER NOT NULL , 
	REFOBJET VARCHAR2(255), 
	remarque VARCHAR2(255),
	 CONSTRAINT HISTOINSERT_PK PRIMARY KEY (IDHISTORIQUE)
   );

create sequence SEQ_HistoInsert
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;


CREATE OR REPLACE FUNCTION GETSEQ_HistoInsert
   RETURN NUMBER
IS
   retour   NUMBER;
BEGIN
   SELECT SEQ_HistoInsert.NEXTVAL INTO retour FROM DUAL;
   RETURN retour;
END;

create or replace view V_HISTOINSERT as
select
    hi."IDHISTORIQUE",hi."DATEHISTORIQUE",hi."HEURE",hi."OBJET",hi."ACTION",hi."IDUTILISATEUR",hi."REFOBJET",hi."REMARQUE"|| ' ' ||hi.REFOBJET||' '||hi.datehistorique as remarque,
    cf.FICHE
from HISTOINSERT hi
         left join V_CLASSEETFICHE cf on cf.CLASSE = hi.OBJET;