CREATE OR REPLACE VIEW FABRICATIONCPL AS 
  SELECT
    f.ID,f.LANCEPAR,f.CIBLE,f.REMARQUE,f.LIBELLE,f.BESOIN,f.DATY,f.idOffille,nvl(f.idof, off.idmere) AS idof,
    p.val AS lanceparLib,
    p2.val AS cibleLib,
    f.etat AS etat,
    f.fabricationsuiv,
    f.FABRICATIONPREC,
    CASE
        WHEN f.ETAT=1
            THEN 'CRÉÉ'
        WHEN f.ETAT=11
            THEN 'VALIDÉ'
        WHEN f.ETAT=0
            THEN 'ANNULÉ'
        WHEN f.ETAT=21
            THEN 'ENTAMÉ'
        WHEN f.ETAT=31
            THEN 'BLOQUÉ'
        WHEN f.ETAT=41
            THEN 'TERMINÉ'
        END AS ETATLIB
FROM FABRICATION f
         LEFT JOIN POINT p ON p.id = f.lancepar
         LEFT JOIN MAGASIN2 p2 ON p2.id = f.cible
         LEFT JOIN offille off ON f.idoffille = off.id;

CREATE OR REPLACE VIEW COMPTEURLIB AS 
  SELECT 
c."ID",c."NOMBRE",c."IDFABRICATION",c."IDMACHINE",c."DATY",c."HEURE",c."DEBUT",c."ETAT",c."IDORIGINE",
f.LIBELLE AS idfabricationlib,
m.VAL AS idmachinelib,
CASE 
	WHEN c.etat = 0 
	THEN 'ANNULÉE'
	WHEN c.etat = 1 
	THEN 'CRÉÉE'
	WHEN c.etat = 11 
	THEN 'VISÉE'
END AS etatlib
FROM COMPTEUR c 
LEFT JOIN FABRICATION f ON f.id = c.idfabrication
LEFT JOIN MACHINE m ON m.id = c.idmachine
;

UPDATE ETATOBJETMAINTENANCE x
	SET x.VAL='Disponible'
	WHERE x.ID='ETOM0001';

UPDATE MENUDYNAMIQUE x
	SET x.ICONE='settings'
	WHERE x.ID='MNDNMT012';
