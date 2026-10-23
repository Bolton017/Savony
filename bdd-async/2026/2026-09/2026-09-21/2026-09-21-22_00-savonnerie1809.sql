CREATE OR REPLACE  VIEW COMPTA_LETTRAGE_LIB (ID, LETTRE, DATE_LETTRAGE, COMPTE, MONTANT, REMARQUE, JOURNAL) AS 
  SELECT cl.id, cl.LETTRE, cl.DATE_LETTRAGE, cc.COMPTE, cl.montant, cl.remarque, '-' AS journal
FROM compta_lettrage cl
          JOIN COMPTA_SOUS_ECRITURE cse ON cse.LETTRAGE = cl.ID
          JOIN COMPTA_COMPTE cc ON cc.COMPTE = cse.compte
          --JOIN COMPTA_JOURNAL_VIEW jrn ON cse.JOURNAL = jrn.ID
           GROUP BY cl.id, cl.LETTRE, cl.DATE_LETTRAGE, cc.COMPTE, cl.montant, cl.remarque ;
 ;