alter table AS_BONDELIVRAISON_CLIENT add lieudelivraison varchar2(250);

create or replace view AS_BONDELIVRAISON_CLIENT_CPL as
SELECT bl.id, bl.remarque,
       v.id AS idvente,
       v.designation,
       bl.idbc, bl.daty, bl.etat,
       m.id AS idmagasin,
       m.val AS magasin,
       v.IDRESERVATION,
       c.nom AS IDCLIENTlib,
       bl.vehicule,
       bl.chauffeur,
       bl.description,
       c.id AS idClient,
       CASE
           WHEN bl.ETAT = 1  THEN 'Crée'
           WHEN bl.ETAT = 11 THEN 'Validée'
           WHEN bl.ETAT = 3 THEN 'BL Préparé (En attente de livraison)'
           ELSE 'Autre'
           END AS etatlib,
       LIEUDELIVRAISON
FROM AS_BONDELIVRAISON_CLIENT bl
         LEFT JOIN MAGASINPOINT m ON bl.magasin=m.id
         LEFT JOIN vente v ON v.id=bl.idvente
         LEFT JOIN client c ON c.ID = bl.IDCLIENT;

create view PROFORMADETAILS_CPL_PDF as
SELECT vd.ID,
       vd.IDPROFORMA,
       vd.IDPRODUIT,
       vd.IDORIGINE,
       vd.QTE,
       vd.PU,
       vd.REMISE,
       vd.TVA,
       vd.PUACHAT,
       vd.PUVENTE,
       v.IDDEVISE,
       vd.TAUXDECHANGE,
       vd.DESIGNATION,
       vd.COMPTE,
       vd.PUREVIENT,
       vd.IDDEMANDEPRIXFILLE,
       v.DESIGNATION                                                                                       AS IDPROFORMALIB,
       p.LIBELLE                                                                                           AS IDPRODUITLIB,
       cast((vd.QTE * vd.PU) as NUMBER(30, 2))                                                             AS puTotal,
       vd.unite,
       au.val                                                                                              AS uniteLib,
       cast(((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2))                                 AS remisemontant,
       cast((cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) * nvl(vd.ristourne, 0) /
             100) as number(30, 2))                                                                                               as montantristourne,
       cast(nvl(p.CALORIE * vd.QTE * v.fraislivraison, 0) as number(30, 2))                                as fraistransport,
       cast((cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) -
             (cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) * nvl(vd.ristourne, 0) /
              100)) +
            nvl(p.CALORIE * vd.QTE * v.fraislivraison, 0) as number(30 ,2))                                                       as montanttotal,
       cast((nvl(vd.TVA, 0) / 100) *
            ((cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) -
              (cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) *
               nvl(vd.ristourne, 0) /
               100)) +
             nvl(p.CALORIE * vd.QTE * v.fraislivraison, 0)) as number(30,2))                                                     as montanttva,
       cast(((cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) -
              (cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) *
               nvl(vd.ristourne, 0) /
               100)) + nvl(p.CALORIE * vd.QTE * v.fraislivraison, 0)) + (nvl(vd.TVA, 0) / 100) *
                                                                        ((cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) -
                                                                          (cast((vd.QTE * vd.PU) - ((vd.QTE * vd.PU) * NVL(vd.remise, 0)) / 100 as NUMBER(30, 2)) *
                                                                           nvl(vd.ristourne, 0) / 100)) +
                                                                         p.CALORIE * vd.QTE *
                                                                         v.fraislivraison) as number(30, 2))                      as montantttc,
       vd.datedebut,
       cast(nvl(p.calorie, 0) as number(10,2))                                                                                   as CALORIE,
       vd.ristourne                                                                                        as ristourne,
       cast(p.CALORIE as number(30, 2))                                                                    as poidsparkilo,
       cast(v.fraislivraison as number(30, 2))                                                             as fraislivraison,
       cast(p.CALORIE * vd.QTE as number(30, 2))                                                           as poidstotal,
       p.CATEGORIEINGREDIENT
--       d2.id AS idDevis
FROM PROFORMA_DETAILS vd
         LEFT JOIN PROFORMA v ON v.ID = vd.IDPROFORMA
         LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
         LEFT JOIN AS_UNITE au ON au.id = vd.unite;


create or replace view BC_CLIENT_FILLE_CPL_LIB_PDF as
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
       cast(nvl(vdbc.qte,0) as number(30,2)) as qteFacture,
       i.CATEGORIEINGREDIENT
FROM bondecommande_client_fille bcf
         left JOIN as_ingredients i ON i.id = bcf.PRODUIT
         LEFT JOIN vente_details_qte_grp vdbc ON bcf.id = vdbc.idbcfille
         LEFT JOIN AS_UNITE au ON au.id = i.unite
         LEFT JOIN BONDECOMMANDE_CLIENT bc on bc.id = bcf.IDBC
         left join as_BLClientFilleGrpBCFille blf on blf.IDBC_FILLE=bcf.id
WHERE i.ACTIF = 1;


