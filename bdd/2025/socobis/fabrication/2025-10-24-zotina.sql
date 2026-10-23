ALTER TABLE FABRICATIONFILLE 
ADD PU_TEMP NUMBER(25,5);

UPDATE FABRICATIONFILLE 
SET PU_TEMP = PU;


ALTER TABLE FABRICATIONFILLE 
DROP COLUMN PU;

ALTER TABLE FABRICATIONFILLE 
RENAME COLUMN PU_TEMP TO PU;

CREATE OR REPLACE VIEW STOCKETDEPENSEFABTHE  AS 
  SELECT
    sed.IDOBJET,
    sed.IDPRODUIT,
    recFab.LIBINGREDIENTS AS designation,
    cast(sed.ENTREE as number(30,5)) as entree ,
    cast(sed.SORTIE as number(30,5)) as sortie,
    CAST(
            CASE
                WHEN nvl(sed.PU,0) = 0 THEN recFab.pu
                ELSE nvl(sed.PU,0)
                END
        as number(30,5)) AS PU,
    cast(sed.MONTANTENTREE as number(30,5)) as MONTANTENTREE,
    CAST(
            CASE
                WHEN nvl(sed.PU,0) = 0 THEN recFab.pu * sed.SORTIE
                ELSE nvl(sed.PU,0) * sed.SORTIE
                END
        as number(30,2)) as MONTANTSORTIE ,
    sed.IDMERE,
    sed.ID,
    CAST(nvl(recFab.QUANTITE, 0) AS NUMBER(30,
                                           10)) AS qteTh,
    CAST(nvl(recFab.QTEAV, sed.pu) AS NUMBER(30,
                                             5)) AS puth,
    CAST(nvl(recFab.QUANTITE, 0)* nvl(recFab.QTEAV, 0) AS NUMBER(30,
                                                                 5)) AS montTh,
    recFab.CATEGORIEINGREDIENT
FROM
    stockEtDepenseFab sed
        FULL OUTER JOIN as_recFabLibGroupe recFab
                        ON
                            sed.IDOBJET = recFab.IDPRODUITS
                                AND sed.IDPRODUIT = recFab.IDINGREDIENTS ;



CREATE OR REPLACE  VIEW STOCKETDEPENSEOFFILLEFABTHE  AS 
  select
    sed.IDOBJET,
    sed.IDPRODUIT,
    nvl(recFab.LIBINGREDIENTS,ai.LIBELLE) AS designation,
    CAST(sed.ENTREE as number(30,5)) AS ENTREE ,
    CAST(sed.SORTIE as number(30,5))  AS SORTIE ,
    CAST(
            CASE
                WHEN nvl(sed.PU,0) = 0 THEN recFab.pu
                ELSE nvl(sed.PU,0)
                END
        as number(30,5)) AS PU,
    CAST(sed.MONTANENTREE as number(30,2)) AS MONTANENTREE ,
    CAST(
            CASE
                WHEN nvl(sed.PU,0) = 0 THEN recFab.pu * sed.SORTIE
                ELSE nvl(sed.PU,0) * sed.SORTIE
                END
        as number(30,2))  AS MONTANTSORTIE,
    sed.IDMERE,
    sed.ID,
    cast(nvl(recFab.QUANTITE,0) as number(30,10)) as qteTh,
    cast(nvl(recFab.QTEAV,sed.pu) as number(30,2)) as puth,
    cast(nvl(recFab.QUANTITE,0)*nvl(recFab.QTEAV,0) as number(30,2)) as montTh,
    sed.CATEGORIEINGREDIENT,
    sed.CATEGORIEINGREDIENTLIB
from STOCKDEPENSEOFFILLEFAB sed full
                                    outer join AS_RECFOFABLIBGROUPE recFab
                                               on sed.IDMERE =recFab.IDPRODUITS and sed.IDPRODUIT=recFab.IDINGREDIENTS
                                LEFT JOIN AS_INGREDIENTS ai ON ai.ID = sed.IDOBJET OR ai.ID =  sed.IDPRODUIT ;
