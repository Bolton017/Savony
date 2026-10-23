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
       cast(v2.MONTANTTOTAL as number(30,2)) as MONTANTTOTAL,
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
       v.IDZONECLIENT,
       zc.val as IDZONECLIENTLIB,
       --    nanampy an'ito ETATBC ito
       CASE
           WHEN bc.ID IS NOT NULL THEN 'BC Cr&eacute;er'
           ELSE 'BC non Cr&eacute;er'
           END                                                                                AS ETATBC
FROM PROFORMA v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
         JOIN PROFORMAMONTANT2 v2 ON v2.ID = v.ID
         LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id = mv.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN ZONECLIENT zc on zc.ID = v.IDZONECLIENT
         LEFT JOIN BONDECOMMANDE_CLIENT bc ON bc.IDPROFORMA = v.ID;