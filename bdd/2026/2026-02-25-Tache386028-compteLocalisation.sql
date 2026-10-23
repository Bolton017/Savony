ALTER TABLE MVTSTOCKFILLE
    ADD compteLocalisation VARCHAR(255);


INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MDLOCO0000056', 'Localisation', 'location_on', '#', 9, 2, 'MNDN000000003');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDNLOC0000TR0002113', 'Liste', 'view_list', 'module.jsp?but=compta/localisation/localisation-liste.jsp', 2, 3, 'MDLOCO0000056');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDNLOC0000TR0002112', 'Saisie', 'add', 'module.jsp?but=compta/localisation/localisation-saisie.jsp', 1, 3, 'MDLOCO0000056');

create or replace view MVTSTOCKFILLEMONTANT as
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
       mf.compteLocalisation,
       cast(mf.PU*mf.ENTREE as number(30,5)) as montantEntree,cast(mf.PU*mf.SORTIE as number(30,5)) as montantSortie
from MVTSTOCKFILLE mf;

create or replace view MONTANT_STOCK as
SELECT
    mf.IDPRODUIT,
    SUM(NVL(mf.ENTREE,0)) AS ENTREE,
    SUM(NVL(mf.SORTIE,0)) AS SORTIE,
    SUM(NVL(mf.ENTREE,0)) - SUM(NVL(mf.SORTIE,0)) AS quantite,
    cast(sum(mf.montantEntree) as number(30,2))  AS montantEntree,
    cast(sum(mf.montantSortie) as number(30,2))  AS montantSortie,
    CAST(NVL(ai.PU, 0) * (SUM(NVL(mf.ENTREE,0)) - SUM(NVL(mf.SORTIE,0))) AS NUMBER(30,2)) AS montant,
    m.IDMAGASIN,
    mf.compteLocalisation
FROM
    mvtStockFilleMontant mf
        JOIN MVTSTOCK m ON m.id = mf.IDMVTSTOCK
        JOIN AS_INGREDIENTS ai ON ai.ID = mf.IDPRODUIT
WHERE
    m.ETAT >= 11
  AND mf.IDPRODUIT IS NOT NULL
GROUP BY
    mf.IDPRODUIT,
    ai.PU,m.IDMAGASIN, mf.compteLocalisation;

create or replace view V_ETATSTOCK_ING as
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
    ms.compteLocalisation
FROM AS_INGREDIENTS p
         LEFT JOIN MONTANT_STOCK ms ON ms.IDPRODUIT = p.ID
         LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID
         LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID
         LEFT JOIN AS_UNITE u ON p.UNITE = u.ID
WHERE NVL(ms.ENTREE, 0)>0 or NVL(ms.SORTIE, 0)>0;




