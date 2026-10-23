create view ReleverDetailOrder as
select * from ReleverDetail ORDER BY TO_NUMBER(REGEXP_REPLACE(id, '[^0-9]', '')) ASC;

create or replace view RELEVERLIB as
select
    r."ID",r."DATY",r."IDCAISSE",r."ETAT" ,
    c.val as idcaisselib,
    r.DATYDEBUT,
    r.DATYFIN,
    CASE
        WHEN r.ETAT = 1 THEN 'CREEE'
        WHEN r.ETAT = 11 THEN 'VISEE'
        WHEN r.ETAT = 0 THEN 'ANNULEE'
        END
          AS ETATLIB
from Relever r
         join caisse c on c.id = r.idcaisse;

create or replace view RapprochementBCETAT as
select rp.id,rp.IDSOUSECRITURE,rp.IDRELEVERDETAIL,rp.VALEURSOUSECRITURE,rp.VALEURRELEVERDETAIL,rp.DATY,rpm.ETAT,rp.IDMERE from RapprochementBC rp join RAPPROCHEMENTBCMERE rpm on rp.IDMERE=rpm.ID;
