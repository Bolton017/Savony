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
         join caisse c on c.id = r.idcaisse
    /

create view RELEVERDETAILORDER as
select "ID","IDMERE","DATY","DATYVALEUR","DESIGNATION","DEBIT","CREDIT","SOLDE" from ReleverDetail ORDER BY TO_NUMBER(REGEXP_REPLACE(id, '[^0-9]', '')) ASC
    /

create or replace view ECRITURE_IMPOT as
select
    se.*,ce.daty as datymere, cc.COMPTE as codeimpot
from COMPTA_SOUS_ECRITURE se
         join COMPTA_ECRITURE ce on ce.id=se.IDMERE
         join COMPTA_COMPTE cc on cc.COMPTE=se.COMPTE
where ce.ETAT=11;

create or replace view RELEVERDETAILCPL as
select rd."ID",rd."IDMERE",rd."DATY",rd."DATYVALEUR",rd."DESIGNATION",rd."DEBIT",rd."CREDIT" , r.IDCAISSE, cai.COMPTE from ReleverDetail rd join RELEVER r on rd.IDMERE = r.id left join CAISSE cai on cai.id=r.IDCAISSE
    /

