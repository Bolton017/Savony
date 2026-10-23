-- Menus compta
UPDATE MENUDYNAMIQUE m
SET id_pere = 'MD0002121212121'
WHERE m.ID_PERE = 'MNDN274';

-- Menus principaux compta (niveau 2)
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNT2205008C', 'Exercice', 'edit_note', 'module.jsp?but=compta/exercice/ouvertureCloture.jsp', 1, 2,
        'MNDN274');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNT2205007C', 'Journal', 'book', 'module.jsp?but=compta/journal/journal.jsp', 2, 2, 'MNDN274');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNT2205004C', 'Plan comptable', 'account_balance_wallet', NULL, 3, 2, 'MNDN274');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDSN287C', 'Écriture comptable', 'edit_note', 'module.jsp?but=compta/ecriture/ecriture-liste.jsp', 5, 2,
        'MNDN274');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN176951991615864C', 'Facture Standard', 'description',
        'module.jsp?but=compta/depense/facture-depense-liste.jsp', 6, 2, 'MNDN274');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDNT2205001C', 'Lettrage', 'rule', '#', 7, 2, 'MNDN274');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDN285C', 'État comptable', 'account_box', NULL, 8, 2, 'MNDN274');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1769515257466822C', 'Déclaration', 'article', NULL, 9, 2, 'MNDN274');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1766386514657608C', 'Rapprochement bancaire', 'sticky_note_2', NULL, 10, 2, 'MNDN274');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN177684652514350C', 'Validation paiement', 'check',
        'module.jsp?but=compta/vente/validation-comptable.jsp', 11, 2, 'MNDN274');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1785224939782766C', 'Configuration', 'settings', NULL, 12, 2, 'MNDN274');

-- Sous-menus Plan comptable (niveau 3)
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN17866216491964688C', 'Général', 'account_balance_wallet',
        'module.jsp?but=compta/compte/compte-liste.jsp', 1, 3, 'MNDNT2205004C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1786621649196468C', 'Analytique', 'analytics',
        'module.jsp?but=compta/compte/compte-analytique-liste.jsp', 2, 3, 'MNDNT2205004C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN17866216491964689C', 'Auxiliaire', 'account_balance_wallet',
        'module.jsp?but=compta/compte/compte-auxiliaire-liste.jsp', 3, 3, 'MNDNT2205004C');

-- Sous-menus Lettrage (niveau 3)
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN176951573915693300109403C', 'Non lettrées', 'add', 'module.jsp?but=compta/lettrage/lettrage-saisie.jsp',
        1, 3, 'MNDNT2205001C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN17695153020177390190-94C', 'Lettrées', 'view_list', 'module.jsp?but=compta/lettrage/lettrage-liste.jsp',
        2, 3, 'MNDNT2205001C');

-- Sous-menus État comptable (niveau 3)
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDN305C', 'Balance et Grand livre', 'sticky_note_2', 'module.jsp?but=compta/etat/balance-filtre.jsp', 1, 3,
        'MNDN285C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1758106749693840C', 'États financiers', 'sticky_note_2', 'module.jsp?but=compta/bilan/bilan-filtre.jsp',
        2, 3, 'MNDN285C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MNDN1009001C', 'Journaux', 'sticky_note_2', 'module.jsp?but=compta/etat/journal-filtre.jsp', 3, 3, 'MNDN285C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1758106749693840DSDC', 'Consultation par compte', 'sticky_note_2',
        'module.jsp?but=compta/ecriture/consultation-par-compte.jsp', 4, 3, 'MNDN285C');

