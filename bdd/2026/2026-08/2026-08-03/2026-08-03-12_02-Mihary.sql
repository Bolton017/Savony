ALTER TABLE AS_BONDECOMMANDE_FILLE
    ADD REMARQUE VARCHAR(4000) NULL;

create or replace view  AS_BONDECOMMANDE_FILLE_CPL as
(
SELECT asbc."ID",
       asbc."PRODUIT",
       asbc."IDBC",
       asbc."QUANTITE",
       asbc."PU",
       asbc."MONTANT",
       asbc."TVA",
       asbc."UNITE",
       asbc."REMISE",
       asbc."IDDEVISE",
       asbc."TAUXDECHANGE",
       asing.libelle      AS PRODUITLIB,
       asbc.remiseMontant AS REMISEMONTANT,
       asbc.REMARQUE      as REMARQUE
FROM AS_BONDECOMMANDE_FILLE asbc
         LEFT JOIN AS_INGREDIENTS asing ON
    asbc.PRODUIT = asing.ID);
