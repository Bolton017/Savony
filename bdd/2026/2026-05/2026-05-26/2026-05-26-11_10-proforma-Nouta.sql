

CREATE OR REPLACE  VIEW "PROFORMAFOURNISSEURDETAILSCPL2" ("ID", "PRODUIT", "IDMERE", "QUANTITE", "PU", "TVA", "TAUXDECHANGE", "UNITE", "REMISE", "REMISEMONTANT", "DATY", "ETAT", "REMARQUE", "DESIGNATION", "MODEPAIEMENT", "FOURNISSEUR", "REFERENCE", "PRODUITLIB", "UNITELIB", "MODEPAIEMENTLIB", "FOURNISSEURLIB", "IDDEVISE", "IDORIGINEMERE", "MONTANT_BRUT", "MONTANT", "MONTANTHT", "MONTANTTVA", "MONTANTTTC") AS 
  SELECT 
    src.ID,
    src.PRODUIT,
    src.IDMERE,
    src.QUANTITE,
    src.PU,
    src.TVA,
    src.TAUXDECHANGE,
    src.UNITE,
    src.REMISE,
    src.REMISEMONTANT,
    src.DATY,
    src.ETAT,
    src.REMARQUE,
    src.DESIGNATION,
    src.MODEPAIEMENT,
    src.FOURNISSEUR,
    src.REFERENCE,
    src.produitlib,
    src.unitelib,
    src.MODEPAIEMENTLIB,
    src.FOURNISSEURLIB,
    src.iddevise,
    src.idoriginemere,
    CAST(src.MONTANT_BRUT AS NUMBER(30,2)) AS MONTANT_BRUT,
    CAST(src.MONTANT_NET_HT AS NUMBER(30,2)) AS MONTANT,
    CAST(src.MONTANT_NET_HT AS NUMBER(30,2)) AS MONTANTHT,
    CAST(
        CASE 
            WHEN NVL(src.TVA, 0) = 0 THEN 0
            ELSE src.MONTANT_NET_HT * (NVL(src.TVA, 0) / 100)
        END 
    AS NUMBER(30,2)) AS MONTANTTVA,
    CAST(
        CASE 
            WHEN NVL(src.TVA, 0) = 0 THEN src.MONTANT_NET_HT
            ELSE src.MONTANT_NET_HT + (src.MONTANT_NET_HT * (NVL(src.TVA, 0) / 100))
        END 
    AS NUMBER(30,2)) AS MONTANTTTC

FROM (
    SELECT 
        bcf.ID,
        bcf.PRODUIT,
        bcf.IDMERE,
        bcf.QUANTITE,
        bcf.PU,
        bcf.TVA,
        bcf.TAUXDECHANGE,
        bcf.UNITE,
        bcf.REMISE,
        bcf.REMISEMONTANT,
        bcf.iddevise,
        ab.DATY,
        ab.ETAT,
        ab.REMARQUE,
        ab.DESIGNATION,
        ab.MODEPAIEMENT,
        ab.FOURNISSEUR,
        ab.REFERENCE,
        ab.IDORIGINE AS idoriginemere,
        p.LIBELLE AS produitlib,
        u.VAL AS unitelib,
        mp.VAL AS MODEPAIEMENTLIB,
        F.nom AS FOURNISSEURLIB,
        
        -- Calcul du brut
        NVL(bcf.QUANTITE, 0) * NVL(bcf.PU, 0) AS MONTANT_BRUT,
        
        -- Calcul du Net HT avec logique de remise priorisée
        (NVL(bcf.QUANTITE, 0) * NVL(bcf.PU, 0)) 
        - 
        CASE 
            WHEN NVL(bcf.REMISE, 0) > 0 THEN 
                (NVL(bcf.QUANTITE, 0) * NVL(bcf.PU, 0)) * (NVL(bcf.REMISE, 0) / 100)
            WHEN NVL(bcf.REMISEMONTANT, 0) > 0 THEN 
                NVL(bcf.REMISEMONTANT, 0)
            ELSE 0 
        END AS MONTANT_NET_HT
        
    FROM PROFORMAFOURNISSEURDETAILS bcf
    LEFT OUTER JOIN PROFORMAFOURNISSEUR AB ON AB.ID = bcf.IDMERE
    LEFT JOIN AS_INGREDIENTS P ON bcf.PRODUIT = P.ID
    LEFT JOIN AS_UNITE u ON bcf.UNITE = u.id
    LEFT JOIN MODEPAIEMENT mp ON AB.MODEPAIEMENT = mp.id
    LEFT JOIN FOURNISSEUR F ON AB.fournisseur = F.id
) src
 
 ;