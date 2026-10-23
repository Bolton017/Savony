create or replace view V_ETATSTOCK_LOCALISATION as
WITH max_inventaire AS (
    SELECT
        invff.IDPRODUIT,
        imeref.IDMAGASIN,
        invff.COMPTELOCALISATION,
        MAX(imeref.DATY) AS max_daty,
        MAX(invff.QUANTITE) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS qte_max_daty,
        MAX(invff.pu) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS pu_max_daty
    FROM INVENTAIREFILLE invff
    LEFT JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE
    WHERE imeref.ETAT >= 11
    GROUP BY invff.IDPRODUIT, imeref.IDMAGASIN, invff.COMPTELOCALISATION
),
    mouvements AS (
        SELECT
            mff.idproduit,
            meref.idmagasin,
            mff.COMPTELOCALISATION,
            NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.ENTREE ELSE 0 END), 0) AS entree,
            NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.SORTIE ELSE 0 END), 0) AS sortie,
            avg(mff.PU) as pu,
            NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.ENTREE*mff.pu ELSE 0 END), 0) AS montantEntree,
            NVL(SUM(CASE WHEN meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) THEN mff.SORTIE*mff.pu ELSE 0 END), 0) AS montantSortie
        FROM MVTSTOCKFILLE mff
        LEFT JOIN mvtStockDateHeure meref ON meref.ID = mff.IDMVTSTOCK
        LEFT JOIN max_inventaire inv ON inv.idproduit = mff.idproduit
        AND inv.idmagasin = meref.idmagasin
        AND inv.COMPTELOCALISATION = mff.COMPTELOCALISATION
        WHERE meref.ETAT >= 11 AND meref.IDTYPEMVSTOCK != 'TPMVST000023'
        GROUP BY mff.idproduit, meref.idmagasin, mff.COMPTELOCALISATION
     ),
    somme_precalc AS (
        SELECT
            NVL(mv.idproduit, inv.idproduit) as idproduit,
            NVL(mv.idmagasin, inv.idmagasin) as idmagasin,
            NVL(mv.COMPTELOCALISATION, inv.COMPTELOCALISATION) as compteLocalisation,
            NVL(mv.entree, 0) AS entree,
            NVL(mv.sortie, 0) AS sortie,
            ai.LIBELLE AS idproduitlib,
            ai.CATEGORIEINGREDIENT as CATEGORIEINGREDIENT,
            ai.UNITE as unite,
            ai.TYPESTOCK as typestock,
            u.VAL AS idunitelib,
            c.VAL AS idtypeproduitlib,
            mv.pu,
            null as IDFOURNISSEUR,
            null as IDFOURNISSEURLIB,
            m.VAL AS idmagasinlib,
            loc.LIBELLE AS COMPTELOCALISATIONLIB,
            inv.max_daty AS invdaty,
            nvl(inv.qte_max_daty,0) as invquantite,
            NVL(mv.montantEntree, 0) AS montantEntree,
            NVL(mv.montantSortie, 0) AS montantSortie,
            nvl(inv.pu_max_daty * inv.qte_max_daty,0) as montantInv,
            nvl(ai.SEUIL,0) as seuil,
            nvl(ai.SEUILMAX,
            nvl(ai.SEUILMIN,0)+1000) as seuilmax,
            nvl(ai.SEUILMIN,0) as seuilMin,
            ai.PARFUMS as codeproduit,
            m.IDDEPARTEMENT,
            d.val as departementlib
        FROM mouvements mv
        FULL OUTER JOIN max_inventaire inv ON inv.idproduit = mv.idproduit
            AND inv.idmagasin = mv.idmagasin
            AND inv.COMPTELOCALISATION = mv.COMPTELOCALISATION
        LEFT JOIN AS_INGREDIENTS ai ON ai.id = NVL(mv.IDPRODUIT, inv.IDPRODUIT)
        LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
        LEFT JOIN MAGASINPOINT m ON m.id = NVL(mv.IDMAGASIN, inv.IDMAGASIN)
        LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
        LEFT JOIN LOCALISATION loc ON loc.id = NVL(mv.COMPTELOCALISATION, inv.COMPTELOCALISATION)
        LEFT JOIN DEPARTEMENT d ON d.ID = m.IDDEPARTEMENT
    )
SELECT
    null as ID, null as DATY,
    cast(invquantite as number(30,3)) as invquantite,
    cast(entree as number(30,3)) as entree,
    cast(sortie as number(30,3)) as sortie,
    CAST((invquantite)+(ENTREE)-(sortie) AS NUMBER(30,3)) as reste,
    CAST(invquantite+ENTREE-sortie AS NUMBER(30,3)) AS quantite,
    CAST((montantInv+montantEntree-montantSortie) AS NUMBER(30,2)) AS montantreste,
    cast((montantInv+montantEntree-montantSortie)/(invquantite+ENTREE-sortie) as number(30,2)) as pu,
    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,
    IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib,
    compteLocalisation, COMPTELOCALISATIONLIB,
    invdaty, codeproduit, IDDEPARTEMENT, departementlib
FROM somme_precalc
WHERE invquantite+ENTREE-sortie != 0;



create or replace view MVTSTOCKFILLECPTSTOCK as
select msf."ID",
       msf."IDMVTSTOCK",
       msf."IDPRODUIT",
       msf."IDVENTEDETAIL",
       msf."IDTRANSFERTDETAIL",
       msf."MVTSRC",
       msf."DESIGNATION",
       msf."ENTREE",
       msf."SORTIE",
       msf."PU",
       msf."RESTE",
       msf."IDINVENTAIREFILLE",
       msf."DATEINVENTAIRE",
       msf."QTEINVENTAIRE",
       ing.COMPTE_STOCK,
       ing.COMPTE_SORTIE_STOCK,
       msf.COMPTELOCALISATION
from MVTSTOCKFILLE msf
left join AS_INGREDIENTS ing on ing.id=msf.IDPRODUIT;

UPDATE LOCALISATION SET CLASSY = 'PHARM005'
WHERE upper(CLASSY) LIKE upper('%PRODUIT FINI%');

INSERT INTO COMPTA_COMPTE (ID, COMPTE, LIBELLE, TYPECOMPTE, CLASSY, ANALYTIQUE_OBLI, IDJOURNAL, CODEIMPOT) VALUES ('COMCSOC2608001', '322300', 'Piece de rechange commun', '1', '4', null, 'COMP000042', null);
