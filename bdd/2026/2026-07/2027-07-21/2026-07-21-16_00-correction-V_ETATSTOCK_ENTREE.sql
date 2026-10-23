--- 2026-07-20-08_50-view-stock.sql
create or replace view MVTSTOCKFILLEVRAISOURCE as
select ms.ID, ms.IDMVTSTOCK, ms.IDPRODUIT, ms.IDVENTEDETAIL, ms.IDTRANSFERTDETAIL,
       case when  (me.MVTSRC is not null and ms.SORTIE>0)
           then me.MVTSRC
           else ms.MVTSRC
        end as mvtsrc
     ,me.MVTSRC as source2
     , ms.DESIGNATION, ms.ENTREE, ms.SORTIE, ms.PU, ms.RESTE, ms.IDINVENTAIREFILLE from MVTSTOCKFILLE ms left  join
(select m.id, m.idmvtstock, m.idproduit, m.idventedetail, m.idtransfertdetail, m.mvtsrc, m.designation, m.entree, m.sortie, m.pu, m.reste, m.idinventairefille
 from MVTSTOCKFILLE m
where m.entree>0 and m.MVTSRC is not null) me
on me.ID=ms.MVTSRC
left join MVTSTOCK m on m.id=ms.IDMVTSTOCK
where m.IDTYPEMVSTOCK!='TPMVST000023';

create or replace view V_ETATSTOCK_ENTREE as
SELECT
    invdaty,
   cast(invquantite as number(30,2)) as invquantite,
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
   cast(ve.reste*ve.pu as number(30,2)) as montantReste,
   ai.UNITE,
   u.VAL AS idunitelib,
   ve.PU,
   ve.DATY,
   ve.IDFOURNISSEUR,
   ve.IDFOURNISSEURLIB
FROM (
       SELECT
            s.invdaty,
            s.invquantite,
           m.ID,
           m.IDMVTSTOCK,
           m.IDPRODUIT,
           s.ENTREE as entree,
           s.SORTIE,
           m.IDVENTEDETAIL,
           m.IDTRANSFERTDETAIL,
           m.PU,
           m.MVTSRC,
           mp.DATY,
           NVL(s.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0)  AS RESTE,
           NVL(s.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0) AS QUANTITE,
           mp.IDMAGASIN,
           b.IDFOURNISSEUR,
           b.IDFOURNISSEURLIB
       FROM mvtSTockFilleVraiSource m
       LEFT JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK
       LEFT JOIN AS_BONDELIVRAISON_LIB b ON b.ID = mp.IDOBJET

       LEFT JOIN (
           SELECT
    inv.invidproduit AS IDPRODUIT,
    inv.invmvtsrc AS MVTSRC,
    inv.invIdMagasin AS IDMAGASIN,
    inv.invquantite,
    inv.invdaty,
    NVL(mvt.SORTIE, 0) AS SORTIE,
    NVL(mvt.ENTREE, 0) AS ENTREE,
    (NVL(inv.invquantite, 0) + NVL(mvt.ENTREE, 0) - NVL(mvt.SORTIE, 0)) AS STOCK_FINAL
FROM (
    SELECT
        invf.QUANTITE AS invquantite,
        invf.IDPRODUIT AS invidproduit,
        invf.MVTSRC AS invmvtsrc,
        im.daty AS invdaty,
        im.IDMAGASIN AS invIdMagasin
    FROM INVENTAIREFILLE invF
    LEFT JOIN inventaire im ON im.ID = invf.IDINVENTAIRE
    WHERE im.ETAT >= 11
      AND im.daty = (
          SELECT MAX(im2.daty)
          FROM INVENTAIREFILLE invf2
          LEFT JOIN inventaire im2 ON im2.id = invf2.IDINVENTAIRE
          WHERE im2.ETAT >= 11
            AND invf2.IDPRODUIT = invf.IDPRODUIT
            AND invf2.MVTSRC = invf.MVTSRC
            AND im2.IDMAGASIN = im.IDMAGASIN
      )
) inv

LEFT JOIN (
    SELECT
        m.MVTSRC,
        mp.IDMAGASIN,
        m.IDPRODUIT,
        SUM(m.SORTIE) AS SORTIE,
        SUM(m.ENTREE) AS ENTREE
    FROM mvtSTockFilleVraiSource m
    JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK
    LEFT JOIN (
        SELECT
            invf3.IDPRODUIT,
            invf3.MVTSRC,
            im3.IDMAGASIN,
            MAX(im3.DATY) AS max_invdaty
        FROM INVENTAIREFILLE invf3
        LEFT JOIN INVENTAIRE im3 ON im3.id = invf3.IDINVENTAIRE
        WHERE im3.ETAT >= 11
        GROUP BY invf3.IDPRODUIT, invf3.MVTSRC, im3.IDMAGASIN
    ) inv_ref ON inv_ref.IDPRODUIT = m.IDPRODUIT
             AND inv_ref.MVTSRC = m.MVTSRC
             AND inv_ref.IDMAGASIN = mp.IDMAGASIN
    WHERE mp.ETAT >= 11
      AND mp.DATY > inv_ref.max_invdaty
    GROUP BY m.MVTSRC, mp.IDMAGASIN, m.IDPRODUIT
) mvt
  ON mvt.IDPRODUIT = inv.invidproduit
 AND mvt.MVTSRC = inv.invmvtsrc
 AND mvt.IDMAGASIN = inv.invIdMagasin
       ) s ON s.MVTSRC = m.id and s.IDMAGASIN=mp.IDMAGASIN
       WHERE  m.ENTREE > 0 --and m.MVTSRC IS NULL
         AND mp.ETAT >= 11
) ve
LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT
LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id
LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
WHERE ve.PU > 0 and ve.reste !=0;

