alter table MOUVEMENTCAISSE add reference varchar2(100);

-------------------------------------------------------------------------------
-- 1) QUANTITÉ PAR JOUR (et totaux montants)
-------------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_STAT_VENTE_QTE_JOUR AS
SELECT
  TRUNC(DATY)                              AS jour,
  EXTRACT(YEAR  FROM DATY)                 AS annee,
  EXTRACT(MONTH FROM DATY)                 AS mois,
  SUM(NVL(QTE,0))                          AS qte_totale,
  SUM(NVL(MONTANTHT,0))                    AS montant_ht,
  SUM(NVL(MONTANTTVA,0))                   AS montant_tva,
  SUM(NVL(MONTANTTTC,0))                   AS montant_ttc,
  SUM(NVL(MONTANTREMISE,0))                AS montant_remise,
  SUM(NVL(POIDS,0))                        AS poids_total,
  SUM(NVL(FRAIS,0))                        AS frais_total
FROM VENTE_DETAILS_POIDS
GROUP BY TRUNC(DATY), EXTRACT(YEAR FROM DATY), EXTRACT(MONTH FROM DATY);

-------------------------------------------------------------------------------
-- 2) PAR ARTICLE (produit)
-------------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_STAT_VENTE_ARTICLE AS
SELECT
  IDPRODUIT,
  DESIGNATION,
  CATEGORIEPRODUITLIB,
  EXTRACT(YEAR FROM DATY)                  AS annee,
  EXTRACT(MONTH FROM DATY)                 AS mois,
  SUM(NVL(QTE,0))                          AS qte_totale,
  SUM(NVL(MONTANTHT,0))                    AS montant_ht,
  SUM(NVL(MONTANTTVA,0))                   AS montant_tva,
  SUM(NVL(MONTANTTTC,0))                   AS montant_ttc,
  SUM(NVL(MONTANTREMISE,0))                AS montant_remise,
  SUM(NVL(POIDS,0))                        AS poids_total,
  SUM(NVL(FRAIS,0))                        AS frais_total
FROM VENTE_DETAILS_POIDS
GROUP BY IDPRODUIT, DESIGNATION, CATEGORIEPRODUITLIB,
         EXTRACT(YEAR FROM DATY), EXTRACT(MONTH FROM DATY);

-------------------------------------------------------------------------------
-- 3) PAR CLIENT
-- Remarque: la vue source expose "IDCLIENTLIB" (nom). Si vous avez aussi l'ID,
-- ajoutez-le pour éviter les homonymes.
-------------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_STAT_VENTE_CLIENT AS
SELECT
  IDCLIENTLIB                              AS client,
  EXTRACT(YEAR FROM DATY)                  AS annee,
  EXTRACT(MONTH FROM DATY)                 AS mois,
  SUM(NVL(QTE,0))                          AS qte_totale,
  SUM(NVL(MONTANTHT,0))                    AS montant_ht,
  SUM(NVL(MONTANTTVA,0))                   AS montant_tva,
  SUM(NVL(MONTANTTTC,0))                   AS montant_ttc,
  SUM(NVL(MONTANTREMISE,0))                AS montant_remise,
  SUM(NVL(POIDS,0))                        AS poids_total,
  SUM(NVL(FRAIS,0))                        AS frais_total
FROM VENTE_DETAILS_POIDS
GROUP BY IDCLIENTLIB, EXTRACT(YEAR FROM DATY), EXTRACT(MONTH FROM DATY);

-------------------------------------------------------------------------------
-- 4) PAR FAMILLE DE PRODUIT
-------------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_STAT_VENTE_FAMILLE AS
SELECT
  CATEGORIEPRODUITLIB                      AS famille_produit,
  EXTRACT(YEAR FROM DATY)                  AS annee,
  EXTRACT(MONTH FROM DATY)                 AS mois,
  SUM(NVL(QTE,0))                          AS qte_totale,
  SUM(NVL(MONTANTHT,0))                    AS montant_ht,
  SUM(NVL(MONTANTTVA,0))                   AS montant_tva,
  SUM(NVL(MONTANTTTC,0))                   AS montant_ttc,
  SUM(NVL(MONTANTREMISE,0))                AS montant_remise,
  SUM(NVL(POIDS,0))                        AS poids_total,
  SUM(NVL(FRAIS,0))                        AS frais_total
FROM VENTE_DETAILS_POIDS
GROUP BY CATEGORIEPRODUITLIB,
         EXTRACT(YEAR FROM DATY), EXTRACT(MONTH FROM DATY);

-------------------------------------------------------------------------------
-- 5) VENTE BRUTE (avant remise et TVA) + Net HT + TTC
--   montant_brut = PU * QTE
--   remise_montant = montant_brut * (REMISE/100)
--   net_ht = montant_brut - remise_montant
--   tva_montant = net_ht * (TVA/100)
--   ttc = net_ht + tva_montant
-- Agrégé par jour pour lecture rapide; adaptez le GROUP BY si besoin.
-------------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_STAT_VENTE_BRUTE_JOUR AS
SELECT
  TRUNC(DATY)                                      AS jour,
  EXTRACT(YEAR  FROM DATY)                         AS annee,
  EXTRACT(MONTH FROM DATY)                         AS mois,
  SUM(NVL(PU,0) * NVL(QTE,0))                      AS montant_brut,
  SUM( (NVL(PU,0) * NVL(QTE,0)) * NVL(REMISE,0)/100 )            AS montant_remise_calc,
  SUM( (NVL(PU,0) * NVL(QTE,0)) * (1 - NVL(REMISE,0)/100) )      AS montant_net_ht_calc,
  SUM( (NVL(PU,0) * NVL(QTE,0)) * (1 - NVL(REMISE,0)/100) * NVL(TVA,0)/100 ) AS montant_tva_calc,
  SUM( (NVL(PU,0) * NVL(QTE,0)) * (1 - NVL(REMISE,0)/100) * (1 + NVL(TVA,0)/100) ) AS montant_ttc_calc
FROM VENTE_DETAILS_POIDS
GROUP BY TRUNC(DATY), EXTRACT(YEAR FROM DATY), EXTRACT(MONTH FROM DATY);