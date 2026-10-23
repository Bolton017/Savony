create or replace view COMPTASOUSECRITURECND as
select
    ' ' as ID,
    ' ' as NUMERO,
    ' ' as COMPTE,
    ' ' as JOURNAL,
    ' ' as IDJOURNAL,
    ' ' as ECRITURE,
    sysdate as DATY,
    0 as CREDIT,
    0 as DEBIT,
    sysdate as DATECOMPTABLE,
    0 as EXERCICE,
    ' ' as REMARQUE,
    11 as ETAT,
    ' ' as IDMERE,
    1 as HORSEXERCICE,
    ' ' as OD,
    ' ' as ORIGINE,
    ' ' as TIERS,
    ' ' as LIBELLEPIECE,
    ' ' as COMPTE_AUX,
    ' ' as RAISONSOCIAL,
    ' ' as FOLIO,
    ' ' as LETTRAGE,
    ' ' as ANALYTIQUE
from dual
union
SELECT cse.ID,
       cse.NUMERO,
       cse.COMPTE,
       cse.JOURNAL,
       cse.IDJOURNAL,
       cse.ECRITURE,
       cse.DATY,
       cse.CREDIT,
       cse.DEBIT,
       cse.DATECOMPTABLE,
       cse.EXERCICE,
       cse.REMARQUE,
       cse.ETAT,
       cse.IDMERE,
       cse.HORSEXERCICE,
       cse.OD,
       cse.ORIGINE,
       cse.TIERS,
       cse.LIBELLEPIECE,
       cse.COMPTE_AUX,
       cse.RAISONSOCIAL,
       cse.FOLIO,
       cse.LETTRAGE,
       cse.ANALYTIQUE
FROM COMPTA_SOUSECRITURE_LIB cse
         LEFT JOIN SOUSECRITUREDECLARER csed
                   ON cse.id = csed.idSousEcriture
WHERE csed.idSousEcriture IS NULL
  AND cse.COMPTE LIKE '4457%';

create or replace view COMPTASOUSECRITUREDND as
SELECT ' ' as ID,
       ' ' as NUMERO,
       ' ' as COMPTE,
       ' ' as JOURNAL,
       ' ' as IDJOURNAL,
       ' ' as ECRITURE,
       sysdate as DATY,
       0 as CREDIT,
       0 as DEBIT,
       sysdate as DATECOMPTABLE,
       0 as EXERCICE,
       ' ' as REMARQUE,
       11 as ETAT,
       ' ' as IDMERE,
       1 as HORSEXERCICE,
       ' ' as OD,
       ' ' as ORIGINE,
       ' ' as TIERS,
       ' ' as LIBELLEPIECE,
       ' ' as COMPTE_AUX,
       ' ' as RAISONSOCIAL,
       ' ' as FOLIO,
       ' ' as LETTRAGE,
       ' ' as ANALYTIQUE
FROM dual
Union
SELECT cse.ID,
       cse.NUMERO,
       cse.COMPTE,
       cse.JOURNAL,
       cse.IDJOURNAL,
       cse.ECRITURE,
       cse.DATY,
       cse.CREDIT,
       cse.DEBIT,
       cse.DATECOMPTABLE,
       cse.EXERCICE,
       cse.REMARQUE,
       cse.ETAT,
       cse.IDMERE,
       cse.HORSEXERCICE,
       cse.OD,
       cse.ORIGINE,
       cse.TIERS,
       cse.LIBELLEPIECE,
       cse.COMPTE_AUX,
       cse.RAISONSOCIAL,
       cse.FOLIO,
       cse.LETTRAGE,
       cse.ANALYTIQUE
FROM COMPTA_SOUSECRITURE_LIB cse
         LEFT JOIN SOUSECRITUREDECLARER csed
                   ON cse.id = csed.idSousEcriture
WHERE csed.idSousEcriture IS NULL
  AND cse.COMPTE LIKE '4456%';

  CREATE OR REPLACE  VIEW LIAISONCODELIB ("ID", "IDCODEIMPOT", "IDCOMPTE", "FORMULE", "TAXABLE","IDCODEIMPOTLIB") AS
  SELECT
    ls.id,
    ls.idCodeImpot,
    ls.idCompte,
    ls.FORMULE,
    CASE
        WHEN ls.TAXABLE = 1 THEN 'Oui'
        WHEN ls.TAXABLE = 0 THEN 'Non'
        ELSE NULL
        END AS TAXABLE,
    i.rubrique AS IDCODEIMPOTLIB
FROM LiaisonCodeImpot ls
LEFT JOIN imprimedeclaration i ON
    ls.idcodeimpot = i.id;

INSERT INTO COMPTA_COMPTE
(ID, COMPTE, LIBELLE, TYPECOMPTE, CLASSY, ANALYTIQUE_OBLI, IDJOURNAL, CODEIMPOT)
VALUES('COMCSOC0003914P', '44551', 'TVA à décaisser', '1', '4', NULL, 'COMP000035', NULL);

INSERT INTO COMPTA_COMPTE
(ID, COMPTE, LIBELLE, TYPECOMPTE, CLASSY, ANALYTIQUE_OBLI, IDJOURNAL, CODEIMPOT)
VALUES('COMCSOC0003914CR', '44567', 'Crédit de TVA à reporter', '1', '4', NULL, 'COMP000035', NULL);