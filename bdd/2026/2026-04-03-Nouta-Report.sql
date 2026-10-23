CREATE OR REPLACE  VIEW "RELEVECLIENT" ("ID", "JOURNAL", "REFERENCE", "DATY", "LIBELLE", "LETTRE", "DEBIT", "CREDIT", "IDCLIENT", "CLIENTLIB", "COMPTE", "UPDATED_AT", "SOLDE") AS 
  select relever.ID,
       relever.JOURNAL,
       relever.REFERENCE,
       relever.DATY,
       relever.LIBELLE,
       relever.LETTRE,
       relever.DEBIT,
       relever.CREDIT,
       relever.IDCLIENT,
       t.NOM as clientlib,
       t.COMPTE,
       relever.updated_at,relever.solde
from (select id,
             ' '                      as journal,
             id                       as reference,
             daty,
             'NOTE DE CREDIT :' || id as libelle,
             ' '                      as lettre,
             0                        as debit,
             MONTANTTTCAR             as credit,
             IDCLIENT,
             DATY as updated_at,
             MONTANTTTCAR*-1 as solde
      from AVOIRFCLIB_CPL_VISEE
  UNION ALL
      select id,
             ' '           as journal,
             NUMEROFACTURE as reference,
             daty,
             case when REFERENCES_PAIEMENT is null then ' ' else REFERENCES_PAIEMENT end,
             ' '           as lettre,
             MONTANTTTCAR  as debit,
             0             as credit,
             IDCLIENT,
             UPDATED_AT as updated_at,
             MONTANTTTCAR as solde
      from MOUVEMENTCAISSE_DETAIL_UNIQUE
      where ETAT >= 7
  UNION ALL
      select mc.id,
             ' '        as journal,
             mc.id      as reference,
             mc.datycomptabilisation,
             mc.DESIGNATION,
             ' '        as lettre,
             0          as debit,
             mc.CREDIT,
             mc.IDTIERS as idclient,
             mc.UPDATED_AT,
             mc.CREDIT*-1 as solde
      from MOUVEMENTCAISSECPL mc where ETAT > 8 ) relever
         left join tiers t on t.id = relever.IDCLIENT
order by IDCLIENT, DATY, updated_at
 
 
 ;
 








-- SAVONNERIE0126.AVOIRFCLIB_CPL_VISEE source

