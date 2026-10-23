alter table MVTSTOCK add heure VARCHAR2(10);
alter table INVENTAIRE add heure VARCHAR2(10);

create or replace view mvtStockDateHeure as
select m.ID, DESIGNATION, IDMAGASIN, IDVENTE, IDTRANSFERT, IDTYPEMVSTOCK, TO_DATE(TO_CHAR(m.DATY, 'YYYY-MM-DD') || ' ' || NVL(m.HEURE, '00:00:00'), 'YYYY-MM-DD HH24:MI:SS') as DATY, ETAT, IDPOINT, IDOBJET, FABPRECEDENT, IDCATEGORIESTOCK, HEURE from MVTSTOCK m;

create or replace view inventaireDateHeure as
select i.ID, TO_DATE(TO_CHAR(i.DATY, 'YYYY-MM-DD') || ' ' || NVL(i.HEURE, '00:00:00'), 'YYYY-MM-DD HH24:MI:SS') as DATY, DESIGNATION, IDMAGASIN, ETAT, REMARQUE, IDCATEGORIE, HEURE from INVENTAIRE i;

create or replace view V_ETATSTOCK_ENTREE as
WITH max_inventaire AS (
    -- ?    tape 1 : On extrait la date maximale valide par produit une fois pour toutes
    SELECT
        invff.MVTSRC,
        MAX(imeref.DATY) AS max_daty
    FROM INVENTAIREFILLE invff
             LEFT JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE
    WHERE imeref.ETAT >= 11
    GROUP BY invff.MVTSRC
),
     inv_final_precalc AS (
         -- ?   tape 2 : On r??cup??re les quantit??s associ??es ?  cette date maximale
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
         -- ?   tape 3 : Calcul des sommes globales (sorties/entr??es) sans sous-requ??te corr??l??e cass??e
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
         -- ?   tape 4 : Requ??te principale avec application exacte des r??gles de calcul d'origine
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
             invfinal.invdaty AS invdaty,
             loc.LIBELLE as COMPTELOCALISATIONLIB
         FROM MVTSTOCKFILLE mf
                  LEFT JOIN mvtStockDateHeure mere ON mere.id = mf.IDMVTSTOCK
                  LEFT JOIN somme_precalc somme ON somme.MVTSRC = mf.id
                  LEFT JOIN inv_final_precalc invfinal ON invfinal.MVTSRC = mf.ID
                  LEFT JOIN AS_INGREDIENTS ai ON ai.id = mf.IDPRODUIT
                  LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
                  LEFT JOIN MAGASINPOINT m ON mere.IDMAGASIN = m.id
                  LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
                  LEFT JOIN AS_BONDELIVRAISON_LIB b ON b.ID = mere.IDOBJET
                  LEFT JOIN LOCALISATION loc ON loc.id=mf.COMPTELOCALISATION
         WHERE mf.ENTREE > 0
           AND mere.IDTYPEMVSTOCK != 'TPMVST000023'
           AND mere.ETAT >= 11
     )
SELECT
    ID, DATY, CAST(invquantite AS NUMBER(30,2)) AS invquantite, CAST(entree AS NUMBER(30,2)) AS entree, CAST(sortie AS NUMBER(30,2)) AS sortie, CAST(reste AS NUMBER(30,2)) AS reste,
    CAST(reste AS NUMBER(30,2)) AS quantite,
    CAST(reste * PU AS NUMBER(30,2)) AS montantreste,
    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,
    PU, IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib, invdaty,COMPTELOCALISATIONLIB
FROM main_data
WHERE reste != 0;


create or replace view V_ETATSTOCK_ING as
WITH max_inventaire AS (
    -- Étape 1 : On extrait la date maximale valide et la quantité par COUPLE produit/magasin
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
             mff.compteLocalisation,
             loc.LIBELLE as COMPTELOCALISATIONLIB
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
         GROUP BY mff.idproduit, meref.idmagasin,ai.LIBELLE,ai.CATEGORIEINGREDIENT,ai.UNITE,ai.TYPESTOCK,u.VAL,c.VAL,m.VAL, loc.LIBELLE, mff.compteLocalisation
     )
-- Sélection finale
SELECT
    null as ID, null as DATY,  cast(invquantite as number(30,2)) as invquantite,cast(entree as number(30,2)) as entree, cast(sortie as number(30,2)) as sortie,CAST((invquantite)+(ENTREE)-(sortie) AS NUMBER(30,2)) as reste,
    CAST(invquantite+ENTREE-sortie AS NUMBER(30,2)) AS quantite,
    CAST((montantInv+montantEntree-montantSortie)AS NUMBER(30,2))AS montantreste,
    cast((montantInv+montantEntree-montantSortie)/(invquantite+ENTREE-sortie)  as number(30,2)) as pu,
    idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,
    IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib,invdaty,compteLocalisation,COMPTELOCALISATIONLIB
FROM somme_precalc
WHERE invquantite+ENTREE-sortie != 0
--and idproduit='IG001356'
;



create or replace  view MVTSTOCKFILLELIB AS
SELECT
    m.ID ,
    m.IDMVTSTOCK ,
    m.IDPRODUIT ,
    p.libelle  AS IDPRODUITLIB,
    m.ENTREE ,
    m.SORTIE ,
    m.IDVENTEDETAIL ,
    '' AS IDVENTEDETAILLIB,
    m.IDTRANSFERTDETAIL ,
    '' AS IDTRANSFERTDETAILLIB,
    m2.DATY ,
    m2.IDMAGASIN ,
    m3.VAL AS IDMAGASINLIB,
    m.pu,
    cast(m.pu*m.ENTREE+(m.pu*m.sortie) as number(20,5)) as montant,
    p.LIBELLE,
    m.MVTSRC,
    p.libelle AS libelleexacte,
    m2.DATY AS dateSql,
    m2.IDTYPEMVSTOCK,
    m.IDLOT,
    m2.IDOBJET,
    TO_CHAR(l.DATY, 'DD/MM/YYYY') || '-' || l.IDPRODUIT || '-' || l.IDEQUIPE AS IDLOTLIB,
    loc.libelle AS complelocalisationlib,
    m2.ETAT
FROM MVTSTOCKFILLE m
         LEFT JOIN AS_INGREDIENTS  p ON p.ID = m.IDPRODUIT
         LEFT JOIN MVTSTOCK m2 ON m2.ID = m.IDMVTSTOCK
         LEFT JOIN MAGASIN2 m3 ON m3.ID = m2.IDMAGASIN
         LEFT JOIN LOT l on l.ID = m.IDLOT
         LEFT JOIN localisation loc ON m.comptelocalisation=loc.id;

