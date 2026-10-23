create or replace view MVTSTOCKFILLELIB as
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
    p.libelle AS libelleexacte,
    m2.DATY AS dateSql,
    m2.IDTYPEMVSTOCK,
    m.IDLOT,
    m2.IDOBJET,
    TO_CHAR(l.DATY, 'DD/MM/YYYY') || '-' || l.IDPRODUIT || '-' || l.IDEQUIPE AS IDLOTLIB
FROM MVTSTOCKFILLE m
         LEFT JOIN AS_INGREDIENTS  p ON p.ID = m.IDPRODUIT
         LEFT JOIN MVTSTOCK m2 ON m2.ID = m.IDMVTSTOCK
         LEFT JOIN MAGASIN2 m3 ON m3.ID = m2.IDMAGASIN
         LEFT JOIN LOT l on l.ID = m.IDLOT;

create or replace view MVTSTOCKFILLEMONTANTLOT as
select mf."ID",
       mf."IDMVTSTOCK",
       mf."IDPRODUIT",
       mf."ENTREE",
       mf."SORTIE",
       mf."IDVENTEDETAIL",
       mf."IDTRANSFERTDETAIL",
       mf."PU",
       mf."MVTSRC",
       mf."RESTE",
       mf."DESIGNATION",
       cast(mf.PU * mf.ENTREE as number(30, 5)) as montantEntree,
       cast(mf.PU * mf.SORTIE as number(30, 5)) as montantSortie,
       mf.IDLOT,
       TO_CHAR(l.DATY, 'DD/MM/YYYY') || '-' || l.IDPRODUIT || '-' || l.IDEQUIPE AS IDLOTLIB
from MVTSTOCKFILLE mf
LEFT JOIN LOT l on l.ID = mf.IDLOT;

create or replace view MONTANT_STOCKLOT as
SELECT
    mf.IDPRODUIT,
    SUM(NVL(mf.ENTREE,0)) AS ENTREE,
    SUM(NVL(mf.SORTIE,0)) AS SORTIE,
    SUM(NVL(mf.ENTREE,0)) - SUM(NVL(mf.SORTIE,0)) AS quantite,
    cast(sum(mf.montantEntree) as number(30,2))  AS montantEntree,
    cast(sum(mf.montantSortie) as number(30,2))  AS montantSortie,
    CAST(NVL(ai.PU, 0) * (SUM(NVL(mf.ENTREE,0)) - SUM(NVL(mf.SORTIE,0))) AS NUMBER(30,2)) AS montant,
    m.IDMAGASIN,
    mf.IDLOT,
    mf.IDLOTLIB
FROM
    MVTSTOCKFILLEMONTANTLOT mf
        JOIN MVTSTOCK m ON m.id = mf.IDMVTSTOCK
        JOIN AS_INGREDIENTS ai ON ai.ID = mf.IDPRODUIT
WHERE
    m.ETAT >= 11
  AND mf.IDPRODUIT IS NOT NULL
GROUP BY
    mf.IDPRODUIT,
    ai.PU,m.IDMAGASIN,
    mf.IDLOT,
    mf.IDLOTLIB;

create or replace view V_ETATSTOCK_INGLOT as
SELECT
    p.ID AS ID,
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
    CAST(ms.montant AS NUMBER(30,5)) as montantReste,
    mv.IDLOT,
    mv.IDLOTLIB
FROM AS_INGREDIENTS p
         LEFT JOIN MONTANT_STOCK ms ON ms.IDPRODUIT = p.ID
         LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID
         LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID
         LEFT JOIN AS_UNITE u ON p.UNITE = u.ID
         LEFT JOIN MVTSTOCKFILLEMONTANTLOT mv ON mv.IDPRODUIT = p.ID
WHERE NVL(ms.ENTREE, 0)>0 or NVL(ms.SORTIE, 0)>0;



