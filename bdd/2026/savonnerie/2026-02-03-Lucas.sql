-- SAVONNERIE0126.AS_BONDELIVRAISON_CLIENT_CPL source

CREATE OR REPLACE  VIEW AS_BONDELIVRAISON_CLIENT_CPL (ID, REMARQUE, IDVENTE, DESIGNATION, IDBC, DATY, ETAT, IDMAGASIN, MAGASIN, IDRESERVATION, IDCLIENTLIB, VEHICULE, CHAUFFEUR, DESCRIPTION, IDCLIENT,ETATLIB) AS 
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
        WHEN bl.ETAT = 1  THEN 'Creer'
        WHEN bl.ETAT = 11 THEN 'Validee'
        WHEN bl.ETAT = 3 THEN 'BL Préparé (En attente de livraison)'
        ELSE 'Autre'
       END AS etatlib
FROM AS_BONDELIVRAISON_CLIENT bl
LEFT JOIN MAGASINPOINT m ON bl.magasin=m.id
LEFT JOIN vente v ON v.id=bl.idvente
LEFT JOIN client c ON c.ID = bl.IDCLIENT
 ;

 -- SAVONNERIE0126.RAPPROCHEMENT_BF_CLIENT source
SELECT count(*) FROM RAPPROCHEMENT_BF_CLIENT
CREATE OR REPLACE  VIEW RAPPROCHEMENT_BF_CLIENT_2 (ID, PRODUIT, NUMBL, QUANTITE, IDVENTEDETAIL, UNITE, IDBC_FILLE, IDPRODUITLIB, IDVENTE, IDBC, QTELIVREE, QTERESTEALIVRER, QTESORTIE, RESTEASORTIR, PU) AS 
  SELECT abcc.ID,
       abcc.PRODUIT,
       abcc.NUMBL,
       abcc.QUANTITE,
       abcc.IDVENTEDETAIL,
       abcc.UNITE,
       abcc.IDBC_FILLE,
       abcc.IDPRODUITLIB,
       abcc.IDVENTE,
       abcc.IDBC,
       abcc.QTELIVREE,
       abcc.QTERESTEALIVRER,
       nvl(m.qteSortie, 0)                 AS qteSortie,
       nvl(abcc.QUANTITE-nvl(m.qteSortie, 0),0) AS resteASortir,
       nvl(bcf.pu,0)
FROM AS_BONLIVRFILLE_CLIENT_CPL abcc
         LEFT JOIN SORTIEPRODUITparventegrp m ON m.idproduit = abcc.produit and m.IDVENTE = abcc.idvente
         LEFT JOIN MVTSTOCK mv ON mv.idobjet = abcc.numbl
         LEFT JOIN BONDECOMMANDE_CLIENT_FILLE bcf ON abcc.IDBC_FILLE=bcf.id
;