alter table as_ingredients add parfums varchar2(100);

create or replace view AS_INGREDIENTS_LIB as
SELECT ing.id,
       ing.LIBELLE,
       ing.PARFUMS,
       ing.SEUIL,
       au.VAL AS unite,
       ing.QUANTITEPARPACK,
       ing.pu,
       ing.ACTIF,
       ing.PHOTO,
       ing.CALORIE,
       ing.DURRE,
       ing.COMPOSE,
       CAST(
               CASE
                   WHEN ing.COMPOSE = 1 THEN 'OUI'
                   WHEN ing.COMPOSE = 0 THEN 'NON'
                   END AS VARCHAR2(100)
       ) AS COMPOSELIB,
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
       ing.TYPESTOCK,
       ing.UNITE as idunite,
       ing.REFPOST,
       ing.REFQUALIFICATION ,
       p.VAL AS REFPOSTLIB,
       qp.VAL AS REFQUALIFICATIONLIB
FROM as_ingredients ing
         LEFT JOIN AS_UNITE AU ON ing.UNITE = AU.ID
         LEFT JOIN CATEGORIEINGREDIENTLIB catIng
                   ON catIng.id = ing.CATEGORIEINGREDIENT
         LEFT JOIN POSTE p ON p.id = ing.REFPOST
         LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = ing.REFQUALIFICATION;

update AS_UNITE set VAL = 'CARTON' where id = 'UNT005042';
update AS_UNITE set DESCE = 'CARTON' where id = 'UNT005042';


create view TARIF_INGREDIENTS_MAX_LIB as
SELECT
    ti."IDTYPECLIENT",ti."IDINGREDIENT",ti."DATY",ti."PRIXUNITAIRE" ,
    t.VAL AS idtypeclientlib,
    ai.LIBELLE AS idingredientlib,
    ti.UNITE,
    u.VAL as unitelib
FROM TARIF_INGREDIENTS_MAX ti
         LEFT JOIN TYPECLIENT t
                   ON ti.IDTYPECLIENT = t.ID
         LEFT JOIN AS_INGREDIENTS ai
                   ON ti.IDINGREDIENT = ai.ID
         left join AS_UNITE u on u.id=ti.UNITE
    /

create or replace view AS_INGREDIENTS_LIB2 as
SELECT ing.id,
       concat(concat(ing.LIBELLE,' '),ing.PARFUMS) as LIBELLE,
       ing.PARFUMS,
       ing.SEUIL,
       au.VAL AS unitelib,
       ing.QUANTITEPARPACK,
       ing.pu,
       ing.ACTIF,
       ing.PHOTO,
       ing.CALORIE,
       ing.DURRE,
       ing.COMPOSE,
       CAST(
               CASE
                   WHEN ing.COMPOSE = 1 THEN 'OUI'
                   WHEN ing.COMPOSE = 0 THEN 'NON'
                   END AS VARCHAR2(100)
       ) AS COMPOSELIB,
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
       ing.TYPESTOCK,
       ing.UNITE as unite,
       ing.REFPOST,
       ing.REFQUALIFICATION ,
       p.VAL AS REFPOSTLIB,
       qp.VAL AS REFQUALIFICATIONLIB
FROM as_ingredients ing
         LEFT JOIN AS_UNITE AU ON ing.UNITE = AU.ID
         LEFT JOIN CATEGORIEINGREDIENTLIB catIng
                   ON catIng.id = ing.CATEGORIEINGREDIENT
         LEFT JOIN POSTE p ON p.id = ing.REFPOST
         LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = ing.REFQUALIFICATION
    /


create or replace view TARIF_INGREDIENTS_LIB as
SELECT
    ti."ID",ti."IDTYPECLIENT",ti."IDINGREDIENT",ti."DATY",ti."PRIXUNITAIRE" ,
    t.VAL AS idtypeclientlib,
    concat(concat(ai.LIBELLE,' '),ai.PARFUMS)  AS idingredientlib,
    ti.UNITE,
    u.VAL as unitelib
FROM TARIF_INGREDIENTS ti
         LEFT JOIN TYPECLIENT t
                   ON ti.IDTYPECLIENT = t.ID
         LEFT JOIN AS_INGREDIENTS ai
                   ON ti.IDINGREDIENT = ai.ID
         left join AS_UNITE u on u.id=ti.UNITE
    /


create or replace view AS_INGREDIENT_VENTE_LIB as
select ing."ID",
       concat(concat(ing.LIBELLE,' '),ing.PARFUMS) as LIBELLE,
       ing."SEUIL",ing."UNITE",ing."QUANTITEPARPACK",ing."PU",ing."ACTIF",ing."PHOTO",ing."CALORIE",ing."DURRE",ing."COMPOSE",ing."CATEGORIEINGREDIENT",ing."IDFOURNISSEUR",ing."DATY",ing."QTELIMITE",ing."PV",ing."LIBELLEVENTE",ing."SEUILMIN",ing."SEUILMAX",ing."PUACHATUSD",ing."PUACHATEURO",ing."PUACHATAUTREDEVISE",ing."PUVENTEUSD",ing."PUVENTEEURO",ing."PUVENTEAUTREDEVISE",ing."ISVENTE",ing."ISACHAT",ing."COMPTE_VENTE",ing."COMPTE_ACHAT",ing."LIBELLEEXTACTE",ing."TVA",ing."FILEPATH",ing."RESTE",ing."TYPESTOCK",ing."REFPOST",ing."REFQUALIFICATION",ing."IDCHAMBRE",ing."ISPERISHABLE",ing."PV2",ing."IDMAGASIN",ting.PRIXUNITAIRE,TING.IDTYPECLIENT,tc.VAL as idtypeclientlib,un.id as idunite,un.VAL as idunitelib,eq.POIDS,eq.QTE from AS_INGREDIENTS ing
        join TARIF_INGREDIENTS_MAX ting on ing.ID=TING.IDINGREDIENT
        join AS_UNITE un on un.ID=TING.UNITE
        join TYPECLIENT tc on tc.ID=TING.IDTYPECLIENT
        left join EQUIVALENCE eq on eq.IDPRODUIT=ting.IDINGREDIENT and eq.IDUNITE=ting.UNITE;

create or replace view CLIENTLIB as
SELECT
    c."ID",c.CODECLIENT,c."NOM",c."TELEPHONE",c."MAIL",c."ADRESSE",c."REMARQUE",c."COMPTE",c."IDNATIONALITE",c."COMPTEAUXILIAIRE",c."ECHEANCE",c."IDTYPECLIENT",c."TELFIXE",c."IDPROVINCE",c."NIF",c."STAT",c."CARTE",c."DATECARTE",c."TAXE" ,
    t.val AS idTypeClientLib, p.VAL AS provincelib
FROM CLIENT c
         LEFT JOIN TYPECLIENT t ON c.idTypeClient = t.id
         LEFT JOIN PROVINCE p ON p.id = c.idprovince
    /
