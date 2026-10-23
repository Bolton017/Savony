
CREATE OR REPLACE VIEW "AS_BCFILLECALC"  AS 
  select 
       bcf.ID,
       bcf.PRODUIT,
       bcf.IDBC,
       bcf.PU,
       bcf.TVA,
       bcf.UNITE,
       bcf.REMISE,
       bcf.IDDEVISE,
       bcf.TAUXDECHANGE,
       bcf.DESIGNATION,
       nvl(bcf.QUANTITE,0) AS QUANTITE,
       cast(NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) as Number(30, 2)) AS montant,

       CAST(cast(NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) as Number(30, 2)) * (1-(nvl(bcf.REMISE,0)/100))*(1-(nvl(ab.REMISE,0)/100)) as number(30,2)) as montantremise,
       
       cast( cast(NVL(bcf.PU, 0) * NVL(bcf.QUANTITE, 0) as Number(30, 2)) * (CAST(1  - (1-(nvl(bcf.REMISE,0)/100))*(1-(nvl(ab.REMISE,0)/100)) as number(30,2))) as Number(30, 2)) as montantdelaremise,

       cast(bcf.QUANTITE*bcf.pu*(1-(nvl(bcf.REMISE,0)/100))*(1-(nvl(ab.REMISE,0)/100))*nvl(bcf.tva,0)/100 as number(30,2)) as montanttva ,

       cast(bcf.QUANTITE*bcf.pu*(1-(nvl(bcf.REMISE,0)/100))*(1-(nvl(ab.REMISE,0)/100))*(1+(nvl(bcf.tva,0)/100)) as number(30,2)) as montantttc,

       cast(bcf.QUANTITE*bcf.pu*(1-(nvl(bcf.REMISE,0)/100))*(1-(nvl(ab.REMISE,0)/100)) as number(30,2)) as montantht,

       cast(bcf.QUANTITE*bcf.pu*(1-(nvl(bcf.REMISE,0)/100))*(1-(nvl(ab.REMISE,0)/100))*(1+(nvl(bcf.tva,0)/100))*nvl(bcf.TAUXDECHANGE,1) as number(30,2)) as montantttcAr,
       ab.DATY,
       ab.ETAT,
       ab.REMARQUE,
       ab.DESIGNATION as DESIGNATIONMERE,
       ab.MODEPAIEMENT,
       ab.FOURNISSEUR,
       ab.REFERENCE

from AS_BONDECOMMANDE_FILLE bcf join AS_BONDECOMMANDE ab on ab.id = bcf.IDBC  
 ;

CREATE OR REPLACE VIEW "AS_BONDECOMMANDE_CPL" AS 
select bcf.ID,bcf.PRODUIT,bcf.IDBC,bcf.QUANTITE,bcf.QUANTITE*bcf.PU AS montant,bcf.PU,bcf.TVA,bcf.UNITE,bcf.REMISE,
       bcf.DATY,
       bcf.ETAT,
       bcf.REMARQUE,
--       bcf.DESIGNATION,
       bcf.MODEPAIEMENT,
       bcf.FOURNISSEUR,
       bcf.REFERENCE,
       p.LIBELLE  as produitlib,
       u.VAL  as unitelib,
       mp.VAL as MODEPAIEMENTLIB,
       F.nom  AS FOURNISSEURLIB,
       CAST(bcf.montantdelaremise AS NUMBER(30,2)) AS remiseMontant,
       CAST(bcf.montantht AS NUMBER(30,2)) AS  montantht,
       CAST(bcf.montanttva AS NUMBER(30,2)) AS   montanttva,
       CAST(bcf.montantttc AS NUMBER(30,2)) AS  montantttc,
       bcf.iddevise,
       CAST(bcf.montantttcAr AS NUMBER(30,2)) AS  montantttcar,
       bcf.TAUXDECHANGE,
       bcf.designation,
       CASE
	    WHEN ETAT = 0 THEN 'ANNUL&Eacute;'
        WHEN ETAT = 1 THEN 'CR&Eacute;&Eacute;'
       	WHEN etat = 4 THEN 'VIS&Eacute; PAR CI'
       	WHEN etat = 9 THEN 'VIS&Eacute; PAR CG'
       	WHEN etat = 11 THEN 'VIS&Eacute; PAR PDG'
       END AS etatLib
       
