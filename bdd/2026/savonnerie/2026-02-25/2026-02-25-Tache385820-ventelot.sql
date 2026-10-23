create or replace view ventelot as
select
    v.*,
    l.ID as IDLOT,
    l.IDPRODUIT,
    l.IDEQUIPE,
    l.DATY as DATYLOT,
    l.IDEQUIPELIB,
    l.IDPRODUITLIB,
    l.REMARQUE as REMARQUELOT
from LOTLIB l
left JOIN mvtstockfilleLib mvtf on mvtf.IDLOT = l.id
left join AS_BONDELIVRAISON_CLIENT bl on bl.ID = mvtf.IDOBJET
left join vente v on v.ID = bl.IDVENTE;