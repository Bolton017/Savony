CREATE TABLE CommentaireOF (
                               id varchar(200) PRIMARY KEY,
                               idObjet varchar(200),
                               Val VARCHAR2(1000),
                               idPersonnel VARCHAR(200),
                               FOREIGN KEY (idPersonnel)
                                   REFERENCES log_personnel(id),
                               FOREIGN KEY (idObjet)
                                   REFERENCES OFAB(id)
);


CREATE SEQUENCE SeqCommOF INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE NOCACHE NOORDER;

CREATE OR REPLACE FUNCTION getSeqCommOF
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
SELECT SeqCommOF.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;
