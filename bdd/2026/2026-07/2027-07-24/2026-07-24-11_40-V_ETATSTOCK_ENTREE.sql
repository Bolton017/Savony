create or replace  view V_ETATSTOCK_ENTREE as
WITH max_inventaire AS (
    -- Ã    tape 1 : On extrait la date maximale valide par produit une fois pour toutes
    SELECT
        invff.MVTSRC,
        MAX(imeref.DATY) AS max_daty
    FROM INVENTAIREFILLE invff
             LEFT JOIN INVENTAIRE imeref ON imeref.ID = invff.IDINVENTAIRE
    WHERE imeref.ETAT >= 11
    GROUP BY invff.MVTSRC
),
     inv_final_precalc AS (
         -- Ã   tape 2 : On rÃ©cupÃ¨re les quantitÃ©s associÃ©es Ã  cette date maximale
         SELECT
             invfff.MVTSRC,
             invfff.QUANTITE,
             imm.DATY AS invdaty
         FROM INVENTAIREFILLE invfff
                  LEFT JOIN INVENTAIRE imm ON imm.ID = invfff.IDINVENTAIRE
                  INNER JOIN max_inventaire mi ON mi.MVTSRC = invfff.MVTSRC AND imm.DATY = mi.max_daty
         WHERE imm.ETAT >= 11
     ),
     somme_precalc AS (
         -- Ã   tape 3 : Calcul des sommes globales (sorties/entrÃ©es) sans sous-requÃªte corrÃ©lÃ©e cassÃ©e
         SELECT
             mff.MVTSRC,
             NVL(SUM(mff.ENTREE), 0) AS entree,
             NVL(SUM(mff.SORTIE), 0) AS sortie
         FROM MVTSTOCKFILLE mff
                  LEFT JOIN MVTSTOCK meref ON meref.ID = mff.IDMVTSTOCK
                  LEFT JOIN inv_final_precalc inv ON inv.MVTSRC = mff.MVTSRC
         WHERE meref.DATY > nvl(inv.invdaty,to_date('01/01/2025','DD-MM-YYYY')) and meref.ETAT>=11
           AND meref.IDTYPEMVSTOCK != 'TPMVST000023'
         GROUP BY mff.MVTSRC
     ),
     main_data AS (
         -- Ã   tape 4 : RequÃªte principale avec application exacte des rÃ¨gles de calcul d'origine
         SELECT
             mf.ID,
             mere.DATY,
             CAST(NVL(invfinal.QUANTITE, 0) AS NUMBER(30,2)) AS invquantite,

             CASE WHEN mere.DATY > NVL(invfinal.invdaty, TO_DATE('01/01/2025','DD-MM-YYYY'))
                      THEN CAST(NVL(mf.ENTREE, 0) AS NUMBER(30,2))
                  ELSE 0
                 END AS ENTREE,

             CAST(NVL(somme.SORTIE, 0) AS NUMBER(30,2)) AS sortie,

             CASE WHEN mere.DATY <= NVL(invfinal.invdaty, TO_DATE('01/01/2025','DD-MM-YYYY'))
                      THEN CAST((NVL(invfinal.QUANTITE, 0) - NVL(somme.SORTIE, 0)) AS NUMBER(30,2))
                  ELSE CAST((NVL(invfinal.QUANTITE, 0) + mf.ENTREE - NVL(somme.SORTIE, 0)) AS NUMBER(30,2))
                 END AS reste,

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
             invfinal.invdaty AS invdaty
         FROM MVTSTOCKFILLE mf
                  LEFT JOIN MVTSTOCK mere ON mere.id = mf.IDMVTSTOCK
                  LEFT JOIN somme_precalc somme ON somme.MVTSRC = mf.id
                  LEFT JOIN inv_final_precalc invfinal ON invfinal.MVTSRC = mf.ID
                  LEFT JOIN AS_INGREDIENTS ai ON ai.id = mf.IDPRODUIT
                  LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
                  LEFT JOIN MAGASINPOINT m ON mere.IDMAGASIN = m.id
                  LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
                  LEFT JOIN AS_BONDELIVRAISON_LIB b ON b.ID = mere.IDOBJET
         WHERE mf.ENTREE > 0
           AND mere.IDTYPEMVSTOCK != 'TPMVST000023'
           AND mere.ETAT >= 11
     )
SELECT
    ID, DATY, CAST(invquantite AS NUMBER(30,2)) AS invquantite, CAST(entree AS NUMBER(30,2)) AS entree, CAST(sortie AS NUMBER(30,2)) AS sortie, CAST(reste AS NUMBER(30,2)) AS reste,
    CAST(reste AS NUMBER(30,2)) AS quantite,
    CAST(reste * PU AS NUMBER(30,2)) AS montantreste,
    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,
    PU, IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib, invdaty
FROM main_data
WHERE reste != 0;