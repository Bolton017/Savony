-- MVTSTOCKLIB source

/*vente*/

CREATE OR REPLACE  VIEW VENTE_CPL (ID, DESIGNATION, IDMAGASIN, IDMAGASINLIB, DATY, REMARQUE, ETAT, ETATLIB, MONTANTTOTAL, IDDEVISE, IDCLIENT, IDCLIENTLIB, MONTANTTVA, MONTANTTTC, MONTANTTTCAR, MONTANTPAYE, MONTANTRESTE, AVOIR, TAUXDECHANGE, MONTANTREVIENT, MARGEBRUTE, IDRESERVATION, DATYPREVU, REFERENCEFACTURE, MONTANTREMISE, MONTANT, MOIS, ANNEE, POIDS, COLIS, MODEPAIEMENT, MODEPAIEMENTLIB, FRAISLIVRAISON, MODELIVRAISON, MODELIVRAISONLIB, RESTE, IDPROVINCE, PROVINCELIB, IDORIGINE, FRAIS, REFERENCEFACT, NUMEROFACTURE, LIEULIVRAISON, DATELIVRAISON, UPDATED_AT, ECHEANCEFACTURE,motsClesss) AS 
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
    ) AS motsClesss
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
 ;

-- PROFORMA_CPL source

CREATE OR REPLACE  VIEW PROFORMA_CPL (ID, DESIGNATION, IDMAGASIN, IDMAGASINLIB, DATY, REMARQUE, ETAT, ETATLIB, IDDEVISE, IDCLIENT, CODECLIENT, IDCLIENTLIB, ADRESSE, CONTACT, POIDSTOTAL, MONTANT, MONTANTREMISE, MONTANTRISTOURNE, FRAISLIVRAISON, FRAISTRANSPORT, MONTANTTOTAL, MONTANTTVA, MONTANTTTC, MONTANTTTCAR, MONTANTPAYE, MONTANTRESTE, AVOIR, TAUXDECHANGE, MONTANTREVIENT, MARGEBRUTE, IDRESERVATION, IDORIGINE, REMISE, DATEVALIDITE,MOTSCLESSS) AS 
  SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL                                                                                  AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CREE'
           WHEN v.ETAT = 11 THEN 'VISEE'
           WHEN v.ETAT = 0 THEN 'ANNULEE'
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
    ) AS MOTSCLESSS
FROM PROFORMA v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASIN2 m ON m.ID = v.IDMAGASIN
         JOIN PROFORMAMONTANT2 v2 ON v2.ID = v.ID
         LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id = mv.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
 ;

-- PROFORMA_CPL_CREE source

CREATE OR REPLACE  VIEW PROFORMA_CPL_CREE (ID, DESIGNATION, IDMAGASIN, IDMAGASINLIB, DATY, REMARQUE, ETAT, ETATLIB, IDDEVISE, IDCLIENT, IDCLIENTLIB, ADRESSE, CONTACT, MONTANT, MONTANTTOTAL, MONTANTREMISE, MONTANTTVA, MONTANTTTC, MONTANTTTCAR, MONTANTPAYE, MONTANTRESTE, AVOIR, TAUXDECHANGE, MONTANTREVIENT, MARGEBRUTE, IDRESERVATION, IDORIGINE, REMISE,MOTSCLESSS) AS 
  SELECT ID,DESIGNATION,IDMAGASIN,IDMAGASINLIB,DATY,REMARQUE,ETAT,ETATLIB,IDDEVISE,IDCLIENT,IDCLIENTLIB,ADRESSE,CONTACT,MONTANT,MONTANTTOTAL,MONTANTREMISE,MONTANTTVA,MONTANTTTC,MONTANTTTCAR,MONTANTPAYE,MONTANTRESTE,AVOIR,TAUXDECHANGE,MONTANTREVIENT,MARGEBRUTE,IDRESERVATION,IDORIGINE,REMISE,MOTSCLESSS FROM PROFORMA_CPL WHERE etat=1
 ;

-- PROFORMA_CPL_VISEE source

CREATE OR REPLACE  VIEW PROFORMA_CPL_VISEE (ID, DESIGNATION, IDMAGASIN, IDMAGASINLIB, DATY, REMARQUE, ETAT, ETATLIB, IDDEVISE, IDCLIENT, IDCLIENTLIB, ADRESSE, CONTACT, MONTANT, MONTANTTOTAL, MONTANTREMISE, MONTANTTVA, MONTANTTTC, MONTANTTTCAR, MONTANTPAYE, MONTANTRESTE, AVOIR, TAUXDECHANGE, MONTANTREVIENT, MARGEBRUTE, IDRESERVATION, IDORIGINE, REMISE,MOTSCLESSS) AS 
  SELECT ID,DESIGNATION,IDMAGASIN,IDMAGASINLIB,DATY,REMARQUE,ETAT,ETATLIB,IDDEVISE,IDCLIENT,IDCLIENTLIB,ADRESSE,CONTACT,MONTANT,MONTANTTOTAL,MONTANTREMISE,MONTANTTVA,MONTANTTTC,MONTANTTTCAR,MONTANTPAYE,MONTANTRESTE,AVOIR,TAUXDECHANGE,MONTANTREVIENT,MARGEBRUTE,IDRESERVATION,IDORIGINE,REMISE,MOTSCLESSS FROM PROFORMA_CPL WHERE etat=11
 ;

