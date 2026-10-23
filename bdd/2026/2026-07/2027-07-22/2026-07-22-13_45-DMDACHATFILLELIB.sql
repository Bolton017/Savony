
create or replace view DMDACHATFILLELIB as
SELECT
    df.ID,
    df.IDMERE,
    df.IDPRODUIT,
    df.DESIGNATION,
    df.QUANTITE,
    df.PU,
    df.TVA,
    df.QTESTOCK,
    df.UNITE,
    df.REMARQUE,
    cast(NVL(df.PU, 0) * NVL(df.QUANTITE, 0) as Number(30, 2)) AS montanttotal
FROM DMDACHATFILLE df;
