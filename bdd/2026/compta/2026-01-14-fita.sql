CREATE SEQUENCE seq_declaration_tva
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE FUNCTION getSeqDeclarationTva
RETURN NUMBER IS
BEGIN
    RETURN seq_declaration_tva.NEXTVAL;
END;

CREATE TABLE DeclarationTVA (
    id VARCHAR(100) PRIMARY KEY,
    designation VARCHAR(255),
    datyDebut DATE,
    datyFin DATE,
    etat Integer
);

CREATE OR REPLACE VIEW DeclarationTVALib AS
SELECT
    id,
    designation,
    datyDebut,
    datyFin,
    etat,
    CASE
        WHEN etat = 1 THEN 'Créé'
        WHEN etat = 11 THEN 'Validé'
        ELSE 'Inconnu'
    END AS etatLib
FROM DeclarationTVA;