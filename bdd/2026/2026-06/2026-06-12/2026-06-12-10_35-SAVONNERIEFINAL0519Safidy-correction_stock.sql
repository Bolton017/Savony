CREATE OR REPLACE  VIEW MVTSTOCKFILLELIB ("ID", "IDMVTSTOCK", "IDPRODUIT", "IDPRODUITLIB", "ENTREE", "SORTIE", "IDVENTEDETAIL", "IDVENTEDETAILLIB", "IDTRANSFERTDETAIL", "IDTRANSFERTDETAILLIB", "DATY", "IDMAGASIN", "IDMAGASINLIB", "PU", "MONTANT", "LIBELLE", "MVTSRC", "LIBELLEEXACTE", "DATESQL", "IDTYPEMVSTOCK", "IDLOT", "IDOBJET", "IDLOTLIB","COMPTELOCALISATIONLIB") AS
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
    loc.libelle AS complelocalisationlib
FROM MVTSTOCKFILLE m
         LEFT JOIN AS_INGREDIENTS  p ON p.ID = m.IDPRODUIT
         LEFT JOIN MVTSTOCK m2 ON m2.ID = m.IDMVTSTOCK
         LEFT JOIN MAGASIN2 m3 ON m3.ID = m2.IDMAGASIN
         LEFT JOIN LOT l on l.ID = m.IDLOT
         LEFT JOIN localisation loc ON m.comptelocalisation=loc.id;


