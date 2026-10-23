create or replace view V_ETATSTOCK_ING_TOUS as
WITH max_inventaire AS (
    -- Etape 1 : On extrait la date maximale valide et la quantite par COUPLE produit/magasin
    SELECT
        invff.idproduit,
        imeref.idmagasin,
        MAX(imeref.DATY) AS max_daty,
        MAX(invff.QUANTITE) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS qte_max_daty,
        MAX(invff.pu) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS pu_max_daty
    FROM INVENTAIREFILLE invff
    LEFT JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE
    WHERE imeref.ETAT >= 11
    GROUP BY invff.idproduit, imeref.idmagasin
),
somme_precalc AS (
    -- Etape 3 : Calcul des sommes globales agregees par COUPLE produit/magasin
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
        nvl(avg(inv.pu_max_daty*inv.qte_max_daty),0) as montantInv, nvl(max(ai.SEUIL),0) as seuil,nvl(max(ai.SEUILMAX),nvl(max(ai.SEUILMIN),0)+1000) as seuilmax,nvl(max(ai.SEUILMIN),0) as seuilMin,
        mff.compteLocalisation,
        loc.LIBELLE as COMPTELOCALISATIONLIB,
        ai.PARFUMS as codeproduit
    FROM MVTSTOCKFILLE mff
    LEFT JOIN mvtStockDateHeure meref ON meref.ID = mff.IDMVTSTOCK
    LEFT JOIN max_inventaire inv ON inv.idproduit = mff.idproduit AND inv.idmagasin = meref.idmagasin
    LEFT JOIN AS_INGREDIENTS ai ON ai.id = mff.IDPRODUIT
    LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
    LEFT JOIN MAGASINPOINT m ON meref.IDMAGASIN = m.id
    LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
    LEFT JOIN LOCALISATION loc ON loc.id=mff.COMPTELOCALISATION
    WHERE --meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) and
      meref.ETAT >= 11
      AND meref.IDTYPEMVSTOCK != 'TPMVST000023'
    GROUP BY mff.idproduit, meref.idmagasin,ai.LIBELLE,ai.CATEGORIEINGREDIENT,ai.UNITE,ai.TYPESTOCK,u.VAL,c.VAL,m.VAL, mff.compteLocalisation, loc.LIBELLE, ai.PARFUMS
)
-- Selection finale
SELECT
    null as ID, null as DATY,  cast(invquantite as number(30,2)) as invquantite,cast(entree as number(30,2)) as entree, cast(sortie as number(30,2)) as sortie,CAST((invquantite)+(ENTREE)-(sortie) AS NUMBER(30,2)) as reste,
    CAST(invquantite+ENTREE-sortie AS NUMBER(30,2)) AS quantite,
    CAST((montantInv+montantEntree-montantSortie)AS NUMBER(30,2))AS montantreste,
    cast((montantInv+montantEntree-montantSortie)/(invquantite+ENTREE-sortie)  as number(30,2)) as pu,
    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,
     IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib,invdaty,cast(seuil as number(30,2))as seuil,cast(seuilMin as number(30,2))as seuilMin,cast(seuilMax as number(30,2))as seuilMax,compteLocalisation,COMPTELOCALISATIONLIB,codeproduit
FROM somme_precalc;

create or replace view V_ETATSTOCK_ING as
select ID,
       DATY,
       INVQUANTITE,
       ENTREE,
       SORTIE,
       RESTE,
       QUANTITE,
       MONTANTRESTE,
       PU,
       IDPRODUITLIB,
       CATEGORIEINGREDIENT,
       UNITE,
       TYPESTOCK,
       IDUNITELIB,
       IDTYPEPRODUITLIB,
       IDFOURNISSEUR,
       IDFOURNISSEURLIB,
       IDPRODUIT,
       IDMAGASIN,
       IDMAGASINLIB,
       INVDATY,
       SEUIL,
       SEUILMIN,SEUILMAX,compteLocalisation,COMPTELOCALISATIONLIB,
       codeproduit
from V_ETATSTOCK_ING_TOUS WHERE reste != 0;