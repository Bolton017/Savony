
create or replace view RELEVERDETAILCPL as
select rd."ID",rd."IDMERE",rd."DATY",rd."DATYVALEUR",rd."DESIGNATION",rd."DEBIT",rd."CREDIT" , r.IDCAISSE, cai.COMPTE from ReleverDetail rd join RELEVER r on rd.IDMERE = r.id left join CAISSE cai on cai.id=r.IDCAISSE
    /

create or replace view RELEVERDETAILNR as
SELECT
    rd.ID,
    rd.DESIGNATION,
    rd.DEBIT,
    rd.CREDIT,
    rd.DATYVALEUR,
    r.IDCAISSE, cai.COMPTE
FROM RELEVERDETAIL rd
         JOIN RELEVER r ON r.ID = rd.IDMERE
         left join CAISSE cai on cai.id=r.IDCAISSE
WHERE
    r.ETAT >= 11
  AND rd.ID NOT IN (
    SELECT IDRELEVERDETAIL
    FROM RAPPROCHEMENTBC
    WHERE IDRELEVERDETAIL IS NOT NULL
)
    /

create or replace view SOUSECRITURENR as
SELECT
    cse.ID,
    cse.LIBELLEPIECE,
    cse.DEBIT,
    cse.CREDIT,
    cse.DATY,
    cai.ID as IDCAISSE,
    cse.COMPTE
FROM COMPTA_SOUS_ECRITURE cse
         LEFT JOIN COMPTA_ECRITURE ce ON ce.ID = cse.idmere
         LEFT join CAISSE cai on cai.COMPTE=cse.COMPTE
WHERE
    ce.ETAT >= 11
  AND cse.ID NOT IN (
    SELECT idSousEcriture
    FROM RAPPROCHEMENTBC
    WHERE idSousEcriture IS NOT NULL
)
  AND ce.JOURNAL = 'COMP000036' AND cse.COMPTE like '5%'
    /


alter table RAPPROCHEMENTBC add idmere VARCHAR(250);

CREATE TABLE RAPPROCHEMENTBCMERE
(
    ID                      VARCHAR(250) PRIMARY KEY,
    idBanque             VARCHAR(250),
    valeur         NUMBER(30,2),
    DATY                    DATE,
    etat                   NUMBER
);

CREATE SEQUENCE seqRapprochementBCMERE;

CREATE OR REPLACE FUNCTION getSeqRapprochementBCMERE
RETURN NUMBER
IS
    retour NUMBER;
BEGIN
SELECT seqRapprochementBCMERE.NEXTVAL
INTO retour
FROM DUAL;

RETURN retour;
END;


create or replace view RAPPROCHEMENTBCMERELIB as
select
    rp.*,
    ca.VAL as idbanquelib,
    CASE
        WHEN rp.ETAT = 1 THEN 'CREEE'
        WHEN rp.ETAT = 11 THEN 'VISEE'
        WHEN rp.ETAT = 0 THEN 'ANNULEE'
        END
           AS ETATLIB
from RAPPROCHEMENTBCMERE rp join CAISSE ca on ca.id=rp.idBanque;



create or replace view SOUSECRITURENR as
SELECT
    cse.ID,
    cse.LIBELLEPIECE,
    cse.DEBIT,
    cse.CREDIT,
    cse.DATY,
    cai.ID as IDCAISSE,
    cse.COMPTE
FROM COMPTA_SOUS_ECRITURE cse
         LEFT JOIN COMPTA_ECRITURE ce ON ce.ID = cse.idmere
         LEFT join CAISSE cai on cai.COMPTE=cse.COMPTE
WHERE
    ce.ETAT >= 11
  AND cse.ID NOT IN (
    SELECT rpf.idSousEcriture
    FROM RAPPROCHEMENTBC rpf join RAPPROCHEMENTBCMERE rp on rpf.idmere=rp.id
    WHERE rpf.idSousEcriture IS NOT NULL AND rp.ETAT>=11
)
  AND ce.JOURNAL = 'COMP000036' AND cse.COMPTE like '5%'
    /

create or replace view RELEVERDETAILNR as
SELECT
    rd.ID,
    rd.DESIGNATION,
    rd.DEBIT,
    rd.CREDIT,
    rd.DATYVALEUR,
    r.IDCAISSE, cai.COMPTE
FROM RELEVERDETAIL rd
         JOIN RELEVER r ON r.ID = rd.IDMERE
         left join CAISSE cai on cai.id=r.IDCAISSE
WHERE
    r.ETAT >= 11
  AND rd.ID NOT IN (
    SELECT rpf.IDRELEVERDETAIL
    FROM RAPPROCHEMENTBC rpf join RAPPROCHEMENTBCMERE rp on rpf.idmere=rp.id
    WHERE rpf.IDRELEVERDETAIL IS NOT NULL AND rp.ETAT>=11
)
    /