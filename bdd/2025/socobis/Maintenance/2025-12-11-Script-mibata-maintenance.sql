create table TypeMaintenance
(
    ID    VARCHAR2(255) not null
        constraint TypeMaintenance_PK
            primary key,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);

CREATE SEQUENCE seqTypeMaintenance
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

create FUNCTION getseqTypeMaintenance
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seqTypeMaintenance.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

create table TypePanne
(
    ID    VARCHAR2(255) not null
        constraint TypePanne_PK
            primary key,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);

CREATE SEQUENCE seqTypePanne
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

create FUNCTION getseqTypePanne
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seqTypePanne.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;


create table Entite
(
    ID    VARCHAR2(255) not null
        constraint Entite_PK
            primary key,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);

CREATE SEQUENCE seqEntite
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

create FUNCTION getseqEntite
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seqEntite.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

create table Situation
(
    ID    VARCHAR2(255) not null
        constraint Situation_PK
            primary key,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);

CREATE SEQUENCE seqSituation
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

create FUNCTION getseqSituation
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seqSituation.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

create table DemandeTravaux
(
    ID    VARCHAR2(255) not null
        constraint DemandeTravaux_PK
            primary key,
    IDENTITE   VARCHAR2(255) constraint DmdTravauxEntite_FK references Entite(ID),
    IDSITUATION   VARCHAR2(255) constraint DmdTravauxSituation_FK references Situation(ID),
    IDMACHINE   VARCHAR2(255),
    DATY DATE,
    DATEBESOIN DATE,
    Priorite INT DEFAULT 0,
    ESTEXISTANT INT DEFAULT 0,
    DESCRIPTION VARCHAR2(500),
    ETAT INT DEFAULT 1
);

CREATE SEQUENCE seqDemandeTravaux
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

create FUNCTION getseqDemandeTravaux
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seqDemandeTravaux.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;


CREATE OR REPLACE VIEW DEMANDETRAVAUX_CPL AS
SELECT
    dmd.*,
    e.VAL AS idEntiteLib,
    s.VAL AS idSituationLib,
    m.VAL AS idMachineLib,
    CASE dmd.ESTEXISTANT
        WHEN 0 THEN 'NON'
        WHEN 1 THEN 'OUI'
        ELSE 'Non spécifié'
        END AS estExistantLib,
    CASE dmd.ETAT
        WHEN 1 THEN 'CR&Eacute;E'
        WHEN 11 THEN 'VALID&Eacute;E'
        ELSE 'CR&Eacute;E'
        END AS etatLib
FROM DEMANDETRAVAUX dmd
         LEFT JOIN ENTITE e ON e.ID = dmd.IDENTITE
         LEFT JOIN SITUATION s ON s.ID = dmd.IDSITUATION
         LEFT JOIN MACHINE m ON m.ID = dmd.IDMACHINE;

create table ORDRETRAVAUX(
                             ID       VARCHAR2(255) not null
        primary key,
                             LANCEPAR VARCHAR2(255),
                             CIBLE    VARCHAR2(255),
                             REMARQUE VARCHAR2(255),
                             LIBELLE  VARCHAR2(255),
                             BESOIN   DATE,
                             DATY     DATE,
                             ETAT     NUMBER,
                             IDBC     VARCHAR2(500)
        constraint FK_ORDRETRAVAUX_BDC
            references BONDECOMMANDE_CLIENT
);

CREATE SEQUENCE seqORDRETRAVAUX
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

create FUNCTION getseqORDRETRAVAUX
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seqORDRETRAVAUX.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

create table ORDRETRAVAUXFILLE(
                                  ID            VARCHAR2(255) not null
        primary key,
                                  IDINGREDIENTS VARCHAR2(255),
                                  LIBELLE       VARCHAR2(255),
                                  REMARQUE      VARCHAR2(255),
                                  IDMERE        VARCHAR2(255)
        references ORDRETRAVAUX,
                                  DATYBESOIN    DATE,
                                  QTE           NUMBER(20, 2),
                                  IDUNITE       VARCHAR2(100),
                                  IDBCFILLE     VARCHAR2(1000)
        constraint FK_OTFILLE_BDCFILE
            references BONDECOMMANDE_CLIENT_FILLE
);

CREATE SEQUENCE seqORDRETRAVAUXFILLE
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

create FUNCTION getseqORDRETRAVAUXFILLE
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seqORDRETRAVAUXFILLE.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

create table TRAVAUX
(
    ID              VARCHAR2(255)        not null
        primary key,
    LANCEPAR        VARCHAR2(255),
    CIBLE           VARCHAR2(255),
    REMARQUE        VARCHAR2(255),
    LIBELLE         VARCHAR2(255),
    BESOIN          DATE,
    DATY            DATE,
    ETAT            NUMBER(38) default 1 not null,
    IDBC            VARCHAR2(500)
        constraint FK_TRAVAUX_BDC
            references BONDECOMMANDE_CLIENT,
    IDOFFILLE       VARCHAR2(255)
        constraint FAB_OTFILE_FK
            references ORDRETRAVAUXFILLE,
    IDOF            VARCHAR2(255),
    FABRICATIONPREC VARCHAR2(100),
    FABRICATIONSUIV VARCHAR2(50),
    EQUIPE          VARCHAR2(255)
);

CREATE SEQUENCE seqTRAVAUX
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

create FUNCTION getseqTRAVAUX
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seqTRAVAUX.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

create table TRAVAUXFILLE
(
    ID            VARCHAR2(255) not null
        primary key,
    IDINGREDIENTS VARCHAR2(255),
    LIBELLE       VARCHAR2(255),
    REMARQUE      VARCHAR2(255),
    IDMERE        VARCHAR2(255)
        references TRAVAUX,
    DATYBESOIN    DATE,
    QTE           NUMBER(20, 2),
    IDUNITE       VARCHAR2(100),
    PU            NUMBER(20, 2),
    IDBCFILLE     VARCHAR2(1000)
        constraint FK_TRAFILLE_BDCFILLE
            references BONDECOMMANDE_CLIENT_FILLE,
    OPERATEUR     VARCHAR2(255)
        constraint FK_TRAFILLE_OPERATEUR
            references PERSONNEL,
    NIVEAU        NUMBER,
    IDMACHINE     VARCHAR2(255)
        constraint TRAFILLE_MACHINE_FK
            references MACHINE
);

CREATE SEQUENCE seqTRAVAUXFILLE
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

create FUNCTION getseqTRAVAUXFILLE
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seqTRAVAUXFILLE.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

create or replace view OTRAVLIB as
SELECT ofl.ID,
       p1.VAL  AS LANCEPAR,
       p2.VAL  AS CIBLE,
       ofl.REMARQUE,
       ofl.LIBELLE,
       ofl.BESOIN,
       ofl.DATY,
       ofl.ETAT,
       CASE
           WHEN ofl.ETAT=1
               THEN 'CREE'
           WHEN ofl.ETAT=11
               THEN 'VALIDE'
           WHEN ofl.ETAT=0
               THEN 'ANNULE'
           WHEN ofl.ETAT=21
               THEN 'ENTAME'
           WHEN ofl.ETAT=31
               THEN 'BLOQUE'
           WHEN ofl.ETAT=41
               THEN 'TERMINE'
           END AS ETATLIB
FROM ORDRETRAVAUX ofl
         LEFT JOIN MAGASIN2 p1 ON p1.ID = ofl.LANCEPAR
         LEFT JOIN MAGASIN2 p2 ON p2.ID = ofl.CIBLE;

create or replace view TRAVAUXFILLECPL as
SELECT
    f.ID,
    f.IDINGREDIENTS,
    f.LIBELLE,
    f.REMARQUE,
    f.IDMERE,
    f.DATYBESOIN,
    f.QTE,
    f.IDUNITE,
    f.PU,
    ai.LIBELLE AS idingredientsLib,
    p.NOM || ' - ' || p.TELEPHONE AS operateur,
    au.val AS IDUNITELIB,
    f.IDBCFILLE ,
    f.IDMACHINE,
    m.val AS IDMACHINELIB
FROM
    TRAVAUXFILLE f
        LEFT JOIN AS_INGREDIENTS ai ON
        ai.id = f.IDINGREDIENTS
        LEFT JOIN PERSONNEL p ON
        p.ID = f.OPERATEUR
        LEFT JOIN AS_UNITE au ON
        au.id = f.IDUNITE
        LEFT JOIN MACHINE m ON m.ID = f.IDMACHINE;

create or replace view TRAVAUXMEREFILLE as
SELECT
    ff.IDINGREDIENTS,
    ff.IDINGREDIENTSLIB ,
    sum(ff.QTE) qte,
    ff.IDUNITE ,
    f.idOffille,
    f.IDOF,
    f.LIBELLE,
    f.DATY,
    ff.IDBCFILLE
FROM
    TRAVAUXFILLECPL ff
        JOIN TRAVAUX f ON
        f.id = ff.IDMERE
WHERE
    f.etat = 11
GROUP BY
    ff.IDINGREDIENTS,
    ff.IDINGREDIENTSLIB ,
    ff.IDUNITE ,
    f.idOffille,
    f.LIBELLE,
    f.DATY,
    ff.IDBCFILLE,
    f.IDOF;

create or replace view ORDRETRAVAUXFILLELIB as
SELECT
    ofll.ID,
    ofll.IDINGREDIENTS,
    nvl(ofll.LIBELLE,ai.LIBELLE)  AS LIBELLE,
    ofll.REMARQUE,
    ofll.IDMERE,
    ofll.DATYBESOIN,
    ofll.QTE,
    nvl(au.VAL, 'unite') AS IDUNITE,
    fmf.qte AS qteFabrique,
    (ofll.qte-nvl(fmf.qte, 0)) AS qteReste,
    nvl(ofll.LIBELLE,nvl(ai.LIBELLEEXTACTE, ai.LIBELLE)) AS libelleexacte
FROM
    ORDRETRAVAUXFILLE ofll
        LEFT JOIN AS_INGREDIENTS ai ON
        ai.ID = ofll.IDINGREDIENTS
        LEFT JOIN AS_UNITE au ON
        au.ID = ofll.IDUNITE
        LEFT JOIN TRAVAUXMEREFILLE fmf ON
        fmf.IDOFFILLE = ofll.ID
            AND fmf.IDINGREDIENTS = ofll.IDINGREDIENTS
            AND fmf.IDBCFILLE = OFLL.IDBCFILLE;

create or replace view OTRAVFILLERESTELIB as
SELECT o."ID",
       o."IDINGREDIENTS",
       o."LIBELLE",
       o."REMARQUE",
       o."IDMERE",
       o."DATYBESOIN",
       o."QTE",
       o."IDUNITE",
       fmf.qte           AS qteFabrique,
       (o.qte - fmf.qte) AS qteReste
FROM TRAVAUXMEREFILLE fmf
         JOIN ORDRETRAVAUXFILLELIB o ON fmf.idof = o.IDMERE AND fmf.IDINGREDIENTS = o.IDINGREDIENTS;

create or replace view TRAVAUXCPL as
SELECT
    f.ID,f.LANCEPAR,f.CIBLE,f.REMARQUE,f.LIBELLE,f.BESOIN,f.DATY,f.idOffille,nvl(f.idof, off.idmere) AS idof,
    p.val AS lanceparLib,
    p2.val AS cibleLib,
    f.etat AS etat,
    CASE
        WHEN f.ETAT=1
            THEN 'CR&Eacute;E'
        WHEN f.ETAT=11
            THEN 'VALID&Eacute;E'
        WHEN f.ETAT=0
            THEN 'ANNUL&Eacute;E'
        WHEN f.ETAT=21
            THEN 'ENTAM&Eacute;E'
        WHEN f.ETAT=31
            THEN 'BLOQU&Eacute;E'
        WHEN f.ETAT=41
            THEN 'TERMIN&Eacute;E'
        END AS ETATLIB,
    f.FABRICATIONPREC,
    f.FABRICATIONSUIV
FROM TRAVAUX f
         LEFT JOIN MAGASIN p ON p.id = f.lancepar
         LEFT JOIN MAGASIN p2 ON p2.id = f.cible
         LEFT JOIN ORDRETRAVAUXFILLE off ON f.idoffille = off.id;

create or replace view TRAVAUXCPLCREE as
SELECT
    ID,LANCEPAR,CIBLE,REMARQUE,LIBELLE,BESOIN,DATY,IDOFFILLE,IDOF,LANCEPARLIB,CIBLELIB,ETAT,ETATLIB,FABRICATIONPREC,FABRICATIONSUIV
FROM TRAVAUXCPL f
WHERE etat = 1;

create or replace view TRAVAUXCPLVISEE as
SELECT
    ID,LANCEPAR,CIBLE,REMARQUE,LIBELLE,BESOIN,DATY,IDOFFILLE,IDOF,LANCEPARLIB,CIBLELIB,ETAT,ETATLIB,FABRICATIONPREC,FABRICATIONSUIV
FROM TRAVAUXCPL f
WHERE etat = 11;

create or replace view TRAVAUXCPLANNULE as
SELECT
    ID,LANCEPAR,CIBLE,REMARQUE,LIBELLE,BESOIN,DATY,IDOFFILLE,IDOF,LANCEPARLIB,CIBLELIB,ETAT,ETATLIB,FABRICATIONPREC,FABRICATIONSUIV
FROM TRAVAUXCPL f
WHERE etat = 0;

create or replace view TRAVAUXCPLENTAMEE as
SELECT
    ID,LANCEPAR,CIBLE,REMARQUE,LIBELLE,BESOIN,DATY,IDOFFILLE,IDOF,LANCEPARLIB,CIBLELIB,ETAT,ETATLIB,FABRICATIONPREC,FABRICATIONSUIV
FROM TRAVAUXCPL f
WHERE etat = 21;

create or replace view TRAVAUXCPLBLOQUEE as
SELECT
    ID,LANCEPAR,CIBLE,REMARQUE,LIBELLE,BESOIN,DATY,IDOFFILLE,IDOF,LANCEPARLIB,CIBLELIB,ETAT,ETATLIB,FABRICATIONPREC,FABRICATIONSUIV
FROM TRAVAUXCPL f
WHERE etat = 31;

create or replace view TRAVAUXCPLTERMINEE as
SELECT
    ID,LANCEPAR,CIBLE,REMARQUE,LIBELLE,BESOIN,DATY,IDOFFILLE,IDOF,LANCEPARLIB,CIBLELIB,ETAT,ETATLIB,FABRICATIONPREC,FABRICATIONSUIV
FROM TRAVAUXCPL f
WHERE etat = 41;


INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT01','Maintenance','list_alt','',1,1,NULL);

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT012','Configuration','list_alts','',1,2,'MNDNMT01');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT013','Type de maintenance','list_alt','',1,3,'MNDNMT012');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT014','Type de panne','list_alt','',2,3,'MNDNMT012');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT015','Entit&eacute;','list_alt','',3,3,'MNDNMT012');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT016','Situation','list_alt','',4,3,'MNDNMT012');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT018','Saisie','add','module.jsp?but=maintenance/configuration/typemaintenance/typemaintenance-saisie.jsp',1,4,'MNDNMT013');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT019','Liste','list_alt','module.jsp?but=maintenance/configuration/typemaintenance/typemaintenance-liste.jsp',2,4,'MNDNMT013');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0110','Saisie','add','module.jsp?but=maintenance/configuration/typepanne/typepanne-saisie.jsp',1,4,'MNDNMT014');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0111','Liste','list_alt','module.jsp?but=maintenance/configuration/typepanne/typepanne-liste.jsp',2,4,'MNDNMT014');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0112','Saisie','add','module.jsp?but=maintenance/configuration/entite/entite-saisie.jsp',1,4,'MNDNMT015');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0113','Liste','list_alt','module.jsp?but=maintenance/configuration/entite/entite-liste.jsp',2,4,'MNDNMT015');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0114','Saisie','add','module.jsp?but=maintenance/configuration/situation/situation-saisie.jsp',1,4,'MNDNMT016');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0115','Liste','list_alt','module.jsp?but=maintenance/configuration/situation/situation-liste.jsp',2,4,'MNDNMT016');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0116','Ex&eacute;cution','list_alt','',0,2,'MNDNMT01');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0117','Ordre de travaux','list_alts','',1,3,'MNDNMT0116');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0118','Travaux','list_alt','',2,3,'MNDNMT0116');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0119','Cr&eacute;ation','add','module.jsp?but=maintenance/travaux/Otravaux-saisie.jsp',1,4,'MNDNMT0117');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0120','Liste','list_alt','module.jsp?but=maintenance/travaux/Otravaux-liste.jsp',2,4,'MNDNMT0117');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0121','Cr&eacute;ation','add','module.jsp?but=maintenance/travaux/Travaux-saisie.jsp',1,4,'MNDNMT0118');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0122','Liste','list_alt','module.jsp?but=maintenance/travaux/Travaux-liste.jsp',2,4,'MNDNMT0118');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0123','Planning','list_alt','',-1,2,'MNDNMT01');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0124','Planning de maintenance','list_alt','module.jsp?but=maintenance/planning/calendrier-maintenance.jsp',1,3,'MNDNMT0123');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0125','Planning de travaux','list_alt','module.jsp?but=maintenance/planning/calendrier-demande-travaux.jsp',2,3,'MNDNMT0123');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0126','Demande de travaux','list_alt','',3,3,'MNDNMT0123');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0127','Maintenance','list_alt','',4,3,'MNDNMT0123');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0128','Cr&eacute;ation','add','module.jsp?but=maintenance/demandetravaux/demandetravaux-saisie.jsp',1,4,'MNDNMT0126');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0129','Liste','list_alt','module.jsp?but=maintenance/demandetravaux/demandetravaux-liste.jsp',2,4,'MNDNMT0126');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0130','Cr&eacute;ation','add','module.jsp?but=maintenance/demandetravaux/demandetravaux-saisie.jsp',1,4,'MNDNMT0127');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0131','Liste','list_alt','module.jsp?but=maintenance/demandetravaux/demandetravaux-liste.jsp',2,4,'MNDNMT0127');