--- 2026-07-20-11_18-rectif-stock.sql

create or replace view inventaireMereVide as
select 'invVide' as id, TO_DATE('01/01/2026', 'DD-MM-YYYY') as daty, 'inventaire vide' as designation,'' as idmagasin,11 as etat from dual;

create or replace view inventaireMereVideMagasin as
select inventaireMereVide.id, daty, designation, magasin2.id as idmagasin, inventaireMereVide.etat,'inv vide' as remarque,null as idcategorie from inventaireMereVide,magasin2;

create or replace view mvtStockFilleSansInventaire as
select mf.* from mvtStockFille mf
                     left join mvtStock m on m.id=mf.IDMVTSTOCK
where m.ETAT>=11 and mf.entree>0
  and not exists(select invf.id from INVENTAIREFILLE invf left join INVENTAIRE im on im.ID=invf.IDINVENTAIRE where invf.IDPRODUIT=mf.IDPRODUIT and invf.MVTSRC=mf.id and im.IDMAGASIN=m.IDMAGASIN);

create or replace view inventaireFilleVide as
    select 'invf'||mfv.ID as id,'invVide' as idinventaire,mfv.IDPRODUIT,'inv Auto Vide' as explication,null as idjauge,cast( 0 as number(30,10)) as QUANTITETHEORIQUE,cast(0 as number(30,10)) as quantite,mfv.ID as mvtsource
         ,cast(1 as number(30,5)) as pu,null as idfournisseur, null as daty from mvtStockFilleSansInventaire mfv;

create or replace view inventaireFilleAvecVide as select * from INVENTAIREFILLE union all select * from inventaireFilleVide;
create or replace view inventaireAvecVide as
select * from INVENTAIRE union all select * from inventaireMereVideMagasin;


create or replace view V_ETATSTOCK_ENTREE as
SELECT
    invdaty,
   cast(invquantite as number(30,2)) as invquantite,
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
   cast(ve.reste*ve.pu as number(30,2)) as montantReste,
   ai.UNITE,
   u.VAL AS idunitelib,
   ve.PU,
   ve.DATY,
   ve.IDFOURNISSEUR,
   ve.IDFOURNISSEURLIB
