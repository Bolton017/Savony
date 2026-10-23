
----------Nomena
-- SOCOBISPROD0809.V_ETATCAISSE source

CREATE OR REPLACE  VIEW V_ETATCAISSE AS
  WITH MAX_INVENTAIRE AS (
    -- Etape 1 : On extrait la date maximale valide et la quantite par COUPLE produit/magasin
    SELECT REP.IDCAISSE,
           MAX(REP.DATY)                                             AS MAX_DATY,
           MAX(REP.MONTANT) KEEP (DENSE_RANK LAST ORDER BY REP.DATY) AS MONTANT_MAX_DATY
    FROM REPORTCAISSEAVECHEURE REP
    WHERE REP.ETAT >= 11 --and rep.DATY<=TO_DATE('27/07/2026','DD-MM-YYYY')
    GROUP BY REP.IDCAISSE),
     TAUXCHANGEMAX
         AS (SELECT MAX(TAU.TAUX) KEEP (DENSE_RANK LAST ORDER BY TAU.DATY) AS TAUX,
                    TAU.IDDEVISE                                           AS TAUXIDDEVISE,
                    MAX(TAU.DATY)                                          AS TAUXDATY
             FROM TAUXDECHANGE TAU
             GROUP BY IDDEVISE),
     SOMME_PRECALC AS (SELECT C.ID                              AS IDCAISSE,
                              C.VAL                             AS IDCAISSELIB,
                              NVL(SUM(CASE
                                          WHEN MFF.DATY > NVL(INV.MAX_DATY, DATE '2025-01-01') THEN MFF.CREDIT
                                          ELSE 0 END), 0)       AS CREDIT,

                              NVL(SUM(CASE
                                          WHEN MFF.DATY > NVL(INV.MAX_DATY, DATE '2025-01-01') THEN MFF.DEBIT
                                          ELSE 0 END), 0)       AS DEBIT,
                              MAX(INV.MAX_DATY)                 AS DATEDERNIERREPORT,
                              NVL(MAX(INV.MONTANT_MAX_DATY), 0) AS MONTANTDERNIERREPORT,
                              C.IDPOINT,
                              P.VAL                             AS IDPOINTLIB,
                              C.IDTYPECAISSE,
                              TYP.VAL                           AS IDTYPECAISSELIB,
                              C.IDDEVISE,
                              MAX(TAU.TAUX)                     AS TAUX
                       FROM CAISSE C
                                LEFT JOIN MOUVEMENTCAISSEAVECHEURE MFF
                                          ON MFF.IDCAISSE = C.ID AND MFF.ETAT >= 11 AND MFF.IDREPORT IS NOT NULL-- and mff.DATY<=TO_DATE('27/07/2026','DD-MM-YYYY')
                                JOIN MAX_INVENTAIRE INV ON INV.IDCAISSE = C.ID
                                LEFT JOIN TAUXCHANGEMAX TAU ON TAU.TAUXIDDEVISE = C.IDDEVISE
                                LEFT JOIN POINT P ON P.ID = C.IDPOINT
                                LEFT JOIN TYPECAISSE TYP ON TYP.ID = C.IDTYPECAISSE
                       GROUP BY C.ID, C.IDPOINT, P.VAL, C.IDTYPECAISSE, TYP.VAL, C.VAL, C.IDDEVISE)
-- Selection finale
SELECT IDCAISSE,
       IDCAISSELIB || ' (' || NVL(IDDEVISE, 'AR') || ')'                             AS IDCAISSELIB,
       CAST(CREDIT AS NUMBER(30, 2))                                                 AS CREDIT,
       CAST(DEBIT AS NUMBER(30, 2))                                                  AS DEBIT,
       CAST(MONTANTDERNIERREPORT + CREDIT - DEBIT AS NUMBER(30, 2))                  AS RESTE,
       CAST(NVL(TAUX, 1) AS NUMBER(30, 2))                                           AS TAUX,
       CAST((MONTANTDERNIERREPORT + CREDIT - DEBIT) * NVL(TAUX, 1) AS NUMBER(30, 2)) AS RESTEAR,
       DATE '2025-01-01'                                                             AS DATY,
       IDCAISSE                                                                      AS ID,
       DATEDERNIERREPORT,
       CAST(MONTANTDERNIERREPORT AS NUMBER(30, 2))                                   AS MONTANTDERNIERREPORT,
       IDPOINT,
       IDPOINTLIB,
       IDTYPECAISSE,
       IDTYPECAISSELIB,
       (IDCAISSELIB || ' | ' || IDPOINTLIB || ' | ' || IDTYPECAISSELIB || ' | ' || DATEDERNIERREPORT) AS MOTSCLESSS
FROM SOMME_PRECALC

;