alter table PLANNING modify DUREE VARCHAR2(255);
alter table PLANNING add HEURE VARCHAR2(255);

CREATE OR REPLACE VIEW PLANNINGFACTURE AS
SELECT
    v.ID,
    v.IDCLIENT,
    v.DESIGNATION,
    v.DATYPREVU AS DATY,
    v.MONTANTRESTE AS MONTANT,
    CASE
        WHEN v.DATYPREVU < SYSDATE THEN 1
        ELSE 0
        END EtatPlanning,
    CASE
        WHEN v.MONTANTRESTE = 0 THEN 1
        ELSE 0
        END EtatPaiment
FROM VENTE_CPL v
UNION
SELECT
    v.IDFACTURE AS ID,
    v.IDTIERS AS IDCLIENT,
    v.DESIGNATION,
    v.DATY,
    v.CREDIT AS MONTANT,
    CASE
        WHEN v.DATY < SYSDATE THEN 1
        ELSE 0
        END EtatPlanning,
    CASE
        WHEN v.CREDIT <= v.DEBIT THEN 1
        ELSE 0
        END EtatPaiment
FROM PREVISION_COMPLET_CPL v;

CREATE OR REPLACE VIEW PLANNINGFACTURELIB AS
SELECT p.*,
       CASE
           WHEN p.EtatPaiment = 1 THEN 'Pay&eacute;'
           ELSE 'Impay&eacute;'
           END EtatPaimentLib,
       c.NOM AS idClientLib
FROM PLANNINGFACTURE p
         LEFT JOIN CLIENT c ON p.IDCLIENT = c.ID;

CREATE OR REPLACE VIEW PLANNING_CPL AS
SELECT
    p.*,
    m.LIBELLE AS idMachineLib,
    t.VAL AS idTypeMaintenanceLib,
    CASE
        WHEN p.ESTPERIODIQUE = 1 THEN 'OUI'
        ELSE 'NON'
        END estPeriodiqueLib,
    CASE
        WHEN p.ETAT = 11 THEN 'VALID&Eacute;E'
        ELSE 'CR&Eacute;E'
        END etatLib,
    u.VAL AS uniteLib
FROM PLANNING p
         LEFT JOIN AS_INGREDIENTS m ON m.ID = p.IDMACHINE
         LEFT JOIN TYPEMAINTENANCE t ON t.ID = p.IDTYPEMAINTENANCE
         LEFT JOIN AS_UNITE u ON u.ID = p.UNITE;

CREATE OR REPLACE VIEW AS_MACHINE AS
SELECT * FROM AS_INGREDIENTS_LIB ai WHERE ai.IDCATEGORIEINGREDIENT = 'CAT005';


INSERT INTO AS_UNITE (ID, VAL, DESCE) VALUES ('UTF1','Jour','Jour');
INSERT INTO AS_UNITE (ID, VAL, DESCE) VALUES ('UTF2','Semaine','Semaine');
INSERT INTO AS_UNITE (ID, VAL, DESCE) VALUES ('UTF3','Mois','Mois');


CREATE OR REPLACE VIEW UNITE_FREQUENCE AS
SELECT * FROM AS_UNITE ai WHERE ai.ID = 'UTF1' OR ai.ID = 'UTF2' OR ai.ID = 'UTF3';

create or replace view DEMANDETRAVAUX_CPL as
SELECT
    dmd."ID",dmd."IDENTITE",dmd."IDMACHINE",dmd."IDSITUATION",dmd."DATY",dmd."DATEBESOIN",dmd."PRIORITE",dmd."ESTEXISTANT",dmd."DESCRIPTION",dmd."ETAT",
    e.VAL AS idEntiteLib,
    s.VAL AS idSituationLib,
    m.LIBELLE AS idMachineLib,
    CASE dmd.ESTEXISTANT
        WHEN 0 THEN 'NON'
        WHEN 1 THEN 'OUI'
        ELSE 'Non spécifié'
        END AS estExistantLib,
    CASE dmd.ETAT
        WHEN 1 THEN 'CR&Eacute;E'
        WHEN 11 THEN 'VALID&Eacute;E'
        ELSE 'CR&Eacute;E'
        END AS etatLib
FROM DEMANDETRAVAUX dmd
         LEFT JOIN ENTITE e ON e.ID = dmd.IDENTITE
         LEFT JOIN SITUATION s ON s.ID = dmd.IDSITUATION
         LEFT JOIN AS_INGREDIENTS m ON m.ID = dmd.IDMACHINE;


INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNMT0132','Liste des machines','fa fa-compact-disc','module.jsp?but=maintenance/ressources/machine-liste.jsp',1,2,'MNDNMT01');

create or replace view OTRAVFILLELIBSTOCK as
SELECT
    ofll.ID,
    ofll.IDINGREDIENTS,
    nvl(ofll.LIBELLE,ai.LIBELLE)  AS LIBELLE,
    ofll.REMARQUE,
    ofll.IDMERE,
    ob.daty AS  DATYBESOIN,
    ofll.QTE,
    nvl(au.VAL, 'unite') AS IDUNITE,
    cast(nvl(mv.entree,0) as number(30,2)) as qteFabrique,
    cast(ofll.QTE-nvl(mv.ENTREE,0)as number(30,2)) as qteReste,
    nvl(ofll.LIBELLE,nvl(ai.LIBELLEEXTACTE, ai.LIBELLE)) AS libelleexacte,
    ai.pv,
    cast(nvl(mv.ENTREE,0)*ai.pv as number(30,2)) as montantEntree,
    mvt.montantSortie,
    CASE
        WHEN (nvl(mv.ENTREE,0)=0 or ai.pv=0) THEN 0
        ELSE (1-(mvt.montantSortie/(nvl(mv.ENTREE,0)*ai.pv)))*100
        END AS pourc
FROM
    ORDRETRAVAUXFILLE ofll
        LEFT JOIN AS_INGREDIENTS ai ON
        ai.ID = ofll.IDINGREDIENTS
        LEFT JOIN AS_UNITE au ON
        au.ID = ofll.IDUNITE
        left join MVTSTFILLEOFFCATVISEGROUPEDEP mvt on ofll.id=mvt.IDOFf
        left join mvtStockFilleOfEntreePrFini mv on mv.idoff=ofll.id and mv.IDPRODUIT=ofll.IDINGREDIENTS
        LEFT JOIN OFAB ob ON ob.id =  ofll.idmere;

create or replace view OTRAVLIB as
SELECT ofl.ID,
       p1.VAL  AS LANCEPAR,
       p2.VAL  AS CIBLE,
       ofl.REMARQUE,
       ofl.LIBELLE,
       ofl.BESOIN,
       ofl.DATY,
       ofl.ETAT,
       CASE
           WHEN ofl.ETAT=1
               THEN 'CREE'
           WHEN ofl.ETAT=11
               THEN 'VALIDE'
           WHEN ofl.ETAT=0
               THEN 'ANNULE'
           WHEN ofl.ETAT=21
               THEN 'ENTAME'
           WHEN ofl.ETAT=31
               THEN 'BLOQUE'
           WHEN ofl.ETAT=41
               THEN 'TERMINE'
           END AS ETATLIB
FROM ORDRETRAVAUX ofl
         LEFT JOIN ENTITE p1 ON p1.ID = ofl.LANCEPAR
         LEFT JOIN MAGASIN p2 ON p2.ID = ofl.CIBLE;

create or replace view TRAVAUXCPL as
SELECT
    f.ID,f.LANCEPAR,f.CIBLE,f.REMARQUE,f.LIBELLE,f.BESOIN,f.DATY,f.idOffille,nvl(f.idof, off.idmere) AS idof,
    p.val AS lanceparLib,
    p2.val AS cibleLib,
    f.etat AS etat,
    CASE
        WHEN f.ETAT=1
            THEN 'CR&Eacute;E'
        WHEN f.ETAT=11
            THEN 'VALID&Eacute;E'
        WHEN f.ETAT=0
            THEN 'ANNUL&Eacute;E'
        WHEN f.ETAT=21
            THEN 'ENTAM&Eacute;E'
        WHEN f.ETAT=31
            THEN 'BLOQU&Eacute;E'
        WHEN f.ETAT=41
            THEN 'TERMIN&Eacute;E'
        END AS ETATLIB,
    f.FABRICATIONPREC,
    f.FABRICATIONSUIV
FROM TRAVAUX f
         LEFT JOIN ENTITE p ON p.id = f.lancepar
         LEFT JOIN MAGASIN p2 ON p2.id = f.cible
         LEFT JOIN ORDRETRAVAUXFILLE off ON f.idoffille = off.id;

alter table ORDRETRAVAUX
drop constraint FK_ORDRETRAVAUX_BDC;

alter table PLANNING ADD
    IDSOURCE VARCHAR2(255);


create or replace view PLANNING_CPL as
SELECT
    p.*,
    m.LIBELLE AS idMachineLib,
    t.VAL AS idTypeMaintenanceLib,
    CASE
        WHEN p.ESTPERIODIQUE = 1 THEN 'OUI'
        ELSE 'NON'
        END estPeriodiqueLib,
    CASE
        WHEN p.ETAT = 11 THEN 'VALID&Eacute;E'
        ELSE 'CR&Eacute;E'
        END etatLib,
    u.VAL AS uniteLib
FROM PLANNING p
         LEFT JOIN AS_INGREDIENTS m ON m.ID = p.IDMACHINE
         LEFT JOIN TYPEMAINTENANCE t ON t.ID = p.IDTYPEMAINTENANCE
         LEFT JOIN AS_UNITE u ON u.ID = p.UNITE;



create or replace view PLANNINGFACTURE as
SELECT
    v.ID,
    v.IDCLIENT,
    v.DESIGNATION,
    v.DATYPREVU AS DATY,
    v.MONTANTTTC AS MONTANTTOTAL,
    v.MONTANTRESTE,
    v.MONTANTPAYE,
    CASE
        WHEN v.DATYPREVU < SYSDATE THEN 1
        ELSE 0
        END etatPlanning,
    CASE
        WHEN v.MONTANTRESTE = 0 THEN 1
        ELSE 0
        END etatPaiement
FROM VENTE_CPL v;

create or replace view PLANNINGFACTURELIB as
SELECT p.*,
       CASE
           WHEN p.etatPaiement = 1 THEN 'Pay&eacute;'
           ELSE 'Impay&eacute;'
           END etatPaiementLib,
       c.NOM AS idClientLib
FROM PLANNINGFACTURE p
         LEFT JOIN CLIENT c ON p.IDCLIENT = c.ID;


create or replace view DEMANDETRAVAUX_CPL as
SELECT
    dmd."ID",dmd."IDENTITE",dmd."IDMACHINE",dmd."IDSITUATION",dmd."DATY",dmd."DATEBESOIN",dmd."PRIORITE",dmd."ESTEXISTANT",dmd."DESCRIPTION",dmd."ETAT",
    e.VAL AS idEntiteLib,
    s.VAL AS idSituationLib,
    m.LIBELLE AS idMachineLib,
    CASE dmd.ESTEXISTANT
        WHEN 0 THEN 'NON'
        WHEN 1 THEN 'OUI'
        ELSE 'Non spécifié'
        END AS estExistantLib,
    CASE dmd.ETAT
        WHEN 1 THEN 'CR&Eacute;&Eacute;E(S)'
        WHEN 11 THEN 'VALID&Eacute;E(S)'
        ELSE 'CR&Eacute;&Eacute;E(S)'
        END AS etatLib
FROM DEMANDETRAVAUX dmd
         LEFT JOIN ENTITE e ON e.ID = dmd.IDENTITE
         LEFT JOIN SITUATION s ON s.ID = dmd.IDSITUATION
         LEFT JOIN AS_INGREDIENTS m ON m.ID = dmd.IDMACHINE;


create or replace view OTRAVLIB as
SELECT ofl.ID,
       ofl.IDBC,
       p1.VAL  AS LANCEPAR,
       p2.VAL  AS CIBLE,
       ofl.REMARQUE,
       ofl.LIBELLE,
       ofl.BESOIN,
       ofl.DATY,
       ofl.ETAT,
       CASE
           WHEN ofl.ETAT=1
               THEN 'CREE'
           WHEN ofl.ETAT=11
               THEN 'VALIDE'
           WHEN ofl.ETAT=0
               THEN 'ANNULE'
           WHEN ofl.ETAT=21
               THEN 'ENTAME'
           WHEN ofl.ETAT=31
               THEN 'BLOQUE'
           WHEN ofl.ETAT=41
               THEN 'TERMINE'
           END AS ETATLIB
FROM ORDRETRAVAUX ofl
         LEFT JOIN ENTITE p1 ON p1.ID = ofl.LANCEPAR
         LEFT JOIN MAGASIN p2 ON p2.ID = ofl.CIBLE;

CREATE OR REPLACE VIEW TRAVAUXFILLECPL AS
SELECT
    f.ID,
    f.IDINGREDIENTS,
    f.LIBELLE,
    f.REMARQUE,
    f.IDMERE,
    f.DATYBESOIN,
    f.QTE,
    f.IDUNITE,
    f.PU,
    ai.LIBELLE AS idingredientsLib,
    p.NOM || ' - ' || p.TELEPHONE AS operateur,
    au.val AS IDUNITELIB,
    f.IDBCFILLE ,
    f.IDMACHINE,
    m.val AS IDMACHINELIB,
    p2.NOM AS OPERATEURLiB
FROM
    TRAVAUXFILLE f
        LEFT JOIN AS_INGREDIENTS ai ON
        ai.id = f.IDINGREDIENTS
        LEFT JOIN PERSONNEL p ON
        p.ID = f.OPERATEUR
        LEFT JOIN AS_UNITE au ON
        au.id = f.IDUNITE
        LEFT JOIN MACHINE m ON
        m.ID = f.IDMACHINE
        LEFT JOIN PERSONNEL p2 ON
        p2.id = f.OPERATEUR;

INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('UMMMT', NULL, 'MNDNMT01', 'dg', NULL, NULL, 1);

UPDATE MENUDYNAMIQUE
SET LIBELLE='Maintenance', ICONE='list_alt', HREF=NULL, RANG=7, NIVEAU=1, ID_PERE=NULL
WHERE ID='MNDNMT01';



UPDATE USERMENU
SET REFUSER='*', IDMENU='MNDNMT01', IDROLE=NULL, CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=NULL
WHERE ID='UMMMT';

UPDATE MENUDYNAMIQUE
SET LIBELLE='Cr&eacute;ation', ICONE='add', HREF='module.jsp?but=maintenance/travaux/Otravaux-saisie.jsp', RANG=1, NIVEAU=4, ID_PERE='MNDNMT0117'
WHERE ID='MNDNMT0119';

