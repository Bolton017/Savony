create or replace view stockEtDepenseFab as
select mvt.IDOBJET, fille.IDPRODUIT,sum(ENTREE) as entree, sum(SORTIE) as sortie, cast(avg(pu) as number(30,2)) as pu,
       cast(nvl(avg(pu)*sum(entree),0) as number(30,3)) as montantentree,cast(nvl(avg(pu)*sum(sortie),0) as number(30,3)) as montantsortie,ofille.IDMERE,ofille.id
from MVTSTOCKFILLE fille
    left join MvtStockLib mvt on fille.IDMVTSTOCK=mvt.ID
left join FABRICATION fab on mvt.IDOBJET=fab.ID
left join OFFILLE ofille on fab.IDOFFILLE=ofille.ID
where mvt.ETAT>=11 having (sum(ENTREE) - sum(SORTIE))!=0
group by fille.IDPRODUIT,mvt.IDOBJET,ofille.IDMERE,ofille.id
union all
select c.IDFABRICATION as idobjet,c.IDINGREDIENTS as IDPRODUIT,0 as entree,cast(sum(c.qte) as number (30,10)) as sortie,cast(avg(c.PU) as number(30,2)) as pu,0 as montantentree,cast(nvl(avg(c.pu)*sum(c.qte),0) as number(30,2)) as montantsortie,ofile.IDMERE,ofile.id
from charge c
left join fabrication fabb on c.IDFABRICATION=fabb.id
left join OFFILLE ofile on fabb.IDOFFILLE=ofile.ID
where c.etat>=11 group by c.IDFABRICATION, c.IDINGREDIENTS,ofile.IDMERE,ofile.id;

create or replace view stockDepenseOfFab as
    select idmere as idobjet,sdf.IDPRODUIT,cast(sum(sdf.entree) as number(30,2)) as entree,cast(sum(sdf.sortie) as number(30,2)) as sortie, cast(avg(sdf.pu) as number(30,2)) as pu,
           sum(montantentree) as montanentree, sum(montantsortie) as montantsortie,idmere,'-' as id
    from stockEtDepenseFab sdf
group by sdf.IDPRODUIT,idmere;

create or replace view stockEtDepenseFabThe as
select sed.*,cast(nvl(recFab.QUANTITE,0) as number(30,10)) as qteTh,cast(nvl(recFab.QTEAV,sed.pu) as number(30,2)) as puth, cast(nvl(recFab.QUANTITE,0)*nvl(recFab.QTEAV,0) as number(30,2)) as montTh from stockEtDepenseFab sed full outer join as_recFabLibGroupe recFab
    on sed.IDOBJET=recFab.IDPRODUITS and sed.IDPRODUIT=recFab.IDINGREDIENTS;

create view AS_RECFOFABLIBGROUPE as
select fille.IDMERE as IDPRODUITS,a.idingredients,max(a.unite) as unite,sum(quantite) as quantite, avg(a.qteav) as qteav, a.libIngredients
from as_recetteFabLib a left join fabrication fab on a.IDPRODUITS=fab.ID
left join OFFILLE fille on fab.IDOFFILLE=fille.id
group by fille.idMere, a.idingredients, a.libIngredients
/

create or replace view stockEtDepenseOfFabThe as
select sed.*,cast(nvl(recFab.QUANTITE,0) as number(30,10)) as qteTh,cast(nvl(recFab.QTEAV,sed.pu) as number(30,2)) as puth, cast(nvl(recFab.QUANTITE,0)*nvl(recFab.QTEAV,0) as number(30,2)) as montTh from stockDepenseOfFab sed full outer join AS_RECFOFABLIBGROUPE recFab
    on sed.IDOBJET=recFab.IDPRODUITS and sed.IDPRODUIT=recFab.IDINGREDIENTS;

CREATE OR REPLACE FORCE VIEW STOCKETDEPENSEOFFABTHE AS
  select sed."IDOBJET",sed."IDPRODUIT",recFab.LIBINGREDIENTS AS designation,sed."ENTREE",sed."SORTIE",sed."PU",sed."MONTANENTREE",sed."MONTANTSORTIE",sed."IDMERE",sed."ID",cast(nvl(recFab.QUANTITE,0) as number(30,10)) as qteTh,cast(nvl(recFab.QTEAV,sed.pu) as number(30,2)) as puth, cast(nvl(recFab.QUANTITE,0)*nvl(recFab.QTEAV,0) as number(30,2)) as montTh from stockDepenseOfFab sed full outer join AS_RECFOFABLIBGROUPE recFab
    on sed.IDOBJET=recFab.IDPRODUITS and sed.IDPRODUIT=recFab.IDINGREDIENTS;

CREATE OR REPLACE FORCE VIEW STOCKETDEPENSEFABTHE AS
select sed."IDOBJET",sed."IDPRODUIT",recFab.LIBINGREDIENTS AS designation,sed."ENTREE",sed."SORTIE",sed."PU",sed."MONTANTENTREE",sed."MONTANTSORTIE",sed."IDMERE",sed."ID",cast(nvl(recFab.QUANTITE,0) as number(30,10)) as qteTh,cast(nvl(recFab.QTEAV,sed.pu) as number(30,2)) as puth, cast(nvl(recFab.QUANTITE,0)*nvl(recFab.QTEAV,0) as number(30,2)) as montTh from stockEtDepenseFab sed full outer join as_recFabLibGroupe recFab
    on sed.IDOBJET=recFab.IDPRODUITS and sed.IDPRODUIT=recFab.IDINGREDIENTS;