-- AS_BONDELIVRAISONCLIENT_LIBCPL source

CREATE OR REPLACE  VIEW AS_BONDELIVRAISONCLIENT_LIBCPL (ID, REMARQUE, IDVENTE, IDBC, DATY, ETAT, MAGASIN, IDORIGINE, IDCLIENT, IDMAGASINLIB, IDCLIENTLIB, ETATLIB,MOTSCLESSS) AS 
  select ab.ID,ab.REMARQUE,ab.IDVENTE,ab.IDBC,ab.DATY,ab.ETAT,ab.MAGASIN,ab.IDORIGINE,ab.IDCLIENT,
m.val AS idmagasinlib,
 c.nom AS idclientlib,
CASE
    WHEN ab.ETAT = 0 THEN '<span style=color: green;>ANNUL&Eacute;</span>'
    WHEN ab.ETAT = 1 THEN '<span style=color: green;>CR&Eacute;&Eacute;</span>'
    WHEN ab.ETAT = 11 THEN '<span style=color: green;>VALID&Eacute;</span>'
END AS ETATLIB,
UPPER(
        NVL(ab.REMARQUE, '') || ' ' ||
        NVL(c.nom, '') || ' ' ||
        NVL(m.val, '') || ' ' ||
        NVL(ab.IDBC, '') || ' ' ||
        NVL(ab.IDVENTE, '') || ' ' ||
        TO_CHAR(ab.DATY, 'DD/MM/YYYY')
    ) AS MOTSCLESSS
from  AS_BONDELIVRAISON_CLIENT  AB
left join MAGASIN2 m on ab.MAGASIN = m.ID
LEFT JOIN client c ON c.id = ab.idclient
 
 
 ;


CREATE OR REPLACE  VIEW AS_BONDELIVRAISONC_LIBCPL_A (ID, REMARQUE, IDVENTE, IDBC, DATY, ETAT, MAGASIN, IDORIGINE, IDCLIENT, IDMAGASINLIB, IDCLIENTLIB, ETATLIB,MOTSCLESSS) AS 
  SELECT ID,REMARQUE,IDVENTE,IDBC,DATY,ETAT,MAGASIN,IDORIGINE,IDCLIENT,IDMAGASINLIB,IDCLIENTLIB,ETATLIB,MOTSCLESSS FROM AS_BONDELIVRAISONCLIENT_LIBCPL WHERE etat=0
 ;
 
-- AS_BONDELIVRAISONC_LIBCPL_C source

CREATE OR REPLACE  VIEW AS_BONDELIVRAISONC_LIBCPL_C (ID, REMARQUE, IDVENTE, IDBC, DATY, ETAT, MAGASIN, IDORIGINE, IDCLIENT, IDMAGASINLIB, IDCLIENTLIB, ETATLIB,MOTSCLESSS) AS 
  SELECT ID,REMARQUE,IDVENTE,IDBC,DATY,ETAT,MAGASIN,IDORIGINE,IDCLIENT,IDMAGASINLIB,IDCLIENTLIB,ETATLIB,MOTSCLESSS FROM AS_BONDELIVRAISONCLIENT_LIBCPL WHERE etat=1 ;

-- AS_BONDELIVRAISONC_LIBCPL_V source

CREATE OR REPLACE  VIEW AS_BONDELIVRAISONC_LIBCPL_V (ID, REMARQUE, IDVENTE, IDBC, DATY, ETAT, MAGASIN, IDORIGINE, IDCLIENT, IDMAGASINLIB, IDCLIENTLIB, ETATLIB,MOTSCLESSS) AS 
  SELECT ID,REMARQUE,IDVENTE,IDBC,DATY,ETAT,MAGASIN,IDORIGINE,IDCLIENT,IDMAGASINLIB,IDCLIENTLIB,ETATLIB,MOTSCLESSS FROM AS_BONDELIVRAISONCLIENT_LIBCPL WHERE etat=11
 
 
 ;
 
 
 
 -- BONDECOMMANDE_CLIENT_CPL source

CREATE OR REPLACE  VIEW BONDECOMMANDE_CLIENT_CPL (ID, DATY, ETAT, REMARQUE, DESIGNATION, MODEPAIEMENT, MODEPAIEMENTLIB, IDCLIENT, IDCLIENTLIB, REFERENCE, IDMAGASINLIB, ETATLIB, IDPROFORMA, NBFACTURE, MODELIVRAISONLIB, DATELIVRAISON, LIEULIVRAISON,MOTSCLESSS) AS 
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
    ) AS MOTSCLESSS
FROM BONDECOMMANDE_CLIENT bc
         LEFT JOIN CLIENT c ON c.id = bc.IDCLIENT
         LEFT JOIN MODEPAIEMENT m ON m.id = bc.MODEPAIEMENT
         LEFT JOIN MAGASIN2 m2 ON m2.id = bc.IDMAGASIN
         left join vente_origine vo on vo.IDORIGINE=bc.id
 ;
 
 
