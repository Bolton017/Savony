-- GALLOIS.FACTUREFOURNISSEURCPL source

CREATE OR REPLACE FORCE VIEW "FACTUREFOURNISSEURCPL" 
("ID", "IDFOURNISSEUR", "IDFOURNISSEURLIB", "IDMODEPAIEMENT", "IDMODEPAIEMENTLIB", "DATY", "DESIGNATION", "DATEECHEANCEPAIEMENT", 
"ETAT", "ETATLIB", "REFERENCE", "IDBC", "IDMAGASIN", "DEVISE", "TAUX", "IDMAGASINLIB", "IDDEVISE", "MONTANTTVA", "MONTANTHT", 
"MONTANTTTC", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTRESTE", "TAUXDECHANGE","idPrevision") AS 
  SELECT f.ID,
       f.IDFOURNISSEUR,
       f2.NOM  AS IDFOURNISSEURLIB,
       f.IDMODEPAIEMENT,
       m.VAL   AS IDMODEPAIEMENTLIB,
       f.DATY,
       f.DESIGNATION,
       f.DATEECHEANCEPAIEMENT,
       f.ETAT,
       CASE
           WHEN f.ETAT = 1
               THEN 'CREE'
           WHEN f.ETAT = 0
               THEN 'ANNULEE'
           WHEN f.ETAT = 11
               THEN 'VISEE'
           END AS ETATLIB,
       f.REFERENCE,
       f.IDBC,
       f.IDMAGASIN,
       f.DEVISE,
       f.TAUX,
       p.VAL   AS idMagasinLib,
       f3.IDDEVISE,
       cast(f3.MONTANTTVA as number(30,2)) as MONTANTTVA,
       	CAST(f3.MONTANTTTC-f3.MONTANTTVA as number(30,2)) AS MONTANTHT,
          cast(f3.MONTANTTTC as number(30,2)) as montantttc,
          cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
          cast(nvl(mv.debit,0) AS NUMBER(30,2)) AS montantpaye,
          cast(f3.MONTANTTTC-nvl(mv.debit,0) AS NUMBER(30,2)) AS montantreste,
           cast(nvl(f3.tauxdechange,0) AS  NUMBER(30,2)) AS tauxdechange,
           '' as idPrevision
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id 
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE 
         --LEFT JOIN prevision prev ON prev.idfacture=f.id
        ;
        
        CREATE OR REPLACE FORCE VIEW "RESULTATPREVEFFECTIFTOUS"  AS 
  SELECT 
t.daty,
nvl(r.debit,0) AS debit,
nvl(r.credit,0) AS credit,
(CAST (to_char( t.daty, 'IW') AS INTEGER)) AS semaine,
extract(YEAR FROM t.daty) AS annee,
EXTRACT (MONTH FROM t.daty) AS mois
FROM tousLesDate t 
left join resultatPrevisionnelEffectif r ON t.daty=r.daty ;

CREATE OR REPLACE FORCE VIEW "RESULTATPREVISIONNELEFFECTIF" ("DATY", "DEBIT", "CREDIT") AS 
  SELECT daty,
sum(debit) AS debit, 
sum(credit) AS credit
FROM MOUVEMENTCAISSE m  group by daty;

CREATE OR REPLACE FORCE VIEW RESULTATPREVISIONNELTOUS AS 
  SELECT 
t.daty,
nvl(r.debit,0) AS debit,
nvl(r.credit,0) AS credit,
(CAST (to_char( t.daty, 'IW') AS INTEGER)) AS semaine,
extract(YEAR FROM t.daty) AS annee,
EXTRACT (MONTH FROM t.daty) AS mois
FROM tousLesDate t  left join resultatPrevisionnel r ON t.daty=r.daty   ;


-- SOCOBISPROD2411.AS_BONDELIVRAISON_LIBCPL source
-- SOCOBISPROD2411.AS_BONDELIVRAISON_LIBCPL source

CREATE OR REPLACE  VIEW AS_BONDELIVRAISON_LIBCPL (ID, PRODUIT, NUMBL, QUANTITE, IDDETAILSFACTUREFOURNISSEUR, UNITE, IDBC_FILLE, REMARQUE, IDBC, DATY, ETAT, MAGASIN, PRODUITLIB, UNITELIB, MAGASINLIB, LIBELLEEXTACTE, PU,MONTANT) AS 
  SELECT
	bl.ID,
	bl.PRODUIT,
	bl.NUMBL,
	bl.QUANTITE,
	bl.IDDETAILSFACTUREFOURNISSEUR,
	bl.UNITE,
	bl.IDBC_FILLE,
	AB.REMARQUE,
	AB.IDBC,
	AB.DATY,
	AB.ETAT,
	AB.MAGASIN,
	p.libelle AS PRODUITlib,
	u.VAL AS UNITElib,
	m.VAL AS magasinlib,
	p.LIBELLEEXTACTE,
	bl.pu,
	cast(nvl(bl.QUANTITE*bl.PU,0) AS  NUMBER(30,2)) AS MONTANT
FROM
	As_BonDeLivraison_Fille bl
LEFT JOIN AS_BONDELIVRAISON AB ON
	AB.ID = bl.NUMBL
LEFT JOIN AS_INGREDIENTS p ON
	bl.PRODUIT = p.ID
LEFT JOIN AS_UNITE  u ON
	bl.UNITE = u.ID
LEFT JOIN MAGASIN m ON
	ab.MAGASIN = m.ID;

  UPDATE MENUDYNAMIQUE SET  HREF='module.jsp?but=fournisseur/fournisseur-liste.jsp'  WHERE ID='MNDN0000508004';