create or replace view MVTSTOCKFILLELIB as
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
    m2.DATY AS dateSql,
    m2.IDTYPEMVSTOCK,
    m.IDLOT,
    m2.IDOBJET,
    TO_CHAR(l.DATY, 'DD/MM/YYYY') || '-' || l.IDPRODUIT || '-' || l.IDEQUIPE AS IDLOTLIB,
    loc.libelle AS comptelocalisationlib, -- compleLocalisation teto ny taloha
    m2.ETAT
FROM MVTSTOCKFILLE m
         LEFT JOIN AS_INGREDIENTS  p ON p.ID = m.IDPRODUIT
         LEFT JOIN MVTSTOCK m2 ON m2.ID = m.IDMVTSTOCK
         LEFT JOIN MAGASIN2 m3 ON m3.ID = m2.IDMAGASIN
         LEFT JOIN LOT l on l.ID = m.IDLOT
         LEFT JOIN localisation loc ON m.comptelocalisation=loc.id;

create or replace view MVTSTOCKLIB as
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
    CAST(gm.MONTANTENTREE AS NUMBER(32,2)) AS MONTANTENTREE, -- castena
    CAST(gm.MONTANTSORTIE AS NUMBER(32,2)) AS MONTANTSORTIE, -- castena
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
