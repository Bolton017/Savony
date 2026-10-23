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
    cse.ID NOT IN (
        SELECT rpf.idSousEcriture
        FROM RAPPROCHEMENTBC rpf join RAPPROCHEMENTBCMERE rp on rpf.idmere=rp.id
        WHERE rpf.idSousEcriture IS NOT NULL AND rp.ETAT>=11
    )
  AND ce.JOURNAL = 'COMP000036' AND cse.COMPTE like '5%';

create or replace view RELEVERDETAILNRMVT as
SELECT
    ID,
    DESIGNATION,
    CAST(DEBIT AS NUMBER(32,2)) AS DEBIT,
    CAST(CREDIT AS NUMBER(32,2)) AS CREDIT,
    DATYVALEUR,
    IDCAISSE,
    COMPTE,
    CASE
        WHEN DEBIT > 0 THEN 1
        WHEN CREDIT > 0 THEN 2
        ELSE 0
        END AS MOUVEMENT
FROM RELEVERDETAILNR;

