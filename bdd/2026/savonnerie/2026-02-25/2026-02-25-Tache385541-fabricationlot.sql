create or replace view MVTSTOCKFILLELIB as
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
    m.IDLOT,
    m2.IDOBJET
FROM MVTSTOCKFILLE m
     LEFT JOIN AS_INGREDIENTS  p ON p.ID = m.IDPRODUIT
     LEFT JOIN MVTSTOCK m2 ON m2.ID = m.IDMVTSTOCK
     LEFT JOIN MAGASIN2 m3 ON m3.ID = m2.IDMAGASIN;

create or replace view fabricationLot as
select
    fab.*,
    l.ID as IDLOT,
    l.IDPRODUIT,
    l.IDEQUIPE,
    l.DATY as DATYLOT,
    l.IDEQUIPELIB,
    l.IDPRODUITLIB,
    l.REMARQUE as REMARQUELOT
from LOTLIB l
left JOIN mvtstockfilleLib mvtf on mvtf.IDLOT = l.id
left join FABRICATIONCPL fab on fab.ID = mvtf.IDOBJET;