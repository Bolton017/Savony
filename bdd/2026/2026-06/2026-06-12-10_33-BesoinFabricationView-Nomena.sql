create or replace view BESOINFABRICATIONDETAILSCPL as
SELECT
    bfd.id,
    bfd.idBesoinFabrication,
    bfd.idProduit,
    bfd.qte,
    bfd.unite,
    bfd.IDMERE,
    p.LIBELLE                            AS idproduitLib,
    u.VAL                                AS uniteLib,
    bfdl.mois,
    bfdl.annee,
    bfdl.daty,
    DECODE(bfdl.mois,
           1, 'Janvier', 2, 'Février', 3, 'Mars', 4, 'Avril',
           5, 'Mai', 6, 'Juin', 7, 'Juillet', 8, 'Août',
           9, 'Septembre', 10, 'Octobre', 11, 'Novembre', 12, 'Décembre'
    ) AS moisLib,
    DECODE(bfdl.mois,
           1, 'Janvier', 2, 'Février', 3, 'Mars', 4, 'Avril',
           5, 'Mai', 6, 'Juin', 7, 'Juillet', 8, 'Août',
           9, 'Septembre', 10, 'Octobre', 11, 'Novembre', 12, 'Décembre'
    )
        || ' ' || bfdl.annee AS moisAnneeLib,
    (bfdl.annee * 100 + bfdl.mois) AS TRI_CHRONO
FROM BesoinFabricationDetails bfd
         LEFT JOIN AS_INGREDIENTS p ON p.id = bfd.idProduit
         LEFT JOIN AS_UNITE u ON u.id = bfd.unite
         LEFT JOIN BESOINFABRICATION bfdl ON bfdl.id = bfd.IDBESOINFABRICATION
WHERE p.categorieIngredient = 'CAT008'
ORDER BY mois ASC;

create or replace view BESOINFABRICATIONDETAILSORDER as
select "ID","IDBESOINFABRICATION","IDPRODUIT","QTE","UNITE",IDPRODUITLIB  ,"UNITELIB","MOIS","ANNEE","DATY","MOISLIB","MOISANNEELIB","TRI_CHRONO"
from BESOINFABRICATIONDETAILSCPL ORDER BY mois ASC;

create or replace view BESFABDETRECETTECOMP as
select b."ID",b."IDBESOINFABRICATION",b."IDPRODUIT",b."QTE",b."UNITE",b."IDPRODUITLIB",b."UNITELIB",b."MOIS",b."ANNEE",b."DATY",b."MOISLIB",b."MOISANNEELIB",b."TRI_CHRONO",
       ar.IDINGREDIENTS,
       CAST(ar.QUANTITE * b.QTE AS NUMBER(30,10)) as QUANTITEINGREDIENTS,
       TRIM(ar.UNITE) as UNITEINGREDIENTS,
       ai.LIBELLE as LIBELLEINGREDIENT,
       u.VAL as VALUNITE
from BESOINFABRICATIONDETAILSORDER b
         left join as_recettecompose ar on b.IDPRODUIT = ar.IDPRODUITS
         left join AS_INGREDIENTS ai on ai.id = ar.IDINGREDIENTS
         left join unite u on u.ID = TRIM(ar.UNITE)
where ai.CATEGORIEINGREDIENT <> 'CAT001101';

create or replace view BESFABDETRECETTEGBINGCOMP as
select  b.IDINGREDIENTS as IDPRODUIT, sum(QUANTITEINGREDIENTS) as QTE, UNITEINGREDIENTS as UNITE, LIBELLEINGREDIENT as IDPRODUITLIB, VALUNITE as uniteLib,MOIS, ANNEE, DATY, MOISLIB, MOISANNEELIB
from BESFABDETRECETTEComp b
group by b.IDINGREDIENTS, UNITEINGREDIENTS, LIBELLEINGREDIENT, VALUNITE, MOIS, ANNEE, DATY, MOISLIB, MOISANNEELIB;