CREATE OR REPLACE  VIEW BONDECOMMANDE_CLIENT_CPL_A (ID, DATY, ETAT, REMARQUE, DESIGNATION, MODEPAIEMENT, MODEPAIEMENTLIB, IDCLIENT, IDCLIENTLIB, REFERENCE, ETATLIB,MOTSCLESSS) AS 
  SELECT ID,DATY,ETAT,REMARQUE,DESIGNATION,MODEPAIEMENT,MODEPAIEMENTLIB,IDCLIENT,IDCLIENTLIB,REFERENCE,ETATLIB,MOTSCLESSS FROM BONDECOMMANDE_CLIENT_CPL WHERE etat=0
 ;

-- BONDECOMMANDE_CLIENT_CPL_C source

CREATE OR REPLACE  VIEW BONDECOMMANDE_CLIENT_CPL_C (ID, DATY, ETAT, REMARQUE, DESIGNATION, MODEPAIEMENT, MODEPAIEMENTLIB, IDCLIENT, IDCLIENTLIB, REFERENCE, ETATLIB,MOTSCLESSS) AS 
  SELECT ID,DATY,ETAT,REMARQUE,DESIGNATION,MODEPAIEMENT,MODEPAIEMENTLIB,IDCLIENT,IDCLIENTLIB,REFERENCE,ETATLIB,MOTSCLESSS FROM BONDECOMMANDE_CLIENT_CPL WHERE etat=1
 ;

CREATE OR REPLACE  VIEW BONDECOMMANDE_CLIENT_CPL_V (ID, DATY, ETAT, REMARQUE, DESIGNATION, MODEPAIEMENT, MODEPAIEMENTLIB, IDCLIENT, IDCLIENTLIB, REFERENCE, ETATLIB,MOTSCLESSS) AS 
  SELECT ID,DATY,ETAT,REMARQUE,DESIGNATION,MODEPAIEMENT,MODEPAIEMENTLIB,IDCLIENT,IDCLIENTLIB,REFERENCE,ETATLIB,MOTSCLESSS FROM BONDECOMMANDE_CLIENT_CPL WHERE etat=11
 ;

 -- AVOIRFCLIB source

CREATE OR REPLACE  VIEW AVOIRFCLIB (ID, DESIGNATION, IDMAGASIN, IDMAGASINLIB, DATY, REMARQUE, ETAT, IDORIGINE, IDCLIENT, COMPTE, COMPTEAUXILIAIRE, IDVENTE, IDVENTELIB, IDMOTIF, IDMOTIFLIB, IDCATEGORIE, IDCATEGORIELIB, IDDEVISE, TAUXDECHANGE, MONTANTHT, MONTANTTVA, MONTANTTTC, MONTANTHTAR, MONTANTTVAAR, MONTANTTTCAR, IDRESERVATION, TYPEAVOIR, CLIENTLIB,MOTSCLESSS) AS 
  SELECT a.ID,
       a.DESIGNATION,
       a.IDMAGASIN,
       m.VAL         AS IDMAGASINLIB,
       a.DATY,
       a.REMARQUE,
       a.ETAT,
       a.IDORIGINE,
       a.IDCLIENT,
       t.COMPTE,
       t.compteauxiliaire,
       a.IDVENTE,
       v.DESIGNATION AS IDVENTELIB,
       a.IDMOTIF,
       ma.VAL        AS IDMOTIFLIB,
       a.IDCATEGORIE,
       c.VAL         AS IDCATEGORIELIB,
       ag.IDDEVISE,
       ag.TAUXDECHANGE,
       ag.MONTANTHT,
       ag.MONTANTTVA,
       ag.MONTANTTTC,
       ag.MONTANTHTAR,
       ag.MONTANTTVAAR,
       ag.MONTANTTTCAR,
       v.IDRESERVATION,
       ta.val        as Typeavoir,
       t.NOM         as clientlib,
       UPPER(
        NVL(a.DESIGNATION, '') || ' ' ||
        NVL(a.REMARQUE, '') || ' ' ||
        NVL(t.NOM, '') || ' ' ||
        NVL(m.VAL, '') || ' ' ||
        NVL(v.DESIGNATION, '') || ' ' ||
        NVL(ma.VAL, '') || ' ' ||
        NVL(c.VAL, '') || ' ' ||
        NVL(ta.val, '') || ' ' ||
        NVL(t.COMPTE, '') || ' ' ||
        TO_CHAR(a.DATY, 'DD/MM/YYYY')
    ) AS MOTSCLESSS
FROM AVOIRFC a
         LEFT JOIN magasin2 m ON m.id = a.IDMAGASIN
         LEFT JOIN VENTE v ON v.id = a.IDVENTE
         LEFT JOIN MOTIFAVOIRFC ma ON ma.id = a.IDMOTIF
         LEFT JOIN CATEGORIEAVOIRFC c ON c.id = a.IDCATEGORIE
         JOIN AVOIRFCFILLE_GRP ag ON ag.idavoirfc = a.id
         LEFT JOIN TIERS T ON T.ID = A.IDCLIENT
         left join TYPEAVOIR ta on ta.id = a.IDTYPEAVOIR;
 
 -- TRAITEMTTRESTE source

