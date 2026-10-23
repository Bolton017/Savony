
--ajout etatlib
CREATE OR REPLACE VIEW DECLARATIONTVALIB AS
SELECT de.id,
       de.designation,
       de.datyDebut,
       de.datyFin,
       de.etat,
       CASE
           WHEN de.etat = 1 THEN 'CR&Eacute;&Eacute;'
           WHEN de.etat = 11 THEN 'VALID&Eacute;'
           ELSE 'Inconnu'
           END                              AS etatLib,
       nvl(mv.DEBIT, nvl(fd.MONTANTTTC, 0)) AS montantpayer,
       CASE
           WHEN mv.IDORIGINE IS NULL THEN CASE
                                              WHEN fd.IDBC = 'CREDIT' THEN 'Reporté'
                                              ELSE 'Non payé'
               END
           ELSE 'Payé'
           END                              AS payementLib
FROM DeclarationTVA de
         LEFT JOIN FACTUREDECLARATIONCPL fd ON
    de.id = fd.IDOBJET

         LEFT JOIN mouvementcaisse mv ON
    mv.IDORIGINE = fd.id;
 