
CREATE OR REPLACE VIEW STOCKETDEPENSEFABNC AS 
  select mvt.IDOBJET, fille.IDPRODUIT,cast(sum(ENTREE) as number(15,2)) as entree, cast(sum(SORTIE) as number(15,2)) as sortie, cast(avg(fille.pu) as number(30,2)) as pu,
cast(nvl(avg(fille.pu)*sum(entree),0) as number(30,3)) as montantentree,cast(nvl(avg(fille.pu)*sum(sortie),0) as number(30,3)) as montantsortie,ofille.IDMERE,ofille.id, cat.id AS CATEGORIEINGREDIENT, cat.val AS CATEGORIEINGREDIENTLIB
from MVTSTOCKFILLE fille
left join MvtStockLib mvt on fille.IDMVTSTOCK=mvt.ID
left join FABRICATION fab on mvt.IDOBJET=fab.ID
left join OFFILLE ofille on fab.IDOFFILLE=ofille.ID
left join AS_INGREDIENTS ai on fille.IDPRODUIT=ai.id
LEFT JOIN CATEGORIEINGREDIENT cat ON cat.id = ai.CATEGORIEINGREDIENT 
where mvt.ETAT>=11  and ai.COMPOSE=0
group by fille.IDPRODUIT,mvt.IDOBJET,ofille.IDMERE,ofille.id,ai.COMPOSE, cat.id, cat.val
union all
select c.IDFABRICATION as idobjet,c.IDINGREDIENTS as IDPRODUIT,cast(0 as number(15,2)) as entree,cast(sum(c.qte) as number (15,2)) as sortie,cast(avg(c.PU) as number(30,2)) as pu,cast(0 as number(30,3)) as montantentree,cast(nvl(avg(c.pu)*sum(c.qte),0) as number(30,3)) as montantsortie
,ofile.IDMERE,ofile.id, cat.id AS CATEGORIEINGREDIENT, cat.val AS CATEGORIEINGREDIENTLIB
from charge c
left join fabrication fabb on c.IDFABRICATION=fabb.id
left join OFFILLE ofile on fabb.IDOFFILLE=ofile.ID
LEFT JOIN AS_INGREDIENTS ai ON c.IDINGREDIENTS = ai.id
LEFT JOIN CATEGORIEINGREDIENT cat ON cat.id = ai.CATEGORIEINGREDIENT 
where c.etat>=11 group by c.IDFABRICATION, c.IDINGREDIENTS,ofile.IDMERE,ofile.id, cat.id, cat.val;




CREATE OR REPLACE VIEW STOCKETDEPENSEFAB AS 
  select idobjet,IDPRODUIT,cast(entree as number(30,2)) as entree,cast(sortie as number(30,2)) as sortie,cast(pu as number(30,2)) as pu,
          cast(montantentree as number(30,2)) as montantentree,cast(montantsortie as number(30,2)) as montantsortie,IDMERE,id, CATEGORIEINGREDIENT,CATEGORIEINGREDIENTLIB
           from STOCKETDEPENSEFABNC;


CREATE OR REPLACE VIEW STOCKDEPENSEOFFAB AS 
  select idmere as idobjet,sdf.IDPRODUIT,cast(sum(sdf.entree) as number(30,2)) as entree,cast(sum(sdf.sortie) as number(30,2)) as sortie, cast(avg(sdf.pu) as number(30,2)) as pu,
           sum(montantentree) as montanentree, sum(montantsortie) as montantsortie,idmere,'-' as id, sdf.categorieingredient, sdf.categorieingredientlib
    from STOCKETDEPENSEFAB sdf
group by sdf.IDPRODUIT,idmere, sdf.categorieingredient, sdf.categorieingredientlib;



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
  	sed.CATEGORIEINGREDIENT,
  	sed.CATEGORIEINGREDIENTLIB
  from stockDepenseOfFab sed full
  	outer join AS_RECFOFABLIBGROUPE recFab
    on sed.IDOBJET=recFab.IDPRODUITS and sed.IDPRODUIT=recFab.IDINGREDIENTS
    LEFT JOIN AS_INGREDIENTS ai ON ai.ID = sed.IDOBJET OR ai.ID =  sed.IDPRODUIT;

UPDATE AS_INGREDIENTS SET COMPOSE = 0 WHERE CATEGORIEINGREDIENT = 'CAT0012';




