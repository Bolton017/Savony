
create or replace view AS_BONDECOMMANDE_MF as
select bcf."ID",bcf."PRODUIT",bcf."IDBC",bcf."QUANTITE",bcf."PU",bcf."MONTANT",bcf."TVA",bcf."UNITE",bcf."REMISE",
       ab.DATY,
       ab.ETAT,
       ab.REMARQUE,
       ab.DESIGNATION,
       ab.MODEPAIEMENT,
       ab.FOURNISSEUR,
       ab.REFERENCE,
       bcf.TAUXDECHANGE
from AS_BONDECOMMANDE_FILLE bcf
         left outer join AS_BONDECOMMANDE AB on AB.ID = bcf.IDBC;

create or replace view AS_BONDECOMMANDE_LIVRE as
select bc."ID",bc."PRODUIT",bc."IDBC",bc."QUANTITE",bc."PU",bc."MONTANT",bc."TVA",bc."UNITE",bc."REMISE",bc."DATY",bc."ETAT",bc."REMARQUE",bc."DESIGNATION",bc."MODEPAIEMENT",bc."FOURNISSEUR",bc."REFERENCE",
       BC.QUANTITE as qte_commande,
       nvl(AB.qte_livre, 0)               as qte_livre,
       BC.QUANTITE - nvl(AB.qte_livre, 0) AS QTE_reste,
       p.LIBELLE as produitlib,
       bc.TAUXDECHANGE
from AS_BONDECOMMANDE_MF bc
         left join AS_BONDELIVRAISON_LIVRE AB on AB.IDBC_FILLE = bc.id
         left join AS_INGREDIENTS p on p.id=bc.PRODUIT;