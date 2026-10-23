CREATE OR REPLACE VIEW "V_ETATSTOCK_ENTREE" AS
SELECT
    ve.id,
    ai.id AS IDPRODUIT ,
    ai.LIBELLE AS idproduitlib,
    ai.CATEGORIEINGREDIENT ,
    c.VAL AS idtypeproduitlib,
    ve.IDMAGASIN,
    m.VAL AS idmagasinlib,
    CAST(ve.QUANTITE AS number(30,2)) AS QUANTITE ,
    CAST(ve.ENTREE AS number(30,2)) AS ENTREE ,
    CAST(ve.SORTIE AS number(30,2)) AS SORTIE ,
    CAST(ve.RESTE AS number(30,2)) AS RESTE ,
    ai.UNITE ,
    u.VAL AS idunitelib,
    CAST(ve.PU AS number(30,2)) AS PU,
    ve.DATY,
    ve.MVTSRC
FROM
    MVTSTOCKENTREEAVECRESTE ve
        LEFT JOIN AS_INGREDIENTS ai ON
        ai.id = ve.IDPRODUIT
        LEFT JOIN CATEGORIEINGREDIENT c ON
        ai.CATEGORIEINGREDIENT = c.id
        LEFT JOIN MAGASIN2 m ON
        ve.IDMAGASIN = m.id
        LEFT JOIN UNITE u ON ai.UNITE = u.id
WHERE ve.RESTE > 0;




CREATE OR REPLACE VIEW "V_ETATSTOCK_PU" AS
SELECT
    idproduit AS id,
    SUM(QUANTITE) AS RESTE,
    IDMAGASIN,
    PU,
    IDMAGASINLIB,
    max(id) AS mvtsrc
FROM
    V_ETATSTOCK_ENTREE vee
GROUP BY
    IDPRODUIT,
    pu,
    IDMAGASIN ,
    IDMAGASINLIB;

ALTER TABLE INVENTAIREFILLE ADD mvtsrc varchar2(255);

CREATE OR REPLACE VIEW V_ETATSTOCK_ING AS
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
    CAST(ms.montant AS NUMBER(30,5)) as montantReste
FROM AS_INGREDIENTS p
         LEFT JOIN MONTANT_STOCK ms ON ms.IDPRODUIT = p.ID
         LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID
         LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID
         LEFT JOIN AS_UNITE u ON p.UNITE = u.ID
WHERE NVL(ms.ENTREE, 0)>0 or NVL(ms.SORTIE, 0)>0;

CREATE OR REPLACE VIEW V_ETATSTOCK_ENTREE AS
SELECT
    ve.id,
    ai.id AS IDPRODUIT ,
    ai.LIBELLE AS idproduitlib,
    ai.CATEGORIEINGREDIENT ,
    c.VAL AS idtypeproduitlib,
    ve.IDMAGASIN,
    m.VAL AS idmagasinlib,
    CAST(ve.QUANTITE AS number(30,5)) AS QUANTITE ,
    CAST(ve.ENTREE AS number(30,5)) AS ENTREE ,
    CAST(ve.SORTIE AS number(30,5)) AS SORTIE ,
    CAST(ve.RESTE AS number(30,5)) AS RESTE ,
    ai.UNITE ,
    u.VAL AS idunitelib,
    CAST(ve.PU AS number(30,5)) AS PU,
    ve.DATY
FROM
    MVTSTOCKENTREEAVECRESTE ve
        LEFT JOIN AS_INGREDIENTS ai ON
        ai.id = ve.IDPRODUIT
        LEFT JOIN CATEGORIEINGREDIENT c ON
        ai.CATEGORIEINGREDIENT = c.id
        LEFT JOIN MAGASIN2 m ON
        ve.IDMAGASIN = m.id
        LEFT JOIN UNITE u ON ai.UNITE = u.id
WHERE ve.RESTE > 0;

