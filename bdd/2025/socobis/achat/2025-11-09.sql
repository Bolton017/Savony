CREATE OR REPLACE VIEW DMDACHATLIB AS
SELECT
da.id,
da.daty,
da.fournisseur,
f.nom AS fournisseurlib,
da.remarque
FROM DMDACHAT da
LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur;