
CREATE OR REPLACE  VIEW AS_INGREDIENTS_LIB ("ID", "LIBELLE", "PARFUMS", "SEUIL", "UNITE", "QUANTITEPARPACK", "PU", "ACTIF", "PHOTO", "CALORIE", "DURRE", "COMPOSE", "COMPOSELIB", "IDCATEGORIEINGREDIENT", "CATEGORIEINGREDIENT", "IDCATEGORIE", "IDFOURNISSEUR", "DATY", "BIENOUSERV", "ETATLIB", "COMPTE_VENTE", "COMPTE_ACHAT", "PV", "TVA", "TYPESTOCK", "IDUNITE", "REFPOST", "REFQUALIFICATION", "REFPOSTLIB", "REFQUALIFICATIONLIB", "IDFAMILLELIB","ACTIFLIB") AS
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
       qp.VAL AS REFQUALIFICATIONLIB,
       fp.val AS idfamilleLib,
       CASE
           WHEN ing.actif = 1 THEN 'OUI'
           WHEN ing.actif = 0 THEN 'NON'
           END AS  actiflib

FROM as_ingredients ing
         LEFT JOIN AS_UNITE AU ON ing.UNITE = AU.ID
         LEFT JOIN CATEGORIEINGREDIENTLIB catIng
                   ON catIng.id = ing.CATEGORIEINGREDIENT
         LEFT JOIN POSTE p ON p.id = ing.REFPOST
         LEFT JOIN FAMILLEPRODUIT fp ON fp.id=ing.idfamille
         LEFT JOIN QUALIFICATION_PAIE qp ON qp.id = ing.REFQUALIFICATION;

-- produit actif uniquement pour saisie vente
CREATE OR REPLACE  VIEW AS_INGREDIENT_VENTE_LIB ("ID", "LIBELLE", "SEUIL", "UNITE", "QUANTITEPARPACK", "PU", "ACTIF", "PHOTO", "CALORIE", "DURRE", "COMPOSE", "CATEGORIEINGREDIENT", "IDFOURNISSEUR", "DATY", "QTELIMITE", "PV", "LIBELLEVENTE", "SEUILMIN", "SEUILMAX", "PUACHATUSD", "PUACHATEURO", "PUACHATAUTREDEVISE", "PUVENTEUSD", "PUVENTEEURO", "PUVENTEAUTREDEVISE", "ISVENTE", "ISACHAT", "COMPTE_VENTE", "COMPTE_ACHAT", "LIBELLEEXTACTE", "TVA", "FILEPATH", "RESTE", "TYPESTOCK", "REFPOST", "REFQUALIFICATION", "IDCHAMBRE", "ISPERISHABLE", "PV2", "IDMAGASIN", "PRIXUNITAIRE", "IDTYPECLIENT", "IDTYPECLIENTLIB", "IDUNITE", "IDUNITELIB", "POIDS", "QTE") AS
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
       ing."DATY",
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
WHERE ing.CATEGORIEINGREDIENT = 'CAT008' AND ing.actif=1;

CREATE OR REPLACE  VIEW AS_INGREDIENT_VENTE_LIB_PRX ("ID", "LIBELLE", "SEUIL", "UNITE", "QUANTITEPARPACK", "PU", "ACTIF", "PHOTO", "CALORIE", "DURRE", "COMPOSE", "CATEGORIEINGREDIENT", "IDFOURNISSEUR", "DATY", "QTELIMITE", "PV", "LIBELLEVENTE", "SEUILMIN", "SEUILMAX", "PUACHATUSD", "PUACHATEURO", "PUACHATAUTREDEVISE", "PUVENTEUSD", "PUVENTEEURO", "PUVENTEAUTREDEVISE", "ISVENTE", "ISACHAT", "COMPTE_VENTE", "COMPTE_ACHAT", "LIBELLEEXTACTE", "TVA", "FILEPATH", "RESTE", "TYPESTOCK", "REFPOST", "REFQUALIFICATION", "IDCHAMBRE", "ISPERISHABLE", "PV2", "IDMAGASIN", "PRIXUNITAIRE", "IDTYPECLIENT", "IDTYPECLIENTLIB", "IDUNITE", "IDUNITELIB", "POIDS", "QTE") AS
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
WHERE ing.CATEGORIEINGREDIENT = 'CAT008' AND ing.actif=1 ORDER BY daty DESC ;


CREATE OR REPLACE  VIEW COURSELIB ("ID", "IDVEHICULE", "IDCHAUFFEUR", "DATY", "REMARQUE", "ETAT", "ETATLIB", "IDVEHICULELIB", "IDCHAUFFEURLIB") AS
SELECT
    c.ID,
    c.IDVEHICULE,
    c.IDCHAUFFEUR,
    c.DATY,
    c.REMARQUE,
    c.ETAT,
    CASE
        WHEN c.ETAT = 1
            THEN 'CRÉÉE'
        WHEN c.ETAT = 0
            THEN 'ANNULÉE'
        WHEN c.ETAT = 7  THEN 'EN COURS DE LIVRAISON'
        WHEN c.ETAT = 11
            THEN 'TERMINÉE'
        END AS ETATLIB,
    v.LIBELLE AS IDVEHICULELIB,
    ch.NOM  AS IDCHAUFFEURLIB
FROM COURSE c
         LEFT JOIN AS_INGREDIENTS v ON v.id = c.IDVEHICULE
         LEFT JOIN AS_INGREDIENTS ai ON ai.id = v.ID
         LEFT JOIN CHAUFFEUR ch ON ch.ID = c.IDCHAUFFEUR;

CREATE OR REPLACE  VIEW MAGASINLIB ("ID", "VAL", "DESCE", "IDPOINT", "IDPOINTLIB", "IDTYPEMAGASIN", "IDTYPEMAGASINLIB", "IDPRODUIT", "IDPRODUITLIB","IDMAGASINMERELIB") AS
SELECT
    m.ID ,
    m.VAL ,
    m.DESCE ,
    m.IDPOINT ,
    p.VAL AS IDPOINTLIB,
    m.IDTYPEMAGASIN ,
    t.VAL AS IDTYPEMAGASINLIB,
    m.IDPRODUIT ,
    p2.LIBELLE AS IDPRODUITLIB,
    m2.val AS idmagasinmerelib
FROM MAGASIN2 m
         LEFT JOIN POINT p ON p.ID = m.IDPOINT
         LEFT JOIN TYPEMAGASIN t ON t.ID = m.IDTYPEMAGASIN
         LEFT JOIN AS_INGREDIENTS p2 ON p2.ID = m.IDPRODUIT
         LEFT JOIN MAGASIN2 m2 ON m2.id=m.idmagasinmere;