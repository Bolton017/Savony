create or replace view mvtStockFilleGroupeMere as
    select f.IDMVTSTOCK,cast(sum(nvl(f.pu*f.ENTREE,0)) as number(30,2)) as montantEntree,
    cast(sum(nvl(f.pu*f.sortie,0)) as number(30,2)) as montantSortie
           from MVTSTOCKFILLE f group by f.IDMVTSTOCK

create or replace view MVTSTOCKLIB as
SELECT
m.ID ,
m.DESIGNATION ,
m.IDMAGASIN ,
m.IDOBJET ,
m2.VAL  AS idMagasinlib,
m.IDVENTE ,
v.DESIGNATION  AS idVentelib,
m.IDTRANSFERT ,
CAST('' AS VARCHAR2(255)) AS idTransfertlib,
m.IDTYPEMVSTOCK ,
t.VAL AS idTypeMvStocklib ,
m.DATY ,
m.ETAT ,
CASE
	WHEN m.ETAT = 0
	THEN 'ANNULEE'
	WHEN m.ETAT = 1
	THEN 'CREE'
	WHEN m.ETAT = 11
	THEN 'VALIDEE'
END AS etatlib,
v.IDRESERVATION,
gm.montantEntree,
gm.montantSortie
FROM MVTSTOCK m
LEFT JOIN TYPEMVTSTOCK t ON t.ID = m.IDTYPEMVSTOCK
LEFT JOIN VENTE v ON v.ID = m.IDVENTE
LEFT JOIN MAGASIN m2 ON m2.ID = m.IDMAGASIN
left join mvtStockFilleGroupeMere gm on gm.IDMVTSTOCK=m.ID
/

create or replace view AS_RECETTECOMPOSE as
select r.ID,
r.IDPRODUITS,
r.IDINGREDIENTS,
CAST(r.QUANTITE AS NUMBER(30,
10)) AS quantite,
r.UNITE,
ing.compose,
ing.TYPESTOCK
FROM
as_recette r,
as_ingredients ing
WHERE
r.IDINGREDIENTS = ing.id
/

create or replace view AS_INGREDIENTS_LIB as
SELECT ing.id,
          ing.LIBELLE,
          ing.SEUIL,
          au.VAL AS unite,
          ing.QUANTITEPARPACK,
          ing.pu,
          ing.ACTIF,
          ing.PHOTO,
          ing.CALORIE,
          ing.DURRE,
          ing.COMPOSE,
          cating.id AS IDCATEGORIEINGREDIENT ,
          catIng.VAL AS CATEGORIEINGREDIENT,
          ing.CATEGORIEINGREDIENT AS idcategorie,
          ing.idfournisseur,
          ing.daty,
          catIng.desce as bienOuServ,
	      CASE WHEN ing.id IN (SELECT idproduit FROM INDISPONIBILITE i )
	      THEN 'INDISPONIBLE'
	      WHEN ing.id NOT IN (SELECT idproduit FROM INDISPONIBILITE i )
	      THEN 'DISPONIBLE'
	      END AS etatlib,
        ing.COMPTE_VENTE,
        ing.COMPTE_ACHAT,
        ing.pv,
        ing.tva,
        ing.TYPESTOCK
     FROM as_ingredients ing
          JOIN AS_UNITE AU ON ing.UNITE = AU.ID
          JOIN CATEGORIEINGREDIENTLIB catIng
             ON catIng.id = ing.CATEGORIEINGREDIENT
/

create or replace view RECETTEMONTANT as
select
rec.ID,rec.IDPRODUITS,rec.IDINGREDIENTS,rec.QUANTITE,rec.UNITE,'-' as libIngredients,
cast(0 as number(30,10)) as qteav,
cast(0 as number(30,10)) as qtetotal,
i.TYPESTOCK
from as_recette rec
left join AS_INGREDIENTS i on rec.IDINGREDIENTS=i.ID
/

create or replace view AS_RECETTECOMPOSE as
select r.ID,
r.IDPRODUITS,
r.IDINGREDIENTS,
CAST(r.QUANTITE AS NUMBER(30,
10)) AS quantite,
nvl(r.UNITE, u.VAL) as unite,
ing.compose,
ing.TYPESTOCK
FROM
as_recette r,
as_ingredients ing,
as_unite u
WHERE
r.IDINGREDIENTS = ing.id(+)
and ing.UNITE=u.id
/

create or replace view AS_RECETTEFAB as
select offi.id,offi.idMere as IDPRODUITS,offi.idingredients,
cast(offi.qte*nvl(e.qte,1) as number(30,10))as quantite,u.val,ing.compose from FabricationFille offi left join equivalence e
on e.idproduit=offi.idingredients and e.idunite=offi.idunite
left join as_ingredients ing on ing.id=offi.idingredients
left join as_unite u on ing.UNITE=u.id
union all
select "ID","IDPRODUITS","IDINGREDIENTS",cast (QUANTITE as number(20,2))as quantite,"UNITE","COMPOSE" from AS_RECETTECOMPOSE
/

create table as_recettefabrication
(
    id            varchar2(50) primary key,
    idingredients varchar2(200) references AS_INGREDIENTS(id),
    unite         varchar2(100),
    qteav         number(30, 5),
    quantite      number(30, 10),
    idproduits    varchar2(100)
)
/

create or replace view as_recetteFabLib as select arf.*,i.LIBELLE as libIngredients,i.TYPESTOCK from as_recettefabrication arf
left join AS_INGREDIENTS i on arf.idingredients=i.id;

create or replace view as_recFabLibGroupe as
select a.IDPRODUITS,a.idingredients,max(a.unite) as unite,sum(quantite) as quantite, avg(a.qteav) as qteav, a.libIngredients
from as_recetteFabLib a group by a.IDPRODUITS, a.idingredients, a.libIngredients ;

alter table CHARGE
    add idingredients varchar2(150);




