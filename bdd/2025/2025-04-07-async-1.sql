------- 2025-04-07
-------------- Ajout LIBELLEEXACTE

CREATE OR REPLACE  VIEW MVTSTOCKFILLELIB (ID, IDMVTSTOCK, IDPRODUIT, IDPRODUITLIB, ENTREE, SORTIE, IDVENTEDETAIL, IDVENTEDETAILLIB, IDTRANSFERTDETAIL, IDTRANSFERTDETAILLIB, DATY, IDMAGASIN, IDMAGASINLIB, PU, MONTANT,LIBELLEEXACTE) AS 
  SELECT
	m.ID ,
	m.IDMVTSTOCK ,
	m.IDPRODUIT ,
	p.libelle  AS IDPRODUITLIB,
	m.ENTREE ,
	m.SORTIE ,
	m.IDVENTEDETAIL ,
	'' AS IDVENTEDETAILLIB,
	m.IDTRANSFERTDETAIL ,
	'' AS IDTRANSFERTDETAILLIB,
	m2.DATY ,
	m2.IDMAGASIN ,
	m3.VAL AS IDMAGASINLIB,
	m.pu,
    cast(m.pu*m.ENTREE+(m.pu*m.sortie) as number(20,2)) as montant,
    p.LIBELLEEXTACTE
	FROM MVTSTOCKFILLE m
	LEFT JOIN AS_INGREDIENTS  p ON p.ID = m.IDPRODUIT
	LEFT JOIN MVTSTOCK m2 ON m2.ID = m.IDMVTSTOCK
	LEFT JOIN MAGASIN m3 ON m3.ID = m2.IDMAGASIN;

CREATE OR REPLACE  VIEW INVENTAIREFILLELIB (ID, IDINVENTAIRE, IDPRODUIT, IDPRODUITLIB, EXPLICATION, QUANTITETHEORIQUE, QUANTITE,LIBELLEEXACTE) AS 
  SELECT
i.ID ,
i.IDINVENTAIRE ,
i.IDPRODUIT ,
p.libelle AS IDPRODUITLIB,
i.EXPLICATION ,
i.QUANTITETHEORIQUE ,
i.QUANTITE,
p.LIBELLEEXTACTE
FROM INVENTAIREFILLE i
LEFT JOIN AS_INGREDIENTS  p ON p.ID  = i.IDPRODUIT;

CREATE OR REPLACE  VIEW FACTUREFOURNISSEURFILLECPL (ID, IDFACTUREFOURNISSEUR, IDPRODUIT, IDPRODUITLIB, QTE, PU, REMISES, IDBCDETAIL, TVA, IDDEVISE, DATY, MONTANTHT, MONTANTTTC, MONTANTTVA, MONTANTREMISE, MONTANT,LIBELLEEXACTE) AS 
 SELECT
	f.ID ,
	f.IDFACTUREFOURNISSEUR ,
	f.IDPRODUIT ,
	p.LIBELLE AS IDPRODUITLIB,
	f.QTE ,
	f.PU ,
	f.REMISES ,
	f.IDBCDETAIL ,
	f.TVA ,
	f.IDDEVISE,
	f2.DATY,
	CAST(f.QTE * f.PU AS NUMBER(30,
	2)) AS montantht,
	CAST(f.QTE * f.PU + (f.QTE * f.PU * f.TVA / 100) AS NUMBER(30,
	2)) AS montantttc,
	CAST(f.QTE * f.PU * f.TVA / 100 AS NUMBER(30,
	2)) AS montanttva,
	CAST((nvl(f.remises / 100, 0))*(f.QTE * f.PU) AS NUMBER(30,
	2)) AS montantRemise,
	CAST((1-nvl(f.remises / 100, 0))*(f.QTE * f.PU) AS NUMBER(30,
	2)) AS montant,
	p.LIBELLEEXTACTE
FROM
	FACTUREFOURNISSEURFILLE f
LEFT JOIN FACTUREFOURNISSEUR f2 ON
	f2.ID = f.IDFACTUREFOURNISSEUR
LEFT JOIN AS_INGREDIENTS p ON
	p.ID = f.IDPRODUIT;


