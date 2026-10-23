
create view as_ingredient_dep as
SELECT ing.*,c.IDDEPARTEMENT,d.val as departementlib from AS_INGREDIENTS ing
    LEFT JOIN CATEGORIEINGREDIENT c on c.id = ing.CATEGORIEINGREDIENT
    LEFT JOIN DEPARTEMENT d ON d.ID = c.IDDEPARTEMENT;


create or replace view MVTSTOCKFILLELIB as
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
    m2.ETAT,
    p.IDDEPARTEMENT,
    p.departementlib
FROM MVTSTOCKFILLE m
         LEFT JOIN as_ingredient_dep  p ON p.ID = m.IDPRODUIT
         LEFT JOIN MVTSTOCK m2 ON m2.ID = m.IDMVTSTOCK
         LEFT JOIN MAGASIN2 m3 ON m3.ID = m2.IDMAGASIN
WHERE p.actif = 1;


create or replace view ST_INGREDIENTSAUTO as
SELECT
    ai.ID,
    ai.LIBELLE,
    ai.SEUIL,
    au.val AS UNITE,
    au.id AS idUNITE,
    ai.QUANTITEPARPACK,
    ai.PU,
    ai.ACTIF,
    ai.PHOTO,
    ai.CALORIE,
    ai.DURRE,
    ai.COMPOSE,
    ai.CATEGORIEINGREDIENT,
    ai.IDFOURNISSEUR,
    ai.DATY,
    ai.QTELIMITE,
    ai.PV,
    ai.LIBELLEVENTE,
    ai.SEUILMIN,
    ai.SEUILMAX,
    ai.PUACHATUSD,
    ai.PUACHATEURO,
    ai.PUACHATAUTREDEVISE,
    ai.PUVENTEUSD,
    ai.PUVENTEEURO,
    ai.PUVENTEAUTREDEVISE,
    ai.ISVENTE,
    ai.ISACHAT,
    ai.COMPTE_VENTE,
    ai.COMPTE_ACHAT,
    CASE
        WHEN ai.COMPTE_VENTE IS NOT NULL THEN ai.COMPTE_VENTE
        ELSE ai.COMPTE_ACHAT
        END AS compte,
    au.VAL AS UNITELIB,
    ca.IDDEPARTEMENT
FROM AS_INGREDIENTS ai
         LEFT JOIN AS_UNITE au ON au.id = ai.UNITE
         LEFT JOIN CATEGORIEINGREDIENT ca ON ca.id = ai.CATEGORIEINGREDIENT
WHERE ai.actif = 1;


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
             mf.compteLocalisation,
             loc.LIBELLE as COMPTELOCALISATIONLIB,
             ai.PARFUMS as codeproduit,
             ai.IDDEPARTEMENT,
             ai.departementlib
         FROM MVTSTOCKFILLE mf
                  LEFT JOIN mvtStockDateHeure mere ON mere.id = mf.IDMVTSTOCK
                  LEFT JOIN somme_precalc somme ON somme.MVTSRC = mf.id
                  LEFT JOIN inv_final_precalc invfinal ON invfinal.MVTSRC = mf.ID
                  LEFT JOIN AS_INGREDIENT_DEP ai ON ai.id = mf.IDPRODUIT
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
    PU, IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib, invdaty,COMPTELOCALISATIONLIB,compteLocalisation,codeproduit,IDDEPARTEMENT,departementlib
FROM main_data
WHERE reste != 0;






create or replace view  V_ETATSTOCK_ING as
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
    compteLocalisation,
    COMPTELOCALISATIONLIB,
    codeproduit,
    IDDEPARTEMENT,
    departementlib
