alter table FOURNISSEUR add (taxe number);
alter table FOURNISSEUR add (echeance number);

create or replace view AS_BONDECOMMANDE_CPL_RECEPT as
SELECT
    bc.id,
    bc.idbc,
    bc.produitlib,
    bc.unitelib,
    bc.produit,
    nvl(bc.quantite,0) AS quantite,
    nvl(bl.qte,0) AS qtelivrer,
    nvl(ff.qte,0) AS qtefacturer
FROM AS_BONDECOMMANDE_CPL bc
         LEFT JOIN ff_fillebl_grp bl ON bc.id = bl.IDBC_FILLE
         LEFT JOIN ff_fillebc_grp ff ON bc.id = ff.IDBCDETAIL
/