CREATE OR REPLACE  VIEW AS_BONDELIVRAISON_LIBCPL (ID, PRODUIT, NUMBL, QUANTITE, IDDETAILSFACTUREFOURNISSEUR, UNITE, IDBC_FILLE, REMARQUE, IDBC, DATY, ETAT, MAGASIN, PRODUITLIB, UNITELIB, MAGASINLIB,LIBELLEEXACTE) AS 
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
	p.LIBELLEEXTACTE
FROM
	As_BonDeLivraison_Fille bl
LEFT JOIN AS_BONDELIVRAISON AB ON
	AB.ID = bl.NUMBL
LEFT JOIN AS_INGREDIENTS p ON
	bl.PRODUIT = p.ID
LEFT JOIN UNITE u ON
	bl.UNITE = u.ID
LEFT JOIN MAGASIN m ON
	ab.MAGASIN = m.ID
        ;


--- mamafa version OfFilleLib tsy mety
DROP VIEW "OfFilleLib";

------ Ajout accent
UPDATE MENUDYNAMIQUE
SET LIBELLE='Prévision', ICONE='fa fa-tags', HREF=NULL, RANG=9, NIVEAU=1, ID_PERE=NULL
WHERE ID='MENUDYN002';

UPDATE MENUDYNAMIQUE
SET LIBELLE='prévision dépense', ICONE='fa fa-tags', HREF='#', RANG=4, NIVEAU=2, ID_PERE='MENUDYN002'
WHERE ID='MENUDYN0020004';

UPDATE MENUDYNAMIQUE
SET LIBELLE='prévision recette', ICONE='fa fa-tags', HREF='#', RANG=5, NIVEAU=2, ID_PERE='MENUDYN002'
WHERE ID='MENUDYN0020005';

UPDATE MENUDYNAMIQUE
SET LIBELLE='Résultat prévisionnel', ICONE='fa fa-line-chart', HREF='module.jsp?but=prevision/resultat-prevision.jsp', RANG=2, NIVEAU=2, ID_PERE='MENUDYN002'
WHERE ID='MENUDYN0020003';


----Ajout menu Immobilisation de la base fer


INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000011', 'Gestion Immobilisation', 'fa fa-globe', NULL, 13, 1, NULL);

INSERT INTO USERMENU
(ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT)
VALUES('USRMEN0704001', '*', 'ELM000011', NULL, NULL, NULL, NULL);

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001020', 'Existant', 'fa fa-plus', '/fer/pages/module.jsp?but=immo/immobilisation-liste.jsp', 1, 2, 'ELM000011');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001021', 'Ajout', 'fa fa-plus', NULL, 2, 2, 'ELM000011');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001022', 'Opérations', 'fa fa-wrench', NULL, 3, 2, 'ELM000011');


INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000224DNSA', 'Recap par magasin', 'fa fa-money', '/fer/pages/module.jsp?but=immo/immo-parmagasin-liste.jsp', 4, 2, 'ELM000011');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001024', 'Analyse Globale', 'fa fa-search', NULL, 5, 2, 'ELM000011');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('PAL00011IMGT001', 'Immo groupé', 'fa fa fa-globe', '/fer/pages/module.jsp?but=immo/immobilisationAGrouper.jsp', 6, 2, 'ELM000011');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001026', 'Configuration ', 'fa fa-plus', NULL, 7, 2, 'ELM000011');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('INVET0001425', 'Inventaire', 'fa fa-globe', NULL , 7, 2, 'ELM000011');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('PAL00012CHI0012', 'Tableau', 'fa fa-table', '/fer/pages/module.jsp?but=immo/immo-tab-amort.jsp', 7, 2, 'ELM000011');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('INVET00014251', 'Liste', 'fa fa-list', '/fer/pages/module.jsp?but=immo/inventaire/inventaire-liste.jsp', 1, 3, 'INVET0001425');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('INVET00014252', 'Saisie', 'fa fa-plus', '/fer/pages/module.jsp?but=immo/inventaire/inventaire-saisie.jsp', 2, 3, 'INVET0001425');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('PAL000113EXAM1Qw', 'Nature entretien', 'fa fa-search', '/fer/pages/module.jsp?but=immo/configuration/idvaldesce.jsp&ciblename=IMMO_NATURE_ENTRETIEN&value=Code&description=Intitulé', 7, 3, 'ELM001026');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('PAL000113EXAM2Qw', 'Nature detail entretien', 'fa fa-list', '/fer/pages/module.jsp?but=immo/configuration/idvaldesce.jsp&ciblename=IMMO_NATURE_DETAIL_ER&value=Code&description=Intitulé', 8, 3, 'ELM001026');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000411', 'Catégorie', 'fa fa-globe', NULL, 1, 3, 'ELM001026');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000412', 'Nature', 'fa fa-globe', NULL, 2, 3, 'ELM001026');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000413', 'Etat', 'fa fa-circle-o', '/fer/pages/module.jsp?but=immo/configuration/idvaldesce.jsp&ciblename=IMMO_ETAT&value=Code&description=Intitulé', 3, 3, 'ELM001026');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000414', 'Nomenclature', 'fa fa-circle-o', '/fer/pages/module.jsp?but=immo/configuration/idvaldesce.jsp&ciblename=IMMO_NOMENCLATURE&value=Code&description=Intitulé', 4, 3, 'ELM001026');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000415', 'Type d''amortissement', 'fa fa-circle-o', '/fer/pages/module.jsp?but=immo/configuration/idvaldesce.jsp&ciblename=IMMO_TYPE_AMORTISSEMENT&value=Code&description=Intitulé', 5, 3, 'ELM001026');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000416', 'Motif de cession', 'fa fa-circle-o', '/fer/pages/module.jsp?but=immo/configuration/idvaldesce.jsp&ciblename=IMMO_MOTIF_CESSION&value=Code&description=Intitulé', 6, 3, 'ELM001026');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('STATIM0001IM', 'Prêt', 'fa fa-search', '#', 7, 3, 'ELM001022');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000370', 'Visa', 'fa fa-check', NULL, 1, 3, 'ELM001022');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000374', 'Cession', 'fa fa-shopping-cart', NULL, 4, 3, 'ELM001022');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000371', 'Gestion des demandes', 'fa fa-globe', NULL, 1, 3, 'ELM001022');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000372', 'Attribution/transfert', 'fa fa-circle-o', NULL, 2, 3, 'ELM001022');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000373', 'Condamnation', 'fa fa-gavel', NULL, 3, 3, 'ELM001022');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000375', 'Entretien et réparation', 'fa fa-gear', NULL, 5, 3, 'ELM001022');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000381', 'Analyse', 'fa fa-search', '/fer/pages/module.jsp?but=immo/immobilisation-analyse.jsp', 3, 4, 'ELM001022');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000382', 'Historique Détention', 'fa fa-history', '/fer/pages/module.jsp?but=immo/detenteur/detenteur-liste.jsp', 4, 4, 'ELM001022');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM273', 'Journalière', 'fa fa-list', '/fer/pages/module.jsp?but=immo/immo-journaliere.jsp', 3, 3, 'ELM001024');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001041', 'Amortissement', 'fa fa-shopping-cart', NULL, 1, 3, 'ELM001024');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001042', 'Détention', 'fa fa-shopping-cart', NULL, 2, 3, 'ELM001024');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001002', 'Ordre d''entrée', 'fa fa-plus', '/fer/pages/module.jsp?but=compta-matiere/evaluation/ordre-entree-evalue.jsp&etat=11', 2, 3, 'ELM001021');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000380', 'Création', 'fa fa-plus', '/fer/pages/module.jsp?but=immo/immobilisation-saisie.jsp', 1, 3, 'ELM001021');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM0010021', 'Importer', 'fa fa-plus', '/fer/pages/module.jsp?but=immo/import-immo.jsp', 3, 3, 'ELM001021');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001043', 'Liste', 'fa fa-list-alt', '/fer/pages/module.jsp?but=immo/ammortissable-liste.jsp', 1, 4, 'ELM001041');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001064', 'Historique', 'fa fa-list-alt', '/fer/pages/module.jsp?but=immo/detenteur/historique-liste.jsp', 1, 4, 'ELM001042');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001065', 'Détenteur', 'fa fa-list-alt', '/fer/pages/module.jsp?but=immo/attribution/analyse-detention.jsp', 2, 4, 'ELM001042');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('STATIM0002', 'Liste', 'fa fa-search', '/fer/pages/module.jsp?but=immo/pret/pret-liste.jsp', 1, 4, 'STATIM0001IM');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('STATIM0003', 'Saisie', 'fa fa-search', '/fer/pages/module.jsp?but=immo/pret/pret-saisie.jsp', 2, 4, 'STATIM0001IM');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('DEC00007777AC', 'Transfert', 'fa fa-home', '/fer/pages/module.jsp?but=immo/visa/transfert.jsp', 4, 4, 'ELM000370');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('DEC00007777AB', 'Attribution', 'fa fa-home', '/fer/pages/module.jsp?but=immo/visa/attribution.jsp', 3, 4, 'ELM000370');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('DEC00007777AD', 'Cession', 'fa fa-home', '/fer/pages/module.jsp?but=immo/visa/cession.jsp', 5, 4, 'ELM000370');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('DEC00007777AE', 'Condamnation', 'fa fa-home', '/fer/pages/module.jsp?but=immo/visa/condamnation.jsp', 6, 4, 'ELM000370');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001034', 'Immobilisation', 'fa fa-list-alt', '/fer/pages/module.jsp?but=immo/visa/en-attente-de-visa.jsp', 1, 4, 'ELM000370');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001035', 'Visa multiple', 'fa fa-check', '/fer/pages/module.jsp?but=immo/visa/immobilisation-visa.jsp', 2, 4, 'ELM000370');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('STATIM0003AZE', 'Prêt', 'fa fa-search', '/fer/pages/module.jsp?but=immo/visa/pret-visa.jsp', 7, 4, 'ELM000370');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000390', 'Immobilisation', 'fa fa-list-alt', '/fer/pages/module.jsp?but=immo/cessable-liste.jsp', 1, 4, 'ELM000374');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000391', 'Création', 'fa fa-plus', '/fer/pages/module.jsp?but=immo/cession-saisie.jsp', 2, 4, 'ELM000374');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000392', 'Analyse', 'fa fa-search', '/fer/pages/module.jsp?but=immo/cession-liste.jsp', 3, 4, 'ELM000374');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000384', 'Demande', 'fa fa-circle-o', NULL, 1, 4, 'ELM000371');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000386', 'Consultation', 'fa fa-list-alt', '/fer/pages/module.jsp?but=immo/demande/demande-liste.jsp', 2, 4, 'ELM000371');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000387', 'Analyse', 'fa fa-search', '/fer/pages/module.jsp?but=immo/demande/demande-analyse.jsp', 3, 4, 'ELM000371');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001040', 'Suivie', 'fa fa-list-alt', '/fer/pages/module.jsp?but=immo/demande/demande-listeD.jsp', 2, 5, 'ELM000384');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM000385', 'Edition', 'fa fa-pencil', '/fer/pages/module.jsp?but=immo/demande/demande-saisie.jsp', 1, 5, 'ELM000384');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001055', 'Attribution', 'fa fa-child', NULL, 1, 4, 'ELM000372');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001056', 'Transfert', 'fa fa-car', NULL, 2, 4, 'ELM000372');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001057', 'Remise au magasin', 'fa fa-mail-reply', NULL, 3, 4, 'ELM000372');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001052', 'Liste', 'fa fa-list', '/fer/pages/module.jsp?but=immo/attribution/fiche-attribution.jsp', 4, 5, 'ELM001055');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001031', 'Création', 'fa fa-plus', '/fer/pages/module.jsp?but=immo/detenteur/detenteur-saisie.jsp', 2, 5, 'ELM001055');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001032', 'Attribution multiple', 'fa fa-child', '/fer/pages/module.jsp?but=immo/attribution/debut-attribution-multiple.jsp', 3, 5, 'ELM001055');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001030', 'Immobilisation', 'fa fa-list-alt', '/fer/pages/module.jsp?but=immo/attribution/attribuable-liste.jsp', 1, 5, 'ELM001055');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001058', 'Immoblisation', 'fa fa-list', '/fer/pages/module.jsp?but=immo/transfert/immobilisation-liste.jsp', 1, 5, 'ELM001056');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001059', 'créer', 'fa fa-plus', '/fer/pages/module.jsp?but=immo/transfert/transfert-saisie.jsp', 2, 5, 'ELM001056');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001060', 'Liste', 'fa fa-list-alt', '/fer/pages/module.jsp?but=immo/transfert/transfert-liste.jsp', 3, 5, 'ELM001056');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001062', 'créer', 'fa fa-plus', '/fer/pages/module.jsp?but=immo/magasin/remisemagasin-saisie.jsp', 2, 5, 'ELM001057');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001063', 'Liste', 'fa fa-list-alt', '/fer/pages/module.jsp?but=immo/magasin/remisemagasin-liste.jsp', 3, 5, 'ELM001057');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELM001061', 'Immoblisation', 'fa fa-list', '/fer/pages/module.jsp?but=immo/magasin/immobilisation-liste.jsp', 1, 5, 'ELM001057');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT001055', 'Attribution', 'fa fa-child', NULL, 1, 4, 'ELM000372');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT001056', 'Transfert', 'fa fa-car', NULL, 2, 4, 'ELM000372');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT001057', 'Remise au magasin', 'fa fa-mail-reply', NULL, 3, 4, 'ELM000372');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT001052', 'Liste', 'fa fa-list', '/fer/pages/module.jsp?but=immo/attribution/fiche-attribution.jsp', 4, 5, 'ELMT001055');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT001031', 'Création', 'fa fa-plus', '/fer/pages/module.jsp?but=immo/detenteur/detenteur-saisie.jsp', 2, 5, 'ELMT001055');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT001032', 'Attribution multiple', 'fa fa-child', '/fer/pages/module.jsp?but=immo/attribution/debut-attribution-multiple.jsp', 3, 5, 'ELM001055');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT001030', 'Immobilisation', 'fa fa-list-alt', '/fer/pages/module.jsp?but=immo/attribution/attribuable-liste.jsp', 1, 5, 'ELMT001055');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT001058', 'Immoblisation', 'fa fa-list', '/fer/pages/module.jsp?but=immo/transfert/immobilisation-liste.jsp', 1, 5, 'ELMT001056');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT001059', 'créer', 'fa fa-plus', '/fer/pages/module.jsp?but=immo/transfert/transfert-saisie.jsp', 2, 5, 'ELMT001056');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT001060', 'Liste', 'fa fa-list-alt', '/fer/pages/module.jsp?but=immo/transfert/transfert-liste.jsp', 3, 5, 'ELMT001056');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT001062', 'créer', 'fa fa-plus', '/fer/pages/module.jsp?but=immo/magasin/remisemagasin-saisie.jsp', 2, 5, 'ELMT001057');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT001063', 'Liste', 'fa fa-list-alt', '/fer/pages/module.jsp?but=immo/magasin/remisemagasin-liste.jsp', 3, 5, 'ELMT001057');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT001061', 'Immoblisation', 'fa fa-list', '/fer/pages/module.jsp?but=immo/magasin/immobilisation-liste.jsp', 1, 5, 'ELMT001057');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT000389', 'Création', 'fa fa-plus', '/fer/pages/module.jsp?but=immo/condamnation/condamnation-saisie.jsp', 2, 4, 'ELM000373');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT001038', 'Liste', 'fa fa-search', '/fer/pages/module.jsp?but=immo/condamnation/condamnation-liste.jsp', 4, 4, 'ELM000373');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT001037', 'Condamnation multiple', 'fa fa-check', '/fer/pages/module.jsp?but=immo/condamnation/debut-condamnation-multiple.jsp', 3, 4, 'ELM000373');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT000395', 'Liste des devis', 'fa fa-list-alt', '/fer/pages/module.jsp?but=immo/entretien/er-devis-liste.jsp', 1, 4, 'ELM000375');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT000396', 'Création', 'fa fa-plus', '/fer/pages/module.jsp?but=immo/entretien/er-devis-saisie.jsp', 2, 4, 'ELM000375');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT000397', 'Analyse', 'fa fa-search', '/fer/pages/module.jsp?but=immo/entretien/er-devis-analyse.jsp', 3, 4, 'ELM000375');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT000417', 'Liste', 'fa fa-list-alt', '/fer/pages/module.jsp?but=immo/configuration/categorie-liste.jsp', 1, 4, 'ELM000411');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT000418', 'Création', 'fa fa-plus', '/fer/pages/module.jsp?but=immo/configuration/categorie-saisie.jsp', 2, 4, 'ELM000411');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT000419', 'Liste', 'fa fa-list-alt', '/fer/pages/module.jsp?but=immo/configuration/nature-liste.jsp', 1, 4, 'ELM000412');
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('ELMT000420', 'Création', 'fa fa-plus', '/fer/pages/module.jsp?but=immo/configuration/nature-saisie.jsp', 2, 4, 'ELM000412');
