CREATE OR REPLACE VIEW stockEtDepenseOfFabThe as
select
    sed."IDOBJET",
    sed."IDPRODUIT",
    nvl(recFab.LIBINGREDIENTS,ai.LIBELLE) AS designation,
    CAST(sed."ENTREE" as number(30,2)) AS ENTREE ,
    CAST(sed."SORTIE" as number(30,2))  AS SORTIE ,
    CAST(
            CASE
                WHEN nvl(sed."PU",0) = 0 THEN recFab.pu
                ELSE nvl(sed."PU",0)
                END
        as number(30,2)) AS PU,
    CAST(sed."MONTANENTREE" as number(30,2)) AS MONTANENTREE ,
    CAST(
            CASE
                WHEN nvl(sed."PU",0) = 0 THEN recFab.pu * sed."SORTIE"
                ELSE nvl(sed."PU",0) * sed."SORTIE"
                END
        as number(30,2))  AS MONTANTSORTIE,
    sed."IDMERE",
    sed."ID",
    cast(nvl(recFab.QUANTITE,0) as number(30,10)) as qteTh,
    cast(nvl(recFab.QTEAV,sed.pu) as number(30,2)) as puth,
    cast(nvl(recFab.QUANTITE,0)*nvl(recFab.QTEAV,0) as number(30,2)) as montTh,
    recFab.CATEGORIEINGREDIENT
from stockDepenseOfFab sed full
                               outer join AS_RECFOFABLIBGROUPE recFab
                                          on sed.IDOBJET=recFab.IDPRODUITS and sed.IDPRODUIT=recFab.IDINGREDIENTS
                           LEFT JOIN AS_INGREDIENTS ai ON ai.ID = sed.IDOBJET OR ai.ID =  sed.IDPRODUIT;