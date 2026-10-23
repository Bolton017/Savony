


CREATE OR REPLACE  VIEW BC_CLIENT_FILLE_CPL_LIB AS
SELECT
	bcf.ID,
	bcf.PRODUIT,
	bcf.IDBC,
	bcf.QUANTITE,
	bcf.PU,
	bcf.MONTANT,
	bcf.TVA,
	bcf.REMISE,
	bcf.IDDEVISE,
	bcf.UNITE,
	i.LIBELLE AS PRODUITlib,
	i.compte_vente AS compte,
	GREATEST(NVL(bcf.quantite, 0) - NVL(vdbc.qte, 0), 0) AS qtereste
FROM
bondecommande_client_fille bcf
JOIN as_ingredients i ON i.id = bcf.PRODUIT
LEFT JOIN vente_details_qte_grp vdbc ON bcf.id = vdbc.idbcfille;