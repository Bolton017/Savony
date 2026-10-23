create view RESULTATCALCULBESOINSCPL as
select
    r.IDMERE,
    r.IDINGREDIENTS,
    r.LIBELLE,
    r.UNITE,
    r.PU,
    SUM(r.QTE) as qte,
    mf.RESTE as qteStock,
    mf.RESTE - SUM(r.qte) as qteachete ,
    SUM(r.MONTANT) as montant,
    mf.MONTANTRESTE as montantstock,
    mf.MONTANTRESTE - SUM(r.MONTANT) as montantachete
from RESULTATCALCULBESOINS r
         left join V_ETATSTOCK_ING mf on mf.id = r.IDINGREDIENTS AND mf.IDMAGASIN = r.IDMAGASIN
group by
    r.IDMERE,
    r.IDINGREDIENTS,
    r.LIBELLE,
    r.UNITE,
    r.PU,
    mf.RESTE,
    mf.MONTANTRESTE
;