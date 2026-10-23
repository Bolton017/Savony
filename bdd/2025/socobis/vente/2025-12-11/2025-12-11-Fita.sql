alter table VENTE_DETAILS add (poids number(30,5));

create OR REPLACE view VENTE_DETAILS_POIDS
            (ID, IDVENTE, IDPRODUIT, IDORIGINE, QTE, PU, REMISE, TVA, PUACHAT, PUVENTE, IDDEVISE, TAUXDECHANGE,
             DESIGNATION, COMPTE, PUREVIENT, IDBCFILLE, UNITE, UNITELIB, PUNET, MONTANTHT, MONTANTTTC, MONTANTTVA,
             MONTANTREMISE, MONTANT, POIDS, RESTE, FRAIS, IDPRODUITLIB, DATY, DATYPREVU, IDDEVISELIB, IDCATEGORIELIB,
             CATEGORIEPRODUITLIB, PUTOTAL, IDCLIENTLIB)
as
SELECT
    v.ID,
    v.IDVENTE,
    v.IDPRODUIT,
    v.IDORIGINE,
    CAST(v.QTE as number(38,2)),
    v.PU,
    v.REMISE,
    v.TVA,
    v.PUACHAT,
    v.PUVENTE,
    v.IDDEVISE,
    v.TAUXDECHANGE,
    v.DESIGNATION,
    v.COMPTE,
    v.PUREVIENT,
    v.IDBCFILLE,
    v.UNITE,
    v.UNITELIB,
    v.PUNET,
    v.MONTANTHT,
    v.MONTANTTTC,
    v.MONTANTTVA,
    v.MONTANTREMISE,
    v.MONTANT,
    CASE WHEN vdc.POIDS IS NULL OR vdc.POIDS = 0 THEN ing.CALORIE ELSE vdc.POIDS END AS POIDS,
    vc.reste AS reste,
    ve.fraislivraison * nvl(e.POIDS, 0)* nvl(v.QTE, 0) AS frais,
    ing.LIBELLE AS idproduitlib,
    vm.DATY,
    vm.DATYPREVU AS DATYPREVU,
    v.IDDEVISE AS IDDEVISELIB,
    c.VAL AS IDCATEGORIELIB,
    c.VAL AS categorieproduitlib,
    CAST(nvl(v.PU * v.QTE*(1-nvl(v.REMISE,0)/100), 0) +nvl(v.PU * v.QTE*(1-nvl(v.REMISE,0)/100) *(v.TVA/100), 0) AS number(30,2)) AS puTotal,
    cl.nom AS idclientlib
FROM
    VENTE_DETAILS_VIDE v
        LEFT JOIN EQUIVALENCE e ON
        (e.IDPRODUIT = v.IDPRODUIT
            AND e.IDUNITE = v.unite)
        LEFT JOIN VENTE_DETAILS_RESTE vc ON
        vc.ID = v.ID
        LEFT JOIN Vente ve ON
        ve.ID = v.IDVENTE
        LEFT JOIN VENTE_DETAILS vdc ON
        vdc.IDVENTE = ve.ID
        LEFT JOIN AS_INGREDIENTS ing ON
        ing.ID = v.IDPRODUIT
        LEFT JOIN VENTE vm ON vm.ID = v.IDVENTE
        LEFT JOIN CATEGORIEINGREDIENT c  ON ing.CATEGORIEINGREDIENT  = c.ID
        LEFT JOIN CLIENT cl  ON vm.idclient  = cl.ID;