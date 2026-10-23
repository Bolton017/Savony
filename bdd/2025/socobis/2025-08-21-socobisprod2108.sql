--menu 
--Production
--Etat global
--fabrication/etat-global.jsp


INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYN02108001', 'Etat global', 'fas fa-boxes', NULL, 4, 2, 'MENUDYN00304001');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MENUDYN02108002', 'Liste', 'fa fa-list', 'module.jsp?but=fabrication/etat-global.jsp', 1, 3, 'MENUDYN02108001');

--OFFILLELIBSTOCK
--atao left join am ofab
--de ilay datybesoin ovaina ofab.daty ny valeurny

CREATE OR REPLACE  VIEW OFFILLELIBSTOCK (ID, IDINGREDIENTS, LIBELLE, REMARQUE, IDMERE, DATYBESOIN, QTE, IDUNITE, QTEFABRIQUE, QTERESTE, LIBELLEEXACTE, PV, MONTANTENTREE, MONTANTSORTIE, POURC) AS 
  SELECT
	ofll.ID,
	ofll.IDINGREDIENTS,
	nvl(ofll.LIBELLE,ai.LIBELLE)  AS LIBELLE,
	ofll.REMARQUE,
	ofll.IDMERE,
	ob.daty AS  DATYBESOIN,
	ofll.QTE,
	nvl(au.VAL, 'unite') AS IDUNITE,
	cast(nvl(mv.entree,0) as number(30,2)) as qteFabrique,
	cast(ofll.QTE-nvl(mv.ENTREE,0)as number(30,2)) as qteReste,
	nvl(ofll.LIBELLE,nvl(ai.LIBELLEEXTACTE, ai.LIBELLE)) AS libelleexacte,
    ai.pv,
    cast(nvl(mv.ENTREE,0)*ai.pv as number(30,2)) as montantEntree,
    mvt.montantSortie,
        CASE
        WHEN (nvl(mv.ENTREE,0)=0 or ai.pv=0) THEN 0
        ELSE (1-(mvt.montantSortie/(nvl(mv.ENTREE,0)*ai.pv)))*100
    END AS pourc
FROM
	OFFILLE ofll
LEFT JOIN AS_INGREDIENTS ai ON
	ai.ID = ofll.IDINGREDIENTS
LEFT JOIN AS_UNITE au ON
	au.ID = ofll.IDUNITE
left join MVTSTFILLEOFFCATVISEGROUPEDEP mvt on ofll.id=mvt.IDOFf
left join mvtStockFilleOfEntreePrFini mv on mv.idoff=ofll.id and mv.IDPRODUIT=ofll.IDINGREDIENTS
LEFT JOIN OFAB ob ON ob.id =  ofll.idmere
;