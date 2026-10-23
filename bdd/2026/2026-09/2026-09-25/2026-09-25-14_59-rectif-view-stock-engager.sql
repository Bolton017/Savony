CREATE OR REPLACE  VIEW V_ETATSTOCK_ING_ENG AS 
  SELECT
    '' as id,
    '' as DATY,
    cast(sum(invquantite) as number(30,3)) as invquantite,
    cast(sum(entree) as number(30,3)) as entree,
    cast(sum(sortie) as number(30,3)) as sortie,
    cast(sum(reste) as number(30,3)) as reste,
    cast(sum(quantite) as number(30,3)) as quantite,
    cast(sum(reste)* avg(pu) as number(30,2)) as montantReste,
    idproduitlib,
    CATEGORIEINGREDIENT,
    UNITE,
    TYPESTOCK,
    idunitelib,
    idtypeproduitlib,
    avg(PU) AS PU,
    '' as IDFOURNISSEUR,
    '' as IDFOURNISSEURLIB,
    IDPRODUIT,
    IDMAGASIN,
    idmagasinlib,
    min(invdaty) as invdaty,
    -- nesorina group DEPARTEMENT
    max(IDDEPARTEMENT) as IDDEPARTEMENT, 
    max(departementlib) as departementlib
FROM (
         SELECT
             id,
             daty,
             invquantite,
             entree,
             sortie,
             reste,
             quantite,
             montantreste,
             idproduitlib,
             categorieingredient,
             unite,
             typestock,
             idunitelib,
             idtypeproduitlib,
             pu,
             idfournisseur,
             idfournisseurlib,
             idproduit,
             idmagasin,
             idmagasinlib,
             invdaty,
             codeproduit,
             iddepartement,
             departementlib
         FROM V_ETATSTOCK_ING
         UNION ALL
         SELECT
             TO_CHAR(mf.ID)                    AS id,
             TO_CHAR(mere.DATY, 'DD/MM/YYYY')  AS DATY,
             0 AS invquantite,
             mf.entree,
             mf.sortie AS sortie,
             mf.entree - mf.SORTIE AS reste,
             mf.entree - mf.SORTIE AS quantite,
             (mf.entree - mf.SORTIE) * mf.pu AS montantReste,
             ai.LIBELLE AS idproduitlib,
             ai.CATEGORIEINGREDIENT AS CATEGORIEINGREDIENT,
             ai.UNITE,
             ai.TYPESTOCK,
             u.val AS idunitelib,
             c.val AS idtypeproduitlib,
             mf.pu AS PU,
             '' AS IDFOURNISSEUR,
             '' AS IDFOURNISSEURLIB,
             mf.IDPRODUIT,
             mere.IDMAGASIN,
             m.val AS idmagasinlib,
             NULL AS invdaty,
             ai.PARFUMS as codeproduit,
             ai.IDDEPARTEMENT,
             ai.departementlib
         FROM stock_engage_FILLE mf
                  LEFT JOIN stock_engage mere ON mere.id = mf.IDMVTSTOCK
                  LEFT JOIN AS_INGREDIENT_DEP ai ON ai.id = mf.IDPRODUIT
                  LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
                  LEFT JOIN MAGASINPOINT m ON mere.IDMAGASIN = m.id
                  LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
     ) GROUP BY
           idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK,
           idunitelib, idtypeproduitlib, IDPRODUIT,
           IDMAGASIN, idmagasinlib
        -- IDDEPARTEMENT,departementlib
 ;