create view SOUSECRITURER as
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
    cse.ID IN (
        SELECT rpf.idSousEcriture
        FROM RAPPROCHEMENTBC rpf join RAPPROCHEMENTBCMERE rp on rpf.idmere=rp.id
        WHERE rpf.idSousEcriture IS NOT NULL AND rp.ETAT>=11
    )
  AND ce.JOURNAL = 'COMP000036' AND cse.COMPTE like '5%';

create view SOUSECRITURERMVT as
SELECT
    ID,
    LIBELLEPIECE,
    DEBIT,
    CREDIT,
    DATY,
    IDCAISSE,
    COMPTE,
    CASE
        WHEN DEBIT > 0 THEN 1
        WHEN CREDIT > 0 THEN 2
        ELSE 0
        END AS MOUVEMENT
FROM SOUSECRITURER;


create view RELEVERDETAILR as
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
  AND rd.ID IN (
    SELECT rpf.IDRELEVERDETAIL
    FROM RAPPROCHEMENTBC rpf join RAPPROCHEMENTBCMERE rp on rpf.idmere=rp.id
    WHERE rpf.IDRELEVERDETAIL IS NOT NULL AND rp.ETAT>=11
);

create view RELEVERDETAILRMVT as
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
FROM RELEVERDETAILR;