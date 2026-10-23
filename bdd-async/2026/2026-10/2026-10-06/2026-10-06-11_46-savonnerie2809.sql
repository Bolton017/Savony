--
--Description
--Créer une vue en base qui ne retourne QUE les magasins appartenant au DT 

CREATE VIEW magasin_dt
AS 
SELECT 
m.*
FROM MAGASIN2 m 
JOIN service s ON s.id = m.iddepartement 
WHERE s.DEPARTEMENT = 'DT';