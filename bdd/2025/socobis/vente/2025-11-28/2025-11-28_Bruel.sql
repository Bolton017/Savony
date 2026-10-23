create table stock_engage
(
    ID            VARCHAR2(255) not null
        constraint stock_engage_PK
            primary key,
    DESIGNATION   VARCHAR2(255),
    IDMAGASIN     VARCHAR2(255),
    IDVENTE       VARCHAR2(255)
        constraint stock_engage_VENTE_FK
            references VENTE,
    IDTRANSFERT   VARCHAR2(255),
    IDTYPEMVSTOCK VARCHAR2(255),
    DATY          DATE,
    ETAT          NUMBER,
    IDPOINT       VARCHAR2(255),
    IDOBJET       VARCHAR2(100),
    FABPRECEDENT  VARCHAR2(150)
);

create table stock_engage_FILLE
(
    ID                VARCHAR2(255) not null
        constraint stock_engage_FILLE_PK
            primary key,
    IDMVTSTOCK        VARCHAR2(255)
        constraint stock_engageMERE_FILLE_FK
            references stock_engage,
    IDPRODUIT         VARCHAR2(255),
    IDVENTEDETAIL     VARCHAR2(255)
        constraint stock_engage_F_VENTEDETAIL_FK
            references VENTE_DETAILS,
    IDTRANSFERTDETAIL VARCHAR2(255),
    MVTSRC            VARCHAR2(100),
    DESIGNATION       VARCHAR2(500),
    ENTREE            NUMBER(30, 5),
    SORTIE            NUMBER(30, 5),
    PU                NUMBER(30, 5),
    RESTE             NUMBER(30, 5)
);

create view MVTSTOCKFILLEMONTANT_eng as
select mf.ID,
       mf.IDMVTSTOCK,
       mf.IDPRODUIT,
       mf.ENTREE,
       mf.SORTIE,
       mf.IDVENTEDETAIL,
       mf.IDTRANSFERTDETAIL,
       mf.PU,
       mf.MVTSRC,
       mf.RESTE,
       mf.DESIGNATION,
       cast(mf.PU * mf.ENTREE as number(30, 5)) as montantEntree,
       cast(mf.PU * mf.SORTIE as number(30, 5)) as montantSortie
from MVTSTOCKFILLE mf
union all
select mf.ID,
       mf.IDMVTSTOCK,
       mf.IDPRODUIT,
       mf.ENTREE,
       mf.SORTIE,
       mf.IDVENTEDETAIL,
       mf.IDTRANSFERTDETAIL,
       mf.PU,
       mf.MVTSRC,
       mf.RESTE,
       mf.DESIGNATION,
       cast(mf.PU * mf.ENTREE as number(30, 5)) as montantEntree,
       cast(mf.PU * mf.SORTIE as number(30, 5)) as montantSortie
from stock_engage_FILLE mf;

create or replace view MVTstockfille_eng as
select ID, IDMVTSTOCK, IDPRODUIT, IDVENTEDETAIL, IDTRANSFERTDETAIL, MVTSRC, DESIGNATION, ENTREE, SORTIE, PU, RESTE from MVTSTOCKFILLE
    union all
select ID, IDMVTSTOCK, IDPRODUIT, IDVENTEDETAIL, IDTRANSFERTDETAIL, MVTSRC, DESIGNATION, ENTREE, SORTIE, PU, RESTE from stock_engage_FILLE;

create or replace view MVTstock_eng as
select ID, DESIGNATION, IDMAGASIN, IDVENTE, IDTRANSFERT, IDTYPEMVSTOCK, DATY, ETAT, IDPOINT, IDOBJET, FABPRECEDENT from MVTSTOCK
    union all
select ID, DESIGNATION, IDMAGASIN, IDVENTE, IDTRANSFERT, IDTYPEMVSTOCK, DATY, ETAT, IDPOINT, IDOBJET, FABPRECEDENT from stock_engage;


create view MONTANT_STOCK_eng as
SELECT
    mf.IDPRODUIT,
    SUM(NVL(mf.ENTREE,0)) AS ENTREE,
    SUM(NVL(mf.SORTIE,0)) AS SORTIE,
    SUM(NVL(mf.ENTREE,0)) - SUM(NVL(mf.SORTIE,0)) AS quantite,
    cast(sum(mf.montantEntree) as number(30,2))  AS montantEntree,
    cast(sum(mf.montantSortie) as number(30,2))  AS montantSortie,
    CAST(NVL(ai.PU, 0) * (SUM(NVL(mf.ENTREE,0)) - SUM(NVL(mf.SORTIE,0))) AS NUMBER(30,2)) AS montant,
    m.IDMAGASIN
FROM
    mvtStockFilleMontant_eng mf
        JOIN MVTstock_eng m ON m.id = mf.IDMVTSTOCK
        JOIN AS_INGREDIENTS ai ON ai.ID = mf.IDPRODUIT
WHERE
    m.ETAT >= 11
  AND mf.IDPRODUIT IS NOT NULL
