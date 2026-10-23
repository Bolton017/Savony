create or replace view FACTUREFOURNISSEUR_FILLECOMPTE as
select ff.COMPTE,
       ff.IDFACTUREFOURNISSEUR,
       f.etat,
       cast(sum(ff.MONTANTHT*(1-(nvl(f.REMISE,0))/100)) as number(30, 2))                            as montantht,
       cast(sum(ff.MONTANTTVA*(1-(nvl(f.REMISE,0))/100)) as number(30, 2))              as montanttva,
       cast(sum(ff.MONTANTTTC*(1-(nvl(f.REMISE,0))/100)) as number(30, 2)) as montantttc,
       ff.iddevise,
       ff.tauxdechange
from FFFILLECALC ff join FACTUREFOURNISSEUR f on f.id=ff.IDFACTUREFOURNISSEUR
group by COMPTE, IDFACTUREFOURNISSEUR, f.etat,ff.iddevise,ff.tauxdechange;

create or replace view FACTUREFOURNISSEUR_FILLE_VISE as
select COMPTE,IDFACTUREFOURNISSEUR,ETAT,MONTANTHT,MONTANTTVA,MONTANTTTC,iddevise,tauxdechange
from FACTUREFOURNISSEUR_FILLECOMPTE
where etat >= 11;