UPDATE MENUDYNAMIQUE
SET LIBELLE='Cr&eacute;ation', ICONE='add', HREF='module.jsp?but=maintenance/travaux/Travaux-saisie.jsp', RANG=1, NIVEAU=4, ID_PERE='MNDNMT0118'
WHERE ID='MNDNMT0121';

UPDATE MENUDYNAMIQUE
SET LIBELLE='Liste', ICONE='list_alt', HREF='module.jsp?but=maintenance/travaux/Travaux-liste.jsp', RANG=2, NIVEAU=4, ID_PERE='MNDNMT0118'
WHERE ID='MNDNMT0122';
UPDATE MENUDYNAMIQUE
SET LIBELLE='Liste', ICONE='list_alt', HREF='module.jsp?but=maintenance/travaux/Otravaux-liste.jsp', RANG=2, NIVEAU=4, ID_PERE='MNDNMT0117'
WHERE ID='MNDNMT0120';

UPDATE MENUDYNAMIQUE
SET LIBELLE='Planning', ICONE='list_alt', HREF=NULL, RANG=-1, NIVEAU=2, ID_PERE='MNDNMT01'
WHERE ID='MNDNMT0123';

UPDATE MENUDYNAMIQUE
SET LIBELLE='Configuration', ICONE='list_alts', HREF=NULL, RANG=1, NIVEAU=2, ID_PERE='MNDNMT01'
WHERE ID='MNDNMT012';

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDNMT0134256', 'Ressources', 'list_alt', NULL, 1, 2, 'MNDNMT01');
UPDATE MENUDYNAMIQUE
SET LIBELLE='Liste des machines', ICONE='list_alt', HREF='module.jsp?but=maintenance/ressources/machine-liste.jsp', RANG=1, NIVEAU=2, ID_PERE='MNDNMT0134256'
WHERE ID='MNDNMT0132';

UPDATE MENUDYNAMIQUE
SET LIBELLE='Liste des machines', ICONE='list_alt', HREF='module.jsp?but=maintenance/ressources/machine-liste.jsp', RANG=1, NIVEAU=3, ID_PERE='MNDNMT0134256'
WHERE ID='MNDNMT0132';

UPDATE MENUDYNAMIQUE
SET LIBELLE='Cr&eacute;ation', ICONE='add', HREF='module.jsp?but=maintenance/planning/planning-saisie.jsp', RANG=1, NIVEAU=4, ID_PERE='MNDNMT0127'
WHERE ID='MNDNMT0130';
UPDATE MENUDYNAMIQUE
SET LIBELLE='Liste', ICONE='list_alt', HREF='module.jsp?but=maintenance/planning/planning-liste.jsp', RANG=2, NIVEAU=4, ID_PERE='MNDNMT0127'
WHERE ID='MNDNMT0131';


INSERT INTO SITUATION
(ID, VAL, DESCE)
VALUES('SIT000001', 'Arret machine', 'Arret Machine');
INSERT INTO SITUATION
(ID, VAL, DESCE)
VALUES('SIT000002', 'Arret Atelier', 'Arret Atelier');
INSERT INTO SITUATION
(ID, VAL, DESCE)
VALUES('SIT000003', 'Autres', 'Autres');

create table departementmaintenance (
    id varchar(100) primary key,
    val varchar(255),
    desce varchar(255)
);

create sequence seqdepmain
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

CREATE OR REPLACE FUNCTION get_seq_depmain
    RETURN NUMBER
    IS
    retour NUMBER;
BEGIN
SELECT seqdepmain.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;


alter table PERSONNEL add (iddepartement varchar(50) references departementmaintenance(id));

create or replace view personnemaintenancecpl as
select p.*, dm.VAL as iddepartementlib, dm.DESCE as iddepartementdesce from PERSONNEL p
                                                                                left join DEPARTEMENTMAINTENANCE dm on p.IDDEPARTEMENT = dm.ID
where p.IDDEPARTEMENT is not null;

-- dfsd
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764572066943272', 'Personnels de maintenance', 'list_alt', '', 2, 3, 'MNDNMT0134256');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764572076687899', 'Personnel', 'list_alt', '', 1, 4, 'MENDYN1764572066943272');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764572134308572', 'Saisie', 'add', 'module.jsp?but=maintenance/ressources/personnel/personnel-maintenance-saisie.jsp', 1, 5, 'MENDYN1764572076687899');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764572158773208', 'Liste', 'list_alt', 'module.jsp?but=maintenance/ressources/personnel/personnel-maintenance-liste.jsp', 2, 5, 'MENDYN1764572076687899');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764572203689456', 'D&eacute;partement', 'list_alt', '', 2, 4, 'MENDYN1764572066943272');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764572272242575', 'Saisie', 'add', 'module.jsp?but=maintenance/ressources/personnel/departement-saisie.jsp', 1, 5, 'MENDYN1764572203689456');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764572290177749', 'Liste', 'list_alt', 'module.jsp?but=maintenance/ressources/personnel/departement-liste.jsp', 2, 5, 'MENDYN1764572203689456');


create sequence seqpersonnel
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

-- fonction maka ilay sequence OF
CREATE OR REPLACE FUNCTION GET_SEQ_PERSONNELLE
    RETURN NUMBER
    IS
    retour NUMBER;
BEGIN
SELECT seqpersonnel.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;



INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764609933777330', 'Locaux', 'list_alt', '', 3, 3, 'MNDNMT0134256');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764609964958615', 'Saisie', 'list_alt', 'module.jsp?but=maintenance/ressources/locaux/locaux-saisie.jsp', 1, 4, 'MENDYN1764609933777330');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764610006403774', 'Liste', 'list_alt', 'module.jsp?but=maintenance/ressources/locaux/locaux-liste.jsp', 2, 4, 'MENDYN1764609933777330');









    INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764614974716255', 'Outils', 'list_alt', '', 4, 3, 'MNDNMT0134256');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764615006779140', 'Saisie', 'add', 'module.jsp?but=maintenance/ressources/outils/outils-saisie.jsp', 1, 4, 'MENDYN1764614974716255');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764615021923191', 'Liste', 'list_alt', 'module.jsp?but=maintenance/ressources/outils/outils-liste.jsp', 2, 4, 'MENDYN1764614974716255');


INSERT INTO TYPECARBURANT (ID, VAL, DESCE) VALUES ('TC1', 'Essence', 'Essence');
INSERT INTO TYPECARBURANT (ID, VAL, DESCE) VALUES ('TC2', 'Diesel', 'Diesel');


INSERT INTO UNITECONSO (ID, VAL, DESCE) VALUES ('UC1', 'Litre', 'Litre');

create table priorite (
                          id varchar(100) primary key,
                          val varchar(255),
                          desce varchar(255)
);

INSERT INTO PRIORITE (ID, VAL, DESCE) VALUES ('PRIO1', 'Routine', 'routine');
INSERT INTO PRIORITE (ID, VAL, DESCE) VALUES ('PRIO2', 'Importante', 'Importante');
INSERT INTO PRIORITE (ID, VAL, DESCE) VALUES ('PRIO3', 'Urgente', 'Urgente');

create table departement (
                             id varchar(100) primary key,
                             val varchar(255),
                             desce varchar(255)
);


INSERT INTO DEPARTEMENT (ID, VAL, DESCE) VALUES ('DEP1', 'Magasin', 'Magasin');
INSERT INTO DEPARTEMENT (ID, VAL, DESCE) VALUES ('DEP2', 'Caisse', 'Caisse');

alter table DEMANDETRAVAUX add (demandeur varchar(50) references PERSONNEL(ID));
alter table DEMANDETRAVAUX add (cause varchar(250));
alter table DEMANDETRAVAUX add (type varchar(250));

CREATE TABLE QUALITESOBJETMAINTENANCE
(
    ID    VARCHAR(250) NOT NULL PRIMARY KEY,
    VAL   VARCHAR(250),
    DESCE VARCHAR(250)
);

CREATE TABLE ETATOBJETMAINTENANCE
(
    ID    VARCHAR(250) NOT NULL PRIMARY KEY,
    VAL   VARCHAR(250),
    DESCE VARCHAR(250)
);

CREATE TABLE AS_INGREDIENT_MAINTENANCE
(
    ID                  VARCHAR(250) NOT NULL PRIMARY KEY,
    IDINGREDIENT        VARCHAR(250)
        REFERENCES AS_INGREDIENTS(ID),
    IDENTITE            VARCHAR(250),
    REFERENCEOBJET      VARCHAR(250),
    MARQUEOBJET         VARCHAR(250),
    MODELEOBJET         VARCHAR(250),
    NUMEROSERIEOBJET    VARCHAR(250),
    DESCRIPTIONOBJET    VARCHAR(250),
    QUALITEOBJET        VARCHAR(250)
        REFERENCES QUALITESOBJETMAINTENANCE(ID),
    ETATOBJET           VARCHAR(250)
        REFERENCES ETATOBJETMAINTENANCE(ID),
    LOCALISATIONOBJET   VARCHAR(250),
    PUISSANCEOBJET      VARCHAR(250),
    OBSERVATIONOBJET    VARCHAR(250),
    TYPERATTACHEMENT    VARCHAR(250),
    ESTENGIN            NUMBER(2) DEFAULT 0
);

CREATE SEQUENCE seqQualiteObjetMaintenance;

CREATE OR REPLACE FUNCTION getSeqQualiteObjetMaintenance
RETURN NUMBER
IS
    retour NUMBER;
BEGIN
SELECT seqQualiteObjetMaintenance.NEXTVAL
INTO retour
FROM DUAL;

RETURN retour;
END;


CREATE SEQUENCE seqEtatObjetMaintenance;

CREATE OR REPLACE FUNCTION getSeqEtatObjetMaintenance
RETURN NUMBER
IS
    retour NUMBER;
BEGIN
SELECT seqEtatObjetMaintenance.NEXTVAL
INTO retour
FROM DUAL;

RETURN retour;
END;


CREATE SEQUENCE seqAsIngredientInfoMaintenance;

CREATE OR REPLACE FUNCTION getSeqAsIngredientMaintenance
RETURN NUMBER
IS
    retour NUMBER;
BEGIN
SELECT seqAsIngredientInfoMaintenance.NEXTVAL
INTO retour
FROM DUAL;

RETURN retour;
END;


CREATE TABLE UNITEMAINTENANCE
(
    ID      VARCHAR2(50) NOT NULL PRIMARY KEY,
    VAL     VARCHAR2(100),
    DESCE   VARCHAR2(250),
    ECHELLE NUMBER(10) DEFAULT 0
);

CREATE SEQUENCE seqUniteMaintenance;

CREATE OR REPLACE FUNCTION getSeqUniteMaintenance
RETURN NUMBER
IS
    retour NUMBER;
BEGIN
SELECT seqUniteMaintenance.NEXTVAL
INTO retour
FROM DUAL;

INSERT INTO ENTITE
(ID, VAL, DESCE)
VALUES('ENT000001', 'MACHINE', 'Machine / Materiels');
INSERT INTO ENTITE
(ID, VAL, DESCE)
VALUES('ENT000002', 'LOCAUX', 'LOCAUX');
INSERT INTO ENTITE
(ID, VAL, DESCE)
VALUES('ENT000003', 'VOITURES', 'Automobile');
INSERT INTO ENTITE
(ID, VAL, DESCE)
VALUES('ENT000004', 'OUTILS', 'outils');
INSERT INTO CATEGORIEINGREDIENT
(ID, VAL, DESCE)
VALUES('CATM0001', 'Maintenance', 'Maintenance');

CREATE OR REPLACE VIEW AS_INGREDIENT_MAINTENANCE_LIB AS
SELECT
    am.*,
    ai.libelle AS INGREDIENTLIB,
    am.IDENTITE AS IDENTITELIB,
    qo.VAL AS QUALITEOBJETLIB,
    eo.VAL AS ETATOBJETLIB,
    CASE
        WHEN am.ESTENGIN = 1 THEN 'Oui'
        ELSE 'Non'
        END AS ESTENGINLIB
FROM AS_INGREDIENTS ai
         JOIN AS_INGREDIENT_MAINTENANCE am ON ai.ID = am.IDINGREDIENT
         LEFT JOIN QUALITESOBJETMAINTENANCE qo ON am.QUALITEOBJET = qo.ID
         LEFT JOIN ETATOBJETMAINTENANCE eo ON am.ETATOBJET = eo.ID;



create table souscategorieentite
(
    ID    VARCHAR2(255) not null
        constraint souscategorieentite_PK
            primary key,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);

CREATE SEQUENCE seqsouscategorieentite
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

create FUNCTION getseqSouscategorieentite
    RETURN NUMBER
        IS
           retour   NUMBER;
BEGIN
SELECT seqsouscategorieentite.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

create or replace view souscategorieentite_cpl as
SELECT
    sce.*,
    e.id AS idEntite,
    e.VAL AS idEntiteLib
FROM souscategorieentite sce
         LEFT JOIN ENTITE e ON e.ID = sce.DESCE;

INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764601493001676', 'Unité', 'list_alt', '', 5, 3, 'MNDNMT012');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764601565475292', 'Saisie', 'list_alt', 'maintenance/configuration/unite/unitemaintenance-saisie.jsp', 1, 4, 'MENDYN1764601493001676');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764601606147423', 'Liste', 'list_alt', 'module.jsp?but=maintenance/configuration/unite/unitemaintenance-liste.jsp', 2, 4, 'MENDYN1764601493001676');


CREATE SEQUENCE seq_Unite_Maintenance INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE CACHE 20 NOORDER ;

CREATE OR REPLACE FUNCTION getSeqUniteMaintenance
    RETURN NUMBER IS
    retour NUMBER;
BEGIN
SELECT seq_Unite_Maintenance.nextval INTO retour FROM dual;
return retour;
END;


CREATE TABLE INFOSAUTO
(
    ID                              VARCHAR(50) NOT NULL PRIMARY KEY,
    IDINGREDIENT                    VARCHAR(50)
        REFERENCES AS_INGREDIENTS(ID),
    DESCRIPTION                     VARCHAR(50),
    NUMERODEPARC                    VARCHAR(50),
    DATEPREMIEREMISEENCIRCULATION   DATE,
    IMMATRICULATION                 VARCHAR(50),
    NOTE                            VARCHAR(50),
    FOURNISSEUR                     VARCHAR(50),
    NUMERO                          VARCHAR(50),
    VOLUME                          NUMBER(10, 2),
    MONTANT                         NUMBER(15, 2),
    TYPE                            VARCHAR(50),
    VIN                             VARCHAR(50),
    MARQUE                          VARCHAR(50),
    MODELE                          VARCHAR(50),
    ANNEE                           NUMBER(4),
    NOMBREDEPLACES                  NUMBER(3),
    NOMBREDEPORTES                  NUMBER(3),
    PUISSANCEFISCALE                NUMBER(10, 2),
    BAILLEUR                        VARCHAR(50),
    VALEURINITIALE                  NUMBER(15, 2),
    DATEDEBUT                       DATE,
    DURREEENMOIS                    NUMBER(5),
    MENSUALITE                      NUMBER(15, 2),
    VENDEUR                         VARCHAR(50),
    PRIX                            NUMBER(15, 2),
    DATEDACHAT                      DATE,
    NUMERODIMMOBILISATION           VARCHAR(50),
    DUREEDAMORTISSEMENTENMOIS       NUMBER(5),
    PNEUS                           VARCHAR(50),
    BATTERIE                        VARCHAR(50),
    HUILEMOTEUR                     VARCHAR(50),
    HUILEBOITEDEVITESSE             VARCHAR(50),
    TYPEDECARBURANT                 VARCHAR(50),
    CONSOMMATION                    NUMBER(10, 2),
    UNITEDECONSOMMATION             VARCHAR(50)
);

CREATE SEQUENCE seqInfosAuto;

CREATE OR REPLACE FUNCTION getSeqInfosAuto
RETURN NUMBER
IS
    retour NUMBER;
BEGIN
SELECT seqInfosAuto.NEXTVAL
INTO retour
FROM DUAL;

RETURN retour;
END;

ALTER TABLE AS_INGREDIENT_MAINTENANCE ADD LIBELLE VARCHAR2(255);


INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764608553286867', 'Machine', 'list_alt', '', 3, 3, 'MNDNMT0134256');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764608667292943', 'Liste', 'list_alt', 'module.jsp?but=maintenance/ressources/machine/machine-liste.jsp', 1, 4, 'MENDYN1764608553286867');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764608696622367', 'Saisie', 'list_alt', 'module.jsp?but=maintenance/ressources/machine/machine-saisie.jsp', 2, 4, 'MENDYN1764608553286867');



UPDATE ENTITE
SET VAL='Machines', DESCE='Machines'
WHERE ID='ENT000001';
UPDATE ENTITE
SET VAL='Locaux', DESCE='Locaux'
WHERE ID='ENT000002';
UPDATE ENTITE
SET VAL='Voitures', DESCE='Voitures'
WHERE ID='ENT000003';
UPDATE ENTITE
SET VAL='Outils', DESCE='Outils'
WHERE ID='ENT000004';


UPDATE SITUATION
SET VAL='Arr&ecirc;t machine', DESCE='Arr&ecirc;t machine'
WHERE ID='SIT000001';
UPDATE SITUATION
SET VAL='Arr&ecirc;t atelier', DESCE='Arr&ecirc;t atelier'
WHERE ID='SIT000002';

drop view UNITE_FREQUENCE;

CREATE TABLE UNITE_FREQUENCE (
     ID VARCHAR2(255) primary key,
     VAL VARCHAR2(255),
     DESCE VARCHAR2(255),
     ECHELLE NUMBER
);


INSERT INTO UNITE_FREQUENCE (ID, VAL, DESCE, ECHELLE) VALUES ('UF1','Jour','Jour',1);
INSERT INTO UNITE_FREQUENCE (ID, VAL, DESCE, ECHELLE) VALUES ('UF2','Semaine','Semaine',7);
INSERT INTO UNITE_FREQUENCE (ID, VAL, DESCE, ECHELLE) VALUES ('UF3','Mois','Mois',30);

create or replace view PLANNING_CPL as
SELECT
    p."ID",p."REFOBJET",p."ESTPERIODIQUE",p."IDTYPEMAINTENANCE",p."IDMACHINE",p."UNITE",p."FREQUENCE",p."DATEDEBUT",p."DATEFIN",p."DUREE",p."ETAT",p."HEURE",p."IDSOURCE",
    m.LIBELLE AS idMachineLib,
    t.VAL AS idTypeMaintenanceLib,
    CASE
        WHEN p.ESTPERIODIQUE = 1 THEN 'OUI'
        ELSE 'NON'
        END estPeriodiqueLib,
    CASE
        WHEN p.ETAT = 11 THEN 'VALID&Eacute;E'
        ELSE 'CR&Eacute;E'
        END etatLib,
    u.VAL AS uniteLib
FROM PLANNING p
         LEFT JOIN AS_INGREDIENTS m ON m.ID = p.IDMACHINE
         LEFT JOIN TYPEMAINTENANCE t ON t.ID = p.IDTYPEMAINTENANCE
         LEFT JOIN UNITE_FREQUENCE u ON u.ID = p.UNITE;



DELETE FROM menudynamique WHERE id = 'MNDNMT0132';
UPDATE menudynamique SET rang = 1 WHERE id = 'MENDYN1764572066943272';
UPDATE menudynamique SET href = '#', rang = 2 WHERE id = 'MENDYN1764608553286867';



create sequence seqingmain
    minvalue 1
    maxvalue 999999999999
    start with 1
    increment by 1
    cache 20;

-- fonction maka ilay sequence OF
CREATE OR REPLACE FUNCTION GET_SEQ_ING_MAIN
    RETURN NUMBER
    IS
    retour NUMBER;
BEGIN
SELECT seqingmain.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

create table Typecarburant (
                               id varchar(100) primary key,
                               val varchar(255),
                               desce varchar(255)
);

create table uniteconso (
                            id varchar(100) primary key,
                            val varchar(255),
                            desce varchar(255)
);


create or replace view autolib as
select ia.*, tc.val as typecarburantlib, uc.val as UNITEDECONSOMMATIONLIB from INFOSAUTO ia
left join Typecarburant tc on ia.TYPEDECARBURANT = tc.id
left join uniteconso uc on ia.UNITEDECONSOMMATION = uc.id

    INSERT INTO ETATOBJETMAINTENANCE
(ID, VAL, DESCE)
VALUES('ET0001', 'Abimé', 'Abimé');
INSERT INTO ETATOBJETMAINTENANCE
(ID, VAL, DESCE)
VALUES('ET0002', 'Bon état', 'Bon état');
INSERT INTO ETATOBJETMAINTENANCE
(ID, VAL, DESCE)
VALUES('ET0003', 'Neuve', 'Neuve');

INSERT INTO DEPARTEMENTMAINTENANCE
(ID, VAL, DESCE)
VALUES('DEP000002', 'Machiniste', 'Machiniste');
INSERT INTO DEPARTEMENTMAINTENANCE
(ID, VAL, DESCE)
VALUES('DEP000004', 'Mecanicien', 'Mecanicien');
INSERT INTO DEPARTEMENTMAINTENANCE
(ID, VAL, DESCE)
VALUES('DEP000005', 'Plomberie', 'Plomberie');
INSERT INTO DEPARTEMENTMAINTENANCE
(ID, VAL, DESCE)
VALUES('DEP000006', 'Electricien', 'Electricien');

alter table DEMANDETRAVAUX add (demandeur varchar(50) references PERSONNEL(ID));
alter table DEMANDETRAVAUX add (cause varchar(2500));
alter table DEMANDETRAVAUX add (type varchar(2500));


create or replace view AS_INGREDIENT_MAINTENANCE_LIB as
SELECT
    am.*,
    ai.libelle AS INGREDIENTLIB,
    am.IDENTITE AS IDENTITELIB,
    qo.VAL AS QUALITEOBJETLIB,
    eo.VAL AS ETATOBJETLIB,
    CASE
        WHEN am.ESTENGIN = 1 THEN 'Oui'
        ELSE 'Non'
        END AS ESTENGINLIB
FROM AS_INGREDIENTS ai
         JOIN AS_INGREDIENT_MAINTENANCE am ON ai.ID = am.IDINGREDIENT
         LEFT JOIN QUALITESOBJETMAINTENANCE qo ON am.QUALITEOBJET = qo.ID
         LEFT JOIN ETATOBJETMAINTENANCE eo ON am.ETATOBJET = eo.ID;

ALTER TABLE DEMANDETRAVAUX ADD idDepartement VARCHAR2(255);

create or replace view DEMANDETRAVAUX_CPL as
SELECT
    dmd.*,
    e.VAL AS idEntiteLib,
    s.VAL AS idSituationLib,
    m.LIBELLE AS idMachineLib,
    CASE dmd.ESTEXISTANT
        WHEN 0 THEN 'NON'
        WHEN 1 THEN 'OUI'
        ELSE 'Non spécifié'
        END AS estExistantLib,
    CASE dmd.ETAT
        WHEN 1 THEN 'CR&Eacute;&Eacute;E(S)'
        WHEN 11 THEN 'VALID&Eacute;E(S)'
        ELSE 'CR&Eacute;&Eacute;E(S)'
        END AS etatLib,
    d.DESCE AS IDDEPARTEMENTLIB
FROM DEMANDETRAVAUX dmd
         LEFT JOIN ENTITE e ON e.ID = dmd.IDENTITE
         LEFT JOIN SITUATION s ON s.ID = dmd.IDSITUATION
         LEFT JOIN AS_INGREDIENT_MAINTENANCE m ON m.ID = dmd.IDMACHINE
         LEFT JOIN DEPARTEMENTMAINTENANCE d ON d.ID = dmd.IDDEPARTEMENT;


create OR REPLACE view OTRAVFILLELIBSTOCK as
SELECT
    ofll.ID,
    ofll.IDINGREDIENTS,
    nvl(ofll.LIBELLE,ai.LIBELLE)  AS LIBELLE,
    ofll.REMARQUE,
    ofll.IDMERE,
    ob.daty AS  DATYBESOIN,
    ofll.QTE,
    nvl(au.VAL, 'unite') AS IDUNITE,
    cast(nvl(mv.entree,0) as number(30,2)) as qteFabrique,
    cast(ofll.QTE-nvl(mv.ENTREE,0)as number(30,2)) as qteReste,
    nvl(ofll.LIBELLE,nvl(ai.LIBELLEEXTACTE, ai.LIBELLE)) AS libelleexacte,
    ai.pv,
    cast(nvl(mv.ENTREE,0)*ai.pv as number(30,2)) as montantEntree,
    mvt.montantSortie,
    CASE
        WHEN (nvl(mv.ENTREE,0)=0 or ai.pv=0) THEN 0
        ELSE (1-(mvt.montantSortie/(nvl(mv.ENTREE,0)*ai.pv)))*100
        END AS pourc
FROM
    ORDRETRAVAUXFILLE ofll
        LEFT JOIN AS_INGREDIENTS ai ON
        ai.ID = ofll.IDINGREDIENTS
        LEFT JOIN AS_UNITE au ON
        au.ID = ofll.IDUNITE
        left join MVTSTFILLEOFFCATVISEGROUPEDEP mvt on ofll.id=mvt.IDOFf
        left join mvtStockFilleOfEntreePrFini mv on mv.idoff=ofll.id and mv.IDPRODUIT=ofll.IDINGREDIENTS
        LEFT JOIN OFAB ob ON ob.id =  ofll.idmere;

create or replace view OTRAVFILLELIBSTOCK as
SELECT
    ofll.ID,
    ofll.IDINGREDIENTS,
    nvl(ofll.LIBELLE,ai.LIBELLE)  AS LIBELLE,
    ofll.REMARQUE,
    ofll.IDMERE,
    ob.daty AS  DATYBESOIN,
    ofll.QTE,
    nvl(au.VAL, 'unite') AS IDUNITE,
    cast(nvl(mv.entree,0) as number(30,2)) as qteFabrique,
    cast(ofll.QTE-nvl(mv.ENTREE,0)as number(30,2)) as qteReste,
    nvl(ofll.LIBELLE,nvl(ai.LIBELLE, ai.LIBELLE)) AS libelleexacte,
    0 AS pv,
    cast(0 as number(30,2)) as montantEntree,
    mvt.montantSortie,
    0 AS pourc
FROM
    ORDRETRAVAUXFILLE ofll
        LEFT JOIN AS_INGREDIENT_MAINTENANCE ai ON
        ai.ID = ofll.IDINGREDIENTS
        LEFT JOIN AS_UNITE au ON
        au.ID = ofll.IDUNITE
        left join MVTSTFILLEOFFCATVISEGROUPEDEP mvt on ofll.id=mvt.IDOFf
        left join mvtStockFilleOfEntreePrFini mv on mv.idoff=ofll.id and mv.IDPRODUIT=ofll.IDINGREDIENTS
        LEFT JOIN OFAB ob ON ob.id =  ofll.idmere;


alter table DEMANDETRAVAUX
    modify PRIORITE default null;
alter table DEMANDETRAVAUX
    modify PRIORITE VARCHAR2(255) default null;


create or replace view ORDRETRAVAUXFILLELIB as
SELECT
    ofll.ID,
    ofll.IDINGREDIENTS,
    nvl(ofll.LIBELLE,ai.LIBELLE)  AS LIBELLE,
    ofll.REMARQUE,
    ofll.IDMERE,
    ofll.DATYBESOIN,
    ofll.QTE,
    nvl(au.VAL, 'unite') AS IDUNITE,
    fmf.qte AS qteFabrique,
    (ofll.qte-nvl(fmf.qte, 0)) AS qteReste,
    nvl(ofll.LIBELLE,nvl(ai.LIBELLE, ai.LIBELLE)) AS libelleexacte
FROM
    ORDRETRAVAUXFILLE ofll
        LEFT JOIN AS_INGREDIENT_MAINTENANCE ai ON
        ai.ID = ofll.IDINGREDIENTS
        LEFT JOIN AS_UNITE au ON
        au.ID = ofll.IDUNITE
        LEFT JOIN TRAVAUXMEREFILLE fmf ON
        fmf.IDOFFILLE = ofll.ID
            AND fmf.IDINGREDIENTS = ofll.IDINGREDIENTS
            AND fmf.IDBCFILLE = OFLL.IDBCFILLE;


create or replace view TRAVAUXFILLECPL as
SELECT
    f.ID,
    f.IDINGREDIENTS,
    f.LIBELLE,
    f.REMARQUE,
    f.IDMERE,
    f.DATYBESOIN,
    f.QTE,
    f.IDUNITE,
    f.PU,
    ai.LIBELLE AS idingredientsLib,
    p.NOM || ' - ' || p.TELEPHONE AS operateur,
    au.val AS IDUNITELIB,
    f.IDBCFILLE ,
    f.IDMACHINE,
    m.val AS IDMACHINELIB,
    p2.NOM AS OPERATEURLiB
FROM
    TRAVAUXFILLE f
        LEFT JOIN AS_INGREDIENT_MAINTENANCE ai ON
        ai.id = f.IDINGREDIENTS
        LEFT JOIN PERSONNEL p ON
        p.ID = f.OPERATEUR
        LEFT JOIN AS_UNITE au ON
        au.id = f.IDUNITE
        LEFT JOIN MACHINE m ON
        m.ID = f.IDMACHINE
        LEFT JOIN PERSONNEL p2 ON
        p2.id = f.OPERATEUR;


ALTER TABLE DEMANDETRAVAUX ADD demandeur VARCHAR2(255);



INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENDYNA1764572066943272', 'Auto', 'list_alt', '#', 5, 3, 'MNDNMT0134256');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENDYNA1764608667292943', 'Liste', 'list_alt', 'module.jsp?but=maintenance/ressources/auto/auto-liste.jsp', 2, 4, 'MENDYNA1764572066943272');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENDYNA1764608696622367', 'Saisie', 'list_alt', 'module.jsp?but=maintenance/ressources/auto/auto-saisie.jsp', 1, 4, 'MENDYNA1764572066943272');

INSERT INTO TYPEMAINTENANCE
(ID, VAL, DESCE)
VALUES('TM000001', 'Preventive', 'Preventive');
INSERT INTO TYPEMAINTENANCE
(ID, VAL, DESCE)
VALUES('TM000002', 'Corrective', 'corrective');
INSERT INTO TYPEMAINTENANCE
(ID, VAL, DESCE)
VALUES('TM000003', 'Amerliorative', 'Amerliorative');

DELETE FROM MENUDYNAMIQUE
WHERE ID='MNDNMT013';

ALTER TABLE DEMANDETRAVAUX MODIFY PRIORITE VARCHAR(22);

CREATE OR REPLACE VIEW "DEMANDETRAVAUX_CPL" ("ID", "IDENTITE", "IDSITUATION", "IDMACHINE", "DATY", "DATEBESOIN", "PRIORITE", "ESTEXISTANT", "DESCRIPTION", "ETAT", "IDDEPARTEMENT", "IDENTITELIB", "IDSITUATIONLIB", "IDMACHINELIB", "ESTEXISTANTLIB", "ETATLIB", "IDDEPARTEMENTLIB","PRIORITELIB") AS
SELECT
    dmd."ID",dmd."IDENTITE",dmd."IDSITUATION",dmd."IDMACHINE",dmd."DATY",dmd."DATEBESOIN",dmd."PRIORITE",dmd."ESTEXISTANT",dmd."DESCRIPTION",dmd."ETAT",dmd."IDDEPARTEMENT",
    e.VAL AS idEntiteLib,
    s.VAL AS idSituationLib,
    m.LIBELLE AS idMachineLib,
    CASE dmd.ESTEXISTANT
        WHEN 0 THEN 'NON'
        WHEN 1 THEN 'OUI'
        ELSE 'Non spécifié'
        END AS estExistantLib,
    CASE dmd.ETAT
        WHEN 1 THEN 'CR&Eacute;&Eacute;E(S)'
        WHEN 11 THEN 'VALID&Eacute;E(S)'
        ELSE 'CR&Eacute;&Eacute;E(S)'
        END AS etatLib,
    d.DESCE AS IDDEPARTEMENTLIB,
    pri.val AS prioritelib
FROM DEMANDETRAVAUX dmd
         LEFT JOIN ENTITE e ON e.ID = dmd.IDENTITE
         LEFT JOIN SITUATION s ON s.ID = dmd.IDSITUATION
         LEFT JOIN AS_INGREDIENT_MAINTENANCE m ON m.ID = dmd.IDMACHINE
         LEFT JOIN DEPARTEMENTMAINTENANCE d ON d.ID = dmd.IDDEPARTEMENT
         LEFT JOIN PRIORITE pri ON dmd.priorite=pri.ID;

