

CREATE OR REPLACE VIEW V_ETATSTOCK_ENTREE_DMDACHAT AS
SELECT
    ai.id AS ID,
    ai.id AS IDPRODUIT,
    ai.LIBELLE AS IDPRODUITLIB,
    ai.CATEGORIEINGREDIENT,
    c.VAL AS IDTYPEPRODUITLIB,
    ve.IDMAGASIN,
    m.VAL AS IDMAGASINLIB,
    CAST(SUM(CAST(ve.QUANTITE AS NUMBER(30,5))) AS NUMBER(30,5)) AS QUANTITE,
    CAST(SUM(CAST(ve.ENTREE AS NUMBER(30,5)))AS NUMBER(30,5)) AS ENTREE,
    CAST(SUM(CAST(ve.SORTIE AS NUMBER(30,5)))AS NUMBER(30,5)) AS SORTIE,
    CAST(SUM(CAST(ve.RESTE AS NUMBER(30,5)))AS NUMBER(30,5)) AS RESTE,
    ai.UNITE,
    u.VAL AS IDUNITELIB,
    CAST(MIN(CAST(ve.PU AS NUMBER(30,5)))AS NUMBER(30,5)) AS PU,  -- On prend le PU minimal si plusieurs
    MIN(ve.DATY) AS DATY  -- Date représentative
FROM
    MVTSTOCKENTREEAVECRESTE ve
    LEFT JOIN AS_INGREDIENTS ai ON ai.id = ve.IDPRODUIT
    LEFT JOIN CATEGORIEINGREDIENT c ON ai.CATEGORIEINGREDIENT = c.id
    LEFT JOIN MAGASIN2 m ON ve.IDMAGASIN = m.id
    LEFT JOIN UNITE u ON ai.UNITE = u.id
WHERE ve.RESTE > 0 AND ve.PU > 0
GROUP BY
    ai.id,
    ai.LIBELLE,
    ai.CATEGORIEINGREDIENT,
    c.VAL,
    ve.IDMAGASIN,
    m.VAL,
    ai.UNITE,
    u.VAL;


-- SOCOBISPROD2411.CATEGORIEINGREDIENTLIB source


ALTER TABLE CATEGORIEINGREDIENT ADD estachat int;
UPDATE CATEGORIEINGREDIENT c SET estachat=1 WHERE id IN('CAT0010','CAT006','CAT003','CAT0011','CAT009','CAT007','CAT005','CAT004');

CREATE OR REPLACE  VIEW CATEGORIEINGREDIENTLIB_ACHT (ID,VAL,DESCE) AS 
  SELECT
	cat.id,
	cat.val,
	cat.desce
FROM
	CATEGORIEINGREDIENT cat
	WHERE estachat=1;

  
  UPDATE MENUDYNAMIQUE SET  HREF='module.jsp?but=fournisseur/fournisseur-liste.jsp'  WHERE ID='MNDN0000508004';

  CREATE OR REPLACE  VIEW PROFORMADETAILS_CPL (ID, IDPROFORMA, IDPRODUIT, IDORIGINE, QTE, PU, REMISE, TVA, PUACHAT, PUVENTE, IDDEVISE, TAUXDECHANGE, DESIGNATION, COMPTE, PUREVIENT, IDDEMANDEPRIXFILLE, IDPROFORMALIB, IDPRODUITLIB, PUTOTAL, UNITE, UNITELIB, REMISEMONTANT, MONTANTTOTAL, MONTANTTVA, MONTANTTTC, DATEDEBUT,CALORIE) AS 
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
    nvl(p.calorie,0)
--       d2.id AS idDevis
FROM PROFORMA_DETAILS vd
         LEFT JOIN PROFORMA v ON v.ID = vd.IDPROFORMA
         LEFT JOIN AS_INGREDIENTS p ON p.ID = vd.IDPRODUIT
         LEFT JOIN AS_UNITE au ON au.id = vd.unite;
         

         CREATE OR REPLACE VIEW ff_fillebc_grp as
SELECT 
	ff.idproduit,
	ff.IDBCDETAIL,
	sum(ff.qte) AS qte
	FROM (SELECT ff.* FROM FACTUREFOURNISSEURFILLE ff JOIN facturefournisseur f ON f.id=ff.idfacturefournisseur WHERE f.etat>=11  ) ff
GROUP BY idproduit,IDBCDETAIL;

