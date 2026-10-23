
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDNAN001', 'Proforma', 'fa fa-book', null, 8, 2, 'MNDN000000001');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDNAN002', 'Liste', 'fa fa-list', 'module.jsp?but=vente/proforma/proforma-liste.jsp', 2, 3, 'MNDNAN001');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDNAN003', 'Saisie', 'fa fa-plus', 'module.jsp?but=vente/proforma/proforma-saisie.jsp', 1, 3, 'MNDNAN001');


INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDN00050500002', 'Editer Ristourne ', 'fa fa-list', 'module.jsp?but=vente/vente-paiement-multiple.jsp', 9, 2, 'MNDN000000001');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDN00050500002L', 'Liste Ristourne', 'fa fa-list', 'module.jsp?but=ristourne/ristourne-liste.jsp', 9, 2, 'MNDN000000001');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDN0001109001', 'Avoir', 'fa fa-truck', null, 3, 2, 'MNDN000000001');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDN0001109002', 'Saisie', 'fa fa-plus', 'module.jsp?but=avoir/avoirFC-saisie.jsp', 1, 3, 'MNDN0001109001');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDN0001109003', 'Liste', 'fa fa-list', 'module.jsp?but=avoir/avoirFC-liste.jsp', 2, 3, 'MNDN0001109001');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('ELM01', 'Planning', 'fa fa-calendar', 'module.jsp?but=vente/vente-paiement-calendrier.jsp', 3, 2, 'MNDN000000001');


create table PROFORMA
(
    ID            VARCHAR2(255) not null
        primary key,
    DESIGNATION   VARCHAR2(255),
    IDMAGASIN     VARCHAR2(255) not null,
    DATY          DATE          not null,
    REMARQUE      VARCHAR2(255),
    ETAT          NUMBER,
    IDORIGINE     VARCHAR2(255),
    IDCLIENT      VARCHAR2(100)
        references CLIENT,
    ESTPREVU      NUMBER(1),
    DATYPREVU     DATE,
    IDRESERVATION VARCHAR2(100),
    TVA           NUMBER(10, 2),
    ECHEANCE      VARCHAR2(255),
    REGLEMENT     VARCHAR2(255),
    REMISE        NUMBER(5, 2)
);

create table PROFORMA_DETAILS
(
    ID                 VARCHAR2(255) not null
        primary key,
    IDPROFORMA         VARCHAR2(255)
        references PROFORMA,
    IDPRODUIT          VARCHAR2(255),
    IDORIGINE          VARCHAR2(255),
    QTE                NUMBER,
    PU                 NUMBER(30, 2),
    REMISE             NUMBER(30, 2),
    TVA                NUMBER(30, 2),
    PUACHAT            NUMBER(30, 2),
    PUVENTE            NUMBER(30, 2),
    IDDEVISE           VARCHAR2(100)
        references DEVISE,
    TAUXDECHANGE       NUMBER(30, 2),
    DESIGNATION        VARCHAR2(250),
    COMPTE             VARCHAR2(255),
    PUREVIENT          NUMBER(20, 2),
    IDDEMANDEPRIXFILLE VARCHAR2(255),
    UNITE              VARCHAR2(255)
        constraint PROFORMDET_UNITE_FK
            references AS_UNITE,
    DATEDEBUT          DATE
);

-- auto-generated definition
create sequence SEQ_PROFORMA
    nocache
/

create FUNCTION getseqproforma
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_PROFORMA.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;
/

create sequence SEQ_PROFORMA_DETAILS
    nocache
/

create FUNCTION getseqproformadetails
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_PROFORMA_DETAILS.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;
/



