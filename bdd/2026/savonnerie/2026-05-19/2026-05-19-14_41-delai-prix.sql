alter table CLIENT add delai number;

create or replace view AS_INGREDIENT_VENTE_LIB_PRX as
select ing."ID",
       concat(concat(ing.LIBELLE, ' '), ing.PARFUMS) as LIBELLE,
       ing."SEUIL",
       ing."UNITE",
       ing."QUANTITEPARPACK",
       ing."PU",
       ing."ACTIF",
       ing."PHOTO",
       ing."CALORIE",
       ing."DURRE",
       ing."COMPOSE",
       ing."CATEGORIEINGREDIENT",
       ing."IDFOURNISSEUR",
       nvl(ting.DATY,ing.DATY) AS daty,
       ing."QTELIMITE",
       ing."PV",
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
       nvl(ting.PRIXUNITAIRE,ing.PV) AS PRIXUNITAIRE,
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
WHERE ing.CATEGORIEINGREDIENT = 'CAT008';

create or replace view CLIENTLIB as
SELECT
    c.ID,c.NOM,c.TELEPHONE,c.MAIL,c.ADRESSE,c.REMARQUE,c.COMPTE,c.IDNATIONALITE,c.COMPTEAUXILIAIRE,c.IDTYPECLIENT,
    t.val AS idTypeClientLib,
    c.codeclient,c.datecarte,c.taxe,c.idprovince,c.echeance,c.telfixe,c.nif,c.stat,c.carte,p.val AS provincelib,
    c.idzoneclient, zc.val as idzoneclientlib,
    c.IDMODEPAIEMENT, mp.val as idModePaiementLib,
    c.cin,
    c.DELAI
FROM CLIENT c
         LEFT JOIN typeclient t
                   ON c.idTypeClient = t.id
         LEFT JOIN province p ON c.idprovince=p.id
         LEFT JOIN ZONECLIENT zc on c.idzoneclient = zc.ID
         LEFT JOIN MODEPAIEMENT mp on c.idModePaiement = mp.id;
