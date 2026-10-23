UPDATE MODEPAIEMENT
SET VAL='AU COMPTANT ESPÈCES', DESCE='AU COMPTANT ESPÈCES'
WHERE ID='0001';
UPDATE MODEPAIEMENT
SET VAL='10 JOURS DATE DE FACTURATION', DESCE='10 JOURS DATE DE FACTURATION'
WHERE ID='0002';
UPDATE MODEPAIEMENT
SET VAL='15 JOURS DATE DE FACTURATION', DESCE='15 JOURS DATE DE FACTURATION'
WHERE ID='0003';
UPDATE MODEPAIEMENT
SET VAL='20 JOURS DATE DE FACTURATION', DESCE='20 JOURS DATE DE FACTURATION'
WHERE ID='0004';
UPDATE MODEPAIEMENT
SET VAL='30 JOURS DATE DE FACTURATION', DESCE='30 JOURS DATE DE FACTURATION'
WHERE ID='0005';
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0006', '30 JOURS FIN DE MOIS DATE DE FACTURATION', '30 JOURS FIN DE MOIS DATE DE FACTURATION');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0007', '35 JOURS DATE DE FACTURATION', '35 JOURS DATE DE FACTURATION');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0008', '40 JOURS DATE DE FACTURATION', '40 JOURS DATE DE FACTURATION');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0009', '45 JOURS DATE DE FACTURATION', '45 JOURS DATE DE FACTURATION');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0010', '45 JOURS DATE DE LIVRAISON', '45 JOURS DATE DE LIVRAISON');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0011', '50% Commande 50% Livraison', '50% Commande 50% Livraison');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0012', '60 JOURS DATE DE FACTURATION', '60 JOURS DATE DE FACTURATION');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0013', '60 JOURS DATE DE LIVRAISON', '60 JOURS DATE DE LIVRAISON');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0014', '70% Commande 30% Livraison', '70% Commande 30% Livraison');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0015', 'AU COMPTANT PAR AIRTEL MONEY', 'AU COMPTANT PAR AIRTEL MONEY');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0016', 'AU COMPTANT PAR CHÈQUE', 'AU COMPTANT PAR CHÈQUE');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0017', 'DÈS RÉCEPTION FACTURE', 'DÈS RÉCEPTION FACTURE');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0018', 'FIN DU MOIS DATE DE FACTURATION', 'FIN DU MOIS DATE DE FACTURATION');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0019', 'TRAITE 15 JOURS', 'TRAITE 15 JOURS');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0020', 'TRAITE 20 JOURS', 'TRAITE 20 JOURS');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0021', 'TRAITE 30 JOURS', 'TRAITE 30 JOURS');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0022', 'TRAITE 30 JOURS FIN DU MOIS', 'TRAITE 30 JOURS FIN DU MOIS');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0023', 'TRAITE 35 JOURS', 'TRAITE 35 JOURS');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0024', 'TRAITE 45 JOURS', 'TRAITE 45 JOURS');
INSERT INTO MODEPAIEMENT (ID, VAL, DESCE) VALUES ('0025', 'TRAITE 60 JOURS', 'TRAITE 60 JOURS');


CREATE OR REPLACE  VIEW PROFORMA_CPL ("ID", "DESIGNATION", "IDMAGASIN", "IDMAGASINLIB", "DATY", "REMARQUE", "ETAT", "ETATLIB", "IDDEVISE", "IDCLIENT", "CODECLIENT", "IDCLIENTLIB", "ADRESSE", "CONTACT", "POIDSTOTAL", "MONTANT", "MONTANTREMISE", "MONTANTRISTOURNE", "FRAISLIVRAISON", "FRAISTRANSPORT", "MONTANTTOTAL", "MONTANTTVA", "MONTANTTTC", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTRESTE", "AVOIR", "TAUXDECHANGE", "MONTANTREVIENT", "MARGEBRUTE", "IDRESERVATION", "IDORIGINE", "REMISE", "DATEVALIDITE", "MOTSCLESSS") AS
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL                                                                                  AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
           WHEN v.ETAT = 11 THEN 'VIS&Eacute;E'
           WHEN v.ETAT = 0 THEN 'ANNUL&Eacute;E'
           END
                                                                                              AS ETATLIB,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.CODECLIENT,
       c.NOM                                                                                  AS IDCLIENTLIB,
       c.ADRESSE,
       c.TELEPHONE                                                                            AS CONTACT,
       cast(V2.POIDSTOTAL as number(30, 2))                                                   as poidstotal,
       cast(V2.montant as number(30, 2))                                                      as montant,
       cast(V2.montantremise as number(30, 2))                                                as MONTANTREMISE,
       cast(V2.montantristourne as number(30, 2))                                             as MONTANTRistourne,
       cast(nvl(v.fraislivraison, 0) as number(10,2)) as fraislivraison,
       cast(V2.FRAISTRANSPORT as number(30, 2))                                               as fraistransport,
       v2.MONTANTTOTAL,
       cast(V2.MONTANTTVA as number(30, 2))                                                   as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30, 2))                                                   as montantttc,
       cast(V2.MONTANTTTCAR as number(30, 2))                                                 as MONTANTTTCAR,
       cast(nvl(mv.credit, 0) - nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30, 2))                     AS montantpaye,
       cast(V2.MONTANTTTC - nvl(mv.credit, 0) - nvl(ACG.resteapayer_avr, 0) AS NUMBER(30, 2)) AS montantreste,
       nvl(ACG.MONTANTTTC_avr, 0)                                                             as avoir,
       v2.tauxDeChange                                                                        AS tauxDeChange,
       v2.MONTANTREVIENT,
       cast((V2.MONTANTTTCAR - v2.MONTANTREVIENT) as number(20, 2))                           as margeBrute,
       v.IDRESERVATION,
       v.IDORIGINE,
       nvl(v.remise, 0) as remise,
       v.DATEVALIDITE,
       UPPER(
               v.DESIGNATION || ' ' ||
               NVL(c.CODECLIENT, '') || ' ' ||
               NVL(c.NOM, '') || ' ' ||
               NVL(c.ADRESSE, '') || ' ' ||
               NVL(c.TELEPHONE, '') || ' ' ||
               NVL(m.VAL, '') || ' ' ||
               TO_CHAR(v.DATY, 'DD/MM/YYYY') || ' ' ||
               TO_CHAR(v.DATEVALIDITE, 'DD/MM/YYYY')
       ) AS MOTSCLESSS
FROM PROFORMA v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
         JOIN PROFORMAMONTANT2 v2 ON v2.ID = v.ID
         LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id = mv.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID;





