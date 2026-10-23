CREATE OR REPLACE VIEW TRAVAUX_RECAP AS
SELECT t.ID,
       sum(nvl(fac.MONTANTTTC,0)) AS montantChargeExterne,
       sum(nvl(mvt.MONTANTSORTIE,0)) AS montantPiece,
       sum(nvl(pm.MONTANTREEL,0)) AS montantMainDoeuvre,
       sum(nvl(fac.MONTANTTTC,0))+sum(nvl(mvt.MONTANTSORTIE,0))+sum(nvl(pm.MONTANTREEL,0)) AS montantTotal
FROM TRAVAUX t
         LEFT JOIN FACTUREFOURNISSEURCPL_TRAVAUX fac ON fac.IDTRAVAUX = t.ID
         LEFT JOIN MVTSTOCKLIB mvt ON mvt.IDOBJET = t.ID
         LEFT JOIN RAPPROCHEMENTTRAVAUX pm ON pm.IDTRAVAUX = t.ID
group by t.ID;