from AS_BCFILLECALC bcf
         left join AS_INGREDIENTS P on bcf.PRODUIT = P.ID
         left join AS_UNITE u on bcf.UNITE = u.id
         left join MODEPAIEMENT mp on bcf.MODEPAIEMENT = mp.id
         left join fournisseur F on bcf.fournisseur = F.id

 ;


CREATE OR REPLACE VIEW AS_BONDECOMMANDE_CPL_RECEPT  AS 
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
    CAST(bc.montanttva AS NUMBER(30,2)) as montanttva,
    CAST(bc.montantttc AS NUMBER(30,2)) as montantttc ,
    CAST(bc.montantht AS NUMBER(30,2)) as montantht,
    bc.iddevise,
    CAST(nvl(bl.qte,0) AS NUMBER(30,2)) AS qtelivrer,
    --nvl(ff.qte + ffm.qte,0) AS qtefacturer
    CAST(nvl(ffm.qte,0)  AS NUMBER(30,2)) AS qtefacturer,
    CAST(nvl(bc.pu,0)  AS NUMBER(30,2)) AS pu,
    CAST(nvl(montantttcar,0)  AS NUMBER(30,2)) AS montantttcar,
    CAST(nvl(remiseMontant,0)  AS NUMBER(30,2)) AS remiseMontant,
    CAST(nvl(montant,0)  AS NUMBER(30,2)) AS montant,
    bc.designation
FROM AS_BONDECOMMANDE_CPL bc
         LEFT JOIN ff_fillebl_grp bl ON bc.id = bl.IDBC_FILLE
         --LEFT JOIN ff_fillebc_grp ff ON bc.id = ff.IDBCDETAIL
        left join FF_FILLEBC_GRP_MERE ffm on ffm.IDBC = bc.IDBC and ffm.IDPRODUIT = bc.PRODUIT;


CREATE OR REPLACE VIEW FFFILLECALC  AS 
  select vd.ID,vd.IDFACTUREFOURNISSEUR,vd.IDPRODUIT,vd.PU,vd.REMISES,vd.IDBCDETAIL,vd.TVA,vd.DEVISE,vd.TAUXDECHANGE,vd.IDDEVISE,vd.DESIGNATION,vd.COMPTE,vd.MOIS,vd.ANNEE,vd.QTE,vd.MONTANTPERTEGAIN,vd.IDMAGASIN,vd.IDPREVISION,vd.REMISEMONTANT,vd.REMISE,vd.RISTOURNE,
       cast(vd.QTE*vd.pu as number(30,2)) as montantNonRemise,
       cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*(1-(nvl(f.REMISE,0)/100)) as number(30,2)) as montantHT,

       cast(vd.QTE*vd.pu as number(30,2)) *  (cast( 1 - (1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*(1-(nvl(f.REMISE,0)/100)) as number(30,2)))  as montantRemiseSansTva ,

       cast(vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*(1-(nvl(f.REMISE,0)/100)) as number(30,2)) as puRemise,
       cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*(1-(nvl(f.REMISE,0)/100))*nvl(vd.TAUXDECHANGE,1) as number(30,2)) as montantHTAr,
       cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*(1-(nvl(f.REMISE,0)/100))*nvl(vd.tva,0)/100 as number(30,2)) as montantTva,
       cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*(1-(nvl(f.REMISE,0)/100))*nvl(vd.TAUXDECHANGE,1)*nvl(vd.tva,0)/100 as number(30,2)) as montantTvaAr,
       cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*(1-(nvl(f.REMISE,0)/100))*(1+(nvl(vd.tva,0)/100)) as number(30,2)) as montantTTC,
       cast(vd.QTE*vd.pu*(1-(nvl(vd.REMISE,0)/100))*(1-(nvl(vd.RISTOURNE,0)/100))*(1-(nvl(f.REMISE,0)/100))*(1+(nvl(vd.tva,0)/100))*nvl(vd.TAUXDECHANGE,1) as number(30,2)) as montantTTCAr
