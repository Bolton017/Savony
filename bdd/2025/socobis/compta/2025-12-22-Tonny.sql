create or replace view automatiqueForm as
select
    '' as id,
    '' as idCaisseBanque,
    null as dateMin,
    null as dateMax
from dual;

create or replace view ResultatRapprochement as
select
    '' as id,
    '' as idSousEcriture,
    '' as idReleverDetail,
    0 as debit,
    0 as credit,
    null as daty,
    '' as designationSousEcriture,
    '' as designationReleveDetail
from dual;

create or replace view caissebanque as
select id, val, desce from CAISSE where IDTYPECAISSE = 'TCA001';

create or replace view ReleverDetailCpl as
select rd.* , r.IDCAISSE from ReleverDetail rd join RELEVER r on rd.IDMERE = r.id;


create OR REPLACE view SOUSECRITURENR as
SELECT
    cse.ID,
    cse.LIBELLEPIECE,
    cse.DEBIT,
    cse.CREDIT,
    cse.DATY,
    mc.IDCAISSE
FROM COMPTA_SOUS_ECRITURE cse
         JOIN COMPTA_ECRITURE ce ON ce.ID = cse.idmere
            join MOUVEMENTCAISSE mc on ce.IDOBJET = mc.ID
WHERE
    ce.ETAT >= 11
  AND cse.ID NOT IN (
    SELECT idSousEcriture
    FROM RAPPROCHEMENTBC
    WHERE idSousEcriture IS NOT NULL
)
  AND ce.JOURNAL = 'COMP000036'
/

create or replace view RELEVERLIB as
select
    r."ID",r."DATY",r."IDCAISSE",r."ETAT" ,
    c.val as idcaisselib,
    c.id as idCaisse
from Relever r
         join caisse c on c.id = r.idcaisse
/