create table log_departement
(
    ID    VARCHAR2(50) not null
        primary key,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);


INSERT INTO LOG_DEPARTEMENT (ID, VAL, DESCE) VALUES ('DTP1002', 'Magasin', 'Magasin');
INSERT INTO LOG_DEPARTEMENT (ID, VAL, DESCE) VALUES ('DTP1003', 'Caisse', 'Caisse');
INSERT INTO LOG_DEPARTEMENT (ID, VAL, DESCE) VALUES ('DPT1004', 'Depot', 'Depot');

ALTER TABLE demandetravaux ADD IDDEPARTEMENTMAINTENANCE varchar(100);

alter TABLE AS_INGREDIENT_MAINTENANCE
    add  dateaquisition DATE;

CREATE OR REPLACE VIEW AS_INGREDIENT_MAINTENANCE_LIB AS
SELECT
    am.*,
    ai.libelle AS INGREDIENTLIB,
    am.IDENTITE AS IDENTITELIB,
    qo.VAL AS QUALITEOBJETLIB,
    eo.VAL AS ETATOBJETLIB,
    ld.val AS localisationObjetLib,
    CASE
        WHEN am.ESTENGIN = 1 THEN 'Oui'
        ELSE 'Non'
        END AS ESTENGINLIB
FROM AS_INGREDIENTS ai
         JOIN AS_INGREDIENT_MAINTENANCE am ON ai.ID = am.IDINGREDIENT
         LEFT JOIN QUALITESOBJETMAINTENANCE qo ON am.QUALITEOBJET = qo.ID
         LEFT JOIN ETATOBJETMAINTENANCE eo ON am.ETATOBJET = eo.ID
         left join LOG_DEPARTEMENT ld on am.localisationObjet=ld.id

ALTER TABLE MOUVEMENTCAISSE ADD acquereur varchar(255);

UPDATE ETATOBJETMAINTENANCE
SET VAL='Disponnble', DESCE='Disponnble'
WHERE ID='ET0001';
UPDATE ETATOBJETMAINTENANCE
SET VAL='En utilisation', DESCE='En utilisation'
WHERE ID='ET0002';
UPDATE ETATOBJETMAINTENANCE
SET VAL='Hors service', DESCE='Hors service'
WHERE ID='ET0003';


INSERT INTO QUALITESOBJETMAINTENANCE
(ID, VAL, DESCE)
VALUES('QUAL001', 'Bon', 'Bon');
INSERT INTO QUALITESOBJETMAINTENANCE
(ID, VAL, DESCE)
VALUES('QUAL002', 'Abîmée', 'Abîmée');
INSERT INTO QUALITESOBJETMAINTENANCE
(ID, VAL, DESCE)
VALUES('QUAL003', 'Neuve', 'Neuve');

INSERT INTO POINT
(ID, VAL, DESCE)
VALUES('PNTSTKM001', 'Stock tampon ', 'Stock tampon ');


CREATE OR REPLACE VIEW "DEMANDETRAVAUX_CPL" ("ID", "IDENTITE", "IDSITUATION", "IDMACHINE", "DATY", "DATEBESOIN", "PRIORITE", "ESTEXISTANT", "DESCRIPTION", "ETAT", "IDDEPARTEMENT", "IDENTITELIB", "IDSITUATIONLIB", "IDMACHINELIB", "ESTEXISTANTLIB", "ETATLIB", "IDDEPARTEMENTMAINTENANCELIB", "PRIORITELIB","IDDEPARTEMENTLIB") AS
SELECT
    dmd."ID",dmd."IDENTITE",dmd."IDSITUATION",dmd."IDMACHINE",dmd."DATY",dmd."DATEBESOIN",dmd."PRIORITE",dmd."ESTEXISTANT",dmd."DESCRIPTION",dmd."ETAT",dmd."IDDEPARTEMENT",
    e.VAL AS idEntiteLib,
    s.VAL AS idSituationLib,
    m.LIBELLE AS idMachineLib,
    CASE dmd.ESTEXISTANT
        WHEN 0 THEN 'NON'
        WHEN 1 THEN 'OUI'
        ELSE 'Non spécifié'
        END AS estExistantLib,
    CASE dmd.ETAT
        WHEN 1 THEN 'CR&Eacute;&Eacute;E(S)'
        WHEN 11 THEN 'VALID&Eacute;E(S)'
        ELSE 'CR&Eacute;&Eacute;E(S)'
        END AS etatLib,
    d.VAL AS IDDEPARTEMENTMAINTENANCELIB,
    pri.val AS prioritelib,
    departement.id AS IDDEPARTEMENTLIB
FROM DEMANDETRAVAUX dmd
         LEFT JOIN ENTITE e ON e.ID = dmd.IDENTITE
         LEFT JOIN SITUATION s ON s.ID = dmd.IDSITUATION
         LEFT JOIN AS_INGREDIENT_MAINTENANCE m ON m.ID = dmd.IDMACHINE
         LEFT JOIN DEPARTEMENTMAINTENANCE d ON d.ID = dmd.IDDEPARTEMENTMAINTENANCE
         LEFT JOIN PRIORITE pri ON dmd.priorite=pri.ID
         LEFT JOIN LOG_DEPARTEMENT departement ON departement.id=dmd.iddepartement;


CREATE TABLE ATTRIBUTIONELEMENT (
                                    ID                          VARCHAR2(255),
                                    IDINGREDIENTMAINTENANCE     VARCHAR2(255),
                                    IDPERSONNEL                 VARCHAR2(255),
                                    DATY                        DATE NOT NULL,
                                    ETATELEMENT                 VARCHAR2(255),
                                    TYPEATTRIBUTION             NUMBER DEFAULT 0 ,

                                    CONSTRAINT PK_ATTRIBUTIONELEMENT
                                        PRIMARY KEY (ID),

                                    CONSTRAINT FK_ATTRELEMENT_ING
                                        FOREIGN KEY (IDINGREDIENTMAINTENANCE)
                                            REFERENCES AS_INGREDIENT_MAINTENANCE(ID),

                                    CONSTRAINT FK_ATTRELEMENT_PERS
                                        FOREIGN KEY (IDPERSONNEL)
                                            REFERENCES PERSONNEL(ID),

                                    CONSTRAINT FK_ATTRIBUTIONELEMENT_ETAT
                                        FOREIGN KEY (ETATELEMENT)
                                            REFERENCES QUALITESOBJETMAINTENANCE(ID)
);


create sequence seqAttributionElement;
create function getseqAttributionElement return NUMBER is retour NUMBER;
begin
select
    seqAttributionElement.nextval
into
    retour
from
    dual;
return retour;
end;


create or replace view DEMANDETRAVAUX_CPL as
SELECT
    dmd."ID",dmd."IDENTITE",dmd."IDSITUATION",dmd."IDMACHINE",dmd."DATY",dmd."DATEBESOIN",dmd."PRIORITE",dmd."ESTEXISTANT",dmd."DESCRIPTION",dmd."ETAT",dmd."IDDEPARTEMENT",
    e.VAL AS idEntiteLib,
    s.VAL AS idSituationLib,
    m.LIBELLE AS idMachineLib,
    CASE dmd.ESTEXISTANT
        WHEN 0 THEN 'NON'
        WHEN 1 THEN 'OUI'
        ELSE 'Non spécifié'
        END AS estExistantLib,
    CASE dmd.ETAT
        WHEN 1 THEN 'CR&Eacute;&Eacute;E(S)'
        WHEN 11 THEN 'VALID&Eacute;E(S)'
        ELSE 'CR&Eacute;&Eacute;E(S)'
        END AS etatLib,
    d.VAL AS IDDEPARTEMENTMAINTENANCELIB,
    pri.val AS prioritelib,
    departement.id AS IDDEPARTEMENTLIB,
    otf.ID AS idOtFille
FROM DEMANDETRAVAUX dmd
         LEFT JOIN ENTITE e ON e.ID = dmd.IDENTITE
         LEFT JOIN SITUATION s ON s.ID = dmd.IDSITUATION
         LEFT JOIN AS_INGREDIENT_MAINTENANCE m ON m.ID = dmd.IDMACHINE
         LEFT JOIN DEPARTEMENTMAINTENANCE d ON d.ID = dmd.IDDEPARTEMENTMAINTENANCE
         LEFT JOIN PRIORITE pri ON dmd.priorite=pri.ID
         LEFT JOIN LOG_DEPARTEMENT departement ON departement.id=dmd.iddepartement
         LEFT JOIN ORDRETRAVAUX o ON o.IDBC = dmd.ID
         LEFT JOIN ORDRETRAVAUXFILLE otf ON otf.IDMERE = o.ID;

create or replace view ATTRIBUTIONELEMENTLIB as
select
    attr.*,
    asing.LIBELLE as IDINGREDIENTMAINTENANCELIB,
    pers.NOM as idPersonnelLib,
    qom.VAL as qualiteObjetMaintenanceLib,
    case
        when attr.TYPEATTRIBUTION = 0 then 'Sortie'
        when attr.TYPEATTRIBUTION = 1 then 'Retour'
        else 'Inconnu'
        end as typeAttributionLib
from
    ATTRIBUTIONELEMENT attr
        left join AS_INGREDIENT_MAINTENANCE ingm on attr.IDINGREDIENTMAINTENANCE = ingm.ID
        left join AS_INGREDIENTS asing on ingm.IDINGREDIENT = asing.ID
        left join PERSONNEL pers on attr.IDPERSONNEL = pers.ID
        left join QUALITESOBJETMAINTENANCE qom on attr.ETATELEMENT = qom.ID;

INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764919987323625', 'Attribution', 'list_alt', '', 3, 4, 'MENDYN1764614974716255');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764920046026392', 'Saisie', 'list_alt', 'module.jsp?but=maintenance/ressources/outils/attribution/attribution-saisie.jsp', 1, 5, 'MENDYN1764919987323625');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1764920078200526', 'Liste', 'list_alt', 'module.jsp?but=maintenance/ressources/outils/attribution/attribution-liste.jsp', 2, 5, 'MENDYN1764919987323625');

CREATE OR REPLACE VIEW INFOSAUTOLIB as(
select
ia.*,
ing.libelle as idingredientLib,
tc.val as typeDeCarburantLib,
uc.val as unitedeconsommationLib
from INFOSAUTO ia
left join AS_INGREDIENTS ing on ia.idingredient=ing.id
left join TYPECARBURANT tc on tc.id=ia.TYPEDECARBURANT
left join UNITECONSO uc on uc.id=ia.unitedeconsommation
);

       CREATE OR REPLACE VIEW dernierAttributionElement AS
SELECT ae.*
FROM ATTRIBUTIONELEMENT ae
         INNER JOIN (
    SELECT
        IDINGREDIENTMAINTENANCE,
        MAX(DATY) AS max_daty
    FROM ATTRIBUTIONELEMENT
    GROUP BY IDINGREDIENTMAINTENANCE
) derniere ON ae.IDINGREDIENTMAINTENANCE = derniere.IDINGREDIENTMAINTENANCE
    AND ae.DATY = derniere.max_daty;


create table AUTOCARBURANT
(
    ID       VARCHAR(50) not null
        primary key,
    DATY     DATE,
    IDAUTO   VARCHAR(50),
    MONTANT  NUMBER(10, 2),
    ODOMETRE NUMBER(10, 2),
    VOLUME   NUMBER(10)
);

create sequence seqAutoCarburant;

create function getSeqAutoCarburant return NUMBER is retour NUMBER;
begin
select
    seqAutoCarburant.nextval
into
    retour
from
    dual;
return retour;
end;


create or replace view autoMaintenance as
select
    im.ID,
    ai.LIBELLE as val,
    ' ' as desce
from AS_INGREDIENT_MAINTENANCE im
         left join AS_INGREDIENTS ai on im.IDINGREDIENT = ai.ID
where im.IDENTITE = 'ENT000003';


CREATE OR REPLACE VIEW etatrecapitulatifcommande AS
SELECT
    bcg.IDCLIENT,
    bcg.IDCLIENTLIB,
    bcg.DATY,
    SUM(bcg.pu * bcg.QUANTITE) as MONTANT,
    SUM(bcg.QTELIVRE) as qteLivre,
    SUM(bcg.QTENONLIVRE) as qteNonLivre,
    COALESCE(SUM(mc_accompte.CREDIT), 0) + COALESCE(SUM(mc_paye.CREDIT), 0) as montantPaye,
    COALESCE(SUM(bcg.pu * bcg.QUANTITE), 0) - COALESCE(COALESCE(SUM(mc_accompte.CREDIT), 0) + COALESCE(SUM(mc_paye.CREDIT), 0), 0) as montantRestant,
    CASE
        WHEN (COALESCE(SUM(mc_accompte.CREDIT), 0) + COALESCE(SUM(mc_paye.CREDIT), 0)) >= SUM(bcg.pu * bcg.QUANTITE) THEN 22
        WHEN (COALESCE(SUM(bcg.pu * bcg.QUANTITE), 0) - COALESCE(COALESCE(SUM(mc_accompte.CREDIT), 0) + COALESCE(SUM(mc_paye.CREDIT), 0), 0)) > 0 THEN 2
        WHEN SUM(bcg.QTELIVRE) = SUM(bcg.QUANTITE) THEN 111
        WHEN SUM(bcg.QTELIVRE) > 0 THEN 11
        ELSE 1
        END as etat,
    CASE
        WHEN (COALESCE(SUM(mc_accompte.CREDIT), 0) + COALESCE(SUM(mc_paye.CREDIT), 0)) >= SUM(bcg.pu * bcg.QUANTITE) THEN 'Pay&eacute;'
        WHEN (COALESCE(SUM(bcg.pu * bcg.QUANTITE), 0) - COALESCE(COALESCE(SUM(mc_accompte.CREDIT), 0) + COALESCE(SUM(mc_paye.CREDIT), 0), 0)) > 0 THEN 'Accompte'
        WHEN SUM(bcg.QTELIVRE) = SUM(bcg.QUANTITE) THEN 'Livr&eacute;'
        WHEN SUM(bcg.QTELIVRE) > 0 THEN 'non livr&eacute; en totalit&eacute;'
        ELSE 'non livr&eacute;'
        END as etatLib
FROM BONDECOMMANDE_CLIENT_GLOBALE bcg
         LEFT JOIN MOUVEMENTCAISSE mc_accompte ON mc_accompte.IDORIGINE = bcg.IDBC
         LEFT JOIN VENTE v ON v.IDORIGINE = bcg.IDBC
         LEFT JOIN MOUVEMENTCAISSE mc_paye ON mc_paye.IDORIGINE = v.ID
WHERE bcg.ETAT = 11
GROUP BY
    bcg.IDCLIENT,
    bcg.IDCLIENTLIB,
    bcg.DATY,
    bcg.IDBC;


CREATE OR REPLACE VIEW frequence_panne_machine AS
SELECT
    d.* ,
    ai.LIBELLE AS idMachineLib,
    1 AS qte
FROM DEMANDETRAVAUX d
         LEFT JOIN AS_INGREDIENT_MAINTENANCE m
                   ON d.IDMACHINE = m.ID
         LEFT JOIN AS_INGREDIENTS ai
                   ON m.IDINGREDIENT = ai.ID ;

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDNMT013425678978545', 'Analyse', 'list_alt', NULL, 3, 2, 'MNDNMT01');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENDYNfd1764610006403774', 'Liste', 'list_alt', 'module.jsp?but=maintenance/analyse/frequence-panne-machine.jsp#', 1, 3, 'MNDNMT013425678978545');



