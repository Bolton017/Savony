CREATE OR REPLACE VIEW AS_INGREDIENTS_PRODUIT_FINIE AS
  SELECT 
  	   ing.id,
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
       ing.REFQUALIFICATION 
FROM as_ingredients ing
     JOIN AS_UNITE AU 
     ON ing.UNITE = AU.ID
     JOIN CATEGORIEINGREDIENTLIB catIng
     ON catIng.id = ing.CATEGORIEINGREDIENT
WHERE ing.CATEGORIEINGREDIENT = 'CAT008';



CREATE OR REPLACE VIEW INVENTAIREFILLELIB AS 
  SELECT
i.ID ,
i.IDINVENTAIRE ,
i.IDPRODUIT ,
p.libelle AS IDPRODUITLIB,
i.EXPLICATION ,
i.QUANTITETHEORIQUE ,
i.QUANTITE,
p.LIBELLEEXTACTE,
i.pu
FROM INVENTAIREFILLE i
LEFT JOIN AS_INGREDIENTS  p ON p.ID  = i.IDPRODUIT;