create or replace view V_ETATSTOCK_LOCALISATION as
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
        m.IDMAGASINLIB AS idmagasinlib,
        loc.LIBELLE AS COMPTELOCALISATIONLIB,
        ai.PARFUMS AS codeproduit,
        m.IDDIRECTION as IDDEPARTEMENT,
        m.IDDIRECTIONLIB AS departementlib
    FROM somme_precalc s
    LEFT JOIN AS_INGREDIENTS ai ON ai.id = s.idproduit
    LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
    LEFT JOIN DIRECTIONMAGASINLIB m ON m.IDMAGASIN = s.idmagasin
    LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
    LEFT JOIN LOCALISATION loc ON loc.id = s.compteLocalisation
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


create or replace view V_ETATSTOCK_ENTREE as
WITH max_inventaire AS (
    SELECT
        invff.MVTSRC,
        MAX(imeref.DATY) AS max_daty
    FROM INVENTAIREFILLE invff
             LEFT JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE
    WHERE imeref.ETAT >= 11
    GROUP BY invff.MVTSRC
),
     inv_final_precalc AS (
         SELECT
             invfff.MVTSRC,
             invfff.QUANTITE,
             imm.DATY AS invdaty
         FROM INVENTAIREFILLE invfff
                  LEFT JOIN inventaireDateHeure imm ON imm.ID = invfff.IDINVENTAIRE
                  INNER JOIN max_inventaire mi ON mi.MVTSRC = invfff.MVTSRC AND imm.DATY = mi.max_daty
         WHERE imm.ETAT >= 11
     ),
     somme_precalc AS (
         SELECT
             mff.MVTSRC,
             NVL(SUM(mff.ENTREE), 0) AS entree,
             NVL(SUM(mff.SORTIE), 0) AS sortie
         FROM MVTSTOCKFILLE mff
                  LEFT JOIN mvtStockDateHeure meref ON meref.ID = mff.IDMVTSTOCK
                  LEFT JOIN inv_final_precalc inv ON inv.MVTSRC = mff.MVTSRC
         WHERE meref.DATY > nvl(inv.invdaty,to_date('01/01/2025','DD-MM-YYYY')) and meref.ETAT>=11
           AND meref.IDTYPEMVSTOCK != 'TPMVST000023'
         GROUP BY mff.MVTSRC
     ),
     main_data AS (
         SELECT
             mf.ID,
             mere.DATY,
             CAST(NVL(invfinal.QUANTITE, 0) AS NUMBER(30,2)) AS invquantite,
             CASE WHEN mere.DATY > NVL(invfinal.invdaty, TO_DATE('01/01/2025','DD-MM-YYYY'))
                      THEN CAST(NVL(mf.ENTREE, 0) AS NUMBER(30,2))
                  ELSE 0 END AS ENTREE,
             CAST(NVL(somme.SORTIE, 0) AS NUMBER(30,2)) AS sortie,
             CASE WHEN mere.DATY <= NVL(invfinal.invdaty, TO_DATE('01/01/2025','DD-MM-YYYY'))
                      THEN CAST((NVL(invfinal.QUANTITE, 0) - NVL(somme.SORTIE, 0)) AS NUMBER(30,2))
                  ELSE CAST((NVL(invfinal.QUANTITE, 0) + mf.ENTREE - NVL(somme.SORTIE, 0)) AS NUMBER(30,2)) END AS reste,
             ai.LIBELLE AS idproduitlib,
             ai.CATEGORIEINGREDIENT,
             ai.UNITE,
             ai.TYPESTOCK,
             u.VAL AS idunitelib,
             c.VAL AS idtypeproduitlib,
             mf.PU,
             b.IDFOURNISSEUR,
             b.IDFOURNISSEURLIB,
             mf.IDPRODUIT,
             mere.IDMAGASIN,
             m.IDMAGASINLIB AS idmagasinlib,
             invfinal.invdaty AS invdaty,
             mf.compteLocalisation,
             loc.LIBELLE as COMPTELOCALISATIONLIB,
             ai.PARFUMS as codeproduit,
             m.IDDIRECTION as IDDEPARTEMENT,
             m.IDDIRECTIONLIB AS departementlib
         FROM MVTSTOCKFILLE mf
                  LEFT JOIN mvtStockDateHeure mere ON mere.id = mf.IDMVTSTOCK
                  LEFT JOIN somme_precalc somme ON somme.MVTSRC = mf.id
                  LEFT JOIN inv_final_precalc invfinal ON invfinal.MVTSRC = mf.ID
                  LEFT JOIN AS_INGREDIENT_DEP ai ON ai.id = mf.IDPRODUIT
                  LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
                  LEFT JOIN DIRECTIONMAGASINLIB m ON mere.IDMAGASIN = m.IDMAGASIN
                  LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
                  LEFT JOIN AS_BONDELIVRAISON_LIB b ON b.ID = mere.IDOBJET
                  LEFT JOIN LOCALISATION loc ON loc.id=mf.COMPTELOCALISATION
         WHERE mf.ENTREE > 0
           AND mere.IDTYPEMVSTOCK != 'TPMVST000023'
           AND ai.TYPESTOCK != 'CUMP'
           AND mere.ETAT >= 11
     )
SELECT
    ID, DATY, CAST(invquantite AS NUMBER(30,2)) AS invquantite, CAST(entree AS NUMBER(30,2)) AS entree, CAST(sortie AS NUMBER(30,2)) AS sortie, CAST(reste AS NUMBER(30,2)) AS reste,
    CAST(reste AS NUMBER(30,2)) AS quantite,
    CAST(reste * PU AS NUMBER(30,2)) AS montantreste,
    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,
    PU, IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib, invdaty,COMPTELOCALISATIONLIB,compteLocalisation,codeproduit,IDDEPARTEMENT,departementlib
FROM main_data
WHERE reste != 0;