CREATE OR REPLACE  VIEW TRAITEMTTRESTE (ID, DATY, TIERS, BANQUE, DATEECHEANCE, ETAT, MONTANT, ESCOMPTE, TOTAL, REFERENCE, MONTANTRESTE, CDCLT, IDBANQUE, IDTYPEPIECE, TYPEPIECE, ETATVERSEMENT, ETATVERSEMENTLIB,MOTSCLESSS) AS 
  SELECT t.ID,
       t.DATY,
       t.TIERS,
       t.BANQUE,
       t.DATEECHEANCE,
       t.ETAT,
       CAST(nvl(t.MONTANT,0) AS NUMBER(30, 2))                          AS montant,
       t.ESCOMPTE,
       CAST(nvl(t.TOTAL,0) AS NUMBER(30, 2))                            AS total,
       t.REFERENCE,
       CAST((nvl(t.total,0) - nvl(tf.montantenlevetraite, 0)) AS NUMBER(30, 2)) AS montantreste,
       t.cdclt,
       t.idbanque,
       t.idtypepiece,
       t.typepiece,
       nvl(te.etatversement, 1)                                  as etatversement,
       case
           when te.etatversement = -2 then 'Encaissee'
           when te.etatversement = 11 then 'Versee'
           else
               'Non Versee' end                                  as etatversementlib,
          UPPER(
        NVL(t.TIERS, '') || ' ' ||
        NVL(t.BANQUE, '') || ' ' ||
        NVL(t.REFERENCE, '') || ' ' ||
        NVL(t.TYPEPIECE, '') || ' ' ||
        NVL(t.CDCLT, '') || ' ' ||
        NVL(t.IDBANQUE, '') || ' ' ||
        TO_CHAR(t.DATY, 'DD/MM/YYYY') || ' ' ||
        TO_CHAR(t.DATEECHEANCE, 'DD/MM/YYYY') || ' ' ||
        NVL(
            CASE
                WHEN te.etatversement = -2 THEN 'ENCAISSEE'
                WHEN te.etatversement = 11 THEN 'VERSEE'
                ELSE 'NON VERSEE'
            END
        , '')
    ) AS MOTSCLESSS
FROM TRAITE_LIBMTT t
         LEFT JOIN traitemttfc tf ON tf.id = t.id
         LEFT JOIN traiteetatversement te on te.IDTRAITE = t.ID
 
 
 ;
 
-- TRAITEMTTRESTE source

CREATE OR REPLACE  VIEW TRAITEMTTRESTE (ID, DATY, TIERS, BANQUE, DATEECHEANCE, ETAT, MONTANT, ESCOMPTE, TOTAL, REFERENCE, MONTANTRESTE, CDCLT, IDBANQUE, IDTYPEPIECE, TYPEPIECE, ETATVERSEMENT, ETATVERSEMENTLIB,MOTSCLESSS) AS 
  SELECT t.ID,
       t.DATY,
       t.TIERS,
       t.BANQUE,
       t.DATEECHEANCE,
       t.ETAT,
       CAST(nvl(t.MONTANT,0) AS NUMBER(30, 2))                          AS montant,
       t.ESCOMPTE,
       CAST(nvl(t.TOTAL,0) AS NUMBER(30, 2))                            AS total,
       t.REFERENCE,
       CAST((nvl(t.total,0) - nvl(tf.montantenlevetraite, 0)) AS NUMBER(30, 2)) AS montantreste,
       t.cdclt,
       t.idbanque,
       t.idtypepiece,
       t.typepiece,
       nvl(te.etatversement, 1)                                  as etatversement,
       case
           when te.etatversement = -2 then 'Encaissee'
           when te.etatversement = 11 then 'Versee'
           else
               'Non Versee' end                                  as etatversementlib,
          UPPER(
        NVL(t.TIERS, '') || ' ' ||
        NVL(t.BANQUE, '') || ' ' ||
        NVL(t.REFERENCE, '') || ' ' ||
        NVL(t.TYPEPIECE, '') || ' ' ||
        NVL(t.CDCLT, '') || ' ' ||
        NVL(t.IDBANQUE, '') || ' ' ||
        TO_CHAR(t.DATY, 'DD/MM/YYYY') || ' ' ||
        TO_CHAR(t.DATEECHEANCE, 'DD/MM/YYYY') || ' ' ||
        NVL(
            CASE
                WHEN te.etatversement = -2 THEN 'ENCAISSEE'
                WHEN te.etatversement = 11 THEN 'VERSEE'
                ELSE 'NON VERSEE'
            END
        , '')
    ) AS MOTSCLESSS
FROM TRAITE_LIBMTT t
         LEFT JOIN traitemttfc tf ON tf.id = t.id
         LEFT JOIN traiteetatversement te on te.IDTRAITE = t.ID
 
 
 ;
 

 -- TRAITE_LIBC source

CREATE OR REPLACE  VIEW TRAITE_LIBC (ID, DATY, TIERS, BANQUE, DATEECHEANCE, ETAT, MONTANT, ETATVERSEMENT, ETATVERSEMENTLIB, MONTANTRESTE, REFERENCE,MOTSCLESSS) AS 
  SELECT ID,DATY,TIERS,BANQUE,DATEECHEANCE,ETAT,MONTANT, etatversement, etatversementlib,MONTANTRESTE,reference,MOTSCLESSS  from TRAITEMTTRESTE where etat = 1
 
 
 ;
 
 
 -- TRAITE_LIBV source

