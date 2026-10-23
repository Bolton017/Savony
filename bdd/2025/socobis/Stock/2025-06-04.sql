create or replace view mvtStockFilleMontant as
select mf.*,cast(mf.PU*mf.ENTREE as number(30,2)) as montantEntree,cast(mf.PU*mf.SORTIE as number(30,2)) as montantSortie from MVTSTOCKFILLE mf;
CREATE OR  REPLACE VIEW MONTANT_STOCK AS
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
    mvtStockFilleMontant mf
        JOIN MVTSTOCK m ON m.id = mf.IDMVTSTOCK
        JOIN AS_INGREDIENTS ai ON ai.ID = mf.IDPRODUIT
WHERE
    m.ETAT >= 11
  AND mf.IDPRODUIT IS NOT NULL
GROUP BY
    mf.IDPRODUIT,
    ai.PU,m.IDMAGASIN;


CREATE OR  REPLACE VIEW V_ETATSTOCK_ING AS
SELECT
    p.ID AS ID,
    p.LIBELLE AS idproduitLib,
    p.CATEGORIEINGREDIENT,
    tp.DESCE AS idtypeproduitlib,
    ms.IDMAGASIN,
    mag.DESCE AS idmagasinlib,
    TO_DATE('01-01-2001', 'DD-MM-YYYY') AS dateDernierMouvement,
    ms.quantite AS QUANTITE,
    ms.entree AS ENTREE,
    ms.sortie AS SORTIE,
    ms.quantite AS reste,
    p.UNITE,
    u.DESCE AS idunitelib,
    CAST(NVL(p.PV, 0) AS NUMBER(30, 2)) AS PUVENTE,
    mag.IDPOINT,
    mag.IDTYPEMAGASIN,
    p.SEUILMIN,
    p.SEUILMAX,
    ms.montantEntree,
    ms.montantSortie,
    p.pu,
    ms.montant as montantReste
FROM AS_INGREDIENTS p
         LEFT JOIN MONTANT_STOCK ms ON ms.IDPRODUIT = p.ID
         LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID
         LEFT JOIN MAGASIN2 mag ON ms.IDMAGASIN = mag.ID
         LEFT JOIN AS_UNITE u ON p.UNITE = u.ID
where NVL(ms.ENTREE, 0)>0 or NVL(ms.SORTIE,0)>0;