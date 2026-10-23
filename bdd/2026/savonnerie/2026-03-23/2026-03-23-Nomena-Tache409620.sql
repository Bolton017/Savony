INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1773928625523269', 'Étude OF', 'construction', '', 5, 3, 'MENUDYN00304002');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1773928648677486', 'Saisie', 'add', 'module.jsp?but=fabrication/EtudeOF-saisie.jsp', 1, 4, 'MENDYN1773928625523269');
INSERT INTO menudynamique (id, libelle, icone, href, rang, niveau, id_pere) VALUES ('MENDYN1773928669085994', 'Liste', 'view_list', 'module.jsp?but=fabrication/EtudeOF-liste.jsp', 2, 4, 'MENDYN1773928625523269');
DELETE FROM menudynamique WHERE id = 'MENDYN1773928648677486';
UPDATE menudynamique SET rang = 1 WHERE id = 'MENDYN1773928669085994';
DELETE FROM menudynamique WHERE id = 'MENDYN1773928669085994';
UPDATE menudynamique SET href = 'module.jsp?but=fabrication/EtudeOF-liste.jsp' WHERE id = 'MENDYN1773928625523269';
UPDATE menudynamique SET rang = 2, niveau = 2, id_pere = 'MENUDYN00304001' WHERE id = 'MENDYN1773928625523269';
UPDATE menudynamique SET href = '#', rang = 3 WHERE id = 'MENUDYN00304002';
UPDATE menudynamique SET rang = 4 WHERE id = 'MENUDYN01908001';
UPDATE menudynamique SET rang = 5 WHERE id = 'MENUDYN02108001';
UPDATE menudynamique SET rang = 6 WHERE id = 'MNDN00001';
UPDATE menudynamique SET rang = 7 WHERE id = 'MENDYN1773921067406940';


create table EtudeOF
(
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
        constraint FK_EtudeOF_BDC
            references BONDECOMMANDE_CLIENT
);

CREATE SEQUENCE SEQ_EtudeOF INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE NOCACHE NOORDER;

CREATE OR REPLACE FUNCTION get_SEQ_EtudeOF
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
SELECT SEQ_EtudeOF.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;


create table EtudeOFFILLE
(
    ID            VARCHAR2(255) not null
        primary key,
    IDINGREDIENTS VARCHAR2(255),
    LIBELLE       VARCHAR2(255),
    REMARQUE      VARCHAR2(255),
    IDMERE        VARCHAR2(255)
        references ETUDEOF,
    DATYBESOIN    DATE,
    IDUNITE       VARCHAR2(100),
    IDBCFILLE     VARCHAR2(1000)
        constraint FK_EtudeOFFILLE_BDCFILE
            references BONDECOMMANDE_CLIENT_FILLE,
    QTE           NUMBER(30, 5)
);

CREATE SEQUENCE SEQ_EtudeOFFILLE INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999999999999999999999 NOCYCLE NOCACHE NOORDER;

CREATE OR REPLACE FUNCTION get_SEQ_EtudeOFFILLE
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
SELECT SEQ_EtudeOFFILLE.NEXTVAL INTO retour FROM DUAL;

RETURN retour;
END;

create table AS_RECETTEEtudeOFTABLE
(
    ID            VARCHAR2(50) not null
        primary key,
    IDINGREDIENTS VARCHAR2(200)
        references AS_INGREDIENTS,
    UNITE         VARCHAR2(100),
    QTEAV         NUMBER(30, 5),
    QUANTITE      NUMBER(30, 10),
    IDPRODUITS    VARCHAR2(100),
    IDUNITE       VARCHAR2(100),
    COMPOSE       NUMBER,
    NIVEAU        NUMBER
);

create view AS_RECOFFVUESTFAB as
SELECT a."ID",
       a."IDINGREDIENTS",
       a."UNITE",
       a."QTEAV",
       a."QUANTITE",
       a."IDPRODUITS",
       a."IDUNITE",
       a."COMPOSE",
       a."NIVEAU",
       a."LIBINGREDIENTS",
       a."RESTESTOCK",
       cast(a.RAF as number(30, 10)) as raf,
       nvl(f.FabEncours, 0)          AS FabEncours,
       a.TYPESTOCK,
       a.ATELIER
FROM as_recOffVueResteSt a
         LEFT JOIN FabricationEncours f ON f.IDINGREDIENTS = a.IDINGREDIENTS
order by niveau DESC;

