ALTER TABLE vente ADD referencefact varchar(100);
INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDN0000000113', 'Statistiques des vente', 'fa fa-pie-chart', 'module.jsp?but=vente/vente-details-analyse.jsp', 3, 3, 'MNDN000000010');


CREATE OR REPLACE  VIEW INSERTION_VENTE (ID, DESIGNATION, IDMAGASIN, DATY, REMARQUE, ETAT, IDORIGINE, IDCLIENT, IDDEVISE, ESTPREVU, DATYPREVU, IDRESERVATION, ECHEANCEFACTURE, MODEPAIEMENT, MODELIVRAISON, FRAISLIVRAISON,referencefact) AS 
  SELECT
	v.ID,
	v.DESIGNATION,
	v.IDMAGASIN,
	v.DATY,
	v.REMARQUE,
	v.ETAT,
	v.IDORIGINE,
	v.IDCLIENT,
	CAST(' ' AS varchar(100)) AS iddevise,
	v.ESTPREVU,
	v.DATYPREVU,
	v.IDRESERVATION,
	v.echeancefacture,
	v.modepaiement,
	v.modelivraison,
	v.fraislivraison,
	v.referencefact
FROM VENTE v;


CREATE OR REPLACE  VIEW VENTE_CPL (ID, DESIGNATION, IDMAGASIN, IDMAGASINLIB, DATY, REMARQUE, ETAT, ETATLIB, MONTANTTOTAL, IDDEVISE, IDCLIENT, IDCLIENTLIB, MONTANTTVA, MONTANTTTC, MONTANTTTCAR, MONTANTPAYE, MONTANTRESTE, AVOIR, TAUXDECHANGE, MONTANTREVIENT, MARGEBRUTE, IDRESERVATION, DATYPREVU, REFERENCEFACTURE, MONTANTREMISE, MONTANT, MOIS, ANNEE, POIDS, COLIS, MODEPAIEMENT, MODEPAIEMENTLIB, FRAISLIVRAISON, MODELIVRAISON, MODELIVRAISONLIB, RESTE, IDPROVINCE, PROVINCELIB, IDBL, IDORIGINE, FRAIS,REFERENCEFACT) AS 
  SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CREE'
           WHEN v.ETAT = 11 THEN 'VISE'
           WHEN v.ETAT = 0 THEN 'ANNULE'
           END
             AS ETATLIB,
       v2.MONTANTTOTAL,
       v2.IDDEVISE,
       v.IDCLIENT,
       c.NOM AS IDCLIENTLIB,
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.montant,0) AS NUMBER(30,2)) AS montantpaye,
       cast(nvl(V2.MONTANTTTC, 0)-nvl(mv.montant,0)-nvl(ACG.imputeefactar, 0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(ACG.MONTANTTTC_avr, 0) as number(30,2)) as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       case when v.DATYPREVU is null then v.daty else V.DATYPREVU end as datyprevu,
       rf.REFERENCE as referencefacture,
       v2.MONTANTREMISE,
       nvl(v2.MONTANTTOTAL,0)+nvl(v2.MONTANTREMISE,0) as montant,
       extract(month from v.DATY) as mois,
       extract(year from v.DATY) as annee,
       CAST(vp.poids as number(30,2)),
       CAST(vp.colis as number(30,2)),
       v.modepaiement,
       mp.VAL as modepaiementlib,
       nvl(v.fraislivraison,0)*nvl(vp.poids,0) as fraislivraison,
       v.modelivraison,
       CASE
            WHEN v.modelivraison = 1 THEN '<span style=color: green;>LIVRAISON</span>'
            WHEN v.modelivraison = 2 THEN '<span style=color: green;>RECUPERATION</span>'
        END AS modelivraisonlib,
       vr.reste,
       pv.id as idprovince,
       pv.val as provincelib,
       bl.id as idbl,
       v.IDORIGINE,
       v.FRAISLIVRAISON as frais,
       v.REFERENCEFACT
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
        left join PROVINCE pv on pv.id = c.IDPROVINCE
         LEFT JOIN MAGASINPOINT m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN LIAISONPAIEMENTTOTAL mv ON v.id=mv.id2
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID
         LEFT JOIN REFERENCEFACTURE rf ON rf.idfacture=v.Id
         left join vente_poids vp on vp.idvente=v.id
         left join MODEPAIEMENT mp on mp.id=v.modepaiement
         left join vente_reste vr on vr.idvente=v.id
         left join AS_BONDELIVRAISON_CLIENT bl on bl.IDVENTE = v.id;


CREATE OR REPLACE  VIEW VENTE_DETAILS_POIDS (ID, IDVENTE, IDPRODUIT, IDORIGINE, QTE, PU, REMISE, TVA, PUACHAT, PUVENTE, IDDEVISE, TAUXDECHANGE, DESIGNATION, COMPTE, PUREVIENT, IDBCFILLE, UNITE, UNITELIB, PUNET, MONTANTHT, MONTANTTTC, MONTANTTVA, MONTANTREMISE, MONTANT, POIDS, RESTE, FRAIS, IDPRODUITLIB,DATY,DATYPREVU,IDDEVISELIB,IDCATEGORIELIB,categorieproduitlib,puTotal,IDCLIENTLIB) AS 
SELECT
	v.ID,
	v.IDVENTE,
	v.IDPRODUIT,
	v.IDORIGINE,
	CAST(v.QTE as number(38,2)),
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
	CAST(nvl(e.POIDS, 0)* nvl(v.QTE, 0) as number(30,2)) AS poids,
	vc.reste AS reste,
	ve.fraislivraison * nvl(e.POIDS, 0)* nvl(v.QTE, 0) AS frais,
	ing.LIBELLE AS idproduitlib,
	vm.DATY,
	vm.DATYPREVU AS DATYPREVU,
	v.IDDEVISE AS IDDEVISELIB,
	c.VAL AS IDCATEGORIELIB,
	c.VAL AS categorieproduitlib,
	CAST(nvl(v.PU * v.QTE*(1-nvl(v.REMISE,0)/100), 0) +nvl(v.PU * v.QTE*(1-nvl(v.REMISE,0)/100) *(v.TVA/100), 0) AS number(30,2)) AS puTotal,
	cl.nom AS idclientlib
FROM
	VENTE_DETAILS_VIDE v
LEFT JOIN EQUIVALENCE e ON
	(e.IDPRODUIT = v.IDPRODUIT
		AND e.IDUNITE = v.unite)
LEFT JOIN VENTE_DETAILS_RESTE vc ON
	vc.ID = v.ID
LEFT JOIN Vente ve ON
	ve.ID = v.IDVENTE
LEFT JOIN AS_INGREDIENTS ing ON
	ing.ID = v.IDPRODUIT
LEFT JOIN VENTE vm ON vm.ID = v.IDVENTE
LEFT JOIN CATEGORIE c  ON ing.CATEGORIEINGREDIENT  = c.ID
LEFT JOIN CLIENT cl  ON vm.idclient  = cl.ID;