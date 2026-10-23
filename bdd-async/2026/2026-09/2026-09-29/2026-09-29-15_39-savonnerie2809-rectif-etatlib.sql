CREATE OR REPLACE VIEW MVTSTOCKFILLELIB AS 
  SELECT
    m.ID ,
    m.IDMVTSTOCK ,
    m.IDPRODUIT ,
    p.libelle  AS IDPRODUITLIB,
    m.ENTREE ,
    m.SORTIE ,
    m.IDVENTEDETAIL ,
    '' AS IDVENTEDETAILLIB,
    m.IDTRANSFERTDETAIL ,
    '' AS IDTRANSFERTDETAILLIB,
    m2.DATY ,
    m2.IDMAGASIN ,
    m3.VAL AS IDMAGASINLIB,
    m.pu,
    cast(m.pu*m.ENTREE+(m.pu*m.sortie) as number(20,5)) as montant,
    p.LIBELLE,
    m.MVTSRC,
    p.libelle AS libelleexacte,
    m2.DATY AS dateSql,
    m2.IDTYPEMVSTOCK,
    m2.ETAT,
    CASE
        WHEN m2.ETAT = 1 THEN 'CR&Eacute;&Eacute;'
        WHEN m2.ETAT = 11 THEN 'VIS&Eacute;'
        WHEN m2.ETAT = 0 THEN 'ANNUL&Eacute;'
        END AS ETATLIB,
    p.IDDEPARTEMENT,
    p.departementlib,
    p.UNITE AS idunite,
    asu.VAL AS idunitelib,
    m.DESIGNATION,
    m.COMPTELOCALISATION
FROM MVTSTOCKFILLE m
         LEFT JOIN as_ingredient_dep  p ON p.ID = m.IDPRODUIT
         LEFT JOIN MVTSTOCK m2 ON m2.ID = m.IDMVTSTOCK
         LEFT JOIN MAGASIN2 m3 ON m3.ID = m2.IDMAGASIN
         LEFT JOIN AS_UNITE asu ON p.UNITE = asu.ID
WHERE p.actif = 1;