CREATE OR REPLACE  VIEW TRAITE_LIBV (ID, DATY, TIERS, BANQUE, DATEECHEANCE, ETAT, MONTANT, ETATVERSEMENT, ETATVERSEMENTLIB, MONTANTRESTE, REFERENCE,MOTSCLESSS) AS 
  select ID,DATY,TIERS,BANQUE,DATEECHEANCE,ETAT,MONTANT, etatversement, etatversementlib,MONTANTRESTE,reference,MOTSCLESSS from TRAITEMTTRESTE where etat = 11
 
 
 ;
 
 -- TRAITE_LIBESC source

CREATE OR REPLACE  VIEW TRAITE_LIBESC (ID, DATY, TIERS, BANQUE, DATEECHEANCE, ETAT, MONTANT, ETATVERSEMENT, ETATVERSEMENTLIB, MONTANTRESTE, REFERENCE,MOTSCLESSS) AS 
  select ID,DATY,TIERS,BANQUE,DATEECHEANCE,ETAT,MONTANT, etatversement, etatversementlib,MONTANTRESTE,reference,MOTSCLESSS from TRAITEMTTRESTE where id in (select idtraite from escompte where etat = 11)
 
 
 ;
 
 -- TRAITE_LIBVER source

CREATE OR REPLACE  VIEW TRAITE_LIBVER (ID, DATY, TIERS, BANQUE, DATEECHEANCE, ETAT, MONTANT, ETATVERSEMENT, ETATVERSEMENTLIB, MONTANTRESTE, REFERENCE,MOTSCLESSS) AS 
  select ID,DATY,TIERS,BANQUE,DATEECHEANCE,ETAT,MONTANT, etatversement, etatversementlib,MONTANTRESTE,reference,MOTSCLESSS from TRAITEMTTRESTE where etatversement= 11
 
 
 ;
 
 -- TRAITE_LIBNONENC source

CREATE OR REPLACE  VIEW TRAITE_LIBNONENC (ID, DATY, TIERS, BANQUE, DATEECHEANCE, ETAT, MONTANT, ETATVERSEMENT, ETATVERSEMENTLIB, MONTANTRESTE, REFERENCE,MOTSCLESSS) AS 
  select ID,DATY,TIERS,BANQUE,DATEECHEANCE,ETAT,MONTANT, etatversement, etatversementlib,MONTANTRESTE,reference,MOTSCLESSS from TRAITEMTTRESTE where etatversement= 11
 
 
 ;
 
 -- TRAITE_LIBENC source

CREATE OR REPLACE  VIEW TRAITE_LIBENC (ID, DATY, TIERS, BANQUE, DATEECHEANCE, ETAT, MONTANT, ETATVERSEMENT, ETATVERSEMENTLIB, MONTANTRESTE, REFERENCE,MOTSCLESSS) AS 
  select ID,DATY,TIERS,BANQUE,DATEECHEANCE,ETAT,MONTANT, etatversement, etatversementlib,MONTANTRESTE, reference,MOTSCLESSS from TRAITEMTTRESTE where etatversement = -2
 
 
 ;
 
 /*Achat*/

 -- DMDACHATLIB source

CREATE OR REPLACE  VIEW DMDACHATLIB (ID, DATY, FOURNISSEUR, FOURNISSEURLIB, REMARQUE, DATELIMITE, IDMAGASINLIB, IDCATEGORIELIB, ETAT, ETATLIB, IDOBJET,MOTSCLESSS) AS 
  SELECT
    da.id,
    da.daty,
    da.fournisseur,
    f.nom AS fournisseurlib,
    da.remarque,
    da.dateLimite,
    m.val AS idMagasinLib,
    ci.val AS idCategorieLib,
    da.etat,
    CASE
        WHEN da.ETAT = 0
            THEN 'ANNUL&Eacute;E'
        WHEN da.ETAT = 1
            THEN 'CR&Eacute;&Eacute;E'
        WHEN da.ETAT = 11
            THEN 'VIS&Eacute;(E) par Directeur'
        WHEN da.ETAT = 3
            THEN 'VIS&Eacute;(E) par Chef de Fabrication'
        WHEN da.ETAT = 4
            THEN 'VIS&Eacute;(E) par Responsable achat'
        END AS etatlib,
    da.idObjet,
        UPPER(
        NVL(f.nom, '') || ' ' ||
        NVL(da.remarque, '') || ' ' ||
        NVL(m.val, '') || ' ' ||
        NVL(ci.val, '') || ' ' ||
        NVL(da.idObjet, '') || ' ' ||
        TO_CHAR(da.daty, 'DD/MM/YYYY') || ' ' ||
        TO_CHAR(da.dateLimite, 'DD/MM/YYYY') || ' ' ||
        NVL(
            CASE
                WHEN da.ETAT = 0 THEN 'ANNULEE'
                WHEN da.ETAT = 1 THEN 'CREE'
                WHEN da.ETAT = 11 THEN 'VISEE DIRECTEUR'
                WHEN da.ETAT = 3 THEN 'VISEE CHEF FABRICATION'
                WHEN da.ETAT = 4 THEN 'VISEE RESPONSABLE ACHAT'
            END
        , '')
    ) AS MOTSCLESSS