create view PROFORMAMONTANT2 as
SELECT v.ID,
       cast(SUM ((NVL (vd.QTE, 0) * NVL (vd.PU, 0))) as number(30,2)) AS montant,
       cast(SUM ((1-nvl(vd.remise/100,0))*(NVL (vd.QTE, 0) * NVL (vd.PU, 0))) as number(30,2)) AS montanttotal,
       cast(SUM ((NVL (vd.QTE, 0) * NVL (vd.PU, 0))) as number(30,2)) - cast(SUM ((1-nvl(vd.remise/100,0))*(NVL (vd.QTE, 0) * NVL (vd.PU, 0))) as number(30,2)) as montantremise,
       cast(SUM ( (NVL (vd.QTE, 0) * NVL (vd.PuAchat, 0))) as number(30,2)) AS montanttotalachat,
       cast(SUM ((1-nvl(vd.remise/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0))* (NVL (VD.TVA , 0))/100) as number(30,2)) AS montantTva,
       cast(SUM ((1-nvl(vd.remise/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0))* (NVL (VD.TVA , 0))/100)+SUM ((1-nvl(vd.remise/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0)))as number(30,2))  as montantTTC,
       NVL (vd.IDDEVISE,'AR') AS IDDEVISE,
       NVL(avg(vd.tauxDeChange),1 ) AS tauxDeChange,
       cast(SUM ( (1-nvl(vd.remise/100,0))*(NVL (vd.QTE, 0) * NVL (vd.PU, 0)*NVL(VD.TAUXDECHANGE,1) )* (NVL (VD.TVA , 0))/100)+SUM ((1-nvl(vd.remise/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0)*NVL(VD.TAUXDECHANGE,1)))as number(30,2)) as montantTTCAR,
       cast(sum(vd.PUREVIENT*vd.QTE) as number(20,2)) as montantRevient  ,
       v.IDRESERVATION
FROM PROFORMA_DETAILS vd LEFT JOIN PROFORMA v ON v.ID = vd.IDPROFORMA
GROUP BY v.ID, vd.IDDEVISE,v.IDRESERVATION;