FROM (
       SELECT
            s.invdaty,
            s.invquantite,
           m.ID,
           m.IDMVTSTOCK,
           m.IDPRODUIT,
           m.ENTREE as entree,
           s.SORTIE,
           m.IDVENTEDETAIL,
           m.IDTRANSFERTDETAIL,
           m.PU,
           m.MVTSRC,
           mp.DATY,
           NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0)  AS RESTE,
           NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0) AS QUANTITE,
           mp.IDMAGASIN,
           b.IDFOURNISSEUR,
           b.IDFOURNISSEURLIB
       FROM mvtSTockFilleVraiSource m
       LEFT JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK
       LEFT JOIN AS_BONDELIVRAISON_LIB b ON b.ID = mp.IDOBJET

       LEFT JOIN (
           SELECT
    inv.invidproduit AS IDPRODUIT,
    inv.invmvtsrc AS MVTSRC,
    inv.invIdMagasin AS IDMAGASIN,
    inv.invquantite,
    inv.invdaty,
    NVL(mvt.SORTIE, 0) AS SORTIE,
    NVL(mvt.ENTREE, 0) AS ENTREE,
    (NVL(inv.invquantite, 0) + NVL(mvt.ENTREE, 0) - NVL(mvt.SORTIE, 0)) AS STOCK_FINAL
FROM (
    SELECT
        invf.QUANTITE AS invquantite,
        invf.IDPRODUIT AS invidproduit,
        invf.MVTSRC AS invmvtsrc,
        im.daty AS invdaty,
        im.IDMAGASIN AS invIdMagasin
    FROM INVENTAIREFILLEAvecVide invF
    LEFT JOIN inventaireAvecVide im ON im.ID = invf.IDINVENTAIRE
    WHERE im.ETAT >= 11
      AND im.daty = (
          SELECT MAX(im2.daty)
          FROM INVENTAIREFILLEAvecVide invf2
          LEFT JOIN inventaireAvecVide im2 ON im2.id = invf2.IDINVENTAIRE
          WHERE im2.ETAT >= 11
            AND invf2.IDPRODUIT = invf.IDPRODUIT
            AND invf2.MVTSRC = invf.MVTSRC
            AND im2.IDMAGASIN = im.IDMAGASIN
      )
) inv

LEFT JOIN (
    SELECT
        m.MVTSRC,
        mp.IDMAGASIN,
        m.IDPRODUIT,
        SUM(m.SORTIE) AS SORTIE,
        SUM(m.ENTREE) AS ENTREE
    FROM mvtSTockFilleVraiSource m
    JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK
    LEFT JOIN (
        SELECT
            invf3.IDPRODUIT,
            invf3.MVTSRC,
            im3.IDMAGASIN,
            MAX(im3.DATY) AS max_invdaty
        FROM INVENTAIREFILLEAvecVide invf3
        LEFT JOIN inventaireAvecVide im3 ON im3.id = invf3.IDINVENTAIRE
        WHERE im3.ETAT >= 11
        GROUP BY invf3.IDPRODUIT, invf3.MVTSRC, im3.IDMAGASIN
    ) inv_ref ON inv_ref.IDPRODUIT = m.IDPRODUIT
             AND inv_ref.MVTSRC = m.MVTSRC
             AND inv_ref.IDMAGASIN = mp.IDMAGASIN
    WHERE mp.ETAT >= 11
      AND mp.DATY > inv_ref.max_invdaty
    GROUP BY m.MVTSRC, mp.IDMAGASIN, m.IDPRODUIT
) mvt
  ON mvt.IDPRODUIT = inv.invidproduit
 AND mvt.MVTSRC = inv.invmvtsrc
 AND mvt.IDMAGASIN = inv.invIdMagasin
       ) s ON s.MVTSRC = m.id and s.IDMAGASIN=mp.IDMAGASIN
       WHERE  m.ENTREE > 0 --and m.MVTSRC IS NULL
         AND mp.ETAT >= 11
) ve
LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT
LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id
LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
WHERE
    ve.PU > 0
  and ve.reste !=0;


-- 2026-07-20-12_31-rectif-view-stock.sql
create or replace view V_ETATSTOCK_ENTREE as
SELECT
    invdaty,
    cast(invquantite as number(30,2)) as invquantite,
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
   cast(ve.reste*ve.pu as number(30,2)) as montantReste,
   ai.UNITE,
   u.VAL AS idunitelib,
   ve.PU,
   ve.DATY,
   ve.IDFOURNISSEUR,
   ve.IDFOURNISSEURLIB
