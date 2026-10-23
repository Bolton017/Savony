select ing.pu as qteav,cast(0 as number(10,2)) as qtetotal ,ing.unite as idproduits, ing.LIBELLE as idingredients,
sum(rec.quantite*cast (nvl(to_number(SUBSTR((SUBSTR(SYS_CONNECT_BY_PATH(quantite, '/'),0, (INSTR(SYS_CONNECT_BY_PATH(quantite, '/'), '/',-1)-1))),
(INSTR(SUBSTR(SYS_CONNECT_BY_PATH(quantite, '/'),0, (INSTR(SYS_CONNECT_BY_PATH(quantite, '/'), '/',-1)-1)), '/', -1))+1)),1) as number(10,2))) as quantite
from as_recettecompose rec,AS_INGREDIENTS_LIB ing  where rec.compose=0
and rec.IDINGREDIENTS=ing.id  start with idproduits ='PF003'  connect by prior idingredients = idproduits and prior rec.compose = 1  group by ing.unite, ing.libelle,ing.pu;

SELECT
    ing.pu AS qteAv,
    CAST(0 AS NUMBER(10,2)) AS qteTotal,
    ing.unite AS idProduits,
    ing.libelle AS idIngredients,
    SUM(
        (
            SELECT
                EXP(SUM(LN(TO_NUMBER(REGEXP_SUBSTR(path, '[^/]+', 1, LEVEL)))))
            FROM
                dual
            CONNECT BY
                REGEXP_SUBSTR(path, '[^/]+', 1, LEVEL) IS NOT NULL
                AND PRIOR dbms_random.value IS NOT NULL
        )
    ) AS quantite
FROM (
    SELECT
        rec.*,
        SYS_CONNECT_BY_PATH(quantite, '/') AS path
    FROM
        as_recettecompose rec
    START WITH
        idproduits in ('wawa')
    CONNECT BY
        PRIOR idingredients = idproduits
        AND PRIOR rec.compose = 1
) rec
JOIN AS_INGREDIENTS_LIB ing
    ON rec.idingredients = ing.id
WHERE rec.compose = 0
GROUP BY
    ing.unite,
    ing.libelle,
    ing.pu;


SELECT
       pi.id AS idproduit,
       pi.libelle AS libelle_produit,
       c.IDINGREDIENTS AS id_composant,
       pi2.libelle AS libelle_composant,
       pi2.PU as pu,
       c.quantite AS quantite_composant,
       LEVEL AS niveau
   FROM
       AS_INGREDIENTS_LIB pi
   LEFT JOIN
       as_recettecompose c ON pi.id = c.IDPRODUITS
   LEFT JOIN
       AS_INGREDIENTS_LIB pi2 ON c.IDINGREDIENTS = pi2.id
   START WITH
       c.IDPRODUITS = 'PF004'
   CONNECT BY
       PRIOR c.IDINGREDIENTS = c.IDPRODUITS
       AND prior c.compose = 1;  -- On continue tant que l'élément a des sous-composants;
       select * from client;