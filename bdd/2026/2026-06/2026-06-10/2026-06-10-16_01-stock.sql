
create or replace view v_etatstock_entree as
SELECT
    ve.id,
    ai.id AS IDPRODUIT,
    ai.LIBELLE AS idproduitlib,
    ai.CATEGORIEINGREDIENT,
    c.VAL AS idtypeproduitlib,
    ve.IDMAGASIN, ai.typeStock,
    m.VAL AS idmagasinlib,
    ve.QUANTITE,
    CAST(ve.ENTREE AS NUMBER(30,2)) AS ENTREE,
    CAST(ve.SORTIE AS NUMBER(30,2)) AS SORTIE,
    CAST(ve.RESTE AS NUMBER(30,2)) AS RESTE,
    ai.UNITE,
    u.VAL AS idunitelib,
    ve.PU,
    ve.DATY
 FROM (
    SELECT
        "ID",
        "IDMVTSTOCK",
        "IDPRODUIT",
        "ENTREE",
        "SORTIE",
        "IDVENTEDETAIL",
        "IDTRANSFERTDETAIL",
        "PU",
        "MVTSRC",
        "DATY",
        "RESTE",
        "QUANTITE",
        "IDMAGASIN"
    FROM (
        SELECT
            m.ID,
            m.IDMVTSTOCK,
            m.IDPRODUIT,
            m.ENTREE,
            s.SORTIE,
            m.IDVENTEDETAIL,
            m.IDTRANSFERTDETAIL,
            m.PU,
            m.MVTSRC,
            mp.DATY,
            NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) AS RESTE,
            NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) AS QUANTITE,
            mp.IDMAGASIN
        FROM MVTSTOCKFILLE m
        LEFT JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK
        LEFT JOIN (
            SELECT m.MVTSRC, SUM(m.SORTIE) AS SORTIE
            FROM MVTSTOCKFILLE m
            LEFT JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK
            WHERE mp.ETAT >= 11
              AND m.MVTSRC IS NOT NULL
            GROUP BY m.MVTSRC
        ) s ON s.MVTSRC = m.id
        WHERE m.ENTREE > 0
          AND mp.ETAT >= 11
    )

 ) ve
 LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT
 LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
 LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id
 LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
 WHERE  ve.PU > 0