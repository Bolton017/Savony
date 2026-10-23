create or replace view ReleverLib as
select 
    r.* ,
    c.val as idcaisselib
from Relever r
join caisse c on c.id = r.idcaisse;