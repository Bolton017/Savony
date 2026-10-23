create or replace view CRPRODUCTIONJOURNALIER as
select
    fabj.idingredients,
    fabj.libelle,
    fabj.daty,
    fabj.moisannee,
    cast(nvl(sum(fabj.qtecarton),0) AS NUMBER(30, 2)) as qtecarton,
    cast(NVl(sum(mvt.ENTREE), 0) AS NUMBER(30, 2)) as qtefabrique,
    cast(sum(fabj.qtecarton) * nvl(fabj.CALORIE,0) AS NUMBER(30, 2)) as qtekg,
    cast(NVl(sum(mvt.ENTREE), 0) * nvl(fabj.CALORIE,0) AS NUMBER(30, 2)) as qtefabriquekg,
    cast(nvl(ob.QTE,0) AS NUMBER(30, 2)) as OBJECTIF,
    cast(nvl(ob.QTE,0) AS NUMBER(30, 2)) - NVl(sum(mvt.ENTREE), 0) as ECARTOBJECTIF
from (select fab.ID,
             fab.daty,
             fabf.IDINGREDIENTS,
             TO_CHAR(fab.daty, 'MM-YYYY')                                           AS moisannee,
             ai.LIBELLE,
             ai.CALORIE,
             nvl(sum(fabf.QTE), 0) as qtecarton
      from FABRICATIONCPL fab
               left join FABRICATIONFILLE fabf on fabf.IDMERE = fab.ID
               left join AS_INGREDIENTS ai on ai.ID = fabf.IDINGREDIENTS
      where ai.CATEGORIEINGREDIENT = 'CAT008'
      group by ai.CALORIE, fab.ID, fab.daty, fabf.IDINGREDIENTS, ai.LIBELLE) fabj
         LEFT JOIN (
    SELECT st.ENTREE,
           st.IDPRODUIT,
           m.IDOBJET AS idFab
    FROM MVTSTOCKFILLE st
             LEFT JOIN MVTSTOCK m ON st.IDMVTSTOCK = m.ID
    WHERE m.etat >= 11
) mvt ON mvt.IDFAB = fabj.ID AND mvt.IDPRODUIT = fabj.IDINGREDIENTS
         left join OBJECTIFPRODUCTION ob on ob.IDPRODUIT = fabj.IDINGREDIENTS
group by fabj.DATY, fabj.moisannee, fabj.IDINGREDIENTS, fabj.LIBELLE, fabj.CALORIE, ob.QTE
order by IDINGREDIENTS, DATY
;

create or replace view CRCUMMULMOISANNEE as
select cr.IDINGREDIENTS,
       cr.LIBELLE,
       cr.MOISANNEE,
       cast(sum(cr.QTEFABRIQUE) as NUMBER(30, 2)) as CUMULMOIS
from CRPRODUCTIONJOURNALIER cr
group by cr.IDINGREDIENTS, cr.LIBELLE, cr.MOISANNEE
order by cr.IDINGREDIENTS, cr.MOISANNEE
;

create or replace view CRPRODJOURNALIERAVECCUMUL as
select crj.* , crm.CUMULMOIS
from CRPRODUCTIONJOURNALIER crj
         left join CRCUMMULMOISANNEE crm on crm.IDINGREDIENTS = crj.IDINGREDIENTS and crm.MOISANNEE = crj.MOISANNEE
