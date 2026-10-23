CREATE OR REPLACE  VIEW AS_INGREDIENTS_LIB AS
SELECT ing.id,
       ing.LIBELLE,
       ing.SEUIL,
       au.VAL AS unite,
       ing.QUANTITEPARPACK,
       ing.pu,
       ing.ACTIF,
       ing.PHOTO,
       ing.CALORIE,
       ing.DURRE,
       ing.COMPOSE,
       CAST(
               CASE
                   WHEN ing.COMPOSE = 1 THEN 'OUI'
                   WHEN ing.COMPOSE = 0 THEN 'NON'
                   END AS VARCHAR2(100)
       ) AS COMPOSELIB,
       cating.id AS IDCATEGORIEINGREDIENT ,
       catIng.VAL AS CATEGORIEINGREDIENT,
       ing.CATEGORIEINGREDIENT AS idcategorie,
       ing.idfournisseur,
       ing.daty,
       catIng.desce as bienOuServ,
       CASE WHEN ing.id IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'INDISPONIBLE'
            WHEN ing.id NOT IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'DISPONIBLE'
           END AS etatlib,
       ing.COMPTE_VENTE,
       ing.COMPTE_ACHAT,
       ing.pv,
       ing.tva,
       ing.TYPESTOCK,
       ing.UNITE as idunite,
       ing.REFPOST,
       ing.REFQUALIFICATION ,
       p.VAL AS REFPOSTLIB,
       qp.VAL AS REFQUALIFICATIONLIB
FROM as_ingredients ing
         LEFT JOIN AS_UNITE AU ON ing.UNITE = AU.ID
         LEFT JOIN CATEGORIEINGREDIENTLIB catIng
                   ON catIng.id = ing.CATEGORIEINGREDIENT
         LEFT JOIN POSTE p ON p.id = ing.REFPOST
         LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = ing.REFQUALIFICATION ;