-- Sous-menus Déclaration (niveau 3)
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1769515302017739001C', 'Saisie d''une déclaration', 'add',
        'module.jsp?but=declaration/declaration-tva.jsp', 1, 3, 'MENDYN1769515257466822C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1769515302017739C', 'Liste des déclarations', 'view_list',
        'module.jsp?but=declaration/liste-declaration-tva.jsp', 2, 3, 'MENDYN1769515257466822C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN176951533777035C', 'Liste TVA', 'description', 'module.jsp?but=declaration/liste-tva-adeclarer.jsp', 3,
        3, 'MENDYN1769515257466822C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1769515392365851C', 'Parametre DGE', 'content_paste',
        'module.jsp?but=declaration/liste-codeimpot-compte.jsp', 4, 3, 'MENDYN1769515257466822C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1785739313483130C', 'Liste TVA non déclarable', 'description',
        'module.jsp?but=declaration/liste-tva-non-declarer.jsp', 5, 3, 'MENDYN1769515257466822C');

-- Sous-menus Rapprochement bancaire (niveau 3)
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN17663SAISIEC', 'Import Relevé', 'sticky_note_2', 'module.jsp?but=rapprochement/import-relever.jsp', 1, 3,
        'MENDYN1766386514657608C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1785147267895936C', 'Saisie Relevé', 'add', 'module.jsp?but=rapprochement/saisie-relever.jsp', 2, 3,
        'MENDYN1766386514657608C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1766386603290909C', 'Liste Relevé', 'sticky_note_2', 'module.jsp?but=rapprochement/liste-relever.jsp', 3,
        3, 'MENDYN1766386514657608C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN176638653912454C', 'Async - RIB', 'sticky_note_2', 'module.jsp?but=rapprochement/async-rib.jsp', 4, 3,
        'MENDYN1766386514657608C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN17663865543083C', 'RIB - Async', 'sticky_note_2', 'module.jsp?but=rapprochement/rib-async.jsp', 5, 3,
        'MENDYN1766386514657608C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1766386571510101C', 'Automatique', 'sticky_note_2', 'module.jsp?but=rapprochement/automatique-form.jsp',
        6, 3, 'MENDYN1766386514657608C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN176638653912455C', 'Liste rapprochement', 'list_alt',
        'module.jsp?but=rapprochement/liste-rapprochement.jsp', 7, 3, 'MENDYN1766386514657608C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN0026122025C', 'Règlement', 'list_alt', 'module.jsp?but=rapprochement/relever-a-regler.jsp', 8, 3,
        'MENDYN1766386514657608C');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1770706593858630C', 'État', 'balance', 'module.jsp?but=rapprochement/etat-rapprochement.jsp', 9, 3,
        'MENDYN1766386514657608C');