CREATE OR REPLACE  VIEW "AVOIRFCLIB_CPL_VISEE" ("ID", "DESIGNATION", "IDMAGASIN", "IDMAGASINLIB", "DATY", "REMARQUE", "ETAT", "IDORIGINE", "IDCLIENT", "COMPTE", "IDVENTE", "IDVENTELIB", "IDMOTIF", "IDMOTIFLIB", "IDCATEGORIE", "IDCATEGORIELIB", "IDDEVISE", "TAUXDECHANGE", "MONTANTHT", "MONTANTTVA", "MONTANTTTC", "MONTANTHTAR", "MONTANTTVAAR", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTPAYEAR", "RESTEAPAYER", "RESTEAPAYERAR", "IMPUTEEFACT", "IMPUTEEFACTAR") AS 
  select ID,
       DESIGNATION,
       IDMAGASIN,
       IDMAGASINLIB,
       DATY,
       REMARQUE,
       ETAT,
       IDORIGINE,
       IDCLIENT,
       COMPTE,
       IDVENTE,
       IDVENTELIB,
       IDMOTIF,
       IDMOTIFLIB,
       IDCATEGORIE,
       IDCATEGORIELIB,
       IDDEVISE,
       TAUXDECHANGE,
       MONTANTHT,
       MONTANTTVA,
       MONTANTTTC,
       MONTANTHTAR,
       MONTANTTVAAR,
       MONTANTTTCAR,
       MONTANTPAYE,
       MONTANTPAYEAR,
       RESTEAPAYER,
       RESTEAPAYERAR,
       MONTANTTTC - MONTANTPAYE     as imputeefact,
       MONTANTTTCar - MONTANTPAYEar as imputeefactar
from avoirfclib_cpl
where ETAT >= 11
 
 
 ;
 


-- SAVONNERIE0126.AVOIRFCLIB_CPL source

CREATE OR REPLACE  VIEW "AVOIRFCLIB_CPL" ("ID", "DESIGNATION", "IDMAGASIN", "IDMAGASINLIB", "DATY", "REMARQUE", "ETAT", "IDORIGINE", "IDCLIENT", "COMPTE", "IDVENTE", "IDVENTELIB", "IDMOTIF", "IDMOTIFLIB", "IDCATEGORIE", "IDCATEGORIELIB", "IDDEVISE", "TAUXDECHANGE", "MONTANTHT", "MONTANTTVA", "MONTANTTTC", "MONTANTHTAR", "MONTANTTVAAR", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTPAYEAR", "MONTANT_RESTE_FACTURE", "MONTANT_AVOIRS_ANTERIEURS", "RESTE_CALCULE", "EXCEDENT_AR", "RESTEAPAYER", "RESTEAPAYERAR", "CLIENTLIB", "TYPEAVOIR") AS 
  SELECT AL.ID,
       AL.DESIGNATION,
       AL.IDMAGASIN,
       AL.IDMAGASINLIB,
       AL.DATY,
       AL.REMARQUE,
       AL.ETAT,
       AL.IDORIGINE,
       AL.IDCLIENT,
       AL.COMPTE,
       AL.IDVENTE,
       AL.IDVENTELIB,
       AL.IDMOTIF,
       AL.IDMOTIFLIB,
       AL.IDCATEGORIE,
       AL.IDCATEGORIELIB,
       AL.IDDEVISE,
       AL.TAUXDECHANGE,
       AL.MONTANTHT,
       AL.MONTANTTVA,
       AL.MONTANTTTC,
       AL.MONTANTHTAR,
       AL.MONTANTTVAAR,
       AL.MONTANTTTCAR,
       nvl(M.montant, 0)                                        AS MONTANTPAYE,
       NVL(M.montant, 0) * NVL(AL.TAUXDECHANGE, 0)              AS MONTANTPAYEAR,

       NVL(vc.MONTANTRESTE, 0)                                  AS MONTANT_RESTE_FACTURE,

       NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0)         AS MONTANT_AVOIRS_ANTERIEURS,
       -- Cas 1 : facture deja soldee -> chaque avoir = credit direct (exedent)
       CASE
           WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN 0
           ELSE NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0)
           END                                                  AS RESTE_CALCULE,
       -- Excedent a rembourser ou a reporter
       CASE
           WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN NVL(AL.MONTANTTTCAR, 0)
           WHEN NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0) < 0
               THEN ABS(NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) -
                        NVL(AL.MONTANTTTCAR, 0))
           ELSE 0
           END                                                  AS EXCEDENT_AR,
       (CASE
            WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN NVL(AL.MONTANTTTCAR, 0)
            WHEN NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0) <
                 0
                THEN ABS(NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) -
                         NVL(AL.MONTANTTTCAR, 0))
            ELSE 0
           END) - NVL(M.montant, 0)                             AS resteapayer,
       (CASE
            WHEN NVL(vc.MONTANTRESTE, 0) = 0 THEN NVL(AL.MONTANTTTCAR, 0)
            WHEN NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) - NVL(AL.MONTANTTTCAR, 0) <
                 0
                THEN ABS(NVL(vc.MONTANTRESTE, 0) - NVL(SUM_PRECEDENTS.montant_avoirs_precedents, 0) -
                         NVL(AL.MONTANTTTCAR, 0))
            ELSE 0
           END) - (NVL(M.montant, 0) * NVL(AL.TAUXDECHANGE, 0)) AS resteapayerar,
       AL.clientlib,
       AL.Typeavoir
FROM AVOIRFCLIB AL
         LEFT JOIN MOUVEMENTCAISSEGRPAVOIR_LP M
                   ON AL.ID = M.IDORIGINE
         LEFT JOIN VENTE_CPL_SANSAVOIR vc
                   ON vc.id = AL.idvente
-- Somme des avoirs precedents pour la meme facture
         LEFT JOIN (SELECT a2.idvente,
                           a2.id                AS idcourant,
                           SUM(a1.MONTANTTTCAR) AS montant_avoirs_precedents
                    FROM AVOIRFCLIB a1
                             JOIN AVOIRFCLIB a2 ON a1.idvente = a2.idvente
                    WHERE a1.ETAT <> 0
                      AND (a1.DATY < a2.DATY OR (a1.DATY = a2.DATY AND a1.ID < a2.ID))
                    GROUP BY a2.idvente, a2.id) SUM_PRECEDENTS
                   ON SUM_PRECEDENTS.idvente = AL.idvente
                       AND SUM_PRECEDENTS.idcourant = AL.id
 
 
 ;
 



-- SAVONNERIE0126.VENTE_CPL_SANSAVOIR source