CREATE OR REPLACE  VIEW V_ETATSTOCK_ENTREE ("ID", "IDPRODUIT", "IDPRODUITLIB", "CATEGORIEINGREDIENT", "IDTYPEPRODUITLIB", "IDMAGASIN", "IDMAGASINLIB", "TYPESTOCK", "QUANTITE", "ENTREE", "SORTIE", "RESTE", "UNITE", "IDUNITELIB", "PU", "DATY", "IDFOURNISSEUR", "IDFOURNISSEURLIB", "DATEACHAT", "PUVENTE", "IDPOINT", "IDTYPEMAGASIN", "SEUILMIN", "SEUILMAX", "MONTANTENTREE", "MONTANTSORTIE", "MONTANTRESTE", "MVTSRC","COMPTELOCALISATION","COMPTELOCALISATIONLIB", "MOTSCLESSS") AS
SELECT SQ.ID,SQ.IDPRODUIT,SQ.IDPRODUITLIB,SQ.CATEGORIEINGREDIENT,SQ.IDTYPEPRODUITLIB,SQ.IDMAGASIN,SQ.IDMAGASINLIB,SQ.TYPESTOCK,CAST(COALESCE(SQ.QUANTITE,0) AS NUMBER(30,5)) AS quantite,cast(COALESCE(SQ.ENTREE,0) as number(30,5)) as entree,cast(COALESCE(SQ.SORTIE,0) as number(30,5)) as sortie,CAST(COALESCE(SQ.RESTE,0) AS NUMBER(30,5)) AS reste,SQ.UNITE,SQ.IDUNITELIB,SQ.PU,SQ.DATY,SQ.IDFOURNISSEUR,SQ.IDFOURNISSEURLIB,SQ.DATEACHAT,CAST(COALESCE(SQ.PUVENTE,0) AS NUMBER(30,5)) AS PUVENTE,SQ.IDPOINT,SQ.IDTYPEMAGASIN,CAST(COALESCE(SQ.SEUILMIN,0) AS NUMBER(30,5)) AS SEUILMIN,CAST(COALESCE(SQ.SEUILMAX,0) AS NUMBER(30,5)) AS SEUILMAX ,CAST(COALESCE(SQ.MONTANTENTREE,0) AS NUMBER(30,5)) AS MONTANTENTREE,CAST(COALESCE(SQ.MONTANTSORTIE,0) AS NUMBER(30,5)) AS MONTANTSORTIE ,CAST(COALESCE(SQ.MONTANTRESTE,0) AS NUMBER(30,5)) AS MONTANTRESTE,  SQ.MVTSRC,SQ.COMPTELOCALISATION,SQ.COMPTELOCALISATIONLIB,
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDPRODUIT),'') || ' | ' || NVL(TO_CHAR(IDPRODUITLIB),'') || ' | ' || NVL(TO_CHAR(CATEGORIEINGREDIENT),'') || ' | ' || NVL(TO_CHAR(IDTYPEPRODUITLIB),'') || ' | ' || NVL(TO_CHAR(IDMAGASIN),'') || ' | ' || NVL(TO_CHAR(IDMAGASINLIB),'') || ' | ' || NVL(TO_CHAR(QUANTITE),'') || ' | ' || NVL(TO_CHAR(ENTREE),'') || ' | ' || NVL(TO_CHAR(SORTIE),'') || ' | ' || NVL(TO_CHAR(RESTE),'') || ' | ' || NVL(TO_CHAR(UNITE),'') || ' | ' || NVL(TO_CHAR(IDUNITELIB),'') || ' | ' || NVL(TO_CHAR(PU),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(IDFOURNISSEUR),'') || ' | ' || NVL(TO_CHAR(IDFOURNISSEURLIB),'') || ' | ' || NVL(TO_CHAR(DATEACHAT,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(PUVENTE),'') || ' | ' || NVL(TO_CHAR(IDPOINT),'') || ' | ' || NVL(TO_CHAR(IDTYPEMAGASIN),'') || ' | ' || NVL(TO_CHAR(SEUILMIN),'') || ' | ' || NVL(TO_CHAR(SEUILMAX),'') || ' | ' || NVL(TO_CHAR(MONTANTENTREE),'') || ' | ' || NVL(TO_CHAR(MONTANTSORTIE),'') || ' | ' || NVL(TO_CHAR(MONTANTRESTE),'') || ' | ' || NVL(TO_CHAR(MVTSRC),'')) AS MOTSCLESSS
FROM (
         SELECT DISTINCT
             ve.id,
             ai.id AS idproduit,
             ai.libelle AS idproduitlib,
             ai.categorieingredient,
             c.val AS idtypeproduitlib,
             ve.idmagasin,
             m.val AS idmagasinlib,
             ai.typestock,
             CAST(ve.quantite AS NUMBER(30,5)) AS quantite,
             CAST(ve.entree AS NUMBER(30,5)) AS entree,
             CAST(ve.sortie AS NUMBER(30,5)) AS sortie,
             CAST(ve.reste AS NUMBER(30,5)) AS reste,
             ai.unite,
             u.val AS idunitelib,
             ve.pu,
             ve.daty,
             ve.idfournisseur,
             f.NOM AS idfournisseurlib,
             ve.dateAchat,
             CAST(NVL(ai.PV, 0) AS NUMBER(30, 5)) AS PUVENTE,
             m.IDPOINT,
             m.IDTYPEMAGASIN,
             ai.SEUILMIN,
             ai.SEUILMAX,
             MONTANTENTREE,
             MONTANTSORTIE,
             MONTANTRESTE,
             ve.MVTSRC,
             ve.COMPTELOCALISATION,
             loc.libelle AS COMPTELOCALISATIONLIB
         FROM (
                  SELECT
                      x.*,
                      COALESCE(b.idfournisseur, invf.idfournisseur, bb.IDFOURNISSEUR,trs.idfournisseur) AS idfournisseur,
                      f.DATY as dateAchat

                  FROM (
                           SELECT
                               ID,
                               IDMVTSTOCK,
                               IDPRODUIT,
                               ENTREE,
                               SORTIE,
                               IDVENTEDETAIL,
                               IDTRANSFERTDETAIL,
                               PU,
                               MVTSRC,
                               DATY,
                               RESTE,
                               QUANTITE,
                               IDMAGASIN,
                               IDINVENTAIREFILLE,
                               MONTANTENTREE,
                               MONTANTSORTIE,
                               MONTANTRESTE,
                               COMPTELOCALISATION
                           FROM (
                                    SELECT
                                        mf.ID,
                                        mf.IDMVTSTOCK,
                                        mf.IDPRODUIT,
                                        nvl(mf.ENTREE,0)+nvl(s.ENTREE,0) as entree,
                                        s.SORTIE,
                                        mf.IDVENTEDETAIL,
                                        mf.IDTRANSFERTDETAIL,
                                        mf.PU,
                                        mf.MVTSRC,
                                        ms.DATY,
                                        NVL(mf.ENTREE, 0) - NVL(s.SORTIE, 0)  + NVL(s.ENTREE, 0) AS RESTE,
                                        NVL(mf.ENTREE, 0) - NVL(s.SORTIE, 0) +  NVL(s.ENTREE, 0) AS QUANTITE,
                                        ms.IDMAGASIN,
                                        mf.idinventairefille,
                                        cast((mf.PU*mf.ENTREE) as number(30,5)) AS MONTANTENTREE,
                                        cast((mf.PU*s.SORTIE) as number(30,5)) AS MONTANTSORTIE,
                                        CAST(NVL(mf.ENTREE, 0) - NVL(s.SORTIE, 0)  + NVL(s.ENTREE, 0) AS NUMBER(30,5)) * mf.PU AS MONTANTRESTE,
                                        mf.COMPTELOCALISATION AS comptelocalisation

                                    FROM MVTSTOCKFILLE mf
                                             LEFT JOIN MVTSTOCK ms ON ms.id = mf.IDMVTSTOCK
                                             LEFT JOIN (
                                        SELECT mf2.MVTSRC, SUM(mf2.SORTIE) AS SORTIE,SUM(mf2.ENTREE) AS ENTREE
                                        FROM MVTSTOCKFILLE mf2
                                                 LEFT JOIN MVTSTOCK ms2 ON ms2.id = mf2.IDMVTSTOCK
                                        WHERE ms2.ETAT >= 11
                                          AND mf2.MVTSRC IS NOT NULL
                                        GROUP BY mf2.MVTSRC
                                    ) s ON s.MVTSRC = mf.id
                                    WHERE mf.ENTREE > 0 and (mf.MVTSRC is null or mf.MVTSRC=mf.id)
                                      AND (ms.IDCATEGORIESTOCK IS NULL
                                        OR ms.IDCATEGORIESTOCK <> 'CTGST000003')
                                      AND ms.ETAT >= 11
                                )
                       ) x
                           LEFT JOIN MVTSTOCK ms  ON ms.id = x.IDMVTSTOCK
                           LEFT JOIN AS_BONDELIVRAISON b ON b.ID = ms.IDOBJET
                           LEFT JOIN AS_BONDELIVRAISON bb ON b.ID = ms.IDTRANSFERT
                           LEFT JOIN FACTUREFOURNISSEUR f on f.id=b.IDFACTUREFOURNISSEUR
                           LEFT JOIN INVENTAIREFILLE invf ON invf.id = x.IDINVENTAIREFILLE
                           LEFT JOIN TRANSFERTSTOCKDETAILS trs ON trs.id = x.IDTRANSFERTDETAIL
                  WHERE b.IDFOURNISSEUR IS NOT NULL OR invf.IDFOURNISSEUR IS NOT NULL or bb.IDFOURNISSEUR IS NOT NULL OR trs.idfournisseur is not null

              ) ve

                  LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT
                  LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
                  LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id
                  LEFT JOIN AS_UNITE u ON ai.UNITE = u.id

                  LEFT JOIN FOURNISSEUR f ON f.ID = ve.idfournisseur
                  LEFT JOIN LOCALISATION loc ON loc.id=ve.COMPTELOCALISATION

         WHERE ve.PU > 0 AND CAST(ve.reste AS NUMBER(30,5)) != 0
     ) SQ;