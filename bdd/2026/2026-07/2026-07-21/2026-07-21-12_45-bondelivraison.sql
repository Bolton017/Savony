create or replace view AS_BLCLFILLEGRP_VENTE_CPL_V1 as
SELECT
    a.PRODUIT ,
    a.IDPRODUITLIB,
    a.IDVENTE,
    abc.daty,
    nvl( sum(QUANTITE) ,0) AS QUANTITE,
    a.UNITE,
    u.VAL AS unitelib,
    a.NUMBL
FROM AS_BONLIVRFILLE_CLIENT_CPL a
         LEFT JOIN AS_BONDELIVRAISON_CLIENT abc ON abc.id = a.numbl
         left join AS_UNITE u on u.id = a.unite
WHERE abc.etat = 11
GROUP BY a.IDPRODUITLIB,
         a.IDVENTE,a.PRODUIT,abc.daty
        , a.UNITE,u.val, a.NUMBL;