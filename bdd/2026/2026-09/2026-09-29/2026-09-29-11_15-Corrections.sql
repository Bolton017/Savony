create or replace view AS_BONDECOMMANDE_FILLE_CPL_U

as
(
SELECT asbc."ID",
       asbc."PRODUIT",
       asbc."IDBC",
       asbc."QUANTITE",
       asbc."PU",
       asbc."MONTANT",
       asbc."TVA",
       asbc."UNITE",
       au.val as UNITELIB,
       asbc."REMISE",
       asbc."IDDEVISE",
       asbc."TAUXDECHANGE",
       asing.libelle      AS PRODUITLIB,
       asbc.remiseMontant AS REMISEMONTANT,
       asbc.REMARQUE      as REMARQUE
FROM AS_BONDECOMMANDE_FILLE asbc
         LEFT JOIN AS_INGREDIENTS asing ON
    asbc.PRODUIT = asing.ID
             left join as_unite au on au.ID = asing.unite);
