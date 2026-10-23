CREATE OR REPLACE VIEW mvtstockfillelib  AS
SELECT
    m.ID ,
    m.IDMVTSTOCK ,
    m.IDPRODUIT ,
    p.libelle  AS IDPRODUITLIB,
    m.ENTREE ,
    m.SORTIE ,
    m.IDVENTEDETAIL ,
    '' AS IDVENTEDETAILLIB,
    m.IDTRANSFERTDETAIL ,
    '' AS IDTRANSFERTDETAILLIB,
    m2.DATY ,
    m2.IDMAGASIN ,
    m3.VAL AS IDMAGASINLIB,
    m.pu,
    cast(m.pu*m.ENTREE+(m.pu*m.sortie) as number(20,5)) as montant,
    p.LIBELLE,
    m.MVTSRC,
    p.libelle AS libelleexacte,
    m2.DATY AS dateSql
FROM MVTSTOCKFILLE m
         LEFT JOIN AS_INGREDIENTS  p ON p.ID = m.IDPRODUIT
         LEFT JOIN MVTSTOCK m2 ON m2.ID = m.IDMVTSTOCK
         LEFT JOIN MAGASIN2 m3 ON m3.ID = m2.IDMAGASIN;

create or replace view TRANSFERTSTOCKCPL as
SELECT
    t.ID ,
    t.DESIGNATION ,
    t.IDMAGASINDEPART ,
    m.VAL AS IDMAGASINDEPARTLIB,
    t.IDMAGASINARRIVE ,
    m2.VAL AS IDMAGASINARRIVELIB,
    t.DATY ,
    t.ETAT ,
    t.idof,
    CASE
        WHEN t.ETAT = 0
            THEN 'ANNULÉE'
        WHEN t.ETAT = 1
            THEN 'CRÉÉE'
        WHEN t.ETAT = 11
            THEN 'VISÉE'
        END AS ETATLIB
FROM TRANSFERTSTOCK t
         LEFT JOIN MAGASINPOINT m ON m.ID = t.IDMAGASINDEPART
         LEFT JOIN MAGASINPOINT m2 ON m2.ID = t.IDMAGASINARRIVE;