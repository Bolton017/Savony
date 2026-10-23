INSERT INTO CATEGORIEINGREDIENT
(ID, VAL, DESCE, ESTACHAT)
VALUES('CATM0002', 'Ligne', 'Ligne', NULL);

CREATE OR REPLACE FORCE VIEW "TRAVAUX_RECAP" ("ID", "MONTANTCHARGEEXTERNE", "MONTANTPIECE", "MONTANTMAINDOEUVRE", "MONTANTTOTAL") AS
WITH fac_agg AS (
  SELECT idtravaux,
         SUM(NVL(montantttc, 0)) AS montantChargeExterne
  FROM FACTUREFOURNISSEURCPL_TRAVAUX
  GROUP BY idtravaux
),
mvt_agg AS (
  SELECT idobjet,
         SUM(NVL(montantsortie, 0)) AS montantPiece
  FROM MVTSTOCKLIB
  GROUP BY idobjet
),
pm_agg AS (
  SELECT idtravaux,
         SUM(NVL(montantreel, 0)) AS montantMainDoeuvre
  FROM RAPPROCHEMENTTRAVAUX
  GROUP BY idtravaux
)
SELECT t.id,
       NVL(fac_agg.montantChargeExterne, 0) AS montantChargeExterne,
       NVL(mvt_agg.montantPiece, 0)         AS montantPiece,
       NVL(pm_agg.montantMainDoeuvre, 0)    AS montantMainDoeuvre,
       NVL(fac_agg.montantChargeExterne, 0)
           + NVL(mvt_agg.montantPiece, 0)
           + NVL(pm_agg.montantMainDoeuvre, 0)    AS montantTotal
FROM TRAVAUX t
         LEFT JOIN fac_agg ON fac_agg.idtravaux = t.id
         LEFT JOIN mvt_agg ON mvt_agg.idobjet   = t.id
         LEFT JOIN pm_agg  ON pm_agg.idtravaux  = t.id;
