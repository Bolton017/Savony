CREATE TABLE demandeAvis (
    id varchar(255) primary key,
    demandeur VARCHAR(255),
    personneCible varchar(255),
    daty date,
    heure varchar(255),
    idObjet varchar(255)
);

CREATE SEQUENCE SEQ_demandeAvis INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION GETSEQdemandeAvis
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
SELECT SEQ_demandeAvis.nextval INTO retour FROM dual;
return retour;
END;

select * from demandeAvis;


CREATE or replace VIEW UTILISATEURSTR AS
SELECT
    TO_CHAR(u.REFUSER) AS REFUSERSTR,
    u.REFUSER,
    u.LOGINUSER,
    u.PWDUSER,
    u.NOMUSER,
    u.ADRUSER,
    u.TELUSER,
    u.IDROLE,
    u.IDSERVICE,
    u.IDDEPARTEMENT
FROM UTILISATEUR u;
