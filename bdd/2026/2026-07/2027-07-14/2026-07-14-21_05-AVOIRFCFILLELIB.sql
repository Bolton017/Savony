create or replace view AVOIRFCFILLELIB as
SELECT
    AF.ID,
    AF.IDAVOIRFC,
    AF.IDPRODUIT,
    AF.IDORIGINE,
    AF.QTE,
    AF.PU,
    AF.REMISE,
    AF.TVA,
    AF.PUACHAT,
    AF.PUVENTE,
    AF.IDDEVISE,
    AF.TAUXDECHANGE,
    AF.DESIGNATION,
    AF.IDVENTEDETAILS,
    cast(((AF.pu - (AF.pu * AF.remise / 100)) * AF.qte) as number(30,2))as montantht,
    cast(((AF.pu - (AF.pu * AF.remise / 100)) * AF.qte) +
         ((((AF.pu * AF.qte) - (AF.pu * AF.remise / 100) * qte)) * AF.tva /100) as number(30, 2)) AS montantttc,
    cast((AF.pu * AF.remise / 100) * qte as number(30,2)) as montantremise,
    cast(((((AF.pu * qte) - (AF.pu * AF.remise / 100) * qte) ) * AF.tva / 100) as number(30,2)) as montanttva,
    P.libelle AS IDPRODUITLIB
FROM AVOIRFCFILLE AF
         LEFT JOIN as_ingredients P ON P.id = AF.IDPRODUIT;