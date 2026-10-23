
CREATE TABLE RAPPROCHEMENTBC
(
    ID                      VARCHAR(250) PRIMARY KEY,
    idSousEcriture             VARCHAR(250),
    idReleverDetail         VARCHAR(250),
    valeurSousEcriture         NUMBER,
    valeurReleverDetail     NUMBER,
    DATY                    DATE,
    etat                   NUMBER
);

CREATE SEQUENCE seqRapprochementBC;

CREATE OR REPLACE FUNCTION getSeqRapprochementBC 
RETURN NUMBER 
IS 
    retour NUMBER;
BEGIN
    SELECT seqRapprochementBC.NEXTVAL
    INTO retour
    FROM DUAL;
    
    RETURN retour;
END;


CREATE OR REPLACE VIEW SousEcritureNR AS
SELECT 
    cse.ID,
    cse.LIBELLEPIECE,
    cse.DEBIT,
    cse.CREDIT,
    cse.DATY
FROM COMPTA_SOUS_ECRITURE cse
    JOIN COMPTA_ECRITURE ce ON ce.ID = cse.idmere
WHERE 
    ce.ETAT >= 11
    AND cse.ID NOT IN (
        SELECT idSousEcriture 
        FROM RAPPROCHEMENTBC 
        WHERE idSousEcriture IS NOT NULL
    )
    AND ce.JOURNAL = 'COMP000036';

INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1766386514657608', 'Rapprochement', 'sticky_note_2', '', 7, 2, 'MNDN274');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN176638653912454', 'Async - RIB', 'list_alt', 'module.jsp?but=rapprochement/async-rib.jsp', 1, 3, 'MENDYN1766386514657608');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN17663865543083', 'RIB - Async', 'list_alt', 'module.jsp?but=rapprochement/rib-async.jsp', 2, 3, 'MENDYN1766386514657608');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1766386571510101', 'Automatique', 'list_alt', 'module.jsp?but=rapprochement/automatique.jsp', 3, 3, 'MENDYN1766386514657608');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1766386603290909', 'Relever', 'list_alt', 'module.jsp?but=rapprochement/liste-relever.jsp', 4, 3, 'MENDYN1766386514657608');


CREATE OR REPLACE VIEW ReleverDetailNR AS
SELECT 
    rd.ID,
    rd.DESIGNATION,
    rd.DEBIT,
    rd.CREDIT,
    rd.DATYVALEUR
FROM RELEVERDETAIL rd
    JOIN RELEVER r ON r.ID = rd.IDMERE
WHERE 
    r.ETAT >= 11
    AND rd.ID NOT IN (
        SELECT IDRELEVERDETAIL 
        FROM RAPPROCHEMENTBC 
        WHERE IDRELEVERDETAIL IS NOT NULL
    );

