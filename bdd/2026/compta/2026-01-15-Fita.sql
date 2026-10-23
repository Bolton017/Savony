CREATE TABLE LiaisonCodeImpot (
                                  id          VARCHAR(250) PRIMARY KEY,
                                  idCodeImpot VARCHAR(250) ,
                                  idCompte    VARCHAR(250)
);

CREATE SEQUENCE seqLiaisonCodeImpot
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
CREATE OR REPLACE FUNCTION getSeqLiaisonCodeImpot
    RETURN NUMBER IS
BEGIN
    RETURN seqLiaisonCodeImpot.NEXTVAL;
END;

CREATE OR REPLACE VIEW LiaisonCodeSaisie AS
SELECT
    id,
    idCodeImpot,
    idCompte,
    '' AS valeur
FROM LiaisonCodeImpot;
