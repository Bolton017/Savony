create or replace view V_ETATSTOCK_ING as
SELECT
    null AS ID,
    null AS DATY,
    CAST(SUM(invquantite) AS NUMBER(30,3)) AS invquantite,
    CAST(SUM(entree) AS NUMBER(30,3)) AS entree,
    CAST(SUM(sortie) AS NUMBER(30,3)) AS sortie,
    CAST(SUM(reste) AS NUMBER(30,3)) AS reste,
    CAST(SUM(quantite) AS NUMBER(30,3)) AS quantite,
    CAST(SUM(montantreste) AS NUMBER(30,2)) AS montantreste,
    CAST(SUM(montantreste) / SUM(reste) AS NUMBER(30,2)) AS pu,
    idproduitlib,
    CATEGORIEINGREDIENT,
    UNITE,
    TYPESTOCK,
    idunitelib,
    idtypeproduitlib,
    null AS IDFOURNISSEUR,
    null AS IDFOURNISSEURLIB,
    IDPRODUIT,
    IDMAGASIN,
    idmagasinlib,
    MAX(invdaty) AS invdaty,
    codeproduit,
    IDDEPARTEMENT,
    departementlib
FROM V_ETATSTOCK_LOCALISATION
GROUP BY
    IDPRODUIT, IDMAGASIN,
    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK,
    idunitelib, idtypeproduitlib,
    idmagasinlib, codeproduit, IDDEPARTEMENT, departementlib
HAVING SUM(reste) != 0;