CREATE OR REPLACE  VIEW "VENTE_CPL_SANSAVOIR" ("ID", "DESIGNATION", "IDMAGASIN", "IDMAGASINLIB", "DATY", "REMARQUE", "ETAT", "ETATLIB", "MONTANTTOTAL", "IDDEVISE", "IDCLIENT", "IDCLIENTLIB", "MONTANTTVA", "MONTANTTTC", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTRESTE", "TAUXDECHANGE", "MONTANTREVIENT", "MARGEBRUTE", "IDRESERVATION", "DATYPREVU", "REFERENCEFACTURE", "MONTANTREMISE", "MONTANT", "MOIS", "ANNEE", "POIDS", "MODEPAIEMENT", "MODEPAIEMENTLIB", "FRAISLIVRAISON", "MODELIVRAISON", "MODELIVRAISONLIB", "RESTE", "IDPROVINCE", "PROVINCELIB") AS 
  SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL                                                        AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CREE'
           WHEN v.ETAT = 11 THEN 'VISE'
           WHEN v.ETAT = 0 THEN 'ANNULE'
           END
                                                                    AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM                                                        AS IDCLIENTLIB,
       cast(V2.MONTANTTVA as number(30, 2))                         as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30, 2))                         as montantttc,
       cast(V2.MONTANTTTCAR as number(30, 2))                       as MONTANTTTCAR,
       cast(nvl(mv.montant, 0) AS NUMBER(30, 2))                    AS montantpaye,
       cast(V2.MONTANTTTC - nvl(mv.montant, 0) AS NUMBER(30, 2))    AS montantreste,
       v2.tauxDeChange                                              AS tauxDeChange,
       v2.MONTANTREVIENT,
       cast((V2.MONTANTTTCAR - v2.MONTANTREVIENT) as number(20, 2)) as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then daty else V.DATYPREVU end as datyprevu,
       rf.REFERENCE                                                 as referencefacture,
       v2.MONTANTREMISE,
       nvl(v2.MONTANTTOTAL, 0) + nvl(v2.MONTANTREMISE, 0)           as montant,
       extract(month from DATY)                                     as mois,
       extract(year from DATY)                                      as annee,
       vp.poids,
       v.modepaiement,
       mp.VAL                                                       as modepaiementlib,
       nvl(v.fraislivraison, 0) * nvl(vp.poids, 0)                  as fraislivraison,
       v.modelivraison,
       CASE
           WHEN v.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
           WHEN v.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
           END                                                      AS modelivraisonlib,
       vr.reste,
       pv.id                                                        as idprovince,
       pv.val                                                       as provincelib
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         left join PROVINCE pv on pv.id = c.IDPROVINCE
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id = mv.id2
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture = v.Id
         left join vente_poids vp on vp.idvente = v.id
         left join MODEPAIEMENT mp on mp.id = v.modepaiement
         left join vente_reste vr on vr.idvente = v.id

 
 
 ;
 
-- SAVONNERIE0126.VENTE_POIDS source

CREATE OR REPLACE  VIEW "VENTE_POIDS" ("IDVENTE", "POIDS", "COLIS") AS 
  select IDVENTE,sum(poids) as poids, sum(QTE) as colis from VENTE_DETAILS_POIDS group by IDVENTE
 
 
 ;
 



-- SAVONNERIE0126.VENTE_DETAILS_POIDS source

CREATE OR REPLACE  VIEW "VENTE_DETAILS_POIDS" ("ID", "IDVENTE", "IDPRODUIT", "IDORIGINE", "QTE", "PU", "REMISE", "TVA", "PUACHAT", "PUVENTE", "IDDEVISE", "TAUXDECHANGE", "DESIGNATION", "COMPTE", "PUREVIENT", "IDBCFILLE", "UNITE", "UNITELIB", "PUNET", "MONTANTHT", "MONTANTTTC", "MONTANTTVA", "MONTANTREMISE", "MONTANT", "POIDS", "RESTE", "FRAIS", "IDPRODUITLIB", "DATY", "DATYPREVU", "IDDEVISELIB", "IDCATEGORIELIB", "CATEGORIEPRODUITLIB", "PUTOTAL", "IDCLIENTLIB", "RISTOURNE") AS 
  SELECT v.ID,
       v.IDVENTE,
       v.IDPRODUIT,
       v.IDORIGINE,
       CAST(v.QTE AS NUMBER(38, 2)) AS QTE,
       v.PU,
       v.REMISE,
       v.TVA,
       v.PUACHAT,
       v.PUVENTE,
       v.IDDEVISE,
       v.TAUXDECHANGE,
       v.DESIGNATION,
       v.COMPTE,
       v.PUREVIENT,
       v.IDBCFILLE,
       v.UNITE,
       v.UNITELIB,
       v.PUNET,
       v.MONTANTHT,
       cast(v.MONTANTTTC as number(30,2)) as MONTANTTTC,
       cast(v.MONTANTTVA as number(30,2)) as montanttva,
       v.MONTANTREMISE,
       v.MONTANT,
       v.poids,
       vc.RESTE                     AS RESTE,
       v.frais                      AS FRAIS,
       v.IDPRODUITLIB,
       v.DATY,
       v.DATYPREVU                  AS DATYPREVU,
       v.IDDEVISE                   AS IDDEVISELIB,
       v.IDCATEGORIELIB,
       v.CATEGORIEPRODUITLIB,
       montantttc                   AS PUTOTAL,
       v.idclientlib,
       v.RISTOURNE                  AS RISTOURNE
