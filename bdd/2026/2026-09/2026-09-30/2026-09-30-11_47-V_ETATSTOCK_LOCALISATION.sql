
CREATE OR REPLACE VIEW V_ETATSTOCK_LOCALISATION AS
WITH max_inventaire AS (
    SELECT
        invff.IDPRODUIT,
        imeref.IDMAGASIN,
        invff.COMPTELOCALISATION,
        CASE WHEN ai.TYPESTOCK = 'CUMP' THEN '#'
             ELSE NVL(invff.MVTSRC, '#') END AS MVTSRC,
        MAX(imeref.DATY) AS max_daty,
        MAX(invff.QUANTITE) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS qte_max_daty,
        MAX(invff.pu)       KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS pu_max_daty
    FROM INVENTAIREFILLE invff
    JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE
    LEFT JOIN AS_INGREDIENTS ai ON ai.id = invff.IDPRODUIT
    WHERE imeref.ETAT >= 11
    GROUP BY invff.IDPRODUIT, imeref.IDMAGASIN, invff.COMPTELOCALISATION,
             CASE WHEN ai.TYPESTOCK = 'CUMP' THEN '#'
                  ELSE NVL(invff.MVTSRC, '#') END
),
mouvements AS (
    SELECT
        mff.idproduit,
        meref.idmagasin,
        mff.COMPTELOCALISATION,
        SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, DATE '2025-01-01') THEN mff.ENTREE ELSE 0 END)        AS entree,
        SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, DATE '2025-01-01') THEN mff.SORTIE ELSE 0 END)        AS sortie,
        SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, DATE '2025-01-01') THEN mff.ENTREE * mff.pu ELSE 0 END) AS montantEntree,
        SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, DATE '2025-01-01') THEN mff.SORTIE * mff.pu ELSE 0 END) AS montantSortie
    FROM MVTSTOCKFILLE mff
    JOIN mvtStockDateHeure meref ON meref.ID = mff.IDMVTSTOCK
    LEFT JOIN AS_INGREDIENTS ai ON ai.id = mff.idproduit
    LEFT JOIN max_inventaire inv
           ON inv.idproduit = mff.idproduit
          AND inv.idmagasin = meref.idmagasin
          AND inv.COMPTELOCALISATION = mff.COMPTELOCALISATION
          AND inv.MVTSRC = CASE WHEN ai.TYPESTOCK = 'CUMP' THEN '#'
                                ELSE NVL(mff.MVTSRC, mff.ID) END
    WHERE meref.ETAT >= 11
      AND meref.IDTYPEMVSTOCK != 'TPMVST000023'
    GROUP BY mff.idproduit, meref.idmagasin, mff.COMPTELOCALISATION
),
lignes AS (
    SELECT idproduit, idmagasin, COMPTELOCALISATION,
           entree, sortie, 0 AS invquantite,
           montantEntree, montantSortie, 0 AS montantInv,
           CAST(NULL AS DATE) AS invdaty
    FROM mouvements
    UNION ALL
    SELECT idproduit, idmagasin, COMPTELOCALISATION,
           0, 0, NVL(qte_max_daty, 0),
           0, 0, NVL(pu_max_daty * qte_max_daty, 0),
           max_daty
    FROM max_inventaire
),
somme_precalc AS (
    SELECT idproduit, idmagasin, COMPTELOCALISATION AS compteLocalisation,
        SUM(entree) AS entree, SUM(sortie) AS sortie,
        MAX(invdaty) AS invdaty, SUM(invquantite) AS invquantite,
        SUM(montantEntree) AS montantEntree,
        SUM(montantSortie) AS montantSortie,
        SUM(montantInv) AS montantInv
    FROM lignes
    GROUP BY idproduit, idmagasin, COMPTELOCALISATION
    HAVING SUM(invquantite) + SUM(entree) - SUM(sortie) != 0
),
detail AS (
    SELECT
        s.idproduit, s.idmagasin, s.compteLocalisation,
        s.entree, s.sortie, s.invdaty, s.invquantite,
        s.montantEntree, s.montantSortie, s.montantInv,
        ai.LIBELLE AS idproduitlib,
        ai.CATEGORIEINGREDIENT AS CATEGORIEINGREDIENT,
        ai.UNITE AS unite,
        ai.TYPESTOCK AS typestock,
        u.VAL AS idunitelib,
        c.VAL AS idtypeproduitlib,
        null AS IDFOURNISSEUR,
        null AS IDFOURNISSEURLIB,
        m.VAL AS idmagasinlib,
        loc.LIBELLE AS COMPTELOCALISATIONLIB,
        ai.PARFUMS AS codeproduit,
        m.IDDEPARTEMENT,
        d.val AS departementlib
    FROM somme_precalc s
    LEFT JOIN AS_INGREDIENTS ai ON ai.id = s.idproduit
    LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
    LEFT JOIN MAGASINPOINT m ON m.id = s.idmagasin
    LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
    LEFT JOIN LOCALISATION loc ON loc.id = s.compteLocalisation
    LEFT JOIN DEPARTEMENT d ON d.ID = m.IDDEPARTEMENT
)
SELECT
    null AS ID, null AS DATY,
    CAST(invquantite AS NUMBER(30,3)) AS invquantite,
    CAST(entree AS NUMBER(30,3)) AS entree,
    CAST(sortie AS NUMBER(30,3)) AS sortie,
    CAST(invquantite + entree - sortie AS NUMBER(30,3)) AS reste,
    CAST(invquantite + entree - sortie AS NUMBER(30,3)) AS quantite,
    CAST(montantInv + montantEntree - montantSortie AS NUMBER(30,2)) AS montantreste,
    CAST((montantInv + montantEntree - montantSortie)
         / NULLIF(invquantite + entree - sortie, 0) AS NUMBER(30,2)) AS pu,
    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,
    IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib,
    compteLocalisation, COMPTELOCALISATIONLIB,
    invdaty, codeproduit, IDDEPARTEMENT, departementlib
FROM detail;
