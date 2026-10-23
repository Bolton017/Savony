-- auto-generated definition
create table CAISSESESSION
(
    ID              VARCHAR2(255) not null,
    DATEOUVERTURE   DATE          not null,
    HEUREOUVERTURE  VARCHAR2(10),
    DATEFERMETURE   DATE,
    HEUREFERMETURE  VARCHAR2(10),
    IDUSEROUVERTURE VARCHAR2(255) not null,
    IDUSERFERMETURE VARCHAR2(255),
    ETAT            NUMBER,
    IDPOINT         VARCHAR2(255),
    IDCAISSE        VARCHAR2(255)
);

alter table REPORTCAISSE add idUser VARCHAR2(255);
alter table REPORTCAISSE add TYPEREPORT VARCHAR2(255);

create or replace view REPORTCAISSE_SAISIE as
SELECT
    r.ID ,
    r.IDCAISSE ,
    c.VAL AS CAISSELIB,
    CAST(r.MONTANT AS NUMBER(30,5)) AS MONTANT ,
    CAST(r.MONTANTTHEORIQUE AS NUMBER(30,5)) AS MONTANTTHEORIQUE ,
    r.DATY ,
    r.ETAT ,r.heure,
    CASE
        WHEN r.ETAT = 0
            THEN 'ANNULEE'
        WHEN r.ETAT = 1
            THEN 'CREE'
        WHEN r.ETAT = 11
            THEN 'VALIDEE'
        END AS ETATLIB,
    r.idUser,
    r.TYPEREPORT,
    '' AS billetage
FROM CAISSE c
         LEFT JOIN REPORTCAISSE r ON c.ID  = r.IDCAISSE;