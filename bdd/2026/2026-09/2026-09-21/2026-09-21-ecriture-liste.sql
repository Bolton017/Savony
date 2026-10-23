

-- ---- COMPTA_ECRITURE_LIB ----
CREATE OR REPLACE VIEW COMPTA_ECRITURE_LIB AS
SELECT ce.ID,
       ce.DATY,
       ce.DATECOMPTABLE,
       ce.EXERCICE,
       ce.DESIGNATION,
       ce.REMARQUE,
       ce.ETAT,
       ce.HORSEXERCICE,
       ce.JOURNAL,
       ce.OD,
       ce.ORIGINE,
       ce.CREDIT,
       ce.DEBIT,
       ce.IDUSER,
       ce.PERIODE,
       ce.TRIMESTRE,
       ce.ANNEE,
       COALESCE(ce.IDOBJET, '-')                                     AS IDOBJET,
       CAST(cm.montant AS NUMBER (38, 2))                            AS montant,
       cj.desce                                                      AS JOURNALLIB,
       cj.val                                                        AS JOURNALCODE,
       CASE
           WHEN ce.ETAT = 1 THEN 'Cree'
           WHEN ce.ETAT = 11 THEN 'Valide'
           ELSE 'Autre'
           END                                                       AS etatlib,
       COALESCE(fc.IDFOURNISSEURLIB, vc.idClientlib, mvc.tiers, '-') AS tierslib,
       CASE
           WHEN ce.ORIGINE = 'AVR' THEN '-'
           WHEN ce.ORIGINE = 'MTC' THEN COALESCE(vc_mtc.NUMEROFACTURE, fc_mtc.NUMERO, '-')
           WHEN ce.ORIGINE = 'MVT' THEN '-'
           WHEN ce.ORIGINE = 'VNT' THEN vc.NUMEROFACTURE
           WHEN ce.ORIGINE = 'FCF' THEN fc.NUMERO
           ELSE '-'
           END                                                       AS piece
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
         LEFT JOIN FACTUREFOURNISSEURCPL fc ON fc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc ON vc.id = ce.idobjet
         LEFT JOIN MOUVEMENTCAISSECPL mvc ON mvc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc_mtc ON vc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN FACTUREFOURNISSEURCPL fc_mtc ON fc_mtc.ID = mvc.IDORIGINE
ORDER BY ce.DATY DESC
 
;

-- ---- COMPTA_ECRITURE_LIB_VENTE ----
CREATE OR REPLACE VIEW COMPTA_ECRITURE_LIB_VENTE AS
SELECT ce.ID,
       ce.DATY,
       ce.DATECOMPTABLE,
       ce.EXERCICE,
       ce.DESIGNATION,
       ce.REMARQUE,
       ce.ETAT,
       ce.HORSEXERCICE,
       ce.JOURNAL,
       ce.OD,
       ce.ORIGINE,
       ce.CREDIT,
       ce.DEBIT,
       ce.IDUSER,
       ce.PERIODE,
       ce.TRIMESTRE,
       ce.ANNEE,
       COALESCE(ce.IDOBJET, '-')                                     AS IDOBJET,
       CAST(cm.montant AS NUMBER (38, 2))                            AS montant,
       cj.desce                                                      AS JOURNALLIB,
       cj.val                                                        AS JOURNALCODE,
       CASE
           WHEN ce.ETAT = 1 THEN 'Cree'
           WHEN ce.ETAT = 11 THEN 'Valide'
           ELSE 'Autre'
           END                                                       AS etatlib,
       COALESCE(fc.IDFOURNISSEURLIB, vc.idClientlib, mvc.tiers, '-') AS tierslib,
       CASE
           WHEN ce.ORIGINE = 'AVR' THEN '-'
           WHEN ce.ORIGINE = 'MTC' THEN COALESCE(vc_mtc.NUMEROFACTURE, fc_mtc.NUMERO, '')
           WHEN ce.ORIGINE = 'MVT' THEN '-'
           WHEN ce.ORIGINE = 'VNT' THEN vc.NUMEROFACTURE
           WHEN ce.ORIGINE = 'FCF' THEN fc.NUMERO
           ELSE '-'
           END                                                       AS piece
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
         LEFT JOIN FACTUREFOURNISSEURCPL fc ON fc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc ON vc.id = ce.idobjet
         LEFT JOIN MOUVEMENTCAISSECPL mvc ON mvc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc_mtc ON vc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN FACTUREFOURNISSEURCPL fc_mtc ON fc_mtc.ID = mvc.IDORIGINE
WHERE ce.IDOBJET LIKE '%VNT%'
ORDER BY ce.DATY DESC
 
;

