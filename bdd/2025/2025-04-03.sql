CREATE OR REPLACE VIEW FABRICATION_OF AS (
SELECT f.id,f.idingredients,f.libelle,f.remarque,f.datybesoin,f.qte,f.idunite,f2.IDOF
FROM FABRICATIONFILLE f 
JOIN FABRICATION f2 ON f.IDMERE =f2.ID
)