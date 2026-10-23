 create or replace view VENTE_DETAILS_VIDE as
select p.ID,
       p.IDVENTE,
       p.IDPRODUIT,
       p.IDORIGINE,
       p.QTE,
       p.PU,
       p.REMISE,
       p.TVA,
       p.PUACHAT,
       p.PUVENTE,
       p.IDDEVISE,
       p.TAUXDECHANGE,
       p.DESIGNATION,
       p.COMPTE,
       p.PUREVIENT,
       p.IDBCFILLE,
       p.UNITE,
       u.VAL                                                                                                   as unitelib,
       cast(p.pu - (p.pu * p.remise / 100) + ((p.pu * p.tva / 100)) as number(30, 2))                                                   as punet,
       cast(0 as number(30, 2))                                          as frais,
       cast(((p.pu - (p.pu * p.remise / 100)) * p.qte) as number(30,2))                                                  as montantht,
       cast(((p.pu - (p.pu * p.remise / 100)) * p.qte) +
            ((((p.pu * p.qte) - (p.pu * p.remise / 100) * qte)) * p.tva /
             100) as number(30, 2))                                                                                                   as montantttc,
       cast(((((p.pu * qte) - (p.pu * p.remise / 100) * qte) ) * p.tva / 100) as number(30,2))                                            as montanttva,
       cast((p.pu * p.remise / 100) * qte as number(30,2))                                                                             as montantremise,
       cast((p.pu) * p.qte as number(30,2))                                                                                            as montant,
       p.ristourne,
       cl.nom                                                                                                  as idclientlib,
       v.DATY,
       v.DATYPREVU,
       ing.LIBELLE                                                                                             AS IDPRODUITLIB,
       c.VAL                                                                                                   AS IDCATEGORIELIB,
       c.VAL                                                                                                   AS CATEGORIEPRODUITLIB,
       cast(NVL(ing.CALORIE, 0) * NVL(p.QTE, 0) as number(30,2))                                                                     as poids,
       p.IDPREVISION
from VENTE_DETAILS p
         left join AS_UNITE u on u.id = p.unite
         left join vente v on v.id = p.IDVENTE
         LEFT JOIN AS_INGREDIENTS ing
                   ON ing.ID = p.IDPRODUIT
         LEFT JOIN CLIENT cl
                   ON v.IDCLIENT = cl.ID
         LEFT JOIN CATEGORIEINGREDIENT c
                   ON ing.CATEGORIEINGREDIENT = c.ID;


create or replace view VENTEMONTANT as
SELECT v.ID,
       cast(SUM((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0))) as number(30, 2))                          AS montanttotal,
       cast(SUM((NVL(vd.QTE, 0) * NVL(vd.PU, 0))) -
            SUM((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0))) as number(30, 2))                  AS montantremise,
       sum(FRAIS)                                                                                                    as frais,
       cast(SUM((NVL(vd.QTE, 0) * NVL(vd.PuAchat, 0))) as number(30, 2))                                             AS montanttotalachat,
       cast(SUM(((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0))) * (NVL(VD.TVA, 0)) /
                100) as number(30, 2))                                                                               AS montantTva,
       cast(SUM(((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0))) * (NVL(VD.TVA, 0)) / 100) +
            SUM((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0)) ) as number(30, 2))                          as montantTTC,
       NVL(vd.IDDEVISE, 'AR')                                                                                        AS IDDEVISE,
       NVL(avg(vd.tauxDeChange), 1)                                                                                  AS tauxDeChange,
       cast(SUM((1 - nvl(vd.remise / 100, 0)) * (NVL(vd.QTE, 0) * NVL(vd.PU, 0)  *
                                                 NVL(VD.TAUXDECHANGE, 1)) *
                (NVL(VD.TVA, 0)) / 100) +
            SUM(((1 - nvl(vd.remise / 100, 0)) *
                 (NVL(vd.QTE, 0) * NVL(vd.PU, 0)) *
                 NVL(VD.TAUXDECHANGE, 1))) as number(30, 2))                        as montantTTCAR,
       cast(sum(vd.PUREVIENT * vd.QTE) as number(20, 2))                                                             as montantRevient,
       v.IDRESERVATION
FROM VENTE_DETAILS_POIDS vd
         LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
         left join AS_INGREDIENTS vp on vp.id = vd.IDPRODUIT
GROUP BY v.ID, NVL(vd.IDDEVISE, 'AR'), v.IDRESERVATION;