CREATE OR REPLACE  VIEW "PLANNING_CPL" AS SELECT
                                              p."ID",p."REFOBJET",p."ESTPERIODIQUE",p."IDTYPEMAINTENANCE",p."IDMACHINE",p."UNITE",p."FREQUENCE",p."DATEDEBUT",p."DATEFIN",p."DUREE",p."ETAT",p."HEURE",p."IDSOURCE",
                                              ai.LIBELLE AS idMachineLib,
                                              t.VAL AS idTypeMaintenanceLib,
                                              CASE
                                                  WHEN p.ESTPERIODIQUE = 1 THEN 'OUI'
                                                  ELSE 'NON'
                                                  END estPeriodiqueLib,
                                              CASE
                                                  WHEN p.ETAT = 11 THEN 'VALID&Eacute;E'
                                                  ELSE 'CR&Eacute;E'
                                                  END etatLib,
                                              u.VAL AS uniteLib,
                                              d.priorite,
                                              d.prioritelib,
                                              d.id AS iddemandetravaux,
                                              o.id AS idordretravaux,
                                              otf.id AS idordretravauxfille,
                                              CASE WHEN d.id IS NULL THEN 0 ELSE 1 END AS etatdemandetravaux,
                                              CASE WHEN o.id IS NULL THEN 0 ELSE 1 END AS etatordretravaux,
                                              CASE WHEN tr.id IS NULL THEN 0 ELSE 1 END AS etattravaux,
                                              CASE WHEN d.id IS NULL THEN 'Non cree' ELSE 'Cree' END AS etatdemandetravauxlib,
                                              CASE WHEN o.id IS NULL THEN 'Non cree' ELSE 'Cree' END AS etatordretravauxlib,
                                              CASE WHEN tr.id IS NULL THEN 'Non cree' ELSE 'Cree' END AS etattravauxlib,
                                              CASE WHEN tr.etat=41 THEN 1 ELSE 0 END AS estTerminee

                                          FROM PLANNING p
                                                   LEFT JOIN AS_INGREDIENT_MAINTENANCE aim ON aim.ID = p.IDMACHINE
                                                   LEFT JOIN AS_INGREDIENTS ai ON ai.id=aim.IDINGREDIENT
                                                   LEFT JOIN TYPEMAINTENANCE t ON t.ID = p.IDTYPEMAINTENANCE
                                                   LEFT JOIN UNITE_FREQUENCE u ON u.ID = p.UNITE
                                                   LEFT JOIN DEMANDETRAVAUX_CPL d ON d.ID = p.IDSOURCE
                                                   LEFT JOIN ORDRETRAVAUX o ON o.IDBC = d.ID
                                                   LEFT JOIN ORDRETRAVAUXFILLE otf ON otf.IDMERE = o.ID
                                                   LEFT JOIN TRAVAUX tr ON tr.IDOFFILLE=otf.id
                                                   LEFT JOIN TRAVAUXFILLE trf ON trf.IDMERE =tr.ID;


ALTER TABLE FACTUREFOURNISSEUR ADD IDOBJET VARCHAR(255);
ALTER TABLE FACTUREFOURNISSEUR ADD IDREF VARCHAR(255);

create or replace view FACTUREFOURNISSEURCPL_M as
SELECT f.ID,
       f.IDFOURNISSEUR,
       f2.NOM  AS IDFOURNISSEURLIB,
       f.IDMODEPAIEMENT,
       m.VAL   AS IDMODEPAIEMENTLIB,
       f.DATY,
       f.DESIGNATION,
       f.DATEECHEANCEPAIEMENT,
       f.ETAT,
       CASE
           WHEN f.ETAT = 1
               THEN 'CREEE'
           WHEN f.ETAT = 0
               THEN 'ANNULEE'
           WHEN f.ETAT = 11
               THEN 'VISEE'
           END AS ETATLIB,
       f.REFERENCE,
       f.IDBC,
       f.IDMAGASIN,
       f.DEVISE,
       case
           when f.TAUX=0 then 1
           else f.TAUX
           end as taux,
       p.VAL   AS idMagasinLib,
       f3.IDDEVISE,
       cast(f3.MONTANTTVA as number(30,2)) as MONTANTTVA,
       CAST(f3.MONTANTTTC-f3.MONTANTTVA as number(30,2)) AS MONTANTHT,
       cast(f3.MONTANTTTC as number(30,2)) as montantttc,
       cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.debit,0) AS NUMBER(30,2)) AS montantpaye,
       cast(f3.MONTANTTTC-nvl(mv.debit,0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(f3.tauxdechange,0) AS  NUMBER(30,2)) AS tauxdechange,
       prev.id as idPrevision,
       CASE
           WHEN f.estprevu=0 THEN 'NON'
           ELSE 'OUI'
           END
           AS estprevulib,
       f.IDOBJET,
       f.IDREF
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id;

create or replace view FACTUREFOURNISSEURCPL_TOUS_M as
SELECT
    fcpl.id,
    fcpl.idfournisseur,
    fcpl.idfournisseurlib,
    fcpl.idmodepaiement,
    fcpl.idmodepaiementlib,
    fcpl.daty,
    fcpl.designation,
    fcpl.dateecheancepaiement,
    fcpl.etatlib,
    fcpl.reference,
    fcpl.idbc,
    fcpl.idmagasin,
    fcpl.idmagasinlib,
    fcpl.devise,
    fcpl.iddevise,
    fcpl.etat,
    fcpl.taux,
    fcpl.montanttva,
    fcpl.montantht,
    fcpl.tauxdechange,
    fcpl.montantttc AS  MONTANTTTC,
    nvl((fcpl.montantpaye * fcpl.TAUXDECHANGE),0) AS MONTANTPAYE,
    nvl((fcpl.montantreste * fcpl.TAUXDECHANGE),0) AS MONTANTRESTE,
    fcpl.IDOBJET,
    fcpl.IDREF
FROM FACTUREFOURNISSEURCPL_M fcpl;


CREATE OR REPLACE  VIEW "PLANNING_CPL" ("ID", "REFOBJET", "ESTPERIODIQUE", "IDTYPEMAINTENANCE", "IDMACHINE", "UNITE", "FREQUENCE", "DATEDEBUT", "DATEFIN", "DUREE", "ETAT", "HEURE", "IDSOURCE", "IDMACHINELIB", "IDTYPEMAINTENANCELIB", "ESTPERIODIQUELIB", "ETATLIB", "UNITELIB", "PRIORITE", "PRIORITELIB", "IDDEMANDETRAVAUX", "IDORDRETRAVAUX", "IDORDRETRAVAUXFILLE", "IDTRAVAUX", "IDENTITE", "IDENTITELIB", "ETATDEMANDETRAVAUX", "ETATORDRETRAVAUX", "ETATTRAVAUX", "ETATDEMANDETRAVAUXLIB", "ETATORDRETRAVAUXLIB", "ETATTRAVAUXLIB", "ESTTERMINEE") AS
SELECT
    p."ID",p."REFOBJET",p."ESTPERIODIQUE",p."IDTYPEMAINTENANCE",p."IDMACHINE",p."UNITE",p."FREQUENCE",p."DATEDEBUT",p."DATEFIN",p."DUREE",p."ETAT",p."HEURE",p."IDSOURCE",
    ai.LIBELLE AS idMachineLib,
    t.VAL AS idTypeMaintenanceLib,
    CASE
        WHEN p.ESTPERIODIQUE = 1 THEN 'OUI'
        ELSE 'NON'
        END estPeriodiqueLib,
    CASE
        WHEN p.ETAT = 11 THEN 'VALID&Eacute;E'
        ELSE 'CR&Eacute;E'
        END etatLib,
    u.VAL AS uniteLib,
    d.priorite,
    d.prioritelib,
    d.id AS iddemandetravaux,
    o.id AS idordretravaux,
    otf.id AS idordretravauxfille,
    tr.id AS idtravaux,
    e.id AS identite,
    e.val AS identitelib,
    CASE WHEN d.id IS NULL THEN 0 ELSE 1 END AS etatdemandetravaux,
    CASE WHEN o.id IS NULL THEN 0 ELSE 1 END AS etatordretravaux,
    CASE WHEN tr.id IS NULL THEN 0 ELSE 1 END AS etattravaux,
    CASE WHEN d.id IS NULL THEN 'Non cree' ELSE 'Cree' END AS etatdemandetravauxlib,
    CASE WHEN o.id IS NULL THEN 'Non cree' ELSE 'Cree' END AS etatordretravauxlib,
    CASE WHEN tr.id IS NULL THEN 'Non cree' ELSE 'Cree' END AS etattravauxlib,
    CASE WHEN tr.etat=41 THEN 1 ELSE 0 END AS estTerminee

FROM PLANNING p
         LEFT JOIN AS_INGREDIENT_MAINTENANCE aim ON aim.ID = p.IDMACHINE
         LEFT JOIN AS_INGREDIENTS ai ON ai.id=aim.IDINGREDIENT
         LEFT JOIN TYPEMAINTENANCE t ON t.ID = p.IDTYPEMAINTENANCE
         LEFT JOIN UNITE_FREQUENCE u ON u.ID = p.UNITE
         LEFT JOIN DEMANDETRAVAUX_CPL d ON d.ID = p.IDSOURCE
         LEFT JOIN ORDRETRAVAUX o ON o.IDBC = d.ID
         LEFT JOIN ORDRETRAVAUXFILLE otf ON otf.IDMERE = o.ID
         LEFT JOIN TRAVAUX tr ON tr.IDOFFILLE=otf.id
         LEFT JOIN TRAVAUXFILLE trf ON trf.IDMERE =tr.ID
         LEFT JOIN ENTITE e ON e.id=aim.IDENTITE;



alter TABLE DEMANDETRAVAUX ADD idplanning varchar(40);
DELETE FROM MENUDYNAMIQUE
WHERE ID='MNDNMT0125';

-- manala menu ordre de travaux
INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('USRMEN762212345641213212132', '*', 'MNDNMT0117', NULL, NULL, NULL, 1);

-- manala menu saisie travaux
INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('USRMEN762212345641213212132221546564', '*', 'MNDNMT0121', NULL, NULL, NULL, 1);


UPDATE MENUDYNAMIQUE
SET LIBELLE='Frequence de panne par machine', ICONE='list_alt', HREF='module.jsp?but=maintenance/analyse/frequence-panne-machine.jsp#', RANG=1, NIVEAU=3, ID_PERE='MNDNMT013425678978545'
WHERE ID='MENDYNfd1764610006403774';
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENDYNfd1764610006403774011212', 'Nombre de panne par machine', 'list_alt', 'module.jsp?but=maintenance/analyse/nombre-panne-machine.jsp#', 2, 3, 'MNDNMT013425678978545');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENDYNfd1764610006403774011212', 'Nombre de panne par machine', 'list_alt', 'module.jsp?but=maintenance/analyse/nombre-panne-machine.jsp#', 2, 3, 'MNDNMT013425678978545');

CREATE OR REPLACE VIEW nombre_panne_machine as
SELECT
    d."ID",
    d."IDENTITE",
    d."IDSITUATION",
    d."IDMACHINE",
    d."DATY",
    d."DATEBESOIN",
    d."PRIORITE",
    d."ESTEXISTANT",
    d."DESCRIPTION",
    d."ETAT",
    d."DEMANDEUR",
    d."CAUSE",
    d."IDDEPARTEMENT",
    d."IDDEPARTEMENTMAINTENANCE",
    ai.LIBELLE AS idMachineLib,

    COUNT(*) OVER (PARTITION BY d.IDMACHINE, d.DATY) AS qte

FROM DEMANDETRAVAUX d
         LEFT JOIN AS_INGREDIENT_MAINTENANCE m
                   ON d.IDMACHINE = m.ID
         LEFT JOIN AS_INGREDIENTS ai
                   ON m.IDINGREDIENT = ai.ID

UPDATE menudynamique SET libelle = 'Configurations', href = '' WHERE id = 'MNDNMT012';
UPDATE menudynamique SET libelle = 'Maintenance planifiée', href = '' WHERE id = 'MNDNMT01';

-- script pour l'usermenu

DELETE FROM usermenu WHERE id = 'USRMEN762212345641213212132'; -- 1 rows
DELETE FROM usermenu WHERE id = 'USRMEN762212345641213212132221546564'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM33C0066D', 'MNDNMT0117', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM77B93B2A', 'MNDNMT0117', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB8B9BE63', 'MNDNMT0117', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM2AEE60E8', 'MNDNMT0117', NULL, 'pompiste', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD3BB5789', 'MNDNMT0121', NULL, 'caisse', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMD26815B0', 'MNDNMT0121', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMC7E4DA2D', 'MNDNMT0121', NULL, 'gestionnaire', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMAA8450A7', 'MNDNMT0121', NULL, 'pompiste', 1);

UPDATE menudynamique SET libelle = 'Maintenance', href = '' WHERE id = 'MNDNMT01';
UPDATE menudynamique SET libelle = 'Maintenance planifiée', href = '' WHERE id = 'MNDNMT0127';


@ -0,0 +1,57 @@
CREATE OR REPLACE  VIEW "PLANNING_CPL" ("ID", "REFOBJET", "ESTPERIODIQUE", "IDTYPEMAINTENANCE", "IDMACHINE", "UNITE", "FREQUENCE", "DATEDEBUT", "DATEFIN", "DUREE", "ETAT", "HEURE", "IDSOURCE", "IDMACHINELIB", "IDTYPEMAINTENANCELIB", "ESTPERIODIQUELIB", "ETATLIB", "UNITELIB", "PRIORITE", "PRIORITELIB", "IDDEMANDETRAVAUX", "IDORDRETRAVAUX", "IDORDRETRAVAUXFILLE", "IDTRAVAUX", "IDENTITE", "IDENTITELIB", "ETATDEMANDETRAVAUX", "ETATORDRETRAVAUX", "ETATTRAVAUX", "ETATDEMANDETRAVAUXLIB", "ETATORDRETRAVAUXLIB", "ETATTRAVAUXLIB") AS
SELECT
    p."ID",p."REFOBJET",p."ESTPERIODIQUE",p."IDTYPEMAINTENANCE",p."IDMACHINE",p."UNITE",p."FREQUENCE",p."DATEDEBUT",p."DATEFIN",p."DUREE",p."ETAT",p."HEURE",p."IDSOURCE",
    ai.LIBELLE AS idMachineLib,
    t.VAL AS idTypeMaintenanceLib,
    CASE
        WHEN p.ESTPERIODIQUE = 1 THEN 'OUI'
        ELSE 'NON'
        END estPeriodiqueLib,
    CASE
        WHEN p.ETAT = 11 THEN 'VALID&Eacute;E'
        ELSE 'CR&Eacute;E'
        END etatLib,
    u.VAL AS uniteLib,
    d.priorite,
    d.prioritelib,
    d.id AS iddemandetravaux,
    o.id AS idordretravaux,
    otf.id AS idordretravauxfille,
    tr.id AS idtravaux,
    e.id AS identite,
    e.val AS identitelib,
    d.etat AS etatdemandetravaux,
    o.etat AS etatordretravaux,
    tr.etat AS etattravaux,
    CASE d.etat
        WHEN 1  THEN 'Créée'
        WHEN 11 THEN 'Visée'
        ELSE 'Aucun'
        END AS etatdemandetravauxlib,
    CASE o.etat
        WHEN 1  THEN 'Créée'
        WHEN 11 THEN 'Visée'
        ELSE 'Aucun'
        END AS etatordretravauxlib,
    CASE tr.etat
        WHEN 1  THEN 'Créée'
        WHEN 11 THEN 'Visée'
        WHEN 21 THEN 'Entamée'
        WHEN 41 THEN 'Terminée'
        ELSE 'Aucun'
        END AS etatTravauxLib



FROM PLANNING p
         LEFT JOIN AS_INGREDIENT_MAINTENANCE aim ON aim.ID = p.IDMACHINE
         LEFT JOIN AS_INGREDIENTS ai ON ai.id=aim.IDINGREDIENT
         LEFT JOIN TYPEMAINTENANCE t ON t.ID = p.IDTYPEMAINTENANCE
         LEFT JOIN UNITE_FREQUENCE u ON u.ID = p.UNITE
         LEFT JOIN DEMANDETRAVAUX_CPL d ON d.ID = p.IDSOURCE
         LEFT JOIN ORDRETRAVAUX o ON o.IDBC = d.ID
         LEFT JOIN ORDRETRAVAUXFILLE otf ON otf.IDMERE = o.ID
         LEFT JOIN TRAVAUX tr ON tr.IDOFFILLE=otf.id
         LEFT JOIN TRAVAUXFILLE trf ON trf.IDMERE =tr.ID
         LEFT JOIN ENTITE e ON e.id=aim.IDENTITE
;

ALTER TABLE AS_INGREDIENT_MAINTENANCE ADD PU NUMBER(10,2) DEFAULT 0 NULL;
ALTER TABLE ATTRIBUTIONELEMENT ADD QTE number DEFAULT 0 NULL;
ALTER TABLE ATTRIBUTIONELEMENT ADD ETAT NUMBER DEFAULT 0 NULL;


