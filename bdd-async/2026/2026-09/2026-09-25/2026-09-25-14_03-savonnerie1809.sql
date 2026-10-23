-- Stef

CREATE OR REPLACE VIEW V_INVENTAIREFILLECPL_2 AS
SELECT
    i.ID AS ID,
    i.IDINVENTAIRE AS IDINVENTAIRE,
    i.IDPRODUIT AS IDPRODUIT,
    p.LIBELLE AS IDPRODUITLIB,
    i.EXPLICATION AS EXPLICATION,
    CAST(
            NVL(i.QUANTITETHEORIQUE, 0)
        AS NUMBER(30, 6)
    ) AS QUANTITETHEORIQUE,
    CAST(
            NVL(i.QUANTITE, 0)
        AS NUMBER(30, 6)
    ) AS QUANTITE,
    p.LIBELLEEXTACTE AS LIBELLEEXTACTE,
    CAST(
            NVL(i.PU, 0)
        AS NUMBER(30, 6)
    ) AS PU,
    CAST(
            NVL(i.QUANTITE, 0)
                - NVL(i.QUANTITETHEORIQUE, 0)
        AS NUMBER(30, 6)
    ) AS ECART,
    iv.DATY AS DATEINV,
    CAST(
            NVL(i.PU, 0)
                * NVL(i.QUANTITETHEORIQUE, 0)
        AS NUMBER(30, 6)
    ) AS MONTANTTHEORIQUE,
    CAST(
            NVL(i.PU, 0)
                * NVL(i.QUANTITE, 0)
        AS NUMBER(30, 6)
    ) AS MONTANTREELLE,
    CAST(
            (
                NVL(i.PU, 0)
                    * NVL(i.QUANTITE, 0)
                )
                -
            (
                NVL(i.PU, 0)
                    * NVL(i.QUANTITETHEORIQUE, 0)
                )
        AS NUMBER(30, 6)
    ) AS ECARTMONTANT,
    p.CATEGORIEINGREDIENT AS CATEGORIEINGREDIENT,
    i.MVTSRC,
    au.ID AS idUnite,
    au.VAL AS idUniteLib,
    iv.idMagasin,
    m.val as idMagasinLib,
    m.IDDEPARTEMENT,
    m.IDDEPARTEMENTLIB
FROM
    INVENTAIREFILLE i
        LEFT JOIN INVENTAIRE iv
                  ON
                      iv.ID = i.IDINVENTAIRE
        LEFT JOIN AS_INGREDIENTS p
                  ON
                      p.ID = i.IDPRODUIT
        LEFT JOIN AS_UNITE au ON
        au.ID = p.UNITE
        LEFT JOIN MAGASINPOINT m ON m.ID = iv.IDMAGASIN
WHERE
    iv.ETAT >= 11;
