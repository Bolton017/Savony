create or replace view BC_CLIENT_FILLE_CPL_LIB as
SELECT
    bcf.ID,
    bcf.PRODUIT,
    bcf.IDBC,
    bcf.QUANTITE,
    bcf.PU,
    bcf.MONTANT,
    bcf.TVA,
    bcf.REMISE,
    bcf.IDDEVISE,
    bcf.UNITE,
    i.LIBELLE AS PRODUITlib,
    i.compte_vente AS compte,
    NVL(bcf.quantite, 0) - NVL(vdbc.qte, 0) AS qtereste,
    au.val AS UNITELIB,
    NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) AS MONTANTTOTAL,
    ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE /100)) as montantdelaremise,
    NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) - ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE /100)) as montantremise,
    CAST(
            ( ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) - ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE /100))) * (nvl(bcf.TVA, 0) / 100) )
        AS NUMBER(30,2)
    ) AS MONTANTTVA,
    CAST(
            (((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) - ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE /100))) + (NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) - ((NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0)) * (bcf.REMISE /100))) * (nvl(bcf.TVA, 0) / 100))
        AS NUMBER(30,2)
    ) AS MONTANTTTC
FROM bondecommande_client_fille bcf
         left JOIN as_ingredients i ON i.id = bcf.PRODUIT
         LEFT JOIN vente_details_qte_grp vdbc ON bcf.id = vdbc.idbcfille
         LEFT JOIN AS_UNITE au ON au.id = i.unite;