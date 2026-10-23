CREATE OR REPLACE VIEW ORDREDEPAIEMENTLIB AS
SELECT 
    o.*, 
    f.nom AS tiersLib,
    m.val AS modepaiementLib
FROM ORDREDEPAIEMENT o
LEFT JOIN fournisseur f ON f.id = o.tiers
LEFT JOIN modepaiement m ON m.id = o.modepaiement;