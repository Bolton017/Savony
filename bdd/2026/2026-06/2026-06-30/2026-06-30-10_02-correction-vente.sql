update AS_INGREDIENTS set ACTIF = 0 where PARFUMS = '27150251';

update AS_INGREDIENTS set UNITE = 'UNT00008' where PARFUMS = '27150252';

update CLIENT set IDTYPECLIENT = 'TYPE009', nom = 'PLACEMENT PERSONNEL P/C MIHARY' where id = 'CLI00SOCT0141100245';

create or replace view AS_INGREDIENT_VENTE_LIB_PRX as
select ing."ID",
       concat(concat(ing.PARFUMS, ' '), ing.LIBELLE) as LIBELLE,
       ing."SEUIL",
       ing."UNITE",
       ing."QUANTITEPARPACK",
       cast(ing."PU" as number(30,2)) as PU,
       ing."ACTIF",
       ing."PHOTO",
       ing."CALORIE",
       ing."DURRE",
       ing."COMPOSE",
       ing."CATEGORIEINGREDIENT",
       ing."IDFOURNISSEUR",
       nvl(ting.DATY,ing.DATY) AS daty,
       ing."QTELIMITE",
       cast(ing."PV" as number(30,2)) as PV,
       ing."LIBELLEVENTE",
       ing."SEUILMIN",
       ing."SEUILMAX",
       ing."PUACHATUSD",
       ing."PUACHATEURO",
       ing."PUACHATAUTREDEVISE",
       ing."PUVENTEUSD",
       ing."PUVENTEEURO",
       ing."PUVENTEAUTREDEVISE",
       ing."ISVENTE",
       ing."ISACHAT",
       ing."COMPTE_VENTE",
       ing."COMPTE_ACHAT",
       ing."LIBELLEEXTACTE",
       ing."TVA",
       ing."FILEPATH",
       ing."RESTE",
       ing."TYPESTOCK",
       ing."REFPOST",
       ing."REFQUALIFICATION",
       ing."IDCHAMBRE",
       ing."ISPERISHABLE",
       ing."PV2",
       ing."IDMAGASIN",
       cast(nvl(ting.PRIXUNITAIRE,ing.PV) as number (30,2)) AS PRIXUNITAIRE,
       tc.ID as IDTYPECLIENT,
       tc.VAL as idtypeclientlib,
       nvl(un.id,un2.id) as idunite,
       nvl(un.VAL,un2.val) as idunitelib,
       eq.POIDS,
       eq.QTE
from AS_INGREDIENTS ing
         cross join TYPECLIENT tc
         left join TARIF_INGREDIENTS_MAX ting on ing.ID = TING.IDINGREDIENT AND ting.IDTYPECLIENT=tc.id
         left join AS_UNITE un on un.ID = TING.UNITE
         left join AS_UNITE un2 on un2.ID = ing.UNITE
         left join EQUIVALENCE eq on eq.IDPRODUIT = ting.IDINGREDIENT and eq.IDUNITE = ting.UNITE
WHERE ing.CATEGORIEINGREDIENT = 'CAT008' AND ing.actif=1 ORDER BY daty DESC;

