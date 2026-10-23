CREATE OR REPLACE VIEW AS_BONDECOMMANDE_FILLE_CPL AS
       SELECT asbc.*, asing.libelle AS PRODUITLIB FROM AS_BONDECOMMANDE_FILLE asbc
       LEFT JOIN AS_INGREDIENTS asing ON asbc.PRODUIT = asing.ID;

CREATE OR REPLACE VIEW AS_BONDECOMMANDE_LIVRE AS
select bc."ID",bc."PRODUIT",bc."IDBC",bc."QUANTITE",bc."PU",bc."MONTANT",bc."TVA",bc."UNITE",bc."REMISE",bc."DATY",bc."ETAT",bc."REMARQUE",bc."DESIGNATION",bc."MODEPAIEMENT",bc."FOURNISSEUR",bc."REFERENCE",
       BC.QUANTITE as qte_commande,
       nvl(AB.qte_livre, 0)               as qte_livre,
       BC.QUANTITE - nvl(AB.qte_livre, 0) AS QTE_reste,
       p.LIBELLE as produitlib
from AS_BONDECOMMANDE_MF bc
         left join AS_BONDELIVRAISON_LIVRE AB on AB.IDBC_FILLE = bc.id
         left join AS_INGREDIENTS p on p.id=bc.PRODUIT
;

CREATE OR REPLACE VIEW AS_BONDECOMMANDE_CPL AS
select bcf.ID,bcf.PRODUIT,bcf.IDBC,bcf.QUANTITE,bcf.QUANTITE*bcf.PU AS montant,bcf.PU,bcf.TVA,bcf.UNITE,bcf.REMISE,
       ab.DATY,
       ab.ETAT,
       ab.REMARQUE,
       ab.DESIGNATION,
       ab.MODEPAIEMENT,
       ab.FOURNISSEUR,
       ab.REFERENCE,
       p.LIBELLE  as produitlib,
       u.VAL  as unitelib,
       mp.VAL as MODEPAIEMENTLIB,
       F.nom  AS FOURNISSEURLIB,
       CAST (bcf.quantite * bcf.pu * (bcf.tva/100) AS NUMBER(30,2)) AS montanttva,
       CAST( bcf.quantite * bcf.pu + (bcf.quantite * bcf.pu * (bcf.tva/100)) AS NUMBER(30,2)) AS montantttc,
       CAST (bcf.quantite * bcf.pu + (bcf.quantite * bcf.pu  * (bcf.tva/100)) - bcf.quantite * bcf.pu * (bcf.tva/100) AS NUMBER(30,2)) AS montantht,
       bcf.iddevise,
       CAST(bcf.TAUXDECHANGE AS NUMBER(30,2)) AS TAUXDECHANGE,
       CAST((bcf.quantite * bcf.pu + (bcf.quantite * bcf.pu * (bcf.tva/100))) * bcf.TAUXDECHANGE AS NUMBER(30,2)) AS MONTANTTTCAR
from AS_BONDECOMMANDE_FILLE bcf
         left outer join AS_BONDECOMMANDE AB on AB.ID = bcf.IDBC
         left join AS_INGREDIENTS P on bcf.PRODUIT = P.ID
         left join AS_UNITE u on bcf.UNITE = u.id
         left join MODEPAIEMENT mp on AB.MODEPAIEMENT = mp.id
         left join fournisseur F on AB.fournisseur = F.id;