-- libelle etat
CREATE OR REPLACE FORCE VIEW "OFABLIB" ("ID", "LANCEPAR", "CIBLE", "REMARQUE", "LIBELLE", "BESOIN", "DATY", "ETAT", "ETATLIB") AS
SELECT ofl.ID,
       p1.VAL  AS LANCEPAR,
       p2.VAL  AS CIBLE,
       ofl.REMARQUE,
       ofl.LIBELLE,
       ofl.BESOIN,
       ofl.DATY,
       ofl.ETAT,
       CASE
           WHEN ofl.ETAT=1
               THEN 'CRÉÉ'
           WHEN ofl.ETAT=11
               THEN 'VALIDÉ'
           WHEN ofl.ETAT=0
               THEN 'ANNULÉ'
           WHEN ofl.ETAT=21
               THEN 'ENTAMÉ'
           WHEN ofl.ETAT=31
               THEN 'BLOQUÉ'
           WHEN ofl.ETAT=41
               THEN 'TERMINÉ'
           END AS ETATLIB
FROM OFAB ofl
         LEFT JOIN MAGASINPOINT p1 ON p1.ID = ofl.LANCEPAR
         LEFT JOIN MAGASINPOINT p2 ON p2.ID = ofl.CIBLE;

-- SOCOBISPROD1509.FABRICATIONCPL source


-- libelle etat
CREATE OR REPLACE FORCE VIEW "FABRICATIONCPL" ("ID", "LANCEPAR", "CIBLE", "REMARQUE", "LIBELLE", "BESOIN", "DATY", "IDOFFILLE", "IDOF", "LANCEPARLIB", "CIBLELIB", "ETAT", "ETATLIB", "FABRICATIONPREC", "FABRICATIONSUIV") AS
SELECT
    f.ID,f.LANCEPAR,f.CIBLE,f.REMARQUE,f.LIBELLE,f.BESOIN,f.DATY,f.idOffille,nvl(f.idof, off.idmere) AS idof,
    p.val AS lanceparLib,
    p2.val AS cibleLib,
    f.etat AS etat,
    CASE
        WHEN f.ETAT=1
            THEN 'CRÉÉE'
        WHEN f.ETAT=11
            THEN 'VALIDÉE'
        WHEN f.ETAT=0
            THEN 'ANNULÉE'
        WHEN f.ETAT=21
            THEN 'ENTAMÉE'
        WHEN f.ETAT=31
            THEN 'BLOQUÉE'
        WHEN f.ETAT=41
            THEN 'TERMINÉE'
        END AS ETATLIB,
    f.FABRICATIONPREC,
    f.FABRICATIONSUIV
FROM FABRICATION f
         LEFT JOIN MAGASINPOINT p ON p.id = f.lancepar
         LEFT JOIN MAGASINPOINT p2 ON p2.id = f.cible
         LEFT JOIN offille off ON f.idoffille = off.id;

-- SOCOBISPROD1509.VENTE_CPL source
-- etat lib
CREATE OR REPLACE FORCE VIEW "VENTE_CPL" ("ID", "DESIGNATION", "IDMAGASIN", "IDMAGASINLIB", "DATY", "REMARQUE", "ETAT", "ETATLIB", "MONTANTTOTAL", "IDDEVISE", "IDCLIENT", "IDCLIENTLIB", "MONTANTTVA", "MONTANTTTC", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTRESTE", "AVOIR", "TAUXDECHANGE", "MONTANTREVIENT", "MARGEBRUTE", "IDRESERVATION", "DATYPREVU", "REFERENCEFACTURE") AS
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CRÉÉE'
           WHEN v.ETAT = 11 THEN 'VISÉE'
           WHEN v.ETAT = 0 THEN 'ANNULÉE'
           END
             AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM AS IDCLIENTLIB,
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.montant,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
       cast(V2.MONTANTTTC-nvl(mv.montant,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30,2))  as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then daty else V.DATYPREVU end as datyprevu,
       rf.REFERENCE as referencefacture
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id=mv.id2
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id;

UPDATE TYPEMVTSTOCK
SET VAL='Entrée', DESCE='Entree'
WHERE ID='TPMVST000001';

-- libelle etat
CREATE OR REPLACE FORCE VIEW "MVTSTOCKLIB" ("ID", "DESIGNATION", "IDMAGASIN", "IDOBJET", "IDMAGASINLIB", "IDVENTE", "IDVENTELIB", "IDTRANSFERT", "IDTRANSFERTLIB", "IDTYPEMVSTOCK", "IDTYPEMVSTOCKLIB", "DATY", "ETAT", "ETATLIB", "IDRESERVATION", "MONTANTENTREE", "MONTANTSORTIE") AS
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
            THEN 'ANNULÉE'
        WHEN m.ETAT = 1
            THEN 'CRÉÉE'
        WHEN m.ETAT = 11
            THEN 'VALIDÉE'
        END AS etatlib,
    v.IDRESERVATION,
    gm.montantEntree,
    gm.montantSortie
FROM MVTSTOCK m
         LEFT JOIN TYPEMVTSTOCK t ON t.ID = m.IDTYPEMVSTOCK
         LEFT JOIN VENTE v ON v.ID = m.IDVENTE
         LEFT JOIN MAGASIN2 m2 ON m2.ID = m.IDMAGASIN
         left join mvtStockFilleGroupeMere gm on gm.IDMVTSTOCK=m.ID;

-- libelle etat
CREATE OR REPLACE FORCE VIEW "CHARGE_CPL" ("ID", "DATY", "LIBELLE", "PU", "QTE", "TYPE", "IDFABRICATION", "ETAT", "TYPELIB", "ETATLIB") AS
SELECT
    c.ID,
    c.DATY,
    c.LIBELLE,
    c.PU,
    c.QTE,
    c.TYPE,
    c.IDFABRICATION,
    c.ETAT,
    t.val AS typelib,
    CASE
        WHEN c.ETAT = 0
            THEN 'ANNULÉE'
        WHEN c.ETAT = 1
            THEN 'CRÉÉE'
        WHEN c.ETAT = 11
            THEN 'VISÉE'
        END AS etatlib
FROM
    CHARGE c
        LEFT JOIN TYPECHARGE t ON
        t.id = c.TYPE ;