FROM DMDACHAT da
         LEFT JOIN FOURNISSEUR f ON f.ID = da.fournisseur
         LEFT JOIN MAGASIN2 m ON da.idMagasin = m.ID
         LEFT JOIN categorieIngredient ci ON da.idCategorie = ci.id

 
 
 ;
 -- FACTUREFOURNISSEURCPL_TOUS source

CREATE OR REPLACE  VIEW FACTUREFOURNISSEURCPL_TOUS (ID, IDFOURNISSEUR, IDFOURNISSEURLIB, IDMODEPAIEMENT, IDMODEPAIEMENTLIB, DATY, DESIGNATION, DATEECHEANCEPAIEMENT, ETATLIB, REFERENCE, IDBC, IDMAGASIN, IDMAGASINLIB, DEVISE, IDDEVISE, ETAT, TAUX, MONTANTTVA, MONTANTHT, TAUXDECHANGE, MONTANTTTC, MONTANTPAYE, MONTANTRESTE,MOTSCLESSS) AS 
  SELECT 
	fcpl.id,
	fcpl.idfournisseur,
	fcpl.idfournisseurlib,
	fcpl.idmodepaiement,
	fcpl.idmodepaiementlib,
	fcpl.daty,
	fcpl.designation,
	fcpl.dateecheancepaiement,
	fcpl.etatlib,
	fcpl.reference,
	fcpl.idbc,
	fcpl.idmagasin,
	fcpl.idmagasinlib,
	fcpl.devise,
	fcpl.iddevise,
	fcpl.etat,
	fcpl.taux,
	fcpl.montanttva,
	fcpl.montantht,
	fcpl.tauxdechange,
	fcpl.montantttc AS  MONTANTTTC, 
	nvl((fcpl.montantpaye * fcpl.TAUXDECHANGE),0) AS MONTANTPAYE,
	nvl((fcpl.montantreste * fcpl.TAUXDECHANGE),0) AS MONTANTRESTE,
	UPPER(
        NVL(fcpl.designation, '') || ' ' ||
        NVL(fcpl.reference, '') || ' ' ||
        NVL(fcpl.idfournisseurlib, '') || ' ' ||
        NVL(fcpl.idmodepaiementlib, '') || ' ' ||
        NVL(fcpl.idmagasinlib, '') || ' ' ||
        NVL(fcpl.devise, '') || ' ' ||
        NVL(fcpl.idbc, '') || ' ' ||
        TO_CHAR(fcpl.daty, 'DD/MM/YYYY') || ' ' ||
        TO_CHAR(fcpl.dateecheancepaiement, 'DD/MM/YYYY') || ' ' ||
        NVL(fcpl.etatlib, '')
    ) AS MOTSCLESSS
FROM FACTUREFOURNISSEURCPL fcpl
 
 
 ;
-- AS_BONDECOMMANDE_MERECPL source

CREATE OR REPLACE  VIEW AS_BONDECOMMANDE_MERECPL (ID, DATY, ETAT, REMARQUE, DESIGNATION, MODEPAIEMENT, FOURNISSEUR, REFERENCE, DATELIMITE, MODEPAIEMENTLIB, FOURNISSEURLIB, MONTANTTVA, MONTANTHT, MONTANTTTC, MONTANTTTCARIARY, IDDEVISELIB, IDDEVISE, IDORIGINE, IDMAGASIN, IDMAGASINLIB, ETATLIB,MOTSCLESSS) AS 
  SELECT
    ab.ID,
    ab.DATY,
    ab.ETAT,
    ab.REMARQUE,
    ab.DESIGNATION,
    ab.MODEPAIEMENT,
    ab.FOURNISSEUR,
    ab.REFERENCE,
    ab.dateLimite,
    mp.VAL AS MODEPAIEMENTLIB,
    F.NOM AS FOURNISSEURLIB,
    abf.montantTVA,
    abf.montantHT,
    CAST(nvl((abf.montantHT + abf.montantTVA),0) AS NUMBER(30,2)) AS montantTTC ,
    CAST(nvl((abf.montantHT + abf.montantTVA) * abf.TAUXDECHANGE,0) AS NUMBER(30,2)) AS montantTTCAriary,
    d.val AS idDeviselib,
    d.id AS IDDEVISE,
    AB.idOrigine,
    AB.IDMAGASIN,
    m.VAL AS idMagasinlib,
    CASE
        WHEN ab.ETAT = 1 THEN 'CREEE'
        WHEN ab.ETAT = 11 THEN 'VISEE'
        WHEN ab.ETAT = 0 THEN 'ANNULEE'
        END
        AS ETATLIB,
          UPPER(
        NVL(ab.DESIGNATION, '') || ' ' ||
        NVL(ab.REFERENCE, '') || ' ' ||
        NVL(ab.REMARQUE, '') || ' ' ||
        NVL(F.NOM, '') || ' ' ||
        NVL(mp.VAL, '') || ' ' ||
        NVL(m.VAL, '') || ' ' ||
        NVL(d.val, '') || ' ' ||
        NVL(ab.IDORIGINE, '') || ' ' ||
        TO_CHAR(ab.DATY, 'DD/MM/YYYY') || ' ' ||
        TO_CHAR(ab.dateLimite, 'DD/MM/YYYY') || ' ' ||
        NVL(
            CASE
                WHEN ab.ETAT = 1 THEN 'CREE'
                WHEN ab.ETAT = 11 THEN 'VISEE'
                WHEN ab.ETAT = 0 THEN 'ANNULEE'
            END
        , '')
    ) AS MOTSCLESSS

