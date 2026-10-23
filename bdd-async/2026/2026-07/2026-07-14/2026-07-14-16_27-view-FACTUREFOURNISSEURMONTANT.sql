create or replace view FACTUREFOURNISSEURMONTANT as
SELECT v.ID,
            cast(SUM ((1-nvl(vd.remise/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0))) as number(30,2)) AS montanttotal,
            cast(SUM ((1-nvl(vd.REMISE /100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0))* (NVL (VD.TVA , 0))/100) as number(30,2)) AS montantTva,
            cast(SUM ((1-nvl(vd.remise/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0))* (NVL (VD.TVA , 0))/100)+SUM ((1-nvl(vd.remise/100,0))* (NVL (vd.QTE, 0) * NVL (vd.PU, 0)))as number(30,2))  as montantTTC,
            NVL (vd.IDDEVISE,'AR') AS IDDEVISE,
            nvl (vd.tauxdechange,1) AS tauxdechange
            FROM FactureFournisseurFille vd LEFT JOIN facturefournisseur v ON v.ID = vd.idfacturefournisseur
   GROUP BY v.ID, vd.IDDEVISE,vd.tauxdechange;