FROM (
         SELECT * FROM V_ETATSTOCK_ENTREE
         union all select * from (
                                     WITH max_inventaire AS (
                                         SELECT
                                             invff.IDPRODUIT,imeref.IDMAGASIN,
                                             MAX(imeref.DATY) AS max_daty
                                                 ,MAX(invff.QUANTITE) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS qte_max_daty,
                                             MAX(invff.pu) KEEP (DENSE_RANK LAST ORDER BY imeref.DATY) AS pu_max_daty
                                         FROM INVENTAIREFILLE invff
                                                  LEFT JOIN inventaireDateHeure imeref ON imeref.ID = invff.IDINVENTAIRE
                                         WHERE imeref.ETAT >= 11 and invff.MVTSRC is null
                                         GROUP BY invff.IDPRODUIT, imeref.IDMAGASIN
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
                                                  loc.LIBELLE as COMPTELOCALISATIONLIB,
                                                  mff.compteLocalisation,
                                                  ai.PARFUMS as codeproduit,
                                                  ai.IDDEPARTEMENT,
                                                  ai.departementlib
                                              FROM MVTSTOCKFILLE mff
                                                       LEFT JOIN mvtStockDateHeure meref ON meref.ID = mff.IDMVTSTOCK
                                                       LEFT JOIN max_inventaire inv ON inv.idproduit = mff.idproduit AND inv.idmagasin = meref.idmagasin
                                                       LEFT JOIN AS_INGREDIENT_DEP ai ON ai.id = mff.IDPRODUIT
                                                       LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
                                                       LEFT JOIN MAGASINPOINT m ON meref.IDMAGASIN = m.id
                                                       LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
                                                       LEFT JOIN LOCALISATION loc ON loc.id=mff.COMPTELOCALISATION
                                              WHERE --meref.DATY > NVL(inv.max_daty, TO_DATE('01/01/2025','DD-MM-YYYY')) and
                                                  meref.ETAT >= 11
                                                AND meref.IDTYPEMVSTOCK != 'TPMVST000023' and mff.MVTSRC is null
                                                and not exists(select 1 from V_ETATSTOCK_ENTREE  ve where ve.id = mff.id)
                                              GROUP BY mff.idproduit, meref.idmagasin,ai.LIBELLE,ai.CATEGORIEINGREDIENT,ai.UNITE,ai.TYPESTOCK,u.VAL,c.VAL,m.VAL,mff.compteLocalisation,ai.PARFUMS,loc.LIBELLE,ai.IDDEPARTEMENT,ai.departementlib
                                          )
                                     SELECT
                                         null as ID, null as DATY,  cast(invquantite as number(30,3)) as invquantite,cast(entree as number(30,3)) as entree, cast(sortie as number(30,3)) as sortie,CAST((invquantite)+(ENTREE)-(sortie) AS NUMBER(30,3)) as reste,
                                         CAST(invquantite+ENTREE-sortie AS NUMBER(30,3)) AS quantite,
                                         CAST((montantInv+montantEntree-montantSortie)AS NUMBER(30,2))AS montantreste,
                                         idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK, idunitelib, idtypeproduitlib,
                                         cast((montantInv+montantEntree-montantSortie)/(invquantite+ENTREE-sortie)  as number(30,2)) as pu,
                                         IDFOURNISSEUR, IDFOURNISSEURLIB, IDPRODUIT, IDMAGASIN, idmagasinlib,invdaty,
                                         COMPTELOCALISATIONLIB,COMPTELOCALISATION,codeproduit, IDDEPARTEMENT,
                                         departementlib
                                     FROM somme_precalc
                                     WHERE (invquantite+ENTREE-sortie) != 0)
     ) GROUP BY
           idproduitlib, CATEGORIEINGREDIENT, UNITE, TYPESTOCK,
           idunitelib, idtypeproduitlib, IDPRODUIT,
           IDMAGASIN, idmagasinlib, compteLocalisation, COMPTELOCALISATIONLIB, codeproduit,    IDDEPARTEMENT,
           departementlib;





create or replace view V_ETATSTOCK_ING_ENG as
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
    IDDEPARTEMENT,
    departementlib
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
           IDMAGASIN, idmagasinlib,IDDEPARTEMENT,departementlib;






