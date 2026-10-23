-- Tonny

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
       cast(p.pu - (p.pu * remise / 100) + ((p.pu * p.tva / 100)) as number(30, 2))                                                   as punet,
       cast(nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0) as number(30, 2))                                          as frais,
       cast(((p.pu - (p.pu * remise / 100)) * qte + nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) *
                                                    NVL(p.QTE, 0)) as number(30,2))                                                  as montantht,
       cast(((p.pu - (p.pu * remise / 100)) * qte + nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0)) +
            ((((p.pu * qte) - (p.pu * remise / 100) * qte) +
              nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0)) * p.tva /
             100) as number(30, 2))                                                                                                   as montantttc,
       cast(((((p.pu * qte) - (p.pu * remise / 100) * qte) + nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) *
                                                             NVL(p.QTE, 0)) * p.tva / 100) as number(30,2))                                            as montanttva,
       cast((p.pu * remise / 100) * qte as number(30,2))                                                                             as montantremise,
       cast((p.pu) * qte as number(30,2))                                                                                            as montant,
       p.ristourne,
       cl.nom                                                                                                  as idclientlib,
       v.DATY,
       v.DATYPREVU,
       ing.LIBELLE                                                                                             AS IDPRODUITLIB,
       c.VAL                                                                                                   AS IDCATEGORIELIB,
       c.VAL                                                                                                   AS CATEGORIEPRODUITLIB,
       cast(NVL(ing.CALORIE, 0) * NVL(p.QTE, 0) as number(30,2))                                                                     as poids
from VENTE_DETAILS p
         left join AS_UNITE u on u.id = p.unite
         left join vente v on v.id = p.IDVENTE
         LEFT JOIN AS_INGREDIENTS ing
                   ON ing.ID = p.IDPRODUIT
         LEFT JOIN CLIENT cl
                   ON v.IDCLIENT = cl.ID
         LEFT JOIN CATEGORIEINGREDIENT c
                   ON ing.CATEGORIEINGREDIENT = c.ID


/