from FACTUREFOURNISSEURFILLE vd join FACTUREFOURNISSEUR f on f.ID=vd.IDFACTUREFOURNISSEUR

 ;


 -- SAVONNERIE2809.FACTUREFOURNISSEURFILLECPL source

CREATE OR REPLACE VIEW FACTUREFOURNISSEURFILLECPL  AS 
  SELECT f.ID,
       f.IDFACTUREFOURNISSEUR,
       f.IDPRODUIT,
       p.LIBELLE                                                         AS IDPRODUITLIB,
       f.QTE,
       f.PU,
       f.REMISES,
       f.IDBCDETAIL,
       f.TVA,
       f.IDDEVISE,
       f2.DATY, cast(f.TAUXDECHANGE as number(30,2)) as TAUXDECHANGE,

       ----------------------------------------------------------
       -- 1 Montant HT brut
       ----------------------------------------------------------
       CAST(f.QTE * f.PU AS NUMBER(30, 2))                               AS montant,
       CAST(f.QTE * f.PU AS NUMBER(30, 2))                               AS montanttotal,

       ----------------------------------------------------------
       -- 2 Montant remise (appliquee sur HT)
       ----------------------------------------------------------
        CAST(f.montantHT AS NUMBER(30, 2)) AS montantRemise,

        CAST(f.montantRemiseSansTva AS NUMBER(30, 2)) AS remiseMontant,
        
       ----------------------------------------------------------
       -- 3 Montant HT net apres remise
       ----------------------------------------------------------
       CAST(f.MONTANTHT
           AS NUMBER(30, 2))                                             AS montantht,

       ----------------------------------------------------------
       -- 4 TVA sur montant HT net
       ----------------------------------------------------------
       CAST(f.MONTANTTVA
           AS NUMBER(30, 2)
       )                                                                 AS montanttva,

       ----------------------------------------------------------
       -- 5 Montant TTC net (HT net + TVA)
       ----------------------------------------------------------
       CAST(
               f.MONTANTTTC
           AS NUMBER(30, 2)
       )                                                                 AS montantttc,

       ----------------------------------------------------------
       -- 6 Frais accessoires
       ----------------------------------------------------------
       NVL(r.montant, 0)                                          AS fraisaccesoire,

       ----------------------------------------------------------
       -- 7 Montant total avec frais (TTC + accessoires)
       ----------------------------------------------------------
       CAST(
               f.montantTTCAr    + NVL(r.montant, 0)
           AS NUMBER(30, 2)
       )                                                                 AS montantavecfraisaccessoire,

       ----------------------------------------------------------
       -- 8 PU unitaire HT + accessoires
       ----------------------------------------------------------
       CAST(

                   f.puRemise*nvl(f.TAUXDECHANGE,1)
                       + (NVL(r.montant, 0)
                    / f.QTE)
           AS NUMBER(30, 2)
       )                                                                 AS puavecfraisaccessoire,
       cast(f.montantTTCAr as number(30,2)) as montantTTCAr,

       ----------------------------------------------------------
       -- Info produit & localisation
       ----------------------------------------------------------
       NVL(p.LIBELLEEXTACTE, p.LIBELLE)                                  AS libelleexacte,
       f.IDPREVISION,
       p2.ID                                                             AS idpoint,
       p2.VAL                                                            AS idpointlib,
       m.ID                                                              AS idmagasin,
       m.VAL                                                             AS idmagasinlib,
       c.ID                                                              AS idcategorie,
       c.VAL                                                             AS idcategorielib,
       f.designation,
       f.remise

FROM FFFILLECALC f
         LEFT JOIN FACTUREFOURNISSEUR f2
                   ON f2.ID = f.IDFACTUREFOURNISSEUR
         LEFT JOIN MAGASIN m
                   ON m.ID = f2.IDMAGASIN
         LEFT JOIN POINT p2
                   ON p2.ID = m.IDPOINT
         LEFT JOIN AS_INGREDIENTS p
                   ON p.ID = f.IDPRODUIT
         LEFT JOIN CATEGORIEINGREDIENT c
                   ON c.ID = p.CATEGORIEINGREDIENT
         LEFT JOIN REPARTIRIONPGGROUPEE r
                   ON r.IDFACTUREFILLE = f.ID

 ;