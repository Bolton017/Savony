CREATE OR REPLACE VIEW IMPRIMEDECLARATIONLIB AS
SELECT 
    i.*,
    0 AS montant,
    0 AS montantadeclarer
FROM IMPRIMEDECLARATION i;




ALTER TABLE IMPRIMEDECLARATION
ADD Taux NUMBER(10,2);



CREATE TABLE LiaisonCodeImpot (
    id NUMBER PRIMARY KEY,
    idCodeImpot NUMBER NOT NULL,
    idCompte NUMBER NOT NULL
);


CREATE SEQUENCE seqLiaisonCodeImpot
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE FUNCTION getSeqLiaisonCodeImpot
RETURN NUMBER
IS
    v_next_val NUMBER;
BEGIN
    SELECT seqLiaisonCodeImpot.NEXTVAL INTO v_next_val FROM DUAL;
    RETURN v_next_val;
END;
/


CREATE OR REPLACE VIEW LiaisonCodeSaisie AS
SELECT 
    id,
    idCodeImpot,
    idCompte,
    ' ' AS valeur
FROM LiaisonCodeImpot;