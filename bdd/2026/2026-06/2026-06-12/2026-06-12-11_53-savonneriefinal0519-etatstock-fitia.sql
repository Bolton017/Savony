
create or replace view v_etatstock_entree as
SELECT
    ve.id,
    ai.id AS IDPRODUIT,
    ai.LIBELLE AS idproduitlib,
    ai.CATEGORIEINGREDIENT,
    c.VAL AS idtypeproduitlib,
    ve.IDMAGASIN, ai.typeStock,
    m.VAL AS idmagasinlib,
    ve.QUANTITE,
    CAST(ve.ENTREE AS NUMBER(30,2)) AS ENTREE,
    CAST(ve.SORTIE AS NUMBER(30,2)) AS SORTIE,
    CAST(ve.RESTE AS NUMBER(30,2)) AS RESTE,
    ai.UNITE,
    u.VAL AS idunitelib,
    ve.PU,
    ve.DATY,
    ve.COMPTELOCALISATION,
    ve.COMPTELOCALISATIONLIB
 FROM (
    SELECT
        "ID",
        "IDMVTSTOCK",
        "IDPRODUIT",
        "ENTREE",
        "SORTIE",
        "IDVENTEDETAIL",
        "IDTRANSFERTDETAIL",
        "PU",
        "MVTSRC",
        "DATY",
        "RESTE",
        "QUANTITE",
        "IDMAGASIN",
        "COMPTELOCALISATION",
        "COMPTELOCALISATIONLIB"
    FROM (
        SELECT
            m.ID,
            m.IDMVTSTOCK,
            m.IDPRODUIT,
            m.ENTREE,
            s.SORTIE,
            m.IDVENTEDETAIL,
            m.IDTRANSFERTDETAIL,
            m.PU,
            m.MVTSRC,
            mp.DATY,
            NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) AS RESTE,
            NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) AS QUANTITE,
            mp.IDMAGASIN,
            m.COMPTELOCALISATION,
            loc.LIBELLE as COMPTELOCALISATIONLIB
        FROM MVTSTOCKFILLE m
        LEFT JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK
        LEFT JOIN LOCALISATION loc ON loc.id=m.COMPTELOCALISATION
        LEFT JOIN (
            SELECT m.MVTSRC, SUM(m.SORTIE) AS SORTIE
            FROM MVTSTOCKFILLE m
            LEFT JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK
            WHERE mp.ETAT >= 11
              AND m.MVTSRC IS NOT NULL
            GROUP BY m.MVTSRC
        ) s ON s.MVTSRC = m.id
        WHERE m.ENTREE > 0
          AND mp.ETAT >= 11
    )

 ) ve
 LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT
 LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
 LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id
 LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
 WHERE  ve.PU > 0;


create or replace view v_etatstock_ing as
SELECT
                   '-' as id,ai.typeStock,
                   ai.id AS IDPRODUIT,
                   ai.LIBELLE AS idproduitlib,
                   ai.CATEGORIEINGREDIENT,
                   c.VAL AS idtypeproduitlib,
                   m.id as IDMAGASIN,
                   m.VAL AS idmagasinlib,
                   ve.QUANTITE,
                   CAST(ve.ENTREE AS NUMBER(30,2)) AS ENTREE,
                   CAST(ve.SORTIE AS NUMBER(30,2)) AS SORTIE,
                   CAST(ve.RESTE AS NUMBER(30,2)) AS RESTE,
                   CAST(nvl(ve.ENTREE*ve.pu,0) AS NUMBER(30,2)) AS MONTANTENTREE,
                   CAST(nvl(ve.sortie*ve.pu,0) AS NUMBER(30,2)) AS MONTANTSORTIE,
                   CAST(nvl((ve.ENTREE*ve.pu)-(ve.sortie*ve.pu),0) AS NUMBER(30,2)) AS MONTANTRESTE,
                   ai.UNITE,
                   u.VAL AS idunitelib,
                   case
                       when ve.reste!=0 then CAST(nvl((((ve.ENTREE*ve.pu)-(ve.sortie*ve.pu))/nvl(ve.reste,1)),0) AS NUMBER(30,2))
                        else cast(ai.pu as number(30,2))
                            end as pu,
                   ve.DATY
                FROM (
                   SELECT
                       IDPRODUIT,
                       sum(mf.ENTREE) as ENTREE,
                       sum (mf.SORTIE) SORTIE,
                       '' as IDVENTEDETAIL,
                       '' as IDTRANSFERTDETAIL,
                       avg (mf.PU) as PU,
                       '' as MVTSRC,
                       '' as DATY,
                       (sum(mf.ENTREE)-sum (mf.SORTIE)) as RESTE,
                       0 as QUANTITE,
                       m.IDMAGASIN IDMAGASIN
                   FROM MVTSTOCKFILLE mf
                        left join mvtStock m on m.id=mf.IDMVTSTOCK
                   where m.ETAT>=11
                   group by mf.IDPRODUIT,m.IDMAGASIN
                ) ve
                LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT
                LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
                LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id
                LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
                WHERE  ve.PU > 0 and ve.reste>=0;