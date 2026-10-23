update COMPTA_COMPTE set libelle ='compte client' where COMPTE='41110000';

update COMPTA_COMPTE set libelle ='transport client' where COMPTE='72004';

create view AVOIRFCMONTANT as
SELECT a.ID,
       a.DESIGNATION,
       a.IDMAGASIN,
       ''         AS IDMAGASINLIB,
       a.DATY,
       a.REMARQUE,
       a.ETAT,
       a.IDORIGINE,
       a.IDCLIENT,
       '' as COMPTE,
        '' as compteauxiliaire,
       a.IDVENTE,
       '' AS IDVENTELIB,
       a.IDMOTIF,
       ''        AS IDMOTIFLIB,
       a.IDCATEGORIE,
       ''         AS IDCATEGORIELIB,
       ag.IDDEVISE,
       ag.TAUXDECHANGE,
       ag.MONTANTHT,
       ag.MONTANTTVA,
       ag.MONTANTTTC,
       ag.MONTANTHTAR,
       ag.MONTANTTVAAR,
       ag.MONTANTTTCAR,
        '' as IDRESERVATION,
       ''        as Typeavoir,
       ''         as clientlib,
       NVL(M.montant, 0) * NVL(ag.TAUXDECHANGE, 0)              AS MONTANTPAYEAR
FROM AVOIRFC a
         --LEFT JOIN magasin2 m ON m.id = a.IDMAGASIN
         --LEFT JOIN VENTE v ON v.id = a.IDVENTE
         --LEFT JOIN MOTIFAVOIRFC ma ON ma.id = a.IDMOTIF
         --LEFT JOIN CATEGORIEAVOIRFC c ON c.id = a.IDCATEGORIE
         JOIN AVOIRFCFILLE_GRP ag ON ag.idavoirfc = a.id
         --LEFT JOIN TIERS T ON T.ID = A.IDCLIENT
         LEFT JOIN MOUVEMENTCAISSEGRPAVOIR_LP M
                   ON A.ID = M.IDORIGINE
where a.ETAT>=11 and a.IDORIGINE is not null
/



create or replace view VENTE_CPL as
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
       cast(nvl(V2.MONTANTTTC, 0) - nvl(mv.montant, 0) - nvl(ACG.MONTANTTTCAR-acg.MONTANTPAYEAR, 0) AS NUMBER(30, 2)) AS montantreste,
       cast(nvl(ACG.MONTANTTTCAR, 0) as number(30, 2))                                             as avoir,
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
       UPPER(
               v.DESIGNATION || ' ' ||
               NVL(c.NOM, '') || ' ' ||
               NVL(m.VAL, '') || ' ' ||
               NVL(pv.val, '') || ' ' ||
               NVL(v.NUMEROFACTURE, '') || ' ' ||
               NVL(rf.REFERENCE, '') || ' ' ||
               NVL(mp.VAL, '') || ' ' ||
               TO_CHAR(v.DATY, 'DD/MM/YYYY')
       ) AS motsClesss,
       com.nom||com.prenom AS commerciallib,
       zc.val as IDZONECLIENTLIB
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         left join PROVINCE pv on pv.id = c.IDPROVINCE
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id = mv.id2
         LEFT JOIN AVOIRFCMONTANT ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture = v.Id
         left join vente_poids vp on vp.idvente = v.id
         left join MODEPAIEMENT mp on mp.id = v.modepaiement
         left join vente_reste vr on vr.idvente = v.id
         LEFT JOIN log_personnel com ON com.id=v.commercial
         LEFT JOIN ZONECLIENT zc on zc.ID = v.IDZONECLIENT

/