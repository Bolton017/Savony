CREATE OR REPLACE  VIEW VENTE_CPL_SANSAVOIR ("ID", "DESIGNATION", "IDMAGASIN", "IDMAGASINLIB", "DATY", "REMARQUE", "ETAT", "ETATLIB", "MONTANTTOTAL", "IDDEVISE", "IDCLIENT", "IDCLIENTLIB", "MONTANTTVA", "MONTANTTTC", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTRESTE", "TAUXDECHANGE", "MONTANTREVIENT", "MARGEBRUTE", "IDRESERVATION", "DATYPREVU", "REFERENCEFACTURE", "MONTANTREMISE", "MONTANT", "MOIS", "ANNEE", "POIDS", "MODEPAIEMENT", "MODEPAIEMENTLIB", "FRAISLIVRAISON", "MODELIVRAISON", "MODELIVRAISONLIB", "RESTE", "IDPROVINCE", "PROVINCELIB", "NUMFACT") AS
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
       pv.val                                                       as provincelib,
       v.NUMEROFACTURE as numfact
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         left join PROVINCE pv on pv.id = c.IDPROVINCE
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id = mv.id2
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture = v.Id
         left join vente_poids vp on vp.idvente = v.id
         left join MODEPAIEMENT mp on mp.id = v.modepaiement
         left join vente_reste vr on vr.idvente = v.id;



CREATE OR REPLACE  VIEW AVOIRFCLIB_CPL ("ID", "DESIGNATION", "IDMAGASIN", "IDMAGASINLIB", "DATY", "REMARQUE", "ETAT", "IDORIGINE", "IDCLIENT", "COMPTE", "IDVENTE", "IDVENTELIB", "IDMOTIF", "IDMOTIFLIB", "IDCATEGORIE", "IDCATEGORIELIB", "IDDEVISE", "TAUXDECHANGE", "MONTANTHT", "MONTANTTVA", "MONTANTTTC", "MONTANTHTAR", "MONTANTTVAAR", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTPAYEAR", "MONTANT_RESTE_FACTURE", "MONTANT_AVOIRS_ANTERIEURS", "RESTE_CALCULE", "EXCEDENT_AR", "RESTEAPAYER", "RESTEAPAYERAR", "CLIENTLIB", "TYPEAVOIR", "NUMFACT") AS
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
       AL.Typeavoir,
       vc.NUMFACT
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
                       AND SUM_PRECEDENTS.idcourant = AL.id;

alter table AVOIRFC add numavoir varchar2(50);
alter table AVOIRFC add idristourne varchar2(50);

create view V_NUMEROAVOIR_EN_COURS as
SELECT
    EXTRACT(YEAR FROM SYSDATE) AS ANNEE_EN_COURS,
    NVL(MAX(TO_NUMBER(SUBSTR(numavoir, 1, INSTR(numavoir, '/') - 1))), 0) AS DERNIER_NUM,
    NVL(MAX(TO_NUMBER(SUBSTR(numavoir, 1, INSTR(numavoir, '/') - 1))), 0) + 1 AS PROCHAIN_NUM,
    LPAD(NVL(MAX(TO_NUMBER(SUBSTR(numavoir, 1, INSTR(numavoir, '/') - 1))), 0) + 1, 4, '0')
        || '/' || TO_CHAR(EXTRACT(YEAR FROM SYSDATE)) AS PROCHAIN_NUM_FORMAT
FROM AVOIRFC
WHERE SUBSTR(numavoir, INSTR(numavoir, '/') + 1) = TO_CHAR(EXTRACT(YEAR FROM SYSDATE));

alter table AVOIRFCFILLE add taux number(32,2);
ALTER TABLE RISTOURNEDETAILS ADD pu number(30,2);
ALTER TABLE RISTOURNEDETAILS ADD qte number(30,2);

create or replace view RISTOURNEDETAILS_LIB as
SELECT
    r.Id,
    r.idristourne,
    r.idproduit,
    r.taux1,
    r.taux2,
    r.idorigine,
    ai.libelle AS idproduitlib,
    r.QTE,
    r.PU
FROM RISTOURNEDETAILS r
         LEFT JOIN AS_INGREDIENTS ai ON ai.id=r.idproduit;

alter table AS_INGREDIENTS add compte_ristourne varchar2(50);

INSERT INTO CATEGORIEAVOIRFC
(ID, VAL, DESCE, "TYPE")
VALUES('CAT002', 'Annulation partielle commande', 'Annulation partielle commande', NULL);
INSERT INTO CATEGORIEAVOIRFC
(ID, VAL, DESCE, "TYPE")
VALUES('CAT001', 'Categorie Avoir ', 'Categorie Avoir ', NULL);

INSERT INTO MOTIFAVOIRFC
(ID, VAL, DESCE)
VALUES('MOTIF0002', 'Produit défectueux', 'Produit défectueux');
INSERT INTO MOTIFAVOIRFC
(ID, VAL, DESCE)
VALUES('MOTIF0001', 'Retour marchandise', 'Retour marchandise');