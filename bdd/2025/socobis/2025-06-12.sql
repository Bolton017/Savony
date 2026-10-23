CREATE OR REPLACE VIEW V_ETATSTOCK_ING as           
SELECT
 p.ID AS ID,
 p.LIBELLE AS idproduitLib,
 p.CATEGORIEINGREDIENT,
 tp.DESCE AS idtypeproduitlib,
 ms.IDMAGASIN,
 mag.VAL AS idmagasinlib,
 TO_DATE('01-01-2001', 'DD-MM-YYYY') AS dateDernierMouvement,
 ms.quantite AS QUANTITE,
 ms.entree AS ENTREE,
 ms.sortie AS SORTIE,
 ms.quantite AS reste,
 p.UNITE,
 u.DESCE AS idunitelib,
 CAST(NVL(p.PV, 0) AS NUMBER(30, 2)) AS PUVENTE,
 mag.IDPOINT,
 mag.IDTYPEMAGASIN,
 p.SEUILMIN,
 p.SEUILMAX,
 ms.montantEntree,
 ms.montantSortie,
 p.pu,
 ms.montant as montantReste
FROM AS_INGREDIENTS p
LEFT JOIN MONTANT_STOCK ms ON ms.IDPRODUIT = p.ID
LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID
LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID
LEFT JOIN AS_UNITE u ON p.UNITE = u.ID
WHERE NVL(ms.ENTREE, 0)>0 or NVL(ms.SORTIE, 0)>0;

CREATE OR REPLACE VIEW AS_INGREDIENTS_LIB AS
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
       ing.REFPOST
FROM as_ingredients ing
         JOIN AS_UNITE AU ON ing.UNITE = AU.ID
         JOIN CATEGORIEINGREDIENTLIB catIng
              ON catIng.id = ing.CATEGORIEINGREDIENT;


CREATE OR REPLACE VIEW RECETTEMONTANT AS
select
    rec.ID,rec.IDPRODUITS,rec.IDINGREDIENTS,cast(rec.QUANTITE as number(30,10)) as QUANTITE,rec.UNITE,'-' as libIngredients,'-' as IDUNITE,'' as source,0 as COMPOSE,
    cast(0 as number(30,10)) as qteav,
    cast(0 as number(30,10)) as qtetotal,
    i.TYPESTOCK,
    i.REFPOST,
    0 as niveau
from as_recette rec
         left join AS_INGREDIENTS i on rec.IDINGREDIENTS=i.ID;


CREATE OR REPLACE VIEW AS_RECETTEFABLIB AS
select arf.ID,arf.IDINGREDIENTS,arf.UNITE,arf.QTEAV,arf.QUANTITE,arf.IDPRODUITS,i.LIBELLE ||' ('||u.VAL||')' as libIngredients,i.TYPESTOCK,i.CATEGORIEINGREDIENT from as_recettefabrication arf
                                                                                                                                                                          left join AS_INGREDIENTS i on arf.idingredients=i.id
                                                                                                                                                                          left join AS_UNITE u on i.UNITE=u.ID;


CREATE OR REPLACE VIEW AS_RECETTEFABLIBSERVICE AS
SELECT ID,IDINGREDIENTS,UNITE,QTEAV,QUANTITE,IDPRODUITS,LIBINGREDIENTS,TYPESTOCK,categorieingredient FROM As_recetteFabLib WHERE TYPESTOCK IS NULL AND UNITE = 'UNT003' AND CATEGORIEINGREDIENT!='CAT002';

CREATE OR REPLACE VIEW STOCKETDEPENSEFABTHECAT  AS
select std.IDOBJET,std.IDPRODUIT,std.ENTREE,std.SORTIE,std.PU,std.MONTANTENTREE,std.MONTANTSORTIE,std.IDMERE,std.ID,std.QTETH,std.PUTH,std.MONTTH,cat.VAL as CATEGORIEINGREDIENT, ing.CATEGORIEINGREDIENT IDCATEGORIEINGREDIENT from stockEtDepenseFabThe std
                                                                                                                                                                                                                                         left join AS_INGREDIENTS ing on std.IDPRODUIT=ing.id
                                                                                                                                                                                                                                         left join CATEGORIEINGREDIENT cat on ing.CATEGORIEINGREDIENT=cat.id;

CREATE OR REPLACE VIEW STOCKETDEPFABTHECATGROUPE AS
select st.IDOBJET ,st.CATEGORIEINGREDIENT,st.idcategorieingredient,cast(sum(montantsortie) as number(30,2)) as montantSortie,cast(sum(montth) as number(30,2)) as montth, cast(sum(montth)-sum(montantsortie) as number(30,2)) as ecart
from stockEtDepenseFabTheCat st
group by st.idobjet,st.CATEGORIEINGREDIENT,st.idcategorieingredient;

CREATE OR REPLACE VIEW AS_RECETTEFABLIB AS
select arf.ID,arf.IDINGREDIENTS,arf.UNITE,arf.QTEAV,arf.QUANTITE,arf.IDPRODUITS,i.LIBELLE ||' ('||u.VAL||')' as libIngredients,i.TYPESTOCK,i.CATEGORIEINGREDIENT from as_recettefabrication arf
                                                                                                                                                                          left join AS_INGREDIENTS i on arf.idingredients=i.id
                                                                                                                                                                          left join AS_UNITE u on i.UNITE=u.ID;

CREATE OR REPLACE VIEW AS_RECFABLIBGROUPE AS
select a.IDPRODUITS,a.idingredients,max(a.unite) as unite,sum(quantite) as quantite, avg(a.qteav) as qteav, a.libIngredients,a.categorieingredient
from as_recetteFabLib a group by a.IDPRODUITS, a.idingredients, a.libIngredients,a.categorieingredient;


CREATE OR REPLACE VIEW STOCKETDEPENSEFABTHE AS
SELECT
    sed.IDOBJET,
    sed.IDPRODUIT,
    recFab.LIBINGREDIENTS AS designation,
    cast(sed.ENTREE as number(30,2)) as entree ,
    cast(sed.SORTIE as number(30,2)) as sortie,
    cast(sed.PU as number(30,2)) as pu,
    cast(sed.MONTANTENTREE as number(30,2)) as MONTANTENTREE,
    cast(sed.MONTANTSORTIE as number(30,2)) as MONTANTSORTIE ,
    sed.IDMERE,
    sed.ID,
    CAST(nvl(recFab.QUANTITE, 0) AS NUMBER(30,
                                           10)) AS qteTh,
    CAST(nvl(recFab.QTEAV, sed.pu) AS NUMBER(30,
                                             2)) AS puth,
    CAST(nvl(recFab.QUANTITE, 0)* nvl(recFab.QTEAV, 0) AS NUMBER(30,
                                                                 2)) AS montTh,
    recFab.CATEGORIEINGREDIENT
FROM
    stockEtDepenseFab sed
        FULL OUTER JOIN as_recFabLibGroupe recFab
                        ON
                            sed.IDOBJET = recFab.IDPRODUITS
                                AND sed.IDPRODUIT = recFab.IDINGREDIENTS ;
