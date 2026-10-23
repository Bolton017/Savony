
CREATE TABLE MOTravaux
(
    ID              VARCHAR2(50) NOT NULL PRIMARY KEY,
    IDPERSONNEL     VARCHAR2(50),
    DUREEESTIMATIF  NUMBER(10, 2),
    TAUXHORAIRE     NUMBER(10, 2),
    IDTRAVAUX       VARCHAR2(50),
    CONSTRAINT fk_motravaux_personnel FOREIGN KEY (IDPERSONNEL) 
        REFERENCES Personnel(ID)
);


CREATE SEQUENCE seqMOTravaux;

CREATE FUNCTION getSeqMOTravaux RETURN NUMBER IS 
    retour NUMBER;
BEGIN
    SELECT seqMOTravaux.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;

create or replace view MOTravauxLib as
select 
  MO.*, 
  P.NOM  AS NOMPERSONNEL    
from MOTravaux MO
LEFT JOIN Personnel P ON P.ID = MO.IDPERSONNEL;