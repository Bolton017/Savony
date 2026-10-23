UPDATE AS_INGREDIENTS
SET TYPESTOCK = 'CUMP'
WHERE TYPESTOCK NOT IN (
    SELECT ID
    FROM TYPESTOCK
);

ALTER TABLE AS_INGREDIENTS
ADD CONSTRAINT FK_AS_INGREDIENTS_TYPESTOCK
FOREIGN KEY (TYPESTOCK)
REFERENCES TYPESTOCK(ID);

DELETE FROM USERMENU WHERE ID = 'UMB66FEDC8';
DELETE FROM USERMENU WHERE ID = 'UMFA43B44C';
DELETE FROM USERMENU WHERE ID = 'UMB17E6C86';
DELETE FROM USERMENU WHERE ID = 'UM0A842880';
DELETE FROM USERMENU WHERE ID = 'UMFF1C5BE2';
DELETE FROM USERMENU WHERE ID = 'UM5451F90B';
DELETE FROM USERMENU WHERE ID = 'UM668B8EE2';
DELETE FROM USERMENU WHERE ID = 'UME510DAAA';
DELETE FROM USERMENU WHERE ID = 'UM04DE6FA1';
DELETE FROM USERMENU WHERE ID = 'UM81CA5C29';
DELETE FROM USERMENU WHERE ID = 'UMFEB18FE2';

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
            m.VAL AS idmagasinlib,
            invfinal.invdaty AS invdaty,
            mf.compteLocalisation,
            loc.LIBELLE as COMPTELOCALISATIONLIB,
            ai.PARFUMS as codeproduit,
            ai.IDDEPARTEMENT,
            ai.departementlib
        FROM MVTSTOCKFILLE mf
            LEFT JOIN mvtStockDateHeure mere ON mere.id = mf.IDMVTSTOCK
            LEFT JOIN somme_precalc somme ON somme.MVTSRC = mf.id
            LEFT JOIN inv_final_precalc invfinal ON invfinal.MVTSRC = mf.ID
            LEFT JOIN AS_INGREDIENT_DEP ai ON ai.id = mf.IDPRODUIT
            LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
            LEFT JOIN MAGASINPOINT m ON mere.IDMAGASIN = m.id
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

UPDATE AS_INGREDIENTS SET TYPESTOCK = 'FIFO';



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
        MAX(invff.pu) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS pu_max_daty
    FROM INVENTAIREFILLE invff
    LEFT JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE
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
        CASE WHEN ai.TYPESTOCK = 'CUMP' THEN '#'
             ELSE NVL(mff.MVTSRC, mff.ID) END AS MVTSRC,
        NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD/MM/YYYY')) THEN mff.ENTREE ELSE 0 END), 0) AS entree,
        NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD/MM/YYYY')) THEN mff.SORTIE ELSE 0 END), 0) AS sortie,
        NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD/MM/YYYY')) THEN mff.ENTREE*mff.pu ELSE 0 END), 0) AS montantEntree,
        NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD/MM/YYYY')) THEN mff.SORTIE*mff.pu ELSE 0 END), 0) AS montantSortie
    FROM MVTSTOCKFILLE mff
    LEFT JOIN mvtStockDateHeure meref ON meref.ID = mff.IDMVTSTOCK
    LEFT JOIN AS_INGREDIENTS ai ON ai.id = mff.idproduit
    LEFT JOIN max_inventaire inv
           ON inv.idproduit = mff.idproduit
          AND inv.idmagasin = meref.idmagasin
          AND inv.COMPTELOCALISATION = mff.COMPTELOCALISATION
          AND inv.MVTSRC = CASE WHEN ai.TYPESTOCK = 'CUMP' THEN '#'
                                ELSE NVL(mff.MVTSRC, mff.ID) END
    WHERE meref.ETAT >= 11 AND meref.IDTYPEMVSTOCK != 'TPMVST000023'
    GROUP BY mff.idproduit, meref.idmagasin, mff.COMPTELOCALISATION,
             CASE WHEN ai.TYPESTOCK = 'CUMP' THEN '#'
                  ELSE NVL(mff.MVTSRC, mff.ID) END
),
par_lot AS (
    SELECT
        NVL(mv.idproduit, inv.idproduit) AS idproduit,
        NVL(mv.idmagasin, inv.idmagasin) AS idmagasin,
        NVL(mv.COMPTELOCALISATION, inv.COMPTELOCALISATION) AS compteLocalisation,
        NVL(mv.entree, 0) AS entree,
        NVL(mv.sortie, 0) AS sortie,
        inv.max_daty AS invdaty,
        NVL(inv.qte_max_daty, 0) AS invquantite,
        NVL(mv.montantEntree, 0) AS montantEntree,
        NVL(mv.montantSortie, 0) AS montantSortie,
        NVL(inv.pu_max_daty * inv.qte_max_daty, 0) AS montantInv
    FROM mouvements mv
    FULL OUTER JOIN max_inventaire inv
           ON inv.idproduit = mv.idproduit
          AND inv.idmagasin = mv.idmagasin
          AND inv.COMPTELOCALISATION = mv.COMPTELOCALISATION
          AND inv.MVTSRC = mv.MVTSRC
),
somme_precalc AS (
    SELECT
        idproduit, idmagasin, compteLocalisation,
        SUM(entree) AS entree,
        SUM(sortie) AS sortie,
        MAX(invdaty) AS invdaty,
        SUM(invquantite) AS invquantite,
        SUM(montantEntree) AS montantEntree,
        SUM(montantSortie) AS montantSortie,
        SUM(montantInv) AS montantInv
    FROM par_lot
    GROUP BY idproduit, idmagasin, compteLocalisation
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
    CAST((montantInv + montantEntree - montantSortie) / (invquantite + entree - sortie) AS NUMBER(30,2)) AS pu,
    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,
    IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib,
    compteLocalisation, COMPTELOCALISATIONLIB,
    invdaty, codeproduit, IDDEPARTEMENT, departementlib
FROM detail
WHERE invquantite + entree - sortie != 0;