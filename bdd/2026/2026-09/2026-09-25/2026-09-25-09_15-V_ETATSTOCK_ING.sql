create or replace view V_ETATSTOCK_ING as
WITH max_inventaire AS (
    -- Étape 1 : On extrait la date maximale valide et la quantité par COUPLE produit/magasin
    SELECT
        invff.IDPRODUIT,imeref.IDMAGASIN,
        MAX(imeref.DATY) AS max_daty,
        MAX(invff.QUANTITE) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS qte_max_daty,
        MAX(invff.pu) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS pu_max_daty
    FROM INVENTAIREFILLE invff
         LEFT JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE
    WHERE imeref.ETAT >= 11
    GROUP BY invff.IDPRODUIT, imeref.IDMAGASIN
),
     somme_precalc AS (
         -- Étape 3 : Calcul des sommes globales agrégées par COUPLE produit/magasin
         SELECT
             mff.idproduit as idproduit,
             meref.idmagasin as idmagasin,
             NVL(SUM(CASE WHEN meref.DATY >NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.ENTREE ELSE 0 END), 0) AS entree,

             NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.SORTIE ELSE 0 END), 0) AS sortie,
             ai.LIBELLE AS idproduitlib,
             ai.CATEGORIEINGREDIENT as CATEGORIEINGREDIENT,
             ai.UNITE as unite,
             ai.TYPESTOCK as typestock,
             u.VAL AS idunitelib,
             c.VAL AS idtypeproduitlib,
             avg(mff.PU) as pu,
             null as IDFOURNISSEUR,
             null as IDFOURNISSEURLIB,
             m.VAL AS idmagasinlib,
             max(inv.max_daty) AS invdaty,
             nvl(max(inv.qte_max_daty),0)as invquantite,
             NVL(SUM(CASE WHEN meref.DATY >NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.ENTREE*mff.pu ELSE 0 END), 0) AS montantEntree,
             NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.SORTIE*mff.pu ELSE 0 END), 0) AS montantSortie,
             nvl(avg(inv.pu_max_daty*inv.qte_max_daty),0) as montantInv,
             nvl(max(ai.SEUIL),0) as seuil,
             nvl(max(ai.SEUILMAX),
             nvl(max(ai.SEUILMIN),0)+1000) as seuilmax,
             nvl(max(ai.SEUILMIN),0) as seuilMin,
             ai.PARFUMS as codeproduit,
             m.IDDEPARTEMENT,
             d.val as departementlib
         FROM MVTSTOCKFILLE mff
                  LEFT JOIN MVTSTOCK meref ON meref.ID = mff.IDMVTSTOCK
                  LEFT JOIN max_inventaire inv ON inv.idproduit = mff.idproduit AND inv.idmagasin = meref.idmagasin
                  LEFT JOIN AS_INGREDIENTS ai ON ai.id = mff.IDPRODUIT
                  LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
                  LEFT JOIN MAGASINPOINT m ON meref.IDMAGASIN = m.id
                  LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
                  LEFT JOIN LOCALISATION loc ON loc.id=mff.COMPTELOCALISATION
                  LEFT JOIN DEPARTEMENT d ON d.ID = m.IDDEPARTEMENT
         WHERE --meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) and
             meref.ETAT >= 11 AND meref.IDTYPEMVSTOCK != 'TPMVST000023'
         GROUP BY mff.idproduit, meref.idmagasin,ai.LIBELLE,ai.CATEGORIEINGREDIENT,ai.UNITE,ai.TYPESTOCK,u.VAL,c.VAL,m.VAL,
                  ai.PARFUMS,m.IDDEPARTEMENT,d.val
     )
-- Sélection finale
SELECT
    null as ID, null as DATY,  cast(invquantite as number(30,2)) as invquantite,cast(entree as number(30,2)) as entree, cast(sortie as number(30,2)) as sortie,CAST((invquantite)+(ENTREE)-(sortie) AS NUMBER(30,2)) as reste,
    CAST(invquantite+ENTREE-sortie AS NUMBER(30,2)) AS quantite,
    CAST((montantInv+montantEntree-montantSortie)AS NUMBER(30,2))AS montantreste,
    cast((montantInv+montantEntree-montantSortie)/(invquantite+ENTREE-sortie)  as number(30,2)) as pu,
    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,
    IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib,invdaty,codeproduit,IDDEPARTEMENT,departementlib
FROM somme_precalc
WHERE invquantite+ENTREE-sortie != 0;