-- ---- COMPTA_ECRITURE_LIB_STOCK ----
CREATE OR REPLACE VIEW COMPTA_ECRITURE_LIB_STOCK AS
SELECT ce.ID,
       ce.DATY,
       ce.DATECOMPTABLE,
       ce.EXERCICE,
       ce.DESIGNATION,
       ce.REMARQUE,
       ce.ETAT,
       ce.HORSEXERCICE,
       ce.JOURNAL,
       ce.OD,
       ce.ORIGINE,
       ce.CREDIT,
       ce.DEBIT,
       ce.IDUSER,
       ce.PERIODE,
       ce.TRIMESTRE,
       ce.ANNEE,
       COALESCE(ce.IDOBJET, '-')                                     AS IDOBJET,
       CAST(cm.montant AS NUMBER (38, 2))                            AS montant,
       cj.desce                                                      AS JOURNALLIB,
       cj.val                                                        AS JOURNALCODE,
       CASE
           WHEN ce.ETAT = 1 THEN 'Cree'
           WHEN ce.ETAT = 11 THEN 'Valide'
           ELSE 'Autre'
           END                                                       AS etatlib,
       COALESCE(fc.IDFOURNISSEURLIB, vc.idClientlib, mvc.tiers, '-') AS tierslib,
       CASE
           WHEN ce.ORIGINE = 'AVR' THEN '-'
           WHEN ce.ORIGINE = 'MTC' THEN COALESCE(vc_mtc.NUMEROFACTURE, fc_mtc.NUMERO, '-')
           WHEN ce.ORIGINE = 'MVT' THEN '-'
           WHEN ce.ORIGINE = 'VNT' THEN vc.NUMEROFACTURE
           WHEN ce.ORIGINE = 'FCF' THEN fc.NUMERO
           ELSE '-'
           END                                                       AS piece
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
         LEFT JOIN FACTUREFOURNISSEURCPL fc ON fc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc ON vc.id = ce.idobjet
         LEFT JOIN MOUVEMENTCAISSECPL mvc ON mvc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc_mtc ON vc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN FACTUREFOURNISSEURCPL fc_mtc ON fc_mtc.ID = mvc.IDORIGINE
WHERE ce.IDOBJET LIKE '%MVTST%'
   OR ce.IDOBJET LIKE '%MTC%'
ORDER BY ce.DATY DESC
 
;

-- ---- COMPTA_ECRITURE_LIB_AVOIRFC ----
CREATE OR REPLACE VIEW COMPTA_ECRITURE_LIB_AVOIRFC AS
SELECT ce.ID,
       ce.DATY,
       ce.DATECOMPTABLE,
       ce.EXERCICE,
       ce.DESIGNATION,
       ce.REMARQUE,
       ce.ETAT,
       ce.HORSEXERCICE,
       ce.JOURNAL,
       ce.OD,
       ce.ORIGINE,
       ce.CREDIT,
       ce.DEBIT,
       ce.IDUSER,
       ce.PERIODE,
       ce.TRIMESTRE,
       ce.ANNEE,
       COALESCE(ce.IDOBJET, '-')                                     AS IDOBJET,
       CAST(cm.montant AS NUMBER (38, 2))                            AS montant,
       cj.desce                                                      AS JOURNALLIB,
       cj.val                                                        AS JOURNALCODE,
       CASE
           WHEN ce.ETAT = 1 THEN 'Cree'
           WHEN ce.ETAT = 11 THEN 'Valide'
           ELSE 'Autre'
           END                                                       AS etatlib,
       COALESCE(fc.IDFOURNISSEURLIB, vc.idClientlib, mvc.tiers, '-') AS tierslib,
       CASE
           WHEN ce.ORIGINE = 'AVR' THEN '-'
           WHEN ce.ORIGINE = 'MTC' THEN COALESCE(vc_mtc.NUMEROFACTURE, fc_mtc.NUMERO, '-')
           WHEN ce.ORIGINE = 'MVT' THEN '-'
           WHEN ce.ORIGINE = 'VNT' THEN vc.NUMEROFACTURE
           WHEN ce.ORIGINE = 'FCF' THEN fc.NUMERO
           ELSE '-'
           END                                                       AS piece
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
         LEFT JOIN FACTUREFOURNISSEURCPL fc ON fc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc ON vc.id = ce.idobjet
         LEFT JOIN MOUVEMENTCAISSECPL mvc ON mvc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc_mtc ON vc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN FACTUREFOURNISSEURCPL fc_mtc ON fc_mtc.ID = mvc.IDORIGINE
WHERE ce.IDOBJET LIKE '%AVRFC%'
ORDER BY ce.DATY DESC
 
;