-- Sous-menus Configuration (niveau 3)
INSERT INTO MENUDYNAMIQUE
    (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES ('MENDYN1785224986200531C', 'Paramètre de comptabilité', 'admin_panel_settings',
        'module.jsp?but=compta/paramCompta/paramCompta-liste.jsp', 1, 3, 'MENDYN1785224939782766C');
-- Recherche mot cle journal
CREATE
OR REPLACE VIEW COMPTA_JOURNAL_MOTSCLESSS AS
SELECT cj.ID,
       cj.VAL,
       cj.DESCE,
       cj.COMPTE,
       cj.id || '' || cj.val || '' || cj.desce || '' || cj.compte AS motsclesss
FROM COMPTA_JOURNAL cj;

-- Deroulante journal
CREATE
OR REPLACE FORCE VIEW COMPTA_JOURNAL_VIEW AS
SELECT ID,
       VAL,
       VAL || '|' || DESCE AS DESCE
FROM COMPTA_JOURNAL;

-- Journal avec compte
CREATE
OR REPLACE VIEW COMPTA_JOURNAL_COMPTE AS
SELECT ID,
       CASE
           WHEN COMPTE IS NOT NULL THEN VAL || ' - ' || COMPTE
           ELSE VAL
           END                               AS VAL,
       VAL || '|' || DESCE || '**' || COMPTE AS DESCE
FROM COMPTA_JOURNAL
WHERE VAL != 'COMP000015';

-- Plan comptable libelle
CREATE
OR REPLACE VIEW COMPTA_COMPTE_LIBELLE AS
SELECT compta_compte.ID,
       compta_compte.compte,
       compta_compte.libelle,
       compta_type_compte.val                              AS typecompte,
       compta_classe_compte.val                            AS classe,
       (compta_journal.VAL || '|' || compta_journal.DESCE) AS idjournal,
       compta_type_compte.id                               AS idtypecompte
FROM compta_compte
         JOIN compta_type_compte ON compta_type_compte.ID = compta_compte.typecompte
         LEFT JOIN compta_classe_compte ON compta_classe_compte.ID = compta_compte.classy
         LEFT JOIN compta_journal ON compta_compte.idjournal = compta_journal.id;

-- Liste ecritures
CREATE
OR REPLACE VIEW COMPTA_ECRITURE_LIB AS
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
         LEFT JOIN VENTE_CPL vc ON vc.id = ce.idobjet
         LEFT JOIN MOUVEMENTCAISSECPL mvc ON mvc.id = ce.idobjet
         LEFT JOIN VENTE_CPL vc_mtc ON vc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN FACTUREFOURNISSEURCPL fc_mtc ON fc_mtc.ID = mvc.IDORIGINE
ORDER BY ce.DATY DESC;

-- Ecritures ventes
CREATE
OR REPLACE VIEW COMPTA_ECRITURE_LIB_VENTE AS
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
         LEFT JOIN VENTE_CPL vc ON vc.id = ce.idobjet
         LEFT JOIN MOUVEMENTCAISSECPL mvc ON mvc.id = ce.idobjet
         LEFT JOIN VENTE_CPL vc_mtc ON vc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN FACTUREFOURNISSEURCPL fc_mtc ON fc_mtc.ID = mvc.IDORIGINE
WHERE ce.IDOBJET LIKE '%VNT%'
ORDER BY ce.DATY DESC;

-- Ecritures stock et caisse
CREATE
OR REPLACE VIEW COMPTA_ECRITURE_LIB_STOCK AS
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
         LEFT JOIN VENTE_CPL vc ON vc.id = ce.idobjet
         LEFT JOIN MOUVEMENTCAISSECPL mvc ON mvc.id = ce.idobjet
         LEFT JOIN VENTE_CPL vc_mtc ON vc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN FACTUREFOURNISSEURCPL fc_mtc ON fc_mtc.ID = mvc.IDORIGINE
WHERE ce.IDOBJET LIKE '%MVTST%'
   OR ce.IDOBJET LIKE '%MTC%'
ORDER BY ce.DATY DESC;

-- Ecritures avoirs clients
CREATE
OR REPLACE VIEW COMPTA_ECRITURE_LIB_AVOIRFC AS
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
         LEFT JOIN VENTE_CPL vc ON vc.id = ce.idobjet
         LEFT JOIN MOUVEMENTCAISSECPL mvc ON mvc.id = ce.idobjet
         LEFT JOIN VENTE_CPL vc_mtc ON vc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN FACTUREFOURNISSEURCPL fc_mtc ON fc_mtc.ID = mvc.IDORIGINE
WHERE ce.IDOBJET LIKE '%AVRFC%'
ORDER BY ce.DATY DESC;

-- Ecritures achats factures fournisseurs
CREATE
OR REPLACE VIEW COMPTA_ECRITURE_LIB_ACHAT AS
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
         LEFT JOIN VENTE_CPL vc ON vc.id = ce.idobjet
         LEFT JOIN MOUVEMENTCAISSECPL mvc ON mvc.id = ce.idobjet
         LEFT JOIN VENTE_CPL vc_mtc ON vc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN FACTUREFOURNISSEURCPL fc_mtc ON fc_mtc.ID = mvc.IDORIGINE
WHERE ce.IDOBJET LIKE '%FCF%'
ORDER BY ce.DATY DESC;

-- Ecritures manuelles
CREATE
OR REPLACE VIEW COMPTA_ECRITURE_LIB_MANUELLE AS
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
         LEFT JOIN VENTE_CPL vc ON vc.id = ce.idobjet
         LEFT JOIN MOUVEMENTCAISSECPL mvc ON mvc.id = ce.idobjet
         LEFT JOIN VENTE_CPL vc_mtc ON vc_mtc.ID = mvc.IDORIGINE
         LEFT JOIN FACTUREFOURNISSEURCPL fc_mtc ON fc_mtc.ID = mvc.IDORIGINE
WHERE ce.IDOBJET IS NULL
ORDER BY ce.DATY DESC;

-- Fiche ecriture
CREATE
OR REPLACE VIEW COMPTA_ECRITURE_FICHE AS
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
       ce.IDOBJET,
       ce.LETTRAGE,
       vc.FICHE  AS lien,
       ce.dateSaisie,
       ce.DATEMODIF,
       ce.idModificateur,
       u.NOMUSER AS idModificateurlib,
       cj.VAL    AS journalLib
FROM COMPTA_ECRITURE ce
         LEFT JOIN V_CLASSEETFICHE vc ON SUBSTR(ce.IDOBJET, 1, 3) = vc.LIBELLE
         LEFT JOIN utilisateur u ON ce.idmodificateur = u.REFUSER
         LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL;

-- Formulaire saisie depense
CREATE
OR REPLACE FORCE VIEW DEPENSESAISIE AS
SELECT ''                           AS ID,
       ''                           AS IDFOURNISSEUR,
       ''                           AS IDMODEPAIEMENT,
       ''                           AS IDTYPEFACTURE,
       ''                           AS IDDEVISE,
       CAST(NULL AS DATE)           AS DATY,
       CAST(NULL AS DATE)           AS DATYPREVU,
       CAST(NULL AS DATE)           AS DATEECHEANCEPAIEMENT,
       CAST(NULL AS NUMBER(1))      AS ESTPREVU,
       CAST(NULL AS NUMBER)         AS ETAT,
       CAST(NULL AS NUMBER (30, 2)) AS TAUX,
       ''                           AS DEVISE,
       ''                           AS DESIGNATION,
       ''                           AS REFERENCE,
       ''                           AS IDBC,
       ''                           AS IDMAGASIN,
       ''                           AS NUMERO,
       ''                           AS TYPEACHAT,
       ''                           AS TYPE_FACTURE,
       ''                           AS IDOBJET,
       ''                           AS IDREF,
       ''                           AS IDDMDACHAT,
       CAST(NULL AS NUMBER)         AS EXERCICE,
       ''                           AS PERIODE,
       ''                           AS LIBELLE,
       CAST(NULL AS NUMBER (30, 2)) AS TOTALFACTURE,
       ''                           AS TYPETVA,
       ''                           AS TYPEFACTUREFOURNISSEUR,
       ''                           AS JOUR
FROM DUAL;

-- Lignes saisie depense
CREATE
OR REPLACE FORCE VIEW DEPENSEFILLESAISIE AS
SELECT ''                           AS ID,
       ''                           AS IDFACTUREFOURNISSEUR,
       ''                           AS IDPRODUIT,
       ''                           AS IDBCDETAIL,
       ''                           AS DEVISE,
       ''                           AS IDDEVISE,
       ''                           AS DESIGNATION,
       ''                           AS COMPTE,
       ''                           AS COMPTEANALYTIQUE,
       ''                           AS LIBELLE,
       ''                           AS INTITULE,
       CAST(NULL AS NUMBER (30, 2)) AS PU,
       CAST(NULL AS NUMBER (30, 2)) AS PUHT,
       CAST(NULL AS NUMBER (30, 2)) AS TAUXDECHANGE,
       CAST(NULL AS NUMBER (30, 2)) AS REMISES,
       CAST(NULL AS NUMBER)         AS MOIS,
       CAST(NULL AS NUMBER)         AS ANNEE,
       CAST(NULL AS NUMBER (30, 2)) AS QTE,
       CAST(NULL AS NUMBER (30, 2)) AS MONTANTPERTEGAIN,
       CAST(NULL AS NUMBER (30, 2)) AS DEBIT,
       CAST(NULL AS NUMBER (30, 2)) AS CREDIT,
       CAST(NULL AS NUMBER (30, 2)) AS TVA,
       CAST(NULL AS NUMBER (30, 2)) AS MONTANTTVA
FROM DUAL;

-- Liste factures standards
CREATE
OR REPLACE VIEW FACTURESTANDARD AS
SELECT fcpl.id,
       fcpl.idfournisseur,
       fcpl.idfournisseurlib,
       fcpl.idmodepaiement,
       fcpl.idmodepaiementlib,
       fcpl.daty,
       fcpl.designation,
       fcpl.dateecheancepaiement,
       fcpl.etatlib,
       fcpl.reference,
       fcpl.idbc,
       fcpl.idmagasin,
       fcpl.idmagasinlib,
       fcpl.devise,
       fcpl.iddevise,
       fcpl.etat,
       fcpl.taux,
       fcpl.montanttva,
       fcpl.montantht,
       fcpl.tauxdechange,
       fcpl.montantttc                                 AS MONTANTTTC,
       nvl((fcpl.montantpaye * fcpl.TAUXDECHANGE), 0)  AS MONTANTPAYE,
       nvl((fcpl.montantreste * fcpl.TAUXDECHANGE), 0) AS MONTANTRESTE,
       fcpl.IDOBJET,
       fcpl.IDREF,
       fcpl.typeachat,
       ce.id                                           AS idecriture,
       '-'                                             AS compte,
       fcpl.numero                                     AS numero
FROM FACTUREFOURNISSEURCPL fcpl
         LEFT JOIN compta_ecriture ce ON ce.idobjet = fcpl.id
WHERE fcpl.typeachat = 'PS';

-- Lettrage sous ecriture
CREATE
OR REPLACE VIEW COMPTA_SOUSECRITURE_LETTRE (
    ID, NUMERO, COMPTE, JOURNAL, IDJOURNAL, ECRITURE, DATY, CREDIT, DEBIT,
    DATECOMPTABLE, EXERCICE, REMARQUE, ETAT, IDMERE, HORSEXERCICE, OD, ORIGINE,
    TIERS, LIBELLEPIECE, COMPTE_AUX, RAISONSOCIAL, FOLIO, LETTRAGE, ANALYTIQUE,
    IDVENTE, LETTRE, MONTANT
) AS
SELECT lib.ID,
       lib.NUMERO,
       lib.COMPTE,
       lib.JOURNAL,
       lib.IDJOURNAL,
       lib.ECRITURE,
       lib.DATY,
       lib.CREDIT,
       lib.DEBIT,
       lib.DATECOMPTABLE,
       lib.EXERCICE,
       lib.REMARQUE,
       lib.ETAT,
       lib.IDMERE,
       lib.HORSEXERCICE,
       lib.OD,
       lib.ORIGINE,
       lib.TIERS,
       lib.LIBELLEPIECE,
       lib.COMPTE_AUX,
       lib.RAISONSOCIAL,
       lib.FOLIO,
       lib.LETTRAGE,
       lib.ANALYTIQUE,
       COALESCE(mtc.IDORIGINE, ecr.IDOBJET) AS IDVENTE,
       cltr.lettre                          AS LETTRE,
       CASE
           WHEN NVL(lib.DEBIT, 0) = 0 THEN lib.CREDIT
           WHEN NVL(lib.CREDIT, 0) = 0 THEN lib.DEBIT
           ELSE lib.DEBIT - lib.CREDIT
           END                              AS MONTANT
FROM COMPTA_SOUSECRITURE_LIB lib
         JOIN COMPTA_ECRITURE ecr ON lib.IDMERE = ecr.ID
         LEFT JOIN MOUVEMENTCAISSE mtc ON ecr.IDOBJET = mtc.ID
         LEFT JOIN compta_lettrage cltr ON cltr.id = lib.lettrage
WHERE lib.etat = 11
ORDER BY IDVENTE DESC;

-- Lettrage validation CSEMF
CREATE
OR REPLACE VIEW COMPTA_SOUS_ECRITURE_CSEMF AS
SELECT CSE.ID,
       CSE.COMPTE,
       CSE.DEBIT,
       CSE.CREDIT,
       CSE.REMARQUE,
       CSE.LIBELLEPIECE,
       CSE.IDMERE,
       CSE.REFERENCE_ENGAGEMENT,
       CSE.COMPTE_AUX,
       CSE.LETTRAGE,
       CSE.JOURNAL,
       CSE.EXERCICE,
       CSE.ETAT,
       CSE.DATY,
       CSE.FOLIO,
       CSE.ANALYTIQUE,
       CSE.SOURCE,
       CE.ORIGINE,
       CASE
           WHEN NVL(CSE.DEBIT, 0) = 0 THEN CSE.CREDIT
           WHEN NVL(CSE.CREDIT, 0) = 0 THEN CSE.DEBIT
           ELSE CSE.DEBIT - CSE.CREDIT
           END AS MONTANT
FROM COMPTA_SOUS_ECRITURE CSE
         LEFT JOIN COMPTA_ECRITURE CE ON CE.ID = CSE.IDMERE;


-- Vue comptes pour grand livre
CREATE
OR REPLACE VIEW v_compta_compte AS
SELECT id,
       TO_NUMBER(REGEXP_SUBSTR(TRIM(compte), '^[0-9]+')) AS compteInt,
       compte,
       libelle,
       typecompte,
       classy,
       analytique_obli,
       idjournal,
       codeimpot
FROM compta_compte
WHERE REGEXP_LIKE(TRIM(compte), '^[0-9]+');

-- Report de solde general
CREATE
OR REPLACE VIEW REPORTSOLDE_GENERAL_V1 AS
SELECT COMPTE,
       LIBELLE,
       CAST(DEBIT AS NUMBER (30, 2))  AS debit,
       CAST(CREDIT AS NUMBER (30, 2)) AS credit,
       TYPECOMPTE,
       daty,
       CHIFFRE3,
       CHIFFRE2
FROM (SELECT cse.COMPTE,
             cc.libelle,
             SUM(cse.debit)           AS debit,
             SUM(cse.credit)          AS credit,
             cc.typecompte,
             cse.daty,
             CASE
                 WHEN SUBSTR(cse.compte, 1, 4) = '4007' THEN '407'
                 ELSE SUBSTR(cse.compte, 1, 2) || SUBSTR(cse.compte, 5, 1)
                 END                  AS CHIFFRE3,
             SUBSTR(cse.compte, 1, 2) AS CHIFFRE2
      FROM compta_sous_ecriture cse,
           compta_compte cc,
           compta_journal jrn
      WHERE cc.COMPTE = cse.compte
        AND cse.etat = 11
        AND cse.JOURNAL = jrn.id
      GROUP BY cse.COMPTE,
               cc.libelle,
               cc.typecompte,
               cse.daty);

-- Report de solde auxiliaire
CREATE
OR REPLACE VIEW REPORTSOLDE_AUX_V1 AS
SELECT COMPTE,
       LIBELLE,
       CAST(DEBIT AS NUMBER (30, 2))  AS debit,
       CAST(CREDIT AS NUMBER (30, 2)) AS credit,
       TYPECOMPTE,
       daty,
       CHIFFRE3,
       CHIFFRE2
FROM (SELECT t.COMPTEAUXILIAIRE               AS COMPTE,
             t.NOM                            AS LIBELLE,
             SUM(cse.debit)                   AS debit,
             SUM(cse.credit)                  AS credit,
             cc.typecompte,
             cse.daty,
             CASE
                 WHEN SUBSTR(t.COMPTEAUXILIAIRE, 1, 4) = '4007' THEN '407'
                 ELSE SUBSTR(t.COMPTEAUXILIAIRE, 1, 2) || SUBSTR(t.COMPTEAUXILIAIRE, 5, 1)
                 END                          AS CHIFFRE3,
             SUBSTR(t.COMPTEAUXILIAIRE, 1, 2) AS CHIFFRE2
      FROM compta_sous_ecriture cse
               JOIN compta_compte cc ON cc.COMPTE = cse.compte
               JOIN compta_journal jrn ON cse.JOURNAL = jrn.id
               JOIN TIERS t ON t.id = cse.COMPTE_AUX
      WHERE cse.etat = 11
      GROUP BY t.COMPTEAUXILIAIRE,
               t.NOM,
               cc.typecompte,
               cse.daty);

-- Validation comptable des paiements
CREATE
OR REPLACE VIEW MOUVEMENTCAISSECPL_A_VALIDER AS
SELECT ID,
       DESIGNATION,
       IDCAISSE,
       IDCAISSELIB,
       IDVENTEDETAIL,
       IDVIREMENT,
       DEBIT,
       CREDIT,
       DATY,
       ETAT,
       ETATLIB,
       IDVENTE,
       IDORIGINE,
       IDTIERS,
       TIERS,
       DATYCOMPTABILISATION
FROM MOUVEMENTCAISSECPL m
WHERE etat > 7
  AND etat < 11;


CREATE
OR REPLACE VIEW COMPTA_COMPTE_INGREDIENTS
AS
SELECT c.ID,
       c.COMPTE,
       c.LIBELLE,
       c.TYPECOMPTE,
       c.CLASSY,
       c.ANALYTIQUE_OBLI,
       c.IDJOURNAL,
       c.CODEIMPOT,
       si.ID      AS idingredient,
       si.LIBELLE AS libelleIngredient
FROM COMPTA_COMPTE c
         JOIN ST_INGREDIENTSAUTOACHAT_CPL si ON
    c.COMPTE = si.COMPTE_ACHAT;


CREATE
OR REPLACE
VIEW LIAISONCODELIB
AS
SELECT ls.id,
       ls.idCodeImpot,
       ls.idCompte,
       ls.FORMULE,
       CASE
           WHEN ls.TAXABLE = 'oui' THEN 'Oui'
           WHEN ls.TAXABLE = 'non' THEN 'Non'
           ELSE NULL
           END    AS TAXABLE,
       i.rubrique AS IDCODEIMPOTLIB
FROM LiaisonCodeImpot ls
         LEFT JOIN imprimedeclaration i ON
    ls.idcodeimpot = i.id;

CREATE
OR REPLACE VIEW DECLARATIONTVALIB AS
SELECT de.id,
       de.designation,
       de.datyDebut,
       de.datyFin,
       de.etat,
       CASE
           WHEN de.etat = 1 THEN 'Cree'
           WHEN de.etat = 11 THEN 'Valide'
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



CREATE
OR REPLACE
VIEW DECLARATIONTVA_VIDE AS
SELECT dtva.id,
       dtva.designation,
       dtva.datydebut,
       dtva.datyfin,
       dtva.etat,
       0 AS mois,
       0 AS annee
FROM DECLARATIONTVA dtva;


CREATE OR REPLACE VIEW COMPTA_COMPTE_INGREDIENTS AS
SELECT
    c.ID,
    c.COMPTE,
    c.LIBELLE,
    c.TYPECOMPTE,
    c.CLASSY,
    c.ANALYTIQUE_OBLI,
    c.IDJOURNAL,
    c.CODEIMPOT,
    si.ID AS idingredient,
    si.LIBELLE AS libelleIngredient
FROM
    COMPTA_COMPTE c
        LEFT JOIN ST_INGREDIENTSAUTOACHAT_CPL si ON
        c.COMPTE = si.COMPTE_ACHAT;