CREATE OR REPLACE VIEW ff_fillebl_grp as
SELECT 
	produit,
	IDBC_FILLE,
	sum(quantite) AS qte
	FROM (SELECT blf.* FROM AS_BONDELIVRAISON_FILLE blf JOIN AS_BONDELIVRAISON bl ON bl.id=blf.NUMBL WHERE bl.etat>=11  ) 
GROUP BY produit,IDBC_FILLE;


CREATE OR replace VIEW  AS_BONDECOMMANDE_CPL_RECEPT
as
SELECT 
	bc.id,
	bc.idbc,
	bc.produitlib,
	bc.unitelib,
	nvl(bc.quantite,0) AS quantite,
	nvl(bl.qte,0) AS qtelivrer,
	nvl(ff.qte,0) AS qtefacturer
	FROM AS_BONDECOMMANDE_CPL bc
	LEFT JOIN ff_fillebl_grp bl ON bc.id = bl.IDBC_FILLE
	LEFT JOIN ff_fillebc_grp ff ON bc.id = ff.IDBCDETAIL;
	


-- SOCOBISPROD2411.RECAPITULATIF_ALL_FINAL source

CREATE OR REPLACE  VIEW RECAPITULATIF_ALL_FINAL (MOIS, ANNEE, SALAIRE, INDEMNITE, AVANTAGE_EN_NATURE, SALAIRE_BRUT, IRSA, CNAPS_TRAVAILLEUR, MONTANT_NET_PAYER, CNAPS_EMPLOYEUR, CNAPS_A_PAYER, TOTAL_FRM, ID,moislib) AS 
  SELECT rs.mois,
       rs.annee,
       rs.salaire,
       rs.indemnite,
       rs.avantage_en_nature,
       rs.salaire_brut,
       rs.irsa,
       rs.cnaps_travailleur,
       CAST(rs.montant_net_payer AS NUMBER(30, 2)) AS MONTANT_NET_PAYER,
       rs.cnaps_employeur,
       rs.cnaps_a_payer,
       frm.total_frm,
       rs.id,
       TO_CHAR(
			TO_DATE(TO_CHAR(rs.mois, 'FM00'), 'MM'),
			'FMMonth',
			'NLS_DATE_LANGUAGE=FRENCH'
			) AS moisLib
			 
FROM recapitulatif_salaire_all rs
         LEFT JOIN frm_mois_annee frm ON rs.mois = frm.mois AND rs.annee = frm.annee;


         -- SOCOBISPROD2411.SITUATION_SALAIRE_COMPLET source

CREATE OR REPLACE  VIEW SITUATION_SALAIRE_COMPLET (MATRICULE, NOM, ID, MOIS, ANNEE, IDEDITION, SALAIRE, HS_M, INDEM, ANCIEN, PRIME, AUTRES, TOTAL, CNAPS, OSTIE, IRSA_E, IRSA_S, AV_SPE, AUTRES2, A_PAYER, HEURESUPP30NI, HEURESUPP30I, HEURESUPP50NI, HEURESUPP50I, MAJNUIT, MAJFERIE, MAJWEEKEND, ABBATEMENT,moisLib) AS 
SELECT
	se.MATRICULE,
	se.NOM,
	(se.ID || '//' || sa.idedition) AS id,
	se.MOIS,
	se.ANNEE,
	se.IDEDITION,
	se.SALAIRE,
	se.HS_M,
	se.INDEM,
	se.ANCIEN,
	se.PRIME,
	se.AUTRES,
	se.TOTAL,
	se.CNAPS,
	se.OSTIE,
	se.IRSA_E,
	se.IRSA_S,
	se.AV_SPE,
	se.AUTRES2,
	se.A_PAYER,
	sa.heuresupp30ni,
	heuresupp30i,
	heuresupp50ni,
	heuresupp50i,
	majnuit,
	majferie,
	majweekend,
	abbatement,
	TO_CHAR(
	TO_DATE(TO_CHAR(se.mois, 'FM00'), 'MM'),
	'FMMonth',
	'NLS_DATE_LANGUAGE=FRENCH'
	) AS moisLib
	 
FROM
	SITUATION_SALAIRE_EDITION se
LEFT JOIN SITUATION_SALAIRE_AUTRE sa
                   ON
	se.idedition = sa.idedition
	AND se.id = sa.idpersonnel;