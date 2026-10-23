CREATE TABLE ElementInspection (
                                   id    VARCHAR(100) PRIMARY KEY,
                                   val   VARCHAR(100),
                                   desce VARCHAR(255)
);
CREATE SEQUENCE seqelementInspection
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE FUNCTION getSeqelementInspection
    RETURN NUMBER IS
BEGIN
    RETURN seqelementInspection.NEXTVAL;
END;



CREATE TABLE ElementInspectionMachine (
                                   id    VARCHAR(100) PRIMARY KEY,
                                   idElementInspection   VARCHAR(100),
                                   idMachine   VARCHAR(100),
                                   CONSTRAINT fk_element_inspection
                                       FOREIGN KEY (idElementInspection)
                                           REFERENCES ElementInspection(id),
                                      CONSTRAINT fk_machine
                                        FOREIGN KEY (idMachine)
                                             REFERENCES Machine(id)
);
CREATE SEQUENCE seqelementInspectionMachine
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE FUNCTION getseqelementInspectionMachine
    RETURN NUMBER IS
BEGIN
    RETURN seqelementInspectionMachine.NEXTVAL;
END;

CREATE TABLE EtatInspection (
                                   id    VARCHAR(100) PRIMARY KEY,
                                   val   VARCHAR(100),
                                   desce VARCHAR(255)
);
CREATE SEQUENCE seqetatInspection
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE FUNCTION getSeqetatInspection
    RETURN NUMBER IS
BEGIN
    RETURN seqetatInspection.NEXTVAL;
END;




CREATE TABLE InspectionMere (
                                id VARCHAR(100) PRIMARY KEY,
                                daty          DATE NOT NULL,
                                heure         VARCHAR(10),
                                idInspecteur  VARCHAR(100),
                                idElement     VARCHAR(100),
                                remarque      VARCHAR(255),
                                etat          INTEGER,
                                CONSTRAINT fk_inspecteur
                                    FOREIGN KEY (idInspecteur)
                                        REFERENCES Personnel(id),

                                CONSTRAINT fk_element_mere
                                    FOREIGN KEY (idElement)
                                        REFERENCES As_Ingredient_Maintenance(id)
);


CREATE TABLE InspectionFille (
                                 id VARCHAR(100) PRIMARY KEY,
                                 idMere          VARCHAR(100),
                                 idElement       VARCHAR(100),
                                 idEtatInspection  VARCHAR(100),
                                 remarque        VARCHAR(255),
                                 CONSTRAINT fk_inspection_fille_mere
                                     FOREIGN KEY (idMere)
                                         REFERENCES InspectionMere(id),

                                 CONSTRAINT fk_inspection_fille_element
                                     FOREIGN KEY (idElement)
                                         REFERENCES ElementInspectionMachine(id),

                                CONSTRAINT fk_inspection_fille_etat
                                        FOREIGN KEY (idEtatInspection)
                                            REFERENCES EtatInspection(id)
);

CREATE SEQUENCE seq_inspection_mere
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE seq_inspection_fille
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE FUNCTION getSeqInspectionMere
    RETURN NUMBER IS
BEGIN
    RETURN seq_inspection_mere.NEXTVAL;
END;

CREATE OR REPLACE FUNCTION getSeqInspectionFille
    RETURN NUMBER IS
BEGIN
    RETURN seq_inspection_fille.NEXTVAL;
END;

CREATE OR REPLACE VIEW InspectionMereCPL AS
SELECT
    im.id,
    im.daty,
    im.heure,
    im.idInspecteur,
    p.nom        AS idInspecteurlib,
    im.idElement,
    aim.LIBELLE AS idElementlib,
    im.remarque,
    im.etat,
    CASE
        WHEN im.ETAT = 1
            THEN 'CREE'
        WHEN im.ETAT = 0
            THEN 'ANNULEE'
        WHEN im.ETAT = 11
            THEN 'VISEE'
        END AS ETATLIB
FROM InspectionMere im
         LEFT JOIN Personnel p
                   ON im.idInspecteur = p.id
         LEFT JOIN As_Ingredient_Maintenance aim
                   ON im.idElement = aim.id;

CREATE OR REPLACE VIEW InspectionFilleCPL AS
SELECT
    ifi.id,
    ifi.idElement,
    eis.val     AS idElementlib,
    ifi.idEtatInspection,
    ifi.remarque,
    ei.val    AS idEtatInspectionlib,
    m.VAL AS idMachinelib
FROM InspectionFille ifi
         LEFT JOIN ElementInspectionMachine ai
                   ON ifi.idElement = ai.id
        LEFT JOIN ElementInspection eis
                   ON ai.idElementInspection = eis.id
        LEFT JOIN MACHINE m
                   ON ai.idMachine = m.id
         LEFT JOIN EtatInspection ei
                   ON ifi.idEtatInspection = ei.id;


CREATE OR REPLACE VIEW ElementInspectionMachineLib AS
SELECT
    eim.id,
    eim.idElementInspection as idElementInspection,
    eim.idMachine as idMachine,
    ei.val      AS idElementInspectionLib,
    m.val       AS idMachineLib
FROM ElementInspectionMachine eim
         LEFT JOIN ElementInspection ei
                   ON eim.idElementInspection = ei.id
         LEFT JOIN Machine m
                   ON eim.idMachine = m.id;

