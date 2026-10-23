CREATE OR REPLACE VIEW INVENTAIREFILLELIB AS 
  SELECT
    i.ID ,
    i.IDINVENTAIRE ,
    i.IDPRODUIT ,
    p.libelle AS IDPRODUITLIB,
    i.EXPLICATION ,
    i.QUANTITETHEORIQUE ,
    i.QUANTITE,
    p.LIBELLEEXTACTE,
    i.pu,
    cast((i.QUANTITE - i.QUANTITETHEORIQUE) as decimal(30,2)) AS ecart,
    p.PARFUMS,
    i.compteLocalisation AS compteLocalisation,
    l.LIBELLE AS compteLocalisationLib
FROM INVENTAIREFILLE i
         LEFT JOIN AS_INGREDIENTS  p ON p.ID  = i.IDPRODUIT
		LEFT JOIN LOCALISATION l ON i.compteLocalisation = l.id;