create view AS_RECETTEEtudeOFF as
select offi.id,offi.ID as IDPRODUITS,offi.IDINGREDIENTS as idingredients,
       cast(cast(offi.QTE as number(30,10))*cast(nvl(e.qte,1) as number(30,10)) as number(30,10)) as quantite,ing.unite,ing.compose from EtudeOFFILLE offi left join equivalence e
                                                                                                                                                                     on e.idproduit=offi.IDINGREDIENTS and e.idunite=offi.IDUNITE
                                                                                                                                                           left join as_ingredients ing on ing.id=offi.IDINGREDIENTS
union all
select ID,IDPRODUITS,IDINGREDIENTS,cast (QUANTITE as number(30,10))as quantite,UNITE,COMPOSE from AS_RECETTECOMPOSE;


create or replace view EtudeOFLIB as
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
               THEN 'CR&Eacute;&Eacute;E'
           WHEN ofl.ETAT=11
               THEN 'Valid&eacute;'
           WHEN ofl.ETAT=0
               THEN 'ANNULEE'
           WHEN ofl.ETAT=21
               THEN 'ENTAME'
           WHEN ofl.ETAT=31
               THEN 'BLOQUE'
           WHEN ofl.ETAT=41
               THEN 'TERMINEE'
           END AS ETATLIB
FROM EtudeOF ofl
         LEFT JOIN MAGASINPOINT p1 ON p1.ID = ofl.LANCEPAR
         LEFT JOIN MAGASINPOINT p2 ON p2.ID = ofl.CIBLE;

create or replace view ETUDEOFFILLELIBSTOCK as
SELECT
    ofll.ID,
    ofll.IDINGREDIENTS,
    nvl(ofll.LIBELLE,ai.LIBELLE)  AS LIBELLE,
    ofll.REMARQUE,
    ofll.IDMERE,
    ob.daty AS  DATYBESOIN,
    ofll.QTE,
    nvl(au.VAL, 'unite') AS IDUNITE,
    cast(nvl(mv.entree,0) as number(30,5)) as qteFabrique,
    cast(ofll.QTE-nvl(mv.ENTREE,0)as number(30,5)) as qteReste,
    nvl(ofll.LIBELLE,nvl(ai.LIBELLEEXTACTE, ai.LIBELLE)) AS libelleexacte,
    ai.pv,
    cast(nvl(mv.ENTREE,0)*ai.pv as number(30,2)) as montantEntree,
    cast(nvl(mvt.montantSortie,0) as number(30,5)) as montantSortie,
    CASE
        WHEN (nvl(mv.ENTREE,0)=0 or ai.pv=0) THEN 0
        ELSE (1-(mvt.montantSortie/(nvl(mv.ENTREE,0)*ai.pv)))*100
        END AS pourc
FROM
    ETUDEOFFILLE ofll
        LEFT JOIN AS_INGREDIENTS ai ON
        ai.ID = ofll.IDINGREDIENTS
        LEFT JOIN AS_UNITE au ON
        au.ID = ofll.IDUNITE
        left join MVTSTFILLEOFFCATVISEGROUPEDEP mvt on ofll.id=mvt.IDOFf
        left join mvtStockFilleOfEntreePrFini mv on mv.idoff=ofll.id and mv.IDPRODUIT=ofll.IDINGREDIENTS
        LEFT JOIN OFAB ob ON ob.id =  ofll.idmere;

create view ETUDEOFFILLELIB as
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
    ETUDEOFFILLE ofll
        LEFT JOIN AS_INGREDIENTS ai ON
        ai.ID = ofll.IDINGREDIENTS
        LEFT JOIN AS_UNITE au ON
        au.ID = ofll.IDUNITE
        LEFT JOIN FabricationMereFille fmf ON
        fmf.IDOFFILLE = ofll.ID
            AND fmf.IDINGREDIENTS = ofll.IDINGREDIENTS
            AND fmf.IDBCFILLE = OFLL.IDBCFILLE;



create view ETUDEOFFILLERESTELIB as
SELECT o."ID",o."IDINGREDIENTS",o."LIBELLE",o."REMARQUE",o."IDMERE",o."DATYBESOIN",o."QTE",o."IDUNITE",fmf.qte AS qteFabrique,(o.qte-fmf.qte) AS qteReste FROM FabricationMereFille fmf JOIN ETUDEOfFilleLib o ON fmf.idof=o.IDMERE  AND fmf.IDINGREDIENTS=o.IDINGREDIENTS;

