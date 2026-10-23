
create or replace view VENTEMONTANT as
SELECT v.ID,
       cast(SUM((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0)) -
                (nvl(v.fraislivraison, 0) * nvl(vp.CALORIE, 0) * vd.QTE)) as number(30, 2))                          AS montanttotal,
       cast(SUM((NVL(vd.QTE, 0) * NVL(vd.PU, 0))) -
            SUM((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0))) as number(30, 2))                  AS montantremise,
       sum(FRAIS)                                                                                                    as frais,
       cast(SUM((NVL(vd.QTE, 0) * NVL(vd.PuAchat, 0))) as number(30, 2))                                             AS montanttotalachat,
       cast(SUM(((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0)) -
                 (nvl(v.fraislivraison, 0) * nvl(vp.CALORIE, 0) * vd.QTE)) * (NVL(VD.TVA, 0)) /
                100) as number(30, 2))                                                                               AS montantTva,
       cast(SUM(((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0)) -
                 (nvl(v.fraislivraison, 0) * nvl(vp.CALORIE, 0) * vd.QTE)) * (NVL(VD.TVA, 0)) / 100) +
            SUM((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0)) -
                (nvl(v.fraislivraison, 0) * nvl(vp.CALORIE, 0) * vd.QTE)) as number(30, 2))                          as montantTTC,
       NVL(vd.IDDEVISE, 'AR')                                                                                        AS IDDEVISE,
       NVL(avg(vd.tauxDeChange), 1)                                                                                  AS tauxDeChange,
       cast(SUM((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0) -
                                                 (nvl(v.fraislivraison, 0) * nvl(vp.CALORIE, 0) * vd.QTE) *
                                                 NVL(VD.TAUXDECHANGE, 1)) *
                (NVL(VD.TVA, 0)) / 100) +
            SUM(((1 - nvl(vd.remise / 100, 0)) *
                 (NVL(vd.QTE, 0) * NVL(vd.PU, 0) - (nvl(v.fraislivraison, 0) * nvl(vp.CALORIE, 0) * vd.QTE)) *
                 NVL(VD.TAUXDECHANGE, 1)) -
                ((nvl(v.fraislivraison, 0) * nvl(vp.CALORIE, 0) * vd.QTE))) as number(30, 2))                        as montantTTCAR,
       cast(sum(vd.PUREVIENT * vd.QTE) as number(20, 2))                                                             as montantRevient,
       v.IDRESERVATION
FROM VENTE_DETAILS_POIDS vd
         LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
         left join AS_INGREDIENTS vp on vp.id = vd.IDPRODUIT
GROUP BY v.ID, NVL(vd.IDDEVISE, 'AR'), v.IDRESERVATION;