from  AS_BONDECOMMANDE AB
          left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
          left join FOURNISSEUR F on AB.FOURNISSEUR = F.id
          LEFT JOIN AS_BONDECOMMANDEFILLE_CPL abf ON abf.IDBC = ab.ID
          LEFT JOIN DEVISE d ON d.id = ab.IDDEVISE
          LEFT JOIN MAGASINPOINT m ON m.id =  AB.IDMAGASIN  
 ;
 
-- AS_BONDELIVRAISON_LIB source

-- AS_BONDELIVRAISON_LIB source

CREATE OR REPLACE  VIEW AS_BONDELIVRAISON_LIB (ID, REMARQUE, IDBC, DATY, ETAT, MAGASIN, MAGASINLIB, ETATLIB, IDFOURNISSEUR, IDFOURNISSEURLIB, IDFACTUREFOURNISSEUR,MOTSCLESSS) AS 
  select bl.ID,
       bl.REMARQUE,
       bl.IDBC,
       bl.DATY,
       bl.ETAT,
       bl.MAGASIN,
       m.VAL as MAGASINlib,
       case
           when bl.etat = 1 then 'CR&Eacute;&Eacute;(E)'
           when bl.etat = 11 then 'VIS&Eacute;(E)'
           end as etatlib,
       bl.idfournisseur,
       f.nom AS idfournisseurlib,
       bl.IDFACTUREFOURNISSEUR,
        UPPER(
        NVL(bl.REMARQUE, '') || ' ' ||
        NVL(bl.IDBC, '') || ' ' ||
        NVL(f.nom, '') || ' ' ||
        NVL(m.VAL, '') || ' ' ||
        NVL(bl.IDFACTUREFOURNISSEUR, '') || ' ' ||
        TO_CHAR(bl.DATY, 'DD/MM/YYYY') || ' ' ||
        NVL(
            CASE
                WHEN bl.etat = 1 THEN 'CREE'
                WHEN bl.etat = 11 THEN 'VISEE'
            END
        , '')
    ) AS MOTSCLESSS

from AS_BONDELIVRAISON bl
         left join MAGASIN m on bl.MAGASIN = m.ID
         LEFT JOIN fournisseur f ON f.id=bl.idfournisseur
 
 
 ;
 
/*Stock*/

CREATE OR REPLACE  VIEW MVTSTOCKLIB (ID, DESIGNATION, IDMAGASIN, IDOBJET, IDMAGASINLIB, IDVENTE, IDVENTELIB, IDTRANSFERT, IDTRANSFERTLIB, IDTYPEMVSTOCK, IDTYPEMVSTOCKLIB, DATY, ETAT, ETATLIB, IDRESERVATION, MONTANTENTREE, MONTANTSORTIE,motsClesss) AS 
  SELECT
m.ID ,
m.DESIGNATION ,
m.IDMAGASIN ,
m.IDOBJET ,
m2.VAL  AS idMagasinlib,
m.IDVENTE ,
v.DESIGNATION  AS idVentelib,
m.IDTRANSFERT ,
CAST('' AS VARCHAR2(255)) AS idTransfertlib,
m.IDTYPEMVSTOCK ,
t.VAL AS idTypeMvStocklib ,
m.DATY ,
m.ETAT ,
CASE
	WHEN m.ETAT = 0
	THEN 'ANNUL&Eacute;E'
	WHEN m.ETAT = 1
	THEN 'CR&Eacute;&Eacute;E'
	WHEN m.ETAT = 11
	THEN 'VALID&Eacute;E'
END AS etatlib,
v.IDRESERVATION,
gm.montantEntree,
gm.montantSortie,
  (
        m.DESIGNATION || ' ' ||
        NVL(m2.VAL, '') || ' ' ||
        NVL(v.DESIGNATION, '') || ' ' ||
        TO_CHAR(m.DATY, 'YYYY-MM-DD')
    ) AS motsClesss
FROM MVTSTOCK m
LEFT JOIN TYPEMVTSTOCK t ON t.ID = m.IDTYPEMVSTOCK
LEFT JOIN VENTE v ON v.ID = m.IDVENTE
LEFT JOIN MAGASIN2 m2 ON m2.ID = m.IDMAGASIN
left join mvtStockFilleGroupeMere gm on gm.IDMVTSTOCK=m.ID;

-- V_ETATSTOCK_ING source

