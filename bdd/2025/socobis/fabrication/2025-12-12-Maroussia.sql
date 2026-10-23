
CREATE OR REPLACE FORCE VIEW "TABLEAUBORDBC" ("PRODUIT", "MONTANT", "PU", "QUANTITE", "REMISE", "TVA", "UNITE", "QTEOF", "QTEOFRESTANTE", "QTEFAB", "QTEFABRESTANTE", "QTELIVRE", "QTENONLIVRE", "LIBELLEPRODUIT", "DATY") AS
SELECT
    bcf.PRODUIT,
    avg(bcf.MONTANT) as montant,
    avg(bcf.PU) as pu,
    avg(bcf.QUANTITE) as quantite,
    avg(bcf.REMISE) as remise,
    avg(bcf.TVA) as tva,
    ing.UNITE as unite,
    nvl(avg(o.QTE),0) AS QTEOF,
    NVL(sum(bcf.QUANTITE) - nvl(avg(o.QTE),0), 0) AS QTEOFRESTANTE,

    nvl(avg(f.QTE),0) AS QTEFAB,
    NVL(sum(bcf.QUANTITE) - nvl(avg(f.QTE),0), 0) AS QTEFABRESTANTE,

    AVG(NVL(abcf.QUANTITE, 0)) AS QTELIVRE,
    NVL(avg(bcf.QUANTITE) - AVG(NVL(abcf.QUANTITE,0)), 0) AS QTENONLIVRE,
    ing.LIBELLE as libelleProduit,
    bc.DATY

FROM BONDECOMMANDE_CLIENT_FILLE bcf

         LEFT JOIN BONDECOMMANDE_CLIENT bc ON bc.ID = bcf.IDBC

         LEFT JOIN OfGroupByIdbc o ON o.IDBCFILLE = bcf.ID


         LEFT JOIN fabrGroupByIdbc f ON f.IDBCFILLE = bcf.ID

         LEFT JOIN BLGroupByIdbc abcf ON abcf.IDBC_FILLE = bcf.ID

         join AS_INGREDIENTS ing on ing.id=bcf.PRODUIT

GROUP BY
    bcf.PRODUIT,
    ing.LIBELLE, ing.UNITE,bc.DATY;