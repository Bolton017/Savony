
--- ajout pu, montantttcar,remiseMontant
CREATE OR REPLACE  VIEW "AS_BONDECOMMANDE_CPL_RECEPT" AS 
  SELECT
    bc.id,
    bc.idbc,
    bc.produit,
    bc.produitlib,
    bc.unitelib,
    bc.FOURNISSEUR,
    bc.FOURNISSEURLIB,
    nvl(bc.quantite,0) AS quantite,
    bc.REMISE,
    bc.montanttva,
    bc.montantttc,
    bc.montantht,
    bc.iddevise,
    nvl(bl.qte,0) AS qtelivrer,
    --nvl(ff.qte + ffm.qte,0) AS qtefacturer
    nvl(ffm.qte,0) AS qtefacturer,
    nvl(bc.pu,0) AS pu,
    nvl(montantttcar,0) AS montantttcar,
    nvl(remiseMontant,0) AS remiseMontant
FROM AS_BONDECOMMANDE_CPL bc
         LEFT JOIN ff_fillebl_grp bl ON bc.id = bl.IDBC_FILLE
         --LEFT JOIN ff_fillebc_grp ff ON bc.id = ff.IDBCDETAIL
        left join FF_FILLEBC_GRP_MERE ffm on ffm.IDBC = bc.IDBC and ffm.IDPRODUIT = bc.PRODUIT;