GROUP BY
    mf.IDPRODUIT,
    ai.PU,m.IDMAGASIN;

create or replace view V_ETATSTOCK_ING_eng as
SELECT
    p.ID,
    p.LIBELLE AS idproduitLib,
    p.CATEGORIEINGREDIENT,
    tp.DESCE AS idtypeproduitlib,
    ms.IDMAGASIN,
    mag.VAL AS idmagasinlib,
    TO_DATE('01-01-2001', 'DD-MM-YYYY') AS dateDernierMouvement,
    CAST(ms.quantite AS NUMBER(30,5) ) AS QUANTITE,
    CAST(NVL( ms.entree, 0) AS NUMBER(30, 5))  AS ENTREE,
    CAST(NVL( ms.sortie, 0) AS NUMBER(30, 5))  AS SORTIE,
    CAST(NVL( ms.quantite, 0) AS NUMBER(30, 5))  AS reste,
    p.UNITE,
    u.DESCE AS idunitelib,
    CAST(NVL(p.PV, 0) AS NUMBER(30, 5)) AS PUVENTE,
    mag.IDPOINT,
    mag.IDTYPEMAGASIN,
    p.SEUILMIN,
    p.SEUILMAX,
    CAST(ms.montantEntree AS NUMBER(30,5)) AS montantEntree,
    CAST(ms.montantSortie AS NUMBER(30,5)) AS montantSortie,
    CAST(p.pu AS NUMBER(30,5)) AS pu,
    CAST(ms.montant AS NUMBER(30,5)) as montantReste
FROM AS_INGREDIENTS p
         LEFT JOIN MONTANT_STOCK_eng ms ON ms.IDPRODUIT = p.ID
         LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID
         LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID
         LEFT JOIN AS_UNITE u ON p.UNITE = u.ID
WHERE NVL(ms.ENTREE, 0)>0 or NVL(ms.SORTIE, 0)>0;


create view MVTSTOCKFILLELIB_ENG as
SELECT
    m.ID ,
    m.IDMVTSTOCK ,
    m.IDPRODUIT ,
    p.libelle  AS IDPRODUITLIB,
    m.ENTREE ,
    m.SORTIE ,
    m.IDVENTEDETAIL ,
    '' AS IDVENTEDETAILLIB,
    m.IDTRANSFERTDETAIL ,
    '' AS IDTRANSFERTDETAILLIB,
    m2.DATY ,
    m2.IDMAGASIN ,
    m3.VAL AS IDMAGASINLIB,
    m.pu,
    cast(m.pu*m.ENTREE+(m.pu*m.sortie) as number(20,5)) as montant,
    p.LIBELLE,
    m.MVTSRC,
    p.libelle AS libelleexacte
FROM MVTSTOCKFILLE_ENG m
         LEFT JOIN AS_INGREDIENTS  p ON p.ID = m.IDPRODUIT
         LEFT JOIN MVTSTOCK_ENG m2 ON m2.ID = m.IDMVTSTOCK
         LEFT JOIN MAGASIN2 m3 ON m3.ID = m2.IDMAGASIN;

create view SORTIEPRODUITparorigine as
SELECT
idproduit,
idobjet,
CAST(sum(nvl(m.SORTIE,0)) AS NUMBER(15,2))  AS qteSortie
FROM MVTSTOCKFILLE m
LEFT JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK
WHERE mp.etat >= 11
GROUP BY idproduit, idobjet;

create view SORTIEPRODUITparvente as
select spo.*, abc.IDVENTE from SORTIEPRODUITparorigine spo
    left join AS_BONDELIVRAISON_CLIENT abc on abc.id = spo.idobjet;

create view SORTIEPRODUITparventegrp as
select idproduit, IDVENTE, sum(qteSortie) as qteSortie from SORTIEPRODUITparvente
group by IDVENTE, idproduit;

create or replace view RAPPROCHEMENT_BF_CLIENT as
SELECT
abcc.ID,
abcc.PRODUIT,
abcc.NUMBL,
abcc.QUANTITE,
abcc.IDVENTEDETAIL,
abcc.UNITE,
abcc.IDBC_FILLE,
abcc.IDPRODUITLIB,
abcc.IDVENTE,
abcc.IDBC,
abcc.QTELIVREE,
abcc.QTERESTEALIVRER,
nvl(m.qteSortie,0) AS qteSortie,
abcc.QUANTITE - nvl(m.qteSortie,0) AS resteASortir
FROM AS_BONLIVRFILLE_CLIENT_CPL abcc
LEFT JOIN SORTIEPRODUITparventegrp m ON m.idproduit = abcc.produit and m.IDVENTE = abcc.idvente
LEFT JOIN MVTSTOCK mv ON mv.idobjet = abcc.numbl
/

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDN0000000171AE', 'Avec Engagement', 'fa fa-list', 'module.jsp?but=stock/etatstock/etatstock-avec-engagement.jsp', 3, 3, 'MNDN000000017');
