
CREATE OR REPLACE  VIEW CAISSECPL ("ID", "VAL", "DESCE", "IDTYPECAISSE", "IDTYPECAISSELIB", "IDPOINT", "IDPOINTLIB", "IDPOMPISTE", "ETAT", "COMPTE", "ETATLIB", "IDCATEGORIECAISSE", "IDCATEGORIECAISSELIB", "IDMAGASIN", "IDMAGASINLIB", "MOTSCLESSS", "IDDEVISE", "IDDEVISELIB") AS
(
SELECT SQ.ID,
       SQ.VAL,
       SQ.DESCE,
       SQ.IDTYPECAISSE,
       SQ.IDTYPECAISSELIB,
       SQ.IDPOINT,
       SQ.IDPOINTLIB,
       SQ.IDPOMPISTE,
       SQ.ETAT,
       SQ.COMPTE,
       SQ.ETATLIB,
       SQ.IDCATEGORIECAISSE,
       SQ.IDCATEGORIECAISSELIB,
       SQ.IDMAGASIN,
       SQ.IDMAGASINLIB,
       (NVL(TO_CHAR(ID), '') || ' | ' || NVL(TO_CHAR(VAL), '') || ' | ' || NVL(TO_CHAR(DESCE), '') || ' | ' ||
        NVL(TO_CHAR(IDTYPECAISSE), '') || ' | ' || NVL(TO_CHAR(IDTYPECAISSELIB), '') || ' | ' ||
        NVL(TO_CHAR(IDPOINT), '') || ' | ' || NVL(TO_CHAR(IDPOINTLIB), '') || ' | ' || NVL(TO_CHAR(IDPOMPISTE), '') ||
        ' | ' || NVL(TO_CHAR(ETAT), '') || ' | ' || NVL(TO_CHAR(COMPTE), '') || ' | ' || NVL(TO_CHAR(ETATLIB), '') ||
        ' | ' || NVL(TO_CHAR(IDCATEGORIECAISSE), '') || ' | ' || NVL(TO_CHAR(IDCATEGORIECAISSELIB), '') || ' | ' ||
        NVL(TO_CHAR(IDMAGASIN), '') || ' | ' || NVL(TO_CHAR(IDMAGASINLIB), '')) AS MOTSCLESSS,
       sq.IDDEVISE,
       sq.iddeviselib
FROM (SELECT c.ID,
             c.VAL,
             c.DESCE,
             c.IDTYPECAISSE,
             t.VAL                                   AS IDTYPECAISSELIB,
             c.IDPOINT,
             p.VAL                                   AS IDPOINTLIB,
             c.IDPOMPISTE,
             c.ETAT,
             cop.LIBELLE || '(' || cop.COMPTE || ')' as compte,
             CASE
                 WHEN c.ETAT = 0
                     THEN 'ANNUL&Eacute;'
                 WHEN c.ETAT = 1
                     THEN 'CR&Eacute;&Eacute;'
                 WHEN c.ETAT = 11
                     THEN 'VIS&Eacute;'
                 END                                 AS ETATLIB,
             c.idCategorieCaisse,
             c2.VAL                                  AS idCategorieCaisseLib,
             c.IDMAGASIN,
             m.val                                   AS idMagasinLib,
             c.IDDEVISE,
             d.val                                   as iddeviselib
      FROM CAISSE c
               LEFT JOIN TYPECAISSE t ON t.ID = c.IDTYPECAISSE
               LEFT JOIN POINT p ON p.ID = c.IDPOINT
               LEFT JOIN CATEGORIECAISSE c2 ON c2.ID = c.idCategorieCaisse
               LEFT JOIN COMPTA_COMPTE cop ON cop.COMPTE = c.COMPTE
               LEFT JOIN MAGASIN2 m ON m.ID = c.IDMAGASIN
               left join devise d on d.ID = c.IDDEVISE) SQ
);

CREATE OR REPLACE  VIEW REPORTCAISSELIB ("ID", "IDCAISSE", "IDCAISSELIB", "MONTANT", "MONTANTTHEORIQUE", "ECARTCALC", "DATY", "ETAT", "HEURE", "ETATLIB", "ECART") AS
SELECT
    r.ID ,
    r.IDCAISSE ,
    c.VAL AS IDCAISSELIB,
    CAST(r.MONTANT AS NUMBER(30,5)) AS MONTANT ,
    CAST(r.MONTANTTHEORIQUE AS NUMBER(30,5)) AS MONTANTTHEORIQUE ,
    CAST(r.MONTANT - r.MONTANTTHEORIQUE AS NUMBER(30,5)) as ecartCalc,
    r.DATY ,
    r.ETAT ,r.heure,
    CASE
        WHEN r.ETAT = 0
            THEN 'Annul&eacute;'
        WHEN r.ETAT = 1
            THEN 'Cr&eacute;&eacute;'
        WHEN r.ETAT = 11
            THEN 'Valid&eacute;'
        END AS ETATLIB,
    r.MONTANTTHEORIQUE - r.MONTANT as ecart
FROM REPORTCAISSE r
         LEFT JOIN CAISSE c ON c.ID  = r.IDCAISSE
;