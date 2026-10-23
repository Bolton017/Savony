
ALTER TABLE MVTSTOCK
ADD IDCATEGORIESTOCK VARCHAR2(200);

CREATE TABLE CATEGORIESTOCK (
    ID     VARCHAR2(50)  PRIMARY key,
    VAL    VARCHAR2(250),
    DESCE  VARCHAR2(250)
);

INSERT INTO CATEGORIESTOCK
(ID, VAL, DESCE)
VALUES('CTGST000001', 'normal', 'normal');
INSERT INTO CATEGORIESTOCK
(ID, VAL, DESCE)
VALUES('CTGST000002', 'retour fabrication', 'retour fabrication');
INSERT INTO CATEGORIESTOCK
(ID, VAL, DESCE)
VALUES('CTGST000003', 'déchets', 'déchets');

/

create view inventaireFilleTypeMvt as
    select f.*,ing.TYPESTOCK from INVENTAIREFILLE f left join AS_INGREDIENTS ing on f.IDPRODUIT=ing.id;

/
    create or replace view V_ETATSTOCK_ENTREE as
SELECT SQ.ID,SQ.IDPRODUIT,SQ.IDPRODUITLIB,SQ.CATEGORIEINGREDIENT,SQ.IDTYPEPRODUITLIB,SQ.IDMAGASIN,SQ.IDMAGASINLIB,SQ.TYPESTOCK,CAST(COALESCE(SQ.QUANTITE,0) AS NUMBER(30,5)) AS quantite,cast(COALESCE(SQ.ENTREE,0) as number(30,5)) as entree,cast(COALESCE(SQ.SORTIE,0) as number(30,5)) as sortie,CAST(COALESCE(SQ.RESTE,0) AS NUMBER(30,5)) AS reste,SQ.UNITE,SQ.IDUNITELIB,SQ.PU,SQ.DATY,SQ.IDFOURNISSEUR,SQ.IDFOURNISSEURLIB,SQ.DATEACHAT,CAST(COALESCE(SQ.PUVENTE,0) AS NUMBER(30,5)) AS PUVENTE,SQ.IDPOINT,SQ.IDTYPEMAGASIN,CAST(COALESCE(SQ.SEUILMIN,0) AS NUMBER(30,5)) AS SEUILMIN,CAST(COALESCE(SQ.SEUILMAX,0) AS NUMBER(30,5)) AS SEUILMAX ,CAST(COALESCE(SQ.MONTANTENTREE,0) AS NUMBER(30,5)) AS MONTANTENTREE,CAST(COALESCE(SQ.MONTANTSORTIE,0) AS NUMBER(30,5)) AS MONTANTSORTIE ,CAST(COALESCE(SQ.MONTANTRESTE,0) AS NUMBER(30,5)) AS MONTANTRESTE,
       (NVL(TO_CHAR(ID),'') || ' | ' || NVL(TO_CHAR(IDPRODUIT),'') || ' | ' || NVL(TO_CHAR(IDPRODUITLIB),'') || ' | ' || NVL(TO_CHAR(CATEGORIEINGREDIENT),'') || ' | ' || NVL(TO_CHAR(IDTYPEPRODUITLIB),'') || ' | ' || NVL(TO_CHAR(IDMAGASIN),'') || ' | ' || NVL(TO_CHAR(IDMAGASINLIB),'') || ' | ' || NVL(TO_CHAR(QUANTITE),'') || ' | ' || NVL(TO_CHAR(ENTREE),'') || ' | ' || NVL(TO_CHAR(SORTIE),'') || ' | ' || NVL(TO_CHAR(RESTE),'') || ' | ' || NVL(TO_CHAR(UNITE),'') || ' | ' || NVL(TO_CHAR(IDUNITELIB),'') || ' | ' || NVL(TO_CHAR(PU),'') || ' | ' || NVL(TO_CHAR(DATY,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(IDFOURNISSEUR),'') || ' | ' || NVL(TO_CHAR(IDFOURNISSEURLIB),'') || ' | ' || NVL(TO_CHAR(DATEACHAT,'YYYY-MM-DD HH24:MI:SS'),'') || ' | ' || NVL(TO_CHAR(PUVENTE),'') || ' | ' || NVL(TO_CHAR(IDPOINT),'') || ' | ' || NVL(TO_CHAR(IDTYPEMAGASIN),'') || ' | ' || NVL(TO_CHAR(SEUILMIN),'') || ' | ' || NVL(TO_CHAR(SEUILMAX),'') || ' | ' || NVL(TO_CHAR(MONTANTENTREE),'') || ' | ' || NVL(TO_CHAR(MONTANTSORTIE),'') || ' | ' || NVL(TO_CHAR(MONTANTRESTE),'')) AS MOTSCLESSS
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
             MONTANTRESTE
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
                               MONTANTRESTE
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
                                        CAST(NVL(mf.ENTREE, 0) - NVL(s.SORTIE, 0)  + NVL(s.ENTREE, 0) AS NUMBER(30,5)) * mf.PU AS MONTANTRESTE

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

         WHERE ve.PU > 0 AND CAST(ve.reste AS NUMBER(30,5)) != 0
     ) SQ

/

create  or replace view V_ETATSTOCK_ING as
SELECT
             ve.idproduit as id ,
             ve.TYPESTOCK,
             ve.idproduitlib,
             ve.categorieingredient,
             ve.idtypeproduitlib,
             ve.idmagasin,
             ve.idmagasinlib,
             TO_DATE('01-01-2001', 'DD-MM-YYYY') AS dateDernierMouvement,
             CAST(SUM(ve.quantite)AS NUMBER(30,5)) AS quantite,
             CAST(SUM(ve.entree)AS NUMBER(30,5)) AS entree,
             CAST(SUM(ve.sortie)AS NUMBER(30,5)) AS sortie,
             CAST(SUM(ve.reste)AS NUMBER(30,5)) AS reste,
             ve.unite,
             ve.idunitelib,
             CAST(ve.puvente AS NUMBER(30,5)) AS puvente,
             ve.IDPOINT,
             ve.IDTYPEMAGASIN,
             ve.SEUILMIN,
             ve.SEUILMAX,
             CAST(SUM(ve.PU * ve.MONTANTENTREE) AS NUMBER(30,5)) AS MONTANTENTREE,
             CAST(SUM(ve.PU * ve.MONTANTSORTIE) AS NUMBER(30,5)) AS MONTANTSORTIE,
             CAST(ve.PU AS NUMBER(30,5)) AS PU,
             CAST(SUM(ve.PU * ve.MONTANTRESTE) AS NUMBER(30,5)) AS MONTANTRESTE
         FROM V_ETATSTOCK_ENTREE ve
         WHERE ve.PU > 0
         GROUP BY
             ve.idproduit,
             ve.idproduitlib,
             ve.categorieingredient,
             ve.idtypeproduitlib,
             ve.idmagasin,
             ve.idmagasinlib,
             ve.unite,
             ve.idunitelib,
             ve.puvente,
             ve.IDPOINT,
             ve.IDTYPEMAGASIN,
             ve.SEUILMIN,
             ve.SEUILMAX,
             ve.PU,
             ve.TYPESTOCK
         ORDER BY ve.idproduit, ve.PU
/