create or replace view COMPARAISONPRIXPROFORMA as
SELECT
    p.ID,
    p.PRODUIT,
    p.IDMERE,
    p.QUANTITE,
    p.PU,
    p.TVA,
    p.TAUXDECHANGE,
    p.UNITE,
    p.REMISE,
    p.REMISEMONTANT,
    p.DATY,
    p.ETAT,
    p.REMARQUE,
    p.DESIGNATION,
    p.MODEPAIEMENT,
    p.FOURNISSEUR,
    p.REFERENCE,
    p.PRODUITLIB,
    p.UNITELIB,
    p.MODEPAIEMENTLIB,
    p.FOURNISSEURLIB,
    p.IDDEVISE,
    p.IDORIGINEMERE,
    p.MONTANT_BRUT,
    p.MONTANT,
    p.MONTANTHT,
    p.MONTANTTVA,
    p.MONTANTTTC ,
    p2.etat AS etatfille,
    pf.DATEECHEANCE,
    CASE
        WHEN p2.etat = 11 THEN 'S&eacute;l&eacute;ctionn&eacute;'
        ELSE 'Non S&eacute;l&eacute;ctionn&eacute;'
        END AS etatLib
FROM PROFORMAFOURNISSEURDETAILSCPL2 p
    LEFT JOIN PROFORMAFOURNISSEURDETAILS p2 ON p.id = p2.ID
    LEFT JOIN PROFORMAFOURNISSEUR pf ON p2.IDMERE = pf.id;