create view PROFORMA_CPL as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CREE'
           WHEN v.ETAT = 11 THEN 'VISEE'
           WHEN v.ETAT = 0 THEN 'ANNULEE'
           END
             AS ETATLIB,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM AS IDCLIENTLIB,
       c.ADRESSE,
       c.TELEPHONE AS CONTACT,
       cast(V2.montant as number(30,2)) as montant,
       v2.MONTANTTOTAL,
       cast(V2.montantremise as number(30,2)) as MONTANTREMISE,
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.credit,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
       cast(V2.MONTANTTTC-nvl(mv.credit,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
       nvl(ACG.MONTANTTTC_avr, 0)  as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       v.IDORIGINE,
       v.remise
FROM PROFORMA v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
         JOIN PROFORMAMONTANT2 v2 ON v2.ID = v.ID
         LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id=mv.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID;

create view PROFORMADETAILS_CPL as
SELECT
    vd.ID,vd.IDPROFORMA,vd.IDPRODUIT,vd.IDORIGINE,vd.QTE,vd.PU,vd.REMISE,vd.TVA,vd.PUACHAT,vd.PUVENTE,vd.IDDEVISE,vd.TAUXDECHANGE,vd.DESIGNATION,vd.COMPTE,vd.PUREVIENT,vd.IDDEMANDEPRIXFILLE,
    v.DESIGNATION    AS IDPROFORMALIB,
    p.LIBELLE            AS IDPRODUITLIB,
    cast((vd.QTE * vd.PU) as NUMBER(30,2)) AS puTotal,
    vd.unite,
    au.val AS uniteLib,
    cast(((vd.QTE * vd.PU)*NVL(vd.remise, 0))/100 as NUMBER(30,2)) AS remisemontant,
    cast((vd.QTE * vd.PU)-((vd.QTE * vd.PU)*NVL(vd.remise, 0))/100 as NUMBER(30,2)) as montanttotal,
    (nvl(vd.TVA, 0)/100)*cast((vd.QTE * vd.PU)-((vd.QTE * vd.PU)*NVL(vd.remise, 0))/100 as NUMBER(30,2)) as montanttva,
    cast((vd.QTE * vd.PU)-((vd.QTE * vd.PU)*NVL(vd.remise, 0))/100 as NUMBER(30,2))+(nvl(vd.TVA, 0)/100)*cast((vd.QTE * vd.PU)-((vd.QTE * vd.PU)*NVL(vd.remise, 0))/100 as NUMBER(30,2)) as montantttc,
    vd.datedebut
--       d2.id AS idDevis
FROM PROFORMA_DETAILS vd
         LEFT JOIN PROFORMA v ON v.ID = vd.IDPROFORMA
         LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
         LEFT JOIN AS_UNITE au ON au.id = vd.unite;


create table LIAISONPAIEMENT
(
    ID      VARCHAR2(100) not null
        primary key,
    ID1     VARCHAR2(100),
    ID2     VARCHAR2(100),
    MONTANT NUMBER(30, 2),
    ETAT    NUMBER
)
/

-- auto-generated definition
create sequence SEQLIAISONPAIEMENT
    maxvalue 999999999999
/

create FUNCTION getseqLiaisonPaiement
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seqLiaisonPaiement.NEXTVAL INTO retour FROM DUAL;
    RETURN retour;
END;
/



create view LIAISONPAIEMENTTOTAL as
select id2,sum(nvl(montant,0)) as montant from LIAISONPAIEMENT where etat>=11 group by id2
/

create table REFERENCEFACTURE
(
    ID        VARCHAR2(255) not null
        constraint REFERENCEFACTURE_PK
            primary key,
    IDFACTURE VARCHAR2(255),
    REFERENCE VARCHAR2(255)
)
/
create sequence SEQREFERENCEFACTURE
    maxvalue 999999999999
/


create FUNCTION getseqreferencefacture
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seqreferencefacture.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;
/



create or replace view VENTE_CPL as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CREE'
           WHEN v.ETAT = 11 THEN 'VISEE'
           WHEN v.ETAT = 0 THEN 'ANNULEE'
           END
             AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM AS IDCLIENTLIB,
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.montant,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
       cast(V2.MONTANTTTC-nvl(mv.montant,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30,2))  as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then daty else V.DATYPREVU end as datyprevu,
       rf.REFERENCE as referencefacture
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id=mv.id2
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
/

create view VENTENONPAYE as
select ID,
       DESIGNATION,
       IDMAGASIN,
       IDMAGASINLIB,
       DATY,
       REMARQUE,
       ETAT,
       ETATLIB,
       MONTANTTOTAL,
       IDDEVISE,
       IDCLIENT,
       IDCLIENTLIB,
       MONTANTTVA,
       MONTANTTTC,
       MONTANTTTCAR,
       MONTANTPAYE,
       MONTANTRESTE,
       AVOIR,
       TAUXDECHANGE,
       MONTANTREVIENT,
       MARGEBRUTE,
       IDRESERVATION,
       DATYPREVU
from VENTE_CPL
where MONTANTRESTE > 0
  and ETAT >= 11
/

create table RISTOURNE
(
    ID                 VARCHAR2(255) not null
        constraint RISTOURNE_PK
            primary key,
    DESIGNATION        VARCHAR2(200),
    IDCLIENT           VARCHAR2(255),
    DATY               DATE,
    DATEDEBUTRISTOURNE DATE,
    DATEFINRISTOURNE   DATE,
    IDORIGINE          VARCHAR2(255),
    ETAT               NUMBER
)
/
create sequence SEQRISTOURNE
    maxvalue 999999999999
/

create FUNCTION getseqristourne
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seqristourne.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;
/


create view RISTOURNELIB as
SELECT
    r.ID,r.DESIGNATION,r.IDCLIENT,r.DATY,r.DATEDEBUTRISTOURNE,r.DATEFINRISTOURNE,r.IDORIGINE,r.ETAT,
    c.nom AS idclientlib,
    CASE
        WHEN r.etat = 0
            THEN 'ANNULEE'
        WHEN r.etat = 1
            THEN 'CREE'
        WHEN r.etat = 11
            THEN 'VISEE'
        END AS etatlib
FROM RISTOURNE r
         LEFT JOIN CLIENT c ON r.idclient = c.id
/

create table RISTOURNEDETAILS
(
    ID          VARCHAR2(255) not null
        constraint RISTOURNEDETAILS_PK
            primary key,
    IDRISTOURNE VARCHAR2(255)
        constraint RISTOURNE_MEREFILLE_FK
            references RISTOURNE,
    IDPRODUIT   VARCHAR2(50)
        constraint RISTOURNEDETAILS_INGRE_FK
            references AS_INGREDIENTS,
    TAUX1       NUMBER(5, 2),
    TAUX2       NUMBER(5, 2),
    IDORIGINE   VARCHAR2(255)
)
/

create sequence SEQRISTOURNEDETAILS
    maxvalue 999999999999
/


create FUNCTION getseqristournedetails
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seqristournedetails.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;
/

create table RISTOURNEFACTURE
(
    ID          VARCHAR2(255) not null
        constraint RISTOURNEFACTURE_PK
            primary key,
    IDFACTURE   VARCHAR2(255),
    IDRISTOURNE VARCHAR2(255)
        constraint RISTOURNEFACTURE_RISTOURNE_FK
            references RISTOURNE,
    MONTANT     NUMBER(30, 2),
    DATY        DATE,
    ETAT        NUMBER
)
/

create sequence SEQRISTOURNEFACTURE
    maxvalue 999999999999
/


create FUNCTION getseqristournefacture
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seqristournefacture.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;
/


create view RISTOURNEDETAILS_LIB as
SELECT
    r.Id,
    r.idristourne,
    r.idproduit,
    r.taux1,
    r.taux2,
    r.idorigine,
    ai.libelle AS idproduitlib
FROM RISTOURNEDETAILS r
         LEFT JOIN AS_INGREDIENTS ai ON ai.id=r.idproduit
/

create or replace view VENTE_DETAILS_LIB as
SELECT vd.ID,
       vd.IDVENTE,
       v.DESIGNATION    AS IDVENTELIB,
       vd.IDPRODUIT,
       p.LIBELLE            AS IDPRODUITLIB,
       vd.IDORIGINE,
       vd.QTE,
       vd.PU,
       cast((vd.QTE * vd.PU) as NUMBER(30,2)) AS puTotal,
       vd.PuAchat AS PUACHAT,
       v.IDRESERVATION
FROM VENTE_DETAILS vd
         LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
         LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
/

alter table AVOIRFCFILLE drop constraint AVFCFILLE_PRODUIT_FK;

create view MOUVEMENTCAISSE_DETAIL as
select v.ID,v.DESIGNATION,v.IDMAGASIN,v.IDMAGASINLIB,v.DATY,v.REMARQUE,v.ETAT,v.ETATLIB,v.MONTANTTOTAL,v.IDDEVISE,v.IDCLIENT,v.IDCLIENTLIB,v.MONTANTTVA,v.MONTANTTTC,v.MONTANTTTCAR,v.MONTANTPAYE,v.MONTANTRESTE,v.AVOIR,v.TAUXDECHANGE,v.MONTANTREVIENT,v.MARGEBRUTE,v.IDRESERVATION,mv.id as idobjet from VENTE_CPL v left join MOUVEMENTCAISSECPL mv on v.id=mv.idorigine
/


create or replace view MOUVEMENTCAISSECPL as
SELECT m.ID,
       m.DESIGNATION,
       m.IDCAISSE,
       c.VAL   AS IDCAISSELIB,
       m.IDVENTEDETAIL,
       m.IDVIREMENT,
       m.DEBIT,
       m.CREDIT,
       m.DATY,
       m.ETAT,
       CASE
           WHEN m.ETAT = 0
               THEN 'ANNULEE'
           WHEN m.ETAT = 1
               THEN 'CREE'
           WHEN m.ETAT = 11
               THEN 'VALIDEE'
           END AS ETATLIB,
       vd.IDVENTE,
       l.id2 as idorigine,
       m.idtiers,
       t.NOM AS tiers,
       m.idPrevision,
       m.idOP,
       m.taux,
       m.COMPTE,
       m.IDDEVISE
FROM MOUVEMENTCAISSE m
         LEFT JOIN CAISSE c ON c.ID = m.IDCAISSE
         LEFT JOIN VENTE_DETAILS vd ON vd.ID = m.IDVENTEDETAIL
         LEFT JOIN tiers t ON t.ID = m.idtiers
         left join LiaisonPaiement l on l.id1=m.id
/

create sequence seqCompteClient
    minvalue 1
    maxvalue 999999999999
    start with 60000
    increment by 1
    cache 20;

CREATE OR REPLACE FUNCTION getseqCompteClient
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seqCompteClient.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;


create sequence seqCompteFournisseur
    minvalue 1
    maxvalue 999999999999
    start with 60000
    increment by 1
    cache 20;


CREATE OR REPLACE FUNCTION getseqCompteFournisseur
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seqCompteFournisseur.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;