-- ---- COMPTA_ECRITURE_LIB_ACHAT ----
CREATE OR REPLACE VIEW COMPTA_ECRITURE_LIB_ACHAT AS
SELECT ce.ID,
       ce.DATY,
       ce.DATECOMPTABLE,
       ce.EXERCICE,
       ce.DESIGNATION,
       ce.REMARQUE,
       ce.ETAT,
       ce.HORSEXERCICE,
       ce.JOURNAL,
       ce.OD,
       ce.ORIGINE,
       ce.CREDIT,
       ce.DEBIT,
       ce.IDUSER,
       ce.PERIODE,
       ce.TRIMESTRE,
       ce.ANNEE,
       COALESCE(ce.IDOBJET, '-')                                     AS IDOBJET,
       CAST(cm.montant AS NUMBER (38, 2))                            AS montant,
       cj.desce                                                      AS JOURNALLIB,
       cj.val                                                        AS JOURNALCODE,
       CASE
           WHEN ce.ETAT = 1 THEN 'Cree'
           WHEN ce.ETAT = 11 THEN 'Valide'
           ELSE 'Autre'
           END                                                       AS etatlib,
       COALESCE(fc.IDFOURNISSEURLIB, vc.idClientlib, mvc.tiers, '-') AS tierslib,
       CASE
           WHEN ce.ORIGINE = 'AVR' THEN '-'
           WHEN ce.ORIGINE = 'MTC' THEN COALESCE(vc_mtc.NUMEROFACTURE, fc_mtc.NUMERO)
           WHEN ce.ORIGINE = 'MVT' THEN '-'
           WHEN ce.ORIGINE = 'VNT' THEN vc.NUMEROFACTURE
           WHEN ce.ORIGINE = 'FCF' THEN fc.NUMERO
           ELSE '-'
           END                                                       AS piece
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
         LEFT JOIN FACTUREFOURNISSEURCPL fc ON fc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc ON vc.id = ce.idobjet
         LEFT JOIN MOUVEMENTCAISSECPL mvc ON mvc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc_mtc ON vc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN FACTUREFOURNISSEURCPL fc_mtc ON fc_mtc.ID = mvc.IDORIGINE
WHERE ce.IDOBJET LIKE '%FCF%'
ORDER BY ce.DATY DESC
 
;

-- ---- COMPTA_ECRITURE_LIB_MANUELLE ----
CREATE OR REPLACE VIEW COMPTA_ECRITURE_LIB_MANUELLE AS
SELECT ce.ID,
       ce.DATY,
       ce.DATECOMPTABLE,
       ce.EXERCICE,
       ce.DESIGNATION,
       ce.REMARQUE,
       ce.ETAT,
       ce.HORSEXERCICE,
       ce.JOURNAL,
       ce.OD,
       ce.ORIGINE,
       ce.CREDIT,
       ce.DEBIT,
       ce.IDUSER,
       ce.PERIODE,
       ce.TRIMESTRE,
       ce.ANNEE,
       COALESCE(ce.IDOBJET, '-')                                     AS IDOBJET,
       CAST(cm.montant AS NUMBER (38, 2))                            AS montant,
       cj.desce                                                      AS JOURNALLIB,
       cj.val                                                        AS JOURNALCODE,
       CASE
           WHEN ce.ETAT = 1 THEN 'Cree'
           WHEN ce.ETAT = 11 THEN 'Valide'
           ELSE 'Autre'
           END                                                       AS etatlib,
       COALESCE(fc.IDFOURNISSEURLIB, vc.idClientlib, mvc.tiers, '-') AS tierslib,
       CASE
           WHEN ce.ORIGINE = 'AVR' THEN '-'
           WHEN ce.ORIGINE = 'MTC' THEN COALESCE(vc_mtc.NUMEROFACTURE, fc_mtc.NUMERO)
           WHEN ce.ORIGINE = 'MVT' THEN '-'
           WHEN ce.ORIGINE = 'VNT' THEN vc.NUMEROFACTURE
           WHEN ce.ORIGINE = 'FCF' THEN fc.NUMERO
           ELSE '-'
           END                                                       AS piece
FROM COMPTA_ECRITURE ce
         JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
         LEFT JOIN FACTUREFOURNISSEURCPL fc ON fc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc ON vc.id = ce.idobjet
         LEFT JOIN MOUVEMENTCAISSECPL mvc ON mvc.id = ce.idobjet
         LEFT JOIN (SELECT v.id, v.NUMEROFACTURE, c.NOM AS idClientlib FROM VENTE v LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT) vc_mtc ON vc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN FACTUREFOURNISSEURCPL fc_mtc ON fc_mtc.ID = mvc.IDORIGINE
WHERE ce.IDOBJET IS NULL
ORDER BY ce.DATY DESC
 
;
