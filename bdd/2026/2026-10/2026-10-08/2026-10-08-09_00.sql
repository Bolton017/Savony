create or replace view BL_CLIENT_FILLE_GRP_BC as
SELECT
    IDBC_FILLE,
    SUM(QUANTITE) AS QUANTITE
FROM
    AS_BONDELIVRAISON_CLIENT_FILLE abcf
        left join BONDECOMMANDE_CLIENT b on b.id=abcf.NUMBL
        left join AS_BONDELIVRAISON_CLIENT abc on abc.ID = NUMBL
where abc.ETAT =11
GROUP BY IDBC_FILLE;

create or replace view BC_DETAILS_RESTE as
SELECT
    bcf.id AS id,
    bcf.produit,
    bcf.UNITE AS unite,
    bcf.QUANTITE  AS QUANTITE,
    nvl(bcf.QUANTITE,0) - nvl(bl.QUANTITE,0) AS reste,
    bcf.IDBC AS IDBC
FROM
    BONDECOMMANDE_CLIENT_FILLE bcf LEFT JOIN
    BL_CLIENT_FILLE_grp_bc bl ON bcf.ID = bl.idbc_fille;


create view AS_BONLIVRFILLE_CLIENT_CPL_F as
SELECT
    abcf.ID,
    abcf.PRODUIT,
    abcf.NUMBL,
    abcf.QUANTITE,
    abcf.IDVENTEDETAIL,
    abcf.UNITE,
    abcf.IDBC_FILLE,
    p.LIBELLE AS idproduitlib,
    vd.idvente,
    abc.idbc,
    CAST(nvl(s.qtelivree ,0)AS NUMBER(30,2)) AS qtelivree,
--     CAST(nvl(abcf.QUANTITE - CAST(nvl(s.qtelivree ,0)AS NUMBER(30,2))  ,0)AS NUMBER(30,2)) AS qteResteALivrer,
    u.val AS uniteLib,
    vd.PU,
    vd.qte as qtevente,bc_dr.RESTE, vdr.RESTE,
    nvl(bc_dr.RESTE, vdr.RESTE) as qteResteALivrer

FROM AS_BONDELIVRAISON_CLIENT_FILLE abcf
         LEFT JOIN as_ingredients p ON p.id = abcf.produit
         LEFT JOIN VENTE_DETAILS vd ON vd.id = abcf.IDVENTEDETAIL and vd.IDPRODUIT = abcf.PRODUIT
         LEFT JOIN AS_BONDELIVRAISON_CLIENT abc ON abc.id = abcf.numbl
         LEFT JOIN sortiestockfille s ON s.IDPRODUIT = abcf.produit AND s.IDVENTEDETAIL =abcf.IDVENTEDETAIL
         LEFT JOIN AS_UNITE u ON u.id = abcf.UNITE
         LEFT JOIN BC_DETAILS_RESTE bc_dr on bc_dr.id = abcf.IDBC_FILLE
         LEFT JOIN VENTE_DETAILS_RESTE vdr on vdr.id = abcf.IDVENTEDETAIL;