CREATE OR REPLACE VIEW analyse_carte AS 
SELECT 
	mf.*,
	ai.libelle as vehicule
FROM mvtStockFille mf
JOIN MVTSTOCK  mst ON mst.id = mf.idmvtstock
join as_ingredients ai on mst.idobjet = ai.id ;
