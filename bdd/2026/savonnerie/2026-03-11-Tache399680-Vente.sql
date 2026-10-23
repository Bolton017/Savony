-- SAVONNERIE0126.AS_BONDELIVRAISON_CLIENT_CPL source

CREATE OR REPLACE  VIEW AS_BONDELIVRAISON_CLIENT_CPL (ID, REMARQUE, IDVENTE, DESIGNATION, IDBC, DATY, ETAT, IDMAGASIN, MAGASIN, IDRESERVATION, IDCLIENTLIB, VEHICULE, CHAUFFEUR, DESCRIPTION, IDCLIENT, ETATLIB) AS 
  SELECT bl.id, bl.remarque,
v.id AS idvente,
v.designation,
bl.idbc, bl.daty, bl.etat,
m.id AS idmagasin,
m.val AS magasin,
v.IDRESERVATION,
c.nom AS IDCLIENTlib,
bl.vehicule,
bl.chauffeur,
bl.description,
c.id AS idClient,
CASE
        WHEN bl.ETAT = 1  THEN 'Crée'
        WHEN bl.ETAT = 11 THEN 'Validée'
        WHEN bl.ETAT = 3 THEN 'BL Préparé (En attente de livraison)'
        ELSE 'Autre'
       END AS etatlib
FROM AS_BONDELIVRAISON_CLIENT bl
LEFT JOIN MAGASINPOINT m ON bl.magasin=m.id
LEFT JOIN vente v ON v.id=bl.idvente
LEFT JOIN client c ON c.ID = bl.IDCLIENT
 ;