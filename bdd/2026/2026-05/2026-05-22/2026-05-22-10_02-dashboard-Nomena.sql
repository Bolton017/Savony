create or replace view V_TRANSFERT_DASHBOARD as
SELECT
    t.ID,
    t.DESIGNATION,
    t.IDMAGASINDEPART,
    m1.VAL as idMagasinDepartLib,
    t.IDMAGASINARRIVE,
    m2.VAL as idMagasinArriveLib,
    t.DATY,
    t.ETAT,
    CASE WHEN t.ETAT >= 11 THEN 'Validé' ELSE 'En cours' END as statutLib,
    (SELECT SUM(td.QUANTITE * 0) FROM TRANSFERTSTOCKDETAILS td WHERE td.IDTRANSFERTSTOCK = t.ID) as valeurTransferee,
    1 AS nb
FROM TRANSFERTSTOCK t
         JOIN MAGASIN2 m1 ON m1.ID = t.IDMAGASINDEPART
         JOIN MAGASIN2 m2 ON m2.ID = t.IDMAGASINARRIVE;

create or replace view V_STOCK_DASHBOARD as
SELECT
    v."ID",v."IDPRODUIT",v."IDPRODUITLIB",v."CATEGORIEINGREDIENT",v."IDTYPEPRODUITLIB",v."IDMAGASIN",v."IDMAGASINLIB",v."QUANTITE",v."ENTREE",v."SORTIE",v."RESTE",v."UNITE",v."IDUNITELIB",v."PU",v."DATY",v."IDFOURNISSEUR",v."IDFOURNISSEURLIB",v."DATEACHAT",
    (RESTE * PU) AS valeurStock,
    CAST(SUM(QUANTITE) OVER () AS number(30,5))  AS nbArticles
FROM V_ETATSTOCK_ENTREE v;

create or replace view MAGASINPOINTCOMPTE as
select count(*) as NbrMagasin
from MAGASINPOINT;

create or replace view V_INVENTAIRE_ECART_DASHBOARD as
SELECT
    inf.ID,
    inf.IDINVENTAIRE,
    inf.IDPRODUIT,
    p.LIBELLE as idProduitLib,
    inv.IDMAGASIN,
    m.VAL as idMagasinLib,
    (inf.QUANTITE - inf.QUANTITETHEORIQUE) as ecart,
    ((inf.QUANTITE - inf.QUANTITETHEORIQUE) * inf.PU) as valeurEcart,
    inf.DATY
FROM INVENTAIREFILLE inf
         JOIN INVENTAIRE inv ON inv.ID = inf.IDINVENTAIRE
         JOIN AS_INGREDIENTS p ON p.ID = inf.IDPRODUIT
         JOIN MAGASIN2 m ON m.ID = inv.IDMAGASIN;

