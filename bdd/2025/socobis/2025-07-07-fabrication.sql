------------- fabrication

CREATE OR REPLACE VIEW AS_RECETTEFABLIB AS
select arf.ID,arf.IDINGREDIENTS,arf.UNITE,arf.QTEAV,arf.QUANTITE,arf.IDPRODUITS,i.LIBELLE ||' ('||u.VAL||')' as libIngredients,i.TYPESTOCK,i.CATEGORIEINGREDIENT, i.pu from as_recettefabrication arf
                                                                                                                                                                                left join AS_INGREDIENTS i on arf.idingredients=i.id
                                                                                                                                                                                left join AS_UNITE u on i.UNITE=u.ID;


CREATE OR REPLACE VIEW AS_RECFABLIBGROUPE AS
select a.IDPRODUITS,a.idingredients,max(a.unite) as unite,sum(quantite) as quantite, avg(a.qteav) as qteav,avg(a.pu) AS pu, a.libIngredients,a.categorieingredient
from as_recetteFabLib a group by a.IDPRODUITS, a.idingredients, a.libIngredients,a.categorieingredient;


CREATE OR REPLACE VIEW STOCKETDEPENSEFABTHE AS
SELECT
    sed.IDOBJET,
    sed.IDPRODUIT,
    recFab.LIBINGREDIENTS AS designation,
    cast(sed.ENTREE as number(30,2)) as entree ,
    cast(sed.SORTIE as number(30,2)) as sortie,
    CAST(
            CASE
                WHEN nvl(sed."PU",0) = 0 THEN recFab.pu
                ELSE nvl(sed."PU",0)
                END
        as number(30,2)) AS PU,
    cast(sed.MONTANTENTREE as number(30,2)) as MONTANTENTREE,
    CAST(
            CASE
                WHEN nvl(sed."PU",0) = 0 THEN recFab.pu * sed.SORTIE
                ELSE nvl(sed."PU",0) * sed.SORTIE
                END
        as number(30,2)) as MONTANTSORTIE ,
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
   