FROM VENTE_DETAILS_VIDE v
         LEFT JOIN EQUIVALENCE e
                   ON e.IDPRODUIT = v.IDPRODUIT
                       AND e.IDUNITE = v.UNITE
         LEFT JOIN VENTE_DETAILS_RESTE vc
                   ON vc.ID = v.ID
         LEFT JOIN Vente ve
                   ON ve.ID = v.IDVENTE
         LEFT JOIN VENTE_DETAILS vdc
                   ON vdc.ID = ve.ID
 
 
 ;
 

-- SAVONNERIE0126.VENTE_DETAILS_VIDE source

CREATE OR REPLACE  VIEW "VENTE_DETAILS_VIDE" ("ID", "IDVENTE", "IDPRODUIT", "IDORIGINE", "QTE", "PU", "REMISE", "TVA", "PUACHAT", "PUVENTE", "IDDEVISE", "TAUXDECHANGE", "DESIGNATION", "COMPTE", "PUREVIENT", "IDBCFILLE", "UNITE", "UNITELIB", "PUNET", "FRAIS", "MONTANTHT", "MONTANTTTC", "MONTANTTVA", "MONTANTREMISE", "MONTANT", "RISTOURNE", "IDCLIENTLIB", "DATY", "DATYPREVU", "IDPRODUITLIB", "IDCATEGORIELIB", "CATEGORIEPRODUITLIB", "POIDS", "IDPREVISION") AS 
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
       cast(nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0) as number(30, 2))                                          as frais,
       cast(((p.pu - (p.pu * p.remise / 100)) * p.qte + nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) *
                                                    NVL(p.QTE, 0)) as number(30,2))                                                  as montantht,
       cast(((p.pu - (p.pu * p.remise / 100)) * p.qte + nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0)) +
            ((((p.pu * p.qte) - (p.pu * p.remise / 100) * qte) +
              nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) * NVL(p.QTE, 0)) * p.tva /
             100) as number(30, 2))                                                                                                   as montantttc,
       cast(((((p.pu * qte) - (p.pu * p.remise / 100) * qte) + nvl(v.fraislivraison, 0) * NVL(ing.CALORIE, 0) *
                                                             NVL(p.QTE, 0)) * p.tva / 100) as number(30,2))                                            as montanttva,
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
                   
                  
                  
CREATE OR REPLACE  VIEW "CAISSECPL" ("ID", "VAL", "DESCE", "IDTYPECAISSE", "IDTYPECAISSELIB", "IDPOINT", "IDPOINTLIB", "IDPOMPISTE", "ETAT", "COMPTE", "ETATLIB", "IDCATEGORIECAISSE", "IDCATEGORIECAISSELIB", "IDMAGASIN", "IDMAGASINLIB") AS 
  SELECT c.ID,
       c.VAL,
       c.DESCE,
       c.IDTYPECAISSE,
       t.VAL   AS IDTYPECAISSELIB,
       c.IDPOINT,
       p.VAL   AS IDPOINTLIB,
       c.IDPOMPISTE,
       c.ETAT,
       cop.LIBELLE||'('||c.COMPTE||')' as compte ,
       CASE
           WHEN c.ETAT = 0
               THEN 'ANNULEE'
           WHEN c.ETAT = 1
               THEN 'CREE'
           WHEN c.ETAT = 11
               THEN 'VISEE'
           END AS ETATLIB,
       c.idCategorieCaisse,
       c2.VAL  AS idCategorieCaisseLib,
       c.IDMAGASIN ,
       m.val AS idMagasinLib
FROM CAISSE c
         LEFT JOIN TYPECAISSE t ON t.ID = c.IDTYPECAISSE
         LEFT JOIN POINT p ON p.IDlocalisation = c.IDPOINT
         LEFT JOIN CATEGORIECAISSE c2 ON c2.ID = c.idCategorieCaisse
         LEFT JOIN COMPTA_COMPTE cop ON cop.ID = c.COMPTE
         LEFT JOIN MAGASIN2 m ON m.ID =c.IDMAGASIN 
       
 
 
 ;