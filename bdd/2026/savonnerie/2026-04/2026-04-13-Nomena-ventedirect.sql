create view VENTE_CPL as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL                                                                                         AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
           WHEN v.ETAT = 11 THEN 'VIS&Eacute;E'
           WHEN v.ETAT = 0 THEN 'ANNUL&Eacute;E'
           END
                                                                                                     AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM                                                                                         AS IDCLIENTLIB,
       cast(V2.MONTANTTVA as number(30, 2))                                                          as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30, 2))                                                          as montantttc,
       cast(V2.MONTANTTTCAR as number(30, 2))                                                        as MONTANTTTCAR,
       cast(nvl(mv.montant, 0) AS NUMBER(30, 2))                                                     AS montantpaye,
       cast(nvl(V2.MONTANTTTC, 0) - nvl(mv.montant, 0) - nvl(ACG.imputeefactar, 0) AS NUMBER(30, 2)) AS montantreste,
       cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30, 2))                                             as avoir,
       v2.tauxDeChange                                                                               AS tauxDeChange,
       v2.MONTANTREVIENT,
       cast((V2.MONTANTTTCAR - v2.MONTANTREVIENT) as number(20, 2))                                  as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then v.daty else V.DATYPREVU end                                as datyprevu,
       rf.REFERENCE                                                                                  as referencefacture,
       v2.MONTANTREMISE,
       nvl(v2.MONTANTTOTAL, 0) + nvl(v2.MONTANTREMISE, 0)                                            as montant,
       extract(month from v.DATY)                                                                    as mois,
       extract(year from v.DATY)                                                                     as annee,
       CAST(vp.poids as number(30, 2))                                                               as poids,
       CAST(vp.colis as number(30, 2))                                                               as colis,
       v.modepaiement,
       mp.VAL                                                                                        as modepaiementlib,
       nvl(v.fraislivraison, 0) * nvl(vp.poids, 0)                                                   as fraislivraison,
       v.modelivraison,
       CASE
           WHEN v.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
           WHEN v.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
           END                                                                                       AS modelivraisonlib,
       vr.reste,
       pv.id                                                                                         as idprovince,
       pv.val                                                                                        as provincelib,
       --bl.id                                                                                         as idbl,
       v.IDORIGINE,
       v.FRAISLIVRAISON                                                                              as frais,
       v.REFERENCEFACT,
       v.NUMEROFACTURE,
       v.LIEULIVRAISON,
       v.DATELIVRAISON,
       v.UPDATED_AT,
       v.ECHEANCEFACTURE,
       nvl(mv2.MONTANTRETOURNER, 0) as montantretourner,
       pers.nom AS idResponsablelib

FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         left join PROVINCE pv on pv.id = c.IDPROVINCE
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN mouvementcaisseGroupeFacture mv2 ON v.id in mv2.IDORIGINE
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id = mv.id2
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture = v.Id
         left join vente_poids vp on vp.idvente = v.id
         left join MODEPAIEMENT mp on mp.id = v.modepaiement
         left join vente_reste vr on vr.idvente = v.id
         LEFT JOIN PERSONNEl pers ON pers.id = v.idResponsable;


CREATE OR REPLACE VIEW VENTE_DETAILS_POIDS AS
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
       v.montantttc                 AS PUTOTAL, -- Correction ici : ajout de v.
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
                   ON vdc.ID = ve.ID;

ALTER TABLE VENTE_DETAILS ADD MONTANTTTC NUMBER(30, 2);
CREATE OR REPLACE TRIGGER TRG_VENTE_DETAILS_MONTANTTTC
    BEFORE INSERT OR UPDATE ON VENTE_DETAILS
                                FOR EACH ROW
BEGIN
    :NEW.MONTANTTTC := :NEW.PU * :NEW.QTE;
END;