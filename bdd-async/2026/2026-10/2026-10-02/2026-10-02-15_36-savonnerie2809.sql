-- Sarobidy

CREATE OR REPLACE VIEW BONDECOMMANDE_CLIENT_FILLE_V AS
select p.ID,
       p.PRODUIT,
       p.IDBC,
       p.QUANTITE,
       p.PU,
       p.MONTANT,
       p.TVA,
       p.REMISE,
       p.IDDEVISE,
       p.UNITE,
       p.DESIGNATION,
       '' as unitelib,
       0  as punet,
       0  as montantht,
       0  as montantttc,
       p.RISTOURNE,
       p.TAUXDECHANGE
from BONDECOMMANDE_CLIENT_FILLE p;
 
