create or replace view PROFORMADETAILS_CPL
            (ID, IDPROFORMA, IDPRODUIT, IDORIGINE, QTE, PU, REMISE, TVA, PUACHAT, PUVENTE, IDDEVISE, TAUXDECHANGE,
             DESIGNATION, COMPTE, PUREVIENT, IDDEMANDEPRIXFILLE, IDPROFORMALIB, IDPRODUITLIB, PUTOTAL, UNITE, UNITELIB,
             REMISEMONTANT, MONTANTTOTAL, MONTANTTVA, MONTANTTTC, DATEDEBUT, CALORIE, RISTOURNE)
as
SELECT
    vd.ID,vd.IDPROFORMA,vd.IDPRODUIT,vd.IDORIGINE,vd.QTE,vd.PU,vd.REMISE,vd.TVA,vd.PUACHAT,vd.PUVENTE,v.IDDEVISE,vd.TAUXDECHANGE,vd.DESIGNATION,vd.COMPTE,vd.PUREVIENT,vd.IDDEMANDEPRIXFILLE,
    v.DESIGNATION    AS IDPROFORMALIB,
    p.LIBELLE            AS IDPRODUITLIB,
    cast((vd.QTE * vd.PU) as NUMBER(30,2)) AS puTotal,
    vd.unite,
    au.val AS uniteLib,
    cast(((vd.QTE * vd.PU)*NVL(vd.remise, 0))/100 as NUMBER(30,2)) AS remisemontant,
    cast((vd.QTE * vd.PU)-((vd.QTE * vd.PU)*NVL(vd.remise, 0))/100 as NUMBER(30,2)) as montanttotal,
    (nvl(vd.TVA, 0)/100)*cast((vd.QTE * vd.PU)-((vd.QTE * vd.PU)*NVL(vd.remise, 0))/100 as NUMBER(30,2)) as montanttva,
    cast((vd.QTE * vd.PU)-((vd.QTE * vd.PU)*NVL(vd.remise, 0))/100 as NUMBER(30,2))+(nvl(vd.TVA, 0)/100)*cast((vd.QTE * vd.PU)-((vd.QTE * vd.PU)*NVL(vd.remise, 0))/100 as NUMBER(30,2)) as montantttc,
    vd.datedebut,
    nvl(p.calorie,0) as CALORIE,
    vd.ristourne as ristourne
--       d2.id AS idDevis
FROM PROFORMA_DETAILS vd
         LEFT JOIN PROFORMA v ON v.ID = vd.IDPROFORMA
         LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
         LEFT JOIN AS_UNITE au ON au.id = vd.unite
    /



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
    ) AS MONTANTTTC,
    bcf.ristourne
FROM bondecommande_client_fille bcf
         left JOIN as_ingredients i ON i.id = bcf.PRODUIT
         LEFT JOIN vente_details_qte_grp vdbc ON bcf.id = vdbc.idbcfille
         LEFT JOIN AS_UNITE au ON au.id = i.unite
    /


alter table VENTE_DETAILS add (ristourne number);


create or replace view VENTE_DETAILS_VIDE as
select p.ID,
       p.IDVENTE,
       p.IDPRODUIT,
       p.IDORIGINE,
       p.QTE,
       p.PU,
       p.REMISE,
       p.TVA,
       p.PUACHAT,
       p.PUVENTE,
       p.IDDEVISE,
       p.TAUXDECHANGE,
       p.DESIGNATION,
       p.COMPTE,
       p.PUREVIENT,
       p.IDBCFILLE,
       p.UNITE,
       u.VAL                                                 as unitelib,
       pu - (pu * remise / 100) + ((pu * tva / 100))         as punet,
       (pu - (pu * remise / 100)) * qte                      as montantht,
       (pu - (pu * remise / 100)) * qte + ( ((pu * qte)-(pu * remise / 100) * qte) * tva / 100 ) as montantttc,
       ( ((pu * qte)-(pu * remise / 100) * qte) * tva / 100 )                                as montanttva,
       (pu * remise / 100) * qte                             as montantremise,
       (pu) * qte                                            as montant,
       p.ristourne
from VENTE_DETAILS p
         left join AS_UNITE u on u.id = p.unite
    /


create or replace view VENTE_DETAILS_POIDS as
SELECT
    v.ID,
    v.IDVENTE,
    v.IDPRODUIT,
    v.IDORIGINE,
    CAST(v.QTE AS NUMBER(38,2)) AS QTE,
    v.PU,
    v.REMISE,
    v.TVA,
    v.PUACHAT,
    v.PUVENTE,
    v.IDDEVISE,
    v.TAUXDECHANGE,
    v.DESIGNATION,
    v.COMPTE,
    v.PUREVIENT,
    v.IDBCFILLE,
    v.UNITE,
    v.UNITELIB,
    v.PUNET,
    v.MONTANTHT,
    v.MONTANTTTC,
    v.MONTANTTVA,
    v.MONTANTREMISE,
    v.MONTANT,
    CASE
        WHEN vdc.POIDS IS NULL OR vdc.POIDS = 0 THEN ing.CALORIE
        ELSE vdc.POIDS
        END AS POIDS,
    vc.RESTE AS RESTE,
    ve.fraislivraison * NVL(e.POIDS,0) * NVL(v.QTE,0) AS FRAIS,
    ing.LIBELLE AS IDPRODUITLIB,
    vm.DATY,
    vm.DATYPREVU AS DATYPREVU,
    v.IDDEVISE AS IDDEVISELIB,
    c.VAL AS IDCATEGORIELIB,
    c.VAL AS CATEGORIEPRODUITLIB,
    CAST(
            NVL(v.PU * v.QTE*(1-NVL(v.REMISE,0)/100),0) +
            NVL(v.PU * v.QTE*(1-NVL(v.REMISE,0)/100)*(v.TVA/100),0)
        AS NUMBER(30,2)
    ) AS PUTOTAL,
    cl.nom AS IDCLIENTLIB,
    v.RISTOURNE AS RISTOURNE
FROM VENTE_DETAILS_VIDE v
         LEFT JOIN EQUIVALENCE e
                   ON e.IDPRODUIT = v.IDPRODUIT
                       AND e.IDUNITE = v.UNITE
         LEFT JOIN VENTE_DETAILS_RESTE vc
                   ON vc.ID = v.ID
         LEFT JOIN Vente ve
                   ON ve.ID = v.IDVENTE
         LEFT JOIN VENTE_DETAILS vdc
                   ON vdc.IDVENTE = ve.ID
         LEFT JOIN AS_INGREDIENTS ing
                   ON ing.ID = v.IDPRODUIT
         LEFT JOIN VENTE vm
                   ON vm.ID = v.IDVENTE
         LEFT JOIN CATEGORIEINGREDIENT c
                   ON ing.CATEGORIEINGREDIENT = c.ID
         LEFT JOIN CLIENT cl
                   ON vm.IDCLIENT = cl.ID
                       /


alter table RISTOURNE add (estLiaisonPaiement integer);
alter table RISTOURNE add (idVente varchar(100));