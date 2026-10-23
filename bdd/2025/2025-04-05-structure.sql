create or replace view OFFILLELIB as
SELECT
	ofll.ID,
	ofll.IDINGREDIENTS,
	ai.LIBELLE ||' '|| ofll.LIBELLE as LIBELLE,
	ofll.REMARQUE,
	ofll.IDMERE,
	ofll.DATYBESOIN,
	ofll.QTE,
	nvl(au.VAL,'unite') AS IDUNITE,
	fmf.qte AS qteFabrique,(ofll.qte-fmf.qte) AS qteReste 
FROM OFFILLE ofll
	LEFT JOIN AS_INGREDIENTS ai ON ai.ID = ofll.IDINGREDIENTS
	LEFT JOIN AS_UNITE au ON au.ID = ofll.IDUNITE
    LEFT JOIN FabricationMereFille fmf on fmf.IDOF=ofll.IDMERE;



-- COMPTA_MONTANT source

CREATE OR REPLACE VIEW COMPTA_MONTANT (MONTANT, IDMERE) AS 
  SELECT
sum(nvl(cse.DEBIT,0)) AS montant ,
cse.IDMERE
FROM COMPTA_SOUS_ECRITURE cse
GROUP BY IDMERE;


-- COMPTA_ECRITURE_LIB source

CREATE OR REPLACE  VIEW COMPTA_ECRITURE_LIB (ID, DATY, DATECOMPTABLE, EXERCICE, DESIGNATION, REMARQUE, ETAT, HORSEXERCICE, JOURNAL, OD, ORIGINE, CREDIT, DEBIT, IDUSER, PERIODE, TRIMESTRE, ANNEE, IDOBJET, MONTANT, JOURNALLIB) AS 
  SELECT 
ce.ID,ce.DATY,ce.DATECOMPTABLE,ce.EXERCICE,ce.DESIGNATION,ce.REMARQUE,ce.ETAT,ce.HORSEXERCICE,ce.JOURNAL,ce.OD,ce.ORIGINE,ce.CREDIT,ce.DEBIT,ce.IDUSER,ce.PERIODE,ce.TRIMESTRE,ce.ANNEE,ce.IDOBJET ,
cm.montant,
cj.desce AS JOURNALLIB
FROM COMPTA_ECRITURE ce 
JOIN COMPTA_MONTANT cm ON ce.id = cm.IDMERE
LEFT JOIN COMPTA_JOURNAL cj ON cj.id = ce.JOURNAL
;


alter table MVTSTOCK
    drop constraint MVTSTOCK_MAGASIN_FK;
alter table INVENTAIRE
    drop constraint INVENTAIRE_MAGASIN_FK;
update inventaire i set i.idMagasin=(select idpoint from magasin where id=i.IDMAGASIN) where 1<2;

update MVTSTOCK m set m.IDMAGASIN=(select idpoint from magasin where id=m.IDMAGASIN) where 1<2;

rename MAGASIN to MAGASIN2;

create or replace view magasin as
    select p.ID,
    p.VAL,
    p.DESCE,
    p.id as idPoint,
    '-' as idProduit,
    '' as idtypemagasin,
    11 as etat
    from point p;