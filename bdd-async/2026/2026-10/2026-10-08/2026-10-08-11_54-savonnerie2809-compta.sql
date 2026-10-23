

----- Safidy

CREATE OR REPLACE  VIEW COMPTA_ECRITURE_FICHE_V2 ("ID", "DATY", "DATECOMPTABLE", "EXERCICE", "DESIGNATION", "REMARQUE", "ETAT", "HORSEXERCICE", "JOURNAL", "OD", "ORIGINE", "CREDIT", "DEBIT", "IDUSER", "PERIODE", "TRIMESTRE", "ANNEE", "IDOBJET", "LETTRAGE", "LIEN", "DATESAISIE", "DATEMODIF", "IDMODIFICATEUR", "IDMODIFICATEURLIB", "JOURNALLIB", "JOURNALDESCE","TIERSLIB","PIECE","REFERENCE","SOURCE") AS 
  SELECT
    cef.ID,
    cef.DATY,
    cef.DATECOMPTABLE,
    cef.EXERCICE,
    cef.DESIGNATION,
    cef.REMARQUE,
    cef.ETAT,
    cef.HORSEXERCICE,
    cef.JOURNAL,
    cef.OD,
    cef.ORIGINE,
    cef.CREDIT,
    cef.DEBIT,
    cef.IDUSER,
    cef.PERIODE,
    cef.TRIMESTRE,
    cef.ANNEE,
    cef.IDOBJET,
    cef.LETTRAGE,
    cef.LIEN,
    cef.DATESAISIE,
    cef.DATEMODIF,
    cef.IDMODIFICATEUR,
    cef.IDMODIFICATEURLIB,
    cj.VAL AS JOURNALLIB,
    cj.DESCE AS JOURNALDESCE,
    ce.tierslib,
    ce.piece,
    ce.reference,
    ce.source
FROM COMPTA_ECRITURE_FICHE cef
         LEFT JOIN COMPTA_JOURNAL cj ON cj.ID = cef.JOURNAL
         LEFT JOIN compta_ecriture_lib ce ON ce.id=cef.id;
		 
		 
--Mamison 
CREATE
OR REPLACE VIEW LIAISONCODELIB
AS
SELECT ls.id,
       ls.idCodeImpot,
       ls.idCompte,
       ls.FORMULE,
       CASE
           WHEN ls.TAXABLE IN ('1', 'oui') THEN 'Oui'
           WHEN ls.TAXABLE IN ('0', 'non') THEN 'Non'
           ELSE NULL
           END    AS TAXABLE,
       i.rubrique AS IDCODEIMPOTLIB
FROM LiaisonCodeImpot ls
         LEFT JOIN imprimedeclaration i ON
    ls.idcodeimpot = i.id;
 