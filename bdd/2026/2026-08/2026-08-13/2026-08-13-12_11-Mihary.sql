CREATE OR REPLACE
    VIEW "AS_BONDECOMMANDE_CPL_FILLE" AS
SELECT
    bcf.ID,
    bcf.PRODUIT,
    bcf.IDBC,
    bcf.QUANTITE,
    bcf.QUANTITE * bcf.PU AS montant,
    bcf.PU,
    bcf.TVA,
    bcf.UNITE,
    bcf.REMISE,
    ab.DATY,
    ab.ETAT,
    ab.DESIGNATION,
    ab.MODEPAIEMENT,
    ab.FOURNISSEUR,
    ab.REFERENCE,
    p.LIBELLE AS produitlib,
    u.VAL AS unitelib,
    mp.VAL AS MODEPAIEMENTLIB,
    F.nom AS FOURNISSEURLIB,
    CAST (((bcf.quantite * bcf.pu)-((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100))) * (bcf.tva / 100) AS NUMBER(30, 2)) AS montanttva,
    CAST( (((((bcf.quantite * bcf.pu + (bcf.quantite * bcf.pu * (bcf.tva / 100)) - bcf.quantite * bcf.pu * (bcf.tva / 100))-(((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100)))))+(((bcf.quantite * bcf.pu)-((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100))) * (bcf.tva / 100)))) AS NUMBER(30, 2)) AS montantttc,
    CAST (((bcf.quantite * bcf.pu + (bcf.quantite * bcf.pu * (bcf.tva / 100)) - bcf.quantite * bcf.pu * (bcf.tva / 100))) AS NUMBER(30, 2)) AS montantht,
    CAST(((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100)) AS NUMBER(30, 2)) AS remiseMontant,
    bcf.iddevise,
    CAST(bcf.TAUXDECHANGE AS NUMBER(30, 2)) AS TAUXDECHANGE,
    CAST( (((((bcf.quantite * bcf.pu + (bcf.quantite * bcf.pu * (bcf.tva / 100)) - bcf.quantite * bcf.pu * (bcf.tva / 100))-(((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100)))))+(((bcf.quantite * bcf.pu)-((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE / 100))) * (bcf.tva / 100))))* bcf.TAUXDECHANGE AS NUMBER(30, 2)) AS MONTANTTTCAR,
    bcf.REMARQUE
FROM
    AS_BONDECOMMANDE_FILLE bcf
        LEFT OUTER JOIN AS_BONDECOMMANDE AB ON
        AB.ID = bcf.IDBC
        LEFT JOIN AS_INGREDIENTS P ON
        bcf.PRODUIT = P.ID
        LEFT JOIN AS_UNITE u ON
        bcf.UNITE = u.id
        LEFT JOIN MODEPAIEMENT mp ON
        AB.MODEPAIEMENT = mp.id
        LEFT JOIN fournisseur F ON
        AB.fournisseur = F.id;