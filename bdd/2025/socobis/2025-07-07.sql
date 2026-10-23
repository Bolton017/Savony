CREATE OR REPLACE VIEW STOCKETDEPENSEOFFABTHECAT AS 
 SELECT
 	std."IDOBJET",
 	std."IDPRODUIT",
 	std."ENTREE",
 	std."SORTIE",
 	std."PU",
 	std."MONTANENTREE",
 	std."MONTANTSORTIE",
 	std."IDMERE",
 	std."ID",
 	std."QTETH",
 	std."PUTH",
 	std."MONTTH",
 	cat.VAL as CATEGORIEINGREDIENT,
 	cat.ID AS idcategorieingredient
 from stockEtDepenseOfFabThe std
   left join AS_INGREDIENTS ing on std.IDPRODUIT=ing.id
left join CATEGORIEINGREDIENT cat on ing.CATEGORIEINGREDIENT=cat.id;

CREATE OR REPLACE VIEW STOCKETDEPOFFABTHECATGROUPE AS 
 select 
 	st.idmere,
 	st.CATEGORIEINGREDIENT,
 	st.idcategorieingredient,
 	cast(sum(montantsortie) as number(30,2)) as montantSortie,
 	cast(sum(montth) as number(30,2)) as montth,
 	cast(sum(montth)-sum(montantsortie) as number(30,2)) as ecart
  from stockEtDepenseOfFabTheCat st 
 	group by st.idmere,st.CATEGORIEINGREDIENT, st.idcategorieingredient;

CREATE OR REPLACE VIEW AS_RECFOFABLIBGROUPE AS
select 
	fille.IDMERE as IDPRODUITS,
	a.idingredients,
	max(a.unite) as unite,
	sum(quantite) as quantite,
	avg(a.qteav) as qteav,
	a.libIngredients,
	a.CATEGORIEINGREDIENT
from as_recetteFabLib a 
	left join fabrication fab on a.IDPRODUITS=fab.ID
	left join OFFILLE fille on fab.IDOFFILLE=fille.id
	group by fille.idMere, a.idingredients, a.libIngredients, a.CATEGORIEINGREDIENT;

CREATE OR REPLACE VIEW STOCKETDEPENSEOFFABTHE AS
  select 
  	sed."IDOBJET",
  	sed."IDPRODUIT",
  	recFab.LIBINGREDIENTS AS designation,
  	sed."ENTREE",
  	sed."SORTIE",
  	sed."PU",
  	sed."MONTANENTREE",
  	sed."MONTANTSORTIE",
  	sed."IDMERE",
  	sed."ID",
  	cast(nvl(recFab.QUANTITE,0) as number(30,10)) as qteTh,
  	cast(nvl(recFab.QTEAV,sed.pu) as number(30,2)) as puth,
  	cast(nvl(recFab.QUANTITE,0)*nvl(recFab.QTEAV,0) as number(30,2)) as montTh,
  	recFab.CATEGORIEINGREDIENT
  from stockDepenseOfFab sed full 
  	outer join AS_RECFOFABLIBGROUPE recFab
    on sed.IDOBJET=recFab.IDPRODUITS and sed.IDPRODUIT=recFab.IDINGREDIENTS;


CREATE OR REPLACE VIEW V_ETATSTOCK_ING AS
SELECT
    p.ID AS ID,
    p.LIBELLE AS idproduitLib,
    p.CATEGORIEINGREDIENT,
    tp.DESCE AS idtypeproduitlib,
    ms.IDMAGASIN,
    mag.VAL AS idmagasinlib,
    TO_DATE('01-01-2001', 'DD-MM-YYYY') AS dateDernierMouvement,
    ms.quantite AS QUANTITE,
    CAST(NVL( ms.entree, 0) AS NUMBER(30, 2))  AS ENTREE,
    CAST(NVL( ms.sortie, 0) AS NUMBER(30, 2))  AS SORTIE,
    CAST(NVL( ms.quantite, 0) AS NUMBER(30, 2))  AS reste,
    p.UNITE,
    u.DESCE AS idunitelib,
    CAST(NVL(p.PV, 0) AS NUMBER(30, 2)) AS PUVENTE,
    mag.IDPOINT,
    mag.IDTYPEMAGASIN,
    p.SEUILMIN,
    p.SEUILMAX,
    ms.montantEntree,
    ms.montantSortie,
    p.pu,
    ms.montant as montantReste
FROM AS_INGREDIENTS p
         LEFT JOIN MONTANT_STOCK ms ON ms.IDPRODUIT = p.ID
         LEFT JOIN CATEGORIEINGREDIENT tp ON p.CATEGORIEINGREDIENT = tp.ID
         LEFT JOIN MAGASINPOINT mag ON ms.IDMAGASIN = mag.ID
         LEFT JOIN AS_UNITE u ON p.UNITE = u.ID
WHERE NVL(ms.ENTREE, 0)>0 or NVL(ms.SORTIE, 0)>0;


CREATE OR REPLACE VIEW AS_RECETTEFABLIB AS
select arf.ID,arf.IDINGREDIENTS,arf.UNITE,arf.QTEAV,arf.QUANTITE,arf.IDPRODUITS,i.LIBELLE ||' ('||u.VAL||')' as libIngredients,i.TYPESTOCK,i.CATEGORIEINGREDIENT,i.PU from as_recettefabrication arf
                                                                                                                                                                               left join AS_INGREDIENTS i on arf.idingredients=i.id
                                                                                                                                                                               left join AS_UNITE u on i.UNITE=u.ID;


CREATE OR REPLACE VIEW AS_RECFOFABLIBGROUPE AS
select
    fille.IDMERE as IDPRODUITS,
    a.idingredients,
    max(a.unite) as unite,
    sum(quantite) as quantite,
    avg(a.qteav) as qteav,
    CAST(avg(a.pu) AS NUMBER(30,2)) AS pu,
    a.libIngredients,
    a.CATEGORIEINGREDIENT
from as_recetteFabLib a
         left join fabrication fab on a.IDPRODUITS=fab.ID
         left join OFFILLE fille on fab.IDOFFILLE=fille.id
group by fille.idMere, a.idingredients, a.libIngredients, a.CATEGORIEINGREDIENT;

CREATE OR REPLACE VIEW STOCKETDEPENSEOFFABTHE AS
select
    sed."IDOBJET",
    sed."IDPRODUIT",
    recFab.LIBINGREDIENTS AS designation,
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
    recFab.CATEGORIEINGREDIENT
from stockDepenseOfFab sed full
                               outer join AS_RECFOFABLIBGROUPE recFab
                                          on sed.IDOBJET=recFab.IDPRODUITS and sed.IDPRODUIT=recFab.IDINGREDIENTS;