FROM (
       SELECT
            s.invdaty,
            s.invquantite,
           m.ID,
           m.IDMVTSTOCK,
           m.IDPRODUIT,
           case when s.invFid like 'invvidef%'
           then m.ENTREE
           else s.entree end
               as entree,
           s.SORTIE,
           m.IDVENTEDETAIL,
           m.IDTRANSFERTDETAIL,
           m.PU,
           m.MVTSRC,
           mp.DATY,
           case when s.invFid like 'invvidef%'
           then NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0)
           else NVL(s.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0)
           end    AS RESTE,
           case when s.invFid like 'invvidef%'
           then NVL(m.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0)
           else NVL(s.ENTREE, 0) - NVL(s.SORTIE, 0) + NVL(s.invquantite, 0)
           end AS QUANTITE,
           mp.IDMAGASIN,
           b.IDFOURNISSEUR,
           b.IDFOURNISSEURLIB
       FROM mvtSTockFilleVraiSource m
       LEFT JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK
       LEFT JOIN AS_BONDELIVRAISON_LIB b ON b.ID = mp.IDOBJET

       LEFT JOIN (
           SELECT
    inv.invidproduit AS IDPRODUIT,
    inv.invmvtsrc AS MVTSRC,
    inv.invIdMagasin AS IDMAGASIN,
    inv.invquantite,
    inv.invdaty,
    NVL(mvt.SORTIE, 0) AS SORTIE,
    NVL(mvt.ENTREE, 0) AS ENTREE,
    inv.invFid,
    (NVL(inv.invquantite, 0) + NVL(mvt.ENTREE, 0) - NVL(mvt.SORTIE, 0)) AS STOCK_FINAL
FROM (
    SELECT
        invf.QUANTITE AS invquantite,
        invf.IDPRODUIT AS invidproduit,
        invf.MVTSRC AS invmvtsrc,
        im.daty AS invdaty,
        im.IDMAGASIN AS invIdMagasin,
        invf.id as invFid
    FROM inventaireFilleAvecVide invF
    LEFT JOIN inventaireAvecVide im ON im.ID = invf.IDINVENTAIRE
    WHERE im.ETAT >= 11
      AND im.daty = (
          SELECT MAX(im2.daty)
          FROM inventaireFilleAvecVide invf2
          LEFT JOIN inventaireAvecVide im2 ON im2.id = invf2.IDINVENTAIRE
          WHERE im2.ETAT >= 11
            AND invf2.IDPRODUIT = invf.IDPRODUIT
            AND invf2.MVTSRC = invf.MVTSRC
            AND im2.IDMAGASIN = im.IDMAGASIN
          --  AND im2.daty <= TO_DATE('20/07/2026', 'DD-MM-YYYY')
      )
) inv

LEFT JOIN (
    SELECT
        m.MVTSRC,
        mp.IDMAGASIN,
        m.IDPRODUIT,
        SUM(m.SORTIE) AS SORTIE,
        SUM(m.ENTREE) AS ENTREE
    FROM mvtSTockFilleVraiSource m
    JOIN MVTSTOCK mp ON mp.id = m.IDMVTSTOCK
    LEFT JOIN (
        SELECT
            invf3.IDPRODUIT,
            invf3.MVTSRC,
            im3.IDMAGASIN,
            MAX(im3.DATY) AS max_invdaty
        FROM inventaireFilleAvecVide invf3
        LEFT JOIN inventaireAvecVide im3 ON im3.id = invf3.IDINVENTAIRE
        WHERE im3.ETAT >= 11
        --  AND im3.DATY <= TO_DATE('20/07/2026', 'DD-MM-YYYY')
        GROUP BY invf3.IDPRODUIT, invf3.MVTSRC, im3.IDMAGASIN
    ) inv_ref ON inv_ref.IDPRODUIT = m.IDPRODUIT
             AND inv_ref.MVTSRC = m.MVTSRC
             AND inv_ref.IDMAGASIN = mp.IDMAGASIN
    WHERE mp.ETAT >= 11
      --AND mp.DATY <= TO_DATE('20/07/2026', 'DD-MM-YYYY')
      AND mp.DATY > inv_ref.max_invdaty
    and m.IDPRODUIT='ING000T0108'
    GROUP BY m.MVTSRC, mp.IDMAGASIN, m.IDPRODUIT
) mvt
  ON mvt.IDPRODUIT = inv.invidproduit
 AND mvt.MVTSRC = inv.invmvtsrc
 AND mvt.IDMAGASIN = inv.invIdMagasin
       ) s ON s.MVTSRC = m.id and s.IDMAGASIN=mp.IDMAGASIN
       WHERE  m.ENTREE > 0 --and m.MVTSRC IS NULL
         AND mp.ETAT >= 11
         --AND mp.DATY <= TO_DATE('20/07/2026', 'DD-MM-YYYY')
) ve
LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT
LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
LEFT JOIN MAGASINPOINT m ON ve.IDMAGASIN = m.id
LEFT JOIN AS_UNITE u ON ai.UNITE = u.id
WHERE
    ve.PU > 0
  and ve.reste !=0;

-- 2026-07-20-12_56-view-vide-stock.sql
create or replace view inventaireFilleVide as
    select 'invvidef'||mfv.ID as id,'invVide' as idinventaire,mfv.IDPRODUIT,'inv Auto Vide' as explication,null as idjauge,cast( 0 as number(30,10)) as QUANTITETHEORIQUE,cast(0 as number(30,10)) as quantite,mfv.ID as mvtsource
         ,cast(1 as number(30,5)) as pu,null as idfournisseur, null as daty from mvtStockFilleSansInventaire mfv;

