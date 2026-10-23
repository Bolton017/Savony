CREATE OR REPLACE VIEW V_ETATSTOCK_ENTREE  AS
SELECT
    ve.id,
    ai.id AS IDPRODUIT ,
    ai.LIBELLE AS idproduitlib,
    ai.CATEGORIEINGREDIENT ,
    c.VAL AS idtypeproduitlib,
    ve.IDMAGASIN,
    m.VAL AS idmagasinlib,
    ve.QUANTITE ,
    ve.ENTREE ,
    ve.SORTIE ,
    ve.RESTE ,
    ai.UNITE ,
    u.VAL AS idunitelib,
    ve.PU,
    ve.DATY
FROM
    MVTSTOCKENTREEAVECRESTE2 ve
        LEFT JOIN AS_INGREDIENTS ai ON
        ai.id = ve.IDPRODUIT
        LEFT JOIN CATEGORIEINGREDIENT c ON
        ai.CATEGORIEINGREDIENT = c.id
        LEFT JOIN MAGASIN2 m ON
        ve.IDMAGASIN = m.id
        LEFT JOIN UNITE u ON ai.UNITE = u.id;