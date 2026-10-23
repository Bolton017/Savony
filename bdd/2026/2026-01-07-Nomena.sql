create or replace view AS_BONDELIVRAISON_FILLE_VIDE as
SELECT
    cast(' ' as varchar(100)) AS ID,
    cast(' ' as varchar(255)) AS PRODUIT,
    cast(' ' as varchar(255)) AS PRODUITLIB ,
    cast(-1 as NUMBER(10,2) ) AS QUANTITE ,
    cast(' ' as varchar(100)) AS UNITE,
    cast(' ' as varchar(100)) AS NUMBL,
    cast(' ' as varchar(100)) AS IDDETAILSFACTUREFOURNISSEUR,
    cast(' ' as varchar(100)) AS IDBC_FILLE ,
    cast(' ' as varchar(200)) AS REMARQUE ,
    cast(' ' as varchar(100)) AS IDBC ,
    cast(NULL as DATE ) AS DATY ,
    cast(-1 as int ) AS ETAT,
    cast(' ' as varchar(500)) AS MAGASIN ,
    cast(' ' as varchar(255)) AS UNITELIB ,
    cast(' ' as varchar(255)) AS MAGASINLIB,
    cast(-1 as NUMBER(10,2) ) AS pu ,
    cast(' ' as varchar(255)) AS designation

FROM dual;

ALTER TABLE AS_BONDELIVRAISON_FILLE
    add (DESIGNATION VARCHAR2(100));

create or replace view AS_BONDELIVRAISON_LIBCPL as
SELECT
    bl.ID,
    bl.PRODUIT,
    bl.NUMBL,
    bl.QUANTITE,
    bl.IDDETAILSFACTUREFOURNISSEUR,
    bl.UNITE,
    bl.IDBC_FILLE,
    AB.REMARQUE,
    AB.IDBC,
    AB.DATY,
    AB.ETAT,
    AB.MAGASIN,
    p.libelle AS PRODUITlib,
    u.VAL AS UNITElib,
    m.VAL AS magasinlib,
    p.LIBELLEEXTACTE,
    bl.pu,
    bl.DESIGNATION,
    cast(nvl(bl.QUANTITE*bl.PU,0) AS  NUMBER(30,2)) AS MONTANT
FROM
    As_BonDeLivraison_Fille bl
        LEFT JOIN AS_BONDELIVRAISON AB ON
        AB.ID = bl.NUMBL
        LEFT JOIN AS_INGREDIENTS p ON
        bl.PRODUIT = p.ID
        LEFT JOIN AS_UNITE  u ON
        bl.UNITE = u.ID
        LEFT JOIN MAGASIN m ON
        ab.MAGASIN = m.ID;