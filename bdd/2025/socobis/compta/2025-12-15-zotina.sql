
CREATE TABLE Relever
(
    ID        VARCHAR2(50) NOT NULL PRIMARY KEY,
    DATY      DATE,
    IDCAISSE  VARCHAR2(50),
    ETAT      NUMBER(2)
);

CREATE SEQUENCE seqRelever;

CREATE FUNCTION getSeqRelever RETURN NUMBER IS 
    retour NUMBER;
BEGIN
    SELECT seqRelever.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;


CREATE TABLE ReleverDetail
(
    ID           VARCHAR2(50) NOT NULL PRIMARY KEY,
    IDMERE       VARCHAR2(50),
    DATY         DATE,
    DATYVALEUR   DATE,
    DESIGNATION  VARCHAR2(250),
    DEBIT        NUMBER(10, 2),
    CREDIT       NUMBER(10, 2),
    CONSTRAINT fk_releverdetail_relever FOREIGN KEY (IDMERE) REFERENCES Relever(ID)
);

CREATE SEQUENCE seqReleverDetail;

CREATE FUNCTION getSeqReleverDetail RETURN NUMBER IS 
    retour NUMBER;
BEGIN
    SELECT seqReleverDetail.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;



CREATE TABLE Rapprochement
(
    ID               VARCHAR2(50) NOT NULL PRIMARY KEY,
    IDRELEVERDETAIL  VARCHAR2(50),
    IDSECRITURE      VARCHAR2(50),
    DATE_RAPPROCH    DATE,
    ETAT             NUMBER(2),
    CONSTRAINT fk_rapprochement_detail FOREIGN KEY (IDRELEVERDETAIL) REFERENCES ReleverDetail(ID)
);

CREATE SEQUENCE seqRapprochement;

CREATE FUNCTION getSeqRapprochement RETURN NUMBER IS 
    retour NUMBER;
BEGIN
    SELECT seqRapprochement.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;
