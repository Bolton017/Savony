
/*------- AS_RECETTEFABLIB --------------*/
CREATE OR REPLACE VIEW AS_RECETTEFABLIB AS 
select 
	arf.ID,
	arf.IDINGREDIENTS,
	arf.UNITE,
	arf.QTEAV,
	arf.QUANTITE,
	arf.IDPRODUITS,
	i.LIBELLE ||' ('||u.VAL||')' as libIngredients,
	i.TYPESTOCK,
	i.CATEGORIEINGREDIENT,
	i.pu,
	cat.val AS CATEGORIEINGREDIENTLIB
from as_recettefabrication arf
left join AS_INGREDIENTS i 
on arf.idingredients=i.id
LEFT JOIN CATEGORIEINGREDIENT cat 
ON cat.id=i.CATEGORIEINGREDIENT  
left join AS_UNITE u on i.UNITE=u.ID;

/*------------AS_RECFOFABLIBGROUPE------------*/
CREATE OR REPLACE VIEW AS_RECFOFABLIBGROUPE AS
select 
	fille.IDMERE as IDPRODUITS,
	a.idingredients,
	max(a.unite) as unite,
	sum(quantite) as quantite,
	avg(a.qteav) as qteav,
	CAST(avg(a.pu) AS NUMBER(30,2)) AS pu,
	a.libIngredients,
	a.CATEGORIEINGREDIENT,
	a.CATEGORIEINGREDIENTLIB
from as_recetteFabLib a 
left join fabrication fab on a.IDPRODUITS=fab.ID
left join OFFILLE fille on fab.IDOFFILLE=fille.id
group by fille.idMere, a.idingredients, a.libIngredients, a.CATEGORIEINGREDIENT, a.CATEGORIEINGREDIENTLIB;

/*-------------STOCKETDEPENSEOFFABTHE----------*/
CREATE OR REPLACE VIEW STOCKETDEPENSEOFFABTHE AS
  select
  	sed."IDOBJET",
  	sed."IDPRODUIT",
  	nvl(recFab.LIBINGREDIENTS,ai.LIBELLE) AS designation,
  	CAST(sed."ENTREE" as number(30,2)) AS ENTREE ,
  	CAST(sed."SORTIE" as number(30,2))  AS SORTIE ,
  	CAST(
  		CASE
  			WHEN nvl(sed."PU",0) = 0 THEN recFab.pu
		ELSE nvl(sed."PU",0)
		END
  	as number(30,2)) AS PU,
  	CAST(sed."MONTANENTREE" as number(30,2)) AS MONTANENTREE ,
  	CAST(
  		CASE
  			WHEN nvl(sed."PU",0) = 0 THEN recFab.pu * sed."SORTIE"
		ELSE nvl(sed."PU",0) * sed."SORTIE"
		END
  	as number(30,2))  AS MONTANTSORTIE,
  	sed."IDMERE",
  	sed."ID",
  	cast(nvl(recFab.QUANTITE,0) as number(30,10)) as qteTh,
  	cast(nvl(recFab.QTEAV,sed.pu) as number(30,2)) as puth,
  	cast(nvl(recFab.QUANTITE,0)*nvl(recFab.QTEAV,0) as number(30,2)) as montTh,
  	recFab.CATEGORIEINGREDIENT,
  	recFab.CATEGORIEINGREDIENTLIB
  from stockDepenseOfFab sed full
  	outer join AS_RECFOFABLIBGROUPE recFab
    on sed.IDOBJET=recFab.IDPRODUITS and sed.IDPRODUIT=recFab.IDINGREDIENTS
    LEFT JOIN AS_INGREDIENTS ai ON ai.ID = sed.IDOBJET OR ai.ID =  sed.IDPRODUIT;