CREATE OR REPLACE  VIEW V_ETATSTOCK_ING (ID, IDPRODUITLIB, CATEGORIEINGREDIENT, IDTYPEPRODUITLIB, IDMAGASIN, IDMAGASINLIB, DATEDERNIERMOUVEMENT, QUANTITE, ENTREE, SORTIE, RESTE, UNITE, IDUNITELIB, PUVENTE, IDPOINT, IDTYPEMAGASIN, SEUILMIN, SEUILMAX, MONTANTENTREE, MONTANTSORTIE, PU, MONTANTRESTE, COMPTELOCALISATION,MOTSCLESSS) AS 
  SELECT
    p.ID AS ID,
    p.LIBELLE AS idproduitLib,
    p.CATEGORIEINGREDIENT,
    tp.DESCE AS idtypeproduitlib,
    ms.IDMAGASIN,
    mag.VAL AS idmagasinlib,
    TO_DATE('01-01-2001', 'DD-MM-YYYY') AS dateDernierMouvement,
    CAST(ms.quantite AS NUMBER(30,5) ) AS QUANTITE,
    CAST(NVL( ms.entree, 0) AS NUMBER(30, 5))  AS ENTREE,
    CAST(NVL( ms.sortie, 0) AS NUMBER(30, 5))  AS SORTIE,
    CAST(NVL( ms.quantite, 0) AS NUMBER(30, 5))  AS reste,
    p.UNITE,
    u.DESCE AS idunitelib,
    CAST(NVL(p.PV, 0) AS NUMBER(30, 5)) AS PUVENTE,
    mag.IDPOINT,
    mag.IDTYPEMAGASIN,
    p.SEUILMIN,
    p.SEUILMAX,
    CAST(ms.montantEntree AS NUMBER(30,5)) AS montantEntree,
    CAST(ms.montantSortie AS NUMBER(30,5)) AS montantSortie,
    CAST(p.pu AS NUMBER(30,5)) AS pu,
    CAST(ms.montant AS NUMBER(30,5)) as montantReste,
    ms.compteLocalisation,
        UPPER(
        NVL(p.LIBELLE, '') || ' ' ||
        NVL(tp.DESCE, '') || ' ' ||
        NVL(mag.VAL, '') || ' ' ||
        NVL(u.DESCE, '') || ' ' ||
        NVL(ms.compteLocalisation, '') || ' ' ||
        NVL(p.UNITE, '') || ' ' ||
        NVL(p.ID, '') || ' ' ||
        NVL(mag.IDPOINT, '') || ' ' ||
        NVL(mag.IDTYPEMAGASIN, '')
    ) AS MOTSCLESSS
FROM AS_INGREDIENTS p
         LEFT JOIN MONTANT_STOCK ms ON ms.IDPRODUIT = p.ID
         LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID
         LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID
         LEFT JOIN AS_UNITE u ON p.UNITE = u.ID
WHERE NVL(ms.ENTREE, 0)>0 or NVL(ms.SORTIE, 0)>0;
 
 -- FACTUREFOURNISSEURCPL_MGA source

-- INVENTAIRELIB source

CREATE OR REPLACE  VIEW INVENTAIRELIB (ID, DATY, DESIGNATION, IDMAGASIN, IDMAGASINLIB, ETAT, ETATLIB, IDCATEGORIE, IDCATEGORIELIB,MOTSCLESSS) AS 
  SELECT
i.ID ,
i.DATY ,
i.DESIGNATION ,
i.IDMAGASIN ,
m.VAL AS IDMAGASINLIB,
i.ETAT ,
CASE
	WHEN i.ETAT = 0
	THEN 'ANNUL&Eacute;E'
	WHEN i.ETAT = 1
	THEN 'CR&Eacute;&Eacute;E' 
	WHEN i.ETAT = 11
	THEN 'VALID&Eacute;E'
END AS ETATLIB,
i.idcategorie,
c.VAL AS idcategorieLib,
 UPPER(
        NVL(i.DESIGNATION, '') || ' ' ||
        NVL(m.VAL, '') || ' ' ||
        NVL(c.VAL, '') || ' ' ||
        NVL(i.ID, '') || ' ' ||
        TO_CHAR(i.DATY, 'DD/MM/YYYY') || ' ' ||
        NVL(
            CASE
                WHEN i.ETAT = 0 THEN 'ANNULEE'
                WHEN i.ETAT = 1 THEN 'CREE'
                WHEN i.ETAT = 11 THEN 'VALIDEE'
            END
        , '')
    ) AS MOTSCLESSS
FROM INVENTAIRE i
LEFT JOIN MAGASINPOINT m ON m.ID = i.IDMAGASIN
LEFT JOIN CATEGORIEINGREDIENT c ON c.id = i.idcategorie

 
 
 ;
 
 -- INVENTAIRELIB_CREE source

CREATE OR REPLACE  VIEW INVENTAIRELIB_CREE (ID, DATY, DESIGNATION, IDMAGASIN, IDMAGASINLIB, ETAT, ETATLIB,MOTSCLESSS) AS 
  SELECT 
i.ID,i.DATY,i.DESIGNATION,i.IDMAGASIN,i.IDMAGASINLIB,i.ETAT,i.ETATLIB,MOTSCLESSS
FROM INVENTAIRELIB i 
WHERE i.ETAT = 1 
 
 
 ;
 
 -- INVENTAIRELIB_VALIDEE source

CREATE OR REPLACE  VIEW INVENTAIRELIB_VALIDEE (ID, DATY, DESIGNATION, IDMAGASIN, IDMAGASINLIB, ETAT, ETATLIB,MOTSCLESSS) AS 
  SELECT 
i.ID,i.DATY,i.DESIGNATION,i.IDMAGASIN,i.IDMAGASINLIB,i.ETAT,i.ETATLIB,MOTSCLESSS
FROM INVENTAIRELIB i 
WHERE i.ETAT = 11 
 
 
 ;