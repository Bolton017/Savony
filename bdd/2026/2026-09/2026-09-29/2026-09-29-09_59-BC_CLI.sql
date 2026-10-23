create or replace view VENTE_DETAILS_RESTE as
SELECT
    vd.id AS id,
    vd.idProduit,
    vd.UNITE as idunite,
    u.VAL AS unitelib,
    vd.qte AS QTE,
    nvl(vd.QTE,0) - nvl(bl.QUANTITE,0) AS reste,
    vd.IDVENTE AS IDVENTE,
    vd.IDBCFILLE
FROM
    VENTE_DETAILS vd LEFT JOIN
    BL_CLIENT_FILLE_grp_vente bl ON vd.ID = bl.idventedetail
                     LEFT JOIN AS_INGREDIENTS p ON
        p.id = vd.IDPRODUIT
                     left join AS_UNITE u on u.id = vd.unite;


create or replace view BC_CLIENT_FILLE_CPL_LIB as
SELECT bcf.ID,
       bcf.PRODUIT,
       bcf.IDBC,
       bcf.QUANTITE,
       bcf.PU,
       bcf.MONTANT,
       bcf.TVA,
       bcf.REMISE,
       bcf.IDDEVISE,
       bcf.UNITE,
       i.LIBELLE                                                                                                                                      AS PRODUITlib,
       i.compte_vente                                                                                                                                 AS compte,
       NVL(bcf.quantite, 0) - NVL(vdbc.qte, 0)                                                                                                        AS qtereste,
       au.val                                                                                                                                         AS UNITELIB,
       cast(NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) as Number(30, 2))                                                                                   AS MONTANTTOTAL,
       cast(((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100)) as number(30, 2))                                                          as montantdelaremise,
       cast((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) - ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100))) *
            (bcf.ristourne / 100) as number(30, 2))                                                                                                   as montantristourne,
       cast(NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) - ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100)) -
            ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) - ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100))) *
             (bcf.ristourne / 100)) +
            nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0) as number(30, 2))                                                                    as montantremise,
       CAST(
               (((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) -
                 (((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100)) +
                  ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) -
                    ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100))) * (bcf.ristourne / 100))) +
                 nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0)) *
                (nvl(bcf.TVA, 0) / 100))
           AS NUMBER(30, 2)
       )                                                                                                                                              AS MONTANTTVA,
       cast((cast((bcf.quantite * bcf.PU) - ((bcf.quantite * bcf.PU) * NVL(bcf.remise, 0)) / 100 as NUMBER(30, 2)) -
             (cast((bcf.quantite * bcf.PU) - ((bcf.quantite * bcf.PU) * NVL(bcf.remise, 0)) / 100 as NUMBER(30, 2)) *
              nvl(bcf.ristourne, 0) /
              100) + nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0)) + (nvl(bcf.TVA, 0) / 100) *
                                                                             (cast((bcf.quantite * bcf.PU) -
                                                                                   ((bcf.quantite * bcf.PU) * NVL(bcf.remise, 0)) /
                                                                                   100 as NUMBER(30, 2)) -
                                                                              (cast((bcf.quantite * bcf.PU) -
                                                                                    ((bcf.quantite * bcf.PU) * NVL(bcf.remise, 0)) /
                                                                                    100 as NUMBER(30, 2)) *
                                                                               nvl(bcf.ristourne, 0) / 100) +
                                                                              nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0)) as number(30, 2)) AS MONTANTTTC,
       bcf.ristourne,
       nvl(i.CALORIE * bcf.QUANTITE * bc.fraislivraison, 0)                                                                                           as fraistransport,
       nvl(i.CALORIE * bcf.QUANTITE, 0)                                                                                                               as poidstotal,
       bcf.TAUXDECHANGE,cast(nvl(blf.QUANTITE,0) as number(30,2)) as qtelivre,
       cast(nvl(vdbc.qte,0) as number(30,2)) as qteFacture
FROM bondecommande_client_fille bcf
         left JOIN as_ingredients i ON i.id = bcf.PRODUIT
         LEFT JOIN vente_details_qte_grp vdbc ON bcf.id = vdbc.idbcfille
         LEFT JOIN AS_UNITE au ON au.id = i.unite
         LEFT JOIN BONDECOMMANDE_CLIENT bc on bc.id = bcf.IDBC
         left join as_BLClientFilleGrpBCFille blf on blf.IDBC_FILLE=bcf.id
WHERE i.ACTIF = 1;

