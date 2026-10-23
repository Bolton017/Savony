CREATE OR REPLACE VIEW DISPONIBLITESTOCKOF_VIDE AS
SELECT '-'                          AS idIngredients,
       '-'                          AS libIngredients,
       '-'                          AS unite,
       '-'                          AS typestock,
       '-'                          AS categorieingredient,
       '-'                          AS idMagasinLib,
       CAST(0 AS NUMBER(30, 2))     AS qteAv,
       CAST(0 AS NUMBER(30, 2))     AS qteTotal,
       CAST(0 AS NUMBER(30, 2))     AS quantite,
       CAST(0 AS NUMBER(30, 2))     AS reste,
       CAST(NULL AS DATE)            AS daty
FROM DUAL;