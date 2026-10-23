create or replace view import_ing_details as
select imp.*,
       ing.LIBELLE,
       ing.calorie as grammage,
       ing.quantiteparpack,
       cast(case when ing.quantiteparpack > 0 then ing.CALORIE / ing.quantiteparpack else 0 end as number(10, 2)) as poids,
       'g' as unitemorceau,
       imp.PRIXUNITAIRE as ptht,
       cast(imp.PRIXUNITAIRE * (1 + ing.TVA/100) as number(10, 2)) as ptTTC,
       cast(case when ing.quantiteparpack > 0 then imp.PRIXUNITAIRE / ing.quantiteparpack else 0 end as number(10, 2)) as puhtmorceau,
       cast(case when ing.quantiteparpack > 0 then (imp.PRIXUNITAIRE / ing.quantiteparpack) * (1 + ing.TVA/100) else 0 end as number(10, 2)) as puTTCmorceau,
       tc.VAL as typeclientLib
from IMPORTPRIXDETAILS imp
         left join as_ingredients_lib ing on ing.id = imp.IDINGREDIENT
         left join typeClient tc on tc.id = imp.IDTYPECLIENT