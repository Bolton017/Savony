create or replace view PROFORMA_CPL as
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL                                                                                  AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
           WHEN v.ETAT = 11 THEN 'VIS&Eacute;E'
           WHEN v.ETAT = 0 THEN 'ANNUL&Eacute;E'
           END
                                                                                              AS ETATLIB,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.CODECLIENT,
       c.NOM                                                                                  AS IDCLIENTLIB,
       c.ADRESSE,
       c.TELEPHONE                                                                            AS CONTACT,
       cast(V2.POIDSTOTAL as number(30, 2))                                                   as poidstotal,
       cast(V2.montant as number(30, 2))                                                      as montant,
       cast(V2.montantremise as number(30, 2))                                                as MONTANTREMISE,
       cast(V2.montantristourne as number(30, 2))                                             as MONTANTRistourne,
       cast(nvl(v.fraislivraison, 0) as number(10,2)) as fraislivraison,
       cast(V2.FRAISTRANSPORT as number(30, 2))                                               as fraistransport,
       v2.MONTANTTOTAL,
       cast(V2.MONTANTTVA as number(30, 2))                                                   as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30, 2))                                                   as montantttc,
       cast(V2.MONTANTTTCAR as number(30, 2))                                                 as MONTANTTTCAR,
       cast(nvl(mv.credit, 0) - nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30, 2))                     AS montantpaye,
       cast(V2.MONTANTTTC - nvl(mv.credit, 0) - nvl(ACG.resteapayer_avr, 0) AS NUMBER(30, 2)) AS montantreste,
       nvl(ACG.MONTANTTTC_avr, 0)                                                             as avoir,
       v2.tauxDeChange                                                                        AS tauxDeChange,
       v2.MONTANTREVIENT,
       cast((V2.MONTANTTTCAR - v2.MONTANTREVIENT) as number(20, 2))                           as margeBrute,
       v.IDRESERVATION,
       v.IDORIGINE,
       nvl(v.remise, 0) as remise,
       v.DATEVALIDITE,
       UPPER(
               v.DESIGNATION || ' ' ||
               NVL(c.CODECLIENT, '') || ' ' ||
               NVL(c.NOM, '') || ' ' ||
               NVL(c.ADRESSE, '') || ' ' ||
               NVL(c.TELEPHONE, '') || ' ' ||
               NVL(m.VAL, '') || ' ' ||
               TO_CHAR(v.DATY, 'DD/MM/YYYY') || ' ' ||
               TO_CHAR(v.DATEVALIDITE, 'DD/MM/YYYY')
       ) AS MOTSCLESSS,
       zc.val as IDZONECLIENTLIB
FROM PROFORMA v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
         JOIN PROFORMAMONTANT2 v2 ON v2.ID = v.ID
         LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id = mv.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN ZONECLIENT zc on zc.ID = v.IDZONECLIENT;

create or replace view BONDECOMMANDE_CLIENT_CPL as
SELECT
    bc.ID,
    bc.DATY,
    bc.ETAT,
    bc.REMARQUE,
    bc.DESIGNATION,
    bc.MODEPAIEMENT,
    m.VAL AS MODEPAIEMENTLIB,
    bc.IDCLIENT,
    c.NOM AS IDCLIENTLIB,
    bc.REFERENCE,
    m2.VAL AS IDMAGASINLIB,
    CASE
        WHEN bc.ETAT = 0 THEN '<span style=color: green;>ANNUL&Eacute;</span>'
        WHEN bc.ETAT = 1 THEN '<span style=color: green;>CR&Eacute;&Eacute;</span>'
        WHEN bc.ETAT = 11 THEN '<span style=color: green;>VALID&Eacute;</span>'
        END AS ETATLIB,
    bc.IDPROFORMA,
    nvl(vo.nombre,0) as nbfacture,
    CASE
        WHEN bc.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
        WHEN bc.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
        END AS modelivraisonlib,
    bc.dateLivraison,
    bc.lieuLivraison,
    UPPER(
            NVL(bc.DESIGNATION, '') || ' ' ||
            NVL(bc.REFERENCE, '') || ' ' ||
            NVL(c.NOM, '') || ' ' ||
            NVL(m.VAL, '') || ' ' ||
            NVL(m2.VAL, '') || ' ' ||
            NVL(bc.lieuLivraison, '') || ' ' ||
            NVL(bc.IDPROFORMA, '') || ' ' ||
            TO_CHAR(bc.DATY, 'DD/MM/YYYY') || ' ' ||
            TO_CHAR(bc.dateLivraison, 'DD/MM/YYYY')
    ) AS MOTSCLESSS,
    com.nom||com.prenom AS commerciallib,
    zc.val as IDZONECLIENTLIB
FROM BONDECOMMANDE_CLIENT bc
         LEFT JOIN CLIENT c ON c.id = bc.IDCLIENT
         LEFT JOIN MODEPAIEMENT m ON m.id = bc.MODEPAIEMENT
         LEFT JOIN MAGASIN2 m2 ON m2.id = bc.IDMAGASIN
         left join vente_origine vo on vo.IDORIGINE=bc.id
         LEFT JOIN log_personnel com ON com.id=bc.commercial
         LEFT JOIN ZONECLIENT zc on zc.ID = bc.IDZONECLIENT;


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
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture = v.Id
         left join vente_poids vp on vp.idvente = v.id
         left join MODEPAIEMENT mp on mp.id = v.modepaiement
         left join vente_reste vr on vr.idvente = v.id
         LEFT JOIN log_personnel com ON com.id=v.commercial
         LEFT JOIN ZONECLIENT zc on zc.ID = v.IDZONECLIENT;
