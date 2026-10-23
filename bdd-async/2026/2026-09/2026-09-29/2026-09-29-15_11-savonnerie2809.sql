---- cast number(30,2)

CREATE OR REPLACE  VIEW AS_BONDECOMMANDE_CPL_RECEPT (ID, IDBC, PRODUIT, PRODUITLIB, UNITELIB, FOURNISSEUR, FOURNISSEURLIB, QUANTITE, REMISE, MONTANTTVA, MONTANTTTC, MONTANTHT, IDDEVISE, QTELIVRER, QTEFACTURER, PU, MONTANTTTCAR, REMISEMONTANT) AS 
  SELECT
    bc.id,
    bc.idbc,
    bc.produit,
    bc.produitlib,
    bc.unitelib,
    bc.FOURNISSEUR,
    bc.FOURNISSEURLIB,
    CAST(nvl(bc.quantite,0) AS NUMBER(30,2))  AS quantite,
    bc.REMISE,
    bc.montanttva,
    bc.montantttc,
    bc.montantht,
    bc.iddevise,
    CAST(nvl(bl.qte,0) AS NUMBER(30,2)) AS qtelivrer,
    --nvl(ff.qte + ffm.qte,0) AS qtefacturer
    CAST(nvl(ffm.qte,0)  AS NUMBER(30,2)) AS qtefacturer,
    CAST(nvl(bc.pu,0)  AS NUMBER(30,2)) AS pu,
    CAST(nvl(montantttcar,0)  AS NUMBER(30,2)) AS montantttcar,
    CAST(nvl(remiseMontant,0)  AS NUMBER(30,2)) AS remiseMontant
FROM AS_BONDECOMMANDE_CPL bc
         LEFT JOIN ff_fillebl_grp bl ON bc.id = bl.IDBC_FILLE
         --LEFT JOIN ff_fillebc_grp ff ON bc.id = ff.IDBCDETAIL
        left join FF_FILLEBC_GRP_MERE ffm on ffm.IDBC = bc.IDBC and ffm.IDPRODUIT = bc.PRODUIT;