CREATE OR REPLACE  VIEW "ATTRIBUTIONELEMENTLIB" ("ID", "IDINGREDIENTMAINTENANCE", "IDPERSONNEL", "DATY", "ETATELEMENT", "TYPEATTRIBUTION", "IDINGREDIENTMAINTENANCELIB", "IDPERSONNELLIB", "QUALITEOBJETMAINTENANCELIB", "TYPEATTRIBUTIONLIB", "QTE", "ETAT", "ETATLIB") AS
select
    attr."ID",attr."IDINGREDIENTMAINTENANCE",attr."IDPERSONNEL",attr."DATY",attr."ETATELEMENT",attr."TYPEATTRIBUTION",
    asing.LIBELLE as IDINGREDIENTMAINTENANCELIB,
    pers.NOM as idPersonnelLib,
    qom.VAL as qualiteObjetMaintenanceLib,
    case
        when attr.TYPEATTRIBUTION = 0 then 'Sortie'
        when attr.TYPEATTRIBUTION = 1 then 'Retour'
        else 'Inconnu'
        end as typeAttributionLib,
    attr.qte AS qte,
    attr.etat,
    case
        when attr.etat = 1 then 'Cree'
        when attr.etat = 11 then 'Valide'
        end as etatLib

from
    ATTRIBUTIONELEMENT attr
        left join AS_INGREDIENT_MAINTENANCE ingm on attr.IDINGREDIENTMAINTENANCE = ingm.ID
        left join AS_INGREDIENTS asing on ingm.IDINGREDIENT = asing.ID
        left join PERSONNEL pers on attr.IDPERSONNEL = pers.ID
        left join QUALITESOBJETMAINTENANCE qom on attr.ETATELEMENT = qom.ID;


CREATE OR REPLACE  VIEW "DEMANDETRAVAUX_CPL" ("ID", "IDENTITE", "IDSITUATION", "IDMACHINE", "DATY", "DATEBESOIN", "PRIORITE", "ESTEXISTANT", "DESCRIPTION", "ETAT", "IDDEPARTEMENT", "IDENTITELIB", "IDSITUATIONLIB", "IDMACHINELIB", "ESTEXISTANTLIB", "ETATLIB", "IDDEPARTEMENTMAINTENANCE","IDDEPARTEMENTMAINTENANCELIB", "PRIORITELIB", "IDDEPARTEMENTLIB", "IDOTFILLE") AS
SELECT
    dmd."ID",dmd."IDENTITE",dmd."IDSITUATION",dmd."IDMACHINE",dmd."DATY",dmd."DATEBESOIN",dmd."PRIORITE",dmd."ESTEXISTANT",dmd."DESCRIPTION",dmd."ETAT",dmd."IDDEPARTEMENT",
    e.VAL AS idEntiteLib,
    s.VAL AS idSituationLib,
    m.LIBELLE AS idMachineLib,
    CASE dmd.ESTEXISTANT
        WHEN 0 THEN 'NON'
        WHEN 1 THEN 'OUI'
        ELSE 'Non spécifié'
        END AS estExistantLib,
    CASE dmd.ETAT
        WHEN 1 THEN 'CR&Eacute;&Eacute;E(S)'
        WHEN 11 THEN 'VALID&Eacute;E(S)'
        ELSE 'CR&Eacute;&Eacute;E(S)'
        END AS etatLib,
    d.id AS IDDEPARTEMENTMAINTENANCE,
    d.VAL AS IDDEPARTEMENTMAINTENANCELIB,
    pri.val AS prioritelib,
    departement.id AS IDDEPARTEMENTLIB,
    otf.ID AS idOtFille
FROM DEMANDETRAVAUX dmd
         LEFT JOIN ENTITE e ON e.ID = dmd.IDENTITE
         LEFT JOIN SITUATION s ON s.ID = dmd.IDSITUATION
         LEFT JOIN AS_INGREDIENT_MAINTENANCE m ON m.ID = dmd.IDMACHINE
         LEFT JOIN DEPARTEMENTMAINTENANCE d ON d.ID = dmd.IDDEPARTEMENTMAINTENANCE
         LEFT JOIN PRIORITE pri ON dmd.priorite=pri.ID
         LEFT JOIN LOG_DEPARTEMENT departement ON departement.id=dmd.iddepartement
         LEFT JOIN ORDRETRAVAUX o ON o.IDBC = dmd.ID
         LEFT JOIN ORDRETRAVAUXFILLE otf ON otf.IDMERE = o.ID;


CREATE OR REPLACE FORCE VIEW processLib AS
SELECT
    p.IDHISTORIQUE ,
    p.DATEHISTORIQUE ,
    p.HEURE ,
    p.OBJET ,
    p.REFOBJET ,
    p.REMARQUE ,
    p.IDUTILISATEUR ,
    p."ACTION" ,
    p.ECART ,
    pers.NOM || ' ' || pers.TELEPHONE AS acteur
FROM
    PROCESS p
        LEFT JOIN PERSONNEL pers ON
        p.acteur = pers.id;


DELETE FROM usermenu WHERE id = 'USRMEN0304001'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB4E638A4', 'MENUDYN00304001', NULL, 'dg', 0);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1E894CC6', 'MENUDYN00304002', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMB55C07AC', 'MENUDYN00304003', NULL, 'dg', 1);
DELETE FROM usermenu WHERE id = 'UM1E894CC6'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UMB55C07AC'; -- 1 rows
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UMBEDDFF1B', 'MENUDYN0304008', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM14CECC85', 'MENUDYN0304009', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM922CC025', 'MENUDYN3204004', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM756BE06A', 'MENUDYN0304005', NULL, 'dg', 1);
INSERT INTO usermenu (id, idmenu, refuser, idrole, interdit) VALUES ('UM1BD8CB2B', 'MENUDYN3004006', NULL, 'dg', 1);
DELETE FROM usermenu WHERE id = 'UMBEDDFF1B'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM14CECC85'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM922CC025'; -- 1 rows
DELETE FROM usermenu WHERE id = 'UM756BE06A'; -- 1 rows


CREATE OR REPLACE  VIEW "DEMANDETRAVAUX_CPL" ("ID", "IDENTITE", "IDSITUATION", "IDMACHINE", "DATY", "DATEBESOIN", "PRIORITE", "ESTEXISTANT", "DESCRIPTION", "ETAT", "IDDEPARTEMENT", "IDENTITELIB", "IDSITUATIONLIB", "IDMACHINELIB", "ESTEXISTANTLIB", "ETATLIB", "IDDEPARTEMENTMAINTENANCE", "IDDEPARTEMENTMAINTENANCELIB", "PRIORITELIB", "IDDEPARTEMENTLIB", "IDOTFILLE","IDTYPEMAINTENANCE","IDTYPEMAINTENANCELIB") AS
SELECT
    dmd."ID",dmd."IDENTITE",dmd."IDSITUATION",dmd."IDMACHINE",dmd."DATY",dmd."DATEBESOIN",dmd."PRIORITE",dmd."ESTEXISTANT",dmd."DESCRIPTION",dmd."ETAT",dmd."IDDEPARTEMENT",
    e.VAL AS idEntiteLib,
    s.VAL AS idSituationLib,
    m.LIBELLE AS idMachineLib,
    CASE dmd.ESTEXISTANT
        WHEN 0 THEN 'NON'
        WHEN 1 THEN 'OUI'
        ELSE 'Non spécifié'
        END AS estExistantLib,
    CASE dmd.ETAT
        WHEN 1 THEN 'CR&Eacute;&Eacute;E(S)'
        WHEN 11 THEN 'VALID&Eacute;E(S)'
        ELSE 'CR&Eacute;&Eacute;E(S)'
        END AS etatLib,
    d.id AS IDDEPARTEMENTMAINTENANCE,
    d.VAL AS IDDEPARTEMENTMAINTENANCELIB,
    pri.val AS prioritelib,
    departement.val AS IDDEPARTEMENTLIB,
    otf.ID AS idOtFille,
    pl.idtypemaintenance AS idtypemaintenance,
    tm.val AS idtypemaintenancelib
FROM DEMANDETRAVAUX dmd
         LEFT JOIN ENTITE e ON e.ID = dmd.IDENTITE
         LEFT JOIN SITUATION s ON s.ID = dmd.IDSITUATION
         LEFT JOIN AS_INGREDIENT_MAINTENANCE m ON m.ID = dmd.IDMACHINE
         LEFT JOIN DEPARTEMENTMAINTENANCE d ON d.ID = dmd.IDDEPARTEMENTMAINTENANCE
         LEFT JOIN PRIORITE pri ON dmd.priorite=pri.ID
         LEFT JOIN LOG_DEPARTEMENT departement ON departement.id=dmd.iddepartement
         LEFT JOIN ORDRETRAVAUX o ON o.IDBC = dmd.ID
         LEFT JOIN ORDRETRAVAUXFILLE otf ON otf.IDMERE = o.ID
         LEFT JOIN PLANNING pl ON pl.id=dmd.idplanning
         LEFT JOIN TYPEMAINTENANCE tm ON tm.id=pl.idtypemaintenance
;


CREATE OR replace VIEW DEMANDETRAVAUX_CPL_NOMBRE AS
SELECT
    ID,
    IDENTITE,
    IDSITUATION,
    IDMACHINE,
    DATY,
    DATEBESOIN,
    PRIORITE,
    ESTEXISTANT,
    DESCRIPTION,
    ETAT,
    IDDEPARTEMENT,
    IDENTITELIB,
    IDSITUATIONLIB,
    IDMACHINELIB,
    ESTEXISTANTLIB,
    ETATLIB,
    IDDEPARTEMENTMAINTENANCE,
    IDDEPARTEMENTMAINTENANCELIB,
    PRIORITELIB,
    IDDEPARTEMENTLIB,
    IDOTFILLE,
    COUNT(*) AS qte
FROM DEMANDETRAVAUX_CPL
GROUP BY
    ID,
    IDENTITE,
    IDSITUATION,
    IDMACHINE,
    DATY,
    DATEBESOIN,
    PRIORITE,
    ESTEXISTANT,
    DESCRIPTION,
    ETAT,
    IDDEPARTEMENT,
    IDENTITELIB,
    IDSITUATIONLIB,
    IDMACHINELIB,
    ESTEXISTANTLIB,
    ETATLIB,
    IDDEPARTEMENTMAINTENANCE,
    IDDEPARTEMENTMAINTENANCELIB,
    PRIORITELIB,
    IDDEPARTEMENTLIB,
    IDOTFILLE
ORDER BY qte DESC;

CREATE OR REPLACE  VIEW FREQUENCE_PANNE_MACHINE ("ID", "IDENTITE", "IDSITUATION", "IDMACHINE", "DATY", "DATEBESOIN", "PRIORITE", "ESTEXISTANT", "DESCRIPTION", "ETAT", "IDDEPARTEMENT", "CAUSE", "DEMANDEUR", "IDDEPARTEMENTMAINTENANCE", "IDMACHINELIB", "QTE") AS
SELECT
    d."ID",d."IDENTITE",d."IDSITUATION",d."IDMACHINE",d."DATY",d."DATEBESOIN",d."PRIORITE",d."ESTEXISTANT",d."DESCRIPTION",d."ETAT",d."IDDEPARTEMENT",d."CAUSE",d."DEMANDEUR",d."IDDEPARTEMENTMAINTENANCE" ,
    ai.LIBELLE AS idMachineLib,
    1 AS qte
FROM DEMANDETRAVAUX d
         LEFT JOIN AS_INGREDIENT_MAINTENANCE m
                   ON d.IDMACHINE = m.ID
         LEFT JOIN AS_INGREDIENTS ai
                   ON m.IDINGREDIENT = ai.ID ;


INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MEND02302320203023', 'Frequence demande par departement', 'list_alt', 'module.jsp?but=maintenance/analyse/frequence-demande-departement.jsp#', 3, 3, 'MNDNMT013425678978545');

UPDATE MENUDYNAMIQUE
SET LIBELLE='Frequence de demande par departement', ICONE='list_alt', HREF='module.jsp?but=maintenance/analyse/frequence-demande-departement.jsp#', RANG=3, NIVEAU=3, ID_PERE='MNDNMT013425678978545'
WHERE ID='MEND02302320203023';

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MEND00220305056506', 'Rapprochement de realisation', 'list_alt', 'module.jsp?but=maintenance/analyse/rapprochement-realisation.jsp', 4, 3, 'MNDNMT013425678978545');

UPDATE MENUDYNAMIQUE
SET LIBELLE='Frequence de demande par departement', ICONE='list_alt', HREF='module.jsp?but=maintenance/analyse/frequence-demande-departement.jsp', RANG=3, NIVEAU=3, ID_PERE='MNDNMT013425678978545'
WHERE ID='MEND02302320203023';

UPDATE MENUDYNAMIQUE
SET LIBELLE='Frequence de panne par machine', ICONE='list_alt', HREF='module.jsp?but=maintenance/analyse/frequence-panne-machine.jsp', RANG=1, NIVEAU=3, ID_PERE='MNDNMT013425678978545'
WHERE ID='MENDYNfd1764610006403774';


CREATE OR REPLACE VIEW PLANNING_CPL AS
SELECT
    p.ID,
    p.REFOBJET,
    p.ESTPERIODIQUE,
    p.IDTYPEMAINTENANCE,
    p.IDMACHINE,
    p.UNITE,
    p.FREQUENCE,
    p.DATEDEBUT,
    p.DATEFIN,
    p.DUREE,
    p.ETAT,
    p.HEURE,
    p.IDSOURCE,
    ai.LIBELLE AS idMachineLib,
    t.VAL AS idTypeMaintenanceLib,
    CASE
        WHEN p.ESTPERIODIQUE = 1 THEN 'OUI'
        ELSE 'NON'
        END estPeriodiqueLib,
    CASE
        WHEN p.ETAT = 11 THEN 'VALID&Eacute;E'
        ELSE 'CR&Eacute;E'
        END etatLib,
    u.VAL AS uniteLib,
    d.priorite,
    d.prioritelib,
    d.id AS iddemandetravaux,
    o.id AS idordretravaux,
    otf.id AS idordretravauxfille,
    tr.id AS idtravaux,
    e.id AS identite,
    e.val AS identitelib,
    d.etat AS etatdemandetravaux,
    o.etat AS etatordretravaux,
    tr.etat AS etattravaux,
    CASE d.etat
        WHEN 1  THEN 'Créée'
        WHEN 11 THEN 'Visée'
        ELSE 'Aucun'
        END AS etatdemandetravauxlib,
    CASE o.etat
        WHEN 1  THEN 'Créée'
        WHEN 11 THEN 'Visée'
        ELSE 'Aucun'
        END AS etatordretravauxlib,
    CASE tr.etat
        WHEN 1  THEN 'Créée'
        WHEN 11 THEN 'Visée'
        WHEN 21 THEN 'Entamée'
        WHEN 41 THEN 'Terminée'
        ELSE 'Aucun'
        END AS etatTravauxLib,
    cout.couttravaux

FROM PLANNING p
         LEFT JOIN AS_INGREDIENT_MAINTENANCE aim ON aim.ID = p.IDMACHINE
         LEFT JOIN AS_INGREDIENTS ai ON ai.id = aim.IDINGREDIENT
         LEFT JOIN TYPEMAINTENANCE t ON t.ID = p.IDTYPEMAINTENANCE
         LEFT JOIN UNITE_FREQUENCE u ON u.ID = p.UNITE
         LEFT JOIN DEMANDETRAVAUX_CPL d ON d.ID = p.IDSOURCE
         LEFT JOIN ORDRETRAVAUX o ON o.IDBC = d.ID
         LEFT JOIN ORDRETRAVAUXFILLE otf ON otf.IDMERE = o.ID
         LEFT JOIN TRAVAUX tr ON tr.IDOFFILLE = otf.id
         LEFT JOIN (
    SELECT
        trf.IDMERE,
        SUM(trf.qte * trf.pu) AS couttravaux
    FROM TRAVAUXFILLE trf
    GROUP BY trf.IDMERE
) cout ON cout.IDMERE = tr.ID
         LEFT JOIN ENTITE e ON e.id = aim.IDENTITE
;

@ -0,0 +1,53 @@
create or replace view FACTUREFOURNISSEURAVECMACHINE as
SELECT f.ID,
       f.IDFOURNISSEUR,
       f2.NOM  AS IDFOURNISSEURLIB,
       f.IDMODEPAIEMENT,
       m.VAL   AS IDMODEPAIEMENTLIB,
       f.DATY,
       f.DESIGNATION,
       f.DATEECHEANCEPAIEMENT,
       f.ETAT,
       CASE
           WHEN f.ETAT = 1
               THEN 'CREEE'
           WHEN f.ETAT = 0
               THEN 'ANNULEE'
           WHEN f.ETAT = 11
               THEN 'VISEE'
           END AS ETATLIB,
       f.REFERENCE,
       f.IDBC,
       f.IDMAGASIN,
       f.DEVISE,
       case
           when f.TAUX=0 then 1
           else f.TAUX
           end as taux,
       p.VAL   AS idMagasinLib,
       f3.IDDEVISE,
       cast(f3.MONTANTTVA as number(30,2)) as MONTANTTVA,
       CAST(f3.MONTANTTTC-f3.MONTANTTVA as number(30,2)) AS MONTANTHT,
       cast(f3.MONTANTTTC as number(30,2)) as montantttc,
       cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.debit,0) AS NUMBER(30,2)) AS montantpaye,
       cast(f3.MONTANTTTC-nvl(mv.debit,0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(f3.tauxdechange,0) AS  NUMBER(30,2)) AS tauxdechange,
       prev.id as idPrevision,
       CASE
           WHEN f.estprevu=0 THEN 'NON'
           ELSE 'OUI'
           END
           AS estprevulib,
       f.IDOBJET,
       f.IDREF,
       machine.LIBELLE AS idObjetLib,
       machine.IDENTITE
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id
         JOIN AS_INGREDIENT_MAINTENANCE machine ON machine.ID = f.IDOBJET;



CREATE OR REPLACE VIEW PLANNING_CPL AS
SELECT
    p.ID,
    p.REFOBJET,
    p.ESTPERIODIQUE,
    p.IDTYPEMAINTENANCE,
    p.IDMACHINE,
    p.UNITE,
    p.FREQUENCE,
    p.DATEDEBUT,
    p.DATEFIN,
    p.DUREE,
    p.ETAT,
    p.HEURE,
    p.IDSOURCE,
    ai.LIBELLE AS idMachineLib,
    t.VAL AS idTypeMaintenanceLib,
    CASE
        WHEN p.ESTPERIODIQUE = 1 THEN 'OUI'
        ELSE 'NON'
        END estPeriodiqueLib,
    CASE
        WHEN p.ETAT = 11 THEN 'VALID&Eacute;E'
        ELSE 'CR&Eacute;E'
        END etatLib,
    u.VAL AS uniteLib,
    d.priorite,
    d.prioritelib,
    d.id AS iddemandetravaux,
    o.id AS idordretravaux,
    otf.id AS idordretravauxfille,
    tr.id AS idtravaux,
    e.id AS identite,
    e.val AS identitelib,
    d.etat AS etatdemandetravaux,
    o.etat AS etatordretravaux,
    tr.etat AS etattravaux,
    CASE d.etat
        WHEN 1  THEN 'Créée'
        WHEN 11 THEN 'Visée'
        ELSE 'Aucun'
        END AS etatdemandetravauxlib,
    CASE o.etat
        WHEN 1  THEN 'Créée'
        WHEN 11 THEN 'Visée'
        ELSE 'Aucun'
        END AS etatordretravauxlib,
    CASE tr.etat
        WHEN 1  THEN 'Créée'
        WHEN 11 THEN 'Visée'
        WHEN 21 THEN 'Entamée'
        WHEN 41 THEN 'Terminée'
        ELSE 'Aucun'
        END AS etatTravauxLib,
    coalesce(SUM(fff.pu * fff.qte), 0) AS cout

FROM PLANNING p
         LEFT JOIN AS_INGREDIENT_MAINTENANCE aim ON aim.ID = p.IDMACHINE
         LEFT JOIN AS_INGREDIENTS ai ON ai.id = aim.IDINGREDIENT
         LEFT JOIN TYPEMAINTENANCE t ON t.ID = p.IDTYPEMAINTENANCE
         LEFT JOIN UNITE_FREQUENCE u ON u.ID = p.UNITE
         LEFT JOIN DEMANDETRAVAUX_CPL d ON d.ID = p.IDSOURCE
         LEFT JOIN ORDRETRAVAUX o ON o.IDBC = d.ID
         LEFT JOIN ORDRETRAVAUXFILLE otf ON otf.IDMERE = o.ID
         LEFT JOIN TRAVAUX tr ON tr.IDOFFILLE = otf.id
         LEFT JOIN TRAVAUXFILLE trf ON trf.IDMERE = tr.ID
         LEFT JOIN ENTITE e ON e.id = aim.IDENTITE
         LEFT JOIN FACTUREFOURNISSEUR f ON f.IDREF = tr.id
         LEFT JOIN FACTUREFOURNISSEURFILLE fff ON fff.IDFACTUREFOURNISSEUR = f.ID

GROUP BY
    p.ID, p.REFOBJET, p.ESTPERIODIQUE, p.IDTYPEMAINTENANCE, p.IDMACHINE, p.UNITE,
    p.FREQUENCE, p.DATEDEBUT, p.DATEFIN, p.DUREE, p.ETAT, p.HEURE, p.IDSOURCE,
    ai.LIBELLE, t.VAL, u.VAL,
    d.priorite, d.prioritelib, d.id, d.etat,
    o.id, o.etat,
    otf.id,
    tr.id, tr.etat,
    e.id, e.val
;

UPDATE MENUDYNAMIQUE
SET LIBELLE='Saisie', ICONE='list_alt', HREF='module.jsp?but=maintenance/configuration/unite/unitemaintenance-saisie.jsp', RANG=1, NIVEAU=4, ID_PERE='MENDYN1764601493001676'
WHERE ID='MENDYN1764601565475292';

ALTER TABLE AS_INGREDIENT_MAINTENANCE ADD IDLIGNE varchar(40);

CREATE TABLE LIGNE (
                       ID VARCHAR(50) PRIMARY KEY NOT NULL,
                       VAL varchar(40),
                       DESCE varchar(300)
);
INSERT INTO LIGNE
(ID, VAL, DESCE)
VALUES('L001', 'LIGNE BONBON DUR', 'LIGNE BONBON DUR');
INSERT INTO LIGNE
(ID, VAL, DESCE)
VALUES('L002', 'LIGNE BUBBLE-GUM', 'LIGNE BUBBLE-GUM');
INSERT INTO LIGNE
(ID, VAL, DESCE)
VALUES('L003', 'LIGNE PASTILLE ROBIN', 'LIGNE PASTILLE ROBIN');

CREATE OR REPLACE  VIEW "AS_INGREDIENT_MAINTENANCE_LIB" ("ID", "IDINGREDIENT", "IDENTITE", "REFERENCEOBJET", "MARQUEOBJET", "MODELEOBJET", "NUMEROSERIEOBJET", "DESCRIPTIONOBJET", "QUALITEOBJET", "ETATOBJET", "LOCALISATIONOBJET", "PUISSANCEOBJET", "OBSERVATIONOBJET", "TYPERATTACHEMENT", "ESTENGIN", "LIBELLE", "DATEAQUISITION", "INGREDIENTLIB", "IDENTITELIB", "QUALITEOBJETLIB", "ETATOBJETLIB", "LOCALISATIONOBJETLIB", "ESTENGINLIB","IDLIGNE","IDLIGNELIB") AS
SELECT
    am."ID",am."IDINGREDIENT",am."IDENTITE",am."REFERENCEOBJET",am."MARQUEOBJET",am."MODELEOBJET",am."NUMEROSERIEOBJET",am."DESCRIPTIONOBJET",am."QUALITEOBJET",am."ETATOBJET",am."LOCALISATIONOBJET",am."PUISSANCEOBJET",am."OBSERVATIONOBJET",am."TYPERATTACHEMENT",am."ESTENGIN",am."LIBELLE",am."DATEAQUISITION",
    ai.libelle AS INGREDIENTLIB,
    am.IDENTITE AS IDENTITELIB,
    qo.VAL AS QUALITEOBJETLIB,
    eo.VAL AS ETATOBJETLIB,
    ld.val AS localisationObjetLib,
    CASE
        WHEN am.ESTENGIN = 1 THEN 'Oui'
        ELSE 'Non'
        END AS ESTENGINLIB,
    l.id AS idligne,
    l.val AS idlignelib
FROM AS_INGREDIENTS ai
         JOIN AS_INGREDIENT_MAINTENANCE am ON ai.ID = am.IDINGREDIENT
         LEFT JOIN QUALITESOBJETMAINTENANCE qo ON am.QUALITEOBJET = qo.ID
         LEFT JOIN ETATOBJETMAINTENANCE eo ON am.ETATOBJET = eo.ID
         left join LOG_DEPARTEMENT ld on am.localisationObjet=ld.id
         LEFT JOIN LIGNE l ON l.id=am.idligne;

UPDATE USERMENU
SET REFUSER=NULL, IDMENU='MNDNMT0117', IDROLE='dg', CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=0
WHERE ID='UM77B93B2A';
UPDATE USERMENU
SET REFUSER=NULL, IDMENU='MNDNMT0117', IDROLE='gestionnaire', CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=0
WHERE ID='UMB8B9BE63';
UPDATE USERMENU
SET REFUSER=NULL, IDMENU='MNDNMT0117', IDROLE='caisse', CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=0
WHERE ID='UM33C0066D';
UPDATE USERMENU
SET REFUSER=NULL, IDMENU='MNDNMT0117', IDROLE='pompiste', CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=0
WHERE ID='UM2AEE60E8';

UPDATE USERMENU
SET REFUSER='*', IDMENU='MNDNMT0119', IDROLE='dg', CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=1
WHERE ID='UM2AEE60E80235454457';

INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('UMMMT02356446545', '*', 'MENDYN1764919987323625', NULL, NULL, NULL, 1);

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MEND02302320203023023556', 'Depense par Machine', 'list_alt', 'module.jsp?but=maintenance/analyse/depense-machine.jsp', 5, 3, 'MNDNMT013425678978545');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MEND023023202030230235562231', 'Depense par Ligne', 'list_alt', 'module.jsp?but=maintenance/analyse/depense-ligne.jsp', 6, 3, 'MNDNMT013425678978545');



CREATE OR REPLACE  VIEW "FACTUREFOURNISSEURAVECMACHINE" ("ID", "IDFOURNISSEUR", "IDFOURNISSEURLIB", "IDMODEPAIEMENT", "IDMODEPAIEMENTLIB", "DATY", "DESIGNATION", "DATEECHEANCEPAIEMENT", "ETAT", "ETATLIB", "REFERENCE", "IDBC", "IDMAGASIN", "DEVISE", "TAUX", "IDMAGASINLIB", "IDDEVISE", "MONTANTTVA", "MONTANTHT", "MONTANTTTC", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTRESTE", "TAUXDECHANGE", "IDPREVISION", "ESTPREVULIB", "IDOBJET", "IDREF", "IDOBJETLIB", "IDENTITE","IDLIGNE","IDLIGNELIB") AS
SELECT f.ID,
       f.IDFOURNISSEUR,
       f2.NOM  AS IDFOURNISSEURLIB,
       f.IDMODEPAIEMENT,
       m.VAL   AS IDMODEPAIEMENTLIB,
       f.DATY,
       f.DESIGNATION,
       f.DATEECHEANCEPAIEMENT,
       f.ETAT,
       CASE
           WHEN f.ETAT = 1
               THEN 'CREEE'
           WHEN f.ETAT = 0
               THEN 'ANNULEE'
           WHEN f.ETAT = 11
               THEN 'VISEE'
           END AS ETATLIB,
       f.REFERENCE,
       f.IDBC,
       f.IDMAGASIN,
       f.DEVISE,
       case
           when f.TAUX=0 then 1
           else f.TAUX
           end as taux,
       p.VAL   AS idMagasinLib,
       f3.IDDEVISE,
       cast(f3.MONTANTTVA as number(30,2)) as MONTANTTVA,
       CAST(f3.MONTANTTTC-f3.MONTANTTVA as number(30,2)) AS MONTANTHT,
       cast(f3.MONTANTTTC as number(30,2)) as montantttc,
       cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.debit,0) AS NUMBER(30,2)) AS montantpaye,
       cast(f3.MONTANTTTC-nvl(mv.debit,0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(f3.tauxdechange,0) AS  NUMBER(30,2)) AS tauxdechange,
       prev.id as idPrevision,
       CASE
           WHEN f.estprevu=0 THEN 'NON'
           ELSE 'OUI'
           END
           AS estprevulib,
       f.IDOBJET,
       f.IDREF,
       machine.LIBELLE AS idObjetLib,
       machine.IDENTITE,
       ligne.id AS idligne,
       ligne.val AS idlignelib
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id
         JOIN AS_INGREDIENT_MAINTENANCE machine ON machine.ID = f.IDOBJET
         LEFT JOIN LIGNE ligne ON ligne.id=machine.idLIGNE;


UPDATE USERMENU
SET REFUSER=NULL, IDMENU='MNDNMT0117', IDROLE='dg', CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=0
WHERE ID='UMF8374ABA';
UPDATE USERMENU
SET REFUSER=NULL, IDMENU='MNDNMT0117', IDROLE='gestionnaire', CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=0
WHERE ID='UM3A1046FE';
UPDATE USERMENU
SET REFUSER=NULL, IDMENU='MNDNMT0117', IDROLE='pompiste', CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=0
WHERE ID='UMEC9E045B';
UPDATE USERMENU
SET REFUSER=NULL, IDMENU='MNDNMT0117', IDROLE='caisse', CODESERVICE=NULL, CODEDIR=NULL, INTERDIT=0
WHERE ID='UM1A625FD1';

INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('UMMMT5465121254654', '*', 'MNDNMT0119', NULL, NULL, NULL, 1);


CREATE OR REPLACE  VIEW "TRAVAUXCPL" ("ID", "LANCEPAR", "CIBLE", "REMARQUE", "LIBELLE", "BESOIN", "DATY", "IDOFFILLE", "IDOF", "LANCEPARLIB", "CIBLELIB", "ETAT", "ETATLIB", "FABRICATIONPREC", "FABRICATIONSUIV","IDINGREDIENTMAINTENANCE") AS
SELECT
    f.ID,f.LANCEPAR,f.CIBLE,f.REMARQUE,f.LIBELLE,f.BESOIN,f.DATY,f.idOffille,nvl(f.idof, off.idmere) AS idof,
    p.val AS lanceparLib,
    p2.val AS cibleLib,
    f.etat AS etat,
    CASE
        WHEN f.ETAT=1
            THEN 'CR&Eacute;E'
        WHEN f.ETAT=11
            THEN 'VALID&Eacute;E'
        WHEN f.ETAT=0
            THEN 'ANNUL&Eacute;E'
        WHEN f.ETAT=21
            THEN 'ENTAM&Eacute;E'
        WHEN f.ETAT=31
            THEN 'BLOQU&Eacute;E'
        WHEN f.ETAT=41
            THEN 'TERMIN&Eacute;E'
        END AS ETATLIB,
    f.FABRICATIONPREC,
    f.FABRICATIONSUIV,
    off.idIngredients AS idIngredientMaintenance
FROM TRAVAUX f
         LEFT JOIN ENTITE p ON p.id = f.lancepar
         LEFT JOIN MAGASIN p2 ON p2.id = f.cible
         LEFT JOIN ORDRETRAVAUXFILLE off ON f.idoffille = off.id;

UPDATE MENUDYNAMIQUE
SET LIBELLE='Nombre de panne par machine', ICONE='list_alt', HREF='module.jsp?but=maintenance/analyse/nombre-panne-machine.jsp#', RANG=2, NIVEAU=3, ID_PERE='MNDNMT013425678978545'
WHERE ID='MEN64610006403774011212';
UPDATE MENUDYNAMIQUE
SET LIBELLE='Frequence de panne par machine', ICONE='list_alt', HREF='module.jsp?but=maintenance/analyse/frequence-panne-machine.jsp', RANG=1, NIVEAU=3, ID_PERE='MNDNMT013425678978545'
WHERE ID='MEN764610006403774';

INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('UMMMT546512125465412345', '*', 'MEN764610006403774', NULL, NULL, NULL, 1);