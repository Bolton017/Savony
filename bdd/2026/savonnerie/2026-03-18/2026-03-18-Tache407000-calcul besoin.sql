create table CALCULBESOIN
(
    ID          VARCHAR2(250) not null
        primary key,
    DATY        DATE,
    DESIGNATION VARCHAR2(500),
    ETAT        NUMBER,
    IDMAGASIN   VARCHAR2(255)
);

CREATE SEQUENCE seqCalculBesoin;

CREATE OR REPLACE FUNCTION getSeqCalculBesoin
RETURN NUMBER
IS
    retour NUMBER;
BEGIN
SELECT seqCalculBesoin.NEXTVAL
INTO retour
FROM DUAL;

RETURN retour;
END;

create table CALCULBESOINFILLE
(
    ID        VARCHAR2(250) not null primary key,
    IDPRODUIT VARCHAR2(250),
    QTE       NUMBER(10, 3),
    IDMERE    VARCHAR2(255)
);

CREATE SEQUENCE seqCalculBesoinFille;

CREATE OR REPLACE FUNCTION getSeqCalculBesoinFille
RETURN NUMBER
IS
    retour NUMBER;
BEGIN
SELECT seqCalculBesoinFille.NEXTVAL
INTO retour
FROM DUAL;

RETURN retour;
END;
