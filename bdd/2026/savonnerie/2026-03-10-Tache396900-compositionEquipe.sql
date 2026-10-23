CREATE TABLE compositionEquipe (
    ID VARCHAR(255) PRIMARY KEY,
    DATY DATE,
    IdEquipe varchar(255),
    idPersonnel VARCHAR(255),
    remarque VARCHAR(255),
    FOREIGN KEY (IdEquipe) references Equipe(id),
    FOREIGN KEY (idPersonnel) references log_personnel(id)
);


CREATE SEQUENCE SEQ_compositionEquipe INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION GETSEQcompositionEquipe
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
SELECT SEQ_compositionEquipe.nextval INTO retour FROM dual;
return retour;
END;
