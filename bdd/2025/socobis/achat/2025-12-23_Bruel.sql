UPDATE UTILISATEUR SET LOGINUSER = 'Ravaka', PWDUSER = 'paop', NOMUSER = 'Ravaka', ADRUSER = 'DIR42', TELUSER = '03444044044', IDROLE = 'gestionnaire' WHERE REFUSER = 880678;
UPDATE UTILISATEUR SET LOGINUSER = 'Rakoto', PWDUSER = 'paop', NOMUSER = 'Rakoto', ADRUSER = 'DIR42', TELUSER = '03444044044', IDROLE = 'caisse' WHERE REFUSER = 880677;


INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDN00000001147', 'CA journalier', 'bar_chart', 'module.jsp?but=vente/ca/ca-calendrier-v2.jsp', 6, 3, 'MNDN000000010');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDN00000001145', 'CA annuel', 'bar_chart', 'module.jsp?but=vente/ca/graphe-ca-annuel.jsp', 4, 3, 'MNDN000000010');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDN00000001146', 'CA mensuel', 'bar_chart', 'module.jsp?but=vente/ca/camensuel.jsp', 5, 3, 'MNDN000000010');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDN0000000111', 'Chiffre d''affaire', 'bar_chart', 'module.jsp?but=vente/vente-analyse.jsp', 1, 3, 'MNDN000000010');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDN0000000112', 'Par clients', 'bar_chart', 'module.jsp?but=vente/vente-analyse-client.jsp', 3, 3, 'MNDN000000010');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDN0000000114701', 'Analyse des ventes par magasin', 'bar_chart', 'module.jsp?but=vente/vente-analyse.jsp&grouper=idMagasinLib', 7, 3, 'MNDN000000010');
INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES ('MNDN0000000114702', 'Analyse des ventes par catégorie', 'bar_chart', 'module.jsp?but=vente/vente-analyse.jsp&grouper=idCategorieLib', 8, 3, 'MNDN000000010');


CREATE OR REPLACE VIEW VENTE_CPL AS
SELECT v.ID,
       v.DESIGNATION,
       v.IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       v.DATY,
       v.REMARQUE,
       v.ETAT,
       CASE
           WHEN v.ETAT = 1 THEN 'CR&Eacute;&Eacute;E'
           WHEN v.ETAT = 11 THEN 'VIS&Eacute;E'
           WHEN v.ETAT = 0 THEN 'ANNUL&Eacute;E'
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
       CAST(vp.poids as number(30,2)) as poids,
       CAST(vp.colis as number(30,2)) as colis,
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
       v.REFERENCEFACT,
       v.NUMEROFACTURE,
       v.LIEULIVRAISON,
       v.DATELIVRAISON,
       v.UPDATED_AT
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

create or replace view FACTUREFOURNISSEUR_FILLECPL as
select ff.ID,
       ff.IDFACTUREFOURNISSEUR,
       ff.IDPRODUIT,
       ff.QTE,
       ff.PU,
       ff.REMISES,
       ff.IDBCDETAIL,
       ff.TVA,
       p.LIBELLE as produitlib,
       ff.compte,
       f.ETAT,
       ff.iddevise,
       ff.tauxdechange
from FACTUREFOURNISSEURFILLE ff
         left join PRODUIT_LIBCPL p on p.id = ff.idproduit
         left join FACTUREFOURNISSEUR F on F.ID = ff.IDFACTUREFOURNISSEUR
;


create view FACTUREFOURNISSEUR_FILLECOMPTE as
select ff.COMPTE,
       ff.IDFACTUREFOURNISSEUR,
       ff.etat,
       cast(sum(pu * QTE) as number(30, 2))                            as montantht,
       cast(sum(pu * QTE * (tva / 100)) as number(30, 2))              as montanttva,
       cast(sum((pu * QTE) + pu * QTE * (tva / 100)) as number(30, 2)) as montantttc,
       ff.iddevise,
       ff.tauxdechange
from FACTUREFOURNISSEUR_FILLECPL ff
group by COMPTE, IDFACTUREFOURNISSEUR, ff.etat,ff.iddevise,ff.tauxdechange
;

create view FACTUREFOURNISSEUR_FILLE_VISE as
select COMPTE,IDFACTUREFOURNISSEUR,ETAT,MONTANTHT,MONTANTTVA,MONTANTTTC,iddevise,tauxdechange
from FACTUREFOURNISSEUR_FILLECOMPTE
where etat = 11;

create view VENTE_DETAILS_POIDS
            (ID, IDVENTE, IDPRODUIT, IDORIGINE, QTE, PU, REMISE, TVA, PUACHAT, PUVENTE, IDDEVISE, TAUXDECHANGE,
             DESIGNATION, COMPTE, PUREVIENT, IDBCFILLE, UNITE, UNITELIB, PUNET, MONTANTHT, MONTANTTTC, MONTANTTVA,
             MONTANTREMISE, MONTANT, POIDS, RESTE, FRAIS, IDPRODUITLIB, DATY, DATYPREVU, IDDEVISELIB, IDCATEGORIELIB,
             CATEGORIEPRODUITLIB, PUTOTAL, IDCLIENTLIB)
as
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
LEFT JOIN CATEGORIEINGREDIENT c  ON ing.CATEGORIEINGREDIENT  = c.ID
LEFT JOIN CLIENT cl  ON vm.idclient  = cl.ID;

create view VENTENONPAYE as
select ID,
       DESIGNATION,
       IDMAGASIN,
       IDMAGASINLIB,
       DATY,
       REMARQUE,
       ETAT,
       ETATLIB,
       MONTANTTOTAL,
       IDDEVISE,
       IDCLIENT,
       IDCLIENTLIB,
       MONTANTTVA,
       MONTANTTTC,
       MONTANTTTCAR,
       MONTANTPAYE,
       MONTANTRESTE,
       AVOIR,
       TAUXDECHANGE,
       MONTANTREVIENT,
       MARGEBRUTE,
       IDRESERVATION,
       DATYPREVU,
       mois,
       annee
from VENTE_CPL
where  ETAT >= 11 and MONTANTREMISE = 0
/



select 'alter table '||TABLE_NAME||' ALLOCATE EXTENT;' FROM dba_tables where OWNER='SOCOBISPROD2411' AND num_rows=0  ORDER BY TABLE_NAME;

/*
select * from AS_BONDELIVRAISON where id = 'BL000872';

select * from FACTUREFOURNISSEUR where id = 'FCF001050';

select * from COMPTA_ECRITURE where IDOBJET = 'FCF001048';
delete from COMPTA_SOUS_ECRITURE where IDMERE = 'ECR126896';
delete from COMPTA_ECRITURE where id = 'ECR126896';

delete from FACTUREFOURNISSEURFILLE where IDFACTUREFOURNISSEUR = 'FCF001048';
delete from FACTUREFOURNISSEUR where id = 'FCF001048';
*/
alter table FACTUREFOURNISSEUR add idtypefacture varchar2(100) references TYPE_FACTURE;

create or replace view FACTUREFOURNISSEURCPL as
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
               THEN 'CREEE'
           WHEN f.ETAT = 0
               THEN 'ANNULEE'
           WHEN f.ETAT = 11
               THEN 'VISEE'
           END AS ETATLIB,
       f.REFERENCE,
       f.IDBC,
       f.IDMAGASIN,
       f.DEVISE,
       case
           when f.TAUX=0 then 1
           else f.TAUX
           end as taux,
       p.VAL   AS idMagasinLib,
       f3.IDDEVISE,
       cast(f3.MONTANTTVA as number(30,2)) as MONTANTTVA,
       CAST(f3.MONTANTTTC-f3.MONTANTTVA as number(30,2)) AS MONTANTHT,
       cast(f3.MONTANTTTC as number(30,2)) as montantttc,
       cast(f3.MONTANTTTC*f3.tauxdechange as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.debit,0) AS NUMBER(30,2)) AS montantpaye,
       cast(f3.MONTANTTTC-nvl(mv.debit,0) AS NUMBER(30,2)) AS montantreste,
       cast(nvl(f3.tauxdechange,0) AS  NUMBER(30,2)) AS tauxdechange,
       prev.id as idPrevision,
       CASE
           WHEN f.estprevu=0 THEN 'NON'
           ELSE 'OUI'
           END
           AS estprevulib,
       f.IDOBJET,
       f.IDREF,
       f.IDTYPEFACTURE,
       tf.VAL as typefacture
FROM FACTUREFOURNISSEUR f
         LEFT JOIN FOURNISSEUR f2 ON f2.ID = f.IDFOURNISSEUR
         LEFT JOIN MODEPAIEMENT m ON m.ID = f.IDMODEPAIEMENT
         LEFT JOIN MAGASIN p ON p.ID = f.IDMAGASIN
         JOIN FACTUREFOURNISSEURMONTANT f3 ON f.ID = f3.id
         LEFT JOIN mouvementcaisseGroupeFacture mv ON f.id=mv.IDORIGINE
         LEFT JOIN prevision prev ON prev.idfacture=f.id
left join type_facture tf on tf.id = f.IDTYPEFACTURE
/

create or replace view FACTUREFOURNISSEURCPL_NON_LIER as
SELECT
	f.ID,
	f.IDFOURNISSEUR,
	f.IDFOURNISSEURLIB,
	f.IDMODEPAIEMENT,
	f.IDMODEPAIEMENTLIB,
	f.DATY,
	f.DESIGNATION,
	f.DATEECHEANCEPAIEMENT,
	f.ETAT,
	f.ETATLIB,
	f.REFERENCE,
	f.IDBC,
	f.IDMAGASIN,
	f.DEVISE,
	f.TAUX,
	f.IDMAGASINLIB,
	f.IDDEVISE,
	f.MONTANTTVA,
	f.MONTANTHT,
	f.MONTANTTTC,
	f.MONTANTTTCAR,
	f.MONTANTPAYE,
	f.MONTANTRESTE,
	f.TAUXDECHANGE,
	f.IDPREVISION,
	f.IDTYPEFACTURE,
	f.TYPEFACTURE,
	l.id1
FROM FACTUREFOURNISSEURCPL f
LEFT JOIN liaisonfacturefournisseurs